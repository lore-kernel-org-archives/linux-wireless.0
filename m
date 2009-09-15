Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:52371 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994AbZIOC0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 22:26:23 -0400
Received: by mail-ew0-f206.google.com with SMTP id 2so72646ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 19:26:26 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, mcgrof@gmail.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] compat-2.6: adding driver-select script support for rtl818x
Date: Tue, 15 Sep 2009 03:26:24 +0100
Message-Id: <1252981584-12586-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding driver-select script support for rtl818x

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---
 scripts/driver-select |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index e0d7305..dcb777c 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -44,6 +44,7 @@ function usage {
 	echo -e "\t${CYAN}ath${NORMAL} < ${PURPLE} ath5k ath9k ar9170 ${NORMAL}>"
 	echo -e "\t${CYAN}intel${NORMAL} < ${PURPLE} iwl3945 iwlagn ipw2100 ipw2200 ${NORMAL}>"
 	echo -e "\t${CYAN}iwlwifi${NORMAL} < ${PURPLE} iwl3945 iwlagn ${NORMAL}>"
+	echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
 	echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 (SPI and SDIO) wl1271 ${NORMAL}>"
 
 	echo -e "Restoring compat-wireless:"
@@ -127,6 +128,13 @@ function disable_var_01 {
 	disable_var
 }
 
+function disable_var_02 {
+	#var_01 with eeprom not disabled
+	disable_lib80211
+	disable_ssb
+	disable_usbnet
+}
+
 function select_ath_driver 
 {
 	backup_file $ATH_MAKEFILE
@@ -227,6 +235,10 @@ case $1 in
 		select_driver		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_AR9170_USB
 		;;
+	rtl818x)
+		select_drivers		CONFIG_RTL8180 CONFIG_RTL8187
+		disable_var_02
+		;;
 	zd1211rw)
 		select_driver		CONFIG_ZD1211RW
 		disable_var_01
-- 
1.6.2.5

