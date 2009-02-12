Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15772 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbZBLI1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 03:27:10 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 00:27:10 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath9k: Add open loop control support
Date: Thu, 12 Feb 2009 13:57:03 +0530
Message-ID: <1234427223-7897-1-git-send-email-senthilkumar@atheros.com> (sfid-20090212_092716_848230_D4AE95B5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds Open Loop Control support for Atheros chipsets that
supports open loop power control.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c  |   31 +++++
 drivers/net/wireless/ath9k/eeprom.c |  210 +++++++++++++++++++++++++++++------
 drivers/net/wireless/ath9k/eeprom.h |   13 ++-
 drivers/net/wireless/ath9k/hw.c     |   26 ++++-
 drivers/net/wireless/ath9k/hw.h     |    7 +-
 drivers/net/wireless/ath9k/phy.h    |   25 ++++
 drivers/net/wireless/ath9k/rc.c     |    4 +-
 7 files changed, 277 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index a7ce8c5..e5abe65 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -718,10 +718,39 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 	return nf;
 }
 
+static void ath9k_olc_temp_compensation(struct ath_hw *ah)
+{
+	u32 rddata, i;
+	int delta, currPDADC, regval;
+
+	rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
+
+	currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
+
+	if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
+		delta = (currPDADC - ah->initPDADC + 4) / 8;
+	else
+		delta = (currPDADC - ah->initPDADC + 5) / 10;
+
+	if (delta != ah->PDADCdelta) {
+		ah->PDADCdelta = delta;
+		for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
+			regval = ah->originalGain[i] - delta;
+			if (regval < 0)
+				regval = 0;
+
+			REG_RMW_FIELD(ah, AR_PHY_TX_GAIN_TBL1 + i * 4,
+					AR_PHY_TX_GAIN, regval);
+		}
+	}
+}
+
 bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			u8 rxchainmask, bool longcal,
 			bool *isCalDone)
 {
+#define OLC_FOR_AR9280_20_LATER	(AR_SREV_9280_20_OR_LATER(ah) && \
+				ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 	struct hal_cal_list *currCal = ah->cal_list_curr;
 
 	*isCalDone = true;
@@ -742,6 +771,8 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 
 	if (longcal) {
+		if (OLC_FOR_AR9280_20_LATER)
+			ath9k_olc_temp_compensation(ah);
 		ath9k_hw_getnf(ah, chan);
 		ath9k_hw_loadnf(ah, ah->curchan);
 		ath9k_hw_start_nfcal(ah);
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index b0fdb1e..8379a42 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -179,6 +179,69 @@ static void ath9k_hw_get_legacy_target_powers(struct ath_hw *ah,
 	}
 }
 
+static void ath9k_get_txgain_index(struct ath_hw *ah,
+		struct ath9k_channel *chan,
+		struct calDataPerFreqOpLoop *rawDatasetOpLoop,
+		u8 *calChans,  u16 availPiers, u8 *pwr, u8 *pcdacIdx)
+{
+	u8 pcdac, i = 0;
+	u16 idxL = 0, idxR = 0, numPiers;
+	bool match;
+	struct chan_centers centers;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+
+	for (numPiers = 0; numPiers < availPiers; numPiers++)
+		if (calChans[numPiers] == AR5416_BCHAN_UNUSED)
+			break;
+
+	match = ath9k_hw_get_lower_upper_index(
+			(u8)FREQ2FBIN(centers.synth_center, IS_CHAN_2GHZ(chan)),
+			calChans, numPiers, &idxL, &idxR);
+	if (match) {
+		pcdac = rawDatasetOpLoop[idxL].pcdac[0][0];
+		*pwr = rawDatasetOpLoop[idxL].pwrPdg[0][0];
+	} else {
+		pcdac = rawDatasetOpLoop[idxR].pcdac[0][0];
+		*pwr = (rawDatasetOpLoop[idxL].pwrPdg[0][0] +
+				rawDatasetOpLoop[idxR].pwrPdg[0][0])/2;
+	}
+
+	while (pcdac > ah->originalGain[i] &&
+			i < (AR9280_TX_GAIN_TABLE_SIZE - 1))
+		i++;
+
+	*pcdacIdx = i;
+	return;
+}
+
+static void ath9k_olc_get_pdadcs(struct ath_hw *ah,
+				u32 initTxGain,
+				int txPower,
+				u8 *pPDADCValues)
+{
+	u32 i;
+	u32 offset;
+
+	REG_RMW_FIELD(ah, AR_PHY_TX_PWRCTRL6_0,
+			AR_PHY_TX_PWRCTRL_ERR_EST_MODE, 3);
+	REG_RMW_FIELD(ah, AR_PHY_TX_PWRCTRL6_1,
+			AR_PHY_TX_PWRCTRL_ERR_EST_MODE, 3);
+
+	REG_RMW_FIELD(ah, AR_PHY_TX_PWRCTRL7,
+			AR_PHY_TX_PWRCTRL_INIT_TX_GAIN, initTxGain);
+
+	offset = txPower;
+	for (i = 0; i < AR5416_NUM_PDADC_VALUES; i++)
+		if (i < offset)
+			pPDADCValues[i] = 0x0;
+		else
+			pPDADCValues[i] = 0xFF;
+}
+
+
+
+
 static void ath9k_hw_get_target_powers(struct ath_hw *ah,
 				       struct ath9k_channel *chan,
 				       struct cal_target_power_ht *powInfo,
@@ -1596,6 +1659,16 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 		return pBase->rxGainType;
 	case EEP_TXGAIN_TYPE:
 		return pBase->txGainType;
+	case EEP_OL_PWRCTRL:
+		if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_19)
+			return pBase->openLoopPwrCntl ? true : false;
+		else
+			return false;
+	case EEP_RC_CHAIN_MASK:
+		if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_19)
+			return pBase->rcChainMask;
+		else
+			return 0;
 	case EEP_DAC_HPWR_5G:
 		if (AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_20)
 			return pBase->dacHiPwrMode_5G;
