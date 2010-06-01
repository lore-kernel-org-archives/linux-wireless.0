Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41892 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab0FAJm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 05:42:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 02:42:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.54884.785914.327310@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:14:04 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/13] ath9k_hw: Cleanup eeprom_9287.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Fix whitespace damage.
* Remove unused debug messages.
* Introduce a macro NUM_EEP_WORDS.
* Convert AR9287 to lowercase in function names.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |  273 +++++++++++++-------------
 1 files changed, 136 insertions(+), 137 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index b471db5..5010cd1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -17,17 +17,19 @@
 #include "hw.h"
 #include "ar9002_phy.h"
 
-static int ath9k_hw_AR9287_get_eeprom_ver(struct ath_hw *ah)
+#define NUM_EEP_WORDS (sizeof(struct ar9287_eeprom) / sizeof(u16))
+
+static int ath9k_hw_ar9287_get_eeprom_ver(struct ath_hw *ah)
 {
 	return (ah->eeprom.map9287.baseEepHeader.version >> 12) & 0xF;
 }
 
-static int ath9k_hw_AR9287_get_eeprom_rev(struct ath_hw *ah)
+static int ath9k_hw_ar9287_get_eeprom_rev(struct ath_hw *ah)
 {
 	return (ah->eeprom.map9287.baseEepHeader.version) & 0xFFF;
 }
 
-static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
+static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -40,20 +42,20 @@ static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
 			  "Reading from EEPROM, not flash\n");
 	}
 
-	for (addr = 0; addr < sizeof(struct ar9287_eeprom) / sizeof(u16);
-			addr++)	{
-		if (!ath9k_hw_nvram_read(common,
-					 addr + eep_start_loc, eep_data)) {
+	for (addr = 0; addr < NUM_EEP_WORDS; addr++) {
+		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc,
+					 eep_data)) {
 			ath_print(common, ATH_DBG_EEPROM,
 				  "Unable to read eeprom region\n");
 			return false;
 		}
 		eep_data++;
 	}
+
 	return true;
 }
 
