Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:39033 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZGWFaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 01:30:07 -0400
Received: by rv-out-0506.google.com with SMTP id f6so195492rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 22:30:07 -0700 (PDT)
Date: Thu, 23 Jul 2009 10:59:57 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ath9k: Add support for AR9287 based chipsets.
Message-ID: <20090723052957.GB5943@myhost.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c  |   22 +-
 drivers/net/wireless/ath/ath9k/eeprom.c | 1203 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/eeprom.h |  163 +++++-
 drivers/net/wireless/ath/ath9k/hw.c     |  110 +++-
 drivers/net/wireless/ath/ath9k/hw.h     |    4 +
 drivers/net/wireless/ath/ath9k/main.c   |    3 +-
 drivers/net/wireless/ath/ath9k/pci.c    |    2 +
 drivers/net/wireless/ath/ath9k/phy.h    |    1 +
 8 files changed, 1482 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 1f0c5fe..d1bbb02 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -116,7 +116,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 				"NF calibrated [ctl] [chain 1] is %d\n", nf);
 		nfarray[1] = nf;
 
-		if (!AR_SREV_9280(ah)) {
+		if (!AR_SREV_9280(ah) && !AR_SREV_9287(ah)) {
 			nf = MS(REG_READ(ah, AR_PHY_CH2_CCA),
 					AR_PHY_CH2_MINCCA_PWR);
 			if (nf & 0x100)
@@ -154,7 +154,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 				"NF calibrated [ext] [chain 1] is %d\n", nf);
 		nfarray[4] = nf;
 
-		if (!AR_SREV_9280(ah)) {
+		if (!AR_SREV_9280(ah) && !AR_SREV_9287(ah)) {
 			nf = MS(REG_READ(ah, AR_PHY_CH2_EXT_CCA),
 					AR_PHY_CH2_EXT_MINCCA_PWR);
 			if (nf & 0x100)
@@ -613,7 +613,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	if (AR_SREV_9285(ah))
 		chainmask = 0x9;
-	else if (AR_SREV_9280(ah))
+	else if (AR_SREV_9280(ah) || AR_SREV_9287(ah))
 		chainmask = 0x1B;
 	else
 		chainmask = 0x3F;
@@ -873,7 +873,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 		if (AR_SREV_9285_11_OR_LATER(ah))
 			ath9k_hw_9285_pa_cal(ah);
 
-		if (OLC_FOR_AR9280_20_LATER)
+		if (OLC_FOR_AR9280_20_LATER || OLC_FOR_AR9287_10_LATER)
 			ath9k_olc_temp_compensation(ah);
 		ath9k_hw_getnf(ah, chan);
 		ath9k_hw_loadnf(ah, ah->curchan);
@@ -929,8 +929,11 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 			return false;
 	} else {
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
-			REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+			if (!AR_SREV_9287_10_OR_LATER(ah))
+				REG_CLR_BIT(ah, AR_PHY_ADC_CTL,
+					    AR_PHY_ADC_CTL_OFF_PWDADC);
+			REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
+				    AR_PHY_AGC_CONTROL_FLTR_CAL);
 		}
 
 		/* Calibrate the AGC */
@@ -948,8 +951,11 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 		}
 
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			REG_SET_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
-			REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+			if (!AR_SREV_9287_10_OR_LATER(ah))
+				REG_SET_BIT(ah, AR_PHY_ADC_CTL,
+					    AR_PHY_ADC_CTL_OFF_PWDADC);
+			REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+				    AR_PHY_AGC_CONTROL_FLTR_CAL);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index df41ed5..9b1d960 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -2781,11 +2781,1210 @@ static struct eeprom_ops eep_def_ops = {
 	.get_spur_channel	= ath9k_hw_def_get_spur_channel
 };
 
