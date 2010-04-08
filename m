Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274Ab0DHT1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 067/102] ath9k_hw: complete AR9003 calibration
Date: Thu,  8 Apr 2010 15:27:03 -0400
Message-Id: <1270754858-26266-68-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This goes with some new shiny TX IQ calibration that AR9003
hardware family supports.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |  574 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |  100 +++++
 drivers/net/wireless/ath/ath9k/eeprom.h       |    1 +
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 4 files changed, 664 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index ea151ee..498f60a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -58,20 +58,107 @@ static void ar9003_hw_setup_calibration(struct ath_hw *ah,
 	}
 }
 
+/*
+ * Generic calibration routine.
+ * Recalibrate the lower PHY chips to account for temperature/environment
+ * changes.
+ */
+static bool ar9003_hw_per_calibration(struct ath_hw *ah,
+				      struct ath9k_channel *ichan,
+				      u8 rxchainmask,
+				      struct ath9k_cal_list *currCal)
+{
+	/* Cal is assumed not done until explicitly set below */
+	bool iscaldone = false;
+
+	/* Calibration in progress. */
+	if (currCal->calState == CAL_RUNNING) {
+		/* Check to see if it has finished. */
+		if (!(REG_READ(ah, AR_PHY_TIMING4) & AR_PHY_TIMING4_DO_CAL)) {
+			/*
+			* Accumulate cal measures for active chains
+			*/
+			currCal->calData->calCollect(ah);
+			ah->cal_samples++;
+
+			if (ah->cal_samples >=
+			    currCal->calData->calNumSamples) {
+				unsigned int i, numChains = 0;
+				for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+					if (rxchainmask & (1 << i))
+						numChains++;
+				}
+
+				/*
+				* Process accumulated data
+				*/
+				currCal->calData->calPostProc(ah, numChains);
+
+				/* Calibration has finished. */
+				ichan->CalValid |= currCal->calData->calType;
+				currCal->calState = CAL_DONE;
+				iscaldone = true;
+			} else {
+			/*
+			 * Set-up collection of another sub-sample until we
+			 * get desired number
+			 */
+			ar9003_hw_setup_calibration(ah, currCal);
+			}
+		}
+	} else if (!(ichan->CalValid & currCal->calData->calType)) {
+		/* If current cal is marked invalid in channel, kick it off */
+		ath9k_hw_reset_calibration(ah, currCal);
+	}
+
+	return iscaldone;
+}
+
 static bool ar9003_hw_calibrate(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				u8 rxchainmask,
 				bool longcal)
 {
-	/* TODO */
-	return false;
-}
+	bool iscaldone = true;
+	struct ath9k_cal_list *currCal = ah->cal_list_curr;
+
+	/*
+	 * For given calibration:
+	 * 1. Call generic cal routine
+	 * 2. When this cal is done (isCalDone) if we have more cals waiting
+	 *    (eg after reset), mask this to upper layers by not propagating
+	 *    isCalDone if it is set to TRUE.
+	 *    Instead, change isCalDone to FALSE and setup the waiting cal(s)
+	 *    to be run.
+	 */
+	if (currCal &&
+	    (currCal->calState == CAL_RUNNING ||
+	     currCal->calState == CAL_WAITING)) {
+		iscaldone = ar9003_hw_per_calibration(ah, chan,
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
 
-static bool ar9003_hw_init_cal(struct ath_hw *ah,
-			       struct ath9k_channel *chan)
-{
-	/* TODO */
-	return false;
+	/* Do NF cal only at longer intervals */
+	if (longcal) {
+		/*
+		 * Load the NF from history buffer of the current channel.
+		 * NF is slow time-variant, so it is OK to use a historical value.
+		 */
+		ath9k_hw_loadnf(ah, ah->curchan);
+
+		/* start NF calibration, without updating BB NF register */
+		ath9k_hw_start_nfcal(ah);
+	}
+
+	return iscaldone;
 }
 
 static void ar9003_hw_iqcal_collect(struct ath_hw *ah)
@@ -224,13 +311,477 @@ static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 static bool ar9003_hw_iscal_supported(struct ath_hw *ah,
 				      enum ath9k_cal_types calType)
 {
-	/* TODO */
+	switch (calType & ah->supp_cals) {
+	case IQ_MISMATCH_CAL:
+		/*
+		 * XXX: Run IQ Mismatch for non-CCK only
+		 * Note that CHANNEL_B is never set though.
+		 */
+		return true;
+	case ADC_GAIN_CAL:
+	case ADC_DC_CAL:
+		return false;
+	case TEMP_COMP_CAL:
+		return true;
+	}
+
 	return false;
 }
 
-static void ar9003_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
+/*
+ * solve 4x4 linear equation used in loopback iq cal.
+ */
+static bool ar9003_hw_solve_iq_cal(struct ath_hw *ah,
+				   s32 sin_2phi_1,
+				   s32 cos_2phi_1,
+				   s32 sin_2phi_2,
+				   s32 cos_2phi_2,
+				   s32 mag_a0_d0,
+				   s32 phs_a0_d0,
+				   s32 mag_a1_d0,
+				   s32 phs_a1_d0,
+				   s32 solved_eq[])
+{
+	s32 f1 = cos_2phi_1 - cos_2phi_2,
+	    f3 = sin_2phi_1 - sin_2phi_2,
+	    f2;
+	s32 mag_tx, phs_tx, mag_rx, phs_rx;
+	const s32 result_shift = 1 << 15;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	f2 = (f1 * f1 + f3 * f3) / result_shift;
+
+	if (!f2) {
+		ath_print(common, ATH_DBG_CALIBRATE, "Divide by 0\n");
+		return false;
+	}
+
+	/* mag mismatch, tx */
+	mag_tx = f1 * (mag_a0_d0  - mag_a1_d0) + f3 * (phs_a0_d0 - phs_a1_d0);
+	/* phs mismatch, tx */
+	phs_tx = f3 * (-mag_a0_d0 + mag_a1_d0) + f1 * (phs_a0_d0 - phs_a1_d0);
+
+	mag_tx = (mag_tx / f2);
+	phs_tx = (phs_tx / f2);
+
+	/* mag mismatch, rx */
+	mag_rx = mag_a0_d0 - (cos_2phi_1 * mag_tx + sin_2phi_1 * phs_tx) /
+		 result_shift;
+	/* phs mismatch, rx */
+	phs_rx = phs_a0_d0 + (sin_2phi_1 * mag_tx - cos_2phi_1 * phs_tx) /
+		 result_shift;
+
+	solved_eq[0] = mag_tx;
+	solved_eq[1] = phs_tx;
+	solved_eq[2] = mag_rx;
+	solved_eq[3] = phs_rx;
+
+	return true;
+}
+
+static s32 ar9003_hw_find_mag_approx(struct ath_hw *ah, s32 in_re, s32 in_im)
 {
-	/* TODO */
+	s32 abs_i = abs(in_re),
+	    abs_q = abs(in_im),
+	    max_abs, min_abs;
+
+	if (abs_i > abs_q) {
+		max_abs = abs_i;
+		min_abs = abs_q;
+	} else {
+		max_abs = abs_q;
+		min_abs = abs_i;
+	}
+
+	return (max_abs - (max_abs / 32) + (min_abs / 8) + (min_abs / 4));
+}
+
+#define DELPT 32
+
+static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
+				   s32 chain_idx,
+				   const s32 iq_res[],
+				   s32 iqc_coeff[])
+{
+	s32 i2_m_q2_a0_d0, i2_p_q2_a0_d0, iq_corr_a0_d0,
+	    i2_m_q2_a0_d1, i2_p_q2_a0_d1, iq_corr_a0_d1,
+	    i2_m_q2_a1_d0, i2_p_q2_a1_d0, iq_corr_a1_d0,
+	    i2_m_q2_a1_d1, i2_p_q2_a1_d1, iq_corr_a1_d1;
+	s32 mag_a0_d0, mag_a1_d0, mag_a0_d1, mag_a1_d1,
+	    phs_a0_d0, phs_a1_d0, phs_a0_d1, phs_a1_d1,
+	    sin_2phi_1, cos_2phi_1,
+	    sin_2phi_2, cos_2phi_2;
+	s32 mag_tx, phs_tx, mag_rx, phs_rx;
+	s32 solved_eq[4], mag_corr_tx, phs_corr_tx, mag_corr_rx, phs_corr_rx,
+	    q_q_coff, q_i_coff;
+	const s32 res_scale = 1 << 15;
+	const s32 delpt_shift = 1 << 8;
+	s32 mag1, mag2;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	i2_m_q2_a0_d0 = iq_res[0] & 0xfff;
+	i2_p_q2_a0_d0 = (iq_res[0] >> 12) & 0xfff;
+	iq_corr_a0_d0 = ((iq_res[0] >> 24) & 0xff) + ((iq_res[1] & 0xf) << 8);
+
+	if (i2_m_q2_a0_d0 > 0x800)
+		i2_m_q2_a0_d0 = -((0xfff - i2_m_q2_a0_d0) + 1);
+
+	if (i2_p_q2_a0_d0 > 0x800)
+		i2_p_q2_a0_d0 = -((0xfff - i2_p_q2_a0_d0) + 1);
+
+	if (iq_corr_a0_d0 > 0x800)
+		iq_corr_a0_d0 = -((0xfff - iq_corr_a0_d0) + 1);
+
+	i2_m_q2_a0_d1 = (iq_res[1] >> 4) & 0xfff;
+	i2_p_q2_a0_d1 = (iq_res[2] & 0xfff);
+	iq_corr_a0_d1 = (iq_res[2] >> 12) & 0xfff;
+
+	if (i2_m_q2_a0_d1 > 0x800)
+		i2_m_q2_a0_d1 = -((0xfff - i2_m_q2_a0_d1) + 1);
+
+	if (i2_p_q2_a0_d1 > 0x800)
+		i2_p_q2_a0_d1 = -((0xfff - i2_p_q2_a0_d1) + 1);
+
+	if (iq_corr_a0_d1 > 0x800)
+		iq_corr_a0_d1 = -((0xfff - iq_corr_a0_d1) + 1);
+
+	i2_m_q2_a1_d0 = ((iq_res[2] >> 24) & 0xff) + ((iq_res[3] & 0xf) << 8);
+	i2_p_q2_a1_d0 = (iq_res[3] >> 4) & 0xfff;
+	iq_corr_a1_d0 = iq_res[4] & 0xfff;
+
+	if (i2_m_q2_a1_d0 > 0x800)
+		i2_m_q2_a1_d0 = -((0xfff - i2_m_q2_a1_d0) + 1);
+
+	if (i2_p_q2_a1_d0 > 0x800)
+		i2_p_q2_a1_d0 = -((0xfff - i2_p_q2_a1_d0) + 1);
+
+	if (iq_corr_a1_d0 > 0x800)
+		iq_corr_a1_d0 = -((0xfff - iq_corr_a1_d0) + 1);
+
+	i2_m_q2_a1_d1 = (iq_res[4] >> 12) & 0xfff;
+	i2_p_q2_a1_d1 = ((iq_res[4] >> 24) & 0xff) + ((iq_res[5] & 0xf) << 8);
+	iq_corr_a1_d1 = (iq_res[5] >> 4) & 0xfff;
+
+	if (i2_m_q2_a1_d1 > 0x800)
+		i2_m_q2_a1_d1 = -((0xfff - i2_m_q2_a1_d1) + 1);
+
+	if (i2_p_q2_a1_d1 > 0x800)
+		i2_p_q2_a1_d1 = -((0xfff - i2_p_q2_a1_d1) + 1);
+
+	if (iq_corr_a1_d1 > 0x800)
+		iq_corr_a1_d1 = -((0xfff - iq_corr_a1_d1) + 1);
+
+	if ((i2_p_q2_a0_d0 == 0) || (i2_p_q2_a0_d1 == 0) ||
+	    (i2_p_q2_a1_d0 == 0) || (i2_p_q2_a1_d1 == 0)) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Divide by 0:\na0_d0=%d\n"
+			  "a0_d1=%d\na2_d0=%d\na1_d1=%d\n",
+			  i2_p_q2_a0_d0, i2_p_q2_a0_d1,
+			  i2_p_q2_a1_d0, i2_p_q2_a1_d1);
+		return false;
+	}
+
+	mag_a0_d0 = (i2_m_q2_a0_d0 * res_scale) / i2_p_q2_a0_d0;
+	phs_a0_d0 = (iq_corr_a0_d0 * res_scale) / i2_p_q2_a0_d0;
+
+	mag_a0_d1 = (i2_m_q2_a0_d1 * res_scale) / i2_p_q2_a0_d1;
+	phs_a0_d1 = (iq_corr_a0_d1 * res_scale) / i2_p_q2_a0_d1;
+
+	mag_a1_d0 = (i2_m_q2_a1_d0 * res_scale) / i2_p_q2_a1_d0;
+	phs_a1_d0 = (iq_corr_a1_d0 * res_scale) / i2_p_q2_a1_d0;
+
+	mag_a1_d1 = (i2_m_q2_a1_d1 * res_scale) / i2_p_q2_a1_d1;
+	phs_a1_d1 = (iq_corr_a1_d1 * res_scale) / i2_p_q2_a1_d1;
+
+	/* w/o analog phase shift */
+	sin_2phi_1 = (((mag_a0_d0 - mag_a0_d1) * delpt_shift) / DELPT);
+	/* w/o analog phase shift */
+	cos_2phi_1 = (((phs_a0_d1 - phs_a0_d0) * delpt_shift) / DELPT);
+	/* w/  analog phase shift */
+	sin_2phi_2 = (((mag_a1_d0 - mag_a1_d1) * delpt_shift) / DELPT);
+	/* w/  analog phase shift */
+	cos_2phi_2 = (((phs_a1_d1 - phs_a1_d0) * delpt_shift) / DELPT);
+
+	/*
+	 * force sin^2 + cos^2 = 1;
+	 * find magnitude by approximation
+	 */
+	mag1 = ar9003_hw_find_mag_approx(ah, cos_2phi_1, sin_2phi_1);
+	mag2 = ar9003_hw_find_mag_approx(ah, cos_2phi_2, sin_2phi_2);
+
+	if ((mag1 == 0) || (mag2 == 0)) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Divide by 0: mag1=%d, mag2=%d\n",
+			  mag1, mag2);
+		return false;
+	}
+
+	/* normalization sin and cos by mag */
+	sin_2phi_1 = (sin_2phi_1 * res_scale / mag1);
+	cos_2phi_1 = (cos_2phi_1 * res_scale / mag1);
+	sin_2phi_2 = (sin_2phi_2 * res_scale / mag2);
+	cos_2phi_2 = (cos_2phi_2 * res_scale / mag2);
+
+	/* calculate IQ mismatch */
+	if (!ar9003_hw_solve_iq_cal(ah,
+			     sin_2phi_1, cos_2phi_1,
+			     sin_2phi_2, cos_2phi_2,
+			     mag_a0_d0, phs_a0_d0,
+			     mag_a1_d0,
+			     phs_a1_d0, solved_eq)) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Call to ar9003_hw_solve_iq_cal() failed.\n");
+		return false;
+	}
+
+	mag_tx = solved_eq[0];
+	phs_tx = solved_eq[1];
+	mag_rx = solved_eq[2];
+	phs_rx = solved_eq[3];
+
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "chain %d: mag mismatch=%d phase mismatch=%d\n",
+		  chain_idx, mag_tx/res_scale, phs_tx/res_scale);
+
+	if (res_scale == mag_tx) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Divide by 0: mag_tx=%d, res_scale=%d\n",
+			  mag_tx, res_scale);
+		return false;
+	}
+
+	/* calculate and quantize Tx IQ correction factor */
+	mag_corr_tx = (mag_tx * res_scale) / (res_scale - mag_tx);
+	phs_corr_tx = -phs_tx;
+
+	q_q_coff = (mag_corr_tx * 128 / res_scale);
+	q_i_coff = (phs_corr_tx * 256 / res_scale);
+
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "tx chain %d: mag corr=%d  phase corr=%d\n",
+		  chain_idx, q_q_coff, q_i_coff);
+
+	if (q_i_coff < -63)
+		q_i_coff = -63;
+	if (q_i_coff > 63)
+		q_i_coff = 63;
+	if (q_q_coff < -63)
+		q_q_coff = -63;
+	if (q_q_coff > 63)
+		q_q_coff = 63;
+
+	iqc_coeff[0] = (q_q_coff * 128) + q_i_coff;
+
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "tx chain %d: iq corr coeff=%x\n",
+		  chain_idx, iqc_coeff[0]);
+
+	if (-mag_rx == res_scale) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Divide by 0: mag_rx=%d, res_scale=%d\n",
+			  mag_rx, res_scale);
+		return false;
+	}
+
+	/* calculate and quantize Rx IQ correction factors */
+	mag_corr_rx = (-mag_rx * res_scale) / (res_scale + mag_rx);
+	phs_corr_rx = -phs_rx;
+
+	q_q_coff = (mag_corr_rx * 128 / res_scale);
+	q_i_coff = (phs_corr_rx * 256 / res_scale);
+
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "rx chain %d: mag corr=%d  phase corr=%d\n",
+		  chain_idx, q_q_coff, q_i_coff);
+
+	if (q_i_coff < -63)
+		q_i_coff = -63;
+	if (q_i_coff > 63)
+		q_i_coff = 63;
+	if (q_q_coff < -63)
+		q_q_coff = -63;
+	if (q_q_coff > 63)
+		q_q_coff = 63;
+
+	iqc_coeff[1] = (q_q_coff * 128) + q_i_coff;
+
+	ath_print(common, ATH_DBG_CALIBRATE,
+		  "rx chain %d: iq corr coeff=%x\n",
+		  chain_idx, iqc_coeff[1]);
+
+	return true;
+}
+
+static void ar9003_hw_tx_iq_cal(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	const u32 txiqcal_status[AR9300_MAX_CHAINS] = {
+		AR_PHY_TX_IQCAL_STATUS_B0,
+		AR_PHY_TX_IQCAL_STATUS_B1,
+		AR_PHY_TX_IQCAL_STATUS_B2,
+	};
+	const u32 tx_corr_coeff[AR9300_MAX_CHAINS] = {
+		AR_PHY_TX_IQCAL_CORR_COEFF_01_B0,
+		AR_PHY_TX_IQCAL_CORR_COEFF_01_B1,
+		AR_PHY_TX_IQCAL_CORR_COEFF_01_B2,
+	};
+	const u32 rx_corr[AR9300_MAX_CHAINS] = {
+		AR_PHY_RX_IQCAL_CORR_B0,
+		AR_PHY_RX_IQCAL_CORR_B1,
+		AR_PHY_RX_IQCAL_CORR_B2,
+	};
+	const u_int32_t chan_info_tab[] = {
+		AR_PHY_CHAN_INFO_TAB_0,
+		AR_PHY_CHAN_INFO_TAB_1,
+		AR_PHY_CHAN_INFO_TAB_2,
+	};
+	s32 iq_res[6];
+	s32 iqc_coeff[2];
+	s32 i, j;
+	u32 num_chains = 0;
+
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		if (ah->txchainmask & (1 << i))
+			num_chains++;
+	}
+
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
+		      AR_PHY_TX_IQCAQL_CONTROL_1_IQCORR_I_Q_COFF_DELPT,
+		      DELPT);
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_START,
+		      AR_PHY_TX_IQCAL_START_DO_CAL,
+		      AR_PHY_TX_IQCAL_START_DO_CAL);
+
+	if (!ath9k_hw_wait(ah, AR_PHY_TX_IQCAL_START,
+			   AR_PHY_TX_IQCAL_START_DO_CAL,
+			   0, AH_WAIT_TIMEOUT)) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Tx IQ Cal not complete.\n");
+		goto TX_IQ_CAL_FAILED;
+	}
+
+	for (i = 0; i < num_chains; i++) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "Doing Tx IQ Cal for chain %d.\n", i);
+
+		if (REG_READ(ah, txiqcal_status[i]) &
+			     AR_PHY_TX_IQCAL_STATUS_FAILED) {
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Tx IQ Cal failed for chain %d.\n", i);
+			goto TX_IQ_CAL_FAILED;
+		}
+
+		for (j = 0; j < 3; j++) {
+			u_int8_t idx = 2 * j,
+			offset = 4 * j;
+
+			REG_RMW_FIELD(ah, AR_PHY_CHAN_INFO_MEMORY,
+				      AR_PHY_CHAN_INFO_TAB_S2_READ, 0);
+
+			/* 32 bits */
+			iq_res[idx] = REG_READ(ah, chan_info_tab[i] + offset);
+
+			REG_RMW_FIELD(ah, AR_PHY_CHAN_INFO_MEMORY,
+				      AR_PHY_CHAN_INFO_TAB_S2_READ, 1);
+
+			/* 16 bits */
+			iq_res[idx+1] = 0xffff & REG_READ(ah, chan_info_tab[i] + offset);
+
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "IQ RES[%d]=0x%x IQ_RES[%d]=0x%x\n",
+				  idx, iq_res[idx], idx+1, iq_res[idx+1]);
+		}
+
+		if (!ar9003_hw_calc_iq_corr(ah, i, iq_res, iqc_coeff)) {
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "Failed in calculation of IQ correction.\n");
+			goto TX_IQ_CAL_FAILED;
+		}
+
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "IQ_COEFF[0] = 0x%x IQ_COEFF[1] = 0x%x\n",
+			  iqc_coeff[0], iqc_coeff[1]);
+
+		REG_RMW_FIELD(ah, tx_corr_coeff[i],
+			      AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE,
+			      iqc_coeff[0]);
+		REG_RMW_FIELD(ah, rx_corr[i],
+			      AR_PHY_RX_IQCAL_CORR_LOOPBACK_IQCORR_Q_Q_COFF,
+			      iqc_coeff[1] >> 7);
+		REG_RMW_FIELD(ah, rx_corr[i],
+			      AR_PHY_RX_IQCAL_CORR_LOOPBACK_IQCORR_Q_I_COFF,
+			      iqc_coeff[1]);
+	}
+
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_3,
+		      AR_PHY_TX_IQCAL_CONTROL_3_IQCORR_EN, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_RX_IQCAL_CORR_B0,
+		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
+
+	return;
+
+TX_IQ_CAL_FAILED:
+	ath_print(common, ATH_DBG_CALIBRATE, "Tx IQ Cal failed\n");
+	return;
+}
+
+static bool ar9003_hw_init_cal(struct ath_hw *ah,
+			       struct ath9k_channel *chan)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	/*
+	 * 0x7 = 0b111 , AR9003 needs to be configured for 3-chain mode before
+	 * running AGC/TxIQ cals
+	 */
+	ar9003_hw_modify_chain_masks(ah, 0x7, 0x7);
+
+	/* Calibrate the AGC */
+	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
+		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
+		  AR_PHY_AGC_CONTROL_CAL);
+
+	/* Poll for offset calibration complete */
+	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
+			   0, AH_WAIT_TIMEOUT)) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "offset calibration failed to "
+			  "complete in 1ms; noisy environment?\n");
+		return false;
+	}
+
+	/* Do Tx IQ Calibration */
+	ar9003_hw_tx_iq_cal(ah);
+
+	/* Revert chainmasks to their original values before NF cal */
+	ar9003_hw_modify_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+
+	/* Initialize list pointers */
+	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
+
+	if (ar9003_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
+		INIT_CAL(&ah->iq_caldata);
+		INSERT_CAL(ah, &ah->iq_caldata);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "enabling IQ Calibration.\n");
+	}
+
+	if (ar9003_hw_iscal_supported(ah, TEMP_COMP_CAL)) {
+		INIT_CAL(&ah->tempCompCalData);
+		INSERT_CAL(ah, &ah->tempCompCalData);
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "enabling Temperature Compensation Calibration.\n");
+	}
+
+	/* Initialize current pointer to first element in list */
+	ah->cal_list_curr = ah->cal_list;
+
+	if (ah->cal_list_curr)
+		ath9k_hw_reset_calibration(ah, ah->cal_list_curr);
+
+	chan->CalValid = 0;
+
+	return true;
 }
 
 void ar9003_hw_attach_calib_ops(struct ath_hw *ah)
