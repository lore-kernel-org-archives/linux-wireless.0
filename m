Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16.bullet.mail.sp2.yahoo.com ([98.139.91.86]:20744 "HELO
	nm16.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751480Ab2HBFog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 01:44:36 -0400
Date: Wed, 1 Aug 2012 22:44:32 -0700
From: Steven Luo <steven@steven676.net>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH 1/2] compat-wireless: driver-select: refactor
 select_drivers and eliminate redundant select_driver
Message-ID: <ab6d95605ad827f0c7f973d47656a897ffe17fb7.1343885909.git.steven@steven676.net> (sfid-20120802_074441_987859_4751C308)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two functions are functionally identical when passed one argument,
and we'd also like to have the ability to modify Makefiles other than
drivers/net/wireless/Makefile the same way.  Introduce a
select_drivers_from_makefile which takes a Makefile argument, and
implement select_drivers using it.  Convert existing users of
select_driver to select_drivers, and remove the redundant function.

Signed-off-by: Steven Luo <steven@steven676.net>
---
 scripts/driver-select |   47 ++++++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index 35e0eaf..48a43b7 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -88,15 +88,11 @@ function disable_makefile
 	echo > $1
 }
 
-function select_driver 
+function select_drivers_from_makefile
 {
-	backup_file $DRIVERS_MAKEFILE
-	perl -i -ne 'print if /'$1'\)/ ' $DRIVERS_MAKEFILE
-}
-
-function select_drivers
-{
-	backup_file $DRIVERS_MAKEFILE
+	MAKEFILE="$1"
+	shift
+	backup_file $MAKEFILE
 	CONFIGS=""
 	COUNT=0
 	for i in $@; do
@@ -106,8 +102,13 @@ function select_drivers
 			CONFIGS="${CONFIGS}|$i"
 		fi
 	done
-	egrep "$CONFIGS" $DRIVERS_MAKEFILE > ${DRIVERS_MAKEFILE}.tmp
-	mv ${DRIVERS_MAKEFILE}.tmp ${DRIVERS_MAKEFILE}
+	egrep "$CONFIGS" $MAKEFILE > ${MAKEFILE}.tmp
+	mv ${MAKEFILE}.tmp ${MAKEFILE}
+}
+
+function select_drivers
+{
+	select_drivers_from_makefile $DRIVERS_MAKEFILE $@
 }
 
 function disable_lib80211
@@ -333,7 +334,7 @@ case $1 in
 		disable_usbnet
 		;;
 	iwlwifi)
-		select_driver		CONFIG_IWLWIFI
+		select_drivers		CONFIG_IWLWIFI
 		disable_staging
 		disable_var_01
 		disable_bt
@@ -341,7 +342,7 @@ case $1 in
 		disable_usbnet
 		;;
 	iwlegacy)
-		select_driver		CONFIG_IWLEGACY
+		select_drivers		CONFIG_IWLEGACY
 		disable_staging
 		disable_var_01
 		disable_bt
@@ -379,44 +380,44 @@ case $1 in
 	ath5k)
 		disable_staging
 		disable_bt_usb_ethernet_var
-		select_driver		CONFIG_ATH_COMMON
+		select_drivers		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_ATH5K
 		#patch -p1 < enable-older-kernels/enable-2.6.23.patch
 		;;
 	ath9k)
 		disable_staging
 		disable_bt_usb_ethernet_var
-		select_driver		CONFIG_ATH_COMMON
+		select_drivers		CONFIG_ATH_COMMON
 		select_ath9k_driver
 		;;
 	ath9k_ap)
 		disable_staging
 		disable_bt_usb_ethernet_var
-		select_driver		CONFIG_ATH_COMMON
+		select_drivers		CONFIG_ATH_COMMON
 		select_ath9k_driver_ap
 		;;
 	carl9170)
 		disable_staging
 		disable_bt_usb_ethernet_var
-		select_driver		CONFIG_ATH_COMMON
+		select_drivers		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_CARL9170
 		;;
 	ath9k_htc)
 		disable_staging
 		disable_bt_usb_ethernet_var
-		select_driver		CONFIG_ATH_COMMON
+		select_drivers		CONFIG_ATH_COMMON
 		select_ath9k_driver
 		;;
 	ath6kl)
 		disable_staging
 		disable_bt_usb_ethernet_var
-		select_driver		CONFIG_ATH_COMMON
+		select_drivers		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_ATH6KL
 		;;
 	wil6210)
 		disable_staging
 		disable_bt_usb_ethernet_var
-		select_driver		CONFIG_ATH_COMMON
+		select_drivers		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_WIL6210
 		;;
 	brcmsmac)
@@ -432,7 +433,7 @@ case $1 in
 		select_brcm80211_driver	CONFIG_BRCMFMAC CONFIG_BRCMUTIL
 		;;
 	zd1211rw)
-		select_driver		CONFIG_COMPAT_ZD1211RW
+		select_drivers		CONFIG_COMPAT_ZD1211RW
 		disable_staging
 		disable_var_01
 		;;
@@ -441,10 +442,10 @@ case $1 in
 		disable_bt_usb_ethernet
 		disable_eeprom
 		disable_lib80211
-		select_driver		CONFIG_B43
+		select_drivers		CONFIG_B43
 		;;
 	rt2x00)
-		select_driver		CONFIG_RT2X00
+		select_drivers		CONFIG_RT2X00
 		disable_staging
 		disable_bt_usb_ethernet
 		disable_var_02
@@ -492,7 +493,7 @@ case $1 in
 		disable_update-initramfs
 		;;
 	bt)
-		select_driver 		CONFIG_BT
+		select_drivers 		CONFIG_BT
 		disable_var
 		disable_ethernet
 		disable_staging
-- 
1.7.2.5

