#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Default settings
DEFAULT_CONTAINER="nextcloud"
OCC_PATH="/var/www/html/occ"

echo -e "${CYAN}════════════════════════════════════════════"
echo -e "      Docker OCC Interactive Management"
echo -e "════════════════════════════════════════════${NC}"
echo ""

# Get container name
echo -ne "${YELLOW}Container name (default: ${DEFAULT_CONTAINER}): ${NC}"
read CONTAINER_INPUT
CONTAINER=${CONTAINER_INPUT:-$DEFAULT_CONTAINER}

echo -e "${GREEN}Selected container: ${CONTAINER}${NC}"
echo ""

# Run occ list at start
echo -e "${CYAN}Running initial command: occ list${NC}"
echo "--------------------------------------------"
docker exec -it ${CONTAINER} php ${OCC_PATH} list
echo "--------------------------------------------"
echo ""

echo -e "${CYAN}You can now type any OCC command.${NC}"
echo -e "${CYAN}Type 'quit' to exit.${NC}"
echo ""

# Interactive shell
while true; do
    echo -ne "${YELLOW}OCC> ${NC}"
    read OCC_CMD

    # Exit condition (only quit)
    if [[ "$OCC_CMD" == "quit" ]]; then
        echo -e "${RED}Exiting OCC Manager...${NC}"
        break
    fi

    # Skip empty commands
    if [[ -z "$OCC_CMD" ]]; then
        continue
    fi

    # Run the entered command
    echo -e "${CYAN}Running:${NC} php occ ${OCC_CMD}"
    echo "--------------------------------------------"
    docker exec -it ${CONTAINER} php ${OCC_PATH} ${OCC_CMD}
    echo "--------------------------------------------"
    echo -e "${YELLOW}Type 'quit' to exit.${NC}"
done
