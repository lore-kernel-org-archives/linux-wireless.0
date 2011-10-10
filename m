Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1JJFvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 01:51:43 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 05/13] ath9k_hw: Add support to reuse TxIQ cal measurements
Date: Mon, 10 Oct 2011 11:21:10 +0530
Message-ID: <1318225878-7283-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111010_075146_432681_75965C8D)
In-Reply-To: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass an argument to decide whether to reuse the Tx IQ
calibration measurements or not during fast channel change.
This will be later used by MCI support for AR9480.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 026aa5b..6d68566 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -659,7 +659,8 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
 
 static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
 						 u8 num_chains,
-						 struct coeff *coeff)
+						 struct coeff *coeff,
+						 bool is_reusable)
 {
 	int i, im, nmeasurement;
 	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
@@ -726,11 +727,11 @@ static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
 		      AR_PHY_TX_IQCAL_CONTROL_3_IQCORR_EN, 0x1);
 	REG_RMW_FIELD(ah, AR_PHY_RX_IQCAL_CORR_B0,
 		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
+
 	if (caldata)
-		caldata->done_txiqcal_once = true;
+		caldata->done_txiqcal_once = is_reusable;
 
 	return;
-
 }
 
 static bool ar9003_hw_tx_iq_cal_run(struct ath_hw *ah)
@@ -757,7 +758,7 @@ static bool ar9003_hw_tx_iq_cal_run(struct ath_hw *ah)
 	return true;
 }
 
-static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah)
+static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	const u32 txiqcal_status[AR9300_MAX_CHAINS] = {
@@ -846,7 +847,8 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah)
 				coeff.phs_coeff[i][im] -= 128;
 		}
 	}
-	ar9003_hw_tx_iqcal_load_avg_2_passes(ah, num_chains, &coeff);
+	ar9003_hw_tx_iqcal_load_avg_2_passes(ah, num_chains,
+					     &coeff, is_reusable);
 
 	return;
 
@@ -904,6 +906,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	bool txiqcal_done = false;
+	bool is_reusable = true;
 
 	/* Do Tx IQ Calibration */
 	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
@@ -943,7 +946,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	}
 
 	if (txiqcal_done)
-		ar9003_hw_tx_iq_cal_post_proc(ah);
+		ar9003_hw_tx_iq_cal_post_proc(ah, is_reusable);
 	else if (caldata && caldata->done_txiqcal_once)
 		ar9003_hw_tx_iq_cal_reload(ah);
 
-- 
1.7.7