+
+static int ath9k_hw_AR9287_get_eeprom_ver(struct ath_hw *ah)
+{
+	return (ah->eeprom.map9287.baseEepHeader.version >> 12) & 0xF;
+}
+
+static int ath9k_hw_AR9287_get_eeprom_rev(struct ath_hw *ah)
+{
+	return (ah->eeprom.map9287.baseEepHeader.version) & 0xFFF;
+}
+
+static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
+{
+	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+	u16 *eep_data;
+	int addr, eep_start_loc = AR9287_EEP_START_LOC;
+	eep_data = (u16 *)eep;
+	if (!ath9k_hw_use_flash(ah)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"Reading from EEPROM, not flash\n");
+	}
+
+	for (addr = 0; addr < sizeof(struct ar9287_eeprom_t) / sizeof(u16);
+			addr++)	{
+		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+					"Unable to read eeprom region \n");
+			return false;
+		}
+		eep_data++;
+	}
+	return true;
+}
+static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
+{
+#define SIZE_EEPROM_87 (sizeof(struct ar9287_eeprom_t) / sizeof(u16))
+	u32 sum = 0, el, integer;
+	u16 temp, word, magic, magic2, *eepdata;
+	int i, addr;
+	bool need_swap = false;
+	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+
+	if (!ath9k_hw_use_flash(ah)) {
+		if (!ath9k_hw_nvram_read
+				(ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+					"Reading Magic # failed\n");
+			return false;
+		}
+
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"Read Magic = 0x%04X\n", magic);
+		if (magic != AR5416_EEPROM_MAGIC) {
+
+
+			magic2 = swab16(magic);
+
+			if (magic2 == AR5416_EEPROM_MAGIC) {
+				need_swap = true;
+				eepdata = (u16 *)(&ah->eeprom);
+
+				for (addr = 0; addr < SIZE_EEPROM_87; addr++) {
+					temp = swab16(*eepdata);
+					*eepdata = temp;
+					eepdata++;
+				}
+			} else {
+				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+						"Invalid EEPROM Magic. "
+						"endianness mismatch.\n");
+				return -EINVAL;            }
+		}
+	}
+	DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "need_swap = %s.\n", need_swap ?
+					   "True" : "False");
+
+	if (need_swap)
+		el = swab16(ah->eeprom.map9287.baseEepHeader.length);
+	else
+		el = ah->eeprom.map9287.baseEepHeader.length;
+
+	eepdata = (u16 *)(&ah->eeprom);
+	for (i = 0; i < min(el, SIZE_EEPROM_87); i++)
+		sum ^= *eepdata++;
+
+	if (need_swap) {
+		word = swab16(eep->baseEepHeader.length);
+		eep->baseEepHeader.length = word;
+
+		word = swab16(eep->baseEepHeader.checksum);
+		eep->baseEepHeader.checksum = word;
+
+		word = swab16(eep->baseEepHeader.version);
+		eep->baseEepHeader.version = word;
+
+		word = swab16(eep->baseEepHeader.regDmn[0]);
+		eep->baseEepHeader.regDmn[0] = word;
+
+		word = swab16(eep->baseEepHeader.regDmn[1]);
+		eep->baseEepHeader.regDmn[1] = word;
+
+		word = swab16(eep->baseEepHeader.rfSilent);
+		eep->baseEepHeader.rfSilent = word;
+
+		word = swab16(eep->baseEepHeader.blueToothOptions);
+		eep->baseEepHeader.blueToothOptions = word;
+
+		word = swab16(eep->baseEepHeader.deviceCap);
+		eep->baseEepHeader.deviceCap = word;
+
+		integer = swab32(eep->modalHeader.antCtrlCommon);
+		eep->modalHeader.antCtrlCommon = integer;
+
+		for (i = 0; i < AR9287_MAX_CHAINS; i++) {
+			integer = swab32(eep->modalHeader.antCtrlChain[i]);
+			eep->modalHeader.antCtrlChain[i] = integer;
+		}
+
+		for (i = 0; i < AR9287_EEPROM_MODAL_SPURS; i++) {
+			word = swab16(eep->modalHeader.spurChans[i].spurChan);
+			eep->modalHeader.spurChans[i].spurChan = word;
+		}
+	}
+
+	if (sum != 0xffff || ah->eep_ops->get_eeprom_ver(ah) != AR9287_EEP_VER
+	    || ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_NO_BACK_VER) {
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"Bad EEPROM checksum 0x%x or revision 0x%04x\n",
+			 sum, ah->eep_ops->get_eeprom_ver(ah));
+		return -EINVAL;
+	}
+
+	return 0;
+#undef SIZE_EEPROM_87
+}
+
+static u32 ath9k_hw_AR9287_get_eeprom(struct ath_hw *ah,
+		enum eeprom_param param)
+{
+	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
+	struct base_eep_ar9287_header *pBase = &eep->baseEepHeader;
+	u16 ver_minor;
+
+	ver_minor = pBase->version & AR9287_EEP_VER_MINOR_MASK;
+	switch (param) {
+	case EEP_NFTHRESH_2:
+		return pModal->noiseFloorThreshCh[0];
+	case AR_EEPROM_MAC(0):
+		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
+	case AR_EEPROM_MAC(1):
+		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
+	case AR_EEPROM_MAC(2):
+		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
+	case EEP_REG_0:
+		return pBase->regDmn[0];
+	case EEP_REG_1:
+		return pBase->regDmn[1];
+	case EEP_OP_CAP:
+		return pBase->deviceCap;
+	case EEP_OP_MODE:
+		return pBase->opCapFlags;
+	case EEP_RF_SILENT:
+		return pBase->rfSilent;
+	case EEP_MINOR_REV:
+		return ver_minor;
+	case EEP_TX_MASK:
+		return pBase->txMask;
+	case EEP_RX_MASK:
+		return pBase->rxMask;
+	case EEP_DEV_TYPE:
+		return pBase->deviceType;
+	case EEP_OL_PWRCTRL:
+		return pBase->openLoopPwrCntl;
+	case EEP_TEMPSENSE_SLOPE:
+		if (ver_minor >= AR9287_EEP_MINOR_VER_2)
+			return pBase->tempSensSlope;
+		else
+			return 0;
+	case EEP_TEMPSENSE_SLOPE_PAL_ON:
+		if (ver_minor >= AR9287_EEP_MINOR_VER_3)
+			return pBase->tempSensSlopePalOn;
+		else
+			return 0;
+	default:
+		return 0;
+	}
+}
+
+
+static void ath9k_hw_get_AR9287_gain_boundaries_pdadcs(struct ath_hw *ah,
+				   struct ath9k_channel *chan,
+				   struct cal_data_per_freq_ar9287 *pRawDataSet,
+				   u8 *bChans,  u16 availPiers,
+				   u16 tPdGainOverlap, int16_t *pMinCalPower,
+				   u16 *pPdGainBoundaries, u8 *pPDADCValues,
+				   u16 numXpdGains)
+{
+#define TMP_VAL_VPD_TABLE \
+	((vpdTableI[i][sizeCurrVpdTable - 1] + (ss - maxIndex + 1) * vpdStep));
+	int       i, j, k;
+	int16_t   ss;
+	u16  idxL = 0, idxR = 0, numPiers;
+	u8   *pVpdL, *pVpdR, *pPwrL, *pPwrR;
+	u8   minPwrT4[AR9287_NUM_PD_GAINS];
+	u8   maxPwrT4[AR9287_NUM_PD_GAINS];
+	int16_t   vpdStep;
+	int16_t   tmpVal;
+	u16  sizeCurrVpdTable, maxIndex, tgtIndex;
+	bool    match;
+	int16_t  minDelta = 0;
+	struct chan_centers centers;
+	static u8 vpdTableL[AR5416_EEP4K_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+	static u8 vpdTableR[AR5416_EEP4K_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+	static u8 vpdTableI[AR5416_EEP4K_NUM_PD_GAINS]
+		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	for (numPiers = 0; numPiers < availPiers; numPiers++) {
+		if (bChans[numPiers] == AR9287_BCHAN_UNUSED)
+			break;
+	}
+
+	match = ath9k_hw_get_lower_upper_index(
+				   (u8)FREQ2FBIN(centers.synth_center,
+				    IS_CHAN_2GHZ(chan)), bChans, numPiers,
+				    &idxL, &idxR);
+
+	if (match) {
+		for (i = 0; i < numXpdGains; i++) {
+			minPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][0];
+			maxPwrT4[i] = pRawDataSet[idxL].pwrPdg[i][4];
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+					pRawDataSet[idxL].pwrPdg[i],
+					pRawDataSet[idxL].vpdPdg[i],
+					AR9287_PD_GAIN_ICEPTS, vpdTableI[i]);
+		}
+	} else {
+		for (i = 0; i < numXpdGains; i++) {
+			pVpdL = pRawDataSet[idxL].vpdPdg[i];
+			pPwrL = pRawDataSet[idxL].pwrPdg[i];
+			pVpdR = pRawDataSet[idxR].vpdPdg[i];
+			pPwrR = pRawDataSet[idxR].pwrPdg[i];
+
+			minPwrT4[i] = max(pPwrL[0], pPwrR[0]);
+
+			maxPwrT4[i] =
+				min(pPwrL[AR9287_PD_GAIN_ICEPTS - 1],
+				    pPwrR[AR9287_PD_GAIN_ICEPTS - 1]);
+
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+					pPwrL, pVpdL,
+					AR9287_PD_GAIN_ICEPTS,
+					vpdTableL[i]);
+			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
+					pPwrR, pVpdR,
+					AR9287_PD_GAIN_ICEPTS,
+					vpdTableR[i]);
+
+			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
+				vpdTableI[i][j] =
+					(u8)(ath9k_hw_interpolate((u16)
+					FREQ2FBIN(centers. synth_center,
+					IS_CHAN_2GHZ(chan)),
+					bChans[idxL], bChans[idxR],
+					vpdTableL[i][j], vpdTableR[i][j]));
+			}
+		}
+	}
+	*pMinCalPower = (int16_t)(minPwrT4[0] / 2);
+
+	k = 0;
+	for (i = 0; i < numXpdGains; i++) {
+		if (i == (numXpdGains - 1))
+			pPdGainBoundaries[i] = (u16)(maxPwrT4[i] / 2);
+		else
+			pPdGainBoundaries[i] = (u16)((maxPwrT4[i] +
+						      minPwrT4[i+1]) / 4);
+
+		pPdGainBoundaries[i] = min((u16)AR5416_MAX_RATE_POWER,
+					    pPdGainBoundaries[i]);
+
+
+		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
+			minDelta = pPdGainBoundaries[0] - 23;
+			pPdGainBoundaries[0] = 23;
+		} else
+			minDelta = 0;
+
+		if (i == 0) {
+			if (AR_SREV_9280_10_OR_LATER(ah))
+				ss = (int16_t)(0 - (minPwrT4[i] / 2));
+			else
+				ss = 0;
+		} else
+			ss = (int16_t)((pPdGainBoundaries[i-1] -
+				       (minPwrT4[i] / 2)) -
+				       tPdGainOverlap + 1 + minDelta);
+
+		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
+		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
+		while ((ss < 0) && (k < (AR9287_NUM_PDADC_VALUES - 1)))	{
+			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
+			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
+			ss++;
+		}
+
+		sizeCurrVpdTable = (u8)((maxPwrT4[i] - minPwrT4[i]) / 2 + 1);
+		tgtIndex = (u8)(pPdGainBoundaries[i] +
+				tPdGainOverlap - (minPwrT4[i] / 2));
+		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
+			    tgtIndex : sizeCurrVpdTable;
+
+		while ((ss < maxIndex) && (k < (AR9287_NUM_PDADC_VALUES - 1)))
+			pPDADCValues[k++] = vpdTableI[i][ss++];
+
+		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
+				    vpdTableI[i][sizeCurrVpdTable - 2]);
+		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
+		if (tgtIndex > maxIndex) {
+			while ((ss <= tgtIndex) &&
+				(k < (AR9287_NUM_PDADC_VALUES - 1))) {
+				tmpVal = (int16_t) TMP_VAL_VPD_TABLE;
+				pPDADCValues[k++] = (u8)((tmpVal > 255) ?
+							  255 : tmpVal);
+				ss++;
+			}
+		}
+	}
+
+	while (i < AR9287_PD_GAINS_IN_MASK) {
+		pPdGainBoundaries[i] = pPdGainBoundaries[i-1];
+		i++;
+	}
+
+	while (k < AR9287_NUM_PDADC_VALUES) {
+		pPDADCValues[k] = pPDADCValues[k-1];
+		k++;
+	}
+
+#undef TMP_VAL_VPD_TABLE
+}
+
+static void ar9287_eeprom_get_tx_gain_index(struct ath_hw *ah,
+		struct ath9k_channel *chan,
+		struct cal_data_op_loop_ar9287 *pRawDatasetOpLoop,
+		u8 *pCalChans,  u16 availPiers,
+		int8_t *pPwr)
+{
+	u8 pcdac, i = 0;
+	u16  idxL = 0, idxR = 0, numPiers;
+	bool match;
+	struct chan_centers centers;
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	for (numPiers = 0; numPiers < availPiers; numPiers++) {
+		if (pCalChans[numPiers] == AR9287_BCHAN_UNUSED)
+			break;
+	}
+
+	match = ath9k_hw_get_lower_upper_index(
+			(u8)FREQ2FBIN(centers.synth_center, IS_CHAN_2GHZ(chan)),
+			pCalChans, numPiers,
+			&idxL, &idxR);
+
+	if (match) {
+		pcdac = pRawDatasetOpLoop[idxL].pcdac[0][0];
+		*pPwr = pRawDatasetOpLoop[idxL].pwrPdg[0][0];
+	} else {
+		pcdac = pRawDatasetOpLoop[idxR].pcdac[0][0];
+		*pPwr = (pRawDatasetOpLoop[idxL].pwrPdg[0][0] +
+				pRawDatasetOpLoop[idxR].pwrPdg[0][0])/2;
+	}
+
+	while ((pcdac > ah->originalGain[i]) &&
+			(i < (AR9280_TX_GAIN_TABLE_SIZE - 1)))
+		i++;
+}
+
+static void ar9287_eeprom_olpc_set_pdadcs(struct ath_hw *ah,
+					  int32_t txPower, u16 chain)
+{
+	u32 tmpVal;
+	u32 a;
+
+	tmpVal = REG_READ(ah, 0xa270);
+	tmpVal = tmpVal & 0xFCFFFFFF;
+	tmpVal = tmpVal | (0x3 << 24);
+	REG_WRITE(ah, 0xa270, tmpVal);
+
+	tmpVal = REG_READ(ah, 0xb270);
+	tmpVal = tmpVal & 0xFCFFFFFF;
+	tmpVal = tmpVal | (0x3 << 24);
+	REG_WRITE(ah, 0xb270, tmpVal);
+
+	if (chain == 0) {
+		tmpVal = REG_READ(ah, 0xa398);
+		tmpVal = tmpVal & 0xff00ffff;
+		a = (txPower)&0xff;
+		tmpVal = tmpVal | (a << 16);
+		REG_WRITE(ah, 0xa398, tmpVal);
+	}
+
+	if (chain == 1) {
+		tmpVal = REG_READ(ah, 0xb398);
+		tmpVal = tmpVal & 0xff00ffff;
+		a = (txPower)&0xff;
+		tmpVal = tmpVal | (a << 16);
+		REG_WRITE(ah, 0xb398, tmpVal);
+	}
+}
+
+
+static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
+		struct ath9k_channel *chan, int16_t *pTxPowerIndexOffset)
+{
+	struct cal_data_per_freq_ar9287 *pRawDataset;
+	struct cal_data_op_loop_ar9287 *pRawDatasetOpenLoop;
+	u8  *pCalBChans = NULL;
+	u16 pdGainOverlap_t2;
+	u8  pdadcValues[AR9287_NUM_PDADC_VALUES];
+	u16 gainBoundaries[AR9287_PD_GAINS_IN_MASK];
+	u16 numPiers = 0, i, j;
+	int16_t  tMinCalPower;
+	u16 numXpdGain, xpdMask;
+	u16 xpdGainValues[AR9287_NUM_PD_GAINS] = {0, 0, 0, 0};
+	u32 reg32, regOffset, regChainOffset;
+	int16_t   modalIdx, diff = 0;
+	struct ar9287_eeprom_t *pEepData = &ah->eeprom.map9287;
+	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
+	xpdMask = pEepData->modalHeader.xpdGain;
+	if ((pEepData->baseEepHeader.version & AR9287_EEP_VER_MINOR_MASK) >=
+			AR9287_EEP_MINOR_VER_2)
+		pdGainOverlap_t2 = pEepData->modalHeader.pdGainOverlap;
+	else
+		pdGainOverlap_t2 = (u16)(MS(REG_READ(ah, AR_PHY_TPCRG5),
+					    AR_PHY_TPCRG5_PD_GAIN_OVERLAP));
+
+	if (IS_CHAN_2GHZ(chan)) {
+		pCalBChans = pEepData->calFreqPier2G;
+		numPiers = AR9287_NUM_2G_CAL_PIERS;
+		if (ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
+			pRawDatasetOpenLoop =
+				(struct cal_data_op_loop_ar9287 *)
+				pEepData->calPierData2G[0];
+			ah->initPDADC = pRawDatasetOpenLoop->vpdPdg[0][0];
+		}
+	}
+
+	numXpdGain = 0;
+	for (i = 1; i <= AR9287_PD_GAINS_IN_MASK; i++) {
+		if ((xpdMask >> (AR9287_PD_GAINS_IN_MASK - i)) & 1) {
+			if (numXpdGain >= AR9287_NUM_PD_GAINS)
+				break;
+			xpdGainValues[numXpdGain] =
+				(u16)(AR9287_PD_GAINS_IN_MASK-i);
+			numXpdGain++;
+		}
+	}
+
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_NUM_PD_GAIN,
+		      (numXpdGain - 1) & 0x3);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_1,
+		      xpdGainValues[0]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_2,
+		      xpdGainValues[1]);
+	REG_RMW_FIELD(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_GAIN_3,
+		      xpdGainValues[2]);
+
+	for (i = 0; i < AR9287_MAX_CHAINS; i++)	{
+		regChainOffset = i * 0x1000;
+		if (pEepData->baseEepHeader.txMask & (1 << i)) {
+			pRawDatasetOpenLoop = (struct cal_data_op_loop_ar9287 *)
+					       pEepData->calPierData2G[i];
+			if (ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
+				int8_t txPower;
+				ar9287_eeprom_get_tx_gain_index(ah, chan,
+							  pRawDatasetOpenLoop,
+							  pCalBChans, numPiers,
+							  &txPower);
+				ar9287_eeprom_olpc_set_pdadcs(ah, txPower, i);
+			} else {
+				pRawDataset =
+					(struct cal_data_per_freq_ar9287 *)
+					pEepData->calPierData2G[i];
+				ath9k_hw_get_AR9287_gain_boundaries_pdadcs(
+						  ah, chan, pRawDataset,
+						  pCalBChans, numPiers,
+						  pdGainOverlap_t2,
+						  &tMinCalPower, gainBoundaries,
+						  pdadcValues, numXpdGain);
+			}
+
+			if (i == 0) {
+				if (!ath9k_hw_AR9287_get_eeprom(
+							ah, EEP_OL_PWRCTRL)) {
+					REG_WRITE(ah, AR_PHY_TPCRG5 +
+					    regChainOffset,
+					    SM(pdGainOverlap_t2,
+					    AR_PHY_TPCRG5_PD_GAIN_OVERLAP) |
+					    SM(gainBoundaries[0],
+					     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
+					     | SM(gainBoundaries[1],
+					     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
+					     | SM(gainBoundaries[2],
+					     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
+					     | SM(gainBoundaries[3],
+					     AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
+				}
+			}
+
+			if ((int32_t)AR9287_PWR_TABLE_OFFSET_DB !=
+				     pEepData->baseEepHeader.pwrTableOffset) {
+				diff = (u16)
+				       (pEepData->baseEepHeader.pwrTableOffset
+					- (int32_t)AR9287_PWR_TABLE_OFFSET_DB);
+				diff *= 2;
+
+				for (j = 0;
+				     j < ((u16)AR9287_NUM_PDADC_VALUES-diff);
+				     j++)
+					pdadcValues[j] = pdadcValues[j+diff];
+
+				for (j = (u16)(AR9287_NUM_PDADC_VALUES-diff);
+				     j < AR9287_NUM_PDADC_VALUES; j++)
+					pdadcValues[j] =
+					  pdadcValues[
+					  AR9287_NUM_PDADC_VALUES-diff];
+			}
+			if (!ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
+				regOffset = AR_PHY_BASE + (672 << 2) +
+							   regChainOffset;
+				for (j = 0; j < 32; j++) {
+					reg32 = ((pdadcValues[4*j + 0]
+						  & 0xFF) << 0)  |
+						((pdadcValues[4*j + 1]
+						  & 0xFF) << 8)  |
+						((pdadcValues[4*j + 2]
+						  & 0xFF) << 16) |
+						((pdadcValues[4*j + 3]
+						  & 0xFF) << 24) ;
+					REG_WRITE(ah, regOffset, reg32);
+
+					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+						"PDADC (%d,%4x): %4.4x %8.8x\n",
+						i, regChainOffset, regOffset,
+						reg32);
+					DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+						"PDADC: Chain %d | "
+						"PDADC %3d Value %3d | "
+						"PDADC %3d Value %3d | "
+						"PDADC %3d Value %3d | "
+						"PDADC %3d Value %3d |\n",
+						i, 4 * j, pdadcValues[4 * j],
+						4 * j + 1,
+						pdadcValues[4 * j + 1],
+						4 * j + 2,
+						pdadcValues[4 * j + 2],
+						4 * j + 3,
+						pdadcValues[4 * j + 3]);
+
+					regOffset += 4;
+				}
+			}
+		}
+	}
+
+	*pTxPowerIndexOffset = 0;
+}
+
+
+static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
+		struct ath9k_channel *chan, int16_t *ratesArray, u16 cfgCtl,
+		u16 AntennaReduction, u16 twiceMaxRegulatoryPower,
+		u16 powerLimit)
+{
+#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6
+#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10
+
+	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	static const u16 tpScaleReductionTable[5] = { 0, 3, 6, 9,
+						      AR5416_MAX_RATE_POWER };
+	int i;
+	int16_t  twiceLargestAntenna;
+	struct cal_ctl_data_ar9287 *rep;
+	struct cal_target_power_leg targetPowerOfdm = {0, {0, 0, 0, 0} },
+				    targetPowerCck = {0, {0, 0, 0, 0} };
+	struct cal_target_power_leg targetPowerOfdmExt = {0, {0, 0, 0, 0} },
+				    targetPowerCckExt = {0, {0, 0, 0, 0} };
+	struct cal_target_power_ht  targetPowerHt20,
+				    targetPowerHt40 = {0, {0, 0, 0, 0} };
+	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
+	u16 ctlModesFor11g[] = {CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT,
+				CTL_11G_EXT, CTL_2GHT40};
+	u16 numCtlModes = 0, *pCtlMode = NULL, ctlMode, freq;
+	struct chan_centers centers;
+	int tx_chainmask;
+	u16 twiceMinEdgePower;
+	struct ar9287_eeprom_t *pEepData = &ah->eeprom.map9287;
+	tx_chainmask = ah->txchainmask;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+
+	twiceLargestAntenna = max(pEepData->modalHeader.antennaGainCh[0],
+			pEepData->modalHeader.antennaGainCh[1]);
+
+	twiceLargestAntenna =  (int16_t)min((AntennaReduction) -
+					    twiceLargestAntenna, 0);
+
+	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
+	if (ah->regulatory.tp_scale != ATH9K_TP_SCALE_MAX)
+		maxRegAllowedPower -=
+			(tpScaleReductionTable[(ah->regulatory.tp_scale)] * 2);
+
+	scaledPower = min(powerLimit, maxRegAllowedPower);
+
+	switch (ar5416_get_ntxchains(tx_chainmask)) {
+	case 1:
+		break;
+	case 2:
+		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		break;
+	case 3:
+		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		break;
+	}
+	scaledPower = max((u16)0, scaledPower);
+
+	if (IS_CHAN_2GHZ(chan))	{
+		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
+					 SUB_NUM_CTL_MODES_AT_2G_40;
+		pCtlMode = ctlModesFor11g;
+
+		ath9k_hw_get_legacy_target_powers(ah, chan,
+				pEepData->calTargetPowerCck,
+				AR9287_NUM_2G_CCK_TARGET_POWERS,
+				&targetPowerCck, 4, false);
+		ath9k_hw_get_legacy_target_powers(ah, chan,
+				pEepData->calTargetPower2G,
+				AR9287_NUM_2G_20_TARGET_POWERS,
+				&targetPowerOfdm, 4, false);
+		ath9k_hw_get_target_powers(ah, chan,
+				pEepData->calTargetPower2GHT20,
+				AR9287_NUM_2G_20_TARGET_POWERS,
+				&targetPowerHt20, 8, false);
+
+		if (IS_CHAN_HT40(chan))	{
+			numCtlModes = ARRAY_SIZE(ctlModesFor11g);
+			ath9k_hw_get_target_powers(ah, chan,
+					pEepData->calTargetPower2GHT40,
+					AR9287_NUM_2G_40_TARGET_POWERS,
+					&targetPowerHt40, 8, true);
+			ath9k_hw_get_legacy_target_powers(ah, chan,
+					pEepData->calTargetPowerCck,
+					AR9287_NUM_2G_CCK_TARGET_POWERS,
+					&targetPowerCckExt, 4, true);
+			ath9k_hw_get_legacy_target_powers(ah, chan,
+					pEepData->calTargetPower2G,
+					AR9287_NUM_2G_20_TARGET_POWERS,
+					&targetPowerOfdmExt, 4, true);
+		}
+	}
+
+	for (ctlMode = 0; ctlMode < numCtlModes; ctlMode++) {
+
+		bool isHt40CtlMode = (pCtlMode[ctlMode] == CTL_5GHT40) ||
+				     (pCtlMode[ctlMode] == CTL_2GHT40);
+		if (isHt40CtlMode)
+			freq = centers.synth_center;
+		else if (pCtlMode[ctlMode] & EXT_ADDITIVE)
+			freq = centers.ext_center;
+		else
+			freq = centers.ctl_center;
+
+
+		if (ah->eep_ops->get_eeprom_ver(ah) == 14 &&
+				ah->eep_ops->get_eeprom_rev(ah) <= 2)
+			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+			"LOOP-Mode ctlMode %d < %d, isHt40CtlMode %d,"
+			 "EXT_ADDITIVE %d\n", ctlMode, numCtlModes,
+			 isHt40CtlMode, (pCtlMode[ctlMode] & EXT_ADDITIVE));
+		for (i = 0; (i < AR9287_NUM_CTLS)
+			     && pEepData->ctlIndex[i]; i++) {
+			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"LOOP-Ctlidx %d: cfgCtl 0x%2.2x"
+				 "pCtlMode 0x%2.2x ctlIndex 0x%2.2x"
+				 "chan %d chanctl=xxxx\n",
+				 i, cfgCtl, pCtlMode[ctlMode],
+				 pEepData->ctlIndex[i],	chan->channel);
+
+			if ((((cfgCtl & ~CTL_MODE_M) |
+			    (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+			    pEepData->ctlIndex[i]) ||
+			    (((cfgCtl & ~CTL_MODE_M) |
+			    (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+			    ((pEepData->ctlIndex[i] &
+			    CTL_MODE_M) | SD_NO_CTL))) {
+
+				rep = &(pEepData->ctlData[i]);
+				twiceMinEdgePower = ath9k_hw_get_max_edge_power(
+				    freq,
+				    rep->ctlEdges[ar5416_get_ntxchains(
+				    tx_chainmask) - 1],
+				    IS_CHAN_2GHZ(chan), AR5416_NUM_BAND_EDGES);
+
+				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+					"MATCH-EE_IDX %d: ch %d is2 %d"
+					"2xMinEdge %d chainmask %d chains %d\n",
+					 i, freq, IS_CHAN_2GHZ(chan),
+					 twiceMinEdgePower, tx_chainmask,
+					 ar5416_get_ntxchains(tx_chainmask));
+
+				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL)
+					twiceMaxEdgePower = min(
+							    twiceMaxEdgePower,
+							    twiceMinEdgePower);
+				else {
+					twiceMaxEdgePower = twiceMinEdgePower;
+					break;
+				}
+			}
+		}
+
+		minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
+
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"SEL-Min ctlMode %d pCtlMode %d 2xMaxEdge %d"
+				 "sP %d minCtlPwr %d\n",
+				 ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
+				 scaledPower, minCtlPower);
+
+
+		switch (pCtlMode[ctlMode]) {
+
+		case CTL_11B:
+			for (i = 0;
+			     i < ARRAY_SIZE(targetPowerCck.tPow2x);
+			     i++) {
+				targetPowerCck.tPow2x[i] = (u8)min(
+					(u16)targetPowerCck.tPow2x[i],
+					minCtlPower);
+			}
+			break;
+		case CTL_11A:
+		case CTL_11G:
+			for (i = 0;
+			     i < ARRAY_SIZE(targetPowerOfdm.tPow2x);
+			     i++) {
+				targetPowerOfdm.tPow2x[i] = (u8)min(
+					(u16)targetPowerOfdm.tPow2x[i],
+					minCtlPower);
+			}
+			break;
+		case CTL_5GHT20:
+		case CTL_2GHT20:
+			for (i = 0;
+			     i < ARRAY_SIZE(targetPowerHt20.tPow2x);
+			     i++) {
+				targetPowerHt20.tPow2x[i] = (u8)min(
+					(u16)targetPowerHt20.tPow2x[i],
+					minCtlPower);
+			}
+			break;
+		case CTL_11B_EXT:
+			targetPowerCckExt.tPow2x[0] = (u8)min(
+				    (u16)targetPowerCckExt.tPow2x[0],
+				    minCtlPower);
+			break;
+		case CTL_11A_EXT:
+		case CTL_11G_EXT:
+			targetPowerOfdmExt.tPow2x[0] = (u8)min(
+				    (u16)targetPowerOfdmExt.tPow2x[0],
+				    minCtlPower);
+			break;
+		case CTL_5GHT40:
+		case CTL_2GHT40:
+			for (i = 0;
+			     i < ARRAY_SIZE(targetPowerHt40.tPow2x);
+			     i++) {
+				targetPowerHt40.tPow2x[i] = (u8)min(
+					(u16)targetPowerHt40.tPow2x[i],
+					minCtlPower);
+			}
+			break;
+		default:
+			break;
+		}
+	}
+
+	ratesArray[rate6mb] = ratesArray[rate9mb] = ratesArray[rate12mb] =
+		ratesArray[rate18mb] = ratesArray[rate24mb] =
+		targetPowerOfdm.tPow2x[0];
+	ratesArray[rate36mb] = targetPowerOfdm.tPow2x[1];
+	ratesArray[rate48mb] = targetPowerOfdm.tPow2x[2];
+	ratesArray[rate54mb] = targetPowerOfdm.tPow2x[3];
+	ratesArray[rateXr] = targetPowerOfdm.tPow2x[0];
+
+	for (i = 0; i < ARRAY_SIZE(targetPowerHt20.tPow2x); i++)
+		ratesArray[rateHt20_0 + i] = targetPowerHt20.tPow2x[i];
+
+	if (IS_CHAN_2GHZ(chan))	{
+		ratesArray[rate1l]  = targetPowerCck.tPow2x[0];
+		ratesArray[rate2s] = ratesArray[rate2l]  =
+			targetPowerCck.tPow2x[1];
+		ratesArray[rate5_5s] = ratesArray[rate5_5l] =
+			targetPowerCck.tPow2x[2];
+		ratesArray[rate11s] = ratesArray[rate11l] =
+			targetPowerCck.tPow2x[3];
+	}
+	if (IS_CHAN_HT40(chan))	{
+		for (i = 0; i < ARRAY_SIZE(targetPowerHt40.tPow2x); i++)
+			ratesArray[rateHt40_0 + i] = targetPowerHt40.tPow2x[i];
+
+		ratesArray[rateDupOfdm] = targetPowerHt40.tPow2x[0];
+		ratesArray[rateDupCck]  = targetPowerHt40.tPow2x[0];
+		ratesArray[rateExtOfdm] = targetPowerOfdmExt.tPow2x[0];
+		if (IS_CHAN_2GHZ(chan))
+			ratesArray[rateExtCck]  = targetPowerCckExt.tPow2x[0];
+	}
+#undef REDUCE_SCALED_POWER_BY_TWO_CHAIN
+#undef REDUCE_SCALED_POWER_BY_THREE_CHAIN
+}
+
+static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
+		struct ath9k_channel *chan, u16 cfgCtl,
+		u8 twiceAntennaReduction, u8 twiceMaxRegulatoryPower,
+		u8 powerLimit)
+{
+#define INCREASE_MAXPOW_BY_TWO_CHAIN     6
+#define INCREASE_MAXPOW_BY_THREE_CHAIN   10
+	struct ar9287_eeprom_t *pEepData = &ah->eeprom.map9287;
+	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
+	int16_t ratesArray[Ar5416RateSize];
+	int16_t  txPowerIndexOffset = 0;
+	u8 ht40PowerIncForPdadc = 2;
+	int i;
+	memset(ratesArray, 0, sizeof(ratesArray));
+
+	if ((pEepData->baseEepHeader.version & AR9287_EEP_VER_MINOR_MASK) >=
+			AR9287_EEP_MINOR_VER_2)
+		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
+
+	ath9k_hw_set_AR9287_power_per_rate_table(ah, chan,
+			&ratesArray[0], cfgCtl,
+			twiceAntennaReduction,
+			twiceMaxRegulatoryPower,
+			powerLimit);
+
+
+	ath9k_hw_set_AR9287_power_cal_table(ah, chan, &txPowerIndexOffset);
+
+	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
+		ratesArray[i] = (int16_t)(txPowerIndexOffset + ratesArray[i]);
+		if (ratesArray[i] > AR9287_MAX_RATE_POWER)
+			ratesArray[i] = AR9287_MAX_RATE_POWER;
+	}
+
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		for (i = 0; i < Ar5416RateSize; i++)
+			ratesArray[i] -= AR9287_PWR_TABLE_OFFSET_DB * 2;
+	}
+
+
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
+			ATH9K_POW_SM(ratesArray[rate18mb], 24)
+			| ATH9K_POW_SM(ratesArray[rate12mb], 16)
+			| ATH9K_POW_SM(ratesArray[rate9mb],  8)
+			| ATH9K_POW_SM(ratesArray[rate6mb],  0)
+		 );
+
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE2,
+			ATH9K_POW_SM(ratesArray[rate54mb], 24)
+			| ATH9K_POW_SM(ratesArray[rate48mb], 16)
+			| ATH9K_POW_SM(ratesArray[rate36mb],  8)
+			| ATH9K_POW_SM(ratesArray[rate24mb],  0)
+		 );
+
+	if (IS_CHAN_2GHZ(chan))	{
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
+				ATH9K_POW_SM(ratesArray[rate2s], 24)
+				| ATH9K_POW_SM(ratesArray[rate2l],  16)
+				| ATH9K_POW_SM(ratesArray[rateXr],  8)
+				| ATH9K_POW_SM(ratesArray[rate1l],   0)
+			 );
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE4,
+				ATH9K_POW_SM(ratesArray[rate11s], 24)
+				| ATH9K_POW_SM(ratesArray[rate11l], 16)
+				| ATH9K_POW_SM(ratesArray[rate5_5s],  8)
+				| ATH9K_POW_SM(ratesArray[rate5_5l],  0)
+			 );
+	}
+
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE5,
+			ATH9K_POW_SM(ratesArray[rateHt20_3], 24)
+			| ATH9K_POW_SM(ratesArray[rateHt20_2],  16)
+			| ATH9K_POW_SM(ratesArray[rateHt20_1],  8)
+			| ATH9K_POW_SM(ratesArray[rateHt20_0],   0)
+		 );
+
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE6,
+			ATH9K_POW_SM(ratesArray[rateHt20_7], 24)
+			| ATH9K_POW_SM(ratesArray[rateHt20_6],  16)
+			| ATH9K_POW_SM(ratesArray[rateHt20_5],  8)
+			| ATH9K_POW_SM(ratesArray[rateHt20_4],   0)
+		 );
+
+	if (IS_CHAN_HT40(chan))	{
+		if (ath9k_hw_AR9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
+				  ATH9K_POW_SM(ratesArray[rateHt40_3], 24)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_2],  16)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_1],  8)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_0],   0)
+				 );
+
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE8,
+				  ATH9K_POW_SM(ratesArray[rateHt40_7], 24)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_6],  16)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_5],  8)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_4],   0)
+				 );
+		} else {
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE7,
+				  ATH9K_POW_SM(ratesArray[rateHt40_3] +
+					       ht40PowerIncForPdadc, 24)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_2] +
+					       ht40PowerIncForPdadc,  16)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_1] +
+					       ht40PowerIncForPdadc,  8)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_0] +
+					       ht40PowerIncForPdadc,   0)
+				 );
+
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE8,
+				  ATH9K_POW_SM(ratesArray[rateHt40_7] +
+					       ht40PowerIncForPdadc, 24)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_6] +
+					       ht40PowerIncForPdadc,  16)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_5] +
+					       ht40PowerIncForPdadc,  8)
+				  | ATH9K_POW_SM(ratesArray[rateHt40_4] +
+					       ht40PowerIncForPdadc,   0)
+				 );
+
+		}
+
+		REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
+				ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
+				| ATH9K_POW_SM(ratesArray[rateExtCck],  16)
+				| ATH9K_POW_SM(ratesArray[rateDupOfdm],  8)
+				| ATH9K_POW_SM(ratesArray[rateDupCck],   0)
+			 );
+	}
+
+
+	if (IS_CHAN_2GHZ(chan))
+		i = rate1l;
+	else
+		i = rate6mb;
+
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ah->regulatory.max_power_level =
+			ratesArray[i] + AR9287_PWR_TABLE_OFFSET_DB * 2;
+	else
+		ah->regulatory.max_power_level = ratesArray[i];
+
+	switch (ar5416_get_ntxchains(ah->txchainmask)) {
+	case 1:
+		break;
+	case 2:
+		ah->regulatory.max_power_level +=
+			INCREASE_MAXPOW_BY_TWO_CHAIN;
+		break;
+	case 3:
+		ah->regulatory.max_power_level +=
+			INCREASE_MAXPOW_BY_THREE_CHAIN;
+		break;
+	default:
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
+				"Invalid chainmask configuration\n");
+		break;
+	}
+}
+
+static void ath9k_hw_AR9287_set_addac(struct ath_hw *ah,
+				      struct ath9k_channel *chan)
+{
+	return;
+}
+
+static void ath9k_hw_AR9287_set_board_values(struct ath_hw *ah,
+					     struct ath9k_channel *chan)
+{
+	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
+
+	u16 antWrites[AR9287_ANT_16S];
+	u32 regChainOffset;
+	u8 txRxAttenLocal;
+	int i, j, offset_num;
+
+	pModal = &eep->modalHeader;
+
+	antWrites[0] = (u16)((pModal->antCtrlCommon >> 28) & 0xF);
+	antWrites[1] = (u16)((pModal->antCtrlCommon >> 24) & 0xF);
+	antWrites[2] = (u16)((pModal->antCtrlCommon >> 20) & 0xF);
+	antWrites[3] = (u16)((pModal->antCtrlCommon >> 16) & 0xF);
+	antWrites[4] = (u16)((pModal->antCtrlCommon >> 12) & 0xF);
+	antWrites[5] = (u16)((pModal->antCtrlCommon >> 8) & 0xF);
+	antWrites[6] = (u16)((pModal->antCtrlCommon >> 4)  & 0xF);
+	antWrites[7] = (u16)(pModal->antCtrlCommon & 0xF);
+
+	offset_num = 8;
+
+	for (i = 0, j = offset_num; i < AR9287_MAX_CHAINS; i++) {
+		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 28) & 0xf);
+		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 10) & 0x3);
+		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 8) & 0x3);
+		antWrites[j++] = 0;
+		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 6) & 0x3);
+		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 4) & 0x3);
+		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 2) & 0x3);
+		antWrites[j++] = (u16)(pModal->antCtrlChain[i] & 0x3);
+	}
+
+
+	REG_WRITE(ah, AR_PHY_SWITCH_COM,
+		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
+
+	for (i = 0; i < AR9287_MAX_CHAINS; i++)	{
+		regChainOffset = i * 0x1000;
+
+		REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0 + regChainOffset,
+			  pModal->antCtrlChain[i]);
+
+		REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset,
+			  (REG_READ(ah, AR_PHY_TIMING_CTRL4(0) + regChainOffset)
+			   & ~(AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF |
+			   AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF)) |
+			   SM(pModal->iqCalICh[i],
+			      AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF) |
+			   SM(pModal->iqCalQCh[i],
+			      AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF));
+
+		txRxAttenLocal = pModal->txRxAttenCh[i];
+
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			      AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN,
+			      pModal->bswMargin[i]);
+		REG_RMW_FIELD(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
+			      AR_PHY_GAIN_2GHZ_XATTEN1_DB,
+			      pModal->bswAtten[i]);
+		REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
+			      AR9280_PHY_RXGAIN_TXRX_ATTEN,
+			      txRxAttenLocal);
+		REG_RMW_FIELD(ah, AR_PHY_RXGAIN + regChainOffset,
+			      AR9280_PHY_RXGAIN_TXRX_MARGIN,
+			      pModal->rxTxMarginCh[i]);
+	}
+
+
+	if (IS_CHAN_HT40(chan))
+		REG_RMW_FIELD(ah, AR_PHY_SETTLING,
+			      AR_PHY_SETTLING_SWITCH, pModal->swSettleHt40);
+	else
+		REG_RMW_FIELD(ah, AR_PHY_SETTLING,
+			      AR_PHY_SETTLING_SWITCH, pModal->switchSettling);
+
+	REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
+		      AR_PHY_DESIRED_SZ_ADC, pModal->adcDesiredSize);
+
+	REG_WRITE(ah, AR_PHY_RF_CTL4,
+		  SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAA_OFF)
+		  | SM(pModal->txEndToXpaOff, AR_PHY_RF_CTL4_TX_END_XPAB_OFF)
+		  | SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAA_ON)
+		  | SM(pModal->txFrameToXpaOn, AR_PHY_RF_CTL4_FRAME_XPAB_ON));
+
+	REG_RMW_FIELD(ah, AR_PHY_RF_CTL3,
+		      AR_PHY_TX_END_TO_A2_RX_ON, pModal->txEndToRxOn);
+
+	REG_RMW_FIELD(ah, AR_PHY_CCA,
+		      AR9280_PHY_CCA_THRESH62, pModal->thresh62);
+	REG_RMW_FIELD(ah, AR_PHY_EXT_CCA0,
+		      AR_PHY_EXT_CCA0_THRESH62, pModal->thresh62);
+
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0, AR9287_AN_RF2G3_DB1,
+				  AR9287_AN_RF2G3_DB1_S, pModal->db1);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0, AR9287_AN_RF2G3_DB2,
+				  AR9287_AN_RF2G3_DB2_S, pModal->db2);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0,
+				  AR9287_AN_RF2G3_OB_CCK,
+				  AR9287_AN_RF2G3_OB_CCK_S, pModal->ob_cck);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0,
+				  AR9287_AN_RF2G3_OB_PSK,
+				  AR9287_AN_RF2G3_OB_PSK_S, pModal->ob_psk);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0,
+				  AR9287_AN_RF2G3_OB_QAM,
+				  AR9287_AN_RF2G3_OB_QAM_S, pModal->ob_qam);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH0,
+				  AR9287_AN_RF2G3_OB_PAL_OFF,
+				  AR9287_AN_RF2G3_OB_PAL_OFF_S,
+				  pModal->ob_pal_off);
+
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
+				  AR9287_AN_RF2G3_DB1, AR9287_AN_RF2G3_DB1_S,
+				  pModal->db1);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1, AR9287_AN_RF2G3_DB2,
+				  AR9287_AN_RF2G3_DB2_S, pModal->db2);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
+				  AR9287_AN_RF2G3_OB_CCK,
+				  AR9287_AN_RF2G3_OB_CCK_S, pModal->ob_cck);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
+				  AR9287_AN_RF2G3_OB_PSK,
+				  AR9287_AN_RF2G3_OB_PSK_S, pModal->ob_psk);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
+				  AR9287_AN_RF2G3_OB_QAM,
+				  AR9287_AN_RF2G3_OB_QAM_S, pModal->ob_qam);
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_RF2G3_CH1,
+				  AR9287_AN_RF2G3_OB_PAL_OFF,
+				  AR9287_AN_RF2G3_OB_PAL_OFF_S,
+				  pModal->ob_pal_off);
+
+	REG_RMW_FIELD(ah, AR_PHY_RF_CTL2,
+		      AR_PHY_TX_END_DATA_START, pModal->txFrameToDataStart);
+	REG_RMW_FIELD(ah, AR_PHY_RF_CTL2,
+		      AR_PHY_TX_END_PA_ON, pModal->txFrameToPaOn);
+
+	ath9k_hw_analog_shift_rmw(ah, AR9287_AN_TOP2,
+				  AR9287_AN_TOP2_XPABIAS_LVL,
+				  AR9287_AN_TOP2_XPABIAS_LVL_S,
+				  pModal->xpaBiasLvl);
+}
+
+static u8 ath9k_hw_AR9287_get_num_ant_config(struct ath_hw *ah,
+		enum ieee80211_band freq_band)
+{
+	return 1;
+}
+
+
+
+
+static u16 ath9k_hw_AR9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
+		struct ath9k_channel *chan)
+{
+	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
+	return pModal->antCtrlCommon & 0xFFFF;
+}
+
+
+static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
+					    u16 i, bool is2GHz)
+{
+#define EEP_MAP9287_SPURCHAN \
+	(ah->eeprom.map9287.modalHeader.spurChans[i].spurChan)
+	u16 spur_val = AR_NO_SPUR;
+
+	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+			"Getting spur idx %d is2Ghz. %d val %x\n",
+			i, is2GHz, ah->config.spurchans[i][is2GHz]);
+
+	switch (ah->config.spurmode) {
+	case SPUR_DISABLE:
+		break;
+	case SPUR_ENABLE_IOCTL:
+		spur_val = ah->config.spurchans[i][is2GHz];
+		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
+		       "Getting spur val from new loc. %d\n", spur_val);
+		break;
+	case SPUR_ENABLE_EEPROM:
+		spur_val = EEP_MAP9287_SPURCHAN;
+		break;
+	}
+
+	return spur_val;
+
+#undef EEP_MAP9287_SPURCHAN
+}
+
+static struct eeprom_ops eep_AR9287_ops = {
+	.check_eeprom		= ath9k_hw_AR9287_check_eeprom,
+	.get_eeprom		= ath9k_hw_AR9287_get_eeprom,
+	.fill_eeprom		= ath9k_hw_AR9287_fill_eeprom,
+	.get_eeprom_ver		= ath9k_hw_AR9287_get_eeprom_ver,
+	.get_eeprom_rev		= ath9k_hw_AR9287_get_eeprom_rev,
+	.get_num_ant_config	= ath9k_hw_AR9287_get_num_ant_config,
+	.get_eeprom_antenna_cfg	= ath9k_hw_AR9287_get_eeprom_antenna_cfg,
+	.set_board_values	= ath9k_hw_AR9287_set_board_values,
+	.set_addac		= ath9k_hw_AR9287_set_addac,
+	.set_txpower		= ath9k_hw_AR9287_set_txpower,
+	.get_spur_channel	= ath9k_hw_AR9287_get_spur_channel
+};
+
+
 int ath9k_hw_eeprom_attach(struct ath_hw *ah)
 {
 	int status;
-
-	if (AR_SREV_9285(ah)) {
+	if (AR_SREV_9287(ah)) {
+		ah->eep_map = EEP_MAP_AR9287;
+		ah->eep_ops = &eep_AR9287_ops;
+	} else if (AR_SREV_9285(ah)) {
 		ah->eep_map = EEP_MAP_4KBITS;
 		ah->eep_ops = &eep_4k_ops;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 67b8bd1..7ddd016 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -100,6 +100,8 @@
 #define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
 #define OLC_FOR_AR9280_20_LATER (AR_SREV_9280_20_OR_LATER(ah) && \
 				 ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+#define OLC_FOR_AR9287_10_LATER (AR_SREV_9287_10_OR_LATER(ah) && \
+				 ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 
 #define AR_EEPROM_RFSILENT_GPIO_SEL     0x001c
 #define AR_EEPROM_RFSILENT_GPIO_SEL_S   2
@@ -176,6 +178,57 @@
 
 #define AR9280_TX_GAIN_TABLE_SIZE 22
 
+#define AR9287_EEP_VER               0xE
+#define AR9287_EEP_VER_MINOR_MASK    0xFFF
+#define AR9287_EEP_MINOR_VER_1       0x1
+#define AR9287_EEP_MINOR_VER_2       0x2
+#define AR9287_EEP_MINOR_VER_3       0x3
+#define AR9287_EEP_MINOR_VER         AR9287_EEP_MINOR_VER_3
+#define AR9287_EEP_MINOR_VER_b       AR9287_EEP_MINOR_VER
+#define AR9287_EEP_NO_BACK_VER       AR9287_EEP_MINOR_VER_1
+
+#define AR9287_EEP_START_LOC            128
+#define AR9287_NUM_2G_CAL_PIERS         3
+#define AR9287_NUM_2G_CCK_TARGET_POWERS 3
+#define AR9287_NUM_2G_20_TARGET_POWERS  3
+#define AR9287_NUM_2G_40_TARGET_POWERS  3
+#define AR9287_NUM_CTLS              	12
+#define AR9287_NUM_BAND_EDGES        	4
+#define AR9287_NUM_PD_GAINS             4
+#define AR9287_PD_GAINS_IN_MASK         4
+#define AR9287_PD_GAIN_ICEPTS           1
+#define AR9287_EEPROM_MODAL_SPURS       5
+#define AR9287_MAX_RATE_POWER           63
+#define AR9287_NUM_PDADC_VALUES         128
+#define AR9287_NUM_RATES                16
+#define AR9287_BCHAN_UNUSED             0xFF
+#define AR9287_MAX_PWR_RANGE_IN_HALF_DB 64
+#define AR9287_OPFLAGS_11A              0x01
+#define AR9287_OPFLAGS_11G              0x02
+#define AR9287_OPFLAGS_2G_HT40          0x08
+#define AR9287_OPFLAGS_2G_HT20          0x20
+#define AR9287_OPFLAGS_5G_HT40          0x04
+#define AR9287_OPFLAGS_5G_HT20          0x10
+#define AR9287_EEPMISC_BIG_ENDIAN       0x01
+#define AR9287_EEPMISC_WOW              0x02
+#define AR9287_MAX_CHAINS               2
+#define AR9287_ANT_16S                  32
+#define AR9287_custdatasize             20
+
+#define AR9287_NUM_ANT_CHAIN_FIELDS     6
+#define AR9287_NUM_ANT_COMMON_FIELDS    4
+#define AR9287_SIZE_ANT_CHAIN_FIELD     2
+#define AR9287_SIZE_ANT_COMMON_FIELD    4
+#define AR9287_ANT_CHAIN_MASK           0x3
+#define AR9287_ANT_COMMON_MASK          0xf
+#define AR9287_CHAIN_0_IDX              0
+#define AR9287_CHAIN_1_IDX              1
+#define AR9287_DATA_SZ                  32
+
+#define AR9287_PWR_TABLE_OFFSET_DB  -5
+
+#define AR9287_CHECKSUM_LOCATION (AR9287_EEP_START_LOC + 1)
+
 enum eeprom_param {
 	EEP_NFTHRESH_5,
 	EEP_NFTHRESH_2,
@@ -199,7 +252,11 @@ enum eeprom_param {
 	EEP_OL_PWRCTRL,
 	EEP_RC_CHAIN_MASK,
 	EEP_DAC_HPWR_5G,
-	EEP_FRAC_N_5G
+	EEP_FRAC_N_5G,
+	EEP_DEV_TYPE,
+	EEP_TEMPSENSE_SLOPE,
+	EEP_TEMPSENSE_SLOPE_PAL_ON,
+	EEP_PWR_TABLE_OFFSET
 };
 
 enum ar5416_rates {
@@ -368,6 +425,65 @@ struct modal_eep_4k_header {
 	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
 } __packed;
 
+struct base_eep_ar9287_header {
+    u16  length;
+    u16  checksum;
+    u16  version;
+    u8 opCapFlags;
+    u8   eepMisc;
+    u16  regDmn[2];
+    u8   macAddr[6];
+    u8   rxMask;
+    u8   txMask;
+    u16  rfSilent;
+    u16  blueToothOptions;
+    u16  deviceCap;
+    u32  binBuildNumber;
+    u8   deviceType;
+    u8   openLoopPwrCntl;
+    int8_t    pwrTableOffset;
+    int8_t     tempSensSlope;
+    int8_t     tempSensSlopePalOn;
+    u8   futureBase[29];
+} __packed;
+
+struct modal_eep_ar9287_header {
+    u32  antCtrlChain[AR9287_MAX_CHAINS];
+    u32  antCtrlCommon;
+    int8_t    antennaGainCh[AR9287_MAX_CHAINS];
+    u8   switchSettling;
+    u8   txRxAttenCh[AR9287_MAX_CHAINS];
+    u8   rxTxMarginCh[AR9287_MAX_CHAINS];
+    int8_t    adcDesiredSize;
+    u8   txEndToXpaOff;
+    u8   txEndToRxOn;
+    u8   txFrameToXpaOn;
+    u8   thresh62;
+    int8_t    noiseFloorThreshCh[AR9287_MAX_CHAINS];
+    u8   xpdGain;
+    u8   xpd;
+    int8_t    iqCalICh[AR9287_MAX_CHAINS];
+    int8_t    iqCalQCh[AR9287_MAX_CHAINS];
+    u8   pdGainOverlap;
+    u8   xpaBiasLvl;
+    u8   txFrameToDataStart;
+    u8   txFrameToPaOn;
+    u8   ht40PowerIncForPdadc;
+    u8   bswAtten[AR9287_MAX_CHAINS];
+    u8   bswMargin[AR9287_MAX_CHAINS];
+    u8   swSettleHt40;
+	u8   version;
+    u8   db1;
+    u8   db2;
+    u8   ob_cck;
+    u8   ob_psk;
+    u8   ob_qam;
+    u8   ob_pal_off;
+    u8   futureModal[30];
+    struct spur_chan spurChans[AR9287_EEPROM_MODAL_SPURS];
+} __packed;
+
+
 
 struct cal_data_per_freq {
 	u8 pwrPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
@@ -402,6 +518,29 @@ struct cal_ctl_edges {
 } __packed;
 #endif
 
+struct cal_data_op_loop_ar9287 {
+	u8 pwrPdg[2][5];
+	u8 vpdPdg[2][5];
+	u8 pcdac[2][5];
+	u8 empty[2][5];
+} __packed;
+
+
+struct cal_data_per_freq_ar9287 {
+	u8 pwrPdg[AR9287_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
+	u8 vpdPdg[AR9287_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
+} __packed;
+
+union cal_data_per_freq_ar9287_u {
+	struct cal_data_op_loop_ar9287 calDataOpen;
+	struct cal_data_per_freq_ar9287 calDataClose;
+} __packed;
+
+struct cal_ctl_data_ar9287 {
+	struct cal_ctl_edges
+	ctlEdges[AR9287_MAX_CHAINS][AR9287_NUM_BAND_EDGES];
+} __packed;
+
 struct cal_ctl_data {
 	struct cal_ctl_edges
 	ctlEdges[AR5416_MAX_CHAINS][AR5416_NUM_BAND_EDGES];
@@ -461,6 +600,27 @@ struct ar5416_eeprom_4k {
 	u8 padding;
 } __packed;
 
+struct ar9287_eeprom_t {
+	struct base_eep_ar9287_header  baseEepHeader;
+	u8 custData[AR9287_DATA_SZ];
+	struct modal_eep_ar9287_header modalHeader;
+	u8 calFreqPier2G[AR9287_NUM_2G_CAL_PIERS];
+	union cal_data_per_freq_ar9287_u
+	 calPierData2G[AR9287_MAX_CHAINS][AR9287_NUM_2G_CAL_PIERS];
+	struct cal_target_power_leg
+	 calTargetPowerCck[AR9287_NUM_2G_CCK_TARGET_POWERS];
+	struct cal_target_power_leg
+	 calTargetPower2G[AR9287_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower2GHT20[AR9287_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower2GHT40[AR9287_NUM_2G_40_TARGET_POWERS];
+	u8 ctlIndex[AR9287_NUM_CTLS];
+	struct cal_ctl_data_ar9287 ctlData[AR9287_NUM_CTLS];
+	u8 padding;
+} __packed;
+
+
 enum reg_ext_bitmap {
 	REG_EXT_JAPAN_MIDBAND = 1,
 	REG_EXT_FCC_DFS_HT40 = 2,
@@ -480,6 +640,7 @@ struct ath9k_country_entry {
 enum ath9k_eep_map {
 	EEP_MAP_DEFAULT = 0x0,
 	EEP_MAP_4KBITS,
+	EEP_MAP_AR9287,
 	EEP_MAP_MAX
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 605803a..da32269 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -380,6 +380,9 @@ static const char *ath9k_hw_devname(u16 devid)
 		return "Atheros 9280";
 	case AR9285_DEVID_PCIE:
 		return "Atheros 9285";
+	case AR5416_DEVID_AR9287_PCI:
+	case AR5416_DEVID_AR9287_PCIE:
+		return "Atheros 9287";
 	}
 
 	return NULL;
@@ -660,7 +663,8 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if ((ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCI) &&
 	    (ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCIE) &&
 	    (ah->hw_version.macVersion != AR_SREV_VERSION_9160) &&
-	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah)) && (!AR_SREV_9285(ah))) {
+	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah)) &&
+	    (!AR_SREV_9285(ah)) && (!AR_SREV_9287(ah))) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
 			"this driver\n", ah->hw_version.macVersion,
@@ -700,8 +704,37 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	ah->ani_function = ATH9K_ANI_ALL;
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
+	if (AR_SREV_9287_11_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1,
+				ARRAY_SIZE(ar9287Modes_9287_1_1), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_1,
+				ARRAY_SIZE(ar9287Common_9287_1_1), 2);
+		if (ah->config.pcie_clock_req)
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_off_L1_9287_1_1,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_1), 2);
+		else
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_always_on_L1_9287_1_1,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_1),
+					2);
+	} else if (AR_SREV_9287_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_0,
+				ARRAY_SIZE(ar9287Modes_9287_1_0), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_0,
+				ARRAY_SIZE(ar9287Common_9287_1_0), 2);
+
+		if (ah->config.pcie_clock_req)
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_off_L1_9287_1_0,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_0), 2);
+		else
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_always_on_L1_9287_1_0,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_0),
+				  2);
+	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
 
