Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52068 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaAUDwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 22:52:24 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Kai Shi <kaishi@qca.qualcomm.com>
Subject: [PATCH] ath9k: Remove unnecessary check
Date: Tue, 21 Jan 2014 09:16:43 +0530
Message-Id: <1390276003-2367-1-git-send-email-sujith@msujith.org> (sfid-20140121_045247_442545_EAA03EC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit "ath9k: Fix IQ calibration" added a check
to ensure that valid i2_p_q2_a0_d1 values are not discarded.
But since it is masked with 0xfff earlier, the codepath
will not be executed.

The earlier case where all values above 0x800 were considered
invalid is incorrect, since the HW can return valid values
between 0x800 and 0xfff.

Cc: Kai Shi <kaishi@qca.qualcomm.com>
Reported-by: Alex Hacker <hacker@epn.ru>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index a352128..1537f42 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -655,9 +655,6 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	if (i2_m_q2_a0_d1 > 0x800)
 		i2_m_q2_a0_d1 = -((0xfff - i2_m_q2_a0_d1) + 1);
 
-	if (i2_p_q2_a0_d1 > 0x1000)
-		i2_p_q2_a0_d1 = -((0x1fff - i2_p_q2_a0_d1) + 1);
-
 	if (iq_corr_a0_d1 > 0x800)
 		iq_corr_a0_d1 = -((0xfff - iq_corr_a0_d1) + 1);
 
-- 
1.8.5.3

