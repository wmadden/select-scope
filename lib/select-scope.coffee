module.exports =
  activate: (state) ->
    atom.commands.add "atom-workspace", "select-scope:select-more", => @selectMore()

  selectMore: ->
    editor = atom.workspace.getActivePaneItem()
    scopes = editor?.getLastCursor()?.getScopeDescriptor()?.getScopesArray()

    return unless scopes # Give up if this happens, there may not be an open editor

    selectionRange = editor.getSelectedBufferRange()

    # Go outward from the innermost scope and select the first one that includes unselected text
    scopes = scopes.slice().reverse()

    for scope in scopes
      scopeRange = editor.bufferRangeForScopeAtCursor(scope)

      console.log("scopeRange", scopeRange)
      console.log("scopeRange", selectionRange)

      if containsRange(scopeRange, selectionRange) && !sameRange(scopeRange, selectionRange)
        editor.setSelectedBufferRange(scopeRange)
        return

# True if range1 contains range2
containsRange = (range1, range2) ->
  range1.start.row <= range2.start.row && range1.start.column <= range2.start.column &&
    range1.end.row >= range2.end.row && range1.end.column >= range2.end.column

# True if both ranges are exactly the same
sameRange = (range1, range2) ->
  range1.start.row == range2.start.row && range1.start.column == range2.start.column &&
    range1.end.row == range2.end.row && range1.end.column == range2.end.column
