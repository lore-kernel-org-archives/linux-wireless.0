Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49096 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3KQFO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Nov 2013 00:14:56 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
Date: Sun, 17 Nov 2013 10:40:16 +0530
Message-Id: <1384665016-12022-5-git-send-email-sujith@msujith.org> (sfid-20131117_061525_733176_0E62440F)
In-Reply-To: <1384665016-12022-1-git-send-email-sujith@msujith.org>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since calibration data reuse is not enabled in
SoC chips, simplify the IQ calibration code.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 58eacf1..a18c3dd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1255,22 +1255,19 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 
 	/*
 	 * For AR9485 or later chips, TxIQ cal runs as part of
-	 * AGC calibration
+	 * AGC calibration. Specifically, AR9550 in SoC chips.
 	 */
 	if (ah->enabled_cals & TX_IQ_ON_AGC_CAL) {
-		if (caldata && !test_bit(TXIQCAL_DONE, &caldata->cal_flags))
-			REG_SET_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
-				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
-		else
-			REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
-				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
-		txiqcal_done = run_agc_cal = true;
-	} else if (caldata && !test_bit(TXIQCAL_DONE, &caldata->cal_flags)) {
+		txiqcal_done = true;
 		run_agc_cal = true;
+	} else {
 		sep_iq_cal = true;
+		run_agc_cal = true;
 	}
 
-skip_tx_iqcal:
+	/*
+	 * In the SoC family, this will run for AR9300, AR9331 and AR9340.
+	 */
 	if (sep_iq_cal) {
 		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
 		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
@@ -1278,6 +1275,7 @@ skip_tx_iqcal:
 		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 	}
 
+skip_tx_iqcal:
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
 		/* Calibrate the AGC */
 		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
@@ -1299,8 +1297,6 @@ skip_tx_iqcal:
 
 	if (txiqcal_done)
 		ar9003_hw_tx_iq_cal_post_proc(ah, is_reusable);
-	else if (caldata && test_bit(TXIQCAL_DONE, &caldata->cal_flags))
-		ar9003_hw_tx_iq_cal_reload(ah);
 
 	/* Revert chainmask to runtime parameters */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
-- 
1.8.4.2

