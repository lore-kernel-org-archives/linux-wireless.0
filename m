Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56427 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030415AbcGKKC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 06:02:56 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/4] ath9k_hw: simplify ar9003_hw_per_calibration
Date: Mon, 11 Jul 2016 12:02:46 +0200
Message-Id: <20160711100248.68678-2-nbd@nbd.name> (sfid-20160711_120326_540491_722962E8)
In-Reply-To: <20160711100248.68678-1-nbd@nbd.name>
References: <20160711100248.68678-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduce indentation, use a variable to save a few pointer dereferences

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 53 +++++++++++++--------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 518e649..b9ef3d3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -75,50 +75,49 @@ static bool ar9003_hw_per_calibration(struct ath_hw *ah,
 				      struct ath9k_cal_list *currCal)
 {
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
-	/* Cal is assumed not done until explicitly set below */
-	bool iscaldone = false;
+	const struct ath9k_percal_data *cur_caldata = currCal->calData;
 
 	/* Calibration in progress. */
 	if (currCal->calState == CAL_RUNNING) {
 		/* Check to see if it has finished. */
-		if (!(REG_READ(ah, AR_PHY_TIMING4) & AR_PHY_TIMING4_DO_CAL)) {
+		if (REG_READ(ah, AR_PHY_TIMING4) & AR_PHY_TIMING4_DO_CAL)
+			return false;
+
+		/*
+		* Accumulate cal measures for active chains
+		*/
+		cur_caldata->calCollect(ah);
+		ah->cal_samples++;
+
+		if (ah->cal_samples >= cur_caldata->calNumSamples) {
+			unsigned int i, numChains = 0;
+			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+				if (rxchainmask & (1 << i))
+					numChains++;
+			}
+
 			/*
-			* Accumulate cal measures for active chains
+			* Process accumulated data
 			*/
-			currCal->calData->calCollect(ah);
-			ah->cal_samples++;
-
-			if (ah->cal_samples >=
-			    currCal->calData->calNumSamples) {
-				unsigned int i, numChains = 0;
-				for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-					if (rxchainmask & (1 << i))
-						numChains++;
-				}
+			cur_caldata->calPostProc(ah, numChains);
 
-				/*
-				* Process accumulated data
-				*/
-				currCal->calData->calPostProc(ah, numChains);
-
-				/* Calibration has finished. */
-				caldata->CalValid |= currCal->calData->calType;
-				currCal->calState = CAL_DONE;
-				iscaldone = true;
-			} else {
+			/* Calibration has finished. */
+			caldata->CalValid |= cur_caldata->calType;
+			currCal->calState = CAL_DONE;
+			return true;
+		} else {
 			/*
 			 * Set-up collection of another sub-sample until we
 			 * get desired number
 			 */
 			ar9003_hw_setup_calibration(ah, currCal);
-			}
 		}
-	} else if (!(caldata->CalValid & currCal->calData->calType)) {
+	} else if (!(caldata->CalValid & cur_caldata->calType)) {
 		/* If current cal is marked invalid in channel, kick it off */
 		ath9k_hw_reset_calibration(ah, currCal);
 	}
 
-	return iscaldone;
+	return false;
 }
 
 static int ar9003_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
-- 
2.8.4

