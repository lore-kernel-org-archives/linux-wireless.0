Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32409 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbZHGEPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 00:15:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 21:15:17 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19067.43618.973315.564996@gargle.gargle.HOWL>
Date: Fri, 7 Aug 2009 09:45:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/12] ath9k: Cleanup TX power calculation for 4K chips
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Write CCK power-per-rate array always and report
correct TX power to regulatory.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c |   72 +++++++++++++--------------
 1 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index c963615..29878e0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -703,11 +703,11 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 }
 
 static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
-				   struct ath9k_channel *chan,
-				   u16 cfgCtl,
-				   u8 twiceAntennaReduction,
-				   u8 twiceMaxRegulatoryPower,
-				   u8 powerLimit)
+				    struct ath9k_channel *chan,
+				    u16 cfgCtl,
+				    u8 twiceAntennaReduction,
+				    u8 twiceMaxRegulatoryPower,
+				    u8 powerLimit)
 {
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
@@ -724,10 +724,10 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	}
 
 	ath9k_hw_set_4k_power_per_rate_table(ah, chan,
-					       &ratesArray[0], cfgCtl,
-					       twiceAntennaReduction,
-					       twiceMaxRegulatoryPower,
-					       powerLimit);
+					     &ratesArray[0], cfgCtl,
+					     twiceAntennaReduction,
+					     twiceMaxRegulatoryPower,
+					     powerLimit);
 
 	ath9k_hw_set_4k_power_cal_table(ah, chan, &txPowerIndexOffset);
 
@@ -737,11 +737,23 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 			ratesArray[i] = AR5416_MAX_RATE_POWER;
 	}
 
+
+	/* Update regulatory */
+
+	i = rate6mb;
+	if (IS_CHAN_HT40(chan))
+		i = rateHt40_0;
+	else if (IS_CHAN_HT20(chan))
+		i = rateHt20_0;
+
+	ah->regulatory.max_power_level = ratesArray[i];
+
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++)
 			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET * 2;
 	}
 
+	/* OFDM power per rate */
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
 		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
 		  | ATH9K_POW_SM(ratesArray[rate12mb], 16)
@@ -753,19 +765,19 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 		  | ATH9K_POW_SM(ratesArray[rate36mb], 8)
 		  | ATH9K_POW_SM(ratesArray[rate24mb], 0));
 
-	if (IS_CHAN_2GHZ(chan)) {
-		REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
-			  ATH9K_POW_SM(ratesArray[rate2s], 24)
-			  | ATH9K_POW_SM(ratesArray[rate2l], 16)
-			  | ATH9K_POW_SM(ratesArray[rateXr], 8)
-			  | ATH9K_POW_SM(ratesArray[rate1l], 0));
-		REG_WRITE(ah, AR_PHY_POWER_TX_RATE4,
-			  ATH9K_POW_SM(ratesArray[rate11s], 24)
-			  | ATH9K_POW_SM(ratesArray[rate11l], 16)
-			  | ATH9K_POW_SM(ratesArray[rate5_5s], 8)
-			  | ATH9K_POW_SM(ratesArray[rate5_5l], 0));
-	}
-
+	/* CCK power per rate */
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
+		  ATH9K_POW_SM(ratesArray[rate2s], 24)
+		  | ATH9K_POW_SM(ratesArray[rate2l], 16)
+		  | ATH9K_POW_SM(ratesArray[rateXr], 8)
+		  | ATH9K_POW_SM(ratesArray[rate1l], 0));
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE4,
+		  ATH9K_POW_SM(ratesArray[rate11s], 24)
+		  | ATH9K_POW_SM(ratesArray[rate11l], 16)
+		  | ATH9K_POW_SM(ratesArray[rate5_5s], 8)
+		  | ATH9K_POW_SM(ratesArray[rate5_5l], 0));
+
+	/* HT20 power per rate */
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE5,
 		  ATH9K_POW_SM(ratesArray[rateHt20_3], 24)
 		  | ATH9K_POW_SM(ratesArray[rateHt20_2], 16)
@@ -777,6 +789,7 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 		  | ATH9K_POW_SM(ratesArray[rateHt20_5], 8)
 		  | ATH9K_POW_SM(ratesArray[rateHt20_4], 0));
 
+	/* HT40 power per rate */
 	if (IS_CHAN_HT40(chan)) {
 		REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
 			  ATH9K_POW_SM(ratesArray[rateHt40_3] +
@@ -796,27 +809,12 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 					 ht40PowerIncForPdadc, 8)
 			  | ATH9K_POW_SM(ratesArray[rateHt40_4] +
 					 ht40PowerIncForPdadc, 0));
-
 		REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
 			  ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
 			  | ATH9K_POW_SM(ratesArray[rateExtCck], 16)
 			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
 			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
 	}
-
-	i = rate6mb;
-
-	if (IS_CHAN_HT40(chan))
-		i = rateHt40_0;
-	else if (IS_CHAN_HT20(chan))
-		i = rateHt20_0;
-
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ah->regulatory.max_power_level =
-			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
-	else
-		ah->regulatory.max_power_level = ratesArray[i];
-
 }
 
 static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
-- 
1.6.4

