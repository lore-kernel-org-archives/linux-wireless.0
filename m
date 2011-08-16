Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41793 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab1HPNYw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 09:24:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: add many fixes to driver-select
Date: Tue, 16 Aug 2011 15:24:42 +0200
Message-Id: <1313501082-10786-2-git-send-email-hauke@hauke-m.de> (sfid-20110816_152458_708202_7727858A)
In-Reply-To: <1313501082-10786-1-git-send-email-hauke@hauke-m.de>
References: <1313501082-10786-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

after driver-select was used it built often not needed modules. This is
now fixed for most options. Most of these problems where introduced
while a new driver was added to compat-wireless, but driver-select was
not updated.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile              |    8 ++++-
 scripts/driver-select |   67 +++++++++++++++++++++++++++----------------------
 2 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/Makefile b/Makefile
index b6d7079..6fe77b8 100644
--- a/Makefile
+++ b/Makefile
@@ -29,8 +29,12 @@ obj-$(CONFIG_COMPAT_WIRELESS_MODULES) += drivers/net/wireless/
 
 obj-$(CONFIG_COMPAT_NET_USB_MODULES) += drivers/net/usb/
 
-obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/ethernet/broadcom/ drivers/net/ethernet/atheros/
-obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/ssb/ drivers/bcma/ drivers/misc/eeprom/
+obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/ethernet/atheros/
+obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/ethernet/broadcom/
+
+obj-$(CONFIG_COMPAT_VAR_MODULES) += drivers/ssb/
+obj-$(CONFIG_COMPAT_VAR_MODULES) += drivers/bcma/
+obj-$(CONFIG_COMPAT_VAR_MODULES) += drivers/misc/eeprom/
 
 ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
 obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/brcm80211/
diff --git a/scripts/driver-select b/scripts/driver-select
index 208f618..3558112 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -14,6 +14,7 @@ DRIVERS_NET_ATHEROS="drivers/net/ethernet/atheros/Makefile"
 DRIVERS_NET_BROADCOM="drivers/net/ethernet/broadcom/Makefile"
 DRIVERS_NET_USB_MAKEFILE="drivers/net/usb/Makefile"
 SSB_MAKEFILE="drivers/ssb/Makefile"
+BCMA_MAKEFILE="drivers/bcma/Makefile"
 
 # used to backup files from foo to foo.${BACKUP_EXT}
 # If you change this also modify restore_compat() and
@@ -31,11 +32,7 @@ PURPLE="\033[35m"
 CYAN="\033[36m"
 UNDERLINE="\033[02m"
 
-SUPPORTED_80211_DRIVERS="ath5k ath9k ath9k_htc carl9170 b43 zd1211rw rt2x00 wl1251 wl12xx"
-
-if [ -d drivers/staging/ath6kl ]; then
-	SUPPORTED_80211_DRIVERS="$SUPPORTED_80211_DRIVERS ath6kl"
-fi
+SUPPORTED_80211_DRIVERS="ath5k ath9k ath9k_htc carl9170 ath6kl b43 zd1211rw rt2x00 wl1251 wl12xx"
 
 if [ -d drivers/staging/brcm80211 ]; then
 	SUPPORTED_80211_DRIVERS="$SUPPORTED_80211_DRIVERS brcm80211"
