Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47535 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3IKGO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 02:14:59 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath9k: Fix calibration for AR9462
Date: Wed, 11 Sep 2013 11:40:57 +0530
Message-Id: <1378879859-32290-1-git-send-email-sujith@msujith.org> (sfid-20130911_081502_284885_D15A1BF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

TX IQ calibration is disabled by default for AR9462, this
is done using the initvals (reg 0xa644).

But, to compensate for this, the AR_PHY_RX_DELAY register
should be set to the max allowed value when performing
calibration.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 6988e1d..6001bc0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1019,6 +1019,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	bool is_reusable = true, status = true;
 	bool run_rtt_cal = false, run_agc_cal, sep_iq_cal = false;
 	bool rtt = !!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT);
+	u32 rx_delay = 0;
 	u32 agc_ctrl = 0, agc_supp_cals = AR_PHY_AGC_CONTROL_OFFSET_CAL |
 					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
 					  AR_PHY_AGC_CONTROL_PKDET_CAL;
@@ -1099,6 +1100,15 @@ skip_tx_iqcal:
 		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 	}
 
+	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
+		rx_delay = REG_READ(ah, AR_PHY_RX_DELAY);
+		/* Disable BB_active */
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+		udelay(5);
+		REG_WRITE(ah, AR_PHY_RX_DELAY, AR_PHY_RX_DELAY_DELAY);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+	}
+
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
 		/* Calibrate the AGC */
 		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
@@ -1113,6 +1123,11 @@ skip_tx_iqcal:
 		ar9003_hw_do_manual_peak_cal(ah, chan);
 	}
 
+	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
+		REG_WRITE(ah, AR_PHY_RX_DELAY, rx_delay);
+		udelay(5);
+	}
+
 	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
 		ar9003_mci_init_cal_done(ah);
 
-- 
1.8.4

