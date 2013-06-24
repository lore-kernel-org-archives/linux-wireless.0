Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56600 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3FXMvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 08:51:52 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/4] ath9k: Program initvals for AR9462 2.1
Date: Mon, 24 Jun 2013 18:18:45 +0530
Message-Id: <1372078126-13602-3-git-send-email-sujith@msujith.org> (sfid-20130624_145157_892923_40B66E1B)
In-Reply-To: <1372078126-13602-1-git-send-email-sujith@msujith.org>
References: <1372078126-13602-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 59 +++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 671aaa7..3101c39 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -24,6 +24,7 @@
 #include "ar955x_1p0_initvals.h"
 #include "ar9580_1p0_initvals.h"
 #include "ar9462_2p0_initvals.h"
+#include "ar9462_2p1_initvals.h"
 #include "ar9565_1p0_initvals.h"
 
 /* General hardware code for the AR9003 hadware family */
@@ -197,6 +198,31 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
 				ar9485_1_1_pcie_phy_clkreq_disable_L1);
+	} else if (AR_SREV_9462_21(ah)) {
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+			       ar9462_2p1_mac_core);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+			       ar9462_2p1_mac_postamble);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+			       ar9462_2p1_baseband_core);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+			       ar9462_2p1_baseband_postamble);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+			       ar9462_2p1_radio_core);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+			       ar9462_2p1_radio_postamble);
+		INIT_INI_ARRAY(&ah->ini_radio_post_sys2ant,
+			       ar9462_2p1_radio_postamble_sys2ant);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+			       ar9462_2p1_soc_preamble);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
+			       ar9462_2p1_soc_postamble);
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       ar9462_2p1_common_rx_gain);
+		INIT_INI_ARRAY(&ah->iniModesFastClock,
+			       ar9462_2p1_modes_fast_clock);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+			       ar9462_2p1_baseband_core_txfir_coeff_japan_2484);
 	} else if (AR_SREV_9462_20(ah)) {
 
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE], ar9462_2p0_mac_core);
@@ -407,6 +433,9 @@ static void ar9003_tx_gain_table_mode0(struct ath_hw *ah)
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9580_1p0_lowest_ob_db_tx_gain_table);
+	else if (AR_SREV_9462_21(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9462_2p1_modes_low_ob_db_tx_gain);
 	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9462_modes_low_ob_db_tx_gain_table_2p0);
@@ -438,6 +467,9 @@ static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
 	else if (AR_SREV_9550(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar955x_1p0_modes_no_xpa_tx_gain_table);
+	else if (AR_SREV_9462_21(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9462_2p1_modes_high_ob_db_tx_gain);
 	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9462_modes_high_ob_db_tx_gain_table_2p0);
@@ -507,6 +539,9 @@ static void ar9003_tx_gain_table_mode4(struct ath_hw *ah)
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9580_1p0_mixed_ob_db_tx_gain_table);
+	else if (AR_SREV_9462_21(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		       ar9462_2p1_modes_mix_ob_db_tx_gain);
 	else
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9300Modes_mixed_ob_db_tx_gain_table_2p2);
@@ -584,6 +619,9 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 	} else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar9580_1p0_rx_gain_table);
+	else if (AR_SREV_9462_21(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9462_2p1_common_rx_gain);
 	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar9462_common_rx_gain_table_2p0);
@@ -606,6 +644,9 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 	else if (AR_SREV_9485_11(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9485Common_wo_xlna_rx_gain_1_1);
+	else if (AR_SREV_9462_21(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9462_2p1_common_wo_xlna_rx_gain);
 	else if (AR_SREV_9462_20(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9462_common_wo_xlna_rx_gain_table_2p0);
@@ -627,7 +668,16 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 
 static void ar9003_rx_gain_table_mode2(struct ath_hw *ah)
 {
-	if (AR_SREV_9462_20(ah)) {
+	if (AR_SREV_9462_21(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       ar9462_2p1_common_mixed_rx_gain);
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_bb_core,
+			       ar9462_2p1_baseband_core_mix_rxgain);
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_bb_postamble,
+			       ar9462_2p1_baseband_postamble_mix_rxgain);
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+			       ar9462_2p1_baseband_postamble_5g_xlna);
+	} else if (AR_SREV_9462_20(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       ar9462_common_mixed_rx_gain_table_2p0);
 		INIT_INI_ARRAY(&ah->ini_modes_rxgain_bb_core,
@@ -641,7 +691,12 @@ static void ar9003_rx_gain_table_mode2(struct ath_hw *ah)
 
 static void ar9003_rx_gain_table_mode3(struct ath_hw *ah)
 {
-	if (AR_SREV_9462_20(ah)) {
+	if (AR_SREV_9462_21(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       ar9462_2p1_common_5g_xlna_only_rx_gain);
+		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
+			       ar9462_2p1_baseband_postamble_5g_xlna);
+	} else if (AR_SREV_9462_20(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       ar9462_2p0_5g_xlna_only_rxgain);
 		INIT_INI_ARRAY(&ah->ini_modes_rxgain_5g_xlna,
-- 
1.8.3.1

