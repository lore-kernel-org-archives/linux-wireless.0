Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57264 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab1DSN70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:59:26 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 06:59:00 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 08/22] ath9k_hw: Initialize tx and rx gain table from initvals.h for ar9340
Date: Tue, 19 Apr 2011 19:29:06 +0530
Message-ID: <1303221560-25139-9-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
References: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   42 ++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 37af721..a55eddb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -220,7 +220,12 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 	switch (ar9003_hw_get_tx_gain_idx(ah)) {
 	case 0:
 	default:
-		if (AR_SREV_9485_11(ah))
+		if (AR_SREV_9340(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
+				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+				       5);
+		else if (AR_SREV_9485_11(ah))
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 				       ar9485_modes_lowest_ob_db_tx_gain_1_1,
 				       ARRAY_SIZE(ar9485_modes_lowest_ob_db_tx_gain_1_1),
@@ -232,7 +237,12 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 				       5);
 		break;
 	case 1:
-		if (AR_SREV_9485_11(ah))
+		if (AR_SREV_9340(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
+				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+				       5);
+		else if (AR_SREV_9485_11(ah))
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 				       ar9485Modes_high_ob_db_tx_gain_1_1,
 				       ARRAY_SIZE(ar9485Modes_high_ob_db_tx_gain_1_1),
@@ -244,7 +254,12 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 				       5);
 		break;
 	case 2:
-		if (AR_SREV_9485_11(ah))
+		if (AR_SREV_9340(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
+				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+				       5);
+		else if (AR_SREV_9485_11(ah))
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 				       ar9485Modes_low_ob_db_tx_gain_1_1,
 				       ARRAY_SIZE(ar9485Modes_low_ob_db_tx_gain_1_1),
@@ -256,7 +271,12 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 				       5);
 		break;
 	case 3:
-		if (AR_SREV_9485_11(ah))
+		if (AR_SREV_9340(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
+				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
+				       5);
+		else if (AR_SREV_9485_11(ah))
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 				       ar9485Modes_high_power_tx_gain_1_1,
 				       ARRAY_SIZE(ar9485Modes_high_power_tx_gain_1_1),
@@ -275,7 +295,12 @@ static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 	switch (ar9003_hw_get_rx_gain_idx(ah)) {
 	case 0:
 	default:
-		if (AR_SREV_9485_11(ah))
+		if (AR_SREV_9340(ah))
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				       ar9340Common_rx_gain_table_1p0,
+				       ARRAY_SIZE(ar9340Common_rx_gain_table_1p0),
+				       2);
+		else if (AR_SREV_9485_11(ah))
 			INIT_INI_ARRAY(&ah->iniModesRxGain,
 				       ar9485Common_wo_xlna_rx_gain_1_1,
 				       ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
@@ -287,7 +312,12 @@ static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 				       2);
 		break;
 	case 1:
-		if (AR_SREV_9485_11(ah))
+		if (AR_SREV_9340(ah))
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				       ar9340Common_wo_xlna_rx_gain_table_1p0,
+				       ARRAY_SIZE(ar9340Common_wo_xlna_rx_gain_table_1p0),
+				       2);
+		else if (AR_SREV_9485_11(ah))
 			INIT_INI_ARRAY(&ah->iniModesRxGain,
 				       ar9485Common_wo_xlna_rx_gain_1_1,
 				       ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
-- 
1.7.0.4

