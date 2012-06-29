Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31100 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2F2GjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 02:39:10 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/5] ath9k_hw: do not load noise floor readings when it is running
Date: Fri, 29 Jun 2012 12:10:06 +0530
Message-ID: <1340952009-12223-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120629_083913_643074_620A4A62)
In-Reply-To: <1340952009-12223-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340952009-12223-1-git-send-email-rmanohar@qca.qualcomm.com>
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

