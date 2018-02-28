Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:42902 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbeB1Hu3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 02:50:29 -0500
Received: by mail-pg0-f65.google.com with SMTP id y8so654389pgr.9
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 23:50:29 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 3/3] rsi: improve RX packet handling in USB interface
Date: Wed, 28 Feb 2018 13:08:28 +0530
Message-Id: <1519803508-27737-4-git-send-email-amitkarwar@gmail.com> (sfid-20180228_085034_158173_53DD0D2B)
In-Reply-To: <1519803508-27737-1-git-send-email-amitkarwar@gmail.com>
References: <1519803508-27737-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Curretly, RX packet processing is done sequencially. To improve
the efficiency, RX skb queue is introduced.
Here, while preparing RX URB skb is allocated and used
for RX buffer. When rx done handler is called, enqueue the skb
to rx_q and set the thread event.
RX thread is modified to dequeue packets from skb queue and
process further.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c     | 110 ++++++++++++++++-------------
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c |  35 ++++-----
 drivers/net/wireless/rsi/rsi_hal.h         |   1 +
 drivers/net/wireless/rsi/rsi_main.h        |   1 -
 drivers/net/wireless/rsi/rsi_usb.h         |   5 +-
 5 files changed, 78 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 64781a3..be8236f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -29,6 +29,8 @@ MODULE_PARM_DESC(dev_oper_mode,
 		 "9[Wi-Fi STA + BT LE], 13[Wi-Fi STA + BT classic + BT LE]\n"
 		 "6[AP + BT classic], 14[AP + BT classic + BT LE]");
 
