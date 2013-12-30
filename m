Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56820 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3L3EVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Dec 2013 23:21:44 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: Initialize QCA953x INI arrays
Date: Mon, 30 Dec 2013 09:46:36 +0530
Message-Id: <1388376996-614-5-git-send-email-sujith@msujith.org> (sfid-20131230_052152_067384_6DAD5D1D)
In-Reply-To: <1388376996-614-1-git-send-email-sujith@msujith.org>
References: <1388376996-614-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 48 +++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index f3c4102..ec1da0c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -28,6 +28,7 @@
 #include "ar9462_2p1_initvals.h"
 #include "ar9565_1p0_initvals.h"
 #include "ar9565_1p1_initvals.h"
+#include "ar953x_initvals.h"
 
 /* General hardware code for the AR9003 hadware family */
 
@@ -308,6 +309,31 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		/* Fast clock modal settings */
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
 				ar955x_1p0_modes_fast_clock);
+	} else if (AR_SREV_9531(ah)) {
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+			       qca953x_1p0_mac_core);
+		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+			       qca953x_1p0_mac_postamble);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+			       qca953x_1p0_baseband_core);
+		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+			       qca953x_1p0_baseband_postamble);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+			       qca953x_1p0_radio_core);
+		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+			       qca953x_1p0_radio_postamble);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+			       qca953x_1p0_soc_preamble);
+		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
+			       qca953x_1p0_soc_postamble);
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       qca953x_1p0_common_wo_xlna_rx_gain_table);
+		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
+			       qca953x_1p0_common_wo_xlna_rx_gain_bounds);
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       qca953x_1p0_modes_no_xpa_tx_gain_table);
+		INIT_INI_ARRAY(&ah->iniModesFastClock,
+			       qca953x_1p0_modes_fast_clock);
 	} else if (AR_SREV_9580(ah)) {
 		/* mac */
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
@@ -485,6 +511,9 @@ static void ar9003_tx_gain_table_mode0(struct ath_hw *ah)
 	else if (AR_SREV_9550(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar955x_1p0_modes_xpa_tx_gain_table);
+	else if (AR_SREV_9531(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			qca953x_1p0_modes_xpa_tx_gain_table);
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9580_1p0_lowest_ob_db_tx_gain_table);
@@ -525,7 +554,14 @@ static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
 	else if (AR_SREV_9550(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar955x_1p0_modes_no_xpa_tx_gain_table);
-	else if (AR_SREV_9462_21(ah))
+	else if (AR_SREV_9531(ah)) {
+		if (AR_SREV_9531_11(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       qca953x_1p1_modes_no_xpa_tx_gain_table);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       qca953x_1p0_modes_no_xpa_tx_gain_table);
+	} else if (AR_SREV_9462_21(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9462_2p1_modes_high_ob_db_tx_gain);
 	else if (AR_SREV_9462_20(ah))
@@ -699,6 +735,11 @@ static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
 				ar955x_1p0_common_rx_gain_table);
 		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
 				ar955x_1p0_common_rx_gain_bounds);
+	} else if (AR_SREV_9531(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       qca953x_1p0_common_rx_gain_table);
+		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
+			       qca953x_1p0_common_rx_gain_bounds);
 	} else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 				ar9580_1p0_rx_gain_table);
@@ -744,6 +785,11 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 			ar955x_1p0_common_wo_xlna_rx_gain_table);
 		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
 			ar955x_1p0_common_wo_xlna_rx_gain_bounds);
+	} else if (AR_SREV_9531(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       qca953x_1p0_common_wo_xlna_rx_gain_table);
+		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
+			       qca953x_1p0_common_wo_xlna_rx_gain_bounds);
 	} else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9580_1p0_wo_xlna_rx_gain_table);
-- 
1.8.5.2

