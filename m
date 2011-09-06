Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23435 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1IFOsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 10:48:19 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k_hw: Fix magnitude/phase coeff correction
Date: Tue, 6 Sep 2011 20:18:50 +0530
Message-ID: <1315320530-2733-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110906_164823_252296_E81D32B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do the magnitude/phase coeff correction only if the outlier
is detected.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index fa35a02..ee3a8a2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -643,8 +643,9 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
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

