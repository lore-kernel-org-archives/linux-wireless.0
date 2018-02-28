Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:36314 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbeB1HuT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 02:50:19 -0500
Received: by mail-pl0-f66.google.com with SMTP id 61-v6so1058415plf.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 23:50:19 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 1/3] rsi: improve RX handling in SDIO interface
Date: Wed, 28 Feb 2018 13:08:26 +0530
Message-Id: <1519803508-27737-2-git-send-email-amitkarwar@gmail.com> (sfid-20180228_085023_895186_EAA9D105)
In-Reply-To: <1519803508-27737-1-git-send-email-amitkarwar@gmail.com>
References: <1519803508-27737-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Currently, RX packets are handled in interrupt context in SDIO
interface. To improve the efficiency of processing RX packets,
RX thread and RX skb queues are introduced.
When the packet is read from device, driver prepares skb, add to
RX queue and trigger RX thread event. RX thread processes the
packets from RX queue.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 45 +++++++++++++++-----
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 64 +++++++++++++++++++++++------
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 drivers/net/wireless/rsi/rsi_sdio.h         |  8 ++++
 4 files changed, 94 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index beb18d0..98c7d1d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -933,6 +933,8 @@ static int rsi_probe(struct sdio_func *pfunction,
 		     const struct sdio_device_id *id)
 {
 	struct rsi_hw *adapter;
+	struct rsi_91x_sdiodev *sdev;
+	int status;
 
 	rsi_dbg(INIT_ZONE, "%s: Init function called\n", __func__);
 
@@ -940,7 +942,7 @@ static int rsi_probe(struct sdio_func *pfunction,
 	if (!adapter) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to init os intf ops\n",
 			__func__);
-		return 1;
+		return -EINVAL;
 	}
 	adapter->rsi_host_intf = RSI_HOST_INTF_SDIO;
 	adapter->host_intf_ops = &sdio_host_intf_ops;
@@ -948,39 +950,58 @@ static int rsi_probe(struct sdio_func *pfunction,
 	if (rsi_init_sdio_interface(adapter, pfunction)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to init sdio interface\n",
 			__func__);
-		goto fail;
+		status = -EIO;
+		goto fail_free_adapter;
+	}
+	sdev = (struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	rsi_init_event(&sdev->rx_thread.event);
+	status = rsi_create_kthread(adapter->priv, &sdev->rx_thread,
+				    rsi_sdio_rx_thread, "SDIO-RX-Thread");
+	if (status) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to init rx thrd\n", __func__);
+		goto fail_free_adapter;
 	}
+	skb_queue_head_init(&sdev->rx_q.head);
+	sdev->rx_q.num_rx_pkts = 0;
+
 	sdio_claim_host(pfunction);
 	if (sdio_claim_irq(pfunction, rsi_handle_interrupt)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to request IRQ\n", __func__);
 		sdio_release_host(pfunction);
-		goto fail;
+		status = -EIO;
+		goto fail_kill_thread;
 	}
 	sdio_release_host(pfunction);
 	rsi_dbg(INIT_ZONE, "%s: Registered Interrupt handler\n", __func__);
 
 	if (rsi_hal_device_init(adapter)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n", __func__);
-		sdio_claim_host(pfunction);
-		sdio_release_irq(pfunction);
-		sdio_disable_func(pfunction);
-		sdio_release_host(pfunction);
-		goto fail;
+		status = -EINVAL;
+		goto fail_kill_thread;
 	}
 	rsi_dbg(INFO_ZONE, "===> RSI Device Init Done <===\n");
 
 	if (rsi_sdio_master_access_msword(adapter, MISC_CFG_BASE_ADDR)) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n", __func__);
-		return -EIO;
+		status = -EIO;
+		goto fail_dev_init;
 	}
 
 	adapter->priv->hibernate_resume = false;
 	adapter->priv->reinit_hw = false;
 	return 0;
-fail:
+
+fail_dev_init:
+	sdio_claim_host(pfunction);
+	sdio_release_irq(pfunction);
+	sdio_disable_func(pfunction);
+	sdio_release_host(pfunction);
+fail_kill_thread:
+	rsi_kill_thread(&sdev->rx_thread);
+fail_free_adapter:
 	rsi_91x_deinit(adapter);
 	rsi_dbg(ERR_ZONE, "%s: Failed in probe...Exiting\n", __func__);
-	return 1;
+	return status;
 }
 
 static void ulp_read_write(struct rsi_hw *adapter, u16 addr, u32 data,
@@ -1076,6 +1097,8 @@ static void rsi_disconnect(struct sdio_func *pfunction)
 		return;
 
 	dev = (struct rsi_91x_sdiodev *)adapter->rsi_dev;
+
+	rsi_kill_thread(&dev->rx_thread);
 	sdio_claim_host(pfunction);
 	sdio_release_irq(pfunction);
 	sdio_release_host(pfunction);
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 6e74261..612c211 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -60,6 +60,43 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word)
 	return status;
 }
 
