Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32400 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZHGEO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 00:14:58 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 21:15:00 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19067.43599.565835.357578@gargle.gargle.HOWL>
Date: Fri, 7 Aug 2009 09:45:11 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/12] ath9k: Try to fix whitespace damage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |  251 +++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/eeprom.h |  193 ++++++++++++------------
 2 files changed, 215 insertions(+), 229 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 86b13d1..4303a4d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -2854,7 +2854,6 @@ static struct eeprom_ops eep_def_ops = {
 	.get_spur_channel	= ath9k_hw_def_get_spur_channel
 };
 
-
 static int ath9k_hw_AR9287_get_eeprom_ver(struct ath_hw *ah)
 {
 	return (ah->eeprom.map9287.baseEepHeader.version >> 12) & 0xF;
@@ -2871,22 +2870,24 @@ static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
 	u16 *eep_data;
 	int addr, eep_start_loc = AR9287_EEP_START_LOC;
 	eep_data = (u16 *)eep;
+
 	if (!ath9k_hw_use_flash(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"Reading from EEPROM, not flash\n");
+			"Reading from EEPROM, not flash\n");
 	}
 
 	for (addr = 0; addr < sizeof(struct ar9287_eeprom) / sizeof(u16);
 			addr++)	{
 		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-					"Unable to read eeprom region \n");
+				"Unable to read eeprom region \n");
 			return false;
 		}
 		eep_data++;
 	}
 	return true;
 }
+
 static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 {
 	u32 sum = 0, el, integer;
@@ -2996,7 +2997,7 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 }
 
 static u32 ath9k_hw_AR9287_get_eeprom(struct ath_hw *ah,
-		enum eeprom_param param)
+				      enum eeprom_param param)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
@@ -3059,6 +3060,7 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 {
 #define TMP_VAL_VPD_TABLE \
 	((vpdTableI[i][sizeCurrVpdTable - 1] + (ss - maxIndex + 1) * vpdStep));
+
 	int       i, j, k;
 	int16_t   ss;
 	u16  idxL = 0, idxR = 0, numPiers;
@@ -3079,6 +3081,7 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
+
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
 		if (bChans[numPiers] == AR9287_BCHAN_UNUSED)
 			break;
@@ -3205,16 +3208,18 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 }
 
 static void ar9287_eeprom_get_tx_gain_index(struct ath_hw *ah,
-		struct ath9k_channel *chan,
-		struct cal_data_op_loop_ar9287 *pRawDatasetOpLoop,
-		u8 *pCalChans,  u16 availPiers,
-		int8_t *pPwr)
+			    struct ath9k_channel *chan,
+			    struct cal_data_op_loop_ar9287 *pRawDatasetOpLoop,
+			    u8 *pCalChans,  u16 availPiers,
+			    int8_t *pPwr)
 {
 	u8 pcdac, i = 0;
 	u16  idxL = 0, idxR = 0, numPiers;
 	bool match;
 	struct chan_centers centers;
+
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
+
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
 		if (pCalChans[numPiers] == AR9287_BCHAN_UNUSED)
 			break;
@@ -3272,9 +3277,9 @@ static void ar9287_eeprom_olpc_set_pdadcs(struct ath_hw *ah,
 	}
 }
 
-
 static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
-		struct ath9k_channel *chan, int16_t *pTxPowerIndexOffset)
+						struct ath9k_channel *chan,
+						int16_t *pTxPowerIndexOffset)
 {
 	struct cal_data_per_freq_ar9287 *pRawDataset;
 	struct cal_data_op_loop_ar9287 *pRawDatasetOpenLoop;
@@ -3430,7 +3435,6 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 	*pTxPowerIndexOffset = 0;
 }
 
-
 static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 		struct ath9k_channel *chan, int16_t *ratesArray, u16 cfgCtl,
 		u16 AntennaReduction, u16 twiceMaxRegulatoryPower,
@@ -3440,8 +3444,8 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10
 
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
-	static const u16 tpScaleReductionTable[5] = { 0, 3, 6, 9,
-						      AR5416_MAX_RATE_POWER };
+	static const u16 tpScaleReductionTable[5] =
+		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
 	int i;
 	int16_t  twiceLargestAntenna;
 	struct cal_ctl_data_ar9287 *rep;
