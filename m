Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37291 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaANIQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 03:16:32 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: Fix possible overflow condition
Date: Tue, 14 Jan 2014 13:41:17 +0530
Message-Id: <1389687077-7551-1-git-send-email-sujith@msujith.org> (sfid-20140114_091635_780511_CDF70065)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Prevent a possible overflow condition which results in occasional
bad IQ coefficients and EVM numbers.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 4eb35aa..a352128 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -565,7 +565,7 @@ static bool ar9003_hw_solve_iq_cal(struct ath_hw *ah,
 	const s32 result_shift = 1 << 15;
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	f2 = (f1 * f1 + f3 * f3) / result_shift;
+	f2 = ((f1 >> 3) * (f1 >> 3) + (f3 >> 3) * (f3 >> 3)) >> 9;
 
 	if (!f2) {
 		ath_dbg(common, CALIBRATE, "Divide by 0\n");
-- 
1.8.5.2

