Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13831 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab0LAHdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:33:31 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:33:17 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/26] ath9k_hw: Initialize tx/rx gain table from initvals.h for AR9485
Date: Tue, 30 Nov 2010 23:32:34 -0800
Message-ID: <1291188775-13707-6-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   82 +++++++++++++++++++++-------
 1 files changed, 62 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index f01c289..21a5bfe 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -175,22 +175,52 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 	switch (ar9003_hw_get_tx_gain_idx(ah)) {
 	case 0:
 	default:
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			       ar9300Modes_lowest_ob_db_tx_gain_table_2p2,
-			       ARRAY_SIZE(ar9300Modes_lowest_ob_db_tx_gain_table_2p2),
-			       5);
+		if (AR_SREV_9485(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9485Modes_lowest_ob_db_tx_gain_1_0,
+				       ARRAY_SIZE(ar9485Modes_lowest_ob_db_tx_gain_1_0),
+				       5);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9300Modes_lowest_ob_db_tx_gain_table_2p2,
+				       ARRAY_SIZE(ar9300Modes_lowest_ob_db_tx_gain_table_2p2),
+				       5);
 		break;
 	case 1:
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			       ar9300Modes_high_ob_db_tx_gain_table_2p2,
-			       ARRAY_SIZE(ar9300Modes_high_ob_db_tx_gain_table_2p2),
-			       5);
+		if (AR_SREV_9485(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9485Modes_high_ob_db_tx_gain_1_0,
+				       ARRAY_SIZE(ar9485Modes_lowest_ob_db_tx_gain_1_0),
+				       5);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9300Modes_high_ob_db_tx_gain_table_2p2,
+				       ARRAY_SIZE(ar9300Modes_high_ob_db_tx_gain_table_2p2),
+				       5);
 		break;
 	case 2:
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			       ar9300Modes_low_ob_db_tx_gain_table_2p2,
-			       ARRAY_SIZE(ar9300Modes_low_ob_db_tx_gain_table_2p2),
-			       5);
+		if (AR_SREV_9485(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9485Modes_low_ob_db_tx_gain_1_0,
+				       ARRAY_SIZE(ar9485Modes_lowest_ob_db_tx_gain_1_0),
+				       5);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9300Modes_low_ob_db_tx_gain_table_2p2,
+				       ARRAY_SIZE(ar9300Modes_low_ob_db_tx_gain_table_2p2),
+				       5);
+		break;
+	case 3:
+		if (AR_SREV_9485(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9485Modes_high_power_tx_gain_1_0,
+				       ARRAY_SIZE(ar9485Modes_high_power_tx_gain_1_0),
+				       5);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9300Modes_high_power_tx_gain_table_2p2,
+				       ARRAY_SIZE(ar9300Modes_high_power_tx_gain_table_2p2),
+				       5);
 		break;
 	}
 }
@@ -200,16 +230,28 @@ static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 	switch (ar9003_hw_get_rx_gain_idx(ah)) {
 	case 0:
 	default:
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			       ar9300Common_rx_gain_table_2p2,
-			       ARRAY_SIZE(ar9300Common_rx_gain_table_2p2),
-			       2);
+		if (AR_SREV_9485(ah))
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				       ar9485Common_rx_gain_1_0,
+				       ARRAY_SIZE(ar9485Common_rx_gain_1_0),
+				       2);
+		else
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				       ar9300Common_rx_gain_table_2p2,
+				       ARRAY_SIZE(ar9300Common_rx_gain_table_2p2),
+				       2);
 		break;
 	case 1:
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			       ar9300Common_wo_xlna_rx_gain_table_2p2,
-			       ARRAY_SIZE(ar9300Common_wo_xlna_rx_gain_table_2p2),
-			       2);
+		if (AR_SREV_9485(ah))
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				       ar9485Common_wo_xlna_rx_gain_1_0,
+				       ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_0),
+				       2);
+		else
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				       ar9300Common_wo_xlna_rx_gain_table_2p2,
+				       ARRAY_SIZE(ar9300Common_wo_xlna_rx_gain_table_2p2),
+				       2);
 		break;
 	}
 }
-- 
1.7.0.4