@@ -3452,8 +3456,9 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 	struct cal_target_power_ht  targetPowerHt20,
 				    targetPowerHt40 = {0, {0, 0, 0, 0} };
 	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
-	u16 ctlModesFor11g[] = {CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT,
-				CTL_11G_EXT, CTL_2GHT40};
+	u16 ctlModesFor11g[] =
+		{CTL_11B, CTL_11G, CTL_2GHT20,
+		 CTL_11B_EXT, CTL_11G_EXT, CTL_2GHT40};
 	u16 numCtlModes = 0, *pCtlMode = NULL, ctlMode, freq;
 	struct chan_centers centers;
 	int tx_chainmask;
@@ -3464,7 +3469,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	twiceLargestAntenna = max(pEepData->modalHeader.antennaGainCh[0],
-			pEepData->modalHeader.antennaGainCh[1]);
+				  pEepData->modalHeader.antennaGainCh[1]);
 
 	twiceLargestAntenna =  (int16_t)min((AntennaReduction) -
 					    twiceLargestAntenna, 0);
@@ -3489,42 +3494,41 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 	scaledPower = max((u16)0, scaledPower);
 
 	if (IS_CHAN_2GHZ(chan))	{
-		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
-					 SUB_NUM_CTL_MODES_AT_2G_40;
+		numCtlModes =
+			ARRAY_SIZE(ctlModesFor11g) - SUB_NUM_CTL_MODES_AT_2G_40;
 		pCtlMode = ctlModesFor11g;
 
 		ath9k_hw_get_legacy_target_powers(ah, chan,
-				pEepData->calTargetPowerCck,
-				AR9287_NUM_2G_CCK_TARGET_POWERS,
-				&targetPowerCck, 4, false);
+						  pEepData->calTargetPowerCck,
+						  AR9287_NUM_2G_CCK_TARGET_POWERS,
+						  &targetPowerCck, 4, false);
 		ath9k_hw_get_legacy_target_powers(ah, chan,
-				pEepData->calTargetPower2G,
-				AR9287_NUM_2G_20_TARGET_POWERS,
-				&targetPowerOfdm, 4, false);
+						  pEepData->calTargetPower2G,
+						  AR9287_NUM_2G_20_TARGET_POWERS,
+						  &targetPowerOfdm, 4, false);
 		ath9k_hw_get_target_powers(ah, chan,
-				pEepData->calTargetPower2GHT20,
-				AR9287_NUM_2G_20_TARGET_POWERS,
-				&targetPowerHt20, 8, false);
+					   pEepData->calTargetPower2GHT20,
+					   AR9287_NUM_2G_20_TARGET_POWERS,
+					   &targetPowerHt20, 8, false);
 
 		if (IS_CHAN_HT40(chan))	{
 			numCtlModes = ARRAY_SIZE(ctlModesFor11g);
 			ath9k_hw_get_target_powers(ah, chan,
-					pEepData->calTargetPower2GHT40,
-					AR9287_NUM_2G_40_TARGET_POWERS,
-					&targetPowerHt40, 8, true);
+						   pEepData->calTargetPower2GHT40,
+						   AR9287_NUM_2G_40_TARGET_POWERS,
+						   &targetPowerHt40, 8, true);
 			ath9k_hw_get_legacy_target_powers(ah, chan,
-					pEepData->calTargetPowerCck,
-					AR9287_NUM_2G_CCK_TARGET_POWERS,
-					&targetPowerCckExt, 4, true);
+						  pEepData->calTargetPowerCck,
+						  AR9287_NUM_2G_CCK_TARGET_POWERS,
+						  &targetPowerCckExt, 4, true);
 			ath9k_hw_get_legacy_target_powers(ah, chan,
-					pEepData->calTargetPower2G,
-					AR9287_NUM_2G_20_TARGET_POWERS,
-					&targetPowerOfdmExt, 4, true);
+						  pEepData->calTargetPower2G,
+						  AR9287_NUM_2G_20_TARGET_POWERS,
+						  &targetPowerOfdmExt, 4, true);
 		}
 	}
 
 	for (ctlMode = 0; ctlMode < numCtlModes; ctlMode++) {
-
 		bool isHt40CtlMode = (pCtlMode[ctlMode] == CTL_5GHT40) ||
 				     (pCtlMode[ctlMode] == CTL_2GHT40);
 		if (isHt40CtlMode)
@@ -3534,14 +3538,15 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 		else
 			freq = centers.ctl_center;
 
-
 		if (ah->eep_ops->get_eeprom_ver(ah) == 14 &&
-				ah->eep_ops->get_eeprom_rev(ah) <= 2)
+		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
 			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d,"
 			 "EXT_ADDITIVE %d\n", ctlMode, numCtlModes,
 			 isHt40CtlMode, (pCtlMode[ctlMode] & EXT_ADDITIVE));
