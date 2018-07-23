Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53684 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388017AbeGWRFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 13:05:12 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/9] ath9k: don't run periodic and nf calibation at the same time
Date: Mon, 23 Jul 2018 18:02:53 +0200
Message-Id: <20180723160300.58024-2-nbd@nbd.name> (sfid-20180723_180333_176556_E217C3AC)
In-Reply-To: <20180723160300.58024-1-nbd@nbd.name>
References: <20180723160300.58024-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The checks already prevents periodic cal from being started while noise
floor calibration runs. It is missing checks for the other way around.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 50fcd343c41a..fd9db8ca99d7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -676,10 +676,10 @@ static int ar9002_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			return 0;
 
 		ah->cal_list_curr = currCal = currCal->calNext;
-		if (currCal->calState == CAL_WAITING) {
+		if (currCal->calState == CAL_WAITING)
 			ath9k_hw_reset_calibration(ah, currCal);
-			return 0;
-		}
+
+		return 0;
 	}
 
 	/* Do NF cal only at longer intervals */
-- 
2.17.0