@@ -242,7 +793,6 @@ void ar9003_hw_attach_calib_ops(struct ath_hw *ah)
 	priv_ops->init_cal = ar9003_hw_init_cal;
 	priv_ops->setup_calibration = ar9003_hw_setup_calibration;
 	priv_ops->iscal_supported = ar9003_hw_iscal_supported;
-	priv_ops->loadnf = ar9003_hw_loadnf;
 
 	ops->calibrate = ar9003_hw_calibrate;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index faa7d0f..c60f39f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -816,6 +816,105 @@ void ar9003_hw_set_nf_limits(struct ath_hw *ah)
 	ah->nf_5g_min = AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ;
 }
 
+/*
+ * Find out which of the RX chains are enabled
+ */
+static u32 ar9003_hw_get_rx_chainmask(struct ath_hw *ah)
+{
+	u32 chain = REG_READ(ah, AR_PHY_RX_CHAINMASK);
+	/*
+	 * The bits [2:0] indicate the rx chain mask and are to be
+	 * interpreted as follows:
+	 * 00x => Only chain 0 is enabled
+	 * 01x => Chain 1 and 0 enabled
+	 * 1xx => Chain 2,1 and 0 enabled
+	 */
+	return (chain & 0x7);
+}
+
+static void ar9003_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	struct ath9k_nfcal_hist *h;
+	unsigned i, j;
+	int32_t val;
+	const u32 ar9300_cca_regs[6] = {
+		AR_PHY_CCA_0,
+		AR_PHY_CCA_1,
+		AR_PHY_CCA_2,
+		AR_PHY_EXT_CCA,
+		AR_PHY_EXT_CCA_1,
+		AR_PHY_EXT_CCA_2,
+	};
+	u8 chainmask, rx_chain_status;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	rx_chain_status = ar9003_hw_get_rx_chainmask(ah);
+
+	chainmask = 0x3F;
+	h = ah->nfCalHist;
+
+	for (i = 0; i < NUM_NF_READINGS; i++) {
+		if (chainmask & (1 << i)) {
+			val = REG_READ(ah, ar9300_cca_regs[i]);
+			val &= 0xFFFFFE00;
+			val |= (((u32) (h[i].privNF) << 1) & 0x1ff);
+			REG_WRITE(ah, ar9300_cca_regs[i], val);
+		}
+	}
+
+	/*
+	 * Load software filtered NF value into baseband internal minCCApwr
+	 * variable.
+	 */
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_ENABLE_NF);
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
+
+	/*
+	 * Wait for load to complete, should be fast, a few 10s of us.
+	 * The max delay was changed from an original 250us to 10000us
+	 * since 250us often results in NF load timeout and causes deaf
+	 * condition during stress testing 12/12/2009
+	 */
+	for (j = 0; j < 1000; j++) {
+		if ((REG_READ(ah, AR_PHY_AGC_CONTROL) &
+		     AR_PHY_AGC_CONTROL_NF) == 0)
+			break;
+		udelay(10);
+	}
+
+	/*
+	 * We timed out waiting for the noisefloor to load, probably due to an
+	 * in-progress rx. Simply return here and allow the load plenty of time
+	 * to complete before the next calibration interval.  We need to avoid
+	 * trying to load -50 (which happens below) while the previous load is
+	 * still in progress as this can cause rx deafness. Instead by returning
+	 * here, the baseband nf cal will just be capped by our present
+	 * noisefloor until the next calibration timer.
+	 */
+	if (j == 1000) {
+		ath_print(common, ATH_DBG_ANY, "Timeout while waiting for nf "
+			  "to load: AR_PHY_AGC_CONTROL=0x%x\n",
+			  REG_READ(ah, AR_PHY_AGC_CONTROL));
+	}
+
+	/*
+	 * Restore maxCCAPower register parameter again so that we're not capped
+	 * by the median we just loaded.  This will be initial (and max) value
+	 * of next noise floor calibration the baseband does.
+	 */
+	for (i = 0; i < NUM_NF_READINGS; i++) {
+		if (chainmask & (1 << i)) {
+			val = REG_READ(ah, ar9300_cca_regs[i]);
+			val &= 0xFFFFFE00;
+			val |= (((u32) (-50) << 1) & 0x1ff);
+			REG_WRITE(ah, ar9300_cca_regs[i], val);
+		}
+	}
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -835,4 +934,5 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->set_diversity = ar9003_hw_set_diversity;
 	priv_ops->ani_control = ar9003_hw_ani_control;
 	priv_ops->do_getnf = ar9003_hw_do_getnf;
+	priv_ops->loadnf = ar9003_hw_loadnf;
 }
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index e087e2d..c0cd717 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -155,6 +155,7 @@
 #define AR5416_BCHAN_UNUSED             0xFF
 #define AR5416_MAX_PWR_RANGE_IN_HALF_DB 64
 #define AR5416_MAX_CHAINS               3
+#define AR9300_MAX_CHAINS		3
 #define AR5416_PWR_TABLE_OFFSET_DB     -5
 
 /* Rx gain type values */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b280bcb..7f49690 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -605,6 +605,7 @@ struct ath_hw {
 	struct ath9k_cal_list adcgain_caldata;
 	struct ath9k_cal_list adcdc_calinitdata;
 	struct ath9k_cal_list adcdc_caldata;
+	struct ath9k_cal_list tempCompCalData;
 	struct ath9k_cal_list *cal_list;
 	struct ath9k_cal_list *cal_list_last;
 	struct ath9k_cal_list *cal_list_curr;
-- 
1.6.3.3

