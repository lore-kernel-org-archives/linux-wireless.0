Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40170 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab2GORxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 13:53:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 04/12] ath9k_hw: fix tx gain tables for AR934x
Date: Sun, 15 Jul 2012 19:53:32 +0200
Message-Id: <1342374820-92409-4-git-send-email-nbd@openwrt.org> (sfid-20120715_195358_828882_62A2DCDC)
In-Reply-To: <1342374820-92409-3-git-send-email-nbd@openwrt.org>
References: <1342374820-92409-1-git-send-email-nbd@openwrt.org>
 <1342374820-92409-2-git-send-email-nbd@openwrt.org>
 <1342374820-92409-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the EEPROM information to choose the right tx gain table

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   29 ++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 41e88c6..718241d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -561,8 +561,8 @@ static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
 			5);
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
-			ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+			ar9340Modes_high_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9340Modes_high_ob_db_tx_gain_table_1p0),
 			5);
 	else if (AR_SREV_9485_11(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
@@ -605,8 +605,8 @@ static void ar9003_tx_gain_table_mode2(struct ath_hw *ah)
 			5);
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
-			ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+			ar9340Modes_low_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9340Modes_low_ob_db_tx_gain_table_1p0),
 			5);
 	else if (AR_SREV_9485_11(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
@@ -639,8 +639,8 @@ static void ar9003_tx_gain_table_mode3(struct ath_hw *ah)
 			5);
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
-			ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+			ar9340Modes_high_power_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9340Modes_high_power_tx_gain_table_1p0),
 			5);
 	else if (AR_SREV_9485_11(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
@@ -659,6 +659,20 @@ static void ar9003_tx_gain_table_mode3(struct ath_hw *ah)
 			5);
 }
 
+static void ar9003_tx_gain_table_mode4(struct ath_hw *ah)
+{
+	if (AR_SREV_9340(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9340Modes_mixed_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9340Modes_mixed_ob_db_tx_gain_table_1p0),
+			5);
+	else if (AR_SREV_9580(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9580_1p0_mixed_ob_db_tx_gain_table,
+			ARRAY_SIZE(ar9580_1p0_mixed_ob_db_tx_gain_table),
+			5);
+}
+
 static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 {
 	switch (ar9003_hw_get_tx_gain_idx(ah)) {
@@ -675,6 +689,9 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 	case 3:
 		ar9003_tx_gain_table_mode3(ah);
 		break;
+	case 4:
+		ar9003_tx_gain_table_mode4(ah);
+		break;
 	}
 }
 
-- 
1.7.7.5 (Apple Git-26)