@@ -1839,8 +1912,15 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 				      pModal->swSettleHt40);
 	}
 
+	if (AR_SREV_9280_20_OR_LATER(ah) &&
+			AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_19)
+		REG_RMW_FIELD(ah, AR_PHY_CCK_TX_CTRL,
+				AR_PHY_CCK_TX_CTRL_TX_DAC_SCALE_CCK,
+				pModal->miscBits);
+
+
 	if (AR_SREV_9280_20(ah) && AR5416_VER_MASK >= AR5416_EEP_MINOR_VER_20) {
-		if (IS_CHAN_HT20(chan))
+		if (IS_CHAN_2GHZ(chan))
 			REG_RMW_FIELD(ah, AR_AN_TOP1, AR_AN_TOP1_DACIPMODE,
 					eep->baseEepHeader.dacLpMode);
 		else if (eep->baseEepHeader.dacHiPwrMode_5G)
@@ -1851,6 +1931,10 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 
 		REG_RMW_FIELD(ah, AR_PHY_FRAME_CTL, AR_PHY_FRAME_CTL_TX_CLIP,
 				pModal->miscBits >> 2);
+
+		REG_RMW_FIELD(ah, AR_PHY_TX_PWRCTRL9,
+				AR_PHY_TX_DESIRED_SCALE_CCK,
+				eep->baseEepHeader.desiredScaleCCK);
 	}
 
 	return true;
