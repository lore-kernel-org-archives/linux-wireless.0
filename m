Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:49130
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751497AbaJRRCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 13:02:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 06/10] ath9k_hw: do not run NF and periodic calibration at the same time
Date: Sat, 18 Oct 2014 19:02:08 +0200
Message-Id: <1413651732-69783-6-git-send-email-nbd@openwrt.org> (sfid-20141018_190239_647496_5C8CEA07)
In-Reply-To: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It can cause inconsistent calibration results or in some cases turn the
radio deaf.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 6bfdebf..77388fb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -660,7 +660,6 @@ static void ar9002_hw_olc_temp_compensation(struct ath_hw *ah)
 static int ar9002_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			       u8 rxchainmask, bool longcal)
 {
-	bool iscaldone = true;
 	struct ath9k_cal_list *currCal = ah->cal_list_curr;
 	bool nfcal, nfcal_pending = false;
 	int ret;
@@ -672,15 +671,13 @@ static int ar9002_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (currCal && !nfcal &&
 	    (currCal->calState == CAL_RUNNING ||
 	     currCal->calState == CAL_WAITING)) {
-		iscaldone = ar9002_hw_per_calibration(ah, chan,
-						      rxchainmask, currCal);
-		if (iscaldone) {
-			ah->cal_list_curr = currCal = currCal->calNext;
-
-			if (currCal->calState == CAL_WAITING) {
-				iscaldone = false;
-				ath9k_hw_reset_calibration(ah, currCal);
-			}
+		if (!ar9002_hw_per_calibration(ah, chan, rxchainmask, currCal))
+			return 0;
+
+		ah->cal_list_curr = currCal = currCal->calNext;
+		if (currCal->calState == CAL_WAITING) {
+			ath9k_hw_reset_calibration(ah, currCal);
+			return 0;
 		}
 	}
 
@@ -710,7 +707,7 @@ static int ar9002_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 		}
 	}
 
-	return iscaldone;
+	return 1;
 }
 
 /* Carrier leakage Calibration fix */
-- 
2.0.4

