Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 055/102] ath9k_hw: split calib code by hardware families
Date: Thu,  8 Apr 2010 15:26:51 -0400
Message-Id: <1270754858-26266-56-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calibration code touches phy registers and since these
change the calibration code needs to be abstracted.

Noise floor calibration is the only thing remaining but
since the remaining calls only touch the AR_PHY_AGC_CONTROL
register we'll just define that register conditionally, that
will be done separately. The goal is to remove the dependency
of ar9002_phy.h on calib.c

This also adds stubs to be filled for AR9003 calibration code.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile       |    4 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |  986 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   66 ++
 drivers/net/wireless/ath/ath9k/calib.c        |  928 +-----------------------
 drivers/net/wireless/ath/ath9k/calib.h        |   15 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h       |   28 +-
 drivers/net/wireless/ath/ath9k/hw.c           |   34 +-
 drivers/net/wireless/ath/ath9k/hw.h           |   21 +-
 8 files changed, 1111 insertions(+), 971 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_calib.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_calib.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 96af3d9..d2417ed 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -17,11 +17,13 @@ ath9k_hw-y:=	hw.o \
 		ar9003_phy.o \
 		ar9002_phy.o \
 		ar5008_phy.o \
+		ar9002_calib.o \
+		ar9003_calib.o \
+		calib.o \
 		eeprom.o \
 		eeprom_def.o \
 		eeprom_4k.o \
 		eeprom_9287.o \
