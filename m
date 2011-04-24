Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40986 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551Ab1DXQEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 12:04:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 09:04:15 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH v2 1/2] ath9k_hw: Fix Tx IQ Calibration hang issue in AR9003 chips
Date: Sun, 24 Apr 2011 21:34:39 +0530
Message-ID: <1303661079-3376-1-git-send-email-rmanoharan@atheros.com> (sfid-20110424_180445_622904_1B414EB0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AR9003 chips, doing three IQ calibrations will possibly cause chip
in stuck state. In noisy environment, chip could receive
a packet during the middle of three calibrations and it causes
the conflict of HW access and the eventual failure. It also
causes IQ calibration outliers which results in poor Tx EVM.

The IQ Cal procedure is after resetting the chip, run IQ cal 3 times
per each cal cycle and find the two closest readings and average of two.
The advantage of running Tx IQ cal more than once is that we can compare
calibration results for the same gain setting over multiple iterations.
Most of the cases the IQ failures were observed after first pass.

For the AR9485 and later chips, Tx IQ Calibration is performed along
with AGC cal. But for pre-AR9485 chips, Tx IQ cal HW has to be separated
from the rest of calibration HW to avoid chip hang. After all
calibrations are done in HW, we can start SW post-processing.
By doing this way, we minimize the SW difference among all chips.

The order of calibration (run IQ cal before other calibration) is also
needed to avoid chip hang for chips before AR9485. This issue was
originally observed with AR9382.

During the issue kernel log was filled with following message
ath: timeout (100000 us) on reg 0xa640: 0x00000001 & 0x00000001 != 0x00000000
ath: timeout (100000 us) on reg 0xa2c4: 0x00158dd9 & 0x00000001 != 0x00000000
ath: Unable to reset channel (2412 MHz), reset status -5
ath: Unable to set channel

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
v2: updated commit log

 drivers/net/wireless/ath/ath9k/ar9003_calib.c |  350 +++++++++----------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |   23 +-
 drivers/net/wireless/ath/ath9k/reg.h          |    2 +
 3 files changed, 140 insertions(+), 235 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 4a4cd88..2cfa892 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -18,13 +18,13 @@
 #include "hw-ops.h"
 #include "ar9003_phy.h"
 
-#define MPASS	3
 #define MAX_MEASUREMENT	8
-#define MAX_DIFFERENCE	10
+#define MAX_MAG_DELTA	11
+#define MAX_PHS_DELTA	10
 
 struct coeff {
-	int mag_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT][MPASS];
-	int phs_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT][MPASS];
+	int mag_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT];
+	int phs_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT];
 	int iqc_coeff[2];
 };
 
@@ -608,36 +608,48 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	return true;
 }
 
