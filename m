Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56425 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030321AbcGKKCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 06:02:52 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 3/4] ath9k_hw: get rid of some duplicate code in calibration init
Date: Mon, 11 Jul 2016 12:02:47 +0200
Message-Id: <20160711100248.68678-3-nbd@nbd.name> (sfid-20160711_120521_110404_5B863016)
In-Reply-To: <20160711100248.68678-1-nbd@nbd.name>
References: <20160711100248.68678-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove a misleading debug message as well

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 54 +++++++++++----------------
 1 file changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index b9ef3d3..7e27a06 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1373,6 +1373,26 @@ static void ar9003_hw_cl_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 	}
 }
 
+static void ar9003_hw_init_cal_common(struct ath_hw *ah)
+{
+	struct ath9k_hw_cal_data *caldata = ah->caldata;
+
+	/* Initialize list pointers */
+	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
+
+	INIT_CAL(&ah->iq_caldata);
+	INSERT_CAL(ah, &ah->iq_caldata);
+
+	/* Initialize current pointer to first element in list */
+	ah->cal_list_curr = ah->cal_list;
+
+	if (ah->cal_list_curr)
+		ath9k_hw_reset_calibration(ah, ah->cal_list_curr);
+
+	if (caldata)
+		caldata->CalValid = 0;
+}
+
 static bool ar9003_hw_init_cal_pcoem(struct ath_hw *ah,
 				     struct ath9k_channel *chan)
 {
@@ -1532,21 +1552,7 @@ skip_tx_iqcal:
 	/* Revert chainmask to runtime parameters */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
 
-	/* Initialize list pointers */
-	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
-
-	INIT_CAL(&ah->iq_caldata);
-	INSERT_CAL(ah, &ah->iq_caldata);
-	ath_dbg(common, CALIBRATE, "enabling IQ Calibration\n");
-
-	/* Initialize current pointer to first element in list */
-	ah->cal_list_curr = ah->cal_list;
-
-	if (ah->cal_list_curr)
-		ath9k_hw_reset_calibration(ah, ah->cal_list_curr);
-
-	if (caldata)
-		caldata->CalValid = 0;
+	ar9003_hw_init_cal_common(ah);
 
 	return true;
 }
@@ -1577,8 +1583,6 @@ static bool do_ar9003_agc_cal(struct ath_hw *ah)
 static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 				   struct ath9k_channel *chan)
 {
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	bool txiqcal_done = false;
 	bool status = true;
 	bool run_agc_cal = false, sep_iq_cal = false;
@@ -1676,21 +1680,7 @@ skip_tx_iqcal:
 	/* Revert chainmask to runtime parameters */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
 
-	/* Initialize list pointers */
-	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
-
-	INIT_CAL(&ah->iq_caldata);
-	INSERT_CAL(ah, &ah->iq_caldata);
-	ath_dbg(common, CALIBRATE, "enabling IQ Calibration\n");
-
-	/* Initialize current pointer to first element in list */
-	ah->cal_list_curr = ah->cal_list;
-
-	if (ah->cal_list_curr)
-		ath9k_hw_reset_calibration(ah, ah->cal_list_curr);
-
-	if (caldata)
-		caldata->CalValid = 0;
+	ar9003_hw_init_cal_common(ah);
 
 	return true;
 }
-- 
2.8.4

