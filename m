Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37002 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1IMRJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 13:09:48 -0400
From: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: [PATCH 2/4] ath9k_hw: Split tx/rx gain table initval handling
Date: Tue, 13 Sep 2011 22:38:17 +0530
Message-ID: <1315933699-7642-2-git-send-email-senthilb@qca.qualcomm.com> (sfid-20110913_190958_027566_5268F3B9)
In-Reply-To: <1315933699-7642-1-git-send-email-senthilb@qca.qualcomm.com>
References: <1315933699-7642-1-git-send-email-senthilb@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split tx/rx gain table initval hanlding part so readability
is better and easy to manage the code.

Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |  390 +++++++++++++++-------------
 1 files changed, 210 insertions(+), 180 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index b6839e6..6b54700 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -374,208 +374,238 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 	}
 }
 
+static void ar9003_tx_gain_table_mode0(struct ath_hw *ah)
+{
+	if (AR_SREV_9330_12(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9331_modes_lowest_ob_db_tx_gain_1p2,
+			ARRAY_SIZE(ar9331_modes_lowest_ob_db_tx_gain_1p2),
+			5);
+	else if (AR_SREV_9330_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9331_modes_lowest_ob_db_tx_gain_1p1,
+			ARRAY_SIZE(ar9331_modes_lowest_ob_db_tx_gain_1p1),
+			5);
+	else if (AR_SREV_9340(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+			5);
+	else if (AR_SREV_9485_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9485_modes_lowest_ob_db_tx_gain_1_1,
+			ARRAY_SIZE(ar9485_modes_lowest_ob_db_tx_gain_1_1),
+			5);
+	else if (AR_SREV_9580(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9580_1p0_lowest_ob_db_tx_gain_table,
+			ARRAY_SIZE(ar9580_1p0_lowest_ob_db_tx_gain_table),
+			5);
+	else
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9300Modes_lowest_ob_db_tx_gain_table_2p2,
+			ARRAY_SIZE(ar9300Modes_lowest_ob_db_tx_gain_table_2p2),
+			5);
+}
+
+static void ar9003_tx_gain_table_mode1(struct ath_hw *ah)
+{
+	if (AR_SREV_9330_12(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9331_modes_high_ob_db_tx_gain_1p2,
+			ARRAY_SIZE(ar9331_modes_high_ob_db_tx_gain_1p2),
+			5);
+	else if (AR_SREV_9330_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9331_modes_high_ob_db_tx_gain_1p1,
+			ARRAY_SIZE(ar9331_modes_high_ob_db_tx_gain_1p1),
+			5);
+	else if (AR_SREV_9340(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+			5);
+	else if (AR_SREV_9485_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9485Modes_high_ob_db_tx_gain_1_1,
+			ARRAY_SIZE(ar9485Modes_high_ob_db_tx_gain_1_1),
+			5);
+	else if (AR_SREV_9580(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9580_1p0_high_ob_db_tx_gain_table,
+			ARRAY_SIZE(ar9580_1p0_high_ob_db_tx_gain_table),
+			5);
+	else
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9300Modes_high_ob_db_tx_gain_table_2p2,
+			ARRAY_SIZE(ar9300Modes_high_ob_db_tx_gain_table_2p2),
+			5);
+}
+
+static void ar9003_tx_gain_table_mode2(struct ath_hw *ah)
+{
+	if (AR_SREV_9330_12(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9331_modes_low_ob_db_tx_gain_1p2,
+			ARRAY_SIZE(ar9331_modes_low_ob_db_tx_gain_1p2),
+			5);
+	else if (AR_SREV_9330_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9331_modes_low_ob_db_tx_gain_1p1,
+			ARRAY_SIZE(ar9331_modes_low_ob_db_tx_gain_1p1),
+			5);
+	else if (AR_SREV_9340(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+			5);
+	else if (AR_SREV_9485_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9485Modes_low_ob_db_tx_gain_1_1,
+			ARRAY_SIZE(ar9485Modes_low_ob_db_tx_gain_1_1),
+			5);
+	else if (AR_SREV_9580(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9580_1p0_low_ob_db_tx_gain_table,
+			ARRAY_SIZE(ar9580_1p0_low_ob_db_tx_gain_table),
+			5);
+	else
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9300Modes_low_ob_db_tx_gain_table_2p2,
+			ARRAY_SIZE(ar9300Modes_low_ob_db_tx_gain_table_2p2),
+			5);
+}
+
+static void ar9003_tx_gain_table_mode3(struct ath_hw *ah)
+{
+	if (AR_SREV_9330_12(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9331_modes_high_power_tx_gain_1p2,
+			ARRAY_SIZE(ar9331_modes_high_power_tx_gain_1p2),
+			5);
+	else if (AR_SREV_9330_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9331_modes_high_power_tx_gain_1p1,
+			ARRAY_SIZE(ar9331_modes_high_power_tx_gain_1p1),
+			5);
+	else if (AR_SREV_9340(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
+			ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+			5);
+	else if (AR_SREV_9485_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9485Modes_high_power_tx_gain_1_1,
+			ARRAY_SIZE(ar9485Modes_high_power_tx_gain_1_1),
+			5);
+	else if (AR_SREV_9580(ah))
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9580_1p0_high_power_tx_gain_table,
+			ARRAY_SIZE(ar9580_1p0_high_power_tx_gain_table),
+			5);
+	else
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9300Modes_high_power_tx_gain_table_2p2,
+			ARRAY_SIZE(ar9300Modes_high_power_tx_gain_table_2p2),
+			5);
+}
+
 static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 {
 	switch (ar9003_hw_get_tx_gain_idx(ah)) {
 	case 0:
 	default:
-		if (AR_SREV_9330_12(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9331_modes_lowest_ob_db_tx_gain_1p2,
-				ARRAY_SIZE(ar9331_modes_lowest_ob_db_tx_gain_1p2),
-				5);
-		else if (AR_SREV_9330_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9331_modes_lowest_ob_db_tx_gain_1p1,
-				ARRAY_SIZE(ar9331_modes_lowest_ob_db_tx_gain_1p1),
-				5);
-		else if (AR_SREV_9340(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
-				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
-				       5);
-		else if (AR_SREV_9485_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				       ar9485_modes_lowest_ob_db_tx_gain_1_1,
-				       ARRAY_SIZE(ar9485_modes_lowest_ob_db_tx_gain_1_1),
-				       5);
-		else if (AR_SREV_9580(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			      ar9580_1p0_lowest_ob_db_tx_gain_table,
-			      ARRAY_SIZE(ar9580_1p0_lowest_ob_db_tx_gain_table),
-			      5);
-		else
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				       ar9300Modes_lowest_ob_db_tx_gain_table_2p2,
-				       ARRAY_SIZE(ar9300Modes_lowest_ob_db_tx_gain_table_2p2),
-				       5);
+		ar9003_tx_gain_table_mode0(ah);
 		break;
 	case 1:
-		if (AR_SREV_9330_12(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9331_modes_high_ob_db_tx_gain_1p2,
-				ARRAY_SIZE(ar9331_modes_high_ob_db_tx_gain_1p2),
-				5);
-		else if (AR_SREV_9330_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9331_modes_high_ob_db_tx_gain_1p1,
-				ARRAY_SIZE(ar9331_modes_high_ob_db_tx_gain_1p1),
-				5);
-		else if (AR_SREV_9340(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
-				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
-				       5);
-		else if (AR_SREV_9485_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				       ar9485Modes_high_ob_db_tx_gain_1_1,
-				       ARRAY_SIZE(ar9485Modes_high_ob_db_tx_gain_1_1),
-				       5);
-		else if (AR_SREV_9580(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9580_1p0_high_ob_db_tx_gain_table,
-				ARRAY_SIZE(ar9580_1p0_high_ob_db_tx_gain_table),
-				       5);
-		else
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				       ar9300Modes_high_ob_db_tx_gain_table_2p2,
-				       ARRAY_SIZE(ar9300Modes_high_ob_db_tx_gain_table_2p2),
-				       5);
+		ar9003_tx_gain_table_mode1(ah);
 		break;
 	case 2:
-		if (AR_SREV_9330_12(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9331_modes_low_ob_db_tx_gain_1p2,
-				ARRAY_SIZE(ar9331_modes_low_ob_db_tx_gain_1p2),
-				5);
-		else if (AR_SREV_9330_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9331_modes_low_ob_db_tx_gain_1p1,
-				ARRAY_SIZE(ar9331_modes_low_ob_db_tx_gain_1p1),
-				5);
-		else if (AR_SREV_9340(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
-				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
-				       5);
-		else if (AR_SREV_9485_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				       ar9485Modes_low_ob_db_tx_gain_1_1,
-				       ARRAY_SIZE(ar9485Modes_low_ob_db_tx_gain_1_1),
-				       5);
-		else if (AR_SREV_9580(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				 ar9580_1p0_low_ob_db_tx_gain_table,
-				 ARRAY_SIZE(ar9580_1p0_low_ob_db_tx_gain_table),
-				 5);
-		else
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				       ar9300Modes_low_ob_db_tx_gain_table_2p2,
-				       ARRAY_SIZE(ar9300Modes_low_ob_db_tx_gain_table_2p2),
-				       5);
+		ar9003_tx_gain_table_mode2(ah);
 		break;
 	case 3:
-		if (AR_SREV_9330_12(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9331_modes_high_power_tx_gain_1p2,
-				ARRAY_SIZE(ar9331_modes_high_power_tx_gain_1p2),
-				5);
-		else if (AR_SREV_9330_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9331_modes_high_power_tx_gain_1p1,
-				ARRAY_SIZE(ar9331_modes_high_power_tx_gain_1p1),
-				5);
-		else if (AR_SREV_9340(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
-				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
-				       5);
-		else if (AR_SREV_9485_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				       ar9485Modes_high_power_tx_gain_1_1,
-				       ARRAY_SIZE(ar9485Modes_high_power_tx_gain_1_1),
-				       5);
-		else if (AR_SREV_9580(ah))
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				ar9580_1p0_high_power_tx_gain_table,
-				ARRAY_SIZE(ar9580_1p0_high_power_tx_gain_table),
-				5);
-		else
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-				       ar9300Modes_high_power_tx_gain_table_2p2,
-				       ARRAY_SIZE(ar9300Modes_high_power_tx_gain_table_2p2),
-				       5);
+		ar9003_tx_gain_table_mode3(ah);
 		break;
 	}
 }
 
+static void ar9003_rx_gain_table_mode0(struct ath_hw *ah)
+{
+	if (AR_SREV_9330_12(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9331_common_rx_gain_1p2,
+				ARRAY_SIZE(ar9331_common_rx_gain_1p2),
+				2);
+	else if (AR_SREV_9330_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9331_common_rx_gain_1p1,
+				ARRAY_SIZE(ar9331_common_rx_gain_1p1),
+				2);
+	else if (AR_SREV_9340(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9340Common_rx_gain_table_1p0,
+				ARRAY_SIZE(ar9340Common_rx_gain_table_1p0),
+				2);
+	else if (AR_SREV_9485_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9485Common_wo_xlna_rx_gain_1_1,
+				ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
+				2);
+	else if (AR_SREV_9580(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9580_1p0_rx_gain_table,
+				ARRAY_SIZE(ar9580_1p0_rx_gain_table),
+				2);
+	else
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9300Common_rx_gain_table_2p2,
+				ARRAY_SIZE(ar9300Common_rx_gain_table_2p2),
+				2);
+}
+
+static void ar9003_rx_gain_table_mode1(struct ath_hw *ah)
+{
+	if (AR_SREV_9330_12(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9331_common_wo_xlna_rx_gain_1p2,
+			ARRAY_SIZE(ar9331_common_wo_xlna_rx_gain_1p2),
+			2);
+	else if (AR_SREV_9330_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9331_common_wo_xlna_rx_gain_1p1,
+			ARRAY_SIZE(ar9331_common_wo_xlna_rx_gain_1p1),
+			2);
+	else if (AR_SREV_9340(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9340Common_wo_xlna_rx_gain_table_1p0,
+			ARRAY_SIZE(ar9340Common_wo_xlna_rx_gain_table_1p0),
+			2);
+	else if (AR_SREV_9485_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9485Common_wo_xlna_rx_gain_1_1,
+			ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
+			2);
+	else if (AR_SREV_9580(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9580_1p0_wo_xlna_rx_gain_table,
+			ARRAY_SIZE(ar9580_1p0_wo_xlna_rx_gain_table),
+			2);
+	else
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9300Common_wo_xlna_rx_gain_table_2p2,
+			ARRAY_SIZE(ar9300Common_wo_xlna_rx_gain_table_2p2),
+			2);
+}
+
 static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 {
 	switch (ar9003_hw_get_rx_gain_idx(ah)) {
 	case 0:
 	default:
-		if (AR_SREV_9330_12(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-					ar9331_common_rx_gain_1p2,
-					ARRAY_SIZE(ar9331_common_rx_gain_1p2),
-					2);
-		else if (AR_SREV_9330_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-					ar9331_common_rx_gain_1p1,
-					ARRAY_SIZE(ar9331_common_rx_gain_1p1),
-					2);
-		else if (AR_SREV_9340(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				       ar9340Common_rx_gain_table_1p0,
-				       ARRAY_SIZE(ar9340Common_rx_gain_table_1p0),
-				       2);
-		else if (AR_SREV_9485_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				       ar9485Common_wo_xlna_rx_gain_1_1,
-				       ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
-				       2);
-		else if (AR_SREV_9580(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				       ar9580_1p0_rx_gain_table,
-				       ARRAY_SIZE(ar9580_1p0_rx_gain_table),
-				       2);
-		else
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				       ar9300Common_rx_gain_table_2p2,
-				       ARRAY_SIZE(ar9300Common_rx_gain_table_2p2),
-				       2);
+		ar9003_rx_gain_table_mode0(ah);
 		break;
 	case 1:
-		if (AR_SREV_9330_12(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9331_common_wo_xlna_rx_gain_1p2,
-				ARRAY_SIZE(ar9331_common_wo_xlna_rx_gain_1p2),
-				2);
-		else if (AR_SREV_9330_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9331_common_wo_xlna_rx_gain_1p1,
-				ARRAY_SIZE(ar9331_common_wo_xlna_rx_gain_1p1),
-				2);
-		else if (AR_SREV_9340(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				       ar9340Common_wo_xlna_rx_gain_table_1p0,
-				       ARRAY_SIZE(ar9340Common_wo_xlna_rx_gain_table_1p0),
-				       2);
-		else if (AR_SREV_9485_11(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				       ar9485Common_wo_xlna_rx_gain_1_1,
-				       ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
-				       2);
-		else if (AR_SREV_9580(ah))
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				   ar9580_1p0_wo_xlna_rx_gain_table,
-				   ARRAY_SIZE(ar9580_1p0_wo_xlna_rx_gain_table),
-				   2);
-		else
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-				       ar9300Common_wo_xlna_rx_gain_table_2p2,
-				       ARRAY_SIZE(ar9300Common_wo_xlna_rx_gain_table_2p2),
-				       2);
+		ar9003_rx_gain_table_mode1(ah);
 		break;
 	}
 }
-- 
1.7.0.4