-static bool ar9003_hw_compute_closest_pass_and_avg(int *mp_coeff, int *mp_avg)
+static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
+				     int max_delta)
 {
-	int diff[MPASS];
-
-	diff[0] = abs(mp_coeff[0] - mp_coeff[1]);
-	diff[1] = abs(mp_coeff[1] - mp_coeff[2]);
-	diff[2] = abs(mp_coeff[2] - mp_coeff[0]);
-
-	if (diff[0] > MAX_DIFFERENCE &&
-	    diff[1] > MAX_DIFFERENCE &&
-	    diff[2] > MAX_DIFFERENCE)
-		return false;
+	int mp_max = -64, max_idx = 0;
+	int mp_min = 63, min_idx = 0;
+	int mp_avg = 0, i, outlier_idx = 0;
+
+	/* find min/max mismatch across all calibrated gains */
+	for (i = 0; i < nmeasurement; i++) {
+		mp_avg += mp_coeff[i];
+		if (mp_coeff[i] > mp_max) {
+			mp_max = mp_coeff[i];
+			max_idx = i;
+		} else if (mp_coeff[i] < mp_min) {
+			mp_min = mp_coeff[i];
+			min_idx = i;
+		}
+	}
 
-	if (diff[0] <= diff[1] && diff[0] <= diff[2])
-		*mp_avg = (mp_coeff[0] + mp_coeff[1]) / 2;
-	else if (diff[1] <= diff[2])
-		*mp_avg = (mp_coeff[1] + mp_coeff[2]) / 2;
-	else
-		*mp_avg = (mp_coeff[2] + mp_coeff[0]) / 2;
+	/* find average (exclude max abs value) */
+	for (i = 0; i < nmeasurement; i++) {
+		if ((abs(mp_coeff[i]) < abs(mp_max)) ||
+		    (abs(mp_coeff[i]) < abs(mp_min)))
+			mp_avg += mp_coeff[i];
+	}
+	mp_avg /= (nmeasurement - 1);
 
-	return true;
+	/* detect outlier */
+	if (abs(mp_max - mp_min) > max_delta) {
+		if (abs(mp_max - mp_avg) > abs(mp_min - mp_avg))
+			outlier_idx = max_idx;
+		else
+			outlier_idx = min_idx;
+	}
+	mp_coeff[outlier_idx] = mp_avg;
 }
 
 static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
 						 u8 num_chains,
 						 struct coeff *coeff)
 {
-	struct ath_common *common = ath9k_hw_common(ah);
 	int i, im, nmeasurement;
-	int magnitude, phase;
 	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
 
 	memset(tx_corr_coeff, 0, sizeof(tx_corr_coeff));
@@ -657,37 +669,28 @@ static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
 
 	/* Load the average of 2 passes */
 	for (i = 0; i < num_chains; i++) {
-		if (AR_SREV_9485(ah))
-			nmeasurement = REG_READ_FIELD(ah,
-					AR_PHY_TX_IQCAL_STATUS_B0_9485,
-					AR_PHY_CALIBRATED_GAINS_0);
-		else
-			nmeasurement = REG_READ_FIELD(ah,
-					AR_PHY_TX_IQCAL_STATUS_B0,
-					AR_PHY_CALIBRATED_GAINS_0);
+		nmeasurement = REG_READ_FIELD(ah,
+				AR_PHY_TX_IQCAL_STATUS_B0,
+				AR_PHY_CALIBRATED_GAINS_0);
 
 		if (nmeasurement > MAX_MEASUREMENT)
 			nmeasurement = MAX_MEASUREMENT;
 
-		for (im = 0; im < nmeasurement; im++) {
-			/*
-			 * Determine which 2 passes are closest and compute avg
-			 * magnitude
-			 */
-			if (!ar9003_hw_compute_closest_pass_and_avg(coeff->mag_coeff[i][im],
-								    &magnitude))
-				goto disable_txiqcal;
+		/* detect outlier only if nmeasurement > 1 */
+		if (nmeasurement > 1) {
+			/* Detect magnitude outlier */
+			ar9003_hw_detect_outlier(coeff->mag_coeff[i],
+					nmeasurement, MAX_MAG_DELTA);
 
-			/*
-			 * Determine which 2 passes are closest and compute avg
-			 * phase
-			 */
-			if (!ar9003_hw_compute_closest_pass_and_avg(coeff->phs_coeff[i][im],
-								    &phase))
-				goto disable_txiqcal;
+			/* Detect phase outlier */
+			ar9003_hw_detect_outlier(coeff->phs_coeff[i],
+					nmeasurement, MAX_PHS_DELTA);
+		}
 
-			coeff->iqc_coeff[0] = (magnitude & 0x7f) |
-					      ((phase & 0x7f) << 7);
+		for (im = 0; im < nmeasurement; im++) {
+
+			coeff->iqc_coeff[0] = (coeff->mag_coeff[i][im] & 0x7f) |
+				((coeff->phs_coeff[i][im] & 0x7f) << 7);
 
 			if ((im % 2) == 0)
 				REG_RMW_FIELD(ah, tx_corr_coeff[im][i],
@@ -707,141 +710,37 @@ static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
 
 	return;
 
-disable_txiqcal:
-	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_3,
-		      AR_PHY_TX_IQCAL_CONTROL_3_IQCORR_EN, 0x0);
-	REG_RMW_FIELD(ah, AR_PHY_RX_IQCAL_CORR_B0,
-		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x0);
-
-	ath_dbg(common, ATH_DBG_CALIBRATE, "TX IQ Cal disabled\n");
 }
 
-static void ar9003_hw_tx_iq_cal(struct ath_hw *ah)
+static bool ar9003_hw_tx_iq_cal_run(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	static const u32 txiqcal_status[AR9300_MAX_CHAINS] = {
-		AR_PHY_TX_IQCAL_STATUS_B0,
-		AR_PHY_TX_IQCAL_STATUS_B1,
-		AR_PHY_TX_IQCAL_STATUS_B2,
-	};
-	static const u32 chan_info_tab[] = {
-		AR_PHY_CHAN_INFO_TAB_0,
-		AR_PHY_CHAN_INFO_TAB_1,
-		AR_PHY_CHAN_INFO_TAB_2,
-	};
-	struct coeff coeff;
-	s32 iq_res[6];
-	s32 i, j, ip, im, nmeasurement;
-	u8 nchains = get_streams(common->tx_chainmask);
-
-	for (ip = 0; ip < MPASS; ip++) {
-		REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
-			      AR_PHY_TX_IQCAQL_CONTROL_1_IQCORR_I_Q_COFF_DELPT,
-			      DELPT);
-		REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_START,
-			      AR_PHY_TX_IQCAL_START_DO_CAL,
-			      AR_PHY_TX_IQCAL_START_DO_CAL);
-
-		if (!ath9k_hw_wait(ah, AR_PHY_TX_IQCAL_START,
-				   AR_PHY_TX_IQCAL_START_DO_CAL,
-				   0, AH_WAIT_TIMEOUT)) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Tx IQ Cal not complete.\n");
-			goto TX_IQ_CAL_FAILED;
-		}
-
-		nmeasurement = REG_READ_FIELD(ah, AR_PHY_TX_IQCAL_STATUS_B0,
-					      AR_PHY_CALIBRATED_GAINS_0);
-			if (nmeasurement > MAX_MEASUREMENT)
-				nmeasurement = MAX_MEASUREMENT;
-
-		for (i = 0; i < nchains; i++) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Doing Tx IQ Cal for chain %d.\n", i);
-			for (im = 0; im < nmeasurement; im++) {
-				if (REG_READ(ah, txiqcal_status[i]) &
-					     AR_PHY_TX_IQCAL_STATUS_FAILED) {
-					ath_dbg(common, ATH_DBG_CALIBRATE,
-						"Tx IQ Cal failed for chain %d.\n", i);
-					goto TX_IQ_CAL_FAILED;
-				}
-
-				for (j = 0; j < 3; j++) {
-					u8 idx = 2 * j,
-					   offset = 4 * (3 * im + j);
-
-					REG_RMW_FIELD(ah, AR_PHY_CHAN_INFO_MEMORY,
-						      AR_PHY_CHAN_INFO_TAB_S2_READ,
-						      0);
-
-					/* 32 bits */
-					iq_res[idx] = REG_READ(ah,
-							chan_info_tab[i] +
-							offset);
-
-					REG_RMW_FIELD(ah, AR_PHY_CHAN_INFO_MEMORY,
-						      AR_PHY_CHAN_INFO_TAB_S2_READ,
-						      1);
-
-					/* 16 bits */
-					iq_res[idx+1] = 0xffff & REG_READ(ah,
-								chan_info_tab[i] +
-								offset);
-
-					ath_dbg(common, ATH_DBG_CALIBRATE,
-						"IQ RES[%d]=0x%x IQ_RES[%d]=0x%x\n",
-						idx, iq_res[idx], idx+1, iq_res[idx+1]);
-				}
-
-				if (!ar9003_hw_calc_iq_corr(ah, i, iq_res,
-							    coeff.iqc_coeff)) {
-					ath_dbg(common, ATH_DBG_CALIBRATE,
-						"Failed in calculation of IQ correction.\n");
-					goto TX_IQ_CAL_FAILED;
-				}
-				coeff.mag_coeff[i][im][ip] =
-						coeff.iqc_coeff[0] & 0x7f;
-				coeff.phs_coeff[i][im][ip] =
-						(coeff.iqc_coeff[0] >> 7) & 0x7f;
-
-				if (coeff.mag_coeff[i][im][ip] > 63)
-					coeff.mag_coeff[i][im][ip] -= 128;
-				if (coeff.phs_coeff[i][im][ip] > 63)
-					coeff.phs_coeff[i][im][ip] -= 128;
-
-			}
-		}
-	}
-
-	ar9003_hw_tx_iqcal_load_avg_2_passes(ah, nchains, &coeff);
-
-	return;
-
-TX_IQ_CAL_FAILED:
-	ath_dbg(common, ATH_DBG_CALIBRATE, "Tx IQ Cal failed\n");
-}
-
-static void ar9003_hw_tx_iq_cal_run(struct ath_hw *ah)
-{
 	u8 tx_gain_forced;
 
-	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1_9485,
-		      AR_PHY_TX_IQCAQL_CONTROL_1_IQCORR_I_Q_COFF_DELPT, DELPT);
 	tx_gain_forced = REG_READ_FIELD(ah, AR_PHY_TX_FORCED_GAIN,
 					AR_PHY_TXGAIN_FORCE);
 	if (tx_gain_forced)
 		REG_RMW_FIELD(ah, AR_PHY_TX_FORCED_GAIN,
 			      AR_PHY_TXGAIN_FORCE, 0);
 
