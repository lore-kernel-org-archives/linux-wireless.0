Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42426 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab0LKXvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 18:51:36 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 3/8] ath9k_hw: merge ath9k_hw_get_gain_boundaries_pdadcs between eeprom_def.c and eeprom_4k.c
Date: Sun, 12 Dec 2010 00:51:09 +0100
Message-Id: <1292111474-70939-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292111474-70939-2-git-send-email-nbd@openwrt.org>
References: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
 <1292111474-70939-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c     |  190 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/eeprom.h     |    8 +
 drivers/net/wireless/ath/ath9k/eeprom_4k.c  |  169 +-----------------------
 drivers/net/wireless/ath/ath9k/eeprom_def.c |  164 +-----------------------
 4 files changed, 200 insertions(+), 331 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 3d99b6c..d54cfa4 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -279,6 +279,196 @@ void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah)
 	}
 }
 
+void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
+				struct ath9k_channel *chan,
+				void *pRawDataSet,
+				u8 *bChans, u16 availPiers,
+				u16 tPdGainOverlap,
+				u16 *pPdGainBoundaries, u8 *pPDADCValues,
+				u16 numXpdGains)
+{
+	int i, j, k;
+	int16_t ss;
+	u16 idxL = 0, idxR = 0, numPiers;
+	static u8 vpdTableL[AR5416_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+	static u8 vpdTableR[AR5416_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+	static u8 vpdTableI[AR5416_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+
+	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
+	u8 minPwrT4[AR5416_NUM_PD_GAINS];
+	u8 maxPwrT4[AR5416_NUM_PD_GAINS];
+	int16_t vpdStep;
+	int16_t tmpVal;
+	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
+	bool match;
+	int16_t minDelta = 0;
+	struct chan_centers centers;
+	int pdgain_boundary_default;
+	struct cal_data_per_freq *data_def = pRawDataSet;
+	struct cal_data_per_freq_4k *data_4k = pRawDataSet;
+	bool eeprom_4k = AR_SREV_9285(ah) || AR_SREV_9271(ah);
+
+	memset(&minPwrT4, 0, AR5416_NUM_PD_GAINS);
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+
+	for (numPiers = 0; numPiers < availPiers; numPiers++) {
+		if (bChans[numPiers] == AR5416_BCHAN_UNUSED)
+			break;
+	}
+
+	match = ath9k_hw_get_lower_upper_index((u8)FREQ2FBIN(centers.synth_center,
+							     IS_CHAN_2GHZ(chan)),
+					       bChans, numPiers, &idxL, &idxR);
+
+	if (match) {
+		if (eeprom_4k) {
+			for (i = 0; i < numXpdGains; i++) {
+				minPwrT4[i] = data_4k[idxL].pwrPdg[i][0];
+				maxPwrT4[i] = data_4k[idxL].pwrPdg[i][4];
+				ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+						data_4k[idxL].pwrPdg[i],
+						data_4k[idxL].vpdPdg[i],
+						AR5416_PD_GAIN_ICEPTS,
+						vpdTableI[i]);
+			}
+		} else {
+			for (i = 0; i < numXpdGains; i++) {
+				minPwrT4[i] = data_def[idxL].pwrPdg[i][0];
+				maxPwrT4[i] = data_def[idxL].pwrPdg[i][4];
+				ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+						data_def[idxL].pwrPdg[i],
+						data_def[idxL].vpdPdg[i],
+						AR5416_PD_GAIN_ICEPTS,
+						vpdTableI[i]);
+			}
+		}
+	} else {
+		for (i = 0; i < numXpdGains; i++) {
+			if (eeprom_4k) {
+				pVpdL = data_4k[idxL].vpdPdg[i];
+				pPwrL = data_4k[idxL].pwrPdg[i];
+				pVpdR = data_4k[idxR].vpdPdg[i];
+				pPwrR = data_4k[idxR].pwrPdg[i];
+			} else {
+				pVpdL = data_def[idxL].vpdPdg[i];
+				pPwrL = data_def[idxL].pwrPdg[i];
+				pVpdR = data_def[idxR].vpdPdg[i];
+				pPwrR = data_def[idxR].pwrPdg[i];
+			}
+
+			minPwrT4[i] = max(pPwrL[0], pPwrR[0]);
+
+			maxPwrT4[i] =
+				min(pPwrL[AR5416_PD_GAIN_ICEPTS - 1],
+				    pPwrR[AR5416_PD_GAIN_ICEPTS - 1]);
+
+
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+						pPwrL, pVpdL,
+						AR5416_PD_GAIN_ICEPTS,
+						vpdTableL[i]);
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+						pPwrR, pVpdR,
+						AR5416_PD_GAIN_ICEPTS,
+						vpdTableR[i]);
+
+			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
+				vpdTableI[i][j] =
+					(u8)(ath9k_hw_interpolate((u16)
+					     FREQ2FBIN(centers.
+						       synth_center,
+						       IS_CHAN_2GHZ
+						       (chan)),
+					     bChans[idxL], bChans[idxR],
+					     vpdTableL[i][j], vpdTableR[i][j]));
+			}
+		}
+	}
+
+	k = 0;
+
+	for (i = 0; i < numXpdGains; i++) {
+		if (i == (numXpdGains - 1))
+			pPdGainBoundaries[i] =
+				(u16)(maxPwrT4[i] / 2);
+		else
+			pPdGainBoundaries[i] =
+				(u16)((maxPwrT4[i] + minPwrT4[i + 1]) / 4);
+
+		pPdGainBoundaries[i] =
+			min((u16)MAX_RATE_POWER, pPdGainBoundaries[i]);
+
+		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
+			minDelta = pPdGainBoundaries[0] - 23;
+			pPdGainBoundaries[0] = 23;
+		} else {
+			minDelta = 0;
+		}
+
+		if (i == 0) {
+			if (AR_SREV_9280_20_OR_LATER(ah))
+				ss = (int16_t)(0 - (minPwrT4[i] / 2));
+			else
+				ss = 0;
+		} else {
+			ss = (int16_t)((pPdGainBoundaries[i - 1] -
+					(minPwrT4[i] / 2)) -
+				       tPdGainOverlap + 1 + minDelta);
+		}
+		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
+		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
+
+		while ((ss < 0) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
+			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
+			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
+			ss++;
+		}
+
+		sizeCurrVpdTable = (u8) ((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
+		tgtIndex = (u8)(pPdGainBoundaries[i] + tPdGainOverlap -
+				(minPwrT4[i] / 2));
+		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
+			tgtIndex : sizeCurrVpdTable;
+
+		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
+			pPDADCValues[k++] = vpdTableI[i][ss++];
+		}
+
+		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
+				    vpdTableI[i][sizeCurrVpdTable - 2]);
+		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
+
+		if (tgtIndex >= maxIndex) {
+			while ((ss <= tgtIndex) &&
+			       (k < (AR5416_NUM_PDADC_VALUES - 1))) {
+				tmpVal = (int16_t)((vpdTableI[i][sizeCurrVpdTable - 1] +
+						    (ss - maxIndex + 1) * vpdStep));
+				pPDADCValues[k++] = (u8)((tmpVal > 255) ?
+							 255 : tmpVal);
+				ss++;
+			}
+		}
+	}
+
+	if (eeprom_4k)
+		pdgain_boundary_default = 58;
+	else
+		pdgain_boundary_default = pPdGainBoundaries[i - 1];
+
+	while (i < AR5416_PD_GAINS_IN_MASK) {
+		pPdGainBoundaries[i] = pdgain_boundary_default;
+		i++;
+	}
+
+	while (k < AR5416_NUM_PDADC_VALUES) {
+		pPDADCValues[k] = pPDADCValues[k - 1];
+		k++;
+	}
+}
+
 int ath9k_hw_eeprom_init(struct ath_hw *ah)
 {
 	int status;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 833dd0c..1f6b7128 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -691,6 +691,14 @@ u16 ath9k_hw_get_max_edge_power(u16 freq, struct cal_ctl_edges *pRdEdgesPower,
 void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah);
 int ath9k_hw_eeprom_init(struct ath_hw *ah);
 
+void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
+				struct ath9k_channel *chan,
+				void *pRawDataSet,
+				u8 *bChans, u16 availPiers,
+				u16 tPdGainOverlap,
+				u16 *pPdGainBoundaries, u8 *pPDADCValues,
+				u16 numXpdGains);
+
 #define ar5416_get_ntxchains(_txchainmask)			\
 	(((_txchainmask >> 2) & 1) +                            \
 	 ((_txchainmask >> 1) & 1) + (_txchainmask & 1))
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 6102309..b0f7446 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -227,173 +227,6 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 	}
 }
 
