Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47034 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753712AbaILJLa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 05:11:30 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 15/16] mwifiex: add rx workqueue support
Date: Fri, 12 Sep 2014 20:08:59 +0530
Message-ID: <1410532740-3173-16-git-send-email-patila@marvell.com> (sfid-20140912_111324_482547_864E23C8)
In-Reply-To: <1410532740-3173-1-git-send-email-patila@marvell.com>
References: <1410532740-3173-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds RX work queue support to mwifiex.
Packets received are queued to internal queue which are then
processed by scheduling a work item for RX process.

RX work is enabled only on SMP systems.

Reviewed-by: James Cameron <quozl@laptop.org>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 14 +++++
 drivers/net/wireless/mwifiex/init.c          | 19 ++++++
 drivers/net/wireless/mwifiex/main.c          | 91 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h          | 14 +++++
 drivers/net/wireless/mwifiex/pcie.c          | 12 +++-
 drivers/net/wireless/mwifiex/sdio.c          | 11 +++-
 6 files changed, 159 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 06a2c21..4005707 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -183,6 +183,15 @@ mwifiex_del_rx_reorder_entry(struct mwifiex_private *priv,
 	if (!tbl)
 		return;
 
+	spin_lock_irqsave(&priv->adapter->rx_proc_lock, flags);
+	priv->adapter->rx_locked = true;
+	if (priv->adapter->rx_processing) {
+		spin_unlock_irqrestore(&priv->adapter->rx_proc_lock, flags);
+		flush_workqueue(priv->adapter->rx_workqueue);
+	} else {
+		spin_unlock_irqrestore(&priv->adapter->rx_proc_lock, flags);
+	}
+
 	start_win = (tbl->start_win + tbl->win_size) & (MAX_TID_VALUE - 1);
 	mwifiex_11n_dispatch_pkt_until_start_win(priv, tbl, start_win);
 
@@ -194,6 +203,11 @@ mwifiex_del_rx_reorder_entry(struct mwifiex_private *priv,
 
 	kfree(tbl->rx_reorder_ptr);
 	kfree(tbl);
+
+	spin_lock_irqsave(&priv->adapter->rx_proc_lock, flags);
+	priv->adapter->rx_locked = false;
+	spin_unlock_irqrestore(&priv->adapter->rx_proc_lock, flags);
+
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index cd9baad..f7c97cf 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -447,8 +447,11 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	spin_lock_init(&adapter->cmd_free_q_lock);
 	spin_lock_init(&adapter->cmd_pending_q_lock);
 	spin_lock_init(&adapter->scan_pending_q_lock);
+	spin_lock_init(&adapter->rx_q_lock);
+	spin_lock_init(&adapter->rx_proc_lock);
 
 	skb_queue_head_init(&adapter->usb_rx_data_q);
+	skb_queue_head_init(&adapter->rx_data_q);
 
 	for (i = 0; i < adapter->priv_num; ++i) {
 		INIT_LIST_HEAD(&adapter->bss_prio_tbl[i].bss_prio_head);
@@ -614,6 +617,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 	int ret = -EINPROGRESS;
 	struct mwifiex_private *priv;
 	s32 i;
+	unsigned long flags;
 	struct sk_buff *skb;
 
 	/* mwifiex already shutdown */
@@ -648,6 +652,21 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 		}
 	}
 
+	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
+
+	while ((skb = skb_dequeue(&adapter->rx_data_q))) {
+		struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+
+		atomic_dec(&adapter->rx_pending);
+		priv = adapter->priv[rx_info->bss_num];
+		if (priv)
+			priv->stats.rx_dropped++;
+
+		dev_kfree_skb_any(skb);
+	}
+
+	spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+
 	spin_lock(&adapter->mwifiex_lock);
 
 	if (adapter->if_ops.data_complete) {
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index f139386..b522f7c 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -126,6 +126,42 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
+{
+	unsigned long flags;
+	struct sk_buff *skb;
+	bool delay_main_work = adapter->delay_main_work;
+
+	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
+	if (adapter->rx_processing || adapter->rx_locked) {
+		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+		goto exit_rx_proc;
+	} else {
+		adapter->rx_processing = true;
+		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+	}
+
+	/* Check for Rx data */
+	while ((skb = skb_dequeue(&adapter->rx_data_q))) {
+		atomic_dec(&adapter->rx_pending);
+		if (adapter->delay_main_work &&
+		    (atomic_dec_return(&adapter->rx_pending) <
+		     LOW_RX_PENDING)) {
+			adapter->delay_main_work = false;
+			queue_work(adapter->rx_workqueue, &adapter->rx_work);
+		}
+		mwifiex_handle_rx_packet(adapter, skb);
+	}
+	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
+	adapter->rx_processing = false;
+	spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+
+	if (delay_main_work)
+		queue_work(adapter->workqueue, &adapter->main_work);
+exit_rx_proc:
+	return 0;
+}
+
 /*
  * The main process.
  *
@@ -163,6 +199,19 @@ process_start:
 		    (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY))
 			break;
 
+		/* If we process interrupts first, it would increase RX pending
+		 * even further. Avoid this by checking if rx_pending has
+		 * crossed high threshold and schedule rx work queue
+		 * and then process interrupts
+		 */
+		if (atomic_read(&adapter->rx_pending) >= HIGH_RX_PENDING) {
+			adapter->delay_main_work = true;
+			if (!adapter->rx_processing)
+				queue_work(adapter->rx_workqueue,
+					   &adapter->rx_work);
+			break;
+		}
+
 		/* Handle pending interrupt if any */
 		if (adapter->int_status) {
 			if (adapter->hs_activated)
@@ -171,6 +220,9 @@ process_start:
 				adapter->if_ops.process_int_status(adapter);
 		}
 
+		if (adapter->rx_work_enabled && adapter->data_received)
+			queue_work(adapter->rx_workqueue, &adapter->rx_work);
+
 		/* Need to wake up the card ? */
 		if ((adapter->ps_state == PS_STATE_SLEEP) &&
 		    (adapter->pm_wakeup_card_req &&
@@ -183,6 +235,7 @@ process_start:
 		}
 
 		if (IS_CARD_RX_RCVD(adapter)) {
+			adapter->data_received = false;
 			adapter->pm_wakeup_fw_try = false;
 			if (adapter->ps_state == PS_STATE_SLEEP)
 				adapter->ps_state = PS_STATE_AWAKE;
@@ -318,6 +371,12 @@ static void mwifiex_terminate_workqueue(struct mwifiex_adapter *adapter)
 	flush_workqueue(adapter->workqueue);
 	destroy_workqueue(adapter->workqueue);
 	adapter->workqueue = NULL;
+
+	if (adapter->rx_workqueue) {
+		flush_workqueue(adapter->rx_workqueue);
+		destroy_workqueue(adapter->rx_workqueue);
+		adapter->rx_workqueue = NULL;
+	}
 }
 
 /*
@@ -732,6 +791,21 @@ int is_command_pending(struct mwifiex_adapter *adapter)
 }
 
 /*
+ * This is the RX work queue function.
+ *
+ * It handles the RX operations.
+ */
+static void mwifiex_rx_work_queue(struct work_struct *work)
+{
+	struct mwifiex_adapter *adapter =
+		container_of(work, struct mwifiex_adapter, rx_work);
+
+	if (adapter->surprise_removed)
+		return;
+	mwifiex_process_rx(adapter);
+}
+
+/*
  * This is the main work queue function.
  *
  * It handles the main process, which in turn handles the complete
@@ -787,6 +861,11 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	adapter->cmd_wait_q.status = 0;
 	adapter->scan_wait_q_woken = false;
 
+	if (num_possible_cpus() > 1) {
+		adapter->rx_work_enabled = true;
+		pr_notice("rx work enabled, cpus %d\n", num_possible_cpus());
+	}
+
 	adapter->workqueue =
 		alloc_workqueue("MWIFIEX_WORK_QUEUE",
 				WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
@@ -794,6 +873,18 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		goto err_kmalloc;
 
 	INIT_WORK(&adapter->main_work, mwifiex_main_work_queue);
+
+	if (adapter->rx_work_enabled) {
+		adapter->rx_workqueue = alloc_workqueue("MWIFIEX_RX_WORK_QUEUE",
+							WQ_HIGHPRI |
+							WQ_MEM_RECLAIM |
+							WQ_UNBOUND, 1);
+		if (!adapter->rx_workqueue)
+			goto err_kmalloc;
+
+		INIT_WORK(&adapter->rx_work, mwifiex_rx_work_queue);
+	}
+
 	if (adapter->if_ops.iface_work)
 		INIT_WORK(&adapter->iface_work, adapter->if_ops.iface_work);
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e9cd4ab..1a99999 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -58,6 +58,9 @@ enum {
 #define MAX_TX_PENDING      100
 #define LOW_TX_PENDING      80
 
+#define HIGH_RX_PENDING     50
+#define LOW_RX_PENDING      20
+
 #define MWIFIEX_UPLD_SIZE               (2312)
 
 #define MAX_EVENT_SIZE                  2048
@@ -714,6 +717,12 @@ struct mwifiex_adapter {
 	atomic_t cmd_pending;
 	struct workqueue_struct *workqueue;
 	struct work_struct main_work;
+	struct workqueue_struct *rx_workqueue;
+	struct work_struct rx_work;
+	bool rx_work_enabled;
+	bool rx_processing;
+	bool delay_main_work;
+	bool rx_locked;
 	struct mwifiex_bss_prio_tbl bss_prio_tbl[MWIFIEX_MAX_BSS_NUM];
 	/* spin lock for init/shutdown */
 	spinlock_t mwifiex_lock;
@@ -754,6 +763,10 @@ struct mwifiex_adapter {
 	struct list_head scan_pending_q;
 	/* spin lock for scan_pending_q */
 	spinlock_t scan_pending_q_lock;
+	/* spin lock for RX queue */
+	spinlock_t rx_q_lock;
+	/* spin lock for RX processing routine */
+	spinlock_t rx_proc_lock;
 	struct sk_buff_head usb_rx_data_q;
 	u32 scan_processing;
 	u16 region_code;
@@ -831,6 +844,7 @@ struct mwifiex_adapter {
 	u8 num_mem_types;
 	u8 curr_mem_idx;
 	bool scan_chan_gap_enabled;
+	struct sk_buff_head rx_data_q;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 2ada1b7..1504b16 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1233,6 +1233,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 	struct sk_buff *skb_tmp = NULL;
 	struct mwifiex_pcie_buf_desc *desc;
 	struct mwifiex_pfu_buf_desc *desc2;
+	unsigned long flags;
 
 	if (!mwifiex_pcie_ok_to_access_hw(adapter))
 		mwifiex_pm_wakeup_card(adapter);
@@ -1283,7 +1284,16 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 				"info: RECV DATA: Rd=%#x, Wr=%#x, Len=%d\n",
 				card->rxbd_rdptr, wrptr, rx_len);
 			skb_pull(skb_data, INTF_HEADER_LEN);
-			mwifiex_handle_rx_packet(adapter, skb_data);
+			if (adapter->rx_work_enabled) {
+				spin_lock_irqsave(&adapter->rx_q_lock, flags);
+				skb_queue_tail(&adapter->rx_data_q, skb_data);
+				spin_unlock_irqrestore(&adapter->rx_q_lock,
+						       flags);
+				adapter->data_received = true;
+				atomic_inc(&adapter->rx_pending);
+			} else {
+				mwifiex_handle_rx_packet(adapter, skb_data);
+			}
 		}
 
 		skb_tmp = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index bdab122..ea8fc58 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1039,6 +1039,7 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 				    struct sk_buff *skb, u32 upld_typ)
 {
 	u8 *cmd_buf;
+	unsigned long flags;
 	__le16 *curr_ptr = (__le16 *)skb->data;
 	u16 pkt_len = le16_to_cpu(*curr_ptr);
 
@@ -1048,7 +1049,15 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 	switch (upld_typ) {
 	case MWIFIEX_TYPE_DATA:
 		dev_dbg(adapter->dev, "info: --- Rx: Data packet ---\n");
-		mwifiex_handle_rx_packet(adapter, skb);
+		if (adapter->rx_work_enabled) {
+			spin_lock_irqsave(&adapter->rx_q_lock, flags);
+			skb_queue_tail(&adapter->rx_data_q, skb);
+			spin_unlock_irqrestore(&adapter->rx_q_lock, flags);
+			adapter->data_received = true;
+			atomic_inc(&adapter->rx_pending);
+		} else {
+			mwifiex_handle_rx_packet(adapter, skb);
+		}
 		break;
 
 	case MWIFIEX_TYPE_CMD:
-- 
1.8.1.4

