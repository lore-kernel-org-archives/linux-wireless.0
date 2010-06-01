Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41893 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab0FAJm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 05:42:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 02:42:58 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.54887.569783.322877@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:14:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/13] ath9k_hw: Cleanup TX power calculation for AR9287
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Add a few comments, and move the updation of max_power_level
  to a helper routine. This is also done by non-4K based chipsets,
  this will be fixed in a separate patch.

* Remove two WARs which are required for old AR5416 chipsets,
  and are not needed for AR9287.

* Fix indentation and make things readable.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c      |   21 ++
 drivers/net/wireless/ath/ath9k/eeprom.h      |    1 +
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |  287 +++++++++++++-------------
 3 files changed, 168 insertions(+), 141 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index a29b2d9..1266333 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -258,6 +258,27 @@ u16 ath9k_hw_get_max_edge_power(u16 freq, struct cal_ctl_edges *pRdEdgesPower,
 	return twiceMaxEdgePower;
 }
 
+void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+
+	switch (ar5416_get_ntxchains(ah->txchainmask)) {
+	case 1:
+		break;
+	case 2:
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
+		break;
+	case 3:
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
+		break;
+	default:
+		ath_print(common, ATH_DBG_EEPROM,
+			  "Invalid chainmask configuration\n");
+		break;
+	}
+}
+
 int ath9k_hw_eeprom_init(struct ath_hw *ah)
 {
 	int status;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 14186f2..7da7d73 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -705,6 +705,7 @@ void ath9k_hw_get_target_powers(struct ath_hw *ah,
 				u16 numRates, bool isHt40Target);
 u16 ath9k_hw_get_max_edge_power(u16 freq, struct cal_ctl_edges *pRdEdgesPower,
 				bool is2GHz, int num_band_edges);
+void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah);
 int ath9k_hw_eeprom_init(struct ath_hw *ah);
 
 #define ar5416_get_ntxchains(_txchainmask)			\
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 27abfba..5f3b20b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -317,21 +317,18 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 					   pPdGainBoundaries[i]);
 
 
-		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
-			minDelta = pPdGainBoundaries[0] - 23;
-			pPdGainBoundaries[0] = 23;
-		} else
-			minDelta = 0;
+		minDelta = 0;
 
 		if (i == 0) {
 			if (AR_SREV_9280_10_OR_LATER(ah))
 				ss = (int16_t)(0 - (minPwrT4[i] / 2));
 			else
 				ss = 0;
-		} else
+		} else {
 			ss = (int16_t)((pPdGainBoundaries[i-1] -
 					(minPwrT4[i] / 2)) -
 				       tPdGainOverlap + 1 + minDelta);
+		}
 
 		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
 		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
