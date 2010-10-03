Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56770 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0JCRH0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 13:07:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 1/4] ath9k_hw: clean up calibration flags
Date: Sun,  3 Oct 2010 19:07:16 +0200
Message-Id: <1286125639-15137-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The calibration actual calibration flags are only used by the per chip family
source files, so it makes more sense to define them in those files instead
of globally. That way the code has to test for less flags.

Also instead of using a separate callback for testing whether a particular
calibration type is supported, simply adjust ah->supp_cals in the calibration
init which is called right after the hardware reset, before any of the
calibrations are run.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |   51 ++++++++++---------------
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   36 ++++-------------
 drivers/net/wireless/ath/ath9k/calib.c        |    2 +-
 drivers/net/wireless/ath/ath9k/calib.h        |    9 +----
 drivers/net/wireless/ath/ath9k/hw-ops.h       |    6 ---
 drivers/net/wireless/ath/ath9k/hw.h           |    4 +-
 6 files changed, 31 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index f2da119..f0525fb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -20,6 +20,13 @@
 
 #define AR9285_CLCAL_REDO_THRESH    1
 
+enum ar9002_cal_types {
+	ADC_GAIN_CAL = BIT(0),
+	ADC_DC_CAL = BIT(1),
+	IQ_MISMATCH_CAL = BIT(2),
+};
+
+
 static void ar9002_hw_setup_calibration(struct ath_hw *ah,
 					struct ath9k_cal_list *currCal)
 {
@@ -45,8 +52,6 @@ static void ar9002_hw_setup_calibration(struct ath_hw *ah,
 		ath_print(common, ATH_DBG_CALIBRATE,
 			  "starting ADC DC Calibration\n");
 		break;
-	case TEMP_COMP_CAL:
-		break; /* Not supported */
 	}
 
 	REG_SET_BIT(ah, AR_PHY_TIMING_CTRL4(0),
@@ -91,25 +96,6 @@ static bool ar9002_hw_per_calibration(struct ath_hw *ah,
 	return iscaldone;
 }
 
-/* Assumes you are talking about the currently configured channel */
-static bool ar9002_hw_iscal_supported(struct ath_hw *ah,
-				      enum ath9k_cal_types calType)
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
 static void ar9002_hw_iqcal_collect(struct ath_hw *ah)
 {
 	int i;
@@ -872,24 +858,28 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	/* Enable IQ, ADC Gain and ADC DC offset CALs */
 	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
-		if (ar9002_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
+		ah->supp_cals = IQ_MISMATCH_CAL;
+
+		if (AR_SREV_9160_10_OR_LATER(ah) &&
+		    !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan))) {
+			ah->supp_cals |= ADC_GAIN_CAL | ADC_DC_CAL;
+
+
 			INIT_CAL(&ah->adcgain_caldata);
 			INSERT_CAL(ah, &ah->adcgain_caldata);
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "enabling ADC Gain Calibration.\n");
-		}
-		if (ar9002_hw_iscal_supported(ah, ADC_DC_CAL)) {
+
 			INIT_CAL(&ah->adcdc_caldata);
 			INSERT_CAL(ah, &ah->adcdc_caldata);
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "enabling ADC DC Calibration.\n");
 		}
-		if (ar9002_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
-			INIT_CAL(&ah->iq_caldata);
-			INSERT_CAL(ah, &ah->iq_caldata);
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "enabling IQ Calibration.\n");
-		}
+
+		INIT_CAL(&ah->iq_caldata);
+		INSERT_CAL(ah, &ah->iq_caldata);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "enabling IQ Calibration.\n");
 
 		ah->cal_list_curr = ah->cal_list;
 
@@ -980,7 +970,6 @@ void ar9002_hw_attach_calib_ops(struct ath_hw *ah)
 	priv_ops->init_cal_settings = ar9002_hw_init_cal_settings;
 	priv_ops->init_cal = ar9002_hw_init_cal;
 	priv_ops->setup_calibration = ar9002_hw_setup_calibration;
-	priv_ops->iscal_supported = ar9002_hw_iscal_supported;
 
 	ops->calibrate = ar9002_hw_calibrate;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index b41f5cd..9e6edff 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -18,6 +18,11 @@
 #include "hw-ops.h"
 #include "ar9003_phy.h"
 
+enum ar9003_cal_types {
+	IQ_MISMATCH_CAL = BIT(0),
+	TEMP_COMP_CAL = BIT(1),
+};
+
 static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 					struct ath9k_cal_list *currCal)
 {
@@ -50,10 +55,6 @@ static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 		ath_print(common, ATH_DBG_CALIBRATE,
 			  "starting Temperature Compensation Calibration\n");
 		break;
-	case ADC_GAIN_CAL:
-	case ADC_DC_CAL:
-		/* Not yet */
-		break;
 	}
 }
 
