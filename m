Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55949 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3KOJfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:35:07 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 1/5] ath9k: Separate routines for PCOEM and SoC calibration
Date: Fri, 15 Nov 2013 15:00:23 +0530
Message-Id: <1384507827-16026-2-git-send-email-sujith@msujith.org> (sfid-20131115_103517_765757_F0F74327)
In-Reply-To: <1384507827-16026-1-git-send-email-sujith@msujith.org>
References: <1384507827-16026-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Though there is some overlap between the calibration mechanisms
of PC-OEM cards and SoC chip families, dumping both of them
into a single function makes things hard to understand.

ar9003_hw_init_cal() is unreadable with chip-specific segments
scattered around. To make the logic understandable, use
different functions for client cards and SoC chips. Some
code is duplicated, but in the long run, it makes the code
more maintanable.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 198 +++++++++++++++++++++++++-
 1 file changed, 195 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 22934d3..9f54cb5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1040,8 +1040,196 @@ static void ar9003_hw_cl_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 	}
 }
 
-static bool ar9003_hw_init_cal(struct ath_hw *ah,
-			       struct ath9k_channel *chan)
+static bool ar9003_hw_init_cal_pcoem(struct ath_hw *ah,
+				     struct ath9k_channel *chan)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	bool txiqcal_done = false;
+	bool is_reusable = true, status = true;
+	bool run_rtt_cal = false, run_agc_cal, sep_iq_cal = false;
+	bool rtt = !!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT);
+	u32 rx_delay = 0;
+	u32 agc_ctrl = 0, agc_supp_cals = AR_PHY_AGC_CONTROL_OFFSET_CAL |
+					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
+					  AR_PHY_AGC_CONTROL_PKDET_CAL;
+
+	/* Use chip chainmask only for calibration */
+	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
+
+	if (rtt) {
+		if (!ar9003_hw_rtt_restore(ah, chan))
+			run_rtt_cal = true;
+
+		if (run_rtt_cal)
+			ath_dbg(common, CALIBRATE, "RTT calibration to be done\n");
+	}
+
+	run_agc_cal = run_rtt_cal;
+
+	if (run_rtt_cal) {
+		ar9003_hw_rtt_enable(ah);
+		ar9003_hw_rtt_set_mask(ah, 0x00);
+		ar9003_hw_rtt_clear_hist(ah);
+	}
+
+	if (rtt) {
+		if (!run_rtt_cal) {
+			agc_ctrl = REG_READ(ah, AR_PHY_AGC_CONTROL);
+			agc_supp_cals &= agc_ctrl;
+			agc_ctrl &= ~(AR_PHY_AGC_CONTROL_OFFSET_CAL |
+				      AR_PHY_AGC_CONTROL_FLTR_CAL |
+				      AR_PHY_AGC_CONTROL_PKDET_CAL);
+			REG_WRITE(ah, AR_PHY_AGC_CONTROL, agc_ctrl);
+		} else {
+			if (ah->ah_flags & AH_FASTCC)
+				run_agc_cal = true;
+		}
+	}
+
+	if (ah->enabled_cals & TX_CL_CAL) {
+		if (caldata && test_bit(TXCLCAL_DONE, &caldata->cal_flags))
+			REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL,
+				    AR_PHY_CL_CAL_ENABLE);
+		else {
+			REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL,
+				    AR_PHY_CL_CAL_ENABLE);
+			run_agc_cal = true;
+		}
+	}
+
+	if ((IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan)) ||
+	    !(ah->enabled_cals & TX_IQ_CAL))
+		goto skip_tx_iqcal;
+
+	/* Do Tx IQ Calibration */
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
+		      AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT,
+		      DELPT);
+
+	/*
+	 * For AR9485 or later chips, TxIQ cal runs as part of
+	 * AGC calibration
+	 */
+	if (ah->enabled_cals & TX_IQ_ON_AGC_CAL) {
+		if (caldata && !test_bit(TXIQCAL_DONE, &caldata->cal_flags))
+			REG_SET_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
+		else
+			REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
+		txiqcal_done = run_agc_cal = true;
+	} else if (caldata && !test_bit(TXIQCAL_DONE, &caldata->cal_flags)) {
+		run_agc_cal = true;
+		sep_iq_cal = true;
+	}
+
+skip_tx_iqcal:
+	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
+		ar9003_mci_init_cal_req(ah, &is_reusable);
+
+	if (sep_iq_cal) {
+		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+		udelay(5);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+	}
+
+	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
+		rx_delay = REG_READ(ah, AR_PHY_RX_DELAY);
+		/* Disable BB_active */
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+		udelay(5);
+		REG_WRITE(ah, AR_PHY_RX_DELAY, AR_PHY_RX_DELAY_DELAY);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+	}
+
+	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
+		/* Calibrate the AGC */
+		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
+			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
+			  AR_PHY_AGC_CONTROL_CAL);
+
+		/* Poll for offset calibration complete */
+		status = ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
+				       AR_PHY_AGC_CONTROL_CAL,
+				       0, AH_WAIT_TIMEOUT);
+
+		ar9003_hw_do_manual_peak_cal(ah, chan, run_rtt_cal);
+	}
+
+	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
+		REG_WRITE(ah, AR_PHY_RX_DELAY, rx_delay);
+		udelay(5);
+	}
+
+	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
+		ar9003_mci_init_cal_done(ah);
+
+	if (rtt && !run_rtt_cal) {
+		agc_ctrl |= agc_supp_cals;
+		REG_WRITE(ah, AR_PHY_AGC_CONTROL, agc_ctrl);
+	}
+
+	if (!status) {
+		if (run_rtt_cal)
+			ar9003_hw_rtt_disable(ah);
+
+		ath_dbg(common, CALIBRATE,
+			"offset calibration failed to complete in %d ms; noisy environment?\n",
+			AH_WAIT_TIMEOUT / 1000);
+		return false;
+	}
+
+	if (txiqcal_done)
+		ar9003_hw_tx_iq_cal_post_proc(ah, is_reusable);
+	else if (caldata && test_bit(TXIQCAL_DONE, &caldata->cal_flags))
+		ar9003_hw_tx_iq_cal_reload(ah);
+
+	ar9003_hw_cl_cal_post_proc(ah, is_reusable);
+
+	if (run_rtt_cal && caldata) {
+		if (is_reusable) {
+			if (!ath9k_hw_rfbus_req(ah)) {
+				ath_err(ath9k_hw_common(ah),
+					"Could not stop baseband\n");
+			} else {
+				ar9003_hw_rtt_fill_hist(ah);
+
+				if (test_bit(SW_PKDET_DONE, &caldata->cal_flags))
+					ar9003_hw_rtt_load_hist(ah);
+			}
+
+			ath9k_hw_rfbus_done(ah);
+		}
+
+		ar9003_hw_rtt_disable(ah);
+	}
+
+	/* Revert chainmask to runtime parameters */
+	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+
+	/* Initialize list pointers */
+	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
+
+	INIT_CAL(&ah->iq_caldata);
+	INSERT_CAL(ah, &ah->iq_caldata);
+	ath_dbg(common, CALIBRATE, "enabling IQ Calibration\n");
+
+	/* Initialize current pointer to first element in list */
+	ah->cal_list_curr = ah->cal_list;
+
+	if (ah->cal_list_curr)
+		ath9k_hw_reset_calibration(ah, ah->cal_list_curr);
+
+	if (caldata)
+		caldata->CalValid = 0;
+
+	return true;
+}
+
+static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
+				   struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
@@ -1233,8 +1421,12 @@ void ar9003_hw_attach_calib_ops(struct ath_hw *ah)
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
+	if (AR_SREV_9485(ah) || AR_SREV_9462(ah) || AR_SREV_9565(ah))
+		priv_ops->init_cal = ar9003_hw_init_cal_pcoem;
+	else
+		priv_ops->init_cal = ar9003_hw_init_cal_soc;
+
 	priv_ops->init_cal_settings = ar9003_hw_init_cal_settings;
-	priv_ops->init_cal = ar9003_hw_init_cal;
 	priv_ops->setup_calibration = ar9003_hw_setup_calibration;
 
 	ops->calibrate = ar9003_hw_calibrate;
-- 
1.8.4.2

