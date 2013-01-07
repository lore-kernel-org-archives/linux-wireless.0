Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:56739
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352Ab3AGIYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 03:24:47 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k_hw: Fix MCI init for AGC calibration
Date: Mon,  7 Jan 2013 13:53:47 +0530
Message-Id: <1357547028-22891-2-git-send-email-sujith@msujith.org> (sfid-20130107_092505_323910_B417BD80)
In-Reply-To: <1357547028-22891-1-git-send-email-sujith@msujith.org>
References: <1357547028-22891-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When AGC calibration is to be done, a GPM message with the
payload, MCI_GPM_WLAN_CAL_REQ has to be sent. Currently this falls
within the IQ-CAL code block which is incorrect. Fix this by using
a separate variable to decide when IQ-CAL is to be done separately
and call ar9003_mci_init_cal_req correctly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 61caf1c..15f9b89 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -967,7 +967,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	bool txiqcal_done = false, txclcal_done = false;
 	bool is_reusable = true, status = true;
-	bool run_rtt_cal = false, run_agc_cal;
+	bool run_rtt_cal = false, run_agc_cal, sep_iq_cal = false;
 	bool rtt = !!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT);
 	u32 agc_ctrl = 0, agc_supp_cals = AR_PHY_AGC_CONTROL_OFFSET_CAL |
 					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
@@ -1034,19 +1034,22 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
 				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
 		txiqcal_done = run_agc_cal = true;
-		goto skip_tx_iqcal;
-	} else if (caldata && !caldata->done_txiqcal_once)
+	} else if (caldata && !caldata->done_txiqcal_once) {
 		run_agc_cal = true;
+		sep_iq_cal = true;
+	}
 
+skip_tx_iqcal:
 	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
 		ar9003_mci_init_cal_req(ah, &is_reusable);
 
-	txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
-	udelay(5);
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+	if (sep_iq_cal) {
+		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+		udelay(5);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+	}
 
-skip_tx_iqcal:
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
 		/* Calibrate the AGC */
 		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
-- 
1.8.1