+static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num);
+
 /**
  * rsi_usb_card_write() - This function writes to the USB Card.
  * @adapter: Pointer to the adapter structure.
@@ -260,12 +262,31 @@ static void rsi_rx_done_handler(struct urb *urb)
 {
 	struct rx_usb_ctrl_block *rx_cb = urb->context;
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)rx_cb->data;
+	int status = -EINVAL;
 
 	if (urb->status)
-		return;
+		goto out;
+
+	if (urb->actual_length <= 0) {
+		rsi_dbg(INFO_ZONE, "%s: Zero length packet\n", __func__);
+		goto out;
+	}
+	if (skb_queue_len(&dev->rx_q) >= RSI_MAX_RX_PKTS) {
+		rsi_dbg(INFO_ZONE, "Max RX packets reached\n");
+		goto out;
+	}
+	skb_put(rx_cb->rx_skb, urb->actual_length);
+	skb_queue_tail(&dev->rx_q, rx_cb->rx_skb);
 
-	rx_cb->pend = 1;
 	rsi_set_event(&dev->rx_thread.event);
+	status = 0;
+
+out:
+	if (rsi_rx_urb_submit(dev->priv, rx_cb->ep_num))
+		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission", __func__);
+
+	if (status)
+		dev_kfree_skb(rx_cb->rx_skb);
 }
 
 /**
@@ -280,13 +301,26 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num)
 	struct rx_usb_ctrl_block *rx_cb = &dev->rx_cb[ep_num - 1];
 	struct urb *urb = rx_cb->rx_urb;
 	int status;
+	struct sk_buff *skb;
+	u8 dword_align_bytes = 0;
+
+#define RSI_MAX_RX_USB_PKT_SIZE	3000
+	skb = dev_alloc_skb(RSI_MAX_RX_USB_PKT_SIZE);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, MAX_DWORD_ALIGN_BYTES);
+	dword_align_bytes = (unsigned long)skb->data & 0x3f;
+	if (dword_align_bytes > 0)
+		skb_push(skb, dword_align_bytes);
+	urb->transfer_buffer = skb->data;
+	rx_cb->rx_skb = skb;
 
 	usb_fill_bulk_urb(urb,
 			  dev->usbdev,
 			  usb_rcvbulkpipe(dev->usbdev,
 			  dev->bulkin_endpoint_addr[ep_num - 1]),
 			  urb->transfer_buffer,
-			  3000,
+			  RSI_MAX_RX_USB_PKT_SIZE,
 			  rsi_rx_done_handler,
 			  rx_cb);
 
@@ -502,13 +536,9 @@ static void rsi_deinit_usb_interface(struct rsi_hw *adapter)
 	rsi_kill_thread(&dev->rx_thread);
 
 	usb_free_urb(dev->rx_cb[0].rx_urb);
-	kfree(dev->rx_cb[0].rx_buffer);
-	if (adapter->priv->coex_mode > 1) {
+	if (adapter->priv->coex_mode > 1)
 		usb_free_urb(dev->rx_cb[1].rx_urb);
-		kfree(dev->rx_cb[1].rx_buffer);
-	}
 
-	kfree(adapter->priv->rx_data_pkt);
 	kfree(dev->tx_buffer);
 }
 
@@ -523,29 +553,29 @@ static int rsi_usb_init_rx(struct rsi_hw *adapter)
 	for (idx = 0; idx < num_rx_cb; idx++) {
 		rx_cb = &dev->rx_cb[idx];
 
-		rx_cb->rx_buffer = kzalloc(RSI_USB_BUF_SIZE * 2,
-					   GFP_KERNEL);
-		if (!rx_cb->rx_buffer)
-			goto err;
-
 		rx_cb->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!rx_cb->rx_urb) {
 			rsi_dbg(ERR_ZONE, "Failed alloc rx urb[%d]\n", idx);
 			goto err;
 		}
-		rx_cb->rx_urb->transfer_buffer = rx_cb->rx_buffer;
 		rx_cb->ep_num = idx + 1;
 		rx_cb->data = (void *)dev;
 	}
+	skb_queue_head_init(&dev->rx_q);
+	rsi_init_event(&dev->rx_thread.event);
+	if (rsi_create_kthread(adapter->priv, &dev->rx_thread,
+			       rsi_usb_rx_thread, "RX-Thread")) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to init rx thrd\n", __func__);
+		goto err;
+	}
+
 	return 0;
 
 err:
-	kfree(dev->rx_cb[0].rx_buffer);
 	usb_free_urb(dev->rx_cb[0].rx_urb);
-	if (adapter->priv->coex_mode > 1) {
-		kfree(dev->rx_cb[1].rx_buffer);
+	if (adapter->priv->coex_mode > 1)
 		usb_free_urb(dev->rx_cb[1].rx_urb);
-	}
+
 	return -1;
 }
 
@@ -560,7 +590,6 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 				  struct usb_interface *pfunction)
 {
 	struct rsi_91x_usbdev *rsi_dev;
-	struct rsi_common *common = adapter->priv;
 	int status;
 
 	rsi_dev = kzalloc(sizeof(*rsi_dev), GFP_KERNEL);
@@ -569,49 +598,37 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 
 	adapter->rsi_dev = rsi_dev;
 	rsi_dev->usbdev = interface_to_usbdev(pfunction);
+	rsi_dev->priv = (void *)adapter;
 
-	if (rsi_find_bulk_in_and_out_endpoints(pfunction, adapter))
-		return -EINVAL;
+	if (rsi_find_bulk_in_and_out_endpoints(pfunction, adapter)) {
+		status = -EINVAL;
+		goto fail_eps;
+	}
 
 	adapter->device = &pfunction->dev;
 	usb_set_intfdata(pfunction, adapter);
 
-	common->rx_data_pkt = kmalloc(2048, GFP_KERNEL);
-	if (!common->rx_data_pkt) {
-		rsi_dbg(ERR_ZONE, "%s: Failed to allocate memory\n",
-			__func__);
-		return -ENOMEM;
-	}
-
 	rsi_dev->tx_buffer = kmalloc(2048, GFP_KERNEL);
 	if (!rsi_dev->tx_buffer) {
 		status = -ENOMEM;
-		goto fail_tx;
+		goto fail_eps;
 	}
 
 	if (rsi_usb_init_rx(adapter)) {
 		rsi_dbg(ERR_ZONE, "Failed to init RX handle\n");
-		return -ENOMEM;
+		status = -ENOMEM;
+		goto fail_rx;
 	}
 
 	rsi_dev->tx_blk_size = 252;
 	adapter->block_size = rsi_dev->tx_blk_size;
 
 	/* Initializing function callbacks */
-	adapter->rx_urb_submit = rsi_rx_urb_submit;
 	adapter->check_hw_queue_status = rsi_usb_check_queue_status;
 	adapter->determine_event_timeout = rsi_usb_event_timeout;
 	adapter->rsi_host_intf = RSI_HOST_INTF_USB;
 	adapter->host_intf_ops = &usb_host_intf_ops;
 
-	rsi_init_event(&rsi_dev->rx_thread.event);
-	status = rsi_create_kthread(common, &rsi_dev->rx_thread,
-				    rsi_usb_rx_thread, "RX-Thread");
-	if (status) {
-		rsi_dbg(ERR_ZONE, "%s: Unable to init rx thrd\n", __func__);
-		goto fail_thread;
-	}
-
 #ifdef CONFIG_RSI_DEBUGFS
 	/* In USB, one less than the MAX_DEBUGFS_ENTRIES entries is required */
 	adapter->num_debugfs_entries = (MAX_DEBUGFS_ENTRIES - 1);
