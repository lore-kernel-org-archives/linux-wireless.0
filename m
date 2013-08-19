Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50645 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3HSFh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 01:37:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Add support for AR9485 1.2
Date: Mon, 19 Aug 2013 11:03:43 +0530
Message-Id: <1376890423-12480-1-git-send-email-sujith@msujith.org> (sfid-20130819_073737_592541_B38533BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c  | 18 +++++++++---------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  2 +-
 drivers/net/wireless/ath/ath9k/reg.h        |  6 +++---
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index d402cb3..738aa7e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -153,7 +153,7 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		if (!ah->is_clk_25mhz)
 			INIT_INI_ARRAY(&ah->iniAdditional,
 				       ar9340_1p0_radio_core_40M);
-	} else if (AR_SREV_9485_11(ah)) {
+	} else if (AR_SREV_9485_11_OR_LATER(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
 				ar9485_1_1_mac_core);
@@ -424,7 +424,7 @@ static void ar9003_tx_gain_table_mode0(struct ath_hw *ah)
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9340Modes_lowest_ob_db_tx_gain_table_1p0);
-	else if (AR_SREV_9485_11(ah))
+	else if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9485_modes_lowest_ob_db_tx_gain_1_1);
 	else if (AR_SREV_9550(ah))
@@ -458,7 +458,7 @@ static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9340Modes_high_ob_db_tx_gain_table_1p0);
-	else if (AR_SREV_9485_11(ah))
+	else if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9485Modes_high_ob_db_tx_gain_1_1);
 	else if (AR_SREV_9580(ah))
@@ -492,7 +492,7 @@ static void ar9003_tx_gain_table_mode2(struct ath_hw *ah)
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9340Modes_low_ob_db_tx_gain_table_1p0);
-	else if (AR_SREV_9485_11(ah))
+	else if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9485Modes_low_ob_db_tx_gain_1_1);
 	else if (AR_SREV_9580(ah))
@@ -517,7 +517,7 @@ static void ar9003_tx_gain_table_mode3(struct ath_hw *ah)
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9340Modes_high_power_tx_gain_table_1p0);
-	else if (AR_SREV_9485_11(ah))
+	else if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9485Modes_high_power_tx_gain_1_1);
 	else if (AR_SREV_9580(ah))
@@ -552,7 +552,7 @@ static void ar9003_tx_gain_table_mode4(struct ath_hw *ah)
 
 static void ar9003_tx_gain_table_mode5(struct ath_hw *ah)
 {
-	if (AR_SREV_9485_11(ah))
+	if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9485Modes_green_ob_db_tx_gain_1_1);
 	else if (AR_SREV_9340(ah))
@@ -571,7 +571,7 @@ static void ar9003_tx_gain_table_mode6(struct ath_hw *ah)
 	if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9340Modes_low_ob_db_and_spur_tx_gain_table_1p0);
-	else if (AR_SREV_9485_11(ah))
+	else if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9485Modes_green_spur_ob_db_tx_gain_1_1);
 	else if (AR_SREV_9580(ah))
@@ -611,7 +611,7 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar9340Common_rx_gain_table_1p0);
-	else if (AR_SREV_9485_11(ah))
+	else if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       ar9485_common_rx_gain_1_1);
 	else if (AR_SREV_9550(ah)) {
@@ -644,7 +644,7 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 	else if (AR_SREV_9340(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9340Common_wo_xlna_rx_gain_table_1p0);
-	else if (AR_SREV_9485_11(ah))
+	else if (AR_SREV_9485_11_OR_LATER(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9485Common_wo_xlna_rx_gain_1_1);
 	else if (AR_SREV_9462_21(ah))
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 18a5aa4..46b910a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1449,7 +1449,7 @@ static void ar9003_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 	regval |= (ant_div_ctl1 & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 
-	if (AR_SREV_9485_11(ah)) {
+	if (AR_SREV_9485_11_OR_LATER(ah)) {
 		/*
 		 * Enable LNA diversity.
 		 */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 5af9744..a13b2d1 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -893,9 +893,9 @@
 
 #define AR_SREV_9485(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485))
-#define AR_SREV_9485_11(_ah) \
-	(AR_SREV_9485(_ah) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9485_11))
+#define AR_SREV_9485_11_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485) && \
+	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9485_11))
 #define AR_SREV_9485_OR_LATER(_ah) \
 	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9485))
 
-- 
1.8.3.4

