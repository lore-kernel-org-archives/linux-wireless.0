Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50621 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3KQFOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Nov 2013 00:14:55 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] ath9k: Remove RTT/MCI code from SoC calibration
Date: Sun, 17 Nov 2013 10:40:13 +0530
Message-Id: <1384665016-12022-2-git-send-email-sujith@msujith.org> (sfid-20131117_061522_709555_1CFCDC71)
In-Reply-To: <1384665016-12022-1-git-send-email-sujith@msujith.org>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

RTT is enabled only for AR9462 and MCI for AR9462/AR9565.
Also, manual peak calibration is not done for any of the
SoC chips.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 70 +--------------------------
 1 file changed, 1 insertion(+), 69 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 9f54cb5..2824824 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1235,46 +1235,12 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	bool txiqcal_done = false;
 	bool is_reusable = true, status = true;
-	bool run_rtt_cal = false, run_agc_cal, sep_iq_cal = false;
-	bool rtt = !!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT);
+	bool run_agc_cal = false, sep_iq_cal = false;
 	u32 rx_delay = 0;
-	u32 agc_ctrl = 0, agc_supp_cals = AR_PHY_AGC_CONTROL_OFFSET_CAL |
-					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
-					  AR_PHY_AGC_CONTROL_PKDET_CAL;
 
 	/* Use chip chainmask only for calibration */
 	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
 
-	if (rtt) {
-		if (!ar9003_hw_rtt_restore(ah, chan))
-			run_rtt_cal = true;
-
-		if (run_rtt_cal)
-			ath_dbg(common, CALIBRATE, "RTT calibration to be done\n");
-	}
-
-	run_agc_cal = run_rtt_cal;
-
-	if (run_rtt_cal) {
-		ar9003_hw_rtt_enable(ah);
-		ar9003_hw_rtt_set_mask(ah, 0x00);
-		ar9003_hw_rtt_clear_hist(ah);
-	}
-
-	if (rtt) {
-		if (!run_rtt_cal) {
-			agc_ctrl = REG_READ(ah, AR_PHY_AGC_CONTROL);
-			agc_supp_cals &= agc_ctrl;
-			agc_ctrl &= ~(AR_PHY_AGC_CONTROL_OFFSET_CAL |
-				      AR_PHY_AGC_CONTROL_FLTR_CAL |
-				      AR_PHY_AGC_CONTROL_PKDET_CAL);
-			REG_WRITE(ah, AR_PHY_AGC_CONTROL, agc_ctrl);
-		} else {
-			if (ah->ah_flags & AH_FASTCC)
-				run_agc_cal = true;
-		}
-	}
-
 	if (ah->enabled_cals & TX_CL_CAL) {
 		if (caldata && test_bit(TXCLCAL_DONE, &caldata->cal_flags))
 			REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL,
@@ -1313,9 +1279,6 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 	}
 
 skip_tx_iqcal:
-	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
-		ar9003_mci_init_cal_req(ah, &is_reusable);
-
 	if (sep_iq_cal) {
 		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
 		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
@@ -1342,8 +1305,6 @@ skip_tx_iqcal:
 		status = ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
 				       AR_PHY_AGC_CONTROL_CAL,
 				       0, AH_WAIT_TIMEOUT);
-
-		ar9003_hw_do_manual_peak_cal(ah, chan, run_rtt_cal);
 	}
 
 	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
@@ -1351,18 +1312,7 @@ skip_tx_iqcal:
 		udelay(5);
 	}
 
-	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
-		ar9003_mci_init_cal_done(ah);
-
-	if (rtt && !run_rtt_cal) {
-		agc_ctrl |= agc_supp_cals;
-		REG_WRITE(ah, AR_PHY_AGC_CONTROL, agc_ctrl);
-	}
-
 	if (!status) {
-		if (run_rtt_cal)
-			ar9003_hw_rtt_disable(ah);
-
 		ath_dbg(common, CALIBRATE,
 			"offset calibration failed to complete in %d ms; noisy environment?\n",
 			AH_WAIT_TIMEOUT / 1000);
@@ -1376,24 +1326,6 @@ skip_tx_iqcal:
 
 	ar9003_hw_cl_cal_post_proc(ah, is_reusable);
 
-	if (run_rtt_cal && caldata) {
-		if (is_reusable) {
-			if (!ath9k_hw_rfbus_req(ah)) {
-				ath_err(ath9k_hw_common(ah),
-					"Could not stop baseband\n");
-			} else {
-				ar9003_hw_rtt_fill_hist(ah);
-
-				if (test_bit(SW_PKDET_DONE, &caldata->cal_flags))
-					ar9003_hw_rtt_load_hist(ah);
-			}
-
-			ath9k_hw_rfbus_done(ah);
-		}
-
-		ar9003_hw_rtt_disable(ah);
-	}
-
 	/* Revert chainmask to runtime parameters */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
 
-- 
1.8.4.2

