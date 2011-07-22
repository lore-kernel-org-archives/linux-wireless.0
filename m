Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1GVFnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 20/31] ath6kl: Bypass reading irq status based on chk_irq_status_cnt
Date: Fri, 22 Jul 2011 08:41:53 +0300
Message-ID: <1311313324-6766-22-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074326_967670_EBCF80A5)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

This is a regression.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 9904bee..7ab40c1 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -469,7 +469,8 @@ out:
 	ath6kl_dbg(ATH6KL_DBG_IRQ,
 		   "bypassing irq status re-check, forcing done\n");
 
-	*done = true;
+	if (!dev->chk_irq_status_cnt)
+		*done = true;
 
 	ath6kl_dbg(ATH6KL_DBG_IRQ,
 		   "proc_pending_irqs: (done:%d, status=%d\n", *done, status);
-- 
1.7.1

