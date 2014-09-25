Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53480 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbaIYGSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 02:18:30 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 3/3] mwifiex: remove unnecessary rx_q lock
Date: Thu, 25 Sep 2014 17:16:42 +0530
Message-ID: <1411645602-18980-3-git-send-email-patila@marvell.com> (sfid-20140925_081834_852489_89AD1FF4)
In-Reply-To: <1411645602-18980-1-git-send-email-patila@marvell.com>
References: <1411645602-18980-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SKB lists have their own lock. So this lock is not needed.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 1 -
 drivers/net/wireless/mwifiex/main.h | 2 --
 drivers/net/wireless/mwifiex/pcie.c | 4 ----
 drivers/net/wireless/mwifiex/sdio.c | 3 ---
 4 files changed, 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index f7c97cf..580aa45 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -447,7 +447,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	spin_lock_init(&adapter->cmd_free_q_lock);
 	spin_lock_init(&adapter->cmd_pending_q_lock);
 	spin_lock_init(&adapter->scan_pending_q_lock);
-	spin_lock_init(&adapter->rx_q_lock);
 	spin_lock_init(&adapter->rx_proc_lock);
 
 	skb_queue_head_init(&adapter->usb_rx_data_q);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1a99999..b5dc78b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -763,8 +763,6 @@ struct mwifiex_adapter {
 	struct list_head scan_pending_q;
 	/* spin lock for scan_pending_q */
 	spinlock_t scan_pending_q_lock;
-	/* spin lock for RX queue */
-	spinlock_t rx_q_lock;
 	/* spin lock for RX processing routine */
 	spinlock_t rx_proc_lock;
 	struct sk_buff_head usb_rx_data_q;
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 1504b16..7e8d9b0 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1233,7 +1233,6 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 	struct sk_buff *skb_tmp = NULL;
 	struct mwifiex_pcie_buf_desc *desc;
 	struct mwifiex_pfu_buf_desc *desc2;
-	unsigned long flags;
 
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
 		mwifiex_pm_wakeup_card(adapter);
@@ -1285,10 +1284,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 				card->rxbd_rdptr, wrptr, rx_len);
 			skb_pull(skb_data, INTF_HEADER_LEN);
 			if (adapter->rx_work_enabled) {
-				spin_lock_irqsave(&adapter->rx_q_lock, flags);
 				skb_queue_tail(&adapter->rx_data_q, skb_data);
-				spin_unlock_irqrestore(&adapter->rx_q_lock,
-						       flags);
 				adapter->data_received = true;
 				atomic_inc(&adapter->rx_pending);
 			} else {
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index ea8fc58..db9e4e3 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1039,7 +1039,6 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 				    struct sk_buff *skb, u32 upld_typ)
 {
 	u8 *cmd_buf;
-	unsigned long flags;
 	__le16 *curr_ptr = (__le16 *)skb->data;
 	u16 pkt_len = le16_to_cpu(*curr_ptr);
 
@@ -1050,9 +1049,7 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 	case MWIFIEX_TYPE_DATA:
 		dev_dbg(adapter->dev, "info: --- Rx: Data packet ---\n");
 		if (adapter->rx_work_enabled) {
-			spin_lock_irqsave(&adapter->rx_q_lock, flags);
 			skb_queue_tail(&adapter->rx_data_q, skb);
-			spin_unlock_irqrestore(&adapter->rx_q_lock, flags);
 			adapter->data_received = true;
 			atomic_inc(&adapter->rx_pending);
 		} else {
-- 
1.8.1.4

