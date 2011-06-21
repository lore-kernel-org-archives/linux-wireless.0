Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41687 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1FUJY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:24:56 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 07/32] ath9k: initialize tx gain table for AR9330
Date: Tue, 21 Jun 2011 11:23:27 +0200
Message-Id: <1308648232-9906-8-git-send-email-juhosg@openwrt.org> (sfid-20110621_112527_485720_DE186823)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   48 +++++++++++++++++++++++++--
 1 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index dc0ad4a..264a7ea 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -328,7 +328,17 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 	switch (ar9003_hw_get_tx_gain_idx(ah)) {
 	case 0:
 	default:
-		if (AR_SREV_9340(ah))
+		if (AR_SREV_9330_12(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9331_modes_lowest_ob_db_tx_gain_1p2,
+				ARRAY_SIZE(ar9331_modes_lowest_ob_db_tx_gain_1p2),
+				5);
+		else if (AR_SREV_9330_11(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9331_modes_lowest_ob_db_tx_gain_1p1,
+				ARRAY_SIZE(ar9331_modes_lowest_ob_db_tx_gain_1p1),
+				5);
+		else if (AR_SREV_9340(ah))
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
 				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
@@ -345,7 +355,17 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 				       5);
 		break;
 	case 1:
-		if (AR_SREV_9340(ah))
+		if (AR_SREV_9330_12(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9331_modes_high_ob_db_tx_gain_1p2,
+				ARRAY_SIZE(ar9331_modes_high_ob_db_tx_gain_1p2),
+				5);
+		else if (AR_SREV_9330_11(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9331_modes_high_ob_db_tx_gain_1p1,
+				ARRAY_SIZE(ar9331_modes_high_ob_db_tx_gain_1p1),
+				5);
+		else if (AR_SREV_9340(ah))
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
 				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
@@ -362,7 +382,17 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 				       5);
 		break;
 	case 2:
-		if (AR_SREV_9340(ah))
+		if (AR_SREV_9330_12(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9331_modes_low_ob_db_tx_gain_1p2,
+				ARRAY_SIZE(ar9331_modes_low_ob_db_tx_gain_1p2),
+				5);
+		else if (AR_SREV_9330_11(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9331_modes_low_ob_db_tx_gain_1p1,
+				ARRAY_SIZE(ar9331_modes_low_ob_db_tx_gain_1p1),
+				5);
+		else if (AR_SREV_9340(ah))
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
 				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
@@ -379,7 +409,17 @@ static void ar9003_tx_gain_table_apply(struct ath_hw *ah)
 				       5);
 		break;
 	case 3:
-		if (AR_SREV_9340(ah))
+		if (AR_SREV_9330_12(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9331_modes_high_power_tx_gain_1p2,
+				ARRAY_SIZE(ar9331_modes_high_power_tx_gain_1p2),
+				5);
+		else if (AR_SREV_9330_11(ah))
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9331_modes_high_power_tx_gain_1p1,
+				ARRAY_SIZE(ar9331_modes_high_power_tx_gain_1p1),
+				5);
+		else if (AR_SREV_9340(ah))
 			INIT_INI_ARRAY(&ah->iniModesTxGain,
 					ar9340Modes_lowest_ob_db_tx_gain_table_1p0,
 				       ARRAY_SIZE(ar9340Modes_lowest_ob_db_tx_gain_table_1p0),
-- 
1.7.2.1

