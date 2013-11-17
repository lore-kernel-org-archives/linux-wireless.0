Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47883 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3KQFO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Nov 2013 00:14:56 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] ath9k: Fix Carrier Leak calibration for SoC chips
Date: Sun, 17 Nov 2013 10:40:15 +0530
Message-Id: <1384665016-12022-4-git-send-email-sujith@msujith.org> (sfid-20131117_061528_107828_1CF976EE)
In-Reply-To: <1384665016-12022-1-git-send-email-sujith@msujith.org>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

CL calibration is applicable for all chips and the
enable/disable knob comes via the INI file. For PCOEM
chips, the calibration data is reused when Fast Channel Change
is used. Caldata reuse is not enabled for SoC chips, so remove
the CL post processing code.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 27 ++-------------------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |  9 +++++----
 2 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 347b002..58eacf1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1236,20 +1236,13 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 	bool txiqcal_done = false;
 	bool is_reusable = true, status = true;
 	bool run_agc_cal = false, sep_iq_cal = false;
-	u32 rx_delay = 0;
 
 	/* Use chip chainmask only for calibration */
 	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
 
 	if (ah->enabled_cals & TX_CL_CAL) {
-		if (caldata && test_bit(TXCLCAL_DONE, &caldata->cal_flags))
-			REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL,
-				    AR_PHY_CL_CAL_ENABLE);
-		else {
-			REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL,
-				    AR_PHY_CL_CAL_ENABLE);
-			run_agc_cal = true;
-		}
+		REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
+		run_agc_cal = true;
 	}
 
 	if (IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan))
@@ -1285,15 +1278,6 @@ skip_tx_iqcal:
 		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 	}
 
-	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
-		rx_delay = REG_READ(ah, AR_PHY_RX_DELAY);
-		/* Disable BB_active */
-		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
-		udelay(5);
-		REG_WRITE(ah, AR_PHY_RX_DELAY, AR_PHY_RX_DELAY_DELAY);
-		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
-	}
-
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
 		/* Calibrate the AGC */
 		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
@@ -1306,11 +1290,6 @@ skip_tx_iqcal:
 				       0, AH_WAIT_TIMEOUT);
 	}
 
-	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
-		REG_WRITE(ah, AR_PHY_RX_DELAY, rx_delay);
-		udelay(5);
-	}
-
 	if (!status) {
 		ath_dbg(common, CALIBRATE,
 			"offset calibration failed to complete in %d ms; noisy environment?\n",
@@ -1323,8 +1302,6 @@ skip_tx_iqcal:
 	else if (caldata && test_bit(TXIQCAL_DONE, &caldata->cal_flags))
 		ar9003_hw_tx_iq_cal_reload(ah);
 
-	ar9003_hw_cl_cal_post_proc(ah, is_reusable);
-
 	/* Revert chainmask to runtime parameters */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index d39b79f..39b71b3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -641,11 +641,12 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
 		else
 			ah->enabled_cals &= ~TX_IQ_CAL;
 
-		if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE)
-			ah->enabled_cals |= TX_CL_CAL;
-		else
-			ah->enabled_cals &= ~TX_CL_CAL;
 	}
+
+	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE)
+		ah->enabled_cals |= TX_CL_CAL;
+	else
+		ah->enabled_cals &= ~TX_CL_CAL;
 }
 
 static void ar9003_hw_prog_ini(struct ath_hw *ah,
-- 
1.8.4.2

