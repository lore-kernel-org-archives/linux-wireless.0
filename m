Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61092 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0JSObq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 10:31:46 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 07:31:36 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k_hw: Fix divide by zero cases in paprd.
Date: Tue, 19 Oct 2010 20:01:41 +0530
Message-ID: <1287498701-3114-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are not handling all divide by zero cases in paprd.
Add additional checks for divide by zero cases in papard.

This patch has fixes intended for kernel 2.6.36.

Cc: stable@kernel.org
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 7c38229..716db41 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -347,6 +347,10 @@ static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 	    (((Y[6] - Y[3]) * 1 << scale_factor) +
 	     (x_est[6] - x_est[3])) / (x_est[6] - x_est[3]);
 
+	/* prevent division by zero */
+	if (G_fxp == 0)
+		return false;
+
 	Y_intercept =
 	    (G_fxp * (x_est[0] - x_est[3]) +
 	     (1 << scale_factor)) / (1 << scale_factor) + Y[3];
@@ -356,14 +360,12 @@ static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 
 	for (i = 0; i <= 3; i++) {
 		y_est[i] = i * 32;
-
-		/* prevent division by zero */
-		if (G_fxp == 0)
-			return false;
-
 		x_est[i] = ((y_est[i] * 1 << scale_factor) + G_fxp) / G_fxp;
 	}
 
+	if (y_est[max_index] == 0)
+		return false;
+
 	x_est_fxp1_nonlin =
 	    x_est[max_index] - ((1 << scale_factor) * y_est[max_index] +
 				G_fxp) / G_fxp;
@@ -457,6 +459,8 @@ static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 
 	Q_scale_B = find_proper_scale(find_expn(abs(scale_B)), 10);
 	scale_B = scale_B / (1 << Q_scale_B);
+	if (scale_B == 0)
+		return false;
 	Q_beta = find_proper_scale(find_expn(abs(beta_raw)), 10);
 	Q_alpha = find_proper_scale(find_expn(abs(alpha_raw)), 10);
 	beta_raw = beta_raw / (1 << Q_beta);
-- 
1.7.2.1