-		calib.o \
 		ani.o \
 		btcoex.o \
 		mac.o \
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
new file mode 100644
index 0000000..a4abe9c
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -0,0 +1,986 @@
+/*
+ * Copyright (c) 2008-2010 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "hw.h"
+#include "hw-ops.h"
+#include "ar9002_phy.h"
+
+#define AR9285_CLCAL_REDO_THRESH    1
+
+static void ar9002_hw_setup_calibration(struct ath_hw *ah,
+					struct ath9k_cal_list *currCal)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(0),
+		      AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX,
+		      currCal->calData->calCountMax);
+
+	switch (currCal->calData->calType) {
+	case IQ_MISMATCH_CAL:
+		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting IQ Mismatch Calibration\n");
+		break;
+	case ADC_GAIN_CAL:
+		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_GAIN);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting ADC Gain Calibration\n");
+		break;
+	case ADC_DC_CAL:
+		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_PER);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting ADC DC Calibration\n");
+		break;
+	case ADC_DC_INIT_CAL:
+		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_INIT);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "starting Init ADC DC Calibration\n");
+		break;
+	}
+
+	REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
+		    AR_PHY_TIMING_CTRL4_DO_CAL);
+}
+
+static bool ar9002_hw_per_calibration(struct ath_hw *ah,
+				      struct ath9k_channel *ichan,
+				      u8 rxchainmask,
+				      struct ath9k_cal_list *currCal)
+{
+	bool iscaldone = false;
+
+	if (currCal->calState == CAL_RUNNING) {
+		if (!(REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
+		      AR_PHY_TIMING_CTRL4_DO_CAL)) {
+
+			currCal->calData->calCollect(ah);
+			ah->cal_samples++;
+
+			if (ah->cal_samples >= currCal->calData->calNumSamples) {
+				int i, numChains = 0;
+				for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+					if (rxchainmask & (1 << i))
+						numChains++;
+				}
+
+				currCal->calData->calPostProc(ah, numChains);
+				ichan->CalValid |= currCal->calData->calType;
+				currCal->calState = CAL_DONE;
+				iscaldone = true;
+			} else {
+				ar9002_hw_setup_calibration(ah, currCal);
+			}
+		}
+	} else if (!(ichan->CalValid & currCal->calData->calType)) {
+		ath9k_hw_reset_calibration(ah, currCal);
+	}
+
+	return iscaldone;
+}
+
+/* Assumes you are talking about the currently configured channel */
+static bool ar9002_hw_iscal_supported(struct ath_hw *ah,
+				      enum ath9k_cal_types calType)
+{
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+
+	switch (calType & ah->supp_cals) {
+	case IQ_MISMATCH_CAL: /* Both 2 GHz and 5 GHz support OFDM */
+		return true;
+	case ADC_GAIN_CAL:
+	case ADC_DC_CAL:
+		if (!(conf->channel->band == IEEE80211_BAND_2GHZ &&
+		      conf_is_ht20(conf)))
+			return true;
+		break;
+	}
+	return false;
+}
+
+static void ar9002_hw_iqcal_collect(struct ath_hw *ah)
+{
+	int i;
+
+	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+		ah->totalPowerMeasI[i] +=
+			REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
+		ah->totalPowerMeasQ[i] +=
+			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
+		ah->totalIqCorrMeas[i] +=
+			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
+		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+			  "%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
+			  ah->cal_samples, i, ah->totalPowerMeasI[i],
+			  ah->totalPowerMeasQ[i],
+			  ah->totalIqCorrMeas[i]);
+	}
+}
+
+static void ar9002_hw_adc_gaincal_collect(struct ath_hw *ah)
+{
+	int i;
+
+	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+		ah->totalAdcIOddPhase[i] +=
+			REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
+		ah->totalAdcIEvenPhase[i] +=
+			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
+		ah->totalAdcQOddPhase[i] +=
+			REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
+		ah->totalAdcQEvenPhase[i] +=
+			REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
+
+		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+			  "%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
+			  "oddq=0x%08x; evenq=0x%08x;\n",
+			  ah->cal_samples, i,
+			  ah->totalAdcIOddPhase[i],
+			  ah->totalAdcIEvenPhase[i],
+			  ah->totalAdcQOddPhase[i],
+			  ah->totalAdcQEvenPhase[i]);
+	}
+}
+
+static void ar9002_hw_adc_dccal_collect(struct ath_hw *ah)
+{
+	int i;
+
+	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+		ah->totalAdcDcOffsetIOddPhase[i] +=
+			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
+		ah->totalAdcDcOffsetIEvenPhase[i] +=
+			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
+		ah->totalAdcDcOffsetQOddPhase[i] +=
+			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
+		ah->totalAdcDcOffsetQEvenPhase[i] +=
+			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
+
+		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+			  "%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
+			  "oddq=0x%08x; evenq=0x%08x;\n",
+			  ah->cal_samples, i,
+			  ah->totalAdcDcOffsetIOddPhase[i],
+			  ah->totalAdcDcOffsetIEvenPhase[i],
+			  ah->totalAdcDcOffsetQOddPhase[i],
+			  ah->totalAdcDcOffsetQEvenPhase[i]);
+	}
+}
+
+static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 powerMeasQ, powerMeasI, iqCorrMeas;
+	u32 qCoffDenom, iCoffDenom;
+	int32_t qCoff, iCoff;
+	int iqCorrNeg, i;
+
+	for (i = 0; i < numChains; i++) {
+		powerMeasI = ah->totalPowerMeasI[i];
+		powerMeasQ = ah->totalPowerMeasQ[i];
+		iqCorrMeas = ah->totalIqCorrMeas[i];
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Starting IQ Cal and Correction for Chain %d\n",
+			  i);
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Orignal: Chn %diq_corr_meas = 0x%08x\n",
+			  i, ah->totalIqCorrMeas[i]);
+
+		iqCorrNeg = 0;
+
+		if (iqCorrMeas > 0x80000000) {
+			iqCorrMeas = (0xffffffff - iqCorrMeas) + 1;
+			iqCorrNeg = 1;
+		}
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_i = 0x%08x\n", i, powerMeasI);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_q = 0x%08x\n", i, powerMeasQ);
+		ath_print(common, ATH_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
+			  iqCorrNeg);
+
+		iCoffDenom = (powerMeasI / 2 + powerMeasQ / 2) / 128;
+		qCoffDenom = powerMeasQ / 64;
+
+		if ((powerMeasQ != 0) && (iCoffDenom != 0) &&
+		    (qCoffDenom != 0)) {
+			iCoff = iqCorrMeas / iCoffDenom;
+			qCoff = powerMeasI / qCoffDenom - 64;
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d iCoff = 0x%08x\n", i, iCoff);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d qCoff = 0x%08x\n", i, qCoff);
+
+			iCoff = iCoff & 0x3f;
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "New: Chn %d iCoff = 0x%08x\n", i, iCoff);
+			if (iqCorrNeg == 0x0)
+				iCoff = 0x40 - iCoff;
+
+			if (qCoff > 15)
+				qCoff = 15;
+			else if (qCoff <= -16)
+				qCoff = 16;
+
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
+				  i, iCoff, qCoff);
+
+			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
+				      AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF,
+				      iCoff);
+			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
+				      AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF,
+				      qCoff);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "IQ Cal and Correction done for Chain %d\n",
+				  i);
+		}
+	}
+
+	REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
+		    AR_PHY_TIMING_CTRL4_IQCORR_ENABLE);
+}
+
+static void ar9002_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 iOddMeasOffset, iEvenMeasOffset, qOddMeasOffset, qEvenMeasOffset;
+	u32 qGainMismatch, iGainMismatch, val, i;
+
+	for (i = 0; i < numChains; i++) {
+		iOddMeasOffset = ah->totalAdcIOddPhase[i];
+		iEvenMeasOffset = ah->totalAdcIEvenPhase[i];
+		qOddMeasOffset = ah->totalAdcQOddPhase[i];
+		qEvenMeasOffset = ah->totalAdcQEvenPhase[i];
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Starting ADC Gain Cal for Chain %d\n", i);
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_odd_i = 0x%08x\n", i,
+			  iOddMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_even_i = 0x%08x\n", i,
+			  iEvenMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_odd_q = 0x%08x\n", i,
+			  qOddMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_even_q = 0x%08x\n", i,
+			  qEvenMeasOffset);
+
+		if (iOddMeasOffset != 0 && qEvenMeasOffset != 0) {
+			iGainMismatch =
+				((iEvenMeasOffset * 32) /
+				 iOddMeasOffset) & 0x3f;
+			qGainMismatch =
+				((qOddMeasOffset * 32) /
+				 qEvenMeasOffset) & 0x3f;
+
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d gain_mismatch_i = 0x%08x\n", i,
+				  iGainMismatch);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d gain_mismatch_q = 0x%08x\n", i,
+				  qGainMismatch);
+
+			val = REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i));
+			val &= 0xfffff000;
+			val |= (qGainMismatch) | (iGainMismatch << 6);
+			REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
+
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "ADC Gain Cal done for Chain %d\n", i);
+		}
+	}
+
+	REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(0),
+		  REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(0)) |
+		  AR_PHY_NEW_ADC_GAIN_CORR_ENABLE);
+}
+
+static void ar9002_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 iOddMeasOffset, iEvenMeasOffset, val, i;
+	int32_t qOddMeasOffset, qEvenMeasOffset, qDcMismatch, iDcMismatch;
+	const struct ath9k_percal_data *calData =
+		ah->cal_list_curr->calData;
+	u32 numSamples =
+		(1 << (calData->calCountMax + 5)) * calData->calNumSamples;
+
+	for (i = 0; i < numChains; i++) {
+		iOddMeasOffset = ah->totalAdcDcOffsetIOddPhase[i];
+		iEvenMeasOffset = ah->totalAdcDcOffsetIEvenPhase[i];
+		qOddMeasOffset = ah->totalAdcDcOffsetQOddPhase[i];
+		qEvenMeasOffset = ah->totalAdcDcOffsetQEvenPhase[i];
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			   "Starting ADC DC Offset Cal for Chain %d\n", i);
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_odd_i = %d\n", i,
+			  iOddMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_even_i = %d\n", i,
+			  iEvenMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_odd_q = %d\n", i,
+			  qOddMeasOffset);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d pwr_meas_even_q = %d\n", i,
+			  qEvenMeasOffset);
+
+		iDcMismatch = (((iEvenMeasOffset - iOddMeasOffset) * 2) /
+			       numSamples) & 0x1ff;
+		qDcMismatch = (((qOddMeasOffset - qEvenMeasOffset) * 2) /
+			       numSamples) & 0x1ff;
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d dc_offset_mismatch_i = 0x%08x\n", i,
+			  iDcMismatch);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Chn %d dc_offset_mismatch_q = 0x%08x\n", i,
+			  qDcMismatch);
+
+		val = REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i));
+		val &= 0xc0000fff;
+		val |= (qDcMismatch << 12) | (iDcMismatch << 21);
+		REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "ADC DC Offset Cal done for Chain %d\n", i);
+	}
+
+	REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(0),
+		  REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(0)) |
+		  AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE);
+}
+
+static void ar9287_hw_olc_temp_compensation(struct ath_hw *ah)
+{
+	u32 rddata;
+	int32_t delta, currPDADC, slope;
+
+	rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
+	currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
+
+	if (ah->initPDADC == 0 || currPDADC == 0) {
+		/*
+		 * Zero value indicates that no frames have been transmitted yet,
+		 * can't do temperature compensation until frames are transmitted.
+		 */
+		return;
+	} else {
+		slope = ah->eep_ops->get_eeprom(ah, EEP_TEMPSENSE_SLOPE);
+
+		if (slope == 0) { /* to avoid divide by zero case */
+			delta = 0;
+		} else {
+			delta = ((currPDADC - ah->initPDADC)*4) / slope;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_CH0_TX_PWRCTRL11,
+			      AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
+		REG_RMW_FIELD(ah, AR_PHY_CH1_TX_PWRCTRL11,
+			      AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
+	}
+}
+
+static void ar9280_hw_olc_temp_compensation(struct ath_hw *ah)
+{
+	u32 rddata, i;
+	int delta, currPDADC, regval;
+
+	rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
+	currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
+
+	if (ah->initPDADC == 0 || currPDADC == 0)
+		return;
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
+			REG_RMW_FIELD(ah,
+				      AR_PHY_TX_GAIN_TBL1 + i * 4,
+				      AR_PHY_TX_GAIN, regval);
+		}
+	}
+}
+
+static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
+{
+	u32 regVal;
+	unsigned int i;
+	u32 regList [][2] = {
+		{ 0x786c, 0 },
+		{ 0x7854, 0 },
+		{ 0x7820, 0 },
+		{ 0x7824, 0 },
+		{ 0x7868, 0 },
+		{ 0x783c, 0 },
+		{ 0x7838, 0 } ,
+		{ 0x7828, 0 } ,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(regList); i++)
+		regList[i][1] = REG_READ(ah, regList[i][0]);
+
+	regVal = REG_READ(ah, 0x7834);
+	regVal &= (~(0x1));
+	REG_WRITE(ah, 0x7834, regVal);
+	regVal = REG_READ(ah, 0x9808);
+	regVal |= (0x1 << 27);
+	REG_WRITE(ah, 0x9808, regVal);
+
+	/* 786c,b23,1, pwddac=1 */
+	REG_RMW_FIELD(ah, AR9285_AN_TOP3, AR9285_AN_TOP3_PWDDAC, 1);
+	/* 7854, b5,1, pdrxtxbb=1 */
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDRXTXBB1, 1);
+	/* 7854, b7,1, pdv2i=1 */
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDV2I, 1);
+	/* 7854, b8,1, pddacinterface=1 */
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDDACIF, 1);
+	/* 7824,b12,0, offcal=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G2, AR9285_AN_RF2G2_OFFCAL, 0);
+	/* 7838, b1,0, pwddb=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PWDDB, 0);
+	/* 7820,b11,0, enpacal=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_ENPACAL, 0);
+	/* 7820,b25,1, pdpadrv1=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV1, 0);
+	/* 7820,b24,0, pdpadrv2=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1,AR9285_AN_RF2G1_PDPADRV2,0);
+	/* 7820,b23,0, pdpaout=0 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPAOUT, 0);
+	/* 783c,b14-16,7, padrvgn2tab_0=7 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G8,AR9285_AN_RF2G8_PADRVGN2TAB0, 7);
+	/*
+	 * 7838,b29-31,0, padrvgn1tab_0=0
+	 * does not matter since we turn it off
+	 */
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G7,AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
+
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9271_AN_RF2G3_CCOMP, 0xfff);
+
+	/* Set:
+	 * localmode=1,bmode=1,bmoderxtx=1,synthon=1,
+	 * txon=1,paon=1,oscon=1,synthon_force=1
+	 */
+	REG_WRITE(ah, AR9285_AN_TOP2, 0xca0358a0);
+	udelay(30);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9271_AN_RF2G6_OFFS, 0);
+
+	/* find off_6_1; */
+	for (i = 6; i > 0; i--) {
+		regVal = REG_READ(ah, 0x7834);
+		regVal |= (1 << (20 + i));
+		REG_WRITE(ah, 0x7834, regVal);
+		udelay(1);
+		//regVal = REG_READ(ah, 0x7834);
+		regVal &= (~(0x1 << (20 + i)));
+		regVal |= (MS(REG_READ(ah, 0x7840), AR9285_AN_RXTXBB1_SPARE9)
+			    << (20 + i));
+		REG_WRITE(ah, 0x7834, regVal);
+	}
+
+	regVal = (regVal >>20) & 0x7f;
+
+	/* Update PA cal info */
+	if ((!is_reset) && (ah->pacal_info.prev_offset == regVal)) {
+		if (ah->pacal_info.max_skipcount < MAX_PACAL_SKIPCOUNT)
+			ah->pacal_info.max_skipcount =
+				2 * ah->pacal_info.max_skipcount;
+		ah->pacal_info.skipcount = ah->pacal_info.max_skipcount;
+	} else {
+		ah->pacal_info.max_skipcount = 1;
+		ah->pacal_info.skipcount = 0;
+		ah->pacal_info.prev_offset = regVal;
+	}
+
+	regVal = REG_READ(ah, 0x7834);
+	regVal |= 0x1;
+	REG_WRITE(ah, 0x7834, regVal);
+	regVal = REG_READ(ah, 0x9808);
+	regVal &= (~(0x1 << 27));
+	REG_WRITE(ah, 0x9808, regVal);
+
+	for (i = 0; i < ARRAY_SIZE(regList); i++)
+		REG_WRITE(ah, regList[i][0], regList[i][1]);
+}
+
+static inline void ar9285_hw_pa_cal(struct ath_hw *ah, bool is_reset)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 regVal;
+	int i, offset, offs_6_1, offs_0;
+	u32 ccomp_org, reg_field;
+	u32 regList[][2] = {
+		{ 0x786c, 0 },
+		{ 0x7854, 0 },
+		{ 0x7820, 0 },
+		{ 0x7824, 0 },
+		{ 0x7868, 0 },
+		{ 0x783c, 0 },
+		{ 0x7838, 0 },
+	};
+
+	ath_print(common, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
+
+	/* PA CAL is not needed for high power solution */
+	if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) ==
+	    AR5416_EEP_TXGAIN_HIGH_POWER)
+		return;
+
+	if (AR_SREV_9285_11(ah)) {
+		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
+		udelay(10);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(regList); i++)
+		regList[i][1] = REG_READ(ah, regList[i][0]);
+
+	regVal = REG_READ(ah, 0x7834);
+	regVal &= (~(0x1));
+	REG_WRITE(ah, 0x7834, regVal);
+	regVal = REG_READ(ah, 0x9808);
+	regVal |= (0x1 << 27);
+	REG_WRITE(ah, 0x9808, regVal);
+
+	REG_RMW_FIELD(ah, AR9285_AN_TOP3, AR9285_AN_TOP3_PWDDAC, 1);
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDRXTXBB1, 1);
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDV2I, 1);
+	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDDACIF, 1);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G2, AR9285_AN_RF2G2_OFFCAL, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PWDDB, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_ENPACAL, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV1, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV2, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPAOUT, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G8, AR9285_AN_RF2G8_PADRVGN2TAB0, 7);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
+	ccomp_org = MS(REG_READ(ah, AR9285_AN_RF2G6), AR9285_AN_RF2G6_CCOMP);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_CCOMP, 0xf);
+
+	REG_WRITE(ah, AR9285_AN_TOP2, 0xca0358a0);
+	udelay(30);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_OFFS, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, 0);
+
+	for (i = 6; i > 0; i--) {
+		regVal = REG_READ(ah, 0x7834);
+		regVal |= (1 << (19 + i));
+		REG_WRITE(ah, 0x7834, regVal);
+		udelay(1);
+		regVal = REG_READ(ah, 0x7834);
+		regVal &= (~(0x1 << (19 + i)));
+		reg_field = MS(REG_READ(ah, 0x7840), AR9285_AN_RXTXBB1_SPARE9);
+		regVal |= (reg_field << (19 + i));
+		REG_WRITE(ah, 0x7834, regVal);
+	}
+
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, 1);
+	udelay(1);
+	reg_field = MS(REG_READ(ah, AR9285_AN_RF2G9), AR9285_AN_RXTXBB1_SPARE9);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, reg_field);
+	offs_6_1 = MS(REG_READ(ah, AR9285_AN_RF2G6), AR9285_AN_RF2G6_OFFS);
+	offs_0   = MS(REG_READ(ah, AR9285_AN_RF2G3), AR9285_AN_RF2G3_PDVCCOMP);
+
+	offset = (offs_6_1<<1) | offs_0;
+	offset = offset - 0;
+	offs_6_1 = offset>>1;
+	offs_0 = offset & 1;
+
+	if ((!is_reset) && (ah->pacal_info.prev_offset == offset)) {
+		if (ah->pacal_info.max_skipcount < MAX_PACAL_SKIPCOUNT)
+			ah->pacal_info.max_skipcount =
+				2 * ah->pacal_info.max_skipcount;
+		ah->pacal_info.skipcount = ah->pacal_info.max_skipcount;
+	} else {
+		ah->pacal_info.max_skipcount = 1;
+		ah->pacal_info.skipcount = 0;
+		ah->pacal_info.prev_offset = offset;
+	}
+
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_OFFS, offs_6_1);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, offs_0);
+
+	regVal = REG_READ(ah, 0x7834);
+	regVal |= 0x1;
+	REG_WRITE(ah, 0x7834, regVal);
+	regVal = REG_READ(ah, 0x9808);
+	regVal &= (~(0x1 << 27));
+	REG_WRITE(ah, 0x9808, regVal);
+
+	for (i = 0; i < ARRAY_SIZE(regList); i++)
+		REG_WRITE(ah, regList[i][0], regList[i][1]);
+
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_CCOMP, ccomp_org);
+
+	if (AR_SREV_9285_11(ah))
+		REG_WRITE(ah, AR9285_AN_TOP4, AR9285_AN_TOP4_DEFAULT);
+
+}
+
+static void ar9002_hw_pa_cal(struct ath_hw *ah, bool is_reset)
+{
+	if (AR_SREV_9271(ah)) {
+		if (is_reset || !ah->pacal_info.skipcount)
+			ar9271_hw_pa_cal(ah, is_reset);
+		else
+			ah->pacal_info.skipcount--;
+	} else if (AR_SREV_9285_11_OR_LATER(ah)) {
+		if (is_reset || !ah->pacal_info.skipcount)
+			ar9285_hw_pa_cal(ah, is_reset);
+		else
+			ah->pacal_info.skipcount--;
+	}
+}
+
+static void ar9002_hw_olc_temp_compensation(struct ath_hw *ah)
+{
+	if (OLC_FOR_AR9287_10_LATER)
+		ar9287_hw_olc_temp_compensation(ah);
+	else if (OLC_FOR_AR9280_20_LATER)
+		ar9280_hw_olc_temp_compensation(ah);
+}
+
+static bool ar9002_hw_calibrate(struct ath_hw *ah,
+				struct ath9k_channel *chan,
+				u8 rxchainmask,
+				bool longcal)
+{
+	bool iscaldone = true;
+	struct ath9k_cal_list *currCal = ah->cal_list_curr;
+
+	if (currCal &&
+	    (currCal->calState == CAL_RUNNING ||
+	     currCal->calState == CAL_WAITING)) {
+		iscaldone = ar9002_hw_per_calibration(ah, chan,
+						      rxchainmask, currCal);
+		if (iscaldone) {
+			ah->cal_list_curr = currCal = currCal->calNext;
+
+			if (currCal->calState == CAL_WAITING) {
+				iscaldone = false;
+				ath9k_hw_reset_calibration(ah, currCal);
+			}
+		}
+	}
+
+	/* Do NF cal only at longer intervals */
+	if (longcal) {
+		/* Do periodic PAOffset Cal */
+		ar9002_hw_pa_cal(ah, false);
+		ar9002_hw_olc_temp_compensation(ah);
+
+		/* Get the value from the previous NF cal and update history buffer */
+		ath9k_hw_getnf(ah, chan);
+
+		/*
+		 * Load the NF from history buffer of the current channel.
+		 * NF is slow time-variant, so it is OK to use a historical value.
+		 */
+		ath9k_hw_loadnf(ah, ah->curchan);
+
+		ath9k_hw_start_nfcal(ah);
+	}
+
+	return iscaldone;
+}
+
+/* Carrier leakage Calibration fix */
+static bool ar9285_hw_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+	if (IS_CHAN_HT20(chan)) {
+		REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_PARALLEL_CAL_ENABLE);
+		REG_SET_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
+		REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+			    AR_PHY_AGC_CONTROL_FLTR_CAL);
+		REG_CLR_BIT(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_CAL_ENABLE);
+		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
+		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
+				  AR_PHY_AGC_CONTROL_CAL, 0, AH_WAIT_TIMEOUT)) {
+			ath_print(common, ATH_DBG_CALIBRATE, "offset "
+				  "calibration failed to complete in "
+				  "1ms; noisy ??\n");
+			return false;
+		}
+		REG_CLR_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
+		REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_PARALLEL_CAL_ENABLE);
+		REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+	}
+	REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+	REG_SET_BIT(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_CAL_ENABLE);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
+	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
+			  0, AH_WAIT_TIMEOUT)) {
+		ath_print(common, ATH_DBG_CALIBRATE, "offset calibration "
+			  "failed to complete in 1ms; noisy ??\n");
+		return false;
+	}
+
+	REG_SET_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
+	REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
+
+	return true;
+}
+
+static bool ar9285_hw_clc(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	int i;
+	u_int32_t txgain_max;
+	u_int32_t clc_gain, gain_mask = 0, clc_num = 0;
+	u_int32_t reg_clc_I0, reg_clc_Q0;
+	u_int32_t i0_num = 0;
+	u_int32_t q0_num = 0;
+	u_int32_t total_num = 0;
+	u_int32_t reg_rf2g5_org;
+	bool retv = true;
+
+	if (!(ar9285_hw_cl_cal(ah, chan)))
+		return false;
+
+	txgain_max = MS(REG_READ(ah, AR_PHY_TX_PWRCTRL7),
+			AR_PHY_TX_PWRCTRL_TX_GAIN_TAB_MAX);
+
+	for (i = 0; i < (txgain_max+1); i++) {
+		clc_gain = (REG_READ(ah, (AR_PHY_TX_GAIN_TBL1+(i<<2))) &
+			   AR_PHY_TX_GAIN_CLC) >> AR_PHY_TX_GAIN_CLC_S;
+		if (!(gain_mask & (1 << clc_gain))) {
+			gain_mask |= (1 << clc_gain);
+			clc_num++;
+		}
+	}
+
+	for (i = 0; i < clc_num; i++) {
+		reg_clc_I0 = (REG_READ(ah, (AR_PHY_CLC_TBL1 + (i << 2)))
+			      & AR_PHY_CLC_I0) >> AR_PHY_CLC_I0_S;
+		reg_clc_Q0 = (REG_READ(ah, (AR_PHY_CLC_TBL1 + (i << 2)))
+			      & AR_PHY_CLC_Q0) >> AR_PHY_CLC_Q0_S;
+		if (reg_clc_I0 == 0)
+			i0_num++;
+
+		if (reg_clc_Q0 == 0)
+			q0_num++;
+	}
+	total_num = i0_num + q0_num;
+	if (total_num > AR9285_CLCAL_REDO_THRESH) {
+		reg_rf2g5_org = REG_READ(ah, AR9285_RF2G5);
+		if (AR_SREV_9285E_20(ah)) {
+			REG_WRITE(ah, AR9285_RF2G5,
+				  (reg_rf2g5_org & AR9285_RF2G5_IC50TX) |
+				  AR9285_RF2G5_IC50TX_XE_SET);
+		} else {
+			REG_WRITE(ah, AR9285_RF2G5,
+				  (reg_rf2g5_org & AR9285_RF2G5_IC50TX) |
+				  AR9285_RF2G5_IC50TX_SET);
+		}
+		retv = ar9285_hw_cl_cal(ah, chan);
+		REG_WRITE(ah, AR9285_RF2G5, reg_rf2g5_org);
+	}
+	return retv;
+}
+
+static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (AR_SREV_9271(ah) || AR_SREV_9285_12_OR_LATER(ah)) {
+		if (!ar9285_hw_clc(ah, chan))
+			return false;
+	} else {
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			if (!AR_SREV_9287_10_OR_LATER(ah))
+				REG_CLR_BIT(ah, AR_PHY_ADC_CTL,
+					    AR_PHY_ADC_CTL_OFF_PWDADC);
+			REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
+				    AR_PHY_AGC_CONTROL_FLTR_CAL);
+		}
+
+		/* Calibrate the AGC */
+		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
+			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
+			  AR_PHY_AGC_CONTROL_CAL);
+
+		/* Poll for offset calibration complete */
+		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
+				   0, AH_WAIT_TIMEOUT)) {
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "offset calibration failed to "
+				  "complete in 1ms; noisy environment?\n");
+			return false;
+		}
+
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			if (!AR_SREV_9287_10_OR_LATER(ah))
+				REG_SET_BIT(ah, AR_PHY_ADC_CTL,
+					    AR_PHY_ADC_CTL_OFF_PWDADC);
+			REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+				    AR_PHY_AGC_CONTROL_FLTR_CAL);
+		}
+	}
+
+	/* Do PA Calibration */
+	ar9002_hw_pa_cal(ah, true);
+
+	/* Do NF Calibration after DC offset and other calibrations */
+	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
+		  REG_READ(ah, AR_PHY_AGC_CONTROL) | AR_PHY_AGC_CONTROL_NF);
+
+	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
+
+	/* Enable IQ, ADC Gain and ADC DC offset CALs */
+	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
+		if (ar9002_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
+			INIT_CAL(&ah->adcgain_caldata);
+			INSERT_CAL(ah, &ah->adcgain_caldata);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "enabling ADC Gain Calibration.\n");
+		}
+		if (ar9002_hw_iscal_supported(ah, ADC_DC_CAL)) {
+			INIT_CAL(&ah->adcdc_caldata);
+			INSERT_CAL(ah, &ah->adcdc_caldata);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "enabling ADC DC Calibration.\n");
+		}
+		if (ar9002_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
+			INIT_CAL(&ah->iq_caldata);
+			INSERT_CAL(ah, &ah->iq_caldata);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "enabling IQ Calibration.\n");
+		}
+
+		ah->cal_list_curr = ah->cal_list;
+
+		if (ah->cal_list_curr)
+			ath9k_hw_reset_calibration(ah, ah->cal_list_curr);
+	}
+
+	chan->CalValid = 0;
+
+	return true;
+}
+
+static const struct ath9k_percal_data iq_cal_multi_sample = {
+	IQ_MISMATCH_CAL,
+	MAX_CAL_SAMPLES,
+	PER_MIN_LOG_COUNT,
+	ar9002_hw_iqcal_collect,
+	ar9002_hw_iqcalibrate
+};
+static const struct ath9k_percal_data iq_cal_single_sample = {
+	IQ_MISMATCH_CAL,
+	MIN_CAL_SAMPLES,
+	PER_MAX_LOG_COUNT,
+	ar9002_hw_iqcal_collect,
+	ar9002_hw_iqcalibrate
+};
+static const struct ath9k_percal_data adc_gain_cal_multi_sample = {
+	ADC_GAIN_CAL,
+	MAX_CAL_SAMPLES,
+	PER_MIN_LOG_COUNT,
+	ar9002_hw_adc_gaincal_collect,
+	ar9002_hw_adc_gaincal_calibrate
+};
+static const struct ath9k_percal_data adc_gain_cal_single_sample = {
+	ADC_GAIN_CAL,
+	MIN_CAL_SAMPLES,
+	PER_MAX_LOG_COUNT,
+	ar9002_hw_adc_gaincal_collect,
+	ar9002_hw_adc_gaincal_calibrate
+};
+static const struct ath9k_percal_data adc_dc_cal_multi_sample = {
+	ADC_DC_CAL,
+	MAX_CAL_SAMPLES,
+	PER_MIN_LOG_COUNT,
+	ar9002_hw_adc_dccal_collect,
+	ar9002_hw_adc_dccal_calibrate
+};
+static const struct ath9k_percal_data adc_dc_cal_single_sample = {
+	ADC_DC_CAL,
+	MIN_CAL_SAMPLES,
+	PER_MAX_LOG_COUNT,
+	ar9002_hw_adc_dccal_collect,
+	ar9002_hw_adc_dccal_calibrate
+};
+static const struct ath9k_percal_data adc_init_dc_cal = {
+	ADC_DC_INIT_CAL,
+	MIN_CAL_SAMPLES,
+	INIT_LOG_COUNT,
+	ar9002_hw_adc_dccal_collect,
+	ar9002_hw_adc_dccal_calibrate
+};
+
+static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
+{
+	if (AR_SREV_9100(ah)) {
+		ah->iq_caldata.calData = &iq_cal_multi_sample;
+		ah->supp_cals = IQ_MISMATCH_CAL;
+		return;
+	}
+
+	if (AR_SREV_9160_10_OR_LATER(ah)) {
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			ah->iq_caldata.calData = &iq_cal_single_sample;
+			ah->adcgain_caldata.calData =
+				&adc_gain_cal_single_sample;
+			ah->adcdc_caldata.calData =
+				&adc_dc_cal_single_sample;
+			ah->adcdc_calinitdata.calData =
+				&adc_init_dc_cal;
+		} else {
+			ah->iq_caldata.calData = &iq_cal_multi_sample;
+			ah->adcgain_caldata.calData =
+				&adc_gain_cal_multi_sample;
+			ah->adcdc_caldata.calData =
+				&adc_dc_cal_multi_sample;
+			ah->adcdc_calinitdata.calData =
+				&adc_init_dc_cal;
+		}
+		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
+	}
+}
+
+void ar9002_hw_attach_calib_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+
+	priv_ops->init_cal_settings = ar9002_hw_init_cal_settings;
+	priv_ops->init_cal = ar9002_hw_init_cal;
+	priv_ops->setup_calibration = ar9002_hw_setup_calibration;
+	priv_ops->iscal_supported = ar9002_hw_iscal_supported;
+
+	ops->calibrate = ar9002_hw_calibrate;
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
new file mode 100644
index 0000000..6a72677
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -0,0 +1,66 @@
+/*
+ * Copyright (c) 2010 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "hw.h"
+#include "hw-ops.h"
+#include "ar9003_phy.h"
+
+static void ar9003_hw_setup_calibration(struct ath_hw *ah,
+					struct ath9k_cal_list *currCal)
+{
+	/* TODO */
+}
+
+static bool ar9003_hw_calibrate(struct ath_hw *ah,
+				struct ath9k_channel *chan,
+				u8 rxchainmask,
+				bool longcal)
+{
+	/* TODO */
+	return false;
+}
+
+static bool ar9003_hw_init_cal(struct ath_hw *ah,
+			       struct ath9k_channel *chan)
+{
+	/* TODO */
+	return false;
+}
+
+static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
+{
+	/* TODO */
+}
+
+static bool ar9003_hw_iscal_supported(struct ath_hw *ah,
+				      enum ath9k_cal_types calType)
+{
+	/* TODO */
+	return false;
+}
+
+void ar9003_hw_attach_calib_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+
+	priv_ops->init_cal_settings = ar9003_hw_init_cal_settings;
+	priv_ops->init_cal = ar9003_hw_init_cal;
+	priv_ops->setup_calibration = ar9003_hw_setup_calibration;
+	priv_ops->iscal_supported = ar9003_hw_iscal_supported;
+
+	ops->calibrate = ar9003_hw_calibrate;
+}
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index aa724c2..085e126 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -18,9 +18,10 @@
 #include "hw-ops.h"
 #include "ar9002_phy.h"
 
