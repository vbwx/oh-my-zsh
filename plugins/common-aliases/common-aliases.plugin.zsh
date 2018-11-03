# Advanced Aliases.
# Use with caution
#
alias add='awk "{s+=\$1} END {printf \"%.2f\n\", s}"'
alias view='vim -R --noplugin'
alias vi='vim --noplugin'
alias su='sudo -v'
alias _='sudo '
alias b='$BROWSER'
alias e='${VISUAL:-$EDITOR}'

if [[ $OSTYPE == darwin* ]]; then
  alias o='open'
  alias locate='mdfind'
elif [[ $OSTYPE == cygwin* ]]; then
  alias o='cygstart'
  alias pbcopy='tee > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
else
  alias o='xdg-open'
  if type -t xclip > /dev/null; then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif type -t xsel > /dev/null; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi
alias pbc='pbcopy'
alias pbp='pbpaste'

for cmd in start stop restart reboot reload halt; do
  alias $cmd=">&2 echo Call sudo $cmd."
done

alias ack='nocorrect ack'
alias cd='nocorrect cd'
alias gcc='nocorrect gcc'
alias ln='nocorrect ln'
alias rm='nocorrect rm'
alias bower='noglob bower'
alias fc='noglob fc'
alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias sftp='noglob sftp'

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'

alias zshrc='${=VISUAL:-EDITOR} ~/.zshrc' # Quick access to the ~/.zshrc file

alias grep='nocorrect grep --color'
alias sgrep='nocorrect grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# zsh is able to auto-do some kungfoo
# depends on the SUFFIX :)
if is-at-least 4.2.0; then
  # open browser on urls
  if [[ -n "$BROWSER" ]]; then
    _browser_fts=(htm html de org net com at cx nl se dk)
    for ft in $_browser_fts; do alias -s $ft="$BROWSER"; done
  fi

  # open plain text files
  _editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex md yaml yml xml css js)
  for ft in $_editor_fts; do alias -s $ft="$EDITOR"; done

  # open image files
  if [[ -n "$XIVIEWER" || -n "$VIEWER" ]]; then
    _image_fts=(jpg jpeg png gif mng tiff tif xpm)
    for ft in $_image_fts; do alias -s $ft="${XIVIEWER:-$VIEWER}"; done
  fi

  # open media files
  _media_fts=(ape avi flv m4a mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
  for ft in $_media_fts; do alias -s $ft="${PLAYER:-mplayer}"; done

  # open documents
  alias -s pdf="${VIEWER:-acroread}"
  alias -s ps="${VIEWER:-gv}"
  alias -s dvi=xdvi
  alias -s chm=xchm
  alias -s djvu=djview

  # list whats inside packed file
  alias -s zip="unzip -l"
  alias -s rar="unrar l"
  alias -s tar="tar tf"
  alias -s ace="unace l"
  alias -s gz="gzip -l"
  alias -s tgz="gzip -l"
  alias -s bz2="basename -s .bz2"
  alias -s Z="basename -s .Z"
fi

# Resource Usage
if (( $+commands[pydf] )); then
  alias df=pydf
else
  alias df='df -kh'
fi

alias du='du -kh'

if [[ "$OSTYPE" == (darwin*|*bsd*) ]]; then
  alias topc='top -o cpu'
  alias topm='top -o vsize'
else
  alias topc='top -o %CPU'
  alias topm='top -o %MEM'
fi

# Serves a directory via HTTP.
if (( $+commands[python3] )); then
  alias http-serve='python3 -m http.server'
else
  alias http-serve='python -m SimpleHTTPServer'
fi

# Makes a directory and changes to it.
function mkdcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Changes to a directory and lists its contents.
function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pushes an entry onto the directory stack and lists its contents.
function pushdls {
  builtin pushd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pops an entry off the directory stack and lists its contents.
function popdls {
  builtin popd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Prints columns 1 2 3 ... n.
function slit {
  awk "{ print ${(j:,:):-\$${^@}} }"
}

# Finds files and executes a command on them.
function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Displays user owned processes status.
function psu {
  ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