-	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_START_9485,
-		      AR_PHY_TX_IQCAL_START_DO_CAL_9485, 1);
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_START,
+		      AR_PHY_TX_IQCAL_START_DO_CAL, 1);
+
+	if (!ath9k_hw_wait(ah, AR_PHY_TX_IQCAL_START,
+			AR_PHY_TX_IQCAL_START_DO_CAL, 0,
+			AH_WAIT_TIMEOUT)) {
+		ath_dbg(common, ATH_DBG_CALIBRATE,
+			"Tx IQ Cal is not completed.\n");
+		return false;
+	}
+	return true;
 }
 
 static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	const u32 txiqcal_status[AR9300_MAX_CHAINS] = {
-		AR_PHY_TX_IQCAL_STATUS_B0_9485,
+		AR_PHY_TX_IQCAL_STATUS_B0,
 		AR_PHY_TX_IQCAL_STATUS_B1,
 		AR_PHY_TX_IQCAL_STATUS_B2,
 	};
@@ -853,7 +752,7 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah)
 	struct coeff coeff;
 	s32 iq_res[6];
 	u8 num_chains = 0;
-	int i, ip, im, j;
+	int i, im, j;
 	int nmeasurement;
 
 	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
@@ -861,71 +760,69 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah)
 			num_chains++;
 	}
 
