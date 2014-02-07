Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:47007 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaBGFAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 00:00:43 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 5/7] ath9k: Modify IQ calibration for AR955x
Date: Fri,  7 Feb 2014 10:29:53 +0530
Message-Id: <1391749195-24381-6-git-send-email-sujith@msujith.org> (sfid-20140207_060101_483702_15B579C4)
In-Reply-To: <1391749195-24381-1-git-send-email-sujith@msujith.org>
References: <1391749195-24381-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

IQ calibration post-processing for AR955x is different
from other chips - instead of just doing it as part
of AGC calibration once, it is triggered 3 times and
a median is determined. This patch adds initial support
for changing the calibration behavior for AR955x.

Also, to simplify things, a helper routine to issue/poll
AGC calibration is used.

For non-AR955x chips, the iqcal_idx (which will be used
in subsequent patches) is set to zero.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 81 +++++++++++++++++++--------
 1 file changed, 59 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 6d4cb00..4a02ceb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -23,6 +23,7 @@
 #define MAX_MEASUREMENT	MAX_IQCAL_MEASUREMENT
 #define MAX_MAG_DELTA	11
 #define MAX_PHS_DELTA	10
+#define MAXIQCAL        3
 
 struct coeff {
 	int mag_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT];
@@ -800,7 +801,7 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	if (q_q_coff > 63)
 		q_q_coff = 63;
 
-	iqc_coeff[0] = (q_q_coff * 128) + q_i_coff;
+	iqc_coeff[0] = (q_q_coff * 128) + (0x7f & q_i_coff);
 
 	ath_dbg(common, CALIBRATE, "tx chain %d: iq corr coeff=%x\n",
 		chain_idx, iqc_coeff[0]);
@@ -831,7 +832,7 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	if (q_q_coff > 63)
 		q_q_coff = 63;
 
-	iqc_coeff[1] = (q_q_coff * 128) + q_i_coff;
+	iqc_coeff[1] = (q_q_coff * 128) + (0x7f & q_i_coff);
 
 	ath_dbg(common, CALIBRATE, "rx chain %d: iq corr coeff=%x\n",
 		chain_idx, iqc_coeff[1]);
@@ -994,7 +995,9 @@ static bool ar9003_hw_tx_iq_cal_run(struct ath_hw *ah)
 	return true;
 }
 
-static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
+static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah,
+					  int iqcal_idx,
+					  bool is_reusable)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	const u32 txiqcal_status[AR9300_MAX_CHAINS] = {
@@ -1413,7 +1416,7 @@ skip_tx_iqcal:
 	}
 
 	if (txiqcal_done)
-		ar9003_hw_tx_iq_cal_post_proc(ah, is_reusable);
+		ar9003_hw_tx_iq_cal_post_proc(ah, 0, is_reusable);
 	else if (caldata && test_bit(TXIQCAL_DONE, &caldata->cal_flags))
 		ar9003_hw_tx_iq_cal_reload(ah);
 
@@ -1459,6 +1462,29 @@ skip_tx_iqcal:
 	return true;
 }
 
+static bool do_ar9003_agc_cal(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	bool status;
+
+	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
+		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
+		  AR_PHY_AGC_CONTROL_CAL);
+
+	status = ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
+			       AR_PHY_AGC_CONTROL_CAL,
+			       0, AH_WAIT_TIMEOUT);
+	if (!status) {
+		ath_dbg(common, CALIBRATE,
+			"offset calibration failed to complete in %d ms,"
+			"noisy environment?\n",
+			AH_WAIT_TIMEOUT / 1000);
+		return false;
+	}
+
+	return true;
+}
+
 static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 				   struct ath9k_channel *chan)
 {
@@ -1467,6 +1493,7 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 	bool txiqcal_done = false;
 	bool status = true;
 	bool run_agc_cal = false, sep_iq_cal = false;
+	int i = 0;
 
 	/* Use chip chainmask only for calibration */
 	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
@@ -1521,27 +1548,37 @@ skip_tx_iqcal:
 		if (AR_SREV_9330_11(ah))
 			ar9003_hw_manual_peak_cal(ah, 0, IS_CHAN_2GHZ(chan));
 
-		/* Calibrate the AGC */
-		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
-			  AR_PHY_AGC_CONTROL_CAL);
-
-		/* Poll for offset calibration complete */
-		status = ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
-				       AR_PHY_AGC_CONTROL_CAL,
-				       0, AH_WAIT_TIMEOUT);
-	}
+		/*
+		 * For non-AR9550 chips, we just trigger AGC calibration
+		 * in the HW, poll for completion and then process
+		 * the results.
+		 *
+		 * For AR955x, we run it multiple times and use
+		 * median IQ correction.
+		 */
+		if (!AR_SREV_9550(ah)) {
+			status = do_ar9003_agc_cal(ah);
+			if (!status)
+				return false;
 
-	if (!status) {
-		ath_dbg(common, CALIBRATE,
-			"offset calibration failed to complete in %d ms; noisy environment?\n",
-			AH_WAIT_TIMEOUT / 1000);
-		return false;
+			if (txiqcal_done)
+				ar9003_hw_tx_iq_cal_post_proc(ah, 0, false);
+		} else {
+			if (!txiqcal_done) {
+				status = do_ar9003_agc_cal(ah);
+				if (!status)
+					return false;
+			} else {
+				for (i = 0; i < MAXIQCAL; i++) {
+					status = do_ar9003_agc_cal(ah);
+					if (!status)
+						return false;
+					ar9003_hw_tx_iq_cal_post_proc(ah, i, false);
+				}
+			}
+		}
 	}
 
-	if (txiqcal_done)
-		ar9003_hw_tx_iq_cal_post_proc(ah, false);
-
 	/* Revert chainmask to runtime parameters */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
 
-- 
1.8.5.3

