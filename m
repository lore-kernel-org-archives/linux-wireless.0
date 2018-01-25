Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51738 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750769AbeAYKTJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 05:19:09 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH v2 2/2] mwifiex: use more_rx_task_flag to avoid USB RX stall
Date: Thu, 25 Jan 2018 15:44:36 +0530
Message-ID: <1516875276-12171-3-git-send-email-gbhat@marvell.com> (sfid-20180125_111914_957054_469A284A)
In-Reply-To: <1516875276-12171-1-git-send-email-gbhat@marvell.com>
References: <1516875276-12171-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shrenik Shikhare <shrenik@marvell.com>

There is a race condition for acquiring rx_proc_lock between
rx worker thread and USB RX data interrupt
(mwifiex_usb_rx_complete):

1. USB receives an RX data interrupt, queues rx_work
2. rx_work empties rx_data_q, tries to acquire rx_proc_lock (to
clear rx_processing flag)
3. While #2 is yet to acquire rx_proc_lock, driver receives
continuous RX data interupts(mwifiex_usb_rx_complete)
3. For each interrupt at #3, driver acquires rx_proc_lock(it gets
the lock since it is in interrupt context), tries to queue
rx_work, but fails to do so since rx_processing is still set(#2)
4. When rx_pending exceeds HIGH_RX_PENDING, driver stops
submitting URBs back to USB subsystem and thus firmware stops
uploading RX data to driver
5. Now finally #2 will acquire rx_proc_lock, but because of #4,
there are no further triggers to schedule rx_work again

The above scenario occurs in some platforms where the RX
processing is comparitively slower. This results in RX stall in
driver, command/TX timeouts in firmware. The above scenario is
introduced after commit c7dbdcb2a4e1
("mwifiex: schedule rx_work on RX interrupt for USB")

To fix this set a new more_rx_task_flag whenever RX data callback
is trying to schedule rx_work but rx_processing is not yet
cleared. This will let the current rx_work(which was waiting for
rx_proc_lock) to loopback and process newly arrived RX packets.

Fixes: c7dbdcb2a4e1 ("mwifiex: schedule rx_work on RX interrupt for USB")
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
v2: added 'Fixes' label in commit message
---
 drivers/net/wireless/marvell/mwifiex/main.c | 10 +++++++++-
 drivers/net/wireless/marvell/mwifiex/main.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 6e6e1a7..ea87c7c 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -163,6 +163,7 @@ void mwifiex_queue_main_work(struct mwifiex_adapter *adapter)
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	if (adapter->mwifiex_processing) {
 		adapter->more_task_flag = true;
+		adapter->more_rx_task_flag = true;
 		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 	} else {
 		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
@@ -177,6 +178,7 @@ void mwifiex_queue_rx_work(struct mwifiex_adapter *adapter)
 
 	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
 	if (adapter->rx_processing) {
+		adapter->more_rx_task_flag = true;
 		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
 	} else {
 		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
@@ -193,13 +195,14 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 
 	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
 	if (adapter->rx_processing || adapter->rx_locked) {
+		adapter->more_rx_task_flag = true;
 		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
 		goto exit_rx_proc;
 	} else {
 		adapter->rx_processing = true;
 		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
 	}
-
+rx_process_start:
 	/* Check for Rx data */
 	while ((skb = skb_dequeue(&adapter->rx_data_q))) {
 		atomic_dec(&adapter->rx_pending);
@@ -221,6 +224,11 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 		}
 	}
 	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
+	if (adapter->more_rx_task_flag) {
+		adapter->more_rx_task_flag = false;
+		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+		goto rx_process_start;
+	}
 	adapter->rx_processing = false;
 	spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 66ba95c..242e05e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -891,6 +891,7 @@ struct mwifiex_adapter {
 	spinlock_t main_proc_lock;
 	u32 mwifiex_processing;
 	u8 more_task_flag;
+	u8 more_rx_task_flag;
 	u16 tx_buf_size;
 	u16 curr_tx_buf_size;
 	/* sdio single port rx aggregation capability */
-- 
1.9.1