+
 		for (i = 0; (i < AR9287_NUM_CTLS)
 			     && pEepData->ctlIndex[i]; i++) {
 			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
@@ -3552,12 +3557,12 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 				 pEepData->ctlIndex[i],	chan->channel);
 
 			if ((((cfgCtl & ~CTL_MODE_M) |
-			    (pCtlMode[ctlMode] & CTL_MODE_M)) ==
-			    pEepData->ctlIndex[i]) ||
+			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+			     pEepData->ctlIndex[i]) ||
 			    (((cfgCtl & ~CTL_MODE_M) |
-			    (pCtlMode[ctlMode] & CTL_MODE_M)) ==
-			    ((pEepData->ctlIndex[i] &
-			    CTL_MODE_M) | SD_NO_CTL))) {
+			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+			     ((pEepData->ctlIndex[i] &
+			       CTL_MODE_M) | SD_NO_CTL))) {
 
 				rep = &(pEepData->ctlData[i]);
 				twiceMinEdgePower = ath9k_hw_get_max_edge_power(
@@ -3592,7 +3597,6 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 				 ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
 				 scaledPower, minCtlPower);
 
-
 		switch (pCtlMode[ctlMode]) {
 
 		case CTL_11B:
@@ -3650,9 +3654,13 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 		}
 	}
 
-	ratesArray[rate6mb] = ratesArray[rate9mb] = ratesArray[rate12mb] =
-		ratesArray[rate18mb] = ratesArray[rate24mb] =
-		targetPowerOfdm.tPow2x[0];
+	ratesArray[rate6mb] =
+	ratesArray[rate9mb] =
+	ratesArray[rate12mb] =
+	ratesArray[rate18mb] =
+	ratesArray[rate24mb] =
+	targetPowerOfdm.tPow2x[0];
+
 	ratesArray[rate36mb] = targetPowerOfdm.tPow2x[1];
 	ratesArray[rate48mb] = targetPowerOfdm.tPow2x[2];
 	ratesArray[rate54mb] = targetPowerOfdm.tPow2x[3];
@@ -3663,7 +3671,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 
 	if (IS_CHAN_2GHZ(chan))	{
 		ratesArray[rate1l]  = targetPowerCck.tPow2x[0];
-		ratesArray[rate2s] = ratesArray[rate2l]  =
+		ratesArray[rate2s] = ratesArray[rate2l] =
 			targetPowerCck.tPow2x[1];
 		ratesArray[rate5_5s] = ratesArray[rate5_5l] =
 			targetPowerCck.tPow2x[2];
@@ -3680,35 +3688,38 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 		if (IS_CHAN_2GHZ(chan))
 			ratesArray[rateExtCck]  = targetPowerCckExt.tPow2x[0];
 	}
+
 #undef REDUCE_SCALED_POWER_BY_TWO_CHAIN
 #undef REDUCE_SCALED_POWER_BY_THREE_CHAIN
 }
 
 static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
-		struct ath9k_channel *chan, u16 cfgCtl,
-		u8 twiceAntennaReduction, u8 twiceMaxRegulatoryPower,
-		u8 powerLimit)
+					struct ath9k_channel *chan, u16 cfgCtl,
+					u8 twiceAntennaReduction,
+					u8 twiceMaxRegulatoryPower,
+					u8 powerLimit)
 {
 #define INCREASE_MAXPOW_BY_TWO_CHAIN     6
 #define INCREASE_MAXPOW_BY_THREE_CHAIN   10
+
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
 	int16_t  txPowerIndexOffset = 0;
 	u8 ht40PowerIncForPdadc = 2;
 	int i;
+
 	memset(ratesArray, 0, sizeof(ratesArray));
 
 	if ((pEepData->baseEepHeader.version & AR9287_EEP_VER_MINOR_MASK) >=
-			AR9287_EEP_MINOR_VER_2)
+	    AR9287_EEP_MINOR_VER_2)
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 
 	ath9k_hw_set_AR9287_power_per_rate_table(ah, chan,
-			&ratesArray[0], cfgCtl,
-			twiceAntennaReduction,
-			twiceMaxRegulatoryPower,
-			powerLimit);
-
+						 &ratesArray[0], cfgCtl,
+						 twiceAntennaReduction,
+						 twiceMaxRegulatoryPower,
+						 powerLimit);
 
 	ath9k_hw_set_AR9287_power_cal_table(ah, chan, &txPowerIndexOffset);
 
