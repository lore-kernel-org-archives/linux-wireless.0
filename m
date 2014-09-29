Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19795 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbaI2KpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 06:45:00 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <cluo@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv1 RESEND 2/3] mwifiex: do not decrement rx_pending count twice
Date: Mon, 29 Sep 2014 21:44:14 +0530
Message-ID: <1412007255-4625-2-git-send-email-patila@marvell.com> (sfid-20140929_124506_387854_225B5091)
In-Reply-To: <1412007255-4625-1-git-send-email-patila@marvell.com>
References: <1412007255-4625-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an issue with rx processing function where we were
decrementing rx_pending count twice.

Patch also queues correct main_work item when rx_pending count reaches
low watermark.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index be52189..d5070c4 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -130,7 +130,6 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 {
 	unsigned long flags;
 	struct sk_buff *skb;
-	bool delay_main_work = adapter->delay_main_work;
 
 	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
 	if (adapter->rx_processing || adapter->rx_locked) {
@@ -145,10 +144,9 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 	while ((skb = skb_dequeue(&adapter->rx_data_q))) {
 		atomic_dec(&adapter->rx_pending);
 		if (adapter->delay_main_work &&
-		    (atomic_dec_return(&adapter->rx_pending) <
-		     LOW_RX_PENDING)) {
+		    (atomic_read(&adapter->rx_pending) < LOW_RX_PENDING)) {
 			adapter->delay_main_work = false;
-			queue_work(adapter->rx_workqueue, &adapter->rx_work);
+			queue_work(adapter->workqueue, &adapter->main_work);
 		}
 		mwifiex_handle_rx_packet(adapter, skb);
 	}
@@ -156,8 +154,6 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 	adapter->rx_processing = false;
 	spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
 
-	if (delay_main_work)
-		queue_work(adapter->workqueue, &adapter->main_work);
 exit_rx_proc:
 	return 0;
 }
-- 
1.8.1.4