-static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
-				struct ath9k_channel *chan,
-				struct cal_data_per_freq_4k *pRawDataSet,
-				u8 *bChans, u16 availPiers,
-				u16 tPdGainOverlap,
-				u16 *pPdGainBoundaries, u8 *pPDADCValues,
-				u16 numXpdGains)
-{
-#define TMP_VAL_VPD_TABLE \
-	((vpdTableI[i][sizeCurrVpdTable - 1] + (ss - maxIndex + 1) * vpdStep));
-	int i, j, k;
-	int16_t ss;
-	u16 idxL = 0, idxR = 0, numPiers;
-	static u8 vpdTableL[AR5416_EEP4K_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u8 vpdTableR[AR5416_EEP4K_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u8 vpdTableI[AR5416_EEP4K_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-
-	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
-	u8 minPwrT4[AR5416_EEP4K_NUM_PD_GAINS];
-	u8 maxPwrT4[AR5416_EEP4K_NUM_PD_GAINS];
-	int16_t vpdStep;
-	int16_t tmpVal;
-	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
-	bool match;
-	int16_t minDelta = 0;
-	struct chan_centers centers;
-#define PD_GAIN_BOUNDARY_DEFAULT 58;
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
-					(u8)FREQ2FBIN(centers.synth_center,
-					IS_CHAN_2GHZ(chan)), bChans, numPiers,
-					&idxL, &idxR);
-
-	if (match) {
-		for (i = 0; i < numXpdGains; i++) {
-			minPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][0];
-			maxPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][4];
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-					pRawDataSet[idxL].pwrPdg[i],
-					pRawDataSet[idxL].vpdPdg[i],
-					AR5416_PD_GAIN_ICEPTS,
-					vpdTableI[i]);
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
-			maxPwrT4[i] =
-				min(pPwrL[AR5416_PD_GAIN_ICEPTS - 1],
-				    pPwrR[AR5416_PD_GAIN_ICEPTS - 1]);
-
-
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-						pPwrL, pVpdL,
-						AR5416_PD_GAIN_ICEPTS,
-						vpdTableL[i]);
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-						pPwrR, pVpdR,
-						AR5416_PD_GAIN_ICEPTS,
-						vpdTableR[i]);
-
-			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
-				vpdTableI[i][j] =
-					(u8)(ath9k_hw_interpolate((u16)
-					     FREQ2FBIN(centers.
-						       synth_center,
-						       IS_CHAN_2GHZ
-						       (chan)),
-					     bChans[idxL], bChans[idxR],
-					     vpdTableL[i][j], vpdTableR[i][j]));
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
-				(u16)((maxPwrT4[i] + minPwrT4[i + 1]) / 4);
-
-		pPdGainBoundaries[i] =
-			min((u16)MAX_RATE_POWER, pPdGainBoundaries[i]);
-
-		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
-			minDelta = pPdGainBoundaries[0] - 23;
-			pPdGainBoundaries[0] = 23;
-		} else {
-			minDelta = 0;
-		}
-
-		if (i == 0) {
-			if (AR_SREV_9280_20_OR_LATER(ah))
-				ss = (int16_t)(0 - (minPwrT4[i] / 2));
-			else
-				ss = 0;
-		} else {
-			ss = (int16_t)((pPdGainBoundaries[i - 1] -
-					(minPwrT4[i] / 2)) -
-				       tPdGainOverlap + 1 + minDelta);
-		}
-		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
-		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
-
-		while ((ss < 0) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
-			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
-			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
-			ss++;
-		}
-
-		sizeCurrVpdTable = (u8) ((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
-		tgtIndex = (u8)(pPdGainBoundaries[i] + tPdGainOverlap -
-				(minPwrT4[i] / 2));
-		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
-			tgtIndex : sizeCurrVpdTable;
-
-		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1)))
-			pPDADCValues[k++] = vpdTableI[i][ss++];
-
-		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
-				    vpdTableI[i][sizeCurrVpdTable - 2]);
-		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
-
-		if (tgtIndex >= maxIndex) {
-			while ((ss <= tgtIndex) &&
-			       (k < (AR5416_NUM_PDADC_VALUES - 1))) {
-				tmpVal = (int16_t) TMP_VAL_VPD_TABLE;
-				pPDADCValues[k++] = (u8)((tmpVal > 255) ?
-							 255 : tmpVal);
-				ss++;
-			}
-		}
-	}
-
-	while (i < AR5416_PD_GAINS_IN_MASK) {
-		pPdGainBoundaries[i] = PD_GAIN_BOUNDARY_DEFAULT;
-		i++;
-	}
-
-	while (k < AR5416_NUM_PDADC_VALUES) {
-		pPDADCValues[k] = pPDADCValues[k - 1];
-		k++;
-	}
-
-	return;
-#undef TMP_VAL_VPD_TABLE
-}
-
 static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