@@ -3723,99 +3734,85 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 			ratesArray[i] -= AR9287_PWR_TABLE_OFFSET_DB * 2;
 	}
 
-
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
-			ATH9K_POW_SM(ratesArray[rate18mb], 24)
-			| ATH9K_POW_SM(ratesArray[rate12mb], 16)
-			| ATH9K_POW_SM(ratesArray[rate9mb],  8)
-			| ATH9K_POW_SM(ratesArray[rate6mb],  0)
-		 );
+		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
+		  | ATH9K_POW_SM(ratesArray[rate12mb], 16)
+		  | ATH9K_POW_SM(ratesArray[rate9mb], 8)
+		  | ATH9K_POW_SM(ratesArray[rate6mb], 0));
 
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE2,
-			ATH9K_POW_SM(ratesArray[rate54mb], 24)
-			| ATH9K_POW_SM(ratesArray[rate48mb], 16)
-			| ATH9K_POW_SM(ratesArray[rate36mb],  8)
-			| ATH9K_POW_SM(ratesArray[rate24mb],  0)
-		 );
+		  ATH9K_POW_SM(ratesArray[rate54mb], 24)
+		  | ATH9K_POW_SM(ratesArray[rate48mb], 16)
+		  | ATH9K_POW_SM(ratesArray[rate36mb], 8)
+		  | ATH9K_POW_SM(ratesArray[rate24mb], 0));
 
 	if (IS_CHAN_2GHZ(chan))	{
 		REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
-				ATH9K_POW_SM(ratesArray[rate2s], 24)
-				| ATH9K_POW_SM(ratesArray[rate2l],  16)
-				| ATH9K_POW_SM(ratesArray[rateXr],  8)
-				| ATH9K_POW_SM(ratesArray[rate1l],   0)
-			 );
+			  ATH9K_POW_SM(ratesArray[rate2s], 24)
+			  | ATH9K_POW_SM(ratesArray[rate2l], 16)
+			  | ATH9K_POW_SM(ratesArray[rateXr], 8)
+			  | ATH9K_POW_SM(ratesArray[rate1l], 0));
 		REG_WRITE(ah, AR_PHY_POWER_TX_RATE4,
-				ATH9K_POW_SM(ratesArray[rate11s], 24)
-				| ATH9K_POW_SM(ratesArray[rate11l], 16)
-				| ATH9K_POW_SM(ratesArray[rate5_5s],  8)
-				| ATH9K_POW_SM(ratesArray[rate5_5l],  0)
-			 );
+			  ATH9K_POW_SM(ratesArray[rate11s], 24)
+			  | ATH9K_POW_SM(ratesArray[rate11l], 16)
+			  | ATH9K_POW_SM(ratesArray[rate5_5s], 8)
+			  | ATH9K_POW_SM(ratesArray[rate5_5l], 0));
 	}
 
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE5,
-			ATH9K_POW_SM(ratesArray[rateHt20_3], 24)
-			| ATH9K_POW_SM(ratesArray[rateHt20_2],  16)
-			| ATH9K_POW_SM(ratesArray[rateHt20_1],  8)
-			| ATH9K_POW_SM(ratesArray[rateHt20_0],   0)
-		 );
+		  ATH9K_POW_SM(ratesArray[rateHt20_3], 24)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_2], 16)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_1], 8)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_0], 0));
 
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE6,
-			ATH9K_POW_SM(ratesArray[rateHt20_7], 24)
-			| ATH9K_POW_SM(ratesArray[rateHt20_6],  16)
-			| ATH9K_POW_SM(ratesArray[rateHt20_5],  8)
-			| ATH9K_POW_SM(ratesArray[rateHt20_4],   0)
-		 );
+		  ATH9K_POW_SM(ratesArray[rateHt20_7], 24)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_6], 16)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_5], 8)
+		  | ATH9K_POW_SM(ratesArray[rateHt20_4], 0));
 
 	if (IS_CHAN_HT40(chan))	{
 		if (ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
 			REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
 				  ATH9K_POW_SM(ratesArray[rateHt40_3], 24)
-				  | ATH9K_POW_SM(ratesArray[rateHt40_2],  16)
-				  | ATH9K_POW_SM(ratesArray[rateHt40_1],  8)
-				  | ATH9K_POW_SM(ratesArray[rateHt40_0],   0)
-				 );
+				  | ATH9K_POW_SM(ratesArray[rateHt40_2], 16)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_1], 8)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_0], 0));
 
 			REG_WRITE(ah, AR_PHY_POWER_TX_RATE8,
 				  ATH9K_POW_SM(ratesArray[rateHt40_7], 24)
-				  | ATH9K_POW_SM(ratesArray[rateHt40_6],  16)
-				  | ATH9K_POW_SM(ratesArray[rateHt40_5],  8)
-				  | ATH9K_POW_SM(ratesArray[rateHt40_4],   0)
-				 );
+				  | ATH9K_POW_SM(ratesArray[rateHt40_6], 16)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_5], 8)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_4], 0));
 		} else {
 			REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
 				  ATH9K_POW_SM(ratesArray[rateHt40_3] +
 					       ht40PowerIncForPdadc, 24)
 				  | ATH9K_POW_SM(ratesArray[rateHt40_2] +
-					       ht40PowerIncForPdadc,  16)
+						 ht40PowerIncForPdadc, 16)
 				  | ATH9K_POW_SM(ratesArray[rateHt40_1] +
-					       ht40PowerIncForPdadc,  8)
+						 ht40PowerIncForPdadc, 8)
 				  | ATH9K_POW_SM(ratesArray[rateHt40_0] +
-					       ht40PowerIncForPdadc,   0)
-				 );
+						 ht40PowerIncForPdadc, 0));
 
 			REG_WRITE(ah, AR_PHY_POWER_TX_RATE8,
 				  ATH9K_POW_SM(ratesArray[rateHt40_7] +
 					       ht40PowerIncForPdadc, 24)
 				  | ATH9K_POW_SM(ratesArray[rateHt40_6] +
-					       ht40PowerIncForPdadc,  16)
+						 ht40PowerIncForPdadc, 16)
 				  | ATH9K_POW_SM(ratesArray[rateHt40_5] +
-					       ht40PowerIncForPdadc,  8)
+						 ht40PowerIncForPdadc, 8)
 				  | ATH9K_POW_SM(ratesArray[rateHt40_4] +
-					       ht40PowerIncForPdadc,   0)
-				 );
-
+						 ht40PowerIncForPdadc, 0));
 		}
 
 		REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
