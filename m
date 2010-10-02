Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56802.mail.re3.yahoo.com ([66.196.97.76]:39387 "HELO
	web56802.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750762Ab0JBQzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 12:55:52 -0400
Message-ID: <698964.46316.qm@web56802.mail.re3.yahoo.com>
Date: Sat, 2 Oct 2010 09:55:51 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH] compat-wireless: introduce driver-select group for atlxx
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1284325760-929-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this patch:
- fixed a description typo
- changed yellow to purple color in bash as it hurts the eye/hard to read in white background (gnome)
- placed "atl1 atl2 atl1e atl1c" on one line to preserve user space and visibility, this is after all a _wireless_ compat
- introduced "atlxx" group for atlx(x) Ethernet devices in "BLUE" for distinguishability
- sorted all module groups together

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -1,7 +1,7 @@
 #!/bin/bash
 # Copyright 2009        Luis R. Rodriguez <mcgrof@gmail.com>
 #
-# This this to select your compat-wireless driver and
+# This script allows you to select your compat-wireless driver and
 # reduce compilation time.
 
 DRIVERS_MAKEFILE="drivers/net/wireless/Makefile"
@@ -42,7 +42,7 @@ fi
 
 # b43 needs some more work for driver-select, the SSB stuff, plus
 # what if you update b44 but not b43? It will bust.
-SUPPORTED_ETH_DRIVERS="atl1 atl2 atl1e atl1c"
+SUPPORTED_ETH_DRIVERS=""
 
 function usage {
 	echo -e "${GREEN}Usage${NORMAL}: ${CYAN}$0${NORMAL} [ ${PURPLE}<driver-name>${NORMAL} | ${PURPLE}<driver-group-name>${NORMAL} | ${GREEN}restore${NORMAL} ]"
@@ -53,7 +53,7 @@ function usage {
 		echo -e "\t${PURPLE}${i}${NORMAL}"
 	done
 
-	echo -e "\nSupported Ethernet drivers:"
+	echo -e "\nSupported Ethernet drivers: < ${PURPLE}atl1 atl2 atl1e atl1c${NORMAL} >"
 	for i in $SUPPORTED_ETH_DRIVERS; do
 		echo -e "\t${PURPLE}${i}${NORMAL}"
 	done
@@ -66,6 +66,8 @@ function usage {
 	echo -e "\t${CYAN}iwlwifi${NORMAL} < ${PURPLE} iwl3945 iwlagn ${NORMAL}>"
 	echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
 	echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 (SPI and SDIO) wl1271 ${NORMAL}>"
+	
+	echo -e "\t${BLUE}atlxx${NORMAL} < ${PURPLE} atl1 atl2 atl1e atl1c ${NORMAL}>"
 
 	echo -e "Restoring compat-wireless:"
 	echo -e "\t${GREEN}restore${NORMAL}: you can use this option to restore compat-wireless to the original state"
@@ -265,7 +267,7 @@ fi
 
 if [[ ! -f built-in.o ]]; then
 	if [[ "$1" != "restore" ]]; then
-		echo -e "${YELLOW}Processing new driver-select request...${NORMAL}"
+		echo -e "${PURPLE}Processing new driver-select request...${NORMAL}"
 	fi
 fi
 
@@ -279,9 +281,9 @@ fi
 # we'll be trying to leave drivers on Makefiles which are not
 # already there from a previous run.
 if [ -f built-in.o ]; then
-	echo -e "${YELLOW}Old build found, going to clean this up first...${NORMAL}"
+	echo -e "${PURPLE}Old build found, going to clean this up first...${NORMAL}"
 	make clean
-	echo -e "${YELLOW}Restoring Makefiles...${NORMAL}"
+	echo -e "${PURPLE}Restoring Makefiles...${NORMAL}"
 	./$0 restore
 fi
 
@@ -289,6 +291,7 @@ case $1 in
 	restore)
 		restore_compat
 		;;
+# Group drivers
 	atheros)
 		select_drivers		CONFIG_ATH_COMMON \
 					CONFIG_ZD1211RW
@@ -316,6 +319,12 @@ case $1 in
 		disable_staging
 		disable_var_01
 		;;
+	rtl818x)
+		select_drivers		CONFIG_RTL8180 CONFIG_RTL8187
+		disable_staging
+		disable_var_02
+		;;
+# Singular modules
 	ath5k)
 		disable_staging
 		disable_bt_usb_ethernet_var
@@ -353,11 +362,6 @@ case $1 in
 		disable_ath6kl
 		select_driver		CONFIG_NOTHING
 		;;
-	rtl818x)
-		select_drivers		CONFIG_RTL8180 CONFIG_RTL8187
-		disable_staging
-		disable_var_02
-		;;
 	zd1211rw)
 		select_driver		CONFIG_ZD1211RW
 		disable_staging
@@ -375,6 +379,7 @@ case $1 in
 		disable_staging
 		disable_var_02
 		;;
+# Ethernet drivers
 	atl1)
 		enable_only_ethernet
 		echo -e "obj-\$(CONFIG_ATL1) += atlx/" > $DRIVERS_NET
@@ -391,6 +396,11 @@ case $1 in
 		enable_only_ethernet
 		echo -e "obj-\$(CONFIG_ATL1C) += atl1c/" > $DRIVERS_NET
 		;;
+	atlxx)
+		select_drivers		CONFIG_ATL1 CONFIG_ATL2 CONFIG_ATL1E CONFIG_ATL1C
+		enable_only_ethernet
+		disable_b44
+		;;
 	*)
 		echo "Unsupported driver"
 		exit



      
