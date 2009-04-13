Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54219 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbZDMQbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:31:22 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:31:22 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26568.380639.376006@gargle.gargle.HOWL> (sfid-20090413_183124_439285_90F46853)
Date: Mon, 13 Apr 2009 21:56:48 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/11] ath9k: Cleanup calibration interface
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up the functions dealing with calibration,
using proper return values.
ath9k_hw_per_calibration(), ath9k_hw_calibrate now return bool values
instead of setting error values in the function arguments.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   27 +++++++++++++--------------
 drivers/net/wireless/ath/ath9k/calib.h |    3 +--
 drivers/net/wireless/ath/ath9k/main.c  |   32 ++++++++++----------------------
 3 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 3195c0b..a0661bb 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -238,13 +238,12 @@ static void ath9k_hw_reset_calibration(struct ath_hw *ah,
 	ah->cal_samples = 0;
 }
 
-static void ath9k_hw_per_calibration(struct ath_hw *ah,
+static bool ath9k_hw_per_calibration(struct ath_hw *ah,
 				     struct ath9k_channel *ichan,
 				     u8 rxchainmask,
-				     struct hal_cal_list *currCal,
-				     bool *isCalDone)
+				     struct hal_cal_list *currCal)
 {
-	*isCalDone = false;
+	bool iscaldone = false;
 
 	if (currCal->calState == CAL_RUNNING) {
 		if (!(REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
@@ -263,7 +262,7 @@ static void ath9k_hw_per_calibration(struct ath_hw *ah,
 				currCal->calData->calPostProc(ah, numChains);
 				ichan->CalValid |= currCal->calData->calType;
 				currCal->calState = CAL_DONE;
-				*isCalDone = true;
+				iscaldone = true;
 			} else {
 				ath9k_hw_setup_calibration(ah, currCal);
 			}
@@ -271,6 +270,8 @@ static void ath9k_hw_per_calibration(struct ath_hw *ah,
 	} else if (!(ichan->CalValid & currCal->calData->calType)) {
 		ath9k_hw_reset_calibration(ah, currCal);
 	}
+
+	return iscaldone;
 }
 
 /* Assumes you are talking about the currently configured channel */
@@ -841,23 +842,21 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah)
 }
 
 bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
-			u8 rxchainmask, bool longcal,
-			bool *isCalDone)
+			u8 rxchainmask, bool longcal)
 {
+	bool iscaldone = true;
 	struct hal_cal_list *currCal = ah->cal_list_curr;
 
-	*isCalDone = true;
-
 	if (currCal &&
 	    (currCal->calState == CAL_RUNNING ||
 	     currCal->calState == CAL_WAITING)) {
-		ath9k_hw_per_calibration(ah, chan, rxchainmask, currCal,
-					 isCalDone);
-		if (*isCalDone) {
+		iscaldone = ath9k_hw_per_calibration(ah, chan,
+						     rxchainmask, currCal);
+		if (iscaldone) {
 			ah->cal_list_curr = currCal = currCal->calNext;
 
 			if (currCal->calState == CAL_WAITING) {
-				*isCalDone = false;
+				iscaldone = false;
 				ath9k_hw_reset_calibration(ah, currCal);
 			}
 		}
@@ -877,7 +876,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			chan->channelFlags &= ~CHANNEL_CW_INT;
 	}
 
-	return true;
+	return iscaldone;
 }
 
 static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 1c74bd5..ac71ed9 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -116,8 +116,7 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah);
 s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
 bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
-			u8 rxchainmask, bool longcal,
-			bool *isCalDone);
+			u8 rxchainmask, bool longcal);
 bool ath9k_hw_init_cal(struct ath_hw *ah,
 		       struct ath9k_channel *chan);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9564b73..8bf2bf3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -367,28 +367,16 @@ static void ath_ani_calibrate(unsigned long data)
 
 		/* Perform calibration if necessary */
 		if (longcal || shortcal) {
-			bool iscaldone = false;
-
-			if (ath9k_hw_calibrate(ah, ah->curchan,
-					       sc->rx_chainmask, longcal,
-					       &iscaldone)) {
-				if (longcal)
-					sc->ani.noise_floor =
-						ath9k_hw_getchan_noise(ah,
-							       ah->curchan);
-
-				DPRINTF(sc, ATH_DBG_ANI,
-					"calibrate chan %u/%x nf: %d\n",
-					ah->curchan->channel,
-					ah->curchan->channelFlags,
-					sc->ani.noise_floor);
-			} else {
-				DPRINTF(sc, ATH_DBG_ANY,
-					"calibrate chan %u/%x failed\n",
-					ah->curchan->channel,
-					ah->curchan->channelFlags);
-			}
-			sc->ani.caldone = iscaldone;
+			sc->ani.caldone = ath9k_hw_calibrate(ah, ah->curchan,
+						     sc->rx_chainmask, longcal);
+
+			if (longcal)
+				sc->ani.noise_floor = ath9k_hw_getchan_noise(ah,
+								     ah->curchan);
+
+			DPRINTF(sc, ATH_DBG_ANI," calibrate chan %u/%x nf: %d\n",
+				ah->curchan->channel, ah->curchan->channelFlags,
+				sc->ani.noise_floor);
 		}
 	}
 
-- 
1.6.2.2

