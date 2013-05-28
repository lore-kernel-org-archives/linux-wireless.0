Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40184 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934630Ab3E1QEw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 12:04:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	felixb@qca.qualcomm.com
Subject: [PATCH] ath9k_hw: fix PA predistortion miscalibration
Date: Tue, 28 May 2013 18:04:44 +0200
Message-Id: <1369757084-50141-1-git-send-email-nbd@openwrt.org> (sfid-20130528_180459_650324_50004042)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If any bins from the training data are skipped (i != max_index), the
calculated compensation curve gets distorted, and the signal will be
wildly overamplified. This may be the cause of the reported hardware
damage that was caused by PA predistortion (because of which PAPRD was
disabled by default).

When calculating the x_est, Y, theta values, the use of max_index and i
was reversed. i points to the bin index whereas max_index refers to the
index of the calculated arrays.

Note that PA predistortion is still disabled, it will be re-enabled
after it has been properly validated.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 09c1f9d..6343cc9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -454,6 +454,8 @@ static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 		if (accum_cnt <= thresh_accum_cnt)
 			continue;
 
+		max_index++;
+
 		/* sum(tx amplitude) */
 		accum_tx = ((data_L[i] >> 16) & 0xffff) |
 		    ((data_U[i] & 0x7ff) << 16);
@@ -468,20 +470,21 @@ static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 
 		accum_tx <<= scale_factor;
 		accum_rx <<= scale_factor;
-		x_est[i + 1] = (((accum_tx + accum_cnt) / accum_cnt) + 32) >>
-		    scale_factor;
+		x_est[max_index] =
+			(((accum_tx + accum_cnt) / accum_cnt) + 32) >>
+			scale_factor;
 
-		Y[i + 1] = ((((accum_rx + accum_cnt) / accum_cnt) + 32) >>
+		Y[max_index] =
+			((((accum_rx + accum_cnt) / accum_cnt) + 32) >>
 			    scale_factor) +
-			    (1 << scale_factor) * max_index + 16;
+			(1 << scale_factor) * i + 16;
 
 		if (accum_ang >= (1 << 26))
 			accum_ang -= 1 << 27;
 
-		theta[i + 1] = ((accum_ang * (1 << scale_factor)) + accum_cnt) /
-		    accum_cnt;
-
-		max_index++;
+		theta[max_index] =
+			((accum_ang * (1 << scale_factor)) + accum_cnt) /
+			accum_cnt;
 	}
 
 	/*
-- 
1.8.0.2