+void rsi_sdio_rx_thread(struct rsi_common *common)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
+	struct sk_buff *skb;
+	int status;
+
+	do {
+		rsi_wait_event(&sdev->rx_thread.event, EVENT_WAIT_FOREVER);
+		rsi_reset_event(&sdev->rx_thread.event);
+
+		while (true) {
+			if (atomic_read(&sdev->rx_thread.thread_done))
+				goto out;
+
+			skb = skb_dequeue(&sdev->rx_q.head);
+			if (!skb)
+				break;
+			if (sdev->rx_q.num_rx_pkts > 0)
+				sdev->rx_q.num_rx_pkts--;
+			status = rsi_read_pkt(common, skb->data, skb->len);
+			if (status) {
+				rsi_dbg(ERR_ZONE, "Failed to read the packet\n");
+				dev_kfree_skb(skb);
+				break;
+			}
+			dev_kfree_skb(skb);
+		}
+	} while (1);
+
+out:
+	rsi_dbg(INFO_ZONE, "%s: Terminated SDIO RX thread\n", __func__);
+	skb_queue_purge(&sdev->rx_q.head);
+	atomic_inc(&sdev->rx_thread.thread_done);
+	complete_and_exit(&sdev->rx_thread.completion, 0);
+}
+
 /**
  * rsi_process_pkt() - This Function reads rx_blocks register and figures out
  *		       the size of the rx pkt.
@@ -76,6 +113,10 @@ static int rsi_process_pkt(struct rsi_common *common)
 	u32 rcv_pkt_len = 0;
 	int status = 0;
 	u8 value = 0;
+	struct sk_buff *skb;
+
+	if (dev->rx_q.num_rx_pkts >= RSI_MAX_RX_PKTS)
+		return 0;
 
 	num_blks = ((adapter->interrupt_status & 1) |
 			((adapter->interrupt_status >> RECV_NUM_BLOCKS) << 1));
@@ -103,27 +144,24 @@ static int rsi_process_pkt(struct rsi_common *common)
 
 	rcv_pkt_len = (num_blks * 256);
 
-	common->rx_data_pkt = kzalloc(rcv_pkt_len, GFP_KERNEL);
-	if (!common->rx_data_pkt) {
-		rsi_dbg(ERR_ZONE, "%s: Failed in memory allocation\n",
-			__func__);
+	skb = dev_alloc_skb(rcv_pkt_len);
+	if (!skb)
 		return -ENOMEM;
-	}
 
-	status = rsi_sdio_host_intf_read_pkt(adapter,
-					     common->rx_data_pkt,
-					     rcv_pkt_len);
+	status = rsi_sdio_host_intf_read_pkt(adapter, skb->data, rcv_pkt_len);
 	if (status) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to read packet from card\n",
 			__func__);
-		goto fail;
+		dev_kfree_skb(skb);
+		return status;
 	}
+	skb_put(skb, rcv_pkt_len);
+	skb_queue_tail(&dev->rx_q.head, skb);
+	dev->rx_q.num_rx_pkts++;
 
-	status = rsi_read_pkt(common, common->rx_data_pkt, rcv_pkt_len);
+	rsi_set_event(&dev->rx_thread.event);
 
-fail:
-	kfree(common->rx_data_pkt);
-	return status;
+	return 0;
 }
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 47af0cb..c91d625 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -112,6 +112,7 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define RSI_WOW_NO_CONNECTION		BIT(1)
 
 #define RSI_DEV_9113		1
+#define RSI_MAX_RX_PKTS		64
 
 struct version_info {
 	u16 major;
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 49c549b..ba649be 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -105,6 +105,11 @@ struct receive_info {
 	u32 buf_available_counter;
 };
 
+struct rsi_sdio_rx_q {
+	u8 num_rx_pkts;
+	struct sk_buff_head head;
+};
+
 struct rsi_91x_sdiodev {
 	struct sdio_func *pfunction;
 	struct task_struct *sdio_irq_task;
@@ -117,6 +122,8 @@ struct rsi_91x_sdiodev {
 	u16 tx_blk_size;
 	u8 write_fail;
 	bool buff_status_updated;
+	struct rsi_sdio_rx_q rx_q;
+	struct rsi_thread rx_thread;
 };
 
 void rsi_interrupt_handler(struct rsi_hw *adapter);
@@ -131,4 +138,5 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num);
+void rsi_sdio_rx_thread(struct rsi_common *common);
 #endif
-- 
2.7.4