-static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
+static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 {
 	u32 sum = 0, el, integer;
 	u16 temp, word, magic, magic2, *eepdata;
@@ -63,8 +65,8 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!ath9k_hw_use_flash(ah)) {
-		if (!ath9k_hw_nvram_read(common,
-					 AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+		if (!ath9k_hw_nvram_read(common, AR5416_EEPROM_MAGIC_OFFSET,
+					 &magic)) {
 			ath_print(common, ATH_DBG_FATAL,
 				  "Reading Magic # failed\n");
 			return false;
@@ -72,6 +74,7 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 
 		ath_print(common, ATH_DBG_EEPROM,
 			  "Read Magic = 0x%04X\n", magic);
+
 		if (magic != AR5416_EEPROM_MAGIC) {
 			magic2 = swab16(magic);
 
@@ -79,9 +82,7 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 				need_swap = true;
 				eepdata = (u16 *)(&ah->eeprom);
 
-				for (addr = 0;
-				     addr < sizeof(struct ar9287_eeprom) / sizeof(u16);
-				     addr++) {
+				for (addr = 0; addr < NUM_EEP_WORDS; addr++) {
 					temp = swab16(*eepdata);
 					*eepdata = temp;
 					eepdata++;
@@ -89,13 +90,14 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 			} else {
 				ath_print(common, ATH_DBG_FATAL,
 					  "Invalid EEPROM Magic. "
-					  "endianness mismatch.\n");
+					  "Endianness mismatch.\n");
 				return -EINVAL;
 			}
 		}
 	}
-	ath_print(common, ATH_DBG_EEPROM, "need_swap = %s.\n", need_swap ?
-		  "True" : "False");
+
+	ath_print(common, ATH_DBG_EEPROM, "need_swap = %s.\n",
+		  need_swap ? "True" : "False");
 
 	if (need_swap)
 		el = swab16(ah->eeprom.map9287.baseEepHeader.length);
@@ -108,6 +110,7 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 		el = el / sizeof(u16);
 
 	eepdata = (u16 *)(&ah->eeprom);
+
 	for (i = 0; i < el; i++)
 		sum ^= *eepdata++;
 
@@ -161,7 +164,7 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 	return 0;
 }
 
-static u32 ath9k_hw_AR9287_get_eeprom(struct ath_hw *ah,
+static u32 ath9k_hw_ar9287_get_eeprom(struct ath_hw *ah,
 				      enum eeprom_param param)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
@@ -170,6 +173,7 @@ static u32 ath9k_hw_AR9287_get_eeprom(struct ath_hw *ah,
 	u16 ver_minor;
 
 	ver_minor = pBase->version & AR9287_EEP_VER_MINOR_MASK;
+
 	switch (param) {
 	case EEP_NFTHRESH_2:
 		return pModal->noiseFloorThreshCh[0];
@@ -214,29 +218,30 @@ static u32 ath9k_hw_AR9287_get_eeprom(struct ath_hw *ah,
 	}
 }
 
-
-static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
-				   struct ath9k_channel *chan,
-				   struct cal_data_per_freq_ar9287 *pRawDataSet,
-				   u8 *bChans,  u16 availPiers,
-				   u16 tPdGainOverlap, int16_t *pMinCalPower,
-				   u16 *pPdGainBoundaries, u8 *pPDADCValues,
-				   u16 numXpdGains)
+static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
+			       struct ath9k_channel *chan,
+			       struct cal_data_per_freq_ar9287 *pRawDataSet,
+			       u8 *bChans, u16 availPiers,
+			       u16 tPdGainOverlap,
+			       int16_t *pMinCalPower,
+			       u16 *pPdGainBoundaries,
+			       u8 *pPDADCValues,
+			       u16 numXpdGains)
 {
-#define TMP_VAL_VPD_TABLE \
+#define TMP_VAL_VPD_TABLE						\
 	((vpdTableI[i][sizeCurrVpdTable - 1] + (ss - maxIndex + 1) * vpdStep));
 
-	int       i, j, k;
-	int16_t   ss;
-	u16  idxL = 0, idxR = 0, numPiers;
-	u8   *pVpdL, *pVpdR, *pPwrL, *pPwrR;
-	u8   minPwrT4[AR9287_NUM_PD_GAINS];
-	u8   maxPwrT4[AR9287_NUM_PD_GAINS];
-	int16_t   vpdStep;
-	int16_t   tmpVal;
-	u16  sizeCurrVpdTable, maxIndex, tgtIndex;
-	bool    match;
-	int16_t  minDelta = 0;
+	int i, j, k;
+	int16_t ss;
+	u16 idxL = 0, idxR = 0, numPiers;
+	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
+	u8 minPwrT4[AR9287_NUM_PD_GAINS];
+	u8 maxPwrT4[AR9287_NUM_PD_GAINS];
+	int16_t vpdStep;
+	int16_t tmpVal;
+	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
+	bool match;
+	int16_t minDelta = 0;
 	struct chan_centers centers;
 	static u8 vpdTableL[AR5416_EEP4K_NUM_PD_GAINS]
 		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
@@ -253,18 +258,18 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 	}
 
 	match = ath9k_hw_get_lower_upper_index(
-				   (u8)FREQ2FBIN(centers.synth_center,
-				    IS_CHAN_2GHZ(chan)), bChans, numPiers,
-				    &idxL, &idxR);
+		(u8)FREQ2FBIN(centers.synth_center, IS_CHAN_2GHZ(chan)),
+		bChans, numPiers, &idxL, &idxR);
 
 	if (match) {
 		for (i = 0; i < numXpdGains; i++) {
 			minPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][0];
 			maxPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][4];
 			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-					pRawDataSet[idxL].pwrPdg[i],
-					pRawDataSet[idxL].vpdPdg[i],
-					AR9287_PD_GAIN_ICEPTS, vpdTableI[i]);
+						pRawDataSet[idxL].pwrPdg[i],
+						pRawDataSet[idxL].vpdPdg[i],
+						AR9287_PD_GAIN_ICEPTS,
+						vpdTableI[i]);
 		}
 	} else {
 		for (i = 0; i < numXpdGains; i++) {
@@ -275,41 +280,41 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 
 			minPwrT4[i] = max(pPwrL[0], pPwrR[0]);
 
-			maxPwrT4[i] =
-				min(pPwrL[AR9287_PD_GAIN_ICEPTS - 1],
-				    pPwrR[AR9287_PD_GAIN_ICEPTS - 1]);
+			maxPwrT4[i] = min(pPwrL[AR9287_PD_GAIN_ICEPTS - 1],
+					  pPwrR[AR9287_PD_GAIN_ICEPTS - 1]);
 
 			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-					pPwrL, pVpdL,
-					AR9287_PD_GAIN_ICEPTS,
-					vpdTableL[i]);
+						pPwrL, pVpdL,
+						AR9287_PD_GAIN_ICEPTS,
+						vpdTableL[i]);
 			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-					pPwrR, pVpdR,