@@ -2080,6 +2164,12 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
 {
+#define OLC_FOR_AR9280_20_LATER	(AR_SREV_9280_20_OR_LATER(ah) && \
+				ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+#define SM_PD_GAIN(x) SM(0x38, AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_##x)
+#define SM_PDGAIN_B(x, y) \
+		SM((gainBoundaries[x]), AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_##y)
+
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	struct cal_data_per_freq *pRawDataset;
 	u8 *pCalBChans = NULL;
@@ -2113,6 +2203,12 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 		numPiers = AR5416_NUM_5G_CAL_PIERS;
 	}
 
+	if (OLC_FOR_AR9280_20_LATER && IS_CHAN_2GHZ(chan)) {
+		pRawDataset = pEepData->calPierData2G[0];
+		ah->initPDADC = ((struct calDataPerFreqOpLoop *)
+				 pRawDataset)->vpdPdg[0][0];
+	}
+
 	numXpdGain = 0;
 
 	for (i = 1; i <= AR5416_PD_GAINS_IN_MASK; i++) {
@@ -2148,25 +2244,45 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 			else
 				pRawDataset = pEepData->calPierData5G[i];
 
-			ath9k_hw_get_def_gain_boundaries_pdadcs(ah, chan,
-					    pRawDataset, pCalBChans,
-					    numPiers, pdGainOverlap_t2,
-					    &tMinCalPower, gainBoundaries,
-					    pdadcValues, numXpdGain);
+
+			if (OLC_FOR_AR9280_20_LATER) {
+				u8 pcdacIdx;
+				u8 txPower;
+
+				ath9k_get_txgain_index(ah, chan,
+				(struct calDataPerFreqOpLoop *)pRawDataset,
+				pCalBChans, numPiers, &txPower, &pcdacIdx);
+				ath9k_olc_get_pdadcs(ah, pcdacIdx,
+						     txPower/2, pdadcValues);
+			} else {
+				ath9k_hw_get_def_gain_boundaries_pdadcs(ah,
+							chan, pRawDataset,
+							pCalBChans, numPiers,
+							pdGainOverlap_t2,
+							&tMinCalPower,
+							gainBoundaries,
+							pdadcValues,
+							numXpdGain);
+			}
 
 			if ((i == 0) || AR_SREV_5416_V20_OR_LATER(ah)) {
-				REG_WRITE(ah,
-					  AR_PHY_TPCRG5 + regChainOffset,
-					  SM(pdGainOverlap_t2,
-					     AR_PHY_TPCRG5_PD_GAIN_OVERLAP)
-					  | SM(gainBoundaries[0],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1)
-					  | SM(gainBoundaries[1],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2)
-					  | SM(gainBoundaries[2],
-					       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3)
-					  | SM(gainBoundaries[3],
-				       AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4));
+				if (OLC_FOR_AR9280_20_LATER) {
+					REG_WRITE(ah,
+						AR_PHY_TPCRG5 + regChainOffset,
+						SM(0x6,
+						AR_PHY_TPCRG5_PD_GAIN_OVERLAP) |
+						SM_PD_GAIN(1) | SM_PD_GAIN(2) |
+						SM_PD_GAIN(3) | SM_PD_GAIN(4));
+				} else {
+					REG_WRITE(ah,
+						AR_PHY_TPCRG5 + regChainOffset,
+						SM(pdGainOverlap_t2,
+						AR_PHY_TPCRG5_PD_GAIN_OVERLAP)|
+						SM_PDGAIN_B(0, 1) |
+						SM_PDGAIN_B(1, 2) |
+						SM_PDGAIN_B(2, 3) |
+						SM_PDGAIN_B(3, 4));
+				}
 			}
 
 			regOffset = AR_PHY_BASE + (672 << 2) + regChainOffset;
@@ -2200,6 +2316,8 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 	*pTxPowerIndexOffset = 0;
 
 	return true;
+#undef SM_PD_GAIN
+#undef SM_PDGAIN_B
 }
 
 static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
@@ -2500,13 +2618,14 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 				    u8 twiceMaxRegulatoryPower,
 				    u8 powerLimit)
 {
+#define RT_AR_DELTA(x) (ratesArray[x] - cck_ofdm_delta)
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
 		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
 	int16_t ratesArray[Ar5416RateSize];
 	int16_t txPowerIndexOffset = 0;
 	u8 ht40PowerIncForPdadc = 2;
-	int i;
+	int i, cck_ofdm_delta = 0;
 
 	memset(ratesArray, 0, sizeof(ratesArray));
 
@@ -2555,16 +2674,30 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		  | ATH9K_POW_SM(ratesArray[rate24mb], 0));
 
 	if (IS_CHAN_2GHZ(chan)) {
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
+		if (OLC_FOR_AR9280_20_LATER) {
+			cck_ofdm_delta = 2;
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
+				ATH9K_POW_SM(RT_AR_DELTA(rate2s), 24)
+				| ATH9K_POW_SM(RT_AR_DELTA(rate2l), 16)
+				| ATH9K_POW_SM(ratesArray[rateXr], 8)
+				| ATH9K_POW_SM(RT_AR_DELTA(rate1l), 0));
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE4,
+				ATH9K_POW_SM(RT_AR_DELTA(rate11s), 24)
+				| ATH9K_POW_SM(RT_AR_DELTA(rate11l), 16)
+				| ATH9K_POW_SM(RT_AR_DELTA(rate5_5s), 8)
+				| ATH9K_POW_SM(RT_AR_DELTA(rate5_5l), 0));
+		} else {
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE3,
+				ATH9K_POW_SM(ratesArray[rate2s], 24)
+				| ATH9K_POW_SM(ratesArray[rate2l], 16)
+				| ATH9K_POW_SM(ratesArray[rateXr], 8)
+				| ATH9K_POW_SM(ratesArray[rate1l], 0));
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE4,
+				ATH9K_POW_SM(ratesArray[rate11s], 24)
+				| ATH9K_POW_SM(ratesArray[rate11l], 16)
+				| ATH9K_POW_SM(ratesArray[rate5_5s], 8)
+				| ATH9K_POW_SM(ratesArray[rate5_5l], 0));
+		}
 	}
 
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE5,
@@ -2597,12 +2730,19 @@ static int ath9k_hw_def_set_txpower(struct ath_hw *ah,
 					 ht40PowerIncForPdadc, 8)
 			  | ATH9K_POW_SM(ratesArray[rateHt40_4] +
 					 ht40PowerIncForPdadc, 0));
