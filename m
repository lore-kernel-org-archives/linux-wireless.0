Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6630 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IONbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 09:31:50 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH v2] ath9k_hw: Fix magnitude/phase coeff correction
Date: Thu, 15 Sep 2011 19:02:25 +0530
Message-ID: <1316093545-8131-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110915_153153_595983_A9B387A6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do the magnitude/phase coeff correction only if the outlier
is detected. Updating wrong magnitude/phase coeff factor
impacts not only tx gain setting but also leads to poor
performance in congested networks. In the clear environment
the impact is very minimal because the outlier happens
very rarely according to the past experiment. It occured
less than once every 1000 calibrations.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 3319a67..695d9d3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -652,8 +652,9 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
 			outlier_idx = max_idx;
 		else
 			outlier_idx = min_idx;
+
+		mp_coeff[outlier_idx] = mp_avg;
 	}
-	mp_coeff[outlier_idx] = mp_avg;
 }
 
 static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
-- 
1.7.6.1

