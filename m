Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64254 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab0LOPbM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 10:31:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 07:30:56 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/7] ath9k_hw: Tx IQ cal changes for AR9003
Date: Wed, 15 Dec 2010 07:30:50 -0800
Message-ID: <1292427053-5880-4-git-send-email-vasanth@atheros.com>
In-Reply-To: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
References: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add multiple Tx IQ cal support to improve EVM accross
different power levels.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |  212 +++++++++++++------------
 1 files changed, 108 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 75a1c6e..4a4cd88 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -608,107 +608,6 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	return true;
 }
 
-static void ar9003_hw_tx_iq_cal(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	static const u32 txiqcal_status[AR9300_MAX_CHAINS] = {
-		AR_PHY_TX_IQCAL_STATUS_B0,
-		AR_PHY_TX_IQCAL_STATUS_B1,
-		AR_PHY_TX_IQCAL_STATUS_B2,
-	};
-	static const u_int32_t chan_info_tab[] = {
-		AR_PHY_CHAN_INFO_TAB_0,
-		AR_PHY_CHAN_INFO_TAB_1,
-		AR_PHY_CHAN_INFO_TAB_2,
-	};
-	u32 tx_corr_coeff[AR9300_MAX_CHAINS];
-	s32 iq_res[6];
-	s32 iqc_coeff[2];
-	s32 i, j;
-	u32 num_chains = 0;
-
-	tx_corr_coeff[0] = AR_PHY_TX_IQCAL_CORR_COEFF_B0(0);
-	tx_corr_coeff[1] = AR_PHY_TX_IQCAL_CORR_COEFF_B1(0);
-	tx_corr_coeff[2] = AR_PHY_TX_IQCAL_CORR_COEFF_B2(0);
-
-	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-		if (ah->txchainmask & (1 << i))
-			num_chains++;
-	}
-
-	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
-		      AR_PHY_TX_IQCAQL_CONTROL_1_IQCORR_I_Q_COFF_DELPT,
-		      DELPT);
-	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_START,
-		      AR_PHY_TX_IQCAL_START_DO_CAL,
-		      AR_PHY_TX_IQCAL_START_DO_CAL);
-
-	if (!ath9k_hw_wait(ah, AR_PHY_TX_IQCAL_START,
-			   AR_PHY_TX_IQCAL_START_DO_CAL,
-			   0, AH_WAIT_TIMEOUT)) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Tx IQ Cal not complete.\n");
-		goto TX_IQ_CAL_FAILED;
-	}
-
-	for (i = 0; i < num_chains; i++) {
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"Doing Tx IQ Cal for chain %d.\n", i);
-
-		if (REG_READ(ah, txiqcal_status[i]) &
-			     AR_PHY_TX_IQCAL_STATUS_FAILED) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Tx IQ Cal failed for chain %d.\n", i);
-			goto TX_IQ_CAL_FAILED;
-		}
-
-		for (j = 0; j < 3; j++) {
-			u_int8_t idx = 2 * j,
-			offset = 4 * j;
-
-			REG_RMW_FIELD(ah, AR_PHY_CHAN_INFO_MEMORY,
-				      AR_PHY_CHAN_INFO_TAB_S2_READ, 0);
-
-			/* 32 bits */
-			iq_res[idx] = REG_READ(ah, chan_info_tab[i] + offset);
-
-			REG_RMW_FIELD(ah, AR_PHY_CHAN_INFO_MEMORY,
-				      AR_PHY_CHAN_INFO_TAB_S2_READ, 1);
-
-			/* 16 bits */
-			iq_res[idx+1] = 0xffff & REG_READ(ah,
-							  chan_info_tab[i] +
-							  offset);
-
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"IQ RES[%d]=0x%x IQ_RES[%d]=0x%x\n",
-				idx, iq_res[idx], idx+1, iq_res[idx+1]);
-		}
-
-		if (!ar9003_hw_calc_iq_corr(ah, i, iq_res, iqc_coeff)) {
-			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"Failed in calculation of IQ correction.\n");
-			goto TX_IQ_CAL_FAILED;
-		}
-
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"IQ_COEFF[0] = 0x%x IQ_COEFF[1] = 0x%x\n",
-			iqc_coeff[0], iqc_coeff[1]);
-
-		REG_RMW_FIELD(ah, tx_corr_coeff[i],
-			      AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE,
-			      iqc_coeff[0]);
-	}
-
-	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_3,
-		      AR_PHY_TX_IQCAL_CONTROL_3_IQCORR_EN, 0x1);
-
-	return;
-
-TX_IQ_CAL_FAILED:
-	ath_dbg(common, ATH_DBG_CALIBRATE, "Tx IQ Cal failed\n");
-}
-
 static bool ar9003_hw_compute_closest_pass_and_avg(int *mp_coeff, int *mp_avg)
 {
 	int diff[MPASS];
@@ -717,9 +616,9 @@ static bool ar9003_hw_compute_closest_pass_and_avg(int *mp_coeff, int *mp_avg)
 	diff[1] = abs(mp_coeff[1] - mp_coeff[2]);
 	diff[2] = abs(mp_coeff[2] - mp_coeff[0]);
 
-	if (diff[0] > MAX_MEASUREMENT &&
-	    diff[1] > MAX_MEASUREMENT &&
-	    diff[2] > MAX_MEASUREMENT)
+	if (diff[0] > MAX_DIFFERENCE &&
+	    diff[1] > MAX_DIFFERENCE &&
+	    diff[2] > MAX_DIFFERENCE)
 		return false;
 
 	if (diff[0] <= diff[1] && diff[0] <= diff[2])
@@ -817,6 +716,111 @@ disable_txiqcal:
 	ath_dbg(common, ATH_DBG_CALIBRATE, "TX IQ Cal disabled\n");
 }
 