-					AR9287_PD_GAIN_ICEPTS,
-					vpdTableR[i]);
+						pPwrR, pVpdR,
+						AR9287_PD_GAIN_ICEPTS,
+						vpdTableR[i]);
 
 			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
-				vpdTableI[i][j] =
-					(u8)(ath9k_hw_interpolate((u16)
-					FREQ2FBIN(centers. synth_center,
-					IS_CHAN_2GHZ(chan)),
-					bChans[idxL], bChans[idxR],
-					vpdTableL[i][j], vpdTableR[i][j]));
+				vpdTableI[i][j] = (u8)(ath9k_hw_interpolate(
+				       (u16)FREQ2FBIN(centers. synth_center,
+						      IS_CHAN_2GHZ(chan)),
+				       bChans[idxL], bChans[idxR],
+				       vpdTableL[i][j], vpdTableR[i][j]));
 			}
 		}
 	}
-	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
 
+	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
 	k = 0;
+
 	for (i = 0; i < numXpdGains; i++) {
 		if (i == (numXpdGains - 1))
-			pPdGainBoundaries[i] = (u16)(maxPwrT4[i] / 2);
+			pPdGainBoundaries[i] =
+				(u16)(maxPwrT4[i] / 2);
 		else
-			pPdGainBoundaries[i] = (u16)((maxPwrT4[i] +
-						      minPwrT4[i+1]) / 4);
+			pPdGainBoundaries[i] =
+				(u16)((maxPwrT4[i] + minPwrT4[i+1]) / 4);
 
 		pPdGainBoundaries[i] = min((u16)AR5416_MAX_RATE_POWER,
-					    pPdGainBoundaries[i]);
+					   pPdGainBoundaries[i]);
 
 
 		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
@@ -325,11 +330,12 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 				ss = 0;
 		} else
 			ss = (int16_t)((pPdGainBoundaries[i-1] -
-				       (minPwrT4[i] / 2)) -
+					(minPwrT4[i] / 2)) -
 				       tPdGainOverlap + 1 + minDelta);
 
 		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
 		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
+
 		while ((ss < 0) && (k < (AR9287_NUM_PDADC_VALUES - 1)))	{
 			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
 			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
@@ -348,12 +354,13 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
 				    vpdTableI[i][sizeCurrVpdTable - 2]);
 		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
+
 		if (tgtIndex > maxIndex) {
 			while ((ss <= tgtIndex) &&
 				(k < (AR9287_NUM_PDADC_VALUES - 1))) {
 				tmpVal = (int16_t) TMP_VAL_VPD_TABLE;
-				pPDADCValues[k++] = (u8)((tmpVal > 255) ?
-							  255 : tmpVal);
+				pPDADCValues[k++] =
+					(u8)((tmpVal > 255) ? 255 : tmpVal);
 				ss++;
 			}
 		}