@@ -56,8 +53,8 @@ function usage {
 
 	# These should match the switch below.
 	echo -e "\nSupported group drivers:"
-	echo -e "\t${CYAN}atheros${NORMAL} < ${PURPLE} ath5k ath9k carl9170 zd1211rw ${NORMAL}>"
-	echo -e "\t${CYAN}ath${NORMAL} < ${PURPLE} ath5k ath9k carl9170 ${NORMAL}>"
+	echo -e "\t${CYAN}atheros${NORMAL} < ${PURPLE} ath5k ath9k carl9170 zd1211rw ath6kl ${NORMAL}>"
+	echo -e "\t${CYAN}ath${NORMAL} < ${PURPLE} ath5k ath9k carl9170 ath6kl ${NORMAL}>"
 	echo -e "\t${CYAN}iwlagn${NORMAL} < ${PURPLE} iwlagn ${NORMAL}>"
 	echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
 	echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192ce ${NORMAL}>"
@@ -121,9 +118,14 @@ function disable_b44 {
 
 function disable_ssb
 {
-	disable_b44
 	disable_makefile ${SSB_MAKEFILE}
-	perl -i -ne 'print if ! /drivers\/ssb\/ \\/ ' Makefile
+	perl -i -ne 'print if ! /drivers\/ssb\//' Makefile
+}
+
+function disable_bcma
+{
+	disable_makefile ${BCMA_MAKEFILE}
+	perl -i -ne 'print if ! /drivers\/bcma\//' Makefile
 }
 
 function disable_rfkill
@@ -135,13 +137,13 @@ function disable_rfkill
 function disable_eeprom
 {
 	disable_makefile ${EEPROM_MAKEFILE}
-	perl -i -ne 'print if ! /drivers\/misc\/eeprom\/ \\/' Makefile
+	perl -i -ne 'print if ! /drivers\/misc\/eeprom\//' Makefile
 }
 
 function disable_usbnet
 {
 	disable_makefile ${DRIVERS_NET_USB_MAKEFILE}
-	perl -i -ne 'print if ! /drivers\/net\/usb\/ \\/' Makefile
+	perl -i -ne 'print if ! /drivers\/net\/usb\//' Makefile
 }
 
 function disable_usbnet {
@@ -153,11 +155,10 @@ function disable_ethernet {
 } 
 
 function disable_var_03 {
-	perl -i -ne 'print if ! /CONFIG_COMPAT_BLUETOOTH/' Makefile
+	perl -i -ne 'print if ! /CONFIG_COMPAT_VAR_MODULES/' Makefile
 } 
 
 function disable_bt {
-	perl -i -ne 'print if ! /CONFIG_COMPAT_VAR_MODULES/' Makefile
 	perl -i -ne 'print if ! /CONFIG_COMPAT_BLUETOOTH/' Makefile
 } 
 
@@ -165,14 +166,19 @@ function disable_80211 {
 	perl -i -ne 'print if ! /CONFIG_COMPAT_WIRELESS/' Makefile
 }
 
-function disable_bt_usb_ethernet_var {
+function disable_bt_usb_ethernet {
 	backup_file Makefile
 	disable_usbnet
 	disable_ethernet
-	disable_var_03
 	disable_bt
 	disable_update-initramfs
-} 
+}
+
+function disable_bt_usb_ethernet_var {
+	backup_file Makefile
+	disable_bt_usb_ethernet
+	disable_var_03
+}
 
 function enable_only_ethernet {
 	backup_file Makefile
@@ -189,6 +195,7 @@ function enable_only_ethernet {
 
 function disable_var {
 	disable_ssb
+	disable_bcma
 	disable_usbnet
 	disable_eeprom
 	disable_update-initramfs
@@ -203,6 +210,7 @@ function disable_var_02 {
 	#var_01 with eeprom not disabled
 	disable_lib80211
 	disable_ssb
+	disable_bcma
 	disable_usbnet
 	disable_update-initramfs
 }
@@ -212,11 +220,6 @@ function disable_staging {
 	perl -i -ne 'print if ! /CONFIG_COMPAT_STAGING/ ' Makefile
 }
 
-function disable_ath6kl {
-	backup_file Makefile
-	perl -i -ne 'print if ! /ath6kl/ ' Makefile
-}
-
 function disable_brcm80211 {
 	backup_file Makefile
 	perl -i -ne 'print if ! /brcm80211/ ' Makefile
@@ -298,6 +301,7 @@ case $1 in
 		select_drivers		CONFIG_ATH_COMMON \
 					CONFIG_COMPAT_ZD1211RW
 		disable_staging
+		disable_bt_usb_ethernet_var
 		disable_var_01
 		;;
 	ath)
@@ -326,12 +330,16 @@ case $1 in
 	rtl818x)
 		select_drivers		CONFIG_RTL8180 CONFIG_RTL8187
 		disable_staging
-		disable_var_02
+		disable_bt_usb_ethernet
+		disable_ssb
+		disable_bcma
+		disable_lib80211
 		;;
 	rtlwifi)
 		select_drivers		CONFIG_RTL8192CE CONFIG_RTLWIFI
 		disable_staging
 		disable_bt_usb_ethernet_var
+		disable_lib80211
 		;;
 	wl12xx)
 		select_drivers		CONFIG_WL1251 \
@@ -366,15 +374,13 @@ case $1 in
 		select_ath9k_driver
 		;;
 	ath6kl)
+		disable_staging
 		disable_bt_usb_ethernet_var
-		disable_brcm80211
-		select_driver		CONFIG_NOTHING
-		sed -e 's|net/mac80211/||' Makefile > Makefile.ath6kl
-		mv Makefile.ath6kl Makefile
+		select_driver		CONFIG_ATH_COMMON
+		select_ath_driver	CONFIG_ATH6KL
 		;;
 	brcm80211)
 		disable_bt_usb_ethernet_var
-		disable_ath6kl
 		select_driver		CONFIG_NOTHING
 		;;
 	zd1211rw)
@@ -384,14 +390,15 @@ case $1 in
 		;;
 	b43)
 		disable_staging
-		disable_usbnet
-		disable_ethernet
-		disable_var_03
+		disable_bt_usb_ethernet
+		disable_eeprom
+		disable_lib80211
 		select_driver		CONFIG_B43
 		;;
 	rt2x00)
 		select_driver		CONFIG_RT2X00
 		disable_staging
+		disable_bt_usb_ethernet
 		disable_var_02
 		;;
 	wl1251)
-- 
1.7.4.1