+/* Common calibration code */
+
 /* We can tune this as we go by monitoring really low values */
 #define ATH9K_NF_TOO_LOW	-60
-#define AR9285_CLCAL_REDO_THRESH    1
 
 /* AR5416 may return very high value (like -31 dBm), in those cases the nf
  * is incorrect and we should use the static NF value. Later we can try to
@@ -108,44 +109,8 @@ static bool ath9k_hw_get_nf_thresh(struct ath_hw *ah,
 	return true;
 }
 
-static void ath9k_hw_setup_calibration(struct ath_hw *ah,
-				       struct ath9k_cal_list *currCal)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(0),
-		      AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX,
-		      currCal->calData->calCountMax);
-
-	switch (currCal->calData->calType) {
-	case IQ_MISMATCH_CAL:
-		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_IQ);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "starting IQ Mismatch Calibration\n");
-		break;
-	case ADC_GAIN_CAL:
-		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_GAIN);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "starting ADC Gain Calibration\n");
-		break;
-	case ADC_DC_CAL:
-		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_PER);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "starting ADC DC Calibration\n");
-		break;
-	case ADC_DC_INIT_CAL:
-		REG_WRITE(ah, AR_PHY_CALMODE, AR_PHY_CALMODE_ADC_DC_INIT);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "starting Init ADC DC Calibration\n");
-		break;
-	}
-
-	REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
-		    AR_PHY_TIMING_CTRL4_DO_CAL);
-}
-
-static void ath9k_hw_reset_calibration(struct ath_hw *ah,
-				       struct ath9k_cal_list *currCal)
+void ath9k_hw_reset_calibration(struct ath_hw *ah,
+				struct ath9k_cal_list *currCal)
 {
 	int i;
 
@@ -163,324 +128,6 @@ static void ath9k_hw_reset_calibration(struct ath_hw *ah,
 	ah->cal_samples = 0;
 }
 
-static bool ath9k_hw_per_calibration(struct ath_hw *ah,
-				     struct ath9k_channel *ichan,
-				     u8 rxchainmask,
-				     struct ath9k_cal_list *currCal)
-{
-	bool iscaldone = false;
-
-	if (currCal->calState == CAL_RUNNING) {
-		if (!(REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
-		      AR_PHY_TIMING_CTRL4_DO_CAL)) {
-
-			currCal->calData->calCollect(ah);
-			ah->cal_samples++;
-
-			if (ah->cal_samples >= currCal->calData->calNumSamples) {
-				int i, numChains = 0;
-				for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-					if (rxchainmask & (1 << i))
-						numChains++;
-				}
-
-				currCal->calData->calPostProc(ah, numChains);
-				ichan->CalValid |= currCal->calData->calType;
-				currCal->calState = CAL_DONE;
-				iscaldone = true;
-			} else {
-				ath9k_hw_setup_calibration(ah, currCal);
-			}
-		}
-	} else if (!(ichan->CalValid & currCal->calData->calType)) {
-		ath9k_hw_reset_calibration(ah, currCal);
-	}
-
-	return iscaldone;
-}
-
-/* Assumes you are talking about the currently configured channel */
-static bool ath9k_hw_iscal_supported(struct ath_hw *ah,
-				     enum ath9k_cal_types calType)
-{
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
-	switch (calType & ah->supp_cals) {
-	case IQ_MISMATCH_CAL: /* Both 2 GHz and 5 GHz support OFDM */
-		return true;
-	case ADC_GAIN_CAL:
-	case ADC_DC_CAL:
-		if (!(conf->channel->band == IEEE80211_BAND_2GHZ &&
-		      conf_is_ht20(conf)))
-			return true;
-		break;
-	}
-	return false;
-}
-
-static void ath9k_hw_iqcal_collect(struct ath_hw *ah)
-{
-	int i;
-
-	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ah->totalPowerMeasI[i] +=
-			REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ah->totalPowerMeasQ[i] +=
-			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ah->totalIqCorrMeas[i] +=
-			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
-			  "%d: Chn %d pmi=0x%08x;pmq=0x%08x;iqcm=0x%08x;\n",
-			  ah->cal_samples, i, ah->totalPowerMeasI[i],
-			  ah->totalPowerMeasQ[i],
-			  ah->totalIqCorrMeas[i]);
-	}
-}
-
-static void ath9k_hw_adc_gaincal_collect(struct ath_hw *ah)
-{
-	int i;
-
-	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ah->totalAdcIOddPhase[i] +=
-			REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ah->totalAdcIEvenPhase[i] +=
-			REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ah->totalAdcQOddPhase[i] +=
-			REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		ah->totalAdcQEvenPhase[i] +=
-			REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
-
-		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
-			  "%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
-			  "oddq=0x%08x; evenq=0x%08x;\n",
-			  ah->cal_samples, i,
-			  ah->totalAdcIOddPhase[i],
-			  ah->totalAdcIEvenPhase[i],
-			  ah->totalAdcQOddPhase[i],
-			  ah->totalAdcQEvenPhase[i]);
-	}
-}
-
-static void ath9k_hw_adc_dccal_collect(struct ath_hw *ah)
-{
-	int i;
-
-	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
-		ah->totalAdcDcOffsetIOddPhase[i] +=
-			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_0(i));
-		ah->totalAdcDcOffsetIEvenPhase[i] +=
-			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_1(i));
-		ah->totalAdcDcOffsetQOddPhase[i] +=
-			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_2(i));
-		ah->totalAdcDcOffsetQEvenPhase[i] +=
-			(int32_t) REG_READ(ah, AR_PHY_CAL_MEAS_3(i));
-
-		ath_print(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
-			  "%d: Chn %d oddi=0x%08x; eveni=0x%08x; "
-			  "oddq=0x%08x; evenq=0x%08x;\n",
-			  ah->cal_samples, i,
-			  ah->totalAdcDcOffsetIOddPhase[i],
-			  ah->totalAdcDcOffsetIEvenPhase[i],
-			  ah->totalAdcDcOffsetQOddPhase[i],
-			  ah->totalAdcDcOffsetQEvenPhase[i]);
-	}
-}
-
-static void ath9k_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 powerMeasQ, powerMeasI, iqCorrMeas;
-	u32 qCoffDenom, iCoffDenom;
-	int32_t qCoff, iCoff;
-	int iqCorrNeg, i;
-
-	for (i = 0; i < numChains; i++) {
-		powerMeasI = ah->totalPowerMeasI[i];
-		powerMeasQ = ah->totalPowerMeasQ[i];
-		iqCorrMeas = ah->totalIqCorrMeas[i];
-
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Starting IQ Cal and Correction for Chain %d\n",
-			  i);
-
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Orignal: Chn %diq_corr_meas = 0x%08x\n",
-			  i, ah->totalIqCorrMeas[i]);
-
-		iqCorrNeg = 0;
-
-		if (iqCorrMeas > 0x80000000) {
-			iqCorrMeas = (0xffffffff - iqCorrMeas) + 1;
-			iqCorrNeg = 1;
-		}
-
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_i = 0x%08x\n", i, powerMeasI);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_q = 0x%08x\n", i, powerMeasQ);
-		ath_print(common, ATH_DBG_CALIBRATE, "iqCorrNeg is 0x%08x\n",
-			  iqCorrNeg);
-
-		iCoffDenom = (powerMeasI / 2 + powerMeasQ / 2) / 128;
-		qCoffDenom = powerMeasQ / 64;
-
-		if ((powerMeasQ != 0) && (iCoffDenom != 0) &&
-		    (qCoffDenom != 0)) {
-			iCoff = iqCorrMeas / iCoffDenom;
-			qCoff = powerMeasI / qCoffDenom - 64;
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "Chn %d iCoff = 0x%08x\n", i, iCoff);
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "Chn %d qCoff = 0x%08x\n", i, qCoff);
-
-			iCoff = iCoff & 0x3f;
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "New: Chn %d iCoff = 0x%08x\n", i, iCoff);
-			if (iqCorrNeg == 0x0)
-				iCoff = 0x40 - iCoff;
-
-			if (qCoff > 15)
-				qCoff = 15;
-			else if (qCoff <= -16)
-				qCoff = 16;
-
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
-				  i, iCoff, qCoff);
-
-			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
-				      AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF,
-				      iCoff);
-			REG_RMW_FIELD(ah, AR_PHY_TIMING_CTRL4(i),
-				      AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF,
-				      qCoff);
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "IQ Cal and Correction done for Chain %d\n",
-				  i);
-		}
-	}
-
-	REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
-		    AR_PHY_TIMING_CTRL4_IQCORR_ENABLE);
-}
-
-static void ath9k_hw_adc_gaincal_calibrate(struct ath_hw *ah, u8 numChains)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 iOddMeasOffset, iEvenMeasOffset, qOddMeasOffset, qEvenMeasOffset;
-	u32 qGainMismatch, iGainMismatch, val, i;
-
-	for (i = 0; i < numChains; i++) {
-		iOddMeasOffset = ah->totalAdcIOddPhase[i];
-		iEvenMeasOffset = ah->totalAdcIEvenPhase[i];
-		qOddMeasOffset = ah->totalAdcQOddPhase[i];
-		qEvenMeasOffset = ah->totalAdcQEvenPhase[i];
-
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Starting ADC Gain Cal for Chain %d\n", i);
-
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_odd_i = 0x%08x\n", i,
-			  iOddMeasOffset);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_even_i = 0x%08x\n", i,
-			  iEvenMeasOffset);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_odd_q = 0x%08x\n", i,
-			  qOddMeasOffset);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_even_q = 0x%08x\n", i,
-			  qEvenMeasOffset);
-
-		if (iOddMeasOffset != 0 && qEvenMeasOffset != 0) {
-			iGainMismatch =
-				((iEvenMeasOffset * 32) /
-				 iOddMeasOffset) & 0x3f;
-			qGainMismatch =
-				((qOddMeasOffset * 32) /
-				 qEvenMeasOffset) & 0x3f;
-
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "Chn %d gain_mismatch_i = 0x%08x\n", i,
-				  iGainMismatch);
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "Chn %d gain_mismatch_q = 0x%08x\n", i,
-				  qGainMismatch);
-
-			val = REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i));
-			val &= 0xfffff000;
-			val |= (qGainMismatch) | (iGainMismatch << 6);
-			REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
-
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "ADC Gain Cal done for Chain %d\n", i);
-		}
-	}
-
-	REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(0),
-		  REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(0)) |
-		  AR_PHY_NEW_ADC_GAIN_CORR_ENABLE);
-}
-
-static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 iOddMeasOffset, iEvenMeasOffset, val, i;
-	int32_t qOddMeasOffset, qEvenMeasOffset, qDcMismatch, iDcMismatch;
-	const struct ath9k_percal_data *calData =
-		ah->cal_list_curr->calData;
-	u32 numSamples =
-		(1 << (calData->calCountMax + 5)) * calData->calNumSamples;
-
-	for (i = 0; i < numChains; i++) {
-		iOddMeasOffset = ah->totalAdcDcOffsetIOddPhase[i];
-		iEvenMeasOffset = ah->totalAdcDcOffsetIEvenPhase[i];
-		qOddMeasOffset = ah->totalAdcDcOffsetQOddPhase[i];
-		qEvenMeasOffset = ah->totalAdcDcOffsetQEvenPhase[i];
-
-		ath_print(common, ATH_DBG_CALIBRATE,
-			   "Starting ADC DC Offset Cal for Chain %d\n", i);
-
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_odd_i = %d\n", i,
-			  iOddMeasOffset);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_even_i = %d\n", i,
-			  iEvenMeasOffset);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_odd_q = %d\n", i,
-			  qOddMeasOffset);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d pwr_meas_even_q = %d\n", i,
-			  qEvenMeasOffset);
-
-		iDcMismatch = (((iEvenMeasOffset - iOddMeasOffset) * 2) /
-			       numSamples) & 0x1ff;
-		qDcMismatch = (((qOddMeasOffset - qEvenMeasOffset) * 2) /
-			       numSamples) & 0x1ff;
-
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d dc_offset_mismatch_i = 0x%08x\n", i,
-			  iDcMismatch);
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "Chn %d dc_offset_mismatch_q = 0x%08x\n", i,
-			  qDcMismatch);
-
-		val = REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i));
-		val &= 0xc0000fff;
-		val |= (qDcMismatch << 12) | (iDcMismatch << 21);
-		REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(i), val);
-
-		ath_print(common, ATH_DBG_CALIBRATE,
-			  "ADC DC Offset Cal done for Chain %d\n", i);
-	}
-
-	REG_WRITE(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(0),
-		  REG_READ(ah, AR_PHY_NEW_ADC_DC_GAIN_CORR(0)) |
-		  AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE);
-}
-
 /* This is done for the currently configured channel */
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 {
@@ -670,570 +317,3 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 	return nf;
 }
 EXPORT_SYMBOL(ath9k_hw_getchan_noise);
