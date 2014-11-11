Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53534 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaKKHGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 02:06:08 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/6] ath9k: Use new QCA953x initvals
Date: Tue, 11 Nov 2014 12:37:21 +0530
Message-Id: <1415689644-29693-4-git-send-email-sujith@msujith.org> (sfid-20141111_080618_072157_0A8C7BCE)
In-Reply-To: <1415689644-29693-1-git-send-email-sujith@msujith.org>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

This patch updates the initvals for QCA953x v1.1 and v2.0

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 51 ++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index cb09102..06ad217 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -333,12 +333,29 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 			       qca953x_1p0_soc_preamble);
 		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
 			       qca953x_1p0_soc_postamble);
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			       qca953x_1p0_common_wo_xlna_rx_gain_table);
-		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
-			       qca953x_1p0_common_wo_xlna_rx_gain_bounds);
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			       qca953x_1p0_modes_no_xpa_tx_gain_table);
+
+		if (AR_SREV_9531_20(ah)) {
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				       qca953x_2p0_common_wo_xlna_rx_gain_table);
+			INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
+				       qca953x_2p0_common_wo_xlna_rx_gain_bounds);
+		} else {
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				       qca953x_1p0_common_wo_xlna_rx_gain_table);
+			INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
+				       qca953x_1p0_common_wo_xlna_rx_gain_bounds);
+		}
+
+		if (AR_SREV_9531_20(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       qca953x_2p0_modes_no_xpa_tx_gain_table);
+		else if (AR_SREV_9531_11(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       qca953x_1p1_modes_no_xpa_tx_gain_table);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       qca953x_1p0_modes_no_xpa_tx_gain_table);
+
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
 			       qca953x_1p0_modes_fast_clock);
 	} else if (AR_SREV_9580(ah)) {
@@ -518,9 +535,15 @@ static void ar9003_tx_gain_table_mode0(struct ath_hw *ah)
 	else if (AR_SREV_9550(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar955x_1p0_modes_xpa_tx_gain_table);
-	else if (AR_SREV_9531(ah))
+	else if (AR_SREV_9531_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       qca953x_1p0_modes_xpa_tx_gain_table);
+	else if (AR_SREV_9531_11(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			qca953x_1p0_modes_xpa_tx_gain_table);
+			       qca953x_1p1_modes_xpa_tx_gain_table);
+	else if (AR_SREV_9531_20(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			       qca953x_2p0_modes_xpa_tx_gain_table);
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar9580_1p0_lowest_ob_db_tx_gain_table);
@@ -562,7 +585,10 @@ static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			ar955x_1p0_modes_no_xpa_tx_gain_table);
 	else if (AR_SREV_9531(ah)) {
-		if (AR_SREV_9531_11(ah))
+		if (AR_SREV_9531_20(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       qca953x_2p0_modes_no_xpa_tx_gain_table);
+		else if (AR_SREV_9531_11(ah))
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 				       qca953x_1p1_modes_no_xpa_tx_gain_table);
 		else
@@ -789,11 +815,16 @@ static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
 			ar955x_1p0_common_wo_xlna_rx_gain_table);
 		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
 			ar955x_1p0_common_wo_xlna_rx_gain_bounds);
-	} else if (AR_SREV_9531(ah)) {
+	} else if (AR_SREV_9531_10(ah) || AR_SREV_9531_11(ah)) {
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			       qca953x_1p0_common_wo_xlna_rx_gain_table);
 		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
 			       qca953x_1p0_common_wo_xlna_rx_gain_bounds);
+	} else if (AR_SREV_9531_20(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			       qca953x_2p0_common_wo_xlna_rx_gain_table);
+		INIT_INI_ARRAY(&ah->ini_modes_rx_gain_bounds,
+			       qca953x_2p0_common_wo_xlna_rx_gain_bounds);
 	} else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 			ar9580_1p0_wo_xlna_rx_gain_table);
-- 
2.1.3