-	if (AR_SREV_9285_12_OR_LATER(ah)) {
 
 		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285_1_2,
 			       ARRAY_SIZE(ar9285Modes_9285_1_2), 6);
@@ -842,7 +875,28 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if (ecode != 0)
 		goto bad;
 
-	if (AR_SREV_9285_12_OR_LATER(ah)) {
+	if (AR_SREV_9287_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+		ar9287Modes_rx_gain_9287_1_1,
+		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_1), 6);
+	else if (AR_SREV_9287_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+		ar9287Modes_rx_gain_9287_1_0,
+		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_0), 6);
+	else if (AR_SREV_9280_20(ah))
+		ath9k_hw_init_rxgain_ini(ah);
+
+	if (AR_SREV_9287_11(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9287Modes_tx_gain_9287_1_1,
+		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_1), 6);
+	} else if (AR_SREV_9287_10(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9287Modes_tx_gain_9287_1_0,
+		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_0), 6);
+	} else if (AR_SREV_9280_20(ah)) {
+		ath9k_hw_init_txgain_ini(ah);
+	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
 		u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
 
 		/* txgain table */
@@ -858,14 +912,6 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 
 	}
 
-	/* rxgain table */
-	if (AR_SREV_9280_20(ah))
-		ath9k_hw_init_rxgain_ini(ah);
-
-	/* txgain table */
-	if (AR_SREV_9280_20(ah))
-		ath9k_hw_init_txgain_ini(ah);
-
 	ath9k_hw_fill_cap_info(ah);
 
 	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