@@ -375,10 +382,9 @@ static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 static void ar9287_eeprom_get_tx_gain_index(struct ath_hw *ah,
 			    struct ath9k_channel *chan,
 			    struct cal_data_op_loop_ar9287 *pRawDatasetOpLoop,
-			    u8 *pCalChans,  u16 availPiers,
-			    int8_t *pPwr)
+			    u8 *pCalChans,  u16 availPiers, int8_t *pPwr)
 {
-	u16  idxL = 0, idxR = 0, numPiers;
+	u16 idxL = 0, idxR = 0, numPiers;
 	bool match;
 	struct chan_centers centers;
 
@@ -391,14 +397,13 @@ static void ar9287_eeprom_get_tx_gain_index(struct ath_hw *ah,
 
 	match = ath9k_hw_get_lower_upper_index(
 			(u8)FREQ2FBIN(centers.synth_center, IS_CHAN_2GHZ(chan)),
-			pCalChans, numPiers,
-			&idxL, &idxR);
+			pCalChans, numPiers, &idxL, &idxR);
 
 	if (match) {
 		*pPwr = (int8_t) pRawDatasetOpLoop[idxL].pwrPdg[0][0];
 	} else {
 		*pPwr = ((int8_t) pRawDatasetOpLoop[idxL].pwrPdg[0][0] +
-			    (int8_t) pRawDatasetOpLoop[idxR].pwrPdg[0][0])/2;
+			 (int8_t) pRawDatasetOpLoop[idxR].pwrPdg[0][0])/2;
 	}
 
 }
