Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27307 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2F3GHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 02:07:41 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 2/5] ath9k_hw: do not load noise floor readings when it is running
Date: Sat, 30 Jun 2012 11:38:46 +0530
Message-ID: <1341036529-10823-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120630_080743_629778_184E4979)
In-Reply-To: <1341036529-10823-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1341036529-10823-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Noise floor calibration is performed on longcal interval and
the reading will be updated in history buffer. On rare occasions,
the previous noisefloor calibration might not be completed within
the period and trying to load nf reading will be failed. In such
situation, postpone the nf cabliration to next cycle to give
enough time to complete the calibration. This was already taken
care for ar9002 chips.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index d7deb8c..84b558d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -159,14 +159,11 @@ static bool ar9003_hw_calibrate(struct ath_hw *ah,
 		}
 	}
 
-	/* Do NF cal only at longer intervals */
-	if (longcal) {
-		/*
-		 * Get the value from the previous NF cal and update
-		 * history buffer.
-		 */
-		ath9k_hw_getnf(ah, chan);
-
+	/*
+	 * Do NF cal only at longer intervals. Get the value from
+	 * the previous NF cal and update history buffer.
+	 */
+	if (longcal && ath9k_hw_getnf(ah, chan)) {
 		/*
 		 * Load the NF from history buffer of the current channel.
 		 * NF is slow time-variant, so it is OK to use a historical
-- 
1.7.11.1