+static void ar9003_hw_tx_iq_cal(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	static const u32 txiqcal_status[AR9300_MAX_CHAINS] = {
+		AR_PHY_TX_IQCAL_STATUS_B0,
+		AR_PHY_TX_IQCAL_STATUS_B1,
+		AR_PHY_TX_IQCAL_STATUS_B2,
+	};
+	static const u32 chan_info_tab[] = {
+		AR_PHY_CHAN_INFO_TAB_0,
+		AR_PHY_CHAN_INFO_TAB_1,
+		AR_PHY_CHAN_INFO_TAB_2,
+	};
+	struct coeff coeff;
+	s32 iq_res[6];
+	s32 i, j, ip, im, nmeasurement;
+	u8 nchains = get_streams(common->tx_chainmask);
+
+	for (ip = 0; ip < MPASS; ip++) {
+		REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
+			      AR_PHY_TX_IQCAQL_CONTROL_1_IQCORR_I_Q_COFF_DELPT,
+			      DELPT);
+		REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_START,
+			      AR_PHY_TX_IQCAL_START_DO_CAL,
+			      AR_PHY_TX_IQCAL_START_DO_CAL);
+
+		if (!ath9k_hw_wait(ah, AR_PHY_TX_IQCAL_START,
+				   AR_PHY_TX_IQCAL_START_DO_CAL,
+				   0, AH_WAIT_TIMEOUT)) {
+			ath_dbg(common, ATH_DBG_CALIBRATE,
+				"Tx IQ Cal not complete.\n");
+			goto TX_IQ_CAL_FAILED;
+		}
+
+		nmeasurement = REG_READ_FIELD(ah, AR_PHY_TX_IQCAL_STATUS_B0,
+					      AR_PHY_CALIBRATED_GAINS_0);
+			if (nmeasurement > MAX_MEASUREMENT)
+				nmeasurement = MAX_MEASUREMENT;
+
+		for (i = 0; i < nchains; i++) {
+			ath_dbg(common, ATH_DBG_CALIBRATE,
+				"Doing Tx IQ Cal for chain %d.\n", i);
+			for (im = 0; im < nmeasurement; im++) {
+				if (REG_READ(ah, txiqcal_status[i]) &
+					     AR_PHY_TX_IQCAL_STATUS_FAILED) {
+					ath_dbg(common, ATH_DBG_CALIBRATE,
+						"Tx IQ Cal failed for chain %d.\n", i);
+					goto TX_IQ_CAL_FAILED;
+				}
+
+				for (j = 0; j < 3; j++) {
+					u8 idx = 2 * j,
+					   offset = 4 * (3 * im + j);
+
+					REG_RMW_FIELD(ah, AR_PHY_CHAN_INFO_MEMORY,
+						      AR_PHY_CHAN_INFO_TAB_S2_READ,
+						      0);
+
+					/* 32 bits */
+					iq_res[idx] = REG_READ(ah,
+							chan_info_tab[i] +
+							offset);
+
+					REG_RMW_FIELD(ah, AR_PHY_CHAN_INFO_MEMORY,
+						      AR_PHY_CHAN_INFO_TAB_S2_READ,
+						      1);
+
+					/* 16 bits */
+					iq_res[idx+1] = 0xffff & REG_READ(ah,
+								chan_info_tab[i] +
+								offset);
+
+					ath_dbg(common, ATH_DBG_CALIBRATE,
+						"IQ RES[%d]=0x%x IQ_RES[%d]=0x%x\n",
+						idx, iq_res[idx], idx+1, iq_res[idx+1]);
+				}
+
+				if (!ar9003_hw_calc_iq_corr(ah, i, iq_res,
+							    coeff.iqc_coeff)) {
+					ath_dbg(common, ATH_DBG_CALIBRATE,
+						"Failed in calculation of IQ correction.\n");
+					goto TX_IQ_CAL_FAILED;
+				}
+				coeff.mag_coeff[i][im][ip] =
+						coeff.iqc_coeff[0] & 0x7f;
+				coeff.phs_coeff[i][im][ip] =
+						(coeff.iqc_coeff[0] >> 7) & 0x7f;
+
+				if (coeff.mag_coeff[i][im][ip] > 63)
+					coeff.mag_coeff[i][im][ip] -= 128;
+				if (coeff.phs_coeff[i][im][ip] > 63)
+					coeff.phs_coeff[i][im][ip] -= 128;
+
+			}
+		}
+	}
+
+	ar9003_hw_tx_iqcal_load_avg_2_passes(ah, nchains, &coeff);
+
+	return;
+
+TX_IQ_CAL_FAILED:
+	ath_dbg(common, ATH_DBG_CALIBRATE, "Tx IQ Cal failed\n");
+}
+
 static void ar9003_hw_tx_iq_cal_run(struct ath_hw *ah)
 {
 	u8 tx_gain_forced;
-- 
1.7.0.4