-
-static void ar9287_hw_olc_temp_compensation(struct ath_hw *ah)
-{
-	u32 rddata;
-	int32_t delta, currPDADC, slope;
-
-	rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
-	currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
-
-	if (ah->initPDADC == 0 || currPDADC == 0) {
-		/*
-		 * Zero value indicates that no frames have been transmitted yet,
-		 * can't do temperature compensation until frames are transmitted.
-		 */
-		return;
-	} else {
-		slope = ah->eep_ops->get_eeprom(ah, EEP_TEMPSENSE_SLOPE);
-
-		if (slope == 0) { /* to avoid divide by zero case */
-			delta = 0;
-		} else {
-			delta = ((currPDADC - ah->initPDADC)*4) / slope;
-		}
-		REG_RMW_FIELD(ah, AR_PHY_CH0_TX_PWRCTRL11,
-			      AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
-		REG_RMW_FIELD(ah, AR_PHY_CH1_TX_PWRCTRL11,
-			      AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP, delta);
-	}
-}
-
-static void ar9280_hw_olc_temp_compensation(struct ath_hw *ah)
-{
-	u32 rddata, i;
-	int delta, currPDADC, regval;
-
-	rddata = REG_READ(ah, AR_PHY_TX_PWRCTRL4);
-	currPDADC = MS(rddata, AR_PHY_TX_PWRCTRL_PD_AVG_OUT);
-
-	if (ah->initPDADC == 0 || currPDADC == 0)
-		return;
-
-	if (ah->eep_ops->get_eeprom(ah, EEP_DAC_HPWR_5G))
-		delta = (currPDADC - ah->initPDADC + 4) / 8;
-	else
-		delta = (currPDADC - ah->initPDADC + 5) / 10;
-
-	if (delta != ah->PDADCdelta) {
-		ah->PDADCdelta = delta;
-		for (i = 1; i < AR9280_TX_GAIN_TABLE_SIZE; i++) {
-			regval = ah->originalGain[i] - delta;
-			if (regval < 0)
-				regval = 0;
-
-			REG_RMW_FIELD(ah,
-				      AR_PHY_TX_GAIN_TBL1 + i * 4,
-				      AR_PHY_TX_GAIN, regval);
-		}
-	}
-}
-
-static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
-{
-	u32 regVal;
-	unsigned int i;
-	u32 regList [][2] = {
-		{ 0x786c, 0 },
-		{ 0x7854, 0 },
-		{ 0x7820, 0 },
-		{ 0x7824, 0 },
-		{ 0x7868, 0 },
-		{ 0x783c, 0 },
-		{ 0x7838, 0 } ,
-		{ 0x7828, 0 } ,
-	};
-
-	for (i = 0; i < ARRAY_SIZE(regList); i++)
-		regList[i][1] = REG_READ(ah, regList[i][0]);
-
-	regVal = REG_READ(ah, 0x7834);
-	regVal &= (~(0x1));
-	REG_WRITE(ah, 0x7834, regVal);
-	regVal = REG_READ(ah, 0x9808);
-	regVal |= (0x1 << 27);
-	REG_WRITE(ah, 0x9808, regVal);
-
-	/* 786c,b23,1, pwddac=1 */
-	REG_RMW_FIELD(ah, AR9285_AN_TOP3, AR9285_AN_TOP3_PWDDAC, 1);
-	/* 7854, b5,1, pdrxtxbb=1 */
-	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDRXTXBB1, 1);
-	/* 7854, b7,1, pdv2i=1 */
-	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDV2I, 1);
-	/* 7854, b8,1, pddacinterface=1 */
-	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDDACIF, 1);
-	/* 7824,b12,0, offcal=0 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G2, AR9285_AN_RF2G2_OFFCAL, 0);
-	/* 7838, b1,0, pwddb=0 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PWDDB, 0);
-	/* 7820,b11,0, enpacal=0 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_ENPACAL, 0);
-	/* 7820,b25,1, pdpadrv1=0 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV1, 0);
-	/* 7820,b24,0, pdpadrv2=0 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G1,AR9285_AN_RF2G1_PDPADRV2,0);
-	/* 7820,b23,0, pdpaout=0 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPAOUT, 0);
-	/* 783c,b14-16,7, padrvgn2tab_0=7 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G8,AR9285_AN_RF2G8_PADRVGN2TAB0, 7);
-	/*
-	 * 7838,b29-31,0, padrvgn1tab_0=0
-	 * does not matter since we turn it off
-	 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G7,AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
-
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9271_AN_RF2G3_CCOMP, 0xfff);
-
-	/* Set:
-	 * localmode=1,bmode=1,bmoderxtx=1,synthon=1,
-	 * txon=1,paon=1,oscon=1,synthon_force=1
-	 */
-	REG_WRITE(ah, AR9285_AN_TOP2, 0xca0358a0);
-	udelay(30);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9271_AN_RF2G6_OFFS, 0);
-
-	/* find off_6_1; */
-	for (i = 6; i > 0; i--) {
-		regVal = REG_READ(ah, 0x7834);
-		regVal |= (1 << (20 + i));
-		REG_WRITE(ah, 0x7834, regVal);
-		udelay(1);
-		//regVal = REG_READ(ah, 0x7834);
-		regVal &= (~(0x1 << (20 + i)));
-		regVal |= (MS(REG_READ(ah, 0x7840), AR9285_AN_RXTXBB1_SPARE9)
-			    << (20 + i));
-		REG_WRITE(ah, 0x7834, regVal);
-	}
-
-	regVal = (regVal >>20) & 0x7f;
-
-	/* Update PA cal info */
-	if ((!is_reset) && (ah->pacal_info.prev_offset == regVal)) {
-		if (ah->pacal_info.max_skipcount < MAX_PACAL_SKIPCOUNT)
-			ah->pacal_info.max_skipcount =
-				2 * ah->pacal_info.max_skipcount;
-		ah->pacal_info.skipcount = ah->pacal_info.max_skipcount;
-	} else {
-		ah->pacal_info.max_skipcount = 1;
-		ah->pacal_info.skipcount = 0;
-		ah->pacal_info.prev_offset = regVal;
-	}
-
-	regVal = REG_READ(ah, 0x7834);
-	regVal |= 0x1;
-	REG_WRITE(ah, 0x7834, regVal);
-	regVal = REG_READ(ah, 0x9808);
-	regVal &= (~(0x1 << 27));
-	REG_WRITE(ah, 0x9808, regVal);
-
-	for (i = 0; i < ARRAY_SIZE(regList); i++)
-		REG_WRITE(ah, regList[i][0], regList[i][1]);
-}
-
-static inline void ar9285_hw_pa_cal(struct ath_hw *ah, bool is_reset)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 regVal;
-	int i, offset, offs_6_1, offs_0;
-	u32 ccomp_org, reg_field;
-	u32 regList[][2] = {
-		{ 0x786c, 0 },
-		{ 0x7854, 0 },
-		{ 0x7820, 0 },
-		{ 0x7824, 0 },
-		{ 0x7868, 0 },
-		{ 0x783c, 0 },
-		{ 0x7838, 0 },
-	};
-
-	ath_print(common, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
-
-	/* PA CAL is not needed for high power solution */
-	if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) ==
-	    AR5416_EEP_TXGAIN_HIGH_POWER)
-		return;
-
-	if (AR_SREV_9285_11(ah)) {
-		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
-		udelay(10);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(regList); i++)
-		regList[i][1] = REG_READ(ah, regList[i][0]);
-
-	regVal = REG_READ(ah, 0x7834);
-	regVal &= (~(0x1));
-	REG_WRITE(ah, 0x7834, regVal);
-	regVal = REG_READ(ah, 0x9808);
-	regVal |= (0x1 << 27);
-	REG_WRITE(ah, 0x9808, regVal);
-
-	REG_RMW_FIELD(ah, AR9285_AN_TOP3, AR9285_AN_TOP3_PWDDAC, 1);
-	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDRXTXBB1, 1);
-	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDV2I, 1);
-	REG_RMW_FIELD(ah, AR9285_AN_RXTXBB1, AR9285_AN_RXTXBB1_PDDACIF, 1);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G2, AR9285_AN_RF2G2_OFFCAL, 0);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PWDDB, 0);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_ENPACAL, 0);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV1, 0);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV2, 0);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPAOUT, 0);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G8, AR9285_AN_RF2G8_PADRVGN2TAB0, 7);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
-	ccomp_org = MS(REG_READ(ah, AR9285_AN_RF2G6), AR9285_AN_RF2G6_CCOMP);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_CCOMP, 0xf);
-
-	REG_WRITE(ah, AR9285_AN_TOP2, 0xca0358a0);
-	udelay(30);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_OFFS, 0);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, 0);
-
-	for (i = 6; i > 0; i--) {
-		regVal = REG_READ(ah, 0x7834);
-		regVal |= (1 << (19 + i));
-		REG_WRITE(ah, 0x7834, regVal);
-		udelay(1);
-		regVal = REG_READ(ah, 0x7834);
-		regVal &= (~(0x1 << (19 + i)));
-		reg_field = MS(REG_READ(ah, 0x7840), AR9285_AN_RXTXBB1_SPARE9);
-		regVal |= (reg_field << (19 + i));
-		REG_WRITE(ah, 0x7834, regVal);
-	}
-
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, 1);
-	udelay(1);
-	reg_field = MS(REG_READ(ah, AR9285_AN_RF2G9), AR9285_AN_RXTXBB1_SPARE9);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, reg_field);
-	offs_6_1 = MS(REG_READ(ah, AR9285_AN_RF2G6), AR9285_AN_RF2G6_OFFS);
-	offs_0   = MS(REG_READ(ah, AR9285_AN_RF2G3), AR9285_AN_RF2G3_PDVCCOMP);
-
-	offset = (offs_6_1<<1) | offs_0;
-	offset = offset - 0;
-	offs_6_1 = offset>>1;
-	offs_0 = offset & 1;
-
-	if ((!is_reset) && (ah->pacal_info.prev_offset == offset)) {
-		if (ah->pacal_info.max_skipcount < MAX_PACAL_SKIPCOUNT)
-			ah->pacal_info.max_skipcount =
-				2 * ah->pacal_info.max_skipcount;
-		ah->pacal_info.skipcount = ah->pacal_info.max_skipcount;
-	} else {
-		ah->pacal_info.max_skipcount = 1;
-		ah->pacal_info.skipcount = 0;
-		ah->pacal_info.prev_offset = offset;
-	}
-
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_OFFS, offs_6_1);
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, offs_0);
-
-	regVal = REG_READ(ah, 0x7834);
-	regVal |= 0x1;
-	REG_WRITE(ah, 0x7834, regVal);
-	regVal = REG_READ(ah, 0x9808);
-	regVal &= (~(0x1 << 27));
-	REG_WRITE(ah, 0x9808, regVal);
-
-	for (i = 0; i < ARRAY_SIZE(regList); i++)
-		REG_WRITE(ah, regList[i][0], regList[i][1]);
-
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_CCOMP, ccomp_org);
-
-	if (AR_SREV_9285_11(ah))
-		REG_WRITE(ah, AR9285_AN_TOP4, AR9285_AN_TOP4_DEFAULT);
-
-}
-
-static void ar9002_hw_pa_cal(struct ath_hw *ah, bool is_reset)
-{
-	if (AR_SREV_9271(ah)) {
-		if (is_reset || !ah->pacal_info.skipcount)
-			ar9271_hw_pa_cal(ah, is_reset);
-		else
-			ah->pacal_info.skipcount--;
-	} else if (AR_SREV_9285_11_OR_LATER(ah)) {
-		if (is_reset || !ah->pacal_info.skipcount)
-			ar9285_hw_pa_cal(ah, is_reset);
-		else
-			ah->pacal_info.skipcount--;
-	}
-}
-
-static void ar9002_hw_olc_temp_compensation(struct ath_hw *ah)
-{
-	if (OLC_FOR_AR9287_10_LATER)
-		ar9287_hw_olc_temp_compensation(ah);
-	else if (OLC_FOR_AR9280_20_LATER)
-		ar9280_hw_olc_temp_compensation(ah);
-}
-
-bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
-			u8 rxchainmask, bool longcal)
-{
-	bool iscaldone = true;
-	struct ath9k_cal_list *currCal = ah->cal_list_curr;
-
-	if (currCal &&
-	    (currCal->calState == CAL_RUNNING ||
-	     currCal->calState == CAL_WAITING)) {
-		iscaldone = ath9k_hw_per_calibration(ah, chan,
-						     rxchainmask, currCal);
-		if (iscaldone) {
-			ah->cal_list_curr = currCal = currCal->calNext;
-
-			if (currCal->calState == CAL_WAITING) {
-				iscaldone = false;
-				ath9k_hw_reset_calibration(ah, currCal);
-			}
-		}
-	}
-
-	/* Do NF cal only at longer intervals */
-	if (longcal) {
-		/* Do periodic PAOffset Cal */
-		ar9002_hw_pa_cal(ah, false);
-		ar9002_hw_olc_temp_compensation(ah);
-
-		/* Get the value from the previous NF cal and update history buffer */
-		ath9k_hw_getnf(ah, chan);
-
-		/*
-		 * Load the NF from history buffer of the current channel.
-		 * NF is slow time-variant, so it is OK to use a historical value.
-		 */
-		ath9k_hw_loadnf(ah, ah->curchan);
-
-		ath9k_hw_start_nfcal(ah);
-	}
-
-	return iscaldone;
-}
-EXPORT_SYMBOL(ath9k_hw_calibrate);
-
-/* Carrier leakage Calibration fix */
-static bool ar9285_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
-	if (IS_CHAN_HT20(chan)) {
-		REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_PARALLEL_CAL_ENABLE);
-		REG_SET_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
-		REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
-			    AR_PHY_AGC_CONTROL_FLTR_CAL);
-		REG_CLR_BIT(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_CAL_ENABLE);
-		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
-		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
-				  AR_PHY_AGC_CONTROL_CAL, 0, AH_WAIT_TIMEOUT)) {
-			ath_print(common, ATH_DBG_CALIBRATE, "offset "
-				  "calibration failed to complete in "
-				  "1ms; noisy ??\n");
-			return false;
-		}
-		REG_CLR_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
-		REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_PARALLEL_CAL_ENABLE);
-		REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
-	}
-	REG_CLR_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
-	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
-	REG_SET_BIT(ah, AR_PHY_TPCRG1, AR_PHY_TPCRG1_PD_CAL_ENABLE);
-	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL);
-	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
-			  0, AH_WAIT_TIMEOUT)) {
-		ath_print(common, ATH_DBG_CALIBRATE, "offset calibration "
-			  "failed to complete in 1ms; noisy ??\n");
-		return false;
-	}
-
-	REG_SET_BIT(ah, AR_PHY_ADC_CTL, AR_PHY_ADC_CTL_OFF_PWDADC);
-	REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
-	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_FLTR_CAL);
-
-	return true;
-}
-
-static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	int i;
-	u_int32_t txgain_max;
-	u_int32_t clc_gain, gain_mask = 0, clc_num = 0;
-	u_int32_t reg_clc_I0, reg_clc_Q0;
-	u_int32_t i0_num = 0;
-	u_int32_t q0_num = 0;
-	u_int32_t total_num = 0;
-	u_int32_t reg_rf2g5_org;
-	bool retv = true;
-
-	if (!(ar9285_cl_cal(ah, chan)))
-		return false;
-
-	txgain_max = MS(REG_READ(ah, AR_PHY_TX_PWRCTRL7),
-			AR_PHY_TX_PWRCTRL_TX_GAIN_TAB_MAX);
-
-	for (i = 0; i < (txgain_max+1); i++) {
-		clc_gain = (REG_READ(ah, (AR_PHY_TX_GAIN_TBL1+(i<<2))) &
-			   AR_PHY_TX_GAIN_CLC) >> AR_PHY_TX_GAIN_CLC_S;
-		if (!(gain_mask & (1 << clc_gain))) {
-			gain_mask |= (1 << clc_gain);
-			clc_num++;
-		}
-	}
-
-	for (i = 0; i < clc_num; i++) {
-		reg_clc_I0 = (REG_READ(ah, (AR_PHY_CLC_TBL1 + (i << 2)))
-			      & AR_PHY_CLC_I0) >> AR_PHY_CLC_I0_S;
-		reg_clc_Q0 = (REG_READ(ah, (AR_PHY_CLC_TBL1 + (i << 2)))
-			      & AR_PHY_CLC_Q0) >> AR_PHY_CLC_Q0_S;
-		if (reg_clc_I0 == 0)
-			i0_num++;
-
-		if (reg_clc_Q0 == 0)
-			q0_num++;
-	}
-	total_num = i0_num + q0_num;
-	if (total_num > AR9285_CLCAL_REDO_THRESH) {
-		reg_rf2g5_org = REG_READ(ah, AR9285_RF2G5);
-		if (AR_SREV_9285E_20(ah)) {
-			REG_WRITE(ah, AR9285_RF2G5,
-				  (reg_rf2g5_org & AR9285_RF2G5_IC50TX) |
-				  AR9285_RF2G5_IC50TX_XE_SET);
-		} else {
-			REG_WRITE(ah, AR9285_RF2G5,
-				  (reg_rf2g5_org & AR9285_RF2G5_IC50TX) |
-				  AR9285_RF2G5_IC50TX_SET);
-		}
-		retv = ar9285_cl_cal(ah, chan);
-		REG_WRITE(ah, AR9285_RF2G5, reg_rf2g5_org);
-	}
-	return retv;
-}
-
-bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (AR_SREV_9271(ah) || AR_SREV_9285_12_OR_LATER(ah)) {
-		if (!ar9285_clc(ah, chan))
-			return false;
-	} else {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			if (!AR_SREV_9287_10_OR_LATER(ah))
-				REG_CLR_BIT(ah, AR_PHY_ADC_CTL,
-					    AR_PHY_ADC_CTL_OFF_PWDADC);
-			REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
-				    AR_PHY_AGC_CONTROL_FLTR_CAL);
-		}
-
-		/* Calibrate the AGC */
-		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
-			  AR_PHY_AGC_CONTROL_CAL);
-
-		/* Poll for offset calibration complete */
-		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
-				   0, AH_WAIT_TIMEOUT)) {
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "offset calibration failed to "
-				  "complete in 1ms; noisy environment?\n");
-			return false;
-		}
-
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			if (!AR_SREV_9287_10_OR_LATER(ah))
-				REG_SET_BIT(ah, AR_PHY_ADC_CTL,
-					    AR_PHY_ADC_CTL_OFF_PWDADC);
-			REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
-				    AR_PHY_AGC_CONTROL_FLTR_CAL);
-		}
-	}
-
-	/* Do PA Calibration */
-	ar9002_hw_pa_cal(ah, true);
-
-	/* Do NF Calibration after DC offset and other calibrations */
-	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-		  REG_READ(ah, AR_PHY_AGC_CONTROL) | AR_PHY_AGC_CONTROL_NF);
-
-	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
-
-	/* Enable IQ, ADC Gain and ADC DC offset CALs */
-	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
-		if (ath9k_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
-			INIT_CAL(&ah->adcgain_caldata);
-			INSERT_CAL(ah, &ah->adcgain_caldata);
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "enabling ADC Gain Calibration.\n");
-		}
-		if (ath9k_hw_iscal_supported(ah, ADC_DC_CAL)) {
-			INIT_CAL(&ah->adcdc_caldata);
-			INSERT_CAL(ah, &ah->adcdc_caldata);
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "enabling ADC DC Calibration.\n");
-		}
-		if (ath9k_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
-			INIT_CAL(&ah->iq_caldata);
-			INSERT_CAL(ah, &ah->iq_caldata);
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "enabling IQ Calibration.\n");
-		}
-
-		ah->cal_list_curr = ah->cal_list;
-
-		if (ah->cal_list_curr)
-			ath9k_hw_reset_calibration(ah, ah->cal_list_curr);
-	}
-
-	chan->CalValid = 0;
-
-	return true;
-}
-
-const struct ath9k_percal_data iq_cal_multi_sample = {
-	IQ_MISMATCH_CAL,
-	MAX_CAL_SAMPLES,
-	PER_MIN_LOG_COUNT,
-	ath9k_hw_iqcal_collect,
-	ath9k_hw_iqcalibrate
-};
-const struct ath9k_percal_data iq_cal_single_sample = {
-	IQ_MISMATCH_CAL,
-	MIN_CAL_SAMPLES,
-	PER_MAX_LOG_COUNT,
-	ath9k_hw_iqcal_collect,
-	ath9k_hw_iqcalibrate
-};
-const struct ath9k_percal_data adc_gain_cal_multi_sample = {
-	ADC_GAIN_CAL,
-	MAX_CAL_SAMPLES,
-	PER_MIN_LOG_COUNT,
-	ath9k_hw_adc_gaincal_collect,
-	ath9k_hw_adc_gaincal_calibrate
-};
-const struct ath9k_percal_data adc_gain_cal_single_sample = {
-	ADC_GAIN_CAL,
-	MIN_CAL_SAMPLES,
-	PER_MAX_LOG_COUNT,
-	ath9k_hw_adc_gaincal_collect,
-	ath9k_hw_adc_gaincal_calibrate
-};
-const struct ath9k_percal_data adc_dc_cal_multi_sample = {
-	ADC_DC_CAL,
-	MAX_CAL_SAMPLES,
-	PER_MIN_LOG_COUNT,
-	ath9k_hw_adc_dccal_collect,
-	ath9k_hw_adc_dccal_calibrate
-};
-const struct ath9k_percal_data adc_dc_cal_single_sample = {
-	ADC_DC_CAL,
-	MIN_CAL_SAMPLES,
-	PER_MAX_LOG_COUNT,
-	ath9k_hw_adc_dccal_collect,
-	ath9k_hw_adc_dccal_calibrate
-};
-const struct ath9k_percal_data adc_init_dc_cal = {
-	ADC_DC_INIT_CAL,
-	MIN_CAL_SAMPLES,
-	INIT_LOG_COUNT,
-	ath9k_hw_adc_dccal_collect,
-	ath9k_hw_adc_dccal_calibrate
-};
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index b2c873e..9f6c21d 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -19,14 +19,6 @@
 
 #include "hw.h"
 
