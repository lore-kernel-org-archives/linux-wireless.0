Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42429 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab0LKXvh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 18:51:37 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 4/8] ath9k_hw: merge the ar9287 version of ath9k_hw_get_gain_boundaries_pdadcs
Date: Sun, 12 Dec 2010 00:51:10 +0100
Message-Id: <1292111474-70939-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292111474-70939-3-git-send-email-nbd@openwrt.org>
References: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
 <1292111474-70939-2-git-send-email-nbd@openwrt.org>
 <1292111474-70939-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also add a comment about a potential array overrun that needs to
be reviewed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c      |   39 +++++--
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |  159 +-------------------------
 2 files changed, 32 insertions(+), 166 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index d54cfa4..d051631 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -309,7 +309,14 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 	int pdgain_boundary_default;
 	struct cal_data_per_freq *data_def = pRawDataSet;
 	struct cal_data_per_freq_4k *data_4k = pRawDataSet;
+	struct cal_data_per_freq_ar9287 *data_9287 = pRawDataSet;
 	bool eeprom_4k = AR_SREV_9285(ah) || AR_SREV_9271(ah);
+	int intercepts;
+
+	if (AR_SREV_9287(ah))
+		intercepts = AR9287_PD_GAIN_ICEPTS;
+	else
+		intercepts = AR5416_PD_GAIN_ICEPTS;
 
 	memset(&minPwrT4, 0, AR5416_NUM_PD_GAINS);
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
@@ -324,14 +331,25 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 					       bChans, numPiers, &idxL, &idxR);
 
 	if (match) {
-		if (eeprom_4k) {
+		if (AR_SREV_9287(ah)) {
+			/* FIXME: array overrun? */
+			for (i = 0; i < numXpdGains; i++) {
+				minPwrT4[i] = data_9287[idxL].pwrPdg[i][0];
+				maxPwrT4[i] = data_9287[idxL].pwrPdg[i][4];
+				ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+						data_9287[idxL].pwrPdg[i],
+						data_9287[idxL].vpdPdg[i],
+						intercepts,
+						vpdTableI[i]);
+			}
+		} else if (eeprom_4k) {
 			for (i = 0; i < numXpdGains; i++) {
 				minPwrT4[i] = data_4k[idxL].pwrPdg[i][0];
 				maxPwrT4[i] = data_4k[idxL].pwrPdg[i][4];
 				ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 						data_4k[idxL].pwrPdg[i],
 						data_4k[idxL].vpdPdg[i],
-						AR5416_PD_GAIN_ICEPTS,
+						intercepts,
 						vpdTableI[i]);
 			}
 		} else {
@@ -341,13 +359,18 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 				ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 						data_def[idxL].pwrPdg[i],
 						data_def[idxL].vpdPdg[i],
-						AR5416_PD_GAIN_ICEPTS,
+						intercepts,
 						vpdTableI[i]);
 			}
 		}
 	} else {
 		for (i = 0; i < numXpdGains; i++) {
-			if (eeprom_4k) {
+			if (AR_SREV_9287(ah)) {
+				pVpdL = data_9287[idxL].vpdPdg[i];
+				pPwrL = data_9287[idxL].pwrPdg[i];
+				pVpdR = data_9287[idxR].vpdPdg[i];
+				pPwrR = data_9287[idxR].pwrPdg[i];
+			} else if (eeprom_4k) {
 				pVpdL = data_4k[idxL].vpdPdg[i];
 				pPwrL = data_4k[idxL].pwrPdg[i];
 				pVpdR = data_4k[idxR].vpdPdg[i];
@@ -362,17 +385,17 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 			minPwrT4[i] = max(pPwrL[0], pPwrR[0]);
 
 			maxPwrT4[i] =
-				min(pPwrL[AR5416_PD_GAIN_ICEPTS - 1],
-				    pPwrR[AR5416_PD_GAIN_ICEPTS - 1]);
+				min(pPwrL[intercepts - 1],
+				    pPwrR[intercepts - 1]);
 
 
 			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 						pPwrL, pVpdL,
-						AR5416_PD_GAIN_ICEPTS,
+						intercepts,
 						vpdTableL[i]);
 			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 						pPwrR, pVpdR,
-						AR5416_PD_GAIN_ICEPTS,
+						intercepts,
 						vpdTableR[i]);
 
 			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 4ba07da..868faf9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -220,163 +220,6 @@ static u32 ath9k_hw_ar9287_get_eeprom(struct ath_hw *ah,
 	}
 }
 
-static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
-			       struct ath9k_channel *chan,
-			       struct cal_data_per_freq_ar9287 *pRawDataSet,
-			       u8 *bChans, u16 availPiers,
-			       u16 tPdGainOverlap,
-			       u16 *pPdGainBoundaries,
-			       u8 *pPDADCValues,
-			       u16 numXpdGains)
-{
-#define TMP_VAL_VPD_TABLE						\
-	((vpdTableI[i][sizeCurrVpdTable - 1] + (ss - maxIndex + 1) * vpdStep));
-
-	int i, j, k;
-	int16_t ss;
-	u16 idxL = 0, idxR = 0, numPiers;
-	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
-	u8 minPwrT4[AR5416_NUM_PD_GAINS];
-	u8 maxPwrT4[AR5416_NUM_PD_GAINS];
-	int16_t vpdStep;
-	int16_t tmpVal;
-	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
-	bool match;
-	int16_t minDelta = 0;
-	struct chan_centers centers;
-	static u8 vpdTableL[AR5416_EEP4K_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u8 vpdTableR[AR5416_EEP4K_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u8 vpdTableI[AR5416_EEP4K_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-
-	memset(&minPwrT4, 0, AR5416_NUM_PD_GAINS);
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-
-	for (numPiers = 0; numPiers < availPiers; numPiers++) {
-		if (bChans[numPiers] == AR5416_BCHAN_UNUSED)
-			break;
-	}
-
-	match = ath9k_hw_get_lower_upper_index(
-		(u8)FREQ2FBIN(centers.synth_center, IS_CHAN_2GHZ(chan)),
-		bChans, numPiers, &idxL, &idxR);
-
-	if (match) {
-		for (i = 0; i < numXpdGains; i++) {
-			minPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][0];
-			maxPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][4];
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-						pRawDataSet[idxL].pwrPdg[i],
-						pRawDataSet[idxL].vpdPdg[i],
-						AR9287_PD_GAIN_ICEPTS,
-						vpdTableI[i]);
-		}
-	} else {
-		for (i = 0; i < numXpdGains; i++) {
-			pVpdL = pRawDataSet[idxL].vpdPdg[i];
-			pPwrL = pRawDataSet[idxL].pwrPdg[i];
-			pVpdR = pRawDataSet[idxR].vpdPdg[i];
-			pPwrR = pRawDataSet[idxR].pwrPdg[i];
-
-			minPwrT4[i] = max(pPwrL[0], pPwrR[0]);
-
-			maxPwrT4[i] = min(pPwrL[AR9287_PD_GAIN_ICEPTS - 1],
-					  pPwrR[AR9287_PD_GAIN_ICEPTS - 1]);
-
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-						pPwrL, pVpdL,
-						AR9287_PD_GAIN_ICEPTS,
-						vpdTableL[i]);
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-						pPwrR, pVpdR,
-						AR9287_PD_GAIN_ICEPTS,
-						vpdTableR[i]);
-
-			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
-				vpdTableI[i][j] = (u8)(ath9k_hw_interpolate(
-				       (u16)FREQ2FBIN(centers. synth_center,
-						      IS_CHAN_2GHZ(chan)),
-				       bChans[idxL], bChans[idxR],
-				       vpdTableL[i][j], vpdTableR[i][j]));
-			}
-		}
-	}
-
-	k = 0;
-
-	for (i = 0; i < numXpdGains; i++) {
-		if (i == (numXpdGains - 1))
-			pPdGainBoundaries[i] =
-				(u16)(maxPwrT4[i] / 2);
-		else
-			pPdGainBoundaries[i] =
-				(u16)((maxPwrT4[i] + minPwrT4[i+1]) / 4);
-
-		pPdGainBoundaries[i] = min((u16)MAX_RATE_POWER,
-					   pPdGainBoundaries[i]);
-
-
-		minDelta = 0;
-
-		if (i == 0) {
-			if (AR_SREV_9280_20_OR_LATER(ah))
-				ss = (int16_t)(0 - (minPwrT4[i] / 2));
-			else
-				ss = 0;
-		} else {
-			ss = (int16_t)((pPdGainBoundaries[i-1] -
-					(minPwrT4[i] / 2)) -
-				       tPdGainOverlap + 1 + minDelta);
-		}
-
-		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
-		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
-
-		while ((ss < 0) && (k < (AR5416_NUM_PDADC_VALUES - 1)))	{
-			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
-			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
-			ss++;
-		}
-
-		sizeCurrVpdTable = (u8)((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
-		tgtIndex = (u8)(pPdGainBoundaries[i] +
-				tPdGainOverlap - (minPwrT4[i] / 2));
-		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
-			    tgtIndex : sizeCurrVpdTable;
-
-		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1)))
-			pPDADCValues[k++] = vpdTableI[i][ss++];
-
-		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
-				    vpdTableI[i][sizeCurrVpdTable - 2]);
-		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
-
-		if (tgtIndex > maxIndex) {
-			while ((ss <= tgtIndex) &&
-				(k < (AR5416_NUM_PDADC_VALUES - 1))) {
-				tmpVal = (int16_t) TMP_VAL_VPD_TABLE;
-				pPDADCValues[k++] =
-					(u8)((tmpVal > 255) ? 255 : tmpVal);
-				ss++;
-			}
-		}
-	}
-
-	while (i < AR5416_PD_GAINS_IN_MASK) {
-		pPdGainBoundaries[i] = pPdGainBoundaries[i-1];
-		i++;
-	}
-
-	while (k < AR5416_NUM_PDADC_VALUES) {
-		pPDADCValues[k] = pPDADCValues[k-1];
-		k++;
-	}
-
-#undef TMP_VAL_VPD_TABLE
-}
-
 static void ar9287_eeprom_get_tx_gain_index(struct ath_hw *ah,
 			    struct ath9k_channel *chan,
 			    struct cal_data_op_loop_ar9287 *pRawDatasetOpLoop,
@@ -525,7 +368,7 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 					(struct cal_data_per_freq_ar9287 *)
 					pEepData->calPierData2G[i];
 
-				ath9k_hw_get_ar9287_gain_boundaries_pdadcs(ah, chan,
+				ath9k_hw_get_gain_boundaries_pdadcs(ah, chan,
 							   pRawDataset,
 							   pCalBChans, numPiers,
 							   pdGainOverlap_t2,
-- 
1.7.3.2