-
-		REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
-			  ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
-			  | ATH9K_POW_SM(ratesArray[rateExtCck], 16)
-			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
-			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
+		if (OLC_FOR_AR9280_20_LATER) {
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
+				ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
+				| ATH9K_POW_SM(RT_AR_DELTA(rateExtCck), 16)
+				| ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
+				| ATH9K_POW_SM(RT_AR_DELTA(rateDupCck), 0));
+		} else {
+			REG_WRITE(ah, AR_PHY_POWER_TX_RATE9,
+				ATH9K_POW_SM(ratesArray[rateExtOfdm], 24)
+				| ATH9K_POW_SM(ratesArray[rateExtCck], 16)
+				| ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
+				| ATH9K_POW_SM(ratesArray[rateDupCck], 0));
+		}
 	}
 
 	REG_WRITE(ah, AR_PHY_POWER_TX_SUB,
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 60cb23d..2cfea5d 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -168,6 +168,8 @@
 #define AR5416_EEP4K_PD_GAIN_ICEPTS           5
 #define AR5416_EEP4K_MAX_CHAINS               1
 
+#define AR9280_TX_GAIN_TABLE_SIZE 22
+
 enum eeprom_param {
 	EEP_NFTHRESH_5,
 	EEP_NFTHRESH_2,
@@ -188,6 +190,8 @@ enum eeprom_param {
 	EEP_RX_MASK,
 	EEP_RXGAIN_TYPE,
 	EEP_TXGAIN_TYPE,
+	EEP_OL_PWRCTRL,
+	EEP_RC_CHAIN_MASK,
 	EEP_DAC_HPWR_5G,
 	EEP_FRAC_N_5G
 };
@@ -229,7 +233,7 @@ struct base_eep_header {
 	u8 futureBase_1[2];
 	u8 rxGainType;
 	u8 dacHiPwrMode_5G;
-	u8 futureBase_2;
+	u8 openLoopPwrCntl;
 	u8 dacLpMode;
 	u8 txGainType;
 	u8 rcChainMask;
@@ -310,6 +314,13 @@ struct modal_eep_header {
 	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
 } __packed;
 
+struct calDataPerFreqOpLoop {
+	u8 pwrPdg[2][5];
+	u8 vpdPdg[2][5];
+	u8 pcdac[2][5];
+	u8 empty[2][5];
+} __packed;
+
 struct modal_eep_4k_header {
 	u32  antCtrlChain[AR5416_EEP4K_MAX_CHAINS];
 	u32  antCtrlCommon;
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 4af1aac..e33c53f 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1202,10 +1202,23 @@ static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 		return ath9k_hw_def_ini_fixup(ah, pEepData, reg, value);
 }
 
+static void ath9k_olc_init(struct ath_hw *ah)
+{
+	u32 i;
+
+	for (i = 0; i < AR9280_TX_GAIN_TABLE_SIZE; i++)
+		ah->originalGain[i] =
+			MS(REG_READ(ah, AR_PHY_TX_GAIN_TBL1 + i * 4),
+					AR_PHY_TX_GAIN);
+	ah->PDADCdelta = 0;
+}
+
 static int ath9k_hw_process_ini(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				enum ath9k_ht_macmode macmode)
 {
+#define OLC_FOR_AR9280_20_LATER	(AR_SREV_9280_20_OR_LATER(ah) && \
+				ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 	int i, regWrites = 0;
 	struct ieee80211_channel *channel = chan->chan;
 	u32 modesIndex, freqIndex;
@@ -1308,6 +1321,9 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	ath9k_hw_set_regs(ah, chan, macmode);
 	ath9k_hw_init_chain_masks(ah);
 
+	if (OLC_FOR_AR9280_20_LATER)
+		ath9k_olc_init(ah);
+
 	status = ah->eep_ops->set_txpower(ah, chan,
 				  ath9k_regd_get_ctl(ah, chan),
 				  channel->max_antenna_gain * 2,
@@ -1515,6 +1531,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
 	REG_WRITE(ah, AR_RTC_RESET, 0);
+	udelay(2);
 	REG_WRITE(ah, AR_RTC_RESET, 1);
 
 	if (!ath9k_hw_wait(ah,
@@ -1582,7 +1599,10 @@ static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 				struct ath9k_channel *chan)
 {
-	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
+	if (OLC_FOR_AR9280_20_LATER) {
+		if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON))
+			return false;
+	} else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
 		return false;
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
@@ -3404,6 +3424,10 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			return 0;
 		}
 		return false;
+	case ATH9K_CAP_DS:
+		return (AR_SREV_9280_20_OR_LATER(ah) &&
+			(ah->eep_ops->get_eeprom(ah, EEP_RC_CHAIN_MASK) == 1))
+			? false : true;
 	default:
 		return false;
 	}
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 587a78d..08469d9 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -162,7 +162,8 @@ enum ath9k_capability_type {
 	ATH9K_CAP_WME_TKIPMIC,
 	ATH9K_CAP_RFSILENT,
 	ATH9K_CAP_ANT_CFG_2GHZ,
-	ATH9K_CAP_ANT_CFG_5GHZ
+	ATH9K_CAP_ANT_CFG_5GHZ,
+	ATH9K_CAP_DS
 };
 
 struct ath9k_hw_capabilities {
@@ -551,6 +552,10 @@ struct ath_hw {
 	u8 txchainmask;
 	u8 rxchainmask;
 
+	u32 originalGain[22];
+	int initPDADC;
+	int PDADCdelta;
+
 	struct ar5416IniArray iniModes;
 	struct ar5416IniArray iniCommon;
 	struct ar5416IniArray iniBank0;
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 4758c37..3dbdd54 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -387,6 +387,8 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 
 #define AR_PHY_CCK_TX_CTRL       0xA204
 #define AR_PHY_CCK_TX_CTRL_JAPAN 0x00000010
+#define AR_PHY_CCK_TX_CTRL_TX_DAC_SCALE_CCK         0x0000000C
+#define AR_PHY_CCK_TX_CTRL_TX_DAC_SCALE_CCK_S       2
 
 #define AR_PHY_CCK_DETECT                           0xA208
 #define AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK          0x0000003F
@@ -444,6 +446,29 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 #define AR_PHY_TPCRG1_PD_GAIN_3    0x00300000
 #define AR_PHY_TPCRG1_PD_GAIN_3_S  20
 
+#define AR_PHY_TX_PWRCTRL4       0xa264
+#define AR_PHY_TX_PWRCTRL_PD_AVG_VALID     0x00000001
+#define AR_PHY_TX_PWRCTRL_PD_AVG_VALID_S   0
+#define AR_PHY_TX_PWRCTRL_PD_AVG_OUT       0x000001FE
+#define AR_PHY_TX_PWRCTRL_PD_AVG_OUT_S     1
+
+#define AR_PHY_TX_PWRCTRL6_0     0xa270
+#define AR_PHY_TX_PWRCTRL6_1     0xb270
+#define AR_PHY_TX_PWRCTRL_ERR_EST_MODE     0x03000000
+#define AR_PHY_TX_PWRCTRL_ERR_EST_MODE_S   24
+
+#define AR_PHY_TX_PWRCTRL7       0xa274
+#define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN     0x01F80000
+#define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN_S   19
+
+#define AR_PHY_TX_PWRCTRL9       0xa27C
+#define AR_PHY_TX_DESIRED_SCALE_CCK        0x00007C00
+#define AR_PHY_TX_DESIRED_SCALE_CCK_S      10
+
+#define AR_PHY_TX_GAIN_TBL1      0xa300
+#define AR_PHY_TX_GAIN                     0x0007F000
+#define AR_PHY_TX_GAIN_S                   12
+
 #define AR_PHY_VIT_MASK2_M_46_61 0xa3a0
 #define AR_PHY_MASK2_M_31_45     0xa3a4
 #define AR_PHY_MASK2_M_16_30     0xa3a8
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index a4e8631..6b4731c 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1392,6 +1392,7 @@ static void ath_rc_init(struct ath_softc *sc,
 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
 	u8 *ht_mcs = (u8 *)&ath_rc_priv->neg_ht_rates;
 	u8 i, j, k, hi = 0, hthi = 0;
+	struct ath_hw *ah = sc->sc_ah;
 
 	/* FIXME: Adhoc */
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) ||
@@ -1412,7 +1413,8 @@ static void ath_rc_init(struct ath_softc *sc,
 
 	if (sta->ht_cap.ht_supported) {
 		ath_rc_priv->ht_cap = WLAN_RC_HT_FLAG;
-		if (sc->sc_ah->caps.tx_chainmask != 1)
+		if (sc->sc_ah->caps.tx_chainmask != 1 &&
+			ath9k_hw_getcapability(ah, ATH9K_CAP_DS, 0, NULL))
 			ath_rc_priv->ht_cap |= WLAN_RC_DS_FLAG;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			ath_rc_priv->ht_cap |= WLAN_RC_40_FLAG;
-- 
1.6.0.4

