Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:34823
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751071AbaJYTXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:23:39 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 06/10] ath9k_hw: do not run NF and periodic calibration at the same time
Date: Sat, 25 Oct 2014 17:19:31 +0200
Message-Id: <1414250375-74121-6-git-send-email-nbd@openwrt.org> (sfid-20141025_212341_677851_81E9670C)
In-Reply-To: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
References: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It can cause inconsistent calibration results or in some cases turn the
radio deaf.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 29 +++++++++++++--------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 6bfdebf..07994e3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -660,27 +660,26 @@ static void ar9002_hw_olc_temp_compensation(struct ath_hw *ah)
 static int ar9002_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			       u8 rxchainmask, bool longcal)
 {
-	bool iscaldone = true;
 	struct ath9k_cal_list *currCal = ah->cal_list_curr;
-	bool nfcal, nfcal_pending = false;
+	bool nfcal, nfcal_pending = false, percal_pending;
 	int ret;
 
 	nfcal = !!(REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF);
 	if (ah->caldata)
 		nfcal_pending = test_bit(NFCAL_PENDING, &ah->caldata->cal_flags);
 
-	if (currCal && !nfcal &&
-	    (currCal->calState == CAL_RUNNING ||
-	     currCal->calState == CAL_WAITING)) {
-		iscaldone = ar9002_hw_per_calibration(ah, chan,
-						      rxchainmask, currCal);
-		if (iscaldone) {
-			ah->cal_list_curr = currCal = currCal->calNext;
-
-			if (currCal->calState == CAL_WAITING) {
-				iscaldone = false;
-				ath9k_hw_reset_calibration(ah, currCal);
-			}
+	percal_pending = (currCal &&
+			  (currCal->calState == CAL_RUNNING ||
+			   currCal->calState == CAL_WAITING));
+
+	if (percal_pending && !nfcal) {
+		if (!ar9002_hw_per_calibration(ah, chan, rxchainmask, currCal))
+			return 0;
+
+		ah->cal_list_curr = currCal = currCal->calNext;
+		if (currCal->calState == CAL_WAITING) {
+			ath9k_hw_reset_calibration(ah, currCal);
+			return 0;
 		}
 	}
 
@@ -710,7 +709,7 @@ static int ar9002_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 		}
 	}
 
-	return iscaldone;
+	return !percal_pending;
 }
 
 /* Carrier leakage Calibration fix */
-- 
2.1.2

