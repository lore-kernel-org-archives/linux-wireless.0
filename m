Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64354 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbcGALHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 07:07:44 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix possible wrong rx_busy time reporting in QCA4019
Date: Fri, 1 Jul 2016 16:37:25 +0530
Message-ID: <1467371245-5426-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160701_130748_318286_A9B18B12)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As hw cycle counters in QCA4019 wraparound independantly in QCA4019
it is possible cycle counter and rx clear counter would wraparound
at the same time. Current logic assumes only one of the counters
would wraparound at anytime. Fix this by moving 'else' part to
another 'if'.

Fixes: 8e100354a98 ("ath10k: fix cycle counter wraparound handling for QCA4019")
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index bd86e7a..7462627 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -198,7 +198,8 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 		case ATH10K_HW_CC_WRAP_SHIFTED_EACH:
 			if (cc < cc_prev)
 				cc_fix = 0x7fffffff;
-			else
+
+			if (rcc < rcc_prev)
 				rcc_fix = 0x7fffffff;
 			break;
 		case ATH10K_HW_CC_WRAP_DISABLED:
-- 
1.9.1