-	for (ip = 0; ip < MPASS; ip++) {
-		for (i = 0; i < num_chains; i++) {
-			nmeasurement = REG_READ_FIELD(ah,
-					AR_PHY_TX_IQCAL_STATUS_B0_9485,
-					AR_PHY_CALIBRATED_GAINS_0);
-			if (nmeasurement > MAX_MEASUREMENT)
-				nmeasurement = MAX_MEASUREMENT;
+	for (i = 0; i < num_chains; i++) {
+		nmeasurement = REG_READ_FIELD(ah,
+				AR_PHY_TX_IQCAL_STATUS_B0,
+				AR_PHY_CALIBRATED_GAINS_0);
+		if (nmeasurement > MAX_MEASUREMENT)
+			nmeasurement = MAX_MEASUREMENT;
 
-			for (im = 0; im < nmeasurement; im++) {
-				ath_dbg(common, ATH_DBG_CALIBRATE,
-					"Doing Tx IQ Cal for chain %d.\n", i);
+		for (im = 0; im < nmeasurement; im++) {
+			ath_dbg(common, ATH_DBG_CALIBRATE,
+				"Doing Tx IQ Cal for chain %d.\n", i);
 
-				if (REG_READ(ah, txiqcal_status[i]) &
-				    AR_PHY_TX_IQCAL_STATUS_FAILED) {
-					ath_dbg(common, ATH_DBG_CALIBRATE,
+			if (REG_READ(ah, txiqcal_status[i]) &
+					AR_PHY_TX_IQCAL_STATUS_FAILED) {
+				ath_dbg(common, ATH_DBG_CALIBRATE,
 					"Tx IQ Cal failed for chain %d.\n", i);
-					goto tx_iqcal_fail;
-				}
+				goto tx_iqcal_fail;
+			}
 
-				for (j = 0; j < 3; j++) {
-					u32 idx = 2 * j, offset = 4 * (3 * im + j);
+			for (j = 0; j < 3; j++) {
+				u32 idx = 2 * j, offset = 4 * (3 * im + j);
 
-					REG_RMW_FIELD(ah,
+				REG_RMW_FIELD(ah,
 						AR_PHY_CHAN_INFO_MEMORY,
 						AR_PHY_CHAN_INFO_TAB_S2_READ,
 						0);
 
-					/* 32 bits */
-					iq_res[idx] = REG_READ(ah,
-							chan_info_tab[i] +
-							offset);
+				/* 32 bits */
+				iq_res[idx] = REG_READ(ah,
+						chan_info_tab[i] +
+						offset);
 
-					REG_RMW_FIELD(ah,
+				REG_RMW_FIELD(ah,
 						AR_PHY_CHAN_INFO_MEMORY,
 						AR_PHY_CHAN_INFO_TAB_S2_READ,
 						1);
 
-					/* 16 bits */
-					iq_res[idx + 1] = 0xffff & REG_READ(ah,
-							  chan_info_tab[i] + offset);
+				/* 16 bits */
+				iq_res[idx + 1] = 0xffff & REG_READ(ah,
+						chan_info_tab[i] + offset);
 
-					ath_dbg(common, ATH_DBG_CALIBRATE,
-						"IQ RES[%d]=0x%x"
-						"IQ_RES[%d]=0x%x\n",
-						idx, iq_res[idx], idx + 1,
-						iq_res[idx + 1]);
-				}
+				ath_dbg(common, ATH_DBG_CALIBRATE,
+					"IQ RES[%d]=0x%x"
+					"IQ_RES[%d]=0x%x\n",
+					idx, iq_res[idx], idx + 1,
+					iq_res[idx + 1]);
+			}
 
-				if (!ar9003_hw_calc_iq_corr(ah, i, iq_res,
-							    coeff.iqc_coeff)) {
-					ath_dbg(common, ATH_DBG_CALIBRATE,
-					 "Failed in calculation of IQ correction.\n");
-					goto tx_iqcal_fail;
-				}
+			if (!ar9003_hw_calc_iq_corr(ah, i, iq_res,
+						coeff.iqc_coeff)) {
+				ath_dbg(common, ATH_DBG_CALIBRATE,
+					"Failed in calculation of \
+					IQ correction.\n");
+				goto tx_iqcal_fail;
+			}
 
-				coeff.mag_coeff[i][im][ip] =
-						coeff.iqc_coeff[0] & 0x7f;
-				coeff.phs_coeff[i][im][ip] =
-						(coeff.iqc_coeff[0] >> 7) & 0x7f;
+			coeff.mag_coeff[i][im] = coeff.iqc_coeff[0] & 0x7f;
+			coeff.phs_coeff[i][im] =
+				(coeff.iqc_coeff[0] >> 7) & 0x7f;
 
-				if (coeff.mag_coeff[i][im][ip] > 63)
-					coeff.mag_coeff[i][im][ip] -= 128;
-				if (coeff.phs_coeff[i][im][ip] > 63)
-					coeff.phs_coeff[i][im][ip] -= 128;
-			}
+			if (coeff.mag_coeff[i][im] > 63)
+				coeff.mag_coeff[i][im] -= 128;
+			if (coeff.phs_coeff[i][im] > 63)
+				coeff.phs_coeff[i][im] -= 128;
 		}
 	}
 	ar9003_hw_tx_iqcal_load_avg_2_passes(ah, num_chains, &coeff);
@@ -941,6 +838,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	int val;
+	bool txiqcal_done = false;
 
 	val = REG_READ(ah, AR_ENT_OTP);
 	ath_dbg(common, ATH_DBG_CALIBRATE, "ath9k: AR_ENT_OTP 0x%x\n", val);
@@ -957,14 +855,22 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		ar9003_hw_set_chain_masks(ah, 0x7, 0x7);
 
 	/* Do Tx IQ Calibration */
-	if (AR_SREV_9485(ah))
-		ar9003_hw_tx_iq_cal_run(ah);
-	else
-		ar9003_hw_tx_iq_cal(ah);
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
+		      AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT,
+		      DELPT);
 
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
-	udelay(5);
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+	/*
+	 * For AR9485 or later chips, TxIQ cal runs as part of
+	 * AGC calibration
+	 */
+	if (AR_SREV_9485_OR_LATER(ah))
+		txiqcal_done = true;
+	else {
+		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+		udelay(5);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+	}
 
 	/* Calibrate the AGC */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
@@ -979,7 +885,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		return false;
 	}
 
-	if (AR_SREV_9485(ah))
+	if (txiqcal_done)
 		ar9003_hw_tx_iq_cal_post_proc(ah);
 
 	/* Revert chainmasks to their original values before NF cal */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 8bdda2c..7d1e8b5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -548,15 +548,12 @@
 
 #define AR_PHY_TXGAIN_TABLE      (AR_SM_BASE + 0x300)
 
-#define AR_PHY_TX_IQCAL_START_9485		(AR_SM_BASE + 0x3c4)
-#define AR_PHY_TX_IQCAL_START_DO_CAL_9485	0x80000000
-#define AR_PHY_TX_IQCAL_START_DO_CAL_9485_S	31
-#define AR_PHY_TX_IQCAL_CONTROL_1_9485		(AR_SM_BASE + 0x3c8)
-#define AR_PHY_TX_IQCAL_STATUS_B0_9485		(AR_SM_BASE + 0x3f0)
-
-#define AR_PHY_TX_IQCAL_CONTROL_1   (AR_SM_BASE + 0x448)
-#define AR_PHY_TX_IQCAL_START       (AR_SM_BASE + 0x440)
-#define AR_PHY_TX_IQCAL_STATUS_B0   (AR_SM_BASE + 0x48c)
+#define AR_PHY_TX_IQCAL_CONTROL_1   (AR_SM_BASE + AR_SREV_9485(ah) ? \
+						 0x3c8 : 0x448)
+#define AR_PHY_TX_IQCAL_START       (AR_SM_BASE + AR_SREV_9485(ah) ? \
+						 0x3c4 : 0x440)
+#define AR_PHY_TX_IQCAL_STATUS_B0   (AR_SM_BASE + AR_SREV_9485(ah) ? \
+						 0x3f0 : 0x48c)
 #define AR_PHY_TX_IQCAL_CORR_COEFF_B0(_i)    (AR_SM_BASE + \
 					     (AR_SREV_9485(ah) ? \
 					      0x3d0 : 0x450) + ((_i) << 2))
