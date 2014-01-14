Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54694 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaANIAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 03:00:37 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: Fix IQ calibration
Date: Tue, 14 Jan 2014 13:25:17 +0530
Message-Id: <1389686117-9014-1-git-send-email-sujith@msujith.org> (sfid-20140114_090042_515097_99293E75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch fixes a bug in the TX IQ calibration post
processing routine because of which the driver disables
TX IQ correction even though the calibration results
are valid. This fix is applicable for all chips in the
AR9003 family.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 8c145cd..4eb35aa 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -655,8 +655,8 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	if (i2_m_q2_a0_d1 > 0x800)
 		i2_m_q2_a0_d1 = -((0xfff - i2_m_q2_a0_d1) + 1);
 
-	if (i2_p_q2_a0_d1 > 0x800)
-		i2_p_q2_a0_d1 = -((0xfff - i2_p_q2_a0_d1) + 1);
+	if (i2_p_q2_a0_d1 > 0x1000)
+		i2_p_q2_a0_d1 = -((0x1fff - i2_p_q2_a0_d1) + 1);
 
 	if (iq_corr_a0_d1 > 0x800)
 		iq_corr_a0_d1 = -((0xfff - iq_corr_a0_d1) + 1);
@@ -700,6 +700,19 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 		return false;
 	}
 
+	if ((i2_p_q2_a0_d0 < 1024) || (i2_p_q2_a0_d0 > 2047) ||
+            (i2_p_q2_a1_d0 < 0) || (i2_p_q2_a1_d1 < 0) ||
+            (i2_p_q2_a0_d0 <= i2_m_q2_a0_d0) ||
+            (i2_p_q2_a0_d0 <= iq_corr_a0_d0) ||
+            (i2_p_q2_a0_d1 <= i2_m_q2_a0_d1) ||
+            (i2_p_q2_a0_d1 <= iq_corr_a0_d1) ||
+            (i2_p_q2_a1_d0 <= i2_m_q2_a1_d0) ||
+            (i2_p_q2_a1_d0 <= iq_corr_a1_d0) ||
+            (i2_p_q2_a1_d1 <= i2_m_q2_a1_d1) ||
+            (i2_p_q2_a1_d1 <= iq_corr_a1_d1)) {
+		return false;
+	}
+
 	mag_a0_d0 = (i2_m_q2_a0_d0 * res_scale) / i2_p_q2_a0_d0;
 	phs_a0_d0 = (iq_corr_a0_d0 * res_scale) / i2_p_q2_a0_d0;
 
-- 
1.8.5.2