-				ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
-				| ATH9K_POW_SM(ratesArray[rateExtCck],  16)
-				| ATH9K_POW_SM(ratesArray[rateDupOfdm],  8)
-				| ATH9K_POW_SM(ratesArray[rateDupCck],   0)
-			 );
+			  ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
+			  | ATH9K_POW_SM(ratesArray[rateExtCck], 16)
+			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
+			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
 	}
 
-
 	if (IS_CHAN_2GHZ(chan))
 		i = rate1l;
 	else
@@ -3840,7 +3837,7 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-				"Invalid chainmask configuration\n");
+			"Invalid chainmask configuration\n");
 		break;
 	}
 }
@@ -3848,7 +3845,6 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 static void ath9k_hw_AR9287_set_addac(struct ath_hw *ah,
 				      struct ath9k_channel *chan)
 {
-	return;
 }
 
 static void ath9k_hw_AR9287_set_board_values(struct ath_hw *ah,
@@ -3856,7 +3852,6 @@ static void ath9k_hw_AR9287_set_board_values(struct ath_hw *ah,
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
-
 	u16 antWrites[AR9287_ANT_16S];
 	u32 regChainOffset;
 	u8 txRxAttenLocal;
@@ -3886,7 +3881,6 @@ static void ath9k_hw_AR9287_set_board_values(struct ath_hw *ah,
 		antWrites[j++] = (u16)(pModal->antCtrlChain[i] & 0x3);
 	}
 
-
 	REG_WRITE(ah, AR_PHY_SWITCH_COM,
 		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
 
@@ -3899,11 +3893,11 @@ static void ath9k_hw_AR9287_set_board_values(struct ath_hw *ah,
 		REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset,
 			  (REG_READ(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset)
 			   & ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
-			   AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
-			   SM(pModal->iqCalICh[i],
-			      AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
-			   SM(pModal->iqCalQCh[i],
-			      AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
+			       AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
+			  SM(pModal->iqCalICh[i],
+			     AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
+			  SM(pModal->iqCalQCh[i],
+			     AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
 
 		txRxAttenLocal = pModal->txRxAttenCh[i];
 
@@ -3995,23 +3989,20 @@ static void ath9k_hw_AR9287_set_board_values(struct ath_hw *ah,
 }
 
 static u8 ath9k_hw_AR9287_get_num_ant_config(struct ath_hw *ah,
-		enum ieee80211_band freq_band)
+					     enum ieee80211_band freq_band)
 {
 	return 1;
 }
 
-
-
-
 static u16 ath9k_hw_AR9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
-		struct ath9k_channel *chan)
+						  struct ath9k_channel *chan)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
+
 	return pModal->antCtrlCommon & 0xFFFF;
 }
 
-
 static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
 					    u16 i, bool is2GHz)
 {
@@ -4020,8 +4011,8 @@ static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
 	u16 spur_val = AR_NO_SPUR;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
-			"Getting spur idx %d is2Ghz. %d val %x\n",
-			i, is2GHz, ah->config.spurchans[i][is2GHz]);
+		"Getting spur idx %d is2Ghz. %d val %x\n",
+		i, is2GHz, ah->config.spurchans[i][is2GHz]);
 
 	switch (ah->config.spurmode) {
 	case SPUR_DISABLE:
@@ -4055,10 +4046,10 @@ static struct eeprom_ops eep_AR9287_ops = {
 	.get_spur_channel	= ath9k_hw_AR9287_get_spur_channel
 };
 
-
 int ath9k_hw_eeprom_init(struct ath_hw *ah)
 {
 	int status;
+
 	if (AR_SREV_9287(ah)) {
 		ah->eep_map = EEP_MAP_AR9287;
 		ah->eep_ops = &eep_AR9287_ops;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index db77e90..a644709 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -385,106 +385,103 @@ struct calDataPerFreqOpLoop {
 } __packed;
 
 struct modal_eep_4k_header {
-	u32  antCtrlChain[AR5416_EEP4K_MAX_CHAINS];
-	u32  antCtrlCommon;
-	u8   antennaGainCh[AR5416_EEP4K_MAX_CHAINS];
-	u8   switchSettling;
-	u8   txRxAttenCh[AR5416_EEP4K_MAX_CHAINS];
-	u8   rxTxMarginCh[AR5416_EEP4K_MAX_CHAINS];
-	u8   adcDesiredSize;
-	u8   pgaDesiredSize;
-	u8   xlnaGainCh[AR5416_EEP4K_MAX_CHAINS];
-	u8   txEndToXpaOff;
-	u8   txEndToRxOn;
-	u8   txFrameToXpaOn;
-	u8   thresh62;
-	u8   noiseFloorThreshCh[AR5416_EEP4K_MAX_CHAINS];
-	u8   xpdGain;
-	u8   xpd;
-	u8   iqCalICh[AR5416_EEP4K_MAX_CHAINS];
-	u8   iqCalQCh[AR5416_EEP4K_MAX_CHAINS];
-	u8   pdGainOverlap;
-	u8   ob_01;
-	u8   db1_01;
-	u8   xpaBiasLvl;
-	u8   txFrameToDataStart;
-	u8   txFrameToPaOn;
-	u8   ht40PowerIncForPdadc;
-	u8   bswAtten[AR5416_EEP4K_MAX_CHAINS];
-	u8   bswMargin[AR5416_EEP4K_MAX_CHAINS];
-	u8   swSettleHt40;
-	u8   xatten2Db[AR5416_EEP4K_MAX_CHAINS];
-	u8   xatten2Margin[AR5416_EEP4K_MAX_CHAINS];
-	u8   db2_01;
-	u8   version;
-	u16  ob_234;
-	u16  db1_234;
-	u16  db2_234;
-	u8   futureModal[4];
-
+	u32 antCtrlChain[AR5416_EEP4K_MAX_CHAINS];
+	u32 antCtrlCommon;
+	u8 antennaGainCh[AR5416_EEP4K_MAX_CHAINS];
+	u8 switchSettling;
+	u8 txRxAttenCh[AR5416_EEP4K_MAX_CHAINS];
+	u8 rxTxMarginCh[AR5416_EEP4K_MAX_CHAINS];
+	u8 adcDesiredSize;
+	u8 pgaDesiredSize;
+	u8 xlnaGainCh[AR5416_EEP4K_MAX_CHAINS];
+	u8 txEndToXpaOff;
+	u8 txEndToRxOn;
+	u8 txFrameToXpaOn;
+	u8 thresh62;
+	u8 noiseFloorThreshCh[AR5416_EEP4K_MAX_CHAINS];
+	u8 xpdGain;
+	u8 xpd;
+	u8 iqCalICh[AR5416_EEP4K_MAX_CHAINS];
+	u8 iqCalQCh[AR5416_EEP4K_MAX_CHAINS];
+	u8 pdGainOverlap;
+	u8 ob_01;
+	u8 db1_01;
+	u8 xpaBiasLvl;
+	u8 txFrameToDataStart;
+	u8 txFrameToPaOn;
+	u8 ht40PowerIncForPdadc;
+	u8 bswAtten[AR5416_EEP4K_MAX_CHAINS];
+	u8 bswMargin[AR5416_EEP4K_MAX_CHAINS];
+	u8 swSettleHt40;
+	u8 xatten2Db[AR5416_EEP4K_MAX_CHAINS];
+	u8 xatten2Margin[AR5416_EEP4K_MAX_CHAINS];
+	u8 db2_01;
+	u8 version;
+	u16 ob_234;
+	u16 db1_234;
+	u16 db2_234;
+	u8 futureModal[4];
 	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
 } __packed;
 
 struct base_eep_ar9287_header {
-    u16  length;
-    u16  checksum;
-    u16  version;
-    u8 opCapFlags;
-    u8   eepMisc;
-    u16  regDmn[2];
-    u8   macAddr[6];
-    u8   rxMask;
-    u8   txMask;
-    u16  rfSilent;
-    u16  blueToothOptions;
-    u16  deviceCap;
-    u32  binBuildNumber;
-    u8   deviceType;
-    u8   openLoopPwrCntl;
-    int8_t    pwrTableOffset;
-    int8_t     tempSensSlope;
-    int8_t     tempSensSlopePalOn;
-    u8   futureBase[29];
+	u16 length;
+	u16 checksum;
+	u16 version;
+	u8 opCapFlags;
+	u8 eepMisc;
+	u16 regDmn[2];
+	u8 macAddr[6];
+	u8 rxMask;
+	u8 txMask;
+	u16 rfSilent;
+	u16 blueToothOptions;
+	u16 deviceCap;
+	u32 binBuildNumber;
+	u8 deviceType;
+	u8 openLoopPwrCntl;
+	int8_t pwrTableOffset;
+	int8_t tempSensSlope;
+	int8_t tempSensSlopePalOn;
+	u8 futureBase[29];
 } __packed;
 
 struct modal_eep_ar9287_header {
-    u32  antCtrlChain[AR9287_MAX_CHAINS];
-    u32  antCtrlCommon;
-    int8_t    antennaGainCh[AR9287_MAX_CHAINS];
-    u8   switchSettling;
-    u8   txRxAttenCh[AR9287_MAX_CHAINS];
-    u8   rxTxMarginCh[AR9287_MAX_CHAINS];
-    int8_t    adcDesiredSize;
-    u8   txEndToXpaOff;
-    u8   txEndToRxOn;
-    u8   txFrameToXpaOn;
-    u8   thresh62;
-    int8_t    noiseFloorThreshCh[AR9287_MAX_CHAINS];
-    u8   xpdGain;
-    u8   xpd;
-    int8_t    iqCalICh[AR9287_MAX_CHAINS];
-    int8_t    iqCalQCh[AR9287_MAX_CHAINS];
-    u8   pdGainOverlap;
-    u8   xpaBiasLvl;
-    u8   txFrameToDataStart;
-    u8   txFrameToPaOn;
-    u8   ht40PowerIncForPdadc;
-    u8   bswAtten[AR9287_MAX_CHAINS];
-    u8   bswMargin[AR9287_MAX_CHAINS];
-    u8   swSettleHt40;
-	u8   version;
-    u8   db1;
-    u8   db2;
-    u8   ob_cck;
-    u8   ob_psk;
-    u8   ob_qam;
-    u8   ob_pal_off;
-    u8   futureModal[30];
-    struct spur_chan spurChans[AR9287_EEPROM_MODAL_SPURS];
+	u32 antCtrlChain[AR9287_MAX_CHAINS];
+	u32 antCtrlCommon;
+	int8_t antennaGainCh[AR9287_MAX_CHAINS];
+	u8 switchSettling;
+	u8 txRxAttenCh[AR9287_MAX_CHAINS];
+	u8 rxTxMarginCh[AR9287_MAX_CHAINS];
+	int8_t adcDesiredSize;
+	u8 txEndToXpaOff;
+	u8 txEndToRxOn;
+	u8 txFrameToXpaOn;
+	u8 thresh62;
+	int8_t noiseFloorThreshCh[AR9287_MAX_CHAINS];
+	u8 xpdGain;
+	u8 xpd;
+	int8_t iqCalICh[AR9287_MAX_CHAINS];
+	int8_t iqCalQCh[AR9287_MAX_CHAINS];
+	u8 pdGainOverlap;
+	u8 xpaBiasLvl;
+	u8 txFrameToDataStart;
+	u8 txFrameToPaOn;
+	u8 ht40PowerIncForPdadc;
+	u8 bswAtten[AR9287_MAX_CHAINS];
+	u8 bswMargin[AR9287_MAX_CHAINS];
+	u8 swSettleHt40;
+	u8 version;
+	u8 db1;
+	u8 db2;
+	u8 ob_cck;
+	u8 ob_psk;
+	u8 ob_qam;
+	u8 ob_pal_off;
+	u8 futureModal[30];
+	struct spur_chan spurChans[AR9287_EEPROM_MODAL_SPURS];
 } __packed;
 
-
-
 struct cal_data_per_freq {
 	u8 pwrPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
 	u8 vpdPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
@@ -525,7 +522,6 @@ struct cal_data_op_loop_ar9287 {
 	u8 empty[2][5];
 } __packed;
 
-
 struct cal_data_per_freq_ar9287 {
 	u8 pwrPdg[AR9287_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
 	u8 vpdPdg[AR9287_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
@@ -601,26 +597,25 @@ struct ar5416_eeprom_4k {
 } __packed;
 
 struct ar9287_eeprom {
-	struct base_eep_ar9287_header  baseEepHeader;
+	struct base_eep_ar9287_header baseEepHeader;
 	u8 custData[AR9287_DATA_SZ];
 	struct modal_eep_ar9287_header modalHeader;
 	u8 calFreqPier2G[AR9287_NUM_2G_CAL_PIERS];
 	union cal_data_per_freq_ar9287_u
-	 calPierData2G[AR9287_MAX_CHAINS][AR9287_NUM_2G_CAL_PIERS];
+	calPierData2G[AR9287_MAX_CHAINS][AR9287_NUM_2G_CAL_PIERS];
 	struct cal_target_power_leg
-	 calTargetPowerCck[AR9287_NUM_2G_CCK_TARGET_POWERS];
+	calTargetPowerCck[AR9287_NUM_2G_CCK_TARGET_POWERS];
 	struct cal_target_power_leg
-	 calTargetPower2G[AR9287_NUM_2G_20_TARGET_POWERS];
+	calTargetPower2G[AR9287_NUM_2G_20_TARGET_POWERS];
 	struct cal_target_power_ht
-	 calTargetPower2GHT20[AR9287_NUM_2G_20_TARGET_POWERS];
+	calTargetPower2GHT20[AR9287_NUM_2G_20_TARGET_POWERS];
 	struct cal_target_power_ht
-	 calTargetPower2GHT40[AR9287_NUM_2G_40_TARGET_POWERS];
+	calTargetPower2GHT40[AR9287_NUM_2G_40_TARGET_POWERS];
 	u8 ctlIndex[AR9287_NUM_CTLS];
 	struct cal_ctl_data_ar9287 ctlData[AR9287_NUM_CTLS];
 	u8 padding;
 } __packed;
 
-
 enum reg_ext_bitmap {
 	REG_EXT_JAPAN_MIDBAND = 1,
 	REG_EXT_FCC_DFS_HT40 = 2,
-- 
1.6.4