-extern const struct ath9k_percal_data iq_cal_multi_sample;
-extern const struct ath9k_percal_data iq_cal_single_sample;
-extern const struct ath9k_percal_data adc_gain_cal_multi_sample;
-extern const struct ath9k_percal_data adc_gain_cal_single_sample;
-extern const struct ath9k_percal_data adc_dc_cal_multi_sample;
-extern const struct ath9k_percal_data adc_dc_cal_single_sample;
-extern const struct ath9k_percal_data adc_init_dc_cal;
-
 #define AR_PHY_CCA_MAX_AR5416_GOOD_VALUE	-85
 #define AR_PHY_CCA_MAX_AR9280_GOOD_VALUE	-112
 #define AR_PHY_CCA_MAX_AR9285_GOOD_VALUE	-118
@@ -127,9 +119,8 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		       struct ath9k_channel *chan);
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah);
 s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
-bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
-			u8 rxchainmask, bool longcal);
-bool ath9k_hw_init_cal(struct ath_hw *ah,
-		       struct ath9k_channel *chan);
+void ath9k_hw_reset_calibration(struct ath_hw *ah,
+				struct ath9k_cal_list *currCal);
+
 
 #endif /* CALIB_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 83b8261..bd40c0e 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -44,6 +44,14 @@ static inline void ath9k_hw_get_desc_link(struct ath_hw *ah, void *ds,
 {
 	ath9k_hw_ops(ah)->get_desc_link(ds, link);
 }
