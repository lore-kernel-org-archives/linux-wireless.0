Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41740 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab1IFLHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 07:07:00 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Avoid taking semaphore in TCMD event report handling func
Date: Tue, 6 Sep 2011 16:35:55 +0530
Message-ID: <1315307155-11878-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20110906_130705_278220_092DB2E8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

ath6kl_tm_rx_report() func takes ar->sem and sends tcmd to the chip
and then waits for wake_up event from ath6kl_tm_rx_report_event() with timeout.

In the current case, When tcmd report is reached to the host,
ath6kl_tm_rx_report_event() func tries to take the same semaphore (ar->sem)
which is already taken in ath6kl_tm_rx_report().

Due to this, ath6kl_tm_rx_report_event() func always fails to update
tcmd report in the local buffer and sends wake_up event to ath6kl_tm_rx_report().
So, the timeout will happen in ath6kl_tm_rx_report() always and
then it will release ar->sem. Now ath6kl_tm_rx_report_event() will
get a chance to update tcmd report in the local buffer.

There is no need of taking ar->sem in ath6kl_tm_rx_report_event(), we can go ahead
and update the local buffer and send wake_up event to ath6kl_tm_rx_report().
In this way, we will get tcmd report (in the user space) in the first time itself.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/testmode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/testmode.c b/drivers/net/wireless/ath/ath6kl/testmode.c
index 381eb66..971ea61 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.c
+++ b/drivers/net/wireless/ath/ath6kl/testmode.c
@@ -43,16 +43,11 @@ static const struct nla_policy ath6kl_tm_policy[ATH6KL_TM_ATTR_MAX + 1] = {
 
 void ath6kl_tm_rx_report_event(struct ath6kl *ar, void *buf, size_t buf_len)
 {
-	if (down_interruptible(&ar->sem))
-		return;
-
 	kfree(ar->tm.rx_report);
 
 	ar->tm.rx_report = kmemdup(buf, buf_len, GFP_KERNEL);
 	ar->tm.rx_report_len = buf_len;
 
-	up(&ar->sem);
-
 	wake_up(&ar->event_wq);
 }
 
-- 
1.7.0.4