@@ -620,15 +637,12 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	rsi_dbg(INIT_ZONE, "%s: Enabled the interface\n", __func__);
 	return 0;
 
-fail_thread:
-	kfree(rsi_dev->rx_cb[0].rx_buffer);
-	usb_free_urb(rsi_dev->rx_cb[0].rx_urb);
-	if (common->coex_mode > 1) {
-		kfree(rsi_dev->rx_cb[1].rx_buffer);
-		usb_free_urb(rsi_dev->rx_cb[1].rx_urb);
-	}
-fail_tx:
-	kfree(common->rx_data_pkt);
+fail_rx:
+	kfree(rsi_dev->tx_buffer);
+
+fail_eps:
+	kfree(rsi_dev);
+
 	return status;
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index fc25b1b..b1687d2 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -29,44 +29,33 @@ void rsi_usb_rx_thread(struct rsi_common *common)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	struct rx_usb_ctrl_block *rx_cb;
-	int status, idx, num_rx_cb;
+	int status;
+	struct sk_buff *skb;
 
-	num_rx_cb = (adapter->priv->coex_mode > 1 ? 2 : 1);
 	do {
 		rsi_wait_event(&dev->rx_thread.event, EVENT_WAIT_FOREVER);
+		rsi_reset_event(&dev->rx_thread.event);
 
-		if (atomic_read(&dev->rx_thread.thread_done))
-			goto out;
-
-		for (idx = 0; idx < num_rx_cb; idx++) {
-			rx_cb = &dev->rx_cb[idx];
-			if (!rx_cb->pend)
-				continue;
+		while (true) {
+			if (atomic_read(&dev->rx_thread.thread_done))
+				goto out;
 
-			mutex_lock(&common->rx_lock);
-			status = rsi_read_pkt(common, rx_cb->rx_buffer, 0);
+			skb = skb_dequeue(&dev->rx_q);
+			if (!skb)
+				break;
+			status = rsi_read_pkt(common, skb->data, 0);
 			if (status) {
 				rsi_dbg(ERR_ZONE, "%s: Failed To read data",
 					__func__);
-				mutex_unlock(&common->rx_lock);
 				break;
 			}
-			rx_cb->pend = 0;
-			mutex_unlock(&common->rx_lock);
-
-			if (adapter->rx_urb_submit(adapter, rx_cb->ep_num)) {
-				rsi_dbg(ERR_ZONE,
-					"%s: Failed in urb submission",
-					__func__);
-				return;
-			}
+			dev_kfree_skb(skb);
 		}
-		rsi_reset_event(&dev->rx_thread.event);
 	} while (1);
 
 out:
 	rsi_dbg(INFO_ZONE, "%s: Terminated thread\n", __func__);
+	skb_queue_purge(&dev->rx_q);
 	complete_and_exit(&dev->rx_thread.completion, 0);
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index a7d3011..786dccd 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -114,6 +114,7 @@
 
 #define FW_FLASH_OFFSET			0x820
 #define LMAC_VER_OFFSET			(FW_FLASH_OFFSET + 0x200)
+#define MAX_DWORD_ALIGN_BYTES		64
 
 struct bl_header {
 	__le32 flags;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index c91d625..ef4fa32 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -341,7 +341,6 @@ struct rsi_hw {
 	void *rsi_dev;
 	struct rsi_host_intf_ops *host_intf_ops;
 	int (*check_hw_queue_status)(struct rsi_hw *adapter, u8 q_num);
-	int (*rx_urb_submit)(struct rsi_hw *adapter, u8 ep_num);
 	int (*determine_event_timeout)(struct rsi_hw *adapter);
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 0fda14c..a88d592 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -42,12 +42,12 @@
 struct rx_usb_ctrl_block {
 	u8 *data;
 	struct urb *rx_urb;
-	u8 *rx_buffer;
+	struct sk_buff *rx_skb;
 	u8 ep_num;
-	u8 pend;
 };
 
 struct rsi_91x_usbdev {
+	void *priv;
 	struct rsi_thread rx_thread;
 	u8 endpoint;
 	struct usb_device *usbdev;
@@ -60,6 +60,7 @@ struct rsi_91x_usbdev {
 	u8 bulkout_endpoint_addr[MAX_BULK_EP];
 	u32 tx_blk_size;
 	u8 write_fail;
+	struct sk_buff_head rx_q;
 };
 
 static inline int rsi_usb_check_queue_status(struct rsi_hw *adapter, u8 q_num)
-- 
2.7.4
