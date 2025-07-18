#!/bin/bash

# Text styles
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

function loading_animation() {
  echo -n "⏳ $1"
  spin='-\|/'
  i=0
  while kill -0 "$2" 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r⏳ $1 ${spin:$i:1}"
    sleep 0.1
  done
  echo -e "\r✅ $1 done!       "
}

function show_menu() {
  clear
  echo -e "${CYAN}🚀 Website Starter Menu${NC}"
  echo "--------------------------"
  echo "1) React (Vite)"
  echo "2) Vue (Vite)"
  echo "3) Next.js"
  echo "4) Astro"
  echo "5) SvelteKit"
  echo "6) Quit"
  echo "--------------------------"
}

while true; do
  show_menu
  read -p "Choose a framework (1-6): " choice

  case $choice in
    1) framework="React (Vite)"; cmd="yarn create vite {name} --template react" ;;
    2) framework="Vue (Vite)"; cmd="yarn create vite {name} --template vue" ;;
    3) framework="Next.js"; cmd="yarn create next-app {name}" ;;
    4) framework="Astro"; cmd="yarn create astro {name}" ;;
    5) framework="SvelteKit"; cmd="yarn create svelte {name}" ;;
    6)
      echo -e "${YELLOW}👋 Goodbye!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}❌ Invalid choice. Please try again.${NC}"
      sleep 1.5
      continue
      ;;
  esac

  read -p "Enter project name: " project_name
  if [[ -z "$project_name" ]]; then
    echo -e "${RED}❌ Project name cannot be empty.${NC}"
    sleep 1.5
    continue
  fi

  full_cmd=${cmd/\{name\}/$project_name}

  echo -e "\n🛠 Creating ${YELLOW}${framework}${NC} project: ${CYAN}${project_name}${NC}..."

  eval "$full_cmd" &
  loading_animation "Scaffolding..." $!

  cd "$project_name" || { echo -e "${RED}❌ Failed to cd into project folder.${NC}"; exit 1; }

  echo -e "\n📦 Installing dependencies..."
  yarn &> /dev/null &
  loading_animation "Installing dependencies..." $!

  read -p "🚀 Start dev server now? (y/n): " start_now
  if [[ "$start_now" =~ ^[Yy]$ ]]; then
    echo -e "\n🌍 Starting development server..."
    yarn dev
  else
    echo -e "${GREEN}✅ Done! Run 'cd $project_name && yarn dev' when ready.${NC}"
  fi

  break
done