@@ -396,8 +393,8 @@ static void ar9287_eeprom_get_tx_gain_index(struct ath_hw *ah,
 	}
 
 	match = ath9k_hw_get_lower_upper_index(
-			(u8)FREQ2FBIN(centers.synth_center, IS_CHAN_2GHZ(chan)),
-			pCalChans, numPiers, &idxL, &idxR);
+		(u8)FREQ2FBIN(centers.synth_center, IS_CHAN_2GHZ(chan)),
+		pCalChans, numPiers, &idxL, &idxR);
 
 	if (match) {
 		*pPwr = (int8_t) pRawDatasetOpLoop[idxL].pwrPdg[0][0];
@@ -463,7 +460,7 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 	int16_t tMinCalPower;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR9287_NUM_PD_GAINS] = {0, 0, 0, 0};
-	u32 reg32, regOffset, regChainOffset;
+	u32 reg32, regOffset, regChainOffset, regval;
 	int16_t modalIdx, diff = 0;
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 
@@ -471,7 +468,7 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 	xpdMask = pEepData->modalHeader.xpdGain;
 
 	if ((pEepData->baseEepHeader.version & AR9287_EEP_VER_MINOR_MASK) >=
-			AR9287_EEP_MINOR_VER_2)
+	    AR9287_EEP_MINOR_VER_2)
 		pdGainOverlap_t2 = pEepData->modalHeader.pdGainOverlap;
 	else
 		pdGainOverlap_t2 = (u16)(MS(REG_READ(ah, AR_PHY_TPCRG5),
@@ -482,14 +479,14 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 		numPiers = AR9287_NUM_2G_CAL_PIERS;
 		if (ath9k_hw_ar9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
 			pRawDatasetOpenLoop =
-				(struct cal_data_op_loop_ar9287 *)
-				pEepData->calPierData2G[0];
+			(struct cal_data_op_loop_ar9287 *)pEepData->calPierData2G[0];
 			ah->initPDADC = pRawDatasetOpenLoop->vpdPdg[0][0];
 		}
 	}
 
 	numXpdGain = 0;
 
+	/* Calculate the value of xpdgains from the xpdGain Mask */
 	for (i = 1; i <= AR9287_PD_GAINS_IN_MASK; i++) {
 		if ((xpdMask >> (AR9287_PD_GAINS_IN_MASK - i)) & 1) {
 			if (numXpdGain >= AR9287_NUM_PD_GAINS)
@@ -511,77 +508,79 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 
 	for (i = 0; i < AR9287_MAX_CHAINS; i++)	{
 		regChainOffset = i * 0x1000;
+
 		if (pEepData->baseEepHeader.txMask & (1 << i)) {
-			pRawDatasetOpenLoop = (struct cal_data_op_loop_ar9287 *)
-					       pEepData->calPierData2G[i];
+			pRawDatasetOpenLoop =
+			(struct cal_data_op_loop_ar9287 *)pEepData->calPierData2G[i];
+
 			if (ath9k_hw_ar9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
 				int8_t txPower;
 				ar9287_eeprom_get_tx_gain_index(ah, chan,
-							  pRawDatasetOpenLoop,
-							  pCalBChans, numPiers,
-							  &txPower);
+							pRawDatasetOpenLoop,
+							pCalBChans, numPiers,
+							&txPower);
 				ar9287_eeprom_olpc_set_pdadcs(ah, txPower, i);
 			} else {
 				pRawDataset =
 					(struct cal_data_per_freq_ar9287 *)
 					pEepData->calPierData2G[i];
-				ath9k_hw_get_ar9287_gain_boundaries_pdadcs(
-						  ah, chan, pRawDataset,
-						  pCalBChans, numPiers,
-						  pdGainOverlap_t2,
-						  &tMinCalPower, gainBoundaries,
-						  pdadcValues, numXpdGain);
+
+				ath9k_hw_get_ar9287_gain_boundaries_pdadcs(ah, chan,
+							   pRawDataset,
+							   pCalBChans, numPiers,
+							   pdGainOverlap_t2,
+							   &tMinCalPower,
+							   gainBoundaries,
+							   pdadcValues,
+							   numXpdGain);
 			}
 
 			if (i == 0) {
-				if (!ath9k_hw_ar9287_get_eeprom(
-					    ah, EEP_OL_PWRCTRL)) {
-					REG_WRITE(ah, AR_PHY_TPCRG5 +
-					  regChainOffset,
-					  SM(pdGainOverlap_t2,
-					     AR_PHY_TPCRG5_PD_GAIN_OVERLAP) |
-					  SM(gainBoundaries[0],
-					     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
-					  | SM(gainBoundaries[1],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
-					  | SM(gainBoundaries[2],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
-					  | SM(gainBoundaries[3],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
+				if (!ath9k_hw_ar9287_get_eeprom(ah,
+							EEP_OL_PWRCTRL)) {
+
+					regval = SM(pdGainOverlap_t2,
+						    AR_PHY_TPCRG5_PD_GAIN_OVERLAP)
+						| SM(gainBoundaries[0],
+						     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
+						| SM(gainBoundaries[1],
+						     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
+						| SM(gainBoundaries[2],
+						     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
+						| SM(gainBoundaries[3],
+						     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4);
+
+					REG_WRITE(ah,
+						  AR_PHY_TPCRG5 + regChainOffset,
+						  regval);
 				}
 			}
 
 			if ((int32_t)AR9287_PWR_TABLE_OFFSET_DB !=
-				     pEepData->baseEepHeader.pwrTableOffset) {
-				diff = (u16)
-				       (pEepData->baseEepHeader.pwrTableOffset
-					- (int32_t)AR9287_PWR_TABLE_OFFSET_DB);
+			    pEepData->baseEepHeader.pwrTableOffset) {
+				diff = (u16)(pEepData->baseEepHeader.pwrTableOffset -
+					     (int32_t)AR9287_PWR_TABLE_OFFSET_DB);
 				diff *= 2;
 
-				for (j = 0;
-				     j < ((u16)AR9287_NUM_PDADC_VALUES-diff);
-				     j++)
+				for (j = 0; j < ((u16)AR9287_NUM_PDADC_VALUES-diff); j++)
 					pdadcValues[j] = pdadcValues[j+diff];
 
 				for (j = (u16)(AR9287_NUM_PDADC_VALUES-diff);
 				     j < AR9287_NUM_PDADC_VALUES; j++)
 					pdadcValues[j] =
-					  pdadcValues[
-					  AR9287_NUM_PDADC_VALUES-diff];
+					  pdadcValues[AR9287_NUM_PDADC_VALUES-diff];
 			}
 
 			if (!ath9k_hw_ar9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
-				regOffset = AR_PHY_BASE + (672 << 2) +
-							   regChainOffset;
+				regOffset = AR_PHY_BASE +
+					(672 << 2) + regChainOffset;
+
 				for (j = 0; j < 32; j++) {
-					reg32 = ((pdadcValues[4*j + 0]
-						  & 0xFF) << 0)  |
-						((pdadcValues[4*j + 1]
-						  & 0xFF) << 8)  |
-						((pdadcValues[4*j + 2]
-						  & 0xFF) << 16) |
-						((pdadcValues[4*j + 3]
-						  & 0xFF) << 24) ;
+					reg32 = ((pdadcValues[4*j + 0] & 0xFF) << 0)
+						| ((pdadcValues[4*j + 1] & 0xFF) << 8)
+						| ((pdadcValues[4*j + 2] & 0xFF) << 16)
+						| ((pdadcValues[4*j + 3] & 0xFF) << 24);
+
 					REG_WRITE(ah, regOffset, reg32);
 					regOffset += 4;
 				}
@@ -600,6 +599,14 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 						     u16 twiceMaxRegulatoryPower,
 						     u16 powerLimit)
 {
+#define CMP_CTL \
+	(((cfgCtl & ~CTL_MODE_M) | (pCtlMode[ctlMode] & CTL_MODE_M)) == \
+	 pEepData->ctlIndex[i])
+
+#define CMP_NO_CTL \
+	(((cfgCtl & ~CTL_MODE_M) | (pCtlMode[ctlMode] & CTL_MODE_M)) == \
+	 ((pEepData->ctlIndex[i] & CTL_MODE_M) | SD_NO_CTL))
+
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10
 
@@ -617,9 +624,12 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 	struct cal_target_power_ht targetPowerHt20,
 				    targetPowerHt40 = {0, {0, 0, 0, 0} };
 	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
-	u16 ctlModesFor11g[] =
-		{CTL_11B, CTL_11G, CTL_2GHT20,
-		 CTL_11B_EXT, CTL_11G_EXT, CTL_2GHT40};
+	u16 ctlModesFor11g[] = {CTL_11B,
+				CTL_11G,
+				CTL_2GHT20,
+				CTL_11B_EXT,
+				CTL_11G_EXT,
+				CTL_2GHT40};
 	u16 numCtlModes = 0, *pCtlMode = NULL, ctlMode, freq;
 	struct chan_centers centers;
 	int tx_chainmask;
@@ -629,19 +639,28 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
+	/* Compute TxPower reduction due to Antenna Gain */
 	twiceLargestAntenna = max(pEepData->modalHeader.antennaGainCh[0],
 				  pEepData->modalHeader.antennaGainCh[1]);
-
 	twiceLargestAntenna = (int16_t)min((AntennaReduction) -
 					   twiceLargestAntenna, 0);
 
+	/*
+	 * scaledPower is the minimum of the user input power level
+	 * and the regulatory allowed power level.
+	 */
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
+
 	if (regulatory->tp_scale != ATH9K_TP_SCALE_MAX)
 		maxRegAllowedPower -=
 			(tpScaleReductionTable[(regulatory->tp_scale)] * 2);
 
 	scaledPower = min(powerLimit, maxRegAllowedPower);
 
+	/*
+	 * Reduce scaled Power by number of chains active
+	 * to get the per chain tx power level.
+	 */
 	switch (ar5416_get_ntxchains(tx_chainmask)) {
 	case 1:
 		break;
@@ -654,7 +673,11 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 	}
 	scaledPower = max((u16)0, scaledPower);
 
+	/*
+	 * Get TX power from EEPROM.
+	 */
 	if (IS_CHAN_2GHZ(chan))	{
+		/* CTL_11B, CTL_11G, CTL_2GHT20 */
 		numCtlModes =
 			ARRAY_SIZE(ctlModesFor11g) - SUB_NUM_CTL_MODES_AT_2G_40;
 
@@ -674,6 +697,7 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 					   &targetPowerHt20, 8, false);
 
 		if (IS_CHAN_HT40(chan))	{
+			/* All 2G CTLs */
 			numCtlModes = ARRAY_SIZE(ctlModesFor11g);
 			ath9k_hw_get_target_powers(ah, chan,
 						   pEepData->calTargetPower2GHT40,
@@ -691,8 +715,9 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 	}
 
 	for (ctlMode = 0; ctlMode < numCtlModes; ctlMode++) {
-		bool isHt40CtlMode = (pCtlMode[ctlMode] == CTL_5GHT40) ||
-				     (pCtlMode[ctlMode] == CTL_2GHT40);
+		bool isHt40CtlMode =
+			(pCtlMode[ctlMode] == CTL_2GHT40) ? true : false;
+
 		if (isHt40CtlMode)
 			freq = centers.synth_center;
 		else if (pCtlMode[ctlMode] & EXT_ADDITIVE)
@@ -700,31 +725,28 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 		else
 			freq = centers.ctl_center;
 
-		if (ah->eep_ops->get_eeprom_ver(ah) == 14 &&
-		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
-			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
-
+		/* Walk through the CTL indices stored in EEPROM */
 		for (i = 0; (i < AR9287_NUM_CTLS) && pEepData->ctlIndex[i]; i++) {
-			if ((((cfgCtl & ~CTL_MODE_M) |
-			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
-			     pEepData->ctlIndex[i]) ||
-			    (((cfgCtl & ~CTL_MODE_M) |
-			      (pCtlMode[ctlMode] & CTL_MODE_M)) ==
-			     ((pEepData->ctlIndex[i] &
-			       CTL_MODE_M) | SD_NO_CTL))) {
+			struct cal_ctl_edges *pRdEdgesPower;
 
+			/*
+			 * Compare test group from regulatory channel list
+			 * with test mode from pCtlMode list
+			 */
+			if (CMP_CTL || CMP_NO_CTL) {
 				rep = &(pEepData->ctlData[i]);
-				twiceMinEdgePower = ath9k_hw_get_max_edge_power(
-				    freq,
-				    rep->ctlEdges[ar5416_get_ntxchains(
-				    tx_chainmask) - 1],
-				    IS_CHAN_2GHZ(chan), AR5416_NUM_BAND_EDGES);
-
-				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL)
-					twiceMaxEdgePower = min(
-							    twiceMaxEdgePower,
-							    twiceMinEdgePower);
-				else {
+				pRdEdgesPower =
+				rep->ctlEdges[ar5416_get_ntxchains(tx_chainmask) - 1];
+
+				twiceMinEdgePower = ath9k_hw_get_max_edge_power(freq,
+								pRdEdgesPower,
+								IS_CHAN_2GHZ(chan),
+								AR5416_NUM_BAND_EDGES);
+
+				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL) {
+					twiceMaxEdgePower = min(twiceMaxEdgePower,
+								twiceMinEdgePower);
+				} else {
 					twiceMaxEdgePower = twiceMinEdgePower;
 					break;
 				}
@@ -733,55 +755,48 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 
 		minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
 
+		/* Apply ctl mode to correct target power set */
 		switch (pCtlMode[ctlMode]) {
 		case CTL_11B:
-			for (i = 0;
-			     i < ARRAY_SIZE(targetPowerCck.tPow2x);
-			     i++) {
-				targetPowerCck.tPow2x[i] = (u8)min(
-					(u16)targetPowerCck.tPow2x[i],
-					minCtlPower);
+			for (i = 0; i < ARRAY_SIZE(targetPowerCck.tPow2x); i++) {
+				targetPowerCck.tPow2x[i] =
+					(u8)min((u16)targetPowerCck.tPow2x[i],
+						minCtlPower);
 			}
 			break;
 		case CTL_11A:
 		case CTL_11G:
-			for (i = 0;
-			     i < ARRAY_SIZE(targetPowerOfdm.tPow2x);
-			     i++) {
-				targetPowerOfdm.tPow2x[i] = (u8)min(
-					(u16)targetPowerOfdm.tPow2x[i],
-					minCtlPower);
+			for (i = 0; i < ARRAY_SIZE(targetPowerOfdm.tPow2x); i++) {
+				targetPowerOfdm.tPow2x[i] =
+					(u8)min((u16)targetPowerOfdm.tPow2x[i],
+						minCtlPower);
 			}
 			break;
 		case CTL_5GHT20:
 		case CTL_2GHT20:
-			for (i = 0;
-			     i < ARRAY_SIZE(targetPowerHt20.tPow2x);
-			     i++) {
-				targetPowerHt20.tPow2x[i] = (u8)min(
-					(u16)targetPowerHt20.tPow2x[i],
-					minCtlPower);
+			for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x); i++) {
+				targetPowerHt20.tPow2x[i] =
+					(u8)min((u16)targetPowerHt20.tPow2x[i],
+						minCtlPower);
 			}
 			break;
 		case CTL_11B_EXT:
-			targetPowerCckExt.tPow2x[0] = (u8)min(
-				    (u16)targetPowerCckExt.tPow2x[0],
-				    minCtlPower);
+			targetPowerCckExt.tPow2x[0] =
+				(u8)min((u16)targetPowerCckExt.tPow2x[0],
+					minCtlPower);
 			break;
 		case CTL_11A_EXT:
 		case CTL_11G_EXT:
-			targetPowerOfdmExt.tPow2x[0] = (u8)min(
-				    (u16)targetPowerOfdmExt.tPow2x[0],
-				    minCtlPower);
+			targetPowerOfdmExt.tPow2x[0] =
+				(u8)min((u16)targetPowerOfdmExt.tPow2x[0],
+					minCtlPower);
 			break;
 		case CTL_5GHT40:
 		case CTL_2GHT40:
-			for (i = 0;
-			     i < ARRAY_SIZE(targetPowerHt40.tPow2x);
-			     i++) {
-				targetPowerHt40.tPow2x[i] = (u8)min(
-					(u16)targetPowerHt40.tPow2x[i],
-					minCtlPower);
+			for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++) {
+				targetPowerHt40.tPow2x[i] =
+					(u8)min((u16)targetPowerHt40.tPow2x[i],
+						minCtlPower);
 			}
 			break;
 		default:
@@ -789,12 +804,13 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 		}
 	}
 
+	/* Now set the rates array */
+
 	ratesArray[rate6mb] =
 	ratesArray[rate9mb] =
 	ratesArray[rate12mb] =
 	ratesArray[rate18mb] =
-	ratesArray[rate24mb] =
-	targetPowerOfdm.tPow2x[0];
+	ratesArray[rate24mb] = targetPowerOfdm.tPow2x[0];
 
 	ratesArray[rate36mb] = targetPowerOfdm.tPow2x[1];
 	ratesArray[rate48mb] = targetPowerOfdm.tPow2x[2];
@@ -806,12 +822,12 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 
 	if (IS_CHAN_2GHZ(chan))	{
 		ratesArray[rate1l] = targetPowerCck.tPow2x[0];
-		ratesArray[rate2s] = ratesArray[rate2l] =
-			targetPowerCck.tPow2x[1];
-		ratesArray[rate5_5s] = ratesArray[rate5_5l] =
-			targetPowerCck.tPow2x[2];
-		ratesArray[rate11s] = ratesArray[rate11l] =
-			targetPowerCck.tPow2x[3];
+		ratesArray[rate2s] =
+		ratesArray[rate2l] = targetPowerCck.tPow2x[1];
+		ratesArray[rate5_5s] =
+		ratesArray[rate5_5l] = targetPowerCck.tPow2x[2];
+		ratesArray[rate11s] =
+		ratesArray[rate11l] = targetPowerCck.tPow2x[3];
 	}
 	if (IS_CHAN_HT40(chan))	{
 		for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++)
@@ -820,10 +836,13 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 		ratesArray[rateDupOfdm] = targetPowerHt40.tPow2x[0];
 		ratesArray[rateDupCck]  = targetPowerHt40.tPow2x[0];
 		ratesArray[rateExtOfdm] = targetPowerOfdmExt.tPow2x[0];
+
 		if (IS_CHAN_2GHZ(chan))
 			ratesArray[rateExtCck] = targetPowerCckExt.tPow2x[0];
 	}
 
+#undef CMP_CTL
+#undef CMP_NO_CTL
 #undef REDUCE_SCALED_POWER_BY_TWO_CHAIN
 #undef REDUCE_SCALED_POWER_BY_THREE_CHAIN
 }
@@ -834,10 +853,6 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 					u8 twiceMaxRegulatoryPower,
 					u8 powerLimit)
 {
-#define INCREASE_MAXPOW_BY_TWO_CHAIN     6
-#define INCREASE_MAXPOW_BY_THREE_CHAIN   10
-
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
@@ -871,6 +886,7 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 			ratesArray[i] -= AR9287_PWR_TABLE_OFFSET_DB * 2;
 	}
 
+	/* OFDM power per rate */
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
 		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
 		  | ATH9K_POW_SM(ratesArray[rate12mb], 16)
@@ -883,6 +899,7 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 		  | ATH9K_POW_SM(ratesArray[rate36mb], 8)
 		  | ATH9K_POW_SM(ratesArray[rate24mb], 0));
 
+	/* CCK power per rate */
 	if (IS_CHAN_2GHZ(chan))	{
 		REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
 			  ATH9K_POW_SM(ratesArray[rate2s], 24)
@@ -896,6 +913,7 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 			  | ATH9K_POW_SM(ratesArray[rate5_5l], 0));
 	}
 
+	/* HT20 power per rate */
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE5,
 		  ATH9K_POW_SM(ratesArray[rateHt20_3], 24)
 		  | ATH9K_POW_SM(ratesArray[rateHt20_2], 16)
@@ -908,6 +926,7 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 		  | ATH9K_POW_SM(ratesArray[rateHt20_5], 8)
 		  | ATH9K_POW_SM(ratesArray[rateHt20_4], 0));
 
+	/* HT40 power per rate */
 	if (IS_CHAN_HT40(chan))	{
 		if (ath9k_hw_ar9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
 			REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
@@ -943,6 +962,7 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 						 ht40PowerIncForPdadc, 0));
 		}
 
+		/* Dup/Ext power per rate */
 		REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
 			  ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
 			  | ATH9K_POW_SM(ratesArray[rateExtCck], 16)
@@ -960,21 +980,6 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 			ratesArray[i] + AR9287_PWR_TABLE_OFFSET_DB * 2;
 	else
 		regulatory->max_power_level = ratesArray[i];
-
-	switch (ar5416_get_ntxchains(ah->txchainmask)) {
-	case 1:
-		break;
-	case 2:
-		regulatory->max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
-		break;
-	case 3:
-		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
-		break;
-	default:
-		ath_print(common, ATH_DBG_EEPROM,
-			  "Invalid chainmask configuration\n");
-		break;
-	}
 }
 
 static void ath9k_hw_ar9287_set_addac(struct ath_hw *ah,
-- 
1.7.1

