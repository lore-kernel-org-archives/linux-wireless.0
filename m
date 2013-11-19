Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37174 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3KSHEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 02:04:15 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: Attach INI arrays for AR9565 v1.1
Date: Tue, 19 Nov 2013 12:29:35 +0530
Message-Id: <1384844375-6347-4-git-send-email-sujith@msujith.org> (sfid-20131119_080418_701762_D18FB93B)
In-Reply-To: <1384844375-6347-1-git-send-email-sujith@msujith.org>
References: <1384844375-6347-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 54 ++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 33f63dc..568f313 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -26,6 +26,7 @@
 #include "ar9462_2p0_initvals.h"
 #include "ar9462_2p1_initvals.h"
 #include "ar9565_1p0_initvals.h"
+#include "ar9565_1p1_initvals.h"
 
 /* General hardware code for the AR9003 hadware family */
 
@@ -335,6 +336,41 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar9580_1p0_modes_fast_clock);
+	} else if (AR_SREV_9565_11_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+			       ar9565_1p1_mac_core);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+			       ar9565_1p1_mac_postamble);
+
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+			       ar9565_1p1_baseband_core);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+			       ar9565_1p1_baseband_postamble);
+
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+			       ar9565_1p1_radio_core);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+			       ar9565_1p1_radio_postamble);
+
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+			       ar9565_1p1_soc_preamble);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
+			       ar9565_1p1_soc_postamble);
+
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       ar9565_1p1_Common_rx_gain_table);
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9565_1p1_Modes_lowest_ob_db_tx_gain_table);
+
+		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			       ar9565_1p1_pciephy_clkreq_disable_L1);
+		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+			       ar9565_1p1_pciephy_clkreq_disable_L1);
+
+		INIT_INI_ARRAY(&ah->iniModesFastClock,
+				ar9565_1p1_modes_fast_clock);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+			       ar9565_1p1_baseband_core_txfir_coeff_japan_2484);
 	} else if (AR_SREV_9565(ah)) {
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
 			       ar9565_1p0_mac_core);
@@ -445,6 +481,9 @@ static void ar9003_tx_gain_table_mode0(struct ath_hw *ah)
 	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9462_modes_low_ob_db_tx_gain_table_2p0);
+	else if (AR_SREV_9565_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9565_1p1_modes_low_ob_db_tx_gain_table);
 	else if (AR_SREV_9565(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			       ar9565_1p0_modes_low_ob_db_tx_gain_table);
@@ -479,6 +518,9 @@ static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
 	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9462_modes_high_ob_db_tx_gain_table_2p0);
+	else if (AR_SREV_9565_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9565_1p1_modes_high_ob_db_tx_gain_table);
 	else if (AR_SREV_9565(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			       ar9565_1p0_modes_high_ob_db_tx_gain_table);
@@ -504,6 +546,9 @@ static void ar9003_tx_gain_table_mode2(struct ath_hw *ah)
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9580_1p0_low_ob_db_tx_gain_table);
+	else if (AR_SREV_9565_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9565_1p1_modes_low_ob_db_tx_gain_table);
 	else if (AR_SREV_9565(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			       ar9565_1p0_modes_low_ob_db_tx_gain_table);
@@ -529,6 +574,9 @@ static void ar9003_tx_gain_table_mode3(struct ath_hw *ah)
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9580_1p0_high_power_tx_gain_table);
+	else if (AR_SREV_9565_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       ar9565_1p1_modes_high_power_tx_gain_table);
 	else if (AR_SREV_9565(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			       ar9565_1p0_modes_high_power_tx_gain_table);
@@ -642,6 +690,9 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar9462_common_rx_gain_table_2p0);
+	else if (AR_SREV_9565_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       ar9565_1p1_Common_rx_gain_table);
 	else if (AR_SREV_9565(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       ar9565_1p0_Common_rx_gain_table);
@@ -678,6 +729,9 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 	} else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9580_1p0_wo_xlna_rx_gain_table);
+	else if (AR_SREV_9565_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       ar9565_1p1_common_wo_xlna_rx_gain_table);
 	else if (AR_SREV_9565(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       ar9565_1p0_common_wo_xlna_rx_gain_table);
-- 
1.8.4.2