@@ -409,16 +414,22 @@ static void ar9287_eeprom_olpc_set_pdadcs(struct ath_hw *ah,
 	u32 tmpVal;
 	u32 a;
 
+	/* Enable OLPC for chain 0 */
+
 	tmpVal = REG_READ(ah, 0xa270);
 	tmpVal = tmpVal & 0xFCFFFFFF;
 	tmpVal = tmpVal | (0x3 << 24);
 	REG_WRITE(ah, 0xa270, tmpVal);
 
+	/* Enable OLPC for chain 1 */
+
 	tmpVal = REG_READ(ah, 0xb270);
 	tmpVal = tmpVal & 0xFCFFFFFF;
 	tmpVal = tmpVal | (0x3 << 24);
 	REG_WRITE(ah, 0xb270, tmpVal);
 
+	/* Write the OLPC ref power for chain 0 */
+
 	if (chain == 0) {
 		tmpVal = REG_READ(ah, 0xa398);
 		tmpVal = tmpVal & 0xff00ffff;
@@ -427,6 +438,8 @@ static void ar9287_eeprom_olpc_set_pdadcs(struct ath_hw *ah,
 		REG_WRITE(ah, 0xa398, tmpVal);
 	}
 
+	/* Write the OLPC ref power for chain 1 */
+
 	if (chain == 1) {
 		tmpVal = REG_READ(ah, 0xb398);
 		tmpVal = tmpVal & 0xff00ffff;
@@ -436,26 +449,27 @@ static void ar9287_eeprom_olpc_set_pdadcs(struct ath_hw *ah,
 	}
 }
 
-static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
+static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 						struct ath9k_channel *chan,
 						int16_t *pTxPowerIndexOffset)
 {
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct cal_data_per_freq_ar9287 *pRawDataset;
 	struct cal_data_op_loop_ar9287 *pRawDatasetOpenLoop;
-	u8  *pCalBChans = NULL;
+	u8 *pCalBChans = NULL;
 	u16 pdGainOverlap_t2;
-	u8  pdadcValues[AR9287_NUM_PDADC_VALUES];
+	u8 pdadcValues[AR9287_NUM_PDADC_VALUES];
 	u16 gainBoundaries[AR9287_PD_GAINS_IN_MASK];
 	u16 numPiers = 0, i, j;
-	int16_t  tMinCalPower;
+	int16_t tMinCalPower;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR9287_NUM_PD_GAINS] = {0, 0, 0, 0};
 	u32 reg32, regOffset, regChainOffset;
-	int16_t   modalIdx, diff = 0;
+	int16_t modalIdx, diff = 0;
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
+
 	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
 	xpdMask = pEepData->modalHeader.xpdGain;
+
 	if ((pEepData->baseEepHeader.version & AR9287_EEP_VER_MINOR_MASK) >=
 			AR9287_EEP_MINOR_VER_2)
 		pdGainOverlap_t2 = pEepData->modalHeader.pdGainOverlap;
@@ -466,7 +480,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 	if (IS_CHAN_2GHZ(chan)) {
 		pCalBChans = pEepData->calFreqPier2G;
 		numPiers = AR9287_NUM_2G_CAL_PIERS;
-		if (ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
+		if (ath9k_hw_ar9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
 			pRawDatasetOpenLoop =
 				(struct cal_data_op_loop_ar9287 *)
 				pEepData->calPierData2G[0];
@@ -475,6 +489,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 	}
 
 	numXpdGain = 0;
+
 	for (i = 1; i <= AR9287_PD_GAINS_IN_MASK; i++) {
 		if ((xpdMask >> (AR9287_PD_GAINS_IN_MASK - i)) & 1) {
 			if (numXpdGain >= AR9287_NUM_PD_GAINS)
@@ -499,7 +514,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 		if (pEepData->baseEepHeader.txMask & (1 << i)) {
 			pRawDatasetOpenLoop = (struct cal_data_op_loop_ar9287 *)
 					       pEepData->calPierData2G[i];
-			if (ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
+			if (ath9k_hw_ar9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
 				int8_t txPower;
 				ar9287_eeprom_get_tx_gain_index(ah, chan,
 							  pRawDatasetOpenLoop,
@@ -510,7 +525,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 				pRawDataset =
 					(struct cal_data_per_freq_ar9287 *)
 					pEepData->calPierData2G[i];
-				ath9k_hw_get_AR9287_gain_boundaries_pdadcs(
+				ath9k_hw_get_ar9287_gain_boundaries_pdadcs(
 						  ah, chan, pRawDataset,
 						  pCalBChans, numPiers,
 						  pdGainOverlap_t2,
@@ -519,7 +534,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 			}
 
 			if (i == 0) {
-				if (!ath9k_hw_AR9287_get_eeprom(
+				if (!ath9k_hw_ar9287_get_eeprom(
 					    ah, EEP_OL_PWRCTRL)) {
 					REG_WRITE(ah, AR_PHY_TPCRG5 +
 					  regChainOffset,
@@ -555,7 +570,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 					  AR9287_NUM_PDADC_VALUES-diff];
 			}
 
-			if (!ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
+			if (!ath9k_hw_ar9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
 				regOffset = AR_PHY_BASE + (672 << 2) +
 							   regChainOffset;
 				for (j = 0; j < 32; j++) {
@@ -568,27 +583,6 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 						((pdadcValues[4*j + 3]
 						  & 0xFF) << 24) ;
 					REG_WRITE(ah, regOffset, reg32);
-
-					ath_print(common, ATH_DBG_EEPROM,
-						  "PDADC (%d,%4x): %4.4x "
-						  "%8.8x\n",
-						  i, regChainOffset, regOffset,
-						  reg32);
-
-					ath_print(common, ATH_DBG_EEPROM,
-						  "PDADC: Chain %d | "
-						  "PDADC %3d Value %3d | "
-						  "PDADC %3d Value %3d | "
-						  "PDADC %3d Value %3d | "
-						  "PDADC %3d Value %3d |\n",
-						  i, 4 * j, pdadcValues[4 * j],
-						  4 * j + 1,
-						  pdadcValues[4 * j + 1],
-						  4 * j + 2,
-						  pdadcValues[4 * j + 2],
-						  4 * j + 3,
-						  pdadcValues[4 * j + 3]);
-
 					regOffset += 4;
 				}
 			}
@@ -598,25 +592,29 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 	*pTxPowerIndexOffset = 0;
 }
 
-static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
-		struct ath9k_channel *chan, int16_t *ratesArray, u16 cfgCtl,
-		u16 AntennaReduction, u16 twiceMaxRegulatoryPower,
-		u16 powerLimit)
+static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
+						     struct ath9k_channel *chan,
+						     int16_t *ratesArray,
+						     u16 cfgCtl,
+						     u16 AntennaReduction,
+						     u16 twiceMaxRegulatoryPower,
+						     u16 powerLimit)
 {
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10
+
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
 		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
 	int i;
-	int16_t  twiceLargestAntenna;
+	int16_t twiceLargestAntenna;
 	struct cal_ctl_data_ar9287 *rep;
 	struct cal_target_power_leg targetPowerOfdm = {0, {0, 0, 0, 0} },
 				    targetPowerCck = {0, {0, 0, 0, 0} };
 	struct cal_target_power_leg targetPowerOfdmExt = {0, {0, 0, 0, 0} },
 				    targetPowerCckExt = {0, {0, 0, 0, 0} };
-	struct cal_target_power_ht  targetPowerHt20,
+	struct cal_target_power_ht targetPowerHt20,
 				    targetPowerHt40 = {0, {0, 0, 0, 0} };
 	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
 	u16 ctlModesFor11g[] =
@@ -634,8 +632,8 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 	twiceLargestAntenna = max(pEepData->modalHeader.antennaGainCh[0],
 				  pEepData->modalHeader.antennaGainCh[1]);
 
-	twiceLargestAntenna =  (int16_t)min((AntennaReduction) -
-					    twiceLargestAntenna, 0);
+	twiceLargestAntenna = (int16_t)min((AntennaReduction) -
+					   twiceLargestAntenna, 0);
 
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
 	if (regulatory->tp_scale != ATH9K_TP_SCALE_MAX)
@@ -659,6 +657,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 	if (IS_CHAN_2GHZ(chan))	{
 		numCtlModes =
 			ARRAY_SIZE(ctlModesFor11g) - SUB_NUM_CTL_MODES_AT_2G_40;
+
 		pCtlMode = ctlModesFor11g;
 
 		ath9k_hw_get_legacy_target_powers(ah, chan,
@@ -829,7 +828,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 #undef REDUCE_SCALED_POWER_BY_THREE_CHAIN
 }
 
-static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
+static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 					struct ath9k_channel *chan, u16 cfgCtl,
 					u8 twiceAntennaReduction,
 					u8 twiceMaxRegulatoryPower,
@@ -837,12 +836,13 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 {
 #define INCREASE_MAXPOW_BY_TWO_CHAIN     6
 #define INCREASE_MAXPOW_BY_THREE_CHAIN   10
+
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
-	int16_t  txPowerIndexOffset = 0;
+	int16_t txPowerIndexOffset = 0;
 	u8 ht40PowerIncForPdadc = 2;
 	int i;
 
@@ -852,13 +852,13 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 	    AR9287_EEP_MINOR_VER_2)
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 
-	ath9k_hw_set_AR9287_power_per_rate_table(ah, chan,
+	ath9k_hw_set_ar9287_power_per_rate_table(ah, chan,
 						 &ratesArray[0], cfgCtl,
 						 twiceAntennaReduction,
 						 twiceMaxRegulatoryPower,
 						 powerLimit);
 
-	ath9k_hw_set_AR9287_power_cal_table(ah, chan, &txPowerIndexOffset);
+	ath9k_hw_set_ar9287_power_cal_table(ah, chan, &txPowerIndexOffset);
 
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
 		ratesArray[i] = (int16_t)(txPowerIndexOffset + ratesArray[i]);
@@ -909,7 +909,7 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 		  | ATH9K_POW_SM(ratesArray[rateHt20_4], 0));
 
 	if (IS_CHAN_HT40(chan))	{
-		if (ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
+		if (ath9k_hw_ar9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
 			REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
 				  ATH9K_POW_SM(ratesArray[rateHt40_3], 24)
 				  | ATH9K_POW_SM(ratesArray[rateHt40_2], 16)
@@ -965,12 +965,10 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 	case 1:
 		break;
 	case 2:
-		regulatory->max_power_level +=
-			INCREASE_MAXPOW_BY_TWO_CHAIN;
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
 		break;
 	case 3:
-		regulatory->max_power_level +=
-			INCREASE_MAXPOW_BY_THREE_CHAIN;
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
 		break;
 	default:
 		ath_print(common, ATH_DBG_EEPROM,
@@ -979,12 +977,12 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 	}
 }
 
-static void ath9k_hw_AR9287_set_addac(struct ath_hw *ah,
+static void ath9k_hw_ar9287_set_addac(struct ath_hw *ah,
 				      struct ath9k_channel *chan)
 {
 }
 
-static void ath9k_hw_AR9287_set_board_values(struct ath_hw *ah,
+static void ath9k_hw_ar9287_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
@@ -1125,13 +1123,13 @@ static void ath9k_hw_AR9287_set_board_values(struct ath_hw *ah,
 				  pModal->xpaBiasLvl);
 }
 
-static u8 ath9k_hw_AR9287_get_num_ant_config(struct ath_hw *ah,
+static u8 ath9k_hw_ar9287_get_num_ant_config(struct ath_hw *ah,
 					     enum ieee80211_band freq_band)
 {
 	return 1;
 }
 
-static u16 ath9k_hw_AR9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
+static u16 ath9k_hw_ar9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
 						  struct ath9k_channel *chan)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
@@ -1140,11 +1138,12 @@ static u16 ath9k_hw_AR9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
 	return pModal->antCtrlCommon & 0xFFFF;
 }
 
-static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
+static u16 ath9k_hw_ar9287_get_spur_channel(struct ath_hw *ah,
 					    u16 i, bool is2GHz)
 {
 #define EEP_MAP9287_SPURCHAN \
 	(ah->eeprom.map9287.modalHeader.spurChans[i].spurChan)
+
 	struct ath_common *common = ath9k_hw_common(ah);
 	u16 spur_val = AR_NO_SPUR;
 
@@ -1171,15 +1170,15 @@ static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
 }
 
 const struct eeprom_ops eep_ar9287_ops = {
-	.check_eeprom		= ath9k_hw_AR9287_check_eeprom,
-	.get_eeprom		= ath9k_hw_AR9287_get_eeprom,
-	.fill_eeprom		= ath9k_hw_AR9287_fill_eeprom,
-	.get_eeprom_ver		= ath9k_hw_AR9287_get_eeprom_ver,
-	.get_eeprom_rev		= ath9k_hw_AR9287_get_eeprom_rev,
-	.get_num_ant_config	= ath9k_hw_AR9287_get_num_ant_config,
-	.get_eeprom_antenna_cfg	= ath9k_hw_AR9287_get_eeprom_antenna_cfg,
-	.set_board_values	= ath9k_hw_AR9287_set_board_values,
-	.set_addac		= ath9k_hw_AR9287_set_addac,
-	.set_txpower		= ath9k_hw_AR9287_set_txpower,
-	.get_spur_channel	= ath9k_hw_AR9287_get_spur_channel
+	.check_eeprom		= ath9k_hw_ar9287_check_eeprom,
+	.get_eeprom		= ath9k_hw_ar9287_get_eeprom,
+	.fill_eeprom		= ath9k_hw_ar9287_fill_eeprom,
+	.get_eeprom_ver		= ath9k_hw_ar9287_get_eeprom_ver,
+	.get_eeprom_rev		= ath9k_hw_ar9287_get_eeprom_rev,
+	.get_num_ant_config	= ath9k_hw_ar9287_get_num_ant_config,
+	.get_eeprom_antenna_cfg	= ath9k_hw_ar9287_get_eeprom_antenna_cfg,
+	.set_board_values	= ath9k_hw_ar9287_set_board_values,
+	.set_addac		= ath9k_hw_ar9287_set_addac,
+	.set_txpower		= ath9k_hw_ar9287_set_txpower,
+	.get_spur_channel	= ath9k_hw_ar9287_get_spur_channel
 };
-- 
1.7.1