+static inline bool ath9k_hw_calibrate(struct ath_hw *ah,
+				      struct ath9k_channel *chan,
+				      u8 rxchainmask,
+				      bool longcal)
+{
+	return ath9k_hw_ops(ah)->calibrate(ah, chan, rxchainmask, longcal);
+}
+
 /* Private hardware call ops */
 
 /* PHY ops */
@@ -165,7 +173,25 @@ static inline bool ath9k_hw_ani_control(struct ath_hw *ah,
 static inline void ath9k_hw_do_getnf(struct ath_hw *ah,
 				     int16_t nfarray[NUM_NF_READINGS])
 {
-	return ath9k_hw_private_ops(ah)->do_getnf(ah, nfarray);
+	ath9k_hw_private_ops(ah)->do_getnf(ah, nfarray);
+}
+
+static inline bool ath9k_hw_init_cal(struct ath_hw *ah,
+				     struct ath9k_channel *chan)
+{
+	return ath9k_hw_private_ops(ah)->init_cal(ah, chan);
+}
+
+static inline void ath9k_hw_setup_calibration(struct ath_hw *ah,
+					      struct ath9k_cal_list *currCal)
+{
+	ath9k_hw_private_ops(ah)->setup_calibration(ah, currCal);
+}
+
+static inline bool ath9k_hw_iscal_supported(struct ath_hw *ah,
+					    enum ath9k_cal_types calType)
+{
+	return ath9k_hw_private_ops(ah)->iscal_supported(ah, calType);
 }
 
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ac13745..f0a0467 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -594,36 +594,6 @@ static bool ar9003_hw_macversion_supported(u32 macversion)
 	return false;
 }
 