@@ -313,27 +314,6 @@ static const struct ath9k_percal_data iq_cal_single_sample = {
 static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 {
 	ah->iq_caldata.calData = &iq_cal_single_sample;
-	ah->supp_cals = IQ_MISMATCH_CAL;
-}
-
-static bool ar9003_hw_iscal_supported(struct ath_hw *ah,
-				      enum ath9k_cal_types calType)
-{
-	switch (calType & ah->supp_cals) {
-	case IQ_MISMATCH_CAL:
-		/*
-		 * XXX: Run IQ Mismatch for non-CCK only
-		 * Note that CHANNEL_B is never set though.
-		 */
-		return true;
-	case ADC_GAIN_CAL:
-	case ADC_DC_CAL:
-		return false;
-	case TEMP_COMP_CAL:
-		return true;
-	}
-
-	return false;
 }
 
 /*
@@ -772,15 +752,16 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
+	ah->supp_cals = IQ_MISMATCH_CAL;
 
-	if (ar9003_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
+	if (ah->supp_cals & IQ_MISMATCH_CAL) {
 		INIT_CAL(&ah->iq_caldata);
 		INSERT_CAL(ah, &ah->iq_caldata);
 		ath_print(common, ATH_DBG_CALIBRATE,
 			  "enabling IQ Calibration.\n");
 	}
 
-	if (ar9003_hw_iscal_supported(ah, TEMP_COMP_CAL)) {
+	if (ah->supp_cals & TEMP_COMP_CAL) {
 		INIT_CAL(&ah->tempCompCalData);
 		INSERT_CAL(ah, &ah->tempCompCalData);
 		ath_print(common, ATH_DBG_CALIBRATE,
@@ -807,7 +788,6 @@ void ar9003_hw_attach_calib_ops(struct ath_hw *ah)
 	priv_ops->init_cal_settings = ar9003_hw_init_cal_settings;
 	priv_ops->init_cal = ar9003_hw_init_cal;
 	priv_ops->setup_calibration = ar9003_hw_setup_calibration;
-	priv_ops->iscal_supported = ar9003_hw_iscal_supported;
 
 	ops->calibrate = ar9003_hw_calibrate;
 }
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 6351e76..6c38c72 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -186,7 +186,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 		return true;
 	}
 
-	if (!ath9k_hw_iscal_supported(ah, currCal->calData->calType))
+	if (!(ah->supp_cals & currCal->calData->calType))
 		return true;
 
 	ath_print(common, ATH_DBG_CALIBRATE,
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 1fa56c9..b8973eb 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -58,13 +58,6 @@ struct ar5416IniArray {
 		}							\
 	} while (0)
 
-enum ath9k_cal_types {
-	ADC_GAIN_CAL = 0x2,
-	ADC_DC_CAL = 0x4,
-	IQ_MISMATCH_CAL = 0x8,
-	TEMP_COMP_CAL = 0x10,
-};
-
 enum ath9k_cal_state {
 	CAL_INACTIVE,
 	CAL_WAITING,
@@ -79,7 +72,7 @@ enum ath9k_cal_state {
 #define PER_MAX_LOG_COUNT  10
 
 struct ath9k_percal_data {
-	enum ath9k_cal_types calType;
+	u32 calType;
 	u32 calNumSamples;
 	u32 calCountMax;
 	void (*calCollect) (struct ath_hw *);
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index ffecbad..9c4dd0e 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -276,12 +276,6 @@ static inline void ath9k_hw_setup_calibration(struct ath_hw *ah,
 	ath9k_hw_private_ops(ah)->setup_calibration(ah, currCal);
 }
 
-static inline bool ath9k_hw_iscal_supported(struct ath_hw *ah,
-					    enum ath9k_cal_types calType)
-{
-	return ath9k_hw_private_ops(ah)->iscal_supported(ah, calType);
-}
-
 static inline void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 {
 	ath9k_hw_private_ops(ah)->ani_reset(ah, is_scanning);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 235cb53..246c707 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -535,8 +535,6 @@ struct ath_hw_private_ops {
 	bool (*macversion_supported)(u32 macversion);
 	void (*setup_calibration)(struct ath_hw *ah,
 				  struct ath9k_cal_list *currCal);
-	bool (*iscal_supported)(struct ath_hw *ah,
-				enum ath9k_cal_types calType);
 
 	/* PHY ops */
 	int (*rf_set_freq)(struct ath_hw *ah,
@@ -689,7 +687,7 @@ struct ath_hw {
 	u32 atim_window;
 
 	/* Calibration */
-	enum ath9k_cal_types supp_cals;
+	u32 supp_cals;
 	struct ath9k_cal_list iq_caldata;
 	struct ath9k_cal_list adcgain_caldata;
 	struct ath9k_cal_list adcdc_caldata;
-- 
1.7.2.2

