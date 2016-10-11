Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46226 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753801AbcJKRq7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 13:46:59 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] Revert "ath9k_hw: implement temperature compensation support for AR9003+"
Date: Tue, 11 Oct 2016 19:46:49 +0200
Message-Id: <20161011174649.19210-1-nbd@nbd.name> (sfid-20161011_195047_010207_4DC2317D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 171f6402e4aa5cd3b8407f82501f7ea21fa54ccc.
Some users report that this commit causes a regression in performance
under some conditions.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 25 +++----------------------
 drivers/net/wireless/ath/ath9k/hw.h           |  1 -
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index b6f064a..7e27a06 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -33,7 +33,6 @@ struct coeff {
 
 enum ar9003_cal_types {
 	IQ_MISMATCH_CAL = BIT(0),
-	TEMP_COMP_CAL = BIT(1),
 };
 
 static void ar9003_hw_setup_calibration(struct ath_hw *ah,
@@ -59,12 +58,6 @@ static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 		/* Kick-off cal */
 		REG_SET_BIT(ah, AR_PHY_TIMING4, AR_PHY_TIMING4_DO_CAL);
 		break;
-	case TEMP_COMP_CAL:
-		ath_dbg(common, CALIBRATE,
-			"starting Temperature Compensation Calibration\n");
-		REG_SET_BIT(ah, AR_CH0_THERM, AR_CH0_THERM_LOCAL);
-		REG_SET_BIT(ah, AR_CH0_THERM, AR_CH0_THERM_START);
-		break;
 	default:
 		ath_err(common, "Invalid calibration type\n");
 		break;
@@ -93,8 +86,7 @@ static bool ar9003_hw_per_calibration(struct ath_hw *ah,
 		/*
 		* Accumulate cal measures for active chains
 		*/
-		if (cur_caldata->calCollect)
-			cur_caldata->calCollect(ah);
+		cur_caldata->calCollect(ah);
 		ah->cal_samples++;
 
 		if (ah->cal_samples >= cur_caldata->calNumSamples) {
@@ -107,8 +99,7 @@ static bool ar9003_hw_per_calibration(struct ath_hw *ah,
 			/*
 			* Process accumulated data
 			*/
-			if (cur_caldata->calPostProc)
-				cur_caldata->calPostProc(ah, numChains);
+			cur_caldata->calPostProc(ah, numChains);
 
 			/* Calibration has finished. */
 			caldata->CalValid |= cur_caldata->calType;
@@ -323,16 +314,9 @@ static const struct ath9k_percal_data iq_cal_single_sample = {
 	ar9003_hw_iqcalibrate
 };
 
-static const struct ath9k_percal_data temp_cal_single_sample = {
-	TEMP_COMP_CAL,
-	MIN_CAL_SAMPLES,
-	PER_MAX_LOG_COUNT,
-};
-
 static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 {
 	ah->iq_caldata.calData = &iq_cal_single_sample;
-	ah->temp_caldata.calData = &temp_cal_single_sample;
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ah->enabled_cals |= TX_IQ_CAL;
@@ -340,7 +324,7 @@ static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
 	}
 
-	ah->supp_cals = IQ_MISMATCH_CAL | TEMP_COMP_CAL;
+	ah->supp_cals = IQ_MISMATCH_CAL;
 }
 
 #define OFF_UPPER_LT 24
@@ -1399,9 +1383,6 @@ static void ar9003_hw_init_cal_common(struct ath_hw *ah)
 	INIT_CAL(&ah->iq_caldata);
 	INSERT_CAL(ah, &ah->iq_caldata);
 
-	INIT_CAL(&ah->temp_caldata);
-	INSERT_CAL(ah, &ah->temp_caldata);
-
 	/* Initialize current pointer to first element in list */
 	ah->cal_list_curr = ah->cal_list;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2a5d3ad..9cbca12 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -830,7 +830,6 @@ struct ath_hw {
 	/* Calibration */
 	u32 supp_cals;
 	struct ath9k_cal_list iq_caldata;
-	struct ath9k_cal_list temp_caldata;
 	struct ath9k_cal_list adcgain_caldata;
 	struct ath9k_cal_list adcdc_caldata;
 	struct ath9k_cal_list *cal_list;
-- 
2.10.1