@@ -758,10 +755,10 @@
 #define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT   0x01000000
 #define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S 24
 #define AR_PHY_CHANNEL_STATUS_RX_CLEAR      0x00000004
-#define AR_PHY_TX_IQCAQL_CONTROL_1_IQCORR_I_Q_COFF_DELPT             0x01fc0000
-#define AR_PHY_TX_IQCAQL_CONTROL_1_IQCORR_I_Q_COFF_DELPT_S                   18
-#define AR_PHY_TX_IQCAL_START_DO_CAL        0x00000001
-#define AR_PHY_TX_IQCAL_START_DO_CAL_S      0
+#define AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT             0x01fc0000
+#define AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT_S                   18
+#define AR_PHY_TX_IQCAL_START_DO_CAL	    0x00000001
+#define AR_PHY_TX_IQCAL_START_DO_CAL_S	    0
 
 #define AR_PHY_TX_IQCAL_STATUS_FAILED    0x00000001
 #define AR_PHY_CALIBRATED_GAINS_0	 0x3e
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 6acbf0e..af09275 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -868,6 +868,8 @@
 #define AR_SREV_9485_11(_ah) \
 	(AR_SREV_9485(_ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9485_11))
+#define AR_SREV_9485_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9485))
 
 #define AR_SREV_9285E_20(_ah) \
     (AR_SREV_9285_12_OR_LATER(_ah) && \
-- 
1.7.4.4

