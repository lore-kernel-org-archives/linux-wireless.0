Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53209 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbIPAIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 20:08:24 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Fix CCK rate definitions.
Date: Tue, 15 Sep 2015 17:08:18 -0700
Message-Id: <1442362098-24859-1-git-send-email-greearb@candelatech.com> (sfid-20150916_020827_559309_04D3FC21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The old values did NOT match what is found in 10.1.467
firmware.  I figure it is likely it is wrong for the others
as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/hw.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 4c5eee4..710ca32 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -202,13 +202,13 @@ enum ath10k_hw_rate_ofdm {
 };
 
 enum ath10k_hw_rate_cck {
-	ATH10K_HW_RATE_CCK_LP_11M = 0,
-	ATH10K_HW_RATE_CCK_LP_5_5M,
-	ATH10K_HW_RATE_CCK_LP_2M,
-	ATH10K_HW_RATE_CCK_LP_1M,
-	ATH10K_HW_RATE_CCK_SP_11M,
-	ATH10K_HW_RATE_CCK_SP_5_5M,
-	ATH10K_HW_RATE_CCK_SP_2M,
+	ATH10K_HW_RATE_CCK_LP_11M = 0x40,
+	ATH10K_HW_RATE_CCK_LP_5_5M = 0x41,
+	ATH10K_HW_RATE_CCK_LP_2M = 0x42,
+	ATH10K_HW_RATE_CCK_LP_1M = 0x43,
+	ATH10K_HW_RATE_CCK_SP_11M = ATH10K_HW_RATE_CCK_LP_11M | 0x4,
+	ATH10K_HW_RATE_CCK_SP_5_5M = ATH10K_HW_RATE_CCK_LP_5_5M | 0x4,
+	ATH10K_HW_RATE_CCK_SP_2M = ATH10K_HW_RATE_CCK_LP_2M | 0x4,
 };
 
 /* Target specific defines for MAIN firmware */
-- 
2.4.3

