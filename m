Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2JOKB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 06:01:59 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 08/11] ath9k_hw: Configure new switch table for AR9565 BTCOEX
Date: Mon, 15 Oct 2012 15:29:52 +0530
Message-ID: <1350295195-23410-9-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_120204_705508_A89DC113)
In-Reply-To: <1350295195-23410-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350295195-23410-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 drivers/net/wireless/ath/ath9k/reg.h           | 4 ----
 drivers/net/wireless/ath/ath9k/wow.c           | 2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index f3784eb..52249e6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3601,7 +3601,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 	 *   7:4 R/W  SWITCH_TABLE_COM_SPDT_WLAN_IDLE
 	 * SWITCH_TABLE_COM_SPDT_WLAN_IDLE
 	 */
-	if (AR_SREV_9462_20_OR_LATER(ah)) {
+	if (AR_SREV_9462_20(ah) || AR_SREV_9565(ah)) {
 		value = ar9003_switch_com_spdt_get(ah, is2ghz);
 		REG_RMW_FIELD(ah, AR_PHY_GLB_CONTROL,
 				AR_SWITCH_TABLE_COM_SPDT_ALL, value);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 8f40dba..e9dec13 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -907,10 +907,6 @@
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
 	((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_20))
 
-#define AR_SREV_9462_20_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
-	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_20))
-
 #define AR_SREV_9565(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
 
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index a483d51..9f85630 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -118,7 +118,7 @@ static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
 		       (ap_mac_addr[1] << 8) | (ap_mac_addr[0]);
 	data_word[5] = (ap_mac_addr[5] << 8) | (ap_mac_addr[4]);
 
-	if (AR_SREV_9462_20_OR_LATER(ah)) {
+	if (AR_SREV_9462_20(ah)) {
 		/* AR9462 2.0 has an extra descriptor word (time based
 		 * discard) compared to other chips */
 		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + (12 * 4)), 0);
-- 
1.7.12.2

