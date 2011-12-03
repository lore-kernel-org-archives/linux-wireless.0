Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50314 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1LCOq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 09:46:56 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/6] compat-wireless: fix driver-select for intel
Date: Sat,  3 Dec 2011 15:46:22 +0100
Message-Id: <1322923585-13966-3-git-send-email-hauke@hauke-m.de> (sfid-20111203_154700_494822_C264742E)
In-Reply-To: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
References: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlagn was renamed and iwlegacy was added

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/driver-select |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index 3619541..e74dc81 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -53,7 +53,7 @@ function usage {
 	echo -e "\t${CYAN}atheros${NORMAL} < ${PURPLE} ath5k ath9k carl9170 zd1211rw ath6kl ${NORMAL}>"
 	echo -e "\t${CYAN}ath${NORMAL} < ${PURPLE} ath5k ath9k carl9170 ath6kl ${NORMAL}>"
 	echo -e "\t${CYAN}brcm80211${NORMAL} < ${PURPLE} brcmsmac brcmfmac ${NORMAL}>"
-	echo -e "\t${CYAN}iwlagn${NORMAL} < ${PURPLE} iwlagn ${NORMAL}>"
+	echo -e "\t${CYAN}intel${NORMAL} < ${PURPLE} iwlwifi, iwlegacy ${NORMAL}>"
 	echo -e "\t${CYAN}rtl818x${NORMAL} < ${PURPLE} rtl8180 rtl8187 ${NORMAL}>"
 	echo -e "\t${CYAN}rtlwifi${NORMAL} < ${PURPLE} rtl8192ce ${NORMAL}>"
 	echo -e "\t${CYAN}wl12xx${NORMAL} < ${PURPLE} wl1251 wl12xx (SPI and SDIO)${NORMAL}>"
@@ -309,7 +309,8 @@ case $1 in
 		disable_var_01
 		;;
 	intel)
-		select_drivers		CONFIG_COMPAT_IWLWIFI \
+		select_drivers		CONFIG_IWLWIFI \
+					CONFIG_IWLEGACY \
 					CONFIG_IPW
 		disable_staging
 		disable_var
@@ -317,8 +318,16 @@ case $1 in
 		disable_ethernet
 		disable_usbnet
 		;;
-	iwlagn)
-		select_driver		CONFIG_IWLAGN
+	iwlwifi)
+		select_driver		CONFIG_IWLWIFI
+		disable_staging
+		disable_var_01
+		disable_bt
+		disable_ethernet
+		disable_usbnet
+		;;
+	iwlegacy)
+		select_driver		CONFIG_IWLEGACY
 		disable_staging
 		disable_var_01
 		disable_bt
-- 
1.7.5.4