@@ -455,7 +288,7 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 		if (pEepData->baseEepHeader.txMask & (1 << i)) {
 			pRawDataset = pEepData->calPierData2G[i];
 
-			ath9k_hw_get_4k_gain_boundaries_pdadcs(ah, chan,
+			ath9k_hw_get_gain_boundaries_pdadcs(ah, chan,
 					    pRawDataset, pCalBChans,
 					    numPiers, pdGainOverlap_t2,
 					    gainBoundaries,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index da96a78..ad3e234 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -588,168 +588,6 @@ static void ath9k_hw_def_set_addac(struct ath_hw *ah,
 #undef XPA_LVL_FREQ
 }
 
-static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
-				struct ath9k_channel *chan,
-				struct cal_data_per_freq *pRawDataSet,
-				u8 *bChans, u16 availPiers,
-				u16 tPdGainOverlap,
-				u16 *pPdGainBoundaries, u8 *pPDADCValues,
-				u16 numXpdGains)
-{
-	int i, j, k;
-	int16_t ss;
-	u16 idxL = 0, idxR = 0, numPiers;
-	static u8 vpdTableL[AR5416_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u8 vpdTableR[AR5416_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-	static u8 vpdTableI[AR5416_NUM_PD_GAINS]
-		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
-
-	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
-	u8 minPwrT4[AR5416_NUM_PD_GAINS];
-	u8 maxPwrT4[AR5416_NUM_PD_GAINS];
-	int16_t vpdStep;
-	int16_t tmpVal;
-	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
-	bool match;
-	int16_t minDelta = 0;
-	struct chan_centers centers;
-
-	memset(&minPwrT4, 0, AR5416_NUM_PD_GAINS);
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-
-	for (numPiers = 0; numPiers < availPiers; numPiers++) {
-		if (bChans[numPiers] == AR5416_BCHAN_UNUSED)
-			break;
-	}
-
-	match = ath9k_hw_get_lower_upper_index((u8)FREQ2FBIN(centers.synth_center,
-							     IS_CHAN_2GHZ(chan)),
-					       bChans, numPiers, &idxL, &idxR);
-
-	if (match) {
-		for (i = 0; i < numXpdGains; i++) {
-			minPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][0];
-			maxPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][4];
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-					pRawDataSet[idxL].pwrPdg[i],
-					pRawDataSet[idxL].vpdPdg[i],
-					AR5416_PD_GAIN_ICEPTS,
-					vpdTableI[i]);
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
-			maxPwrT4[i] =
-				min(pPwrL[AR5416_PD_GAIN_ICEPTS - 1],
-				    pPwrR[AR5416_PD_GAIN_ICEPTS - 1]);
-
-
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-						pPwrL, pVpdL,
-						AR5416_PD_GAIN_ICEPTS,
-						vpdTableL[i]);
-			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
-						pPwrR, pVpdR,
-						AR5416_PD_GAIN_ICEPTS,
-						vpdTableR[i]);
-
-			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
-				vpdTableI[i][j] =
-					(u8)(ath9k_hw_interpolate((u16)
-					     FREQ2FBIN(centers.
-						       synth_center,
-						       IS_CHAN_2GHZ
-						       (chan)),
-					     bChans[idxL], bChans[idxR],
-					     vpdTableL[i][j], vpdTableR[i][j]));
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
-				(u16)((maxPwrT4[i] + minPwrT4[i + 1]) / 4);
-
-		pPdGainBoundaries[i] =
-			min((u16)MAX_RATE_POWER, pPdGainBoundaries[i]);
-
-		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
-			minDelta = pPdGainBoundaries[0] - 23;
-			pPdGainBoundaries[0] = 23;
-		} else {
-			minDelta = 0;
-		}
-
-		if (i == 0) {
-			if (AR_SREV_9280_20_OR_LATER(ah))
-				ss = (int16_t)(0 - (minPwrT4[i] / 2));
-			else
-				ss = 0;
-		} else {
-			ss = (int16_t)((pPdGainBoundaries[i - 1] -
-					(minPwrT4[i] / 2)) -
-				       tPdGainOverlap + 1 + minDelta);
-		}
-		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
-		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
-
-		while ((ss < 0) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
-			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
-			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
-			ss++;
-		}
-
-		sizeCurrVpdTable = (u8) ((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
-		tgtIndex = (u8)(pPdGainBoundaries[i] + tPdGainOverlap -
-				(minPwrT4[i] / 2));
-		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
-			tgtIndex : sizeCurrVpdTable;
-
-		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
-			pPDADCValues[k++] = vpdTableI[i][ss++];
-		}
-
-		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
-				    vpdTableI[i][sizeCurrVpdTable - 2]);
-		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
-
-		if (tgtIndex >= maxIndex) {
-			while ((ss <= tgtIndex) &&
-			       (k < (AR5416_NUM_PDADC_VALUES - 1))) {
-				tmpVal = (int16_t)((vpdTableI[i][sizeCurrVpdTable - 1] +
-						    (ss - maxIndex + 1) * vpdStep));
-				pPDADCValues[k++] = (u8)((tmpVal > 255) ?
-							 255 : tmpVal);
-				ss++;
-			}
-		}
-	}
-
-	while (i < AR5416_PD_GAINS_IN_MASK) {
-		pPdGainBoundaries[i] = pPdGainBoundaries[i - 1];
-		i++;
-	}
-
-	while (k < AR5416_NUM_PDADC_VALUES) {
-		pPDADCValues[k] = pPDADCValues[k - 1];
-		k++;
-	}
-}
-
 static int16_t ath9k_change_gain_boundary_setting(struct ath_hw *ah,
 				u16 *gb,
 				u16 numXpdGain,
@@ -916,7 +754,7 @@ static void ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 				ath9k_olc_get_pdadcs(ah, pcdacIdx,
 						     txPower/2, pdadcValues);
 			} else {
-				ath9k_hw_get_def_gain_boundaries_pdadcs(ah,
+				ath9k_hw_get_gain_boundaries_pdadcs(ah,
 							chan, pRawDataset,
 							pCalBChans, numPiers,
 							pdGainOverlap_t2,
-- 
1.7.3.2

