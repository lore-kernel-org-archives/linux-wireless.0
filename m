Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39491 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3KSHEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 02:04:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] ath9k: Cleanup IQ calibration for PCOEM chips
Date: Tue, 19 Nov 2013 12:29:32 +0530
Message-Id: <1384844375-6347-1-git-send-email-sujith@msujith.org> (sfid-20131119_080416_154806_113B8FA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since IQ calibration is done as part of AGC calibration for
AR9485 and above, remove the seperate IQ calibration code.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index a18c3dd..aa01272 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1047,7 +1047,7 @@ static bool ar9003_hw_init_cal_pcoem(struct ath_hw *ah,
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	bool txiqcal_done = false;
 	bool is_reusable = true, status = true;
-	bool run_rtt_cal = false, run_agc_cal, sep_iq_cal = false;
+	bool run_rtt_cal = false, run_agc_cal;
 	bool rtt = !!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT);
 	u32 rx_delay = 0;
 	u32 agc_ctrl = 0, agc_supp_cals = AR_PHY_AGC_CONTROL_OFFSET_CAL |
@@ -1119,22 +1119,12 @@ static bool ar9003_hw_init_cal_pcoem(struct ath_hw *ah,
 			REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
 				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
 		txiqcal_done = run_agc_cal = true;
-	} else if (caldata && !test_bit(TXIQCAL_DONE, &caldata->cal_flags)) {
-		run_agc_cal = true;
-		sep_iq_cal = true;
 	}
 
 skip_tx_iqcal:
 	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
 		ar9003_mci_init_cal_req(ah, &is_reusable);
 
-	if (sep_iq_cal) {
-		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
-		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
-		udelay(5);
-		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
-	}
-
 	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
 		rx_delay = REG_READ(ah, AR_PHY_RX_DELAY);
 		/* Disable BB_active */
-- 
1.8.4.2

