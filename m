Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:42960
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378Ab3AGIYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 03:24:47 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath9k_hw: Do not enable IQ-CAL for half/quarter rates
Date: Mon,  7 Jan 2013 13:53:46 +0530
Message-Id: <1357547028-22891-1-git-send-email-sujith@msujith.org> (sfid-20130107_092503_106048_903ABAA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

IQ calibration doesn't complete and times out for half/quarter
rates, so skip it correctly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index fa67e84..61caf1c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1013,7 +1013,8 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		}
 	}
 
-	if (!(ah->enabled_cals & TX_IQ_CAL))
+	if ((IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan)) ||
+	    !(ah->enabled_cals & TX_IQ_CAL))
 		goto skip_tx_iqcal;
 
 	/* Do Tx IQ Calibration */
@@ -1040,12 +1041,10 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	if (ath9k_hw_mci_is_enabled(ah) && IS_CHAN_2GHZ(chan) && run_agc_cal)
 		ar9003_mci_init_cal_req(ah, &is_reusable);
 
-	if (!(IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan))) {
-		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
-		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
-		udelay(5);
-		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
-	}
+	txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+	udelay(5);
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 
 skip_tx_iqcal:
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
-- 
1.8.1

