Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 056/102] ath9k_hw: add the AR9003 ar9003_hw_init_cal callback
Date: Thu,  8 Apr 2010 15:26:52 -0400
Message-Id: <1270754858-26266-57-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |  144 ++++++++++++++++++++++++-
 1 files changed, 143 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 6a72677..aeef038 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -40,9 +40,151 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	return false;
 }
 
+static void ar9003_hw_iqcal_collect(struct ath_hw *ah)
+{
+	int i;
+
+	/* Accumulate IQ cal measures for active chains */
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
+static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 powerMeasQ, powerMeasI, iqCorrMeas;
+	u32 qCoffDenom, iCoffDenom;
+	int32_t qCoff, iCoff;
+	int iqCorrNeg, i;
+	const u_int32_t offset_array[3] = {
+		AR_PHY_RX_IQCAL_CORR_B0,
+		AR_PHY_RX_IQCAL_CORR_B1,
+		AR_PHY_RX_IQCAL_CORR_B2,
+	};
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
+		iCoffDenom = (powerMeasI / 2 + powerMeasQ / 2) / 256;
+		qCoffDenom = powerMeasQ / 64;
+
+		if ((iCoffDenom != 0) && (qCoffDenom != 0)) {
+			iCoff = iqCorrMeas / iCoffDenom;
+			qCoff = powerMeasI / qCoffDenom - 64;
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d iCoff = 0x%08x\n", i, iCoff);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d qCoff = 0x%08x\n", i, qCoff);
+
+			/* Force bounds on iCoff */
+			if (iCoff >= 63)
+				iCoff = 63;
+			else if (iCoff <= -63)
+				iCoff = -63;
+
+			/* Negate iCoff if iqCorrNeg == 0 */
+			if (iqCorrNeg == 0x0)
+				iCoff = -iCoff;
+
+			/* Force bounds on qCoff */
+			if (qCoff >= 63)
+				qCoff = 63;
+			else if (qCoff <= -63)
+				qCoff = -63;
+
+			iCoff = iCoff & 0x7f;
+			qCoff = qCoff & 0x7f;
+
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
+				  i, iCoff, qCoff);
+			ath_print(common, ATH_DBG_CALIBRATE,
+			          "Register offset (0x%04x) "
+				  "before update = 0x%x\n",
+				  offset_array[i],
+				  REG_READ(ah, offset_array[i]));
+
+			REG_RMW_FIELD(ah, offset_array[i],
+				      AR_PHY_RX_IQCAL_CORR_IQCORR_Q_I_COFF,
+				      iCoff);
+			REG_RMW_FIELD(ah, offset_array[i],
+				      AR_PHY_RX_IQCAL_CORR_IQCORR_Q_Q_COFF,
+				      qCoff);
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Register offset (0x%04x) QI COFF "
+				  "(bitfields 0x%08x) after update = 0x%x\n",
+				  offset_array[i],
+				  AR_PHY_RX_IQCAL_CORR_IQCORR_Q_I_COFF,
+				  REG_READ(ah, offset_array[i]));
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Register offset (0x%04x) QQ COFF "
+				  "(bitfields 0x%08x) after update = 0x%x\n",
+				  offset_array[i], AR_PHY_RX_IQCAL_CORR_IQCORR_Q_Q_COFF,
+				  REG_READ(ah, offset_array[i]));
+
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "IQ Cal and Correction done for Chain %d\n",
+				  i);
+		}
+	}
+
+	REG_SET_BIT(ah, AR_PHY_RX_IQCAL_CORR_B0,
+		    AR_PHY_RX_IQCAL_CORR_IQCORR_ENABLE);
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "IQ Cal and Correction (offset 0x%04x) enabled "
+		  "(bit position 0x%08x). New Value 0x%08x\n",
+		  (unsigned) (AR_PHY_RX_IQCAL_CORR_B0),
+		  AR_PHY_RX_IQCAL_CORR_IQCORR_ENABLE,
+		  REG_READ(ah, AR_PHY_RX_IQCAL_CORR_B0));
+}
+
+static const struct ath9k_percal_data iq_cal_single_sample = {
+        IQ_MISMATCH_CAL,
+        MIN_CAL_SAMPLES,
+        PER_MAX_LOG_COUNT,
+	ar9003_hw_iqcal_collect,
+	ar9003_hw_iqcalibrate
+};
+
 static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 {
-	/* TODO */
+	ah->iq_caldata.calData = &iq_cal_single_sample;
+	ah->supp_cals = IQ_MISMATCH_CAL;
 }
 
 static bool ar9003_hw_iscal_supported(struct ath_hw *ah,
-- 
1.6.3.3