@@ -1165,6 +1211,8 @@ struct ath_hw *ath9k_hw_attach(u16 devid, struct ath_softc *sc, int *error)
 	case AR9280_DEVID_PCI:
 	case AR9280_DEVID_PCIE:
 	case AR9285_DEVID_PCIE:
+	case AR5416_DEVID_AR9287_PCI:
+	case AR5416_DEVID_AR9287_PCIE:
 		ah = ath9k_hw_do_attach(devid, sc, error);
 		break;
 	default:
@@ -1341,10 +1389,11 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		DO_DELAY(regWrites);
 	}
 
-	if (AR_SREV_9280(ah))
+	if (AR_SREV_9280(ah) || AR_SREV_9287_10_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
 
-	if (AR_SREV_9280(ah) || AR_SREV_9285_12_OR_LATER(ah))
+	if (AR_SREV_9280(ah) || AR_SREV_9285_12_OR_LATER(ah) ||
+	    AR_SREV_9287_10_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
 	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
@@ -2254,6 +2303,16 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
 
+	if (AR_SREV_9287_10_OR_LATER(ah)) {
+		/* Enable ASYNC FIFO */
+		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL);
+		REG_SET_BIT(ah, AR_PHY_MODE, AR_PHY_MODE_ASYNCFIFO);
+		REG_CLR_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
+		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
+	}
 	r = ath9k_hw_process_ini(ah, chan, sc->tx_chan_width);
 	if (r)
 		return r;
@@ -2330,6 +2389,27 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_init_user_settings(ah);
 
+	if (AR_SREV_9287_10_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_D_GBL_IFS_SIFS,
+			  AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR);
+		REG_WRITE(ah, AR_D_GBL_IFS_SLOT,
+			  AR_D_GBL_IFS_SLOT_ASYNC_FIFO_DUR);
+		REG_WRITE(ah, AR_D_GBL_IFS_EIFS,
+			  AR_D_GBL_IFS_EIFS_ASYNC_FIFO_DUR);
+
+		REG_WRITE(ah, AR_TIME_OUT, AR_TIME_OUT_ACK_CTS_ASYNC_FIFO_DUR);
+		REG_WRITE(ah, AR_USEC, AR_USEC_ASYNC_FIFO_DUR);
+
+		REG_SET_BIT(ah, AR_MAC_PCU_LOGIC_ANALYZER,
+			    AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768);
+		REG_RMW_FIELD(ah, AR_AHB_MODE, AR_AHB_CUSTOM_BURST_EN,
+			      AR_AHB_CUSTOM_BURST_ASYNC_FIFO_VAL);
+	}
+	if (AR_SREV_9287_10_OR_LATER(ah)) {
+		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
+				AR_PCU_MISC_MODE2_ENABLE_AGGWEP);
+	}
+
 	REG_WRITE(ah, AR_STA_ID1,
 		  REG_READ(ah, AR_STA_ID1) | AR_STA_ID1_PRESERVE_SEQNUM);
 