-static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
-{
-	if (AR_SREV_9100(ah)) {
-		ah->iq_caldata.calData = &iq_cal_multi_sample;
-		ah->supp_cals = IQ_MISMATCH_CAL;
-		return;
-	}
-
-	if (AR_SREV_9160_10_OR_LATER(ah)) {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			ah->iq_caldata.calData = &iq_cal_single_sample;
-			ah->adcgain_caldata.calData =
-				&adc_gain_cal_single_sample;
-			ah->adcdc_caldata.calData =
-				&adc_dc_cal_single_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
-		} else {
-			ah->iq_caldata.calData = &iq_cal_multi_sample;
-			ah->adcgain_caldata.calData =
-				&adc_gain_cal_multi_sample;
-			ah->adcdc_caldata.calData =
-				&adc_dc_cal_multi_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
-		}
-		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
-	}
-}
-
 static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 {
 	if (AR_SREV_9271(ah)) {
@@ -3678,7 +3648,6 @@ static void ar9002_hw_attach_ops(struct ath_hw *ah)
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
-	priv_ops->init_cal_settings = ar9002_hw_init_cal_settings;
 	priv_ops->init_mode_regs = ar9002_hw_init_mode_regs;
 	priv_ops->macversion_supported = ar9002_hw_macversion_supported;
 
@@ -3688,6 +3657,7 @@ static void ar9002_hw_attach_ops(struct ath_hw *ah)
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		ar9002_hw_attach_phy_ops(ah);
 
+	ar9002_hw_attach_calib_ops(ah);
 	ar9002_hw_attach_mac_ops(ah);
 }
 
@@ -3700,6 +3670,6 @@ static void ar9003_hw_attach_ops(struct ath_hw *ah)
 	priv_ops->macversion_supported = ar9003_hw_macversion_supported;
 
 	ar9003_hw_attach_phy_ops(ah);
-
+	ar9003_hw_attach_calib_ops(ah);
 	ar9003_hw_attach_mac_ops(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 111b7cb..8101ca4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -464,7 +464,9 @@ struct ath_gen_timer_table {
  * This structure contains private callbacks designed to only be used internally
  * by the hardware core.
  *
- * @init_cal_settings: Initializes calibration settings
+ * @init_cal_settings: setup types of calibrations supported
+ * @init_cal: starts actual calibration
+ *
  * @init_mode_regs: Initializes mode registers
  * @macversion_supported: If this specific mac revision is supported
  *
@@ -475,11 +477,20 @@ struct ath_gen_timer_table {
  * @set_rf_regs:
  * @compute_pll_control: compute the PLL control value to use for
  *	AR_RTC_PLL_CONTROL for a given channel
+ * @setup_calibration: set up calibration
+ * @iscal_supported: used to query if a type of calibration is supported
  */
 struct ath_hw_private_ops {
+	/* Calibration ops */
 	void (*init_cal_settings)(struct ath_hw *ah);
+	bool (*init_cal)(struct ath_hw *ah, struct ath9k_channel *chan);
+
 	void (*init_mode_regs)(struct ath_hw *ah);
 	bool (*macversion_supported)(u32 macversion);
+	void (*setup_calibration)(struct ath_hw *ah,
+				  struct ath9k_cal_list *currCal);
+	bool (*iscal_supported)(struct ath_hw *ah,
+				enum ath9k_cal_types calType);
 
 	/* PHY ops */
 	int (*rf_set_freq)(struct ath_hw *ah,
@@ -518,6 +529,7 @@ struct ath_hw_private_ops {
  * hardware code and also by the lower level driver.
  *
  * @config_pci_powersave:
+ * @calibrate: periodic calibration for NF, ANI, IQ, ADC gain, ADC-DC
  */
 struct ath_hw_ops {
 	void (*config_pci_powersave)(struct ath_hw *ah,
@@ -526,6 +538,10 @@ struct ath_hw_ops {
 	void (*rx_enable)(struct ath_hw *ah);
 	void (*set_desc_link)(void *ds, u32 link);
 	void (*get_desc_link)(void *ds, u32 **link);
+	bool (*calibrate)(struct ath_hw *ah,
+			  struct ath9k_channel *chan,
+			  u8 rxchainmask,
+			  bool longcal);
 };
 
 struct ath_hw {
@@ -827,6 +843,9 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah);
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah);
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah);
 
+void ar9002_hw_attach_calib_ops(struct ath_hw *ah);
+void ar9003_hw_attach_calib_ops(struct ath_hw *ah);
+
 #define ATH_PCIE_CAP_LINK_CTRL	0x70
 #define ATH_PCIE_CAP_LINK_L0S	1
 #define ATH_PCIE_CAP_LINK_L1	2
-- 
1.6.3.3

