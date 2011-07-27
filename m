Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36952 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1G0NBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 09:01:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/4] ath9k_hw: remove the tx power index offset
Date: Wed, 27 Jul 2011 15:01:03 +0200
Message-Id: <1311771665-59853-2-git-send-email-nbd@openwrt.org> (sfid-20110727_150124_252009_520A7786)
In-Reply-To: <1311771665-59853-1-git-send-email-nbd@openwrt.org>
References: <1311771665-59853-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is always 0

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |    9 ++-------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    9 ++-------
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |    8 ++------
 3 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 47cc950..bf64d67 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -248,8 +248,7 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 }
 
 static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
-				  struct ath9k_channel *chan,
-				  int16_t *pTxPowerIndexOffset)
+				  struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
@@ -356,8 +355,6 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 			REGWRITE_BUFFER_FLUSH(ah);
 		}
 	}
-
-	*pTxPowerIndexOffset = 0;
 }
 
 static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
@@ -580,7 +577,6 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
-	int16_t txPowerIndexOffset = 0;
 	u8 ht40PowerIncForPdadc = 2;
 	int i;
 
@@ -597,11 +593,10 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 					     twiceMaxRegulatoryPower,
 					     powerLimit);
 
-	ath9k_hw_set_4k_power_cal_table(ah, chan, &txPowerIndexOffset);
+	ath9k_hw_set_4k_power_cal_table(ah, chan);
 
 	regulatory->max_power_level = 0;
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
-		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
 		if (ratesArray[i] > MAX_RATE_POWER)
 			ratesArray[i] = MAX_RATE_POWER;
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index d6f6b19..a65d2a5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -307,8 +307,7 @@ static void ar9287_eeprom_olpc_set_pdadcs(struct ath_hw *ah,
 }
 
 static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
-						struct ath9k_channel *chan,
-						int16_t *pTxPowerIndexOffset)
+						struct ath9k_channel *chan)
 {
 	struct cal_data_per_freq_ar9287 *pRawDataset;
 	struct cal_data_op_loop_ar9287 *pRawDatasetOpenLoop;
@@ -444,8 +443,6 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 			REGWRITE_BUFFER_FLUSH(ah);
 		}
 	}
-
-	*pTxPowerIndexOffset = 0;
 }
 
 static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
@@ -720,7 +717,6 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
-	int16_t txPowerIndexOffset = 0;
 	u8 ht40PowerIncForPdadc = 2;
 	int i;
 
@@ -736,11 +732,10 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 						 twiceMaxRegulatoryPower,
 						 powerLimit);
 
-	ath9k_hw_set_ar9287_power_cal_table(ah, chan, &txPowerIndexOffset);
+	ath9k_hw_set_ar9287_power_cal_table(ah, chan);
 
 	regulatory->max_power_level = 0;
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
-		ratesArray[i] = (int16_t)(txPowerIndexOffset + ratesArray[i]);
 		if (ratesArray[i] > MAX_RATE_POWER)
 			ratesArray[i] = MAX_RATE_POWER;
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index b9540a9..b665837 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -693,8 +693,7 @@ static void ath9k_adjust_pdadc_values(struct ath_hw *ah,
 }
 
 static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
-				  struct ath9k_channel *chan,
-				  int16_t *pTxPowerIndexOffset)
+				  struct ath9k_channel *chan)
 {
 #define SM_PD_GAIN(x) SM(0x38, AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_##x)
 #define SM_PDGAIN_B(x, y) \
@@ -855,7 +854,6 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 		}
 	}
 
-	*pTxPowerIndexOffset = 0;
 #undef SM_PD_GAIN
 #undef SM_PDGAIN_B
 }
@@ -1143,7 +1141,6 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	struct modal_eep_header *pModal =
 		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
 	int16_t ratesArray[Ar5416RateSize];
-	int16_t txPowerIndexOffset = 0;
 	u8 ht40PowerIncForPdadc = 2;
 	int i, cck_ofdm_delta = 0;
 
@@ -1160,11 +1157,10 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 					       twiceMaxRegulatoryPower,
 					       powerLimit);
 
-	ath9k_hw_set_def_power_cal_table(ah, chan, &txPowerIndexOffset);
+	ath9k_hw_set_def_power_cal_table(ah, chan);
 
 	regulatory->max_power_level = 0;
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
-		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
 		if (ratesArray[i] > MAX_RATE_POWER)
 			ratesArray[i] = MAX_RATE_POWER;
 		if (ratesArray[i] > regulatory->max_power_level)
-- 
1.7.3.2