@@ -3644,7 +3724,9 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 	if (gpio >= ah->caps.num_gpio_pins)
 		return 0xffffffff;
 
-	if (AR_SREV_9285_10_OR_LATER(ah))
+	if (AR_SREV_9287_10_OR_LATER(ah))
+		return MS_REG_READ(AR9287, gpio) != 0;
+	else if (AR_SREV_9285_10_OR_LATER(ah))
 		return MS_REG_READ(AR9285, gpio) != 0;
 	else if (AR_SREV_9280_10_OR_LATER(ah))
 		return MS_REG_READ(AR928X, gpio) != 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 28bffdb..37f7d3d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -42,6 +42,9 @@
 #define AR_SUBVENDOR_ID_NEW_A	0x7065
 #define AR5416_MAGIC		0x19641014
 
+#define AR5416_DEVID_AR9287_PCI  0x002D
+#define AR5416_DEVID_AR9287_PCIE 0x002E
+
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) ath9k_iowrite32((_ah), (_reg), (_val))
 #define REG_READ(_ah, _reg) ath9k_ioread32((_ah), (_reg))
@@ -400,6 +403,7 @@ struct ath_hw {
 	union {
 		struct ar5416_eeprom_def def;
 		struct ar5416_eeprom_4k map4k;
+		struct ar9287_eeprom_t map9287;
 	} eeprom;
 	const struct eeprom_ops *eep_ops;
 	enum ath9k_eep_map eep_map;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3436295..e3722d3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2761,7 +2761,8 @@ static struct {
 	{ AR_SREV_VERSION_9100,		"9100" },
 	{ AR_SREV_VERSION_9160,		"9160" },
 	{ AR_SREV_VERSION_9280,		"9280" },
-	{ AR_SREV_VERSION_9285,		"9285" }
+	{ AR_SREV_VERSION_9285,		"9285" },
+	{ AR_SREV_VERSION_9287,         "9287" }
 };
 
 static struct {
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 170c5b3..cd4841b 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -25,6 +25,8 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x002B) }, /* PCI-E */
+	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
+	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
 	{ 0 }
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index c70f530..de4fada 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -375,6 +375,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 #define AR_PHY_CHAN_INFO_GAIN          0x9CFC
 
 #define AR_PHY_MODE         0xA200
+#define AR_PHY_MODE_ASYNCFIFO 0x80
 #define AR_PHY_MODE_AR2133  0x08
 #define AR_PHY_MODE_AR5111  0x00
 #define AR_PHY_MODE_AR5112  0x08
-- 
1.6.0.1

