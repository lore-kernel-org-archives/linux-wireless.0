Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:43451 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbdLAHtd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 02:49:33 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [v3 1/8] rsi: add rx control block to handle rx packets in USB
Date: Fri,  1 Dec 2017 13:11:18 +0530
Message-Id: <1512114085-2615-2-git-send-email-amitkarwar@gmail.com> (sfid-20171201_084951_347064_D1D85F2B)
In-Reply-To: <1512114085-2615-1-git-send-email-amitkarwar@gmail.com>
References: <1512114085-2615-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Rx bluetooth endpoint shall be added in further patches. Rx control
block is introduced here to handle Rx packets properly. Separate
function is written to initialize the RX control blocks.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c     |  4 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  2 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 75 +++++++++++++++++++++++------
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  | 35 +++++++++-----
 drivers/net/wireless/rsi/rsi_common.h       |  2 +-
 drivers/net/wireless/rsi/rsi_main.h         |  2 +-
 drivers/net/wireless/rsi/rsi_usb.h          | 10 +++-
 7 files changed, 96 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 0cb8e68..0413af8 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -137,7 +137,7 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
  *
  * Return: 0 on success, -1 on failure.
  */
-int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len)
+int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 {
 	u8 *frame_desc = NULL, extended_desc = 0;
 	u32 index, length = 0, queueno = 0;
@@ -146,7 +146,7 @@ int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len)
 
 	index = 0;
 	do {
-		frame_desc = &common->rx_data_pkt[index];
+		frame_desc = &rx_pkt[index];
 		actual_length = *(u16 *)&frame_desc[0];
 		offset = *(u16 *)&frame_desc[2];
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 8e2a95c..9fbc0ef 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -118,7 +118,7 @@ static int rsi_process_pkt(struct rsi_common *common)
 		goto fail;
 	}
 
-	status = rsi_read_pkt(common, rcv_pkt_len);
+	status = rsi_read_pkt(common, common->rx_data_pkt, rcv_pkt_len);
 
 fail:
 	kfree(common->rx_data_pkt);
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 0873022..147fcee2 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -247,12 +247,13 @@ static int rsi_usb_reg_write(struct usb_device *usbdev,
  */
 static void rsi_rx_done_handler(struct urb *urb)
 {
-	struct rsi_hw *adapter = urb->context;
-	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	struct rx_usb_ctrl_block *rx_cb = urb->context;
+	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)rx_cb->data;
 
 	if (urb->status)
 		return;
 
+	rx_cb->pend = 1;
 	rsi_set_event(&dev->rx_thread.event);
 }
 
@@ -262,10 +263,11 @@ static void rsi_rx_done_handler(struct urb *urb)
  *
  * Return: 0 on success, a negative error code on failure.
  */
-static int rsi_rx_urb_submit(struct rsi_hw *adapter)
+static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	struct urb *urb = dev->rx_usb_urb[0];
+	struct rx_usb_ctrl_block *rx_cb = &dev->rx_cb[ep_num - 1];
+	struct urb *urb = rx_cb->rx_urb;
 	int status;
 
 	usb_fill_bulk_urb(urb,
@@ -275,7 +277,7 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter)
 			  urb->transfer_buffer,
 			  3000,
 			  rsi_rx_done_handler,
-			  adapter);
+			  rx_cb);
 
 	status = usb_submit_urb(urb, GFP_KERNEL);
 	if (status)
@@ -484,14 +486,54 @@ static struct rsi_host_intf_ops usb_host_intf_ops = {
  */
 static void rsi_deinit_usb_interface(struct rsi_hw *adapter)
 {
+	u8 idx;
+
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 
 	rsi_kill_thread(&dev->rx_thread);
-	usb_free_urb(dev->rx_usb_urb[0]);
+
+	for (idx = 0; idx < MAX_RX_URBS; idx++) {
+		usb_free_urb(dev->rx_cb[idx].rx_urb);
+		kfree(dev->rx_cb[idx].rx_buffer);
+	}
+
 	kfree(adapter->priv->rx_data_pkt);
 	kfree(dev->tx_buffer);
 }
 
+static int rsi_usb_init_rx(struct rsi_hw *adapter)
+{
+	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	struct rx_usb_ctrl_block *rx_cb;
+	u8 idx;
+
+	for (idx = 0; idx < MAX_RX_URBS; idx++) {
+		rx_cb = &dev->rx_cb[idx];
+
+		rx_cb->rx_buffer = kzalloc(RSI_USB_BUF_SIZE * 2,
+					   GFP_KERNEL | GFP_DMA);
+		if (!rx_cb->rx_buffer)
+			goto err;
+
+		rx_cb->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!rx_cb->rx_urb) {
+			rsi_dbg(ERR_ZONE, "Failed alloc rx urb[%d]\n", idx);
+			goto err;
+		}
+		rx_cb->rx_urb->transfer_buffer = rx_cb->rx_buffer;
+		rx_cb->ep_num = idx + 1;
+		rx_cb->data = (void *)dev;
+	}
+	return 0;
+
+err:
+	for (idx = 0; idx < MAX_RX_URBS; idx++) {
+		kfree(dev->rx_cb[idx].rx_buffer);
+		kfree(dev->rx_cb[idx].rx_urb);
+	}
+	return -1;
+}
+
 /**
  * rsi_init_usb_interface() - This function initializes the usb interface.
  * @adapter: Pointer to the adapter structure.
@@ -504,7 +546,7 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 {
 	struct rsi_91x_usbdev *rsi_dev;
 	struct rsi_common *common = adapter->priv;
-	int status;
+	int status, i;
 
 	rsi_dev = kzalloc(sizeof(*rsi_dev), GFP_KERNEL);
 	if (!rsi_dev)
@@ -531,12 +573,12 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 		status = -ENOMEM;
 		goto fail_tx;
 	}
-	rsi_dev->rx_usb_urb[0] = usb_alloc_urb(0, GFP_KERNEL);
-	if (!rsi_dev->rx_usb_urb[0]) {
-		status = -ENOMEM;
-		goto fail_rx;
+
+	if (rsi_usb_init_rx(adapter)) {
+		rsi_dbg(ERR_ZONE, "Failed to init RX handle\n");
+		return -ENOMEM;
 	}
-	rsi_dev->rx_usb_urb[0]->transfer_buffer = adapter->priv->rx_data_pkt;
+
 	rsi_dev->tx_blk_size = 252;
 	adapter->block_size = rsi_dev->tx_blk_size;
 
@@ -564,9 +606,10 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	return 0;
 
 fail_thread:
-	usb_free_urb(rsi_dev->rx_usb_urb[0]);
-fail_rx:
-	kfree(rsi_dev->tx_buffer);
+	for (i = 0; i < MAX_RX_URBS; i++) {
+		kfree(rsi_dev->rx_cb[i].rx_buffer);
+		kfree(rsi_dev->rx_cb[i].rx_urb);
+	}
 fail_tx:
 	kfree(common->rx_data_pkt);
 	return status;
@@ -698,7 +741,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 		rsi_dbg(INIT_ZONE, "%s: Device Init Done\n", __func__);
 	}
 
-	status = rsi_rx_urb_submit(adapter);
+	status = rsi_rx_urb_submit(adapter, WLAN_EP);
 	if (status)
 		goto err1;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index 465692b..d0650ea 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -29,7 +29,8 @@ void rsi_usb_rx_thread(struct rsi_common *common)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	int status;
+	struct rx_usb_ctrl_block *rx_cb;
+	int status, idx;
 
 	do {
 		rsi_wait_event(&dev->rx_thread.event, EVENT_WAIT_FOREVER);
@@ -37,20 +38,30 @@ void rsi_usb_rx_thread(struct rsi_common *common)
 		if (atomic_read(&dev->rx_thread.thread_done))
 			goto out;
 
-		mutex_lock(&common->rx_lock);
-		status = rsi_read_pkt(common, 0);
-		if (status) {
-			rsi_dbg(ERR_ZONE, "%s: Failed To read data", __func__);
+		for (idx = 0; idx < MAX_RX_URBS; idx++) {
+			rx_cb = &dev->rx_cb[idx];
+			if (!rx_cb->pend)
+				continue;
+
+			mutex_lock(&common->rx_lock);
+			status = rsi_read_pkt(common, rx_cb->rx_buffer, 0);
+			if (status) {
+				rsi_dbg(ERR_ZONE, "%s: Failed To read data",
+					__func__);
+				mutex_unlock(&common->rx_lock);
+				break;
+			}
+			rx_cb->pend = 0;
 			mutex_unlock(&common->rx_lock);
-			return;
+
+			if (adapter->rx_urb_submit(adapter, rx_cb->ep_num)) {
+				rsi_dbg(ERR_ZONE,
+					"%s: Failed in urb submission",
+					__func__);
+				return;
+			}
 		}
-		mutex_unlock(&common->rx_lock);
 		rsi_reset_event(&dev->rx_thread.event);
-		if (adapter->rx_urb_submit(adapter)) {
-			rsi_dbg(ERR_ZONE,
-				"%s: Failed in urb submission", __func__);
-			return;
-		}
 	} while (1);
 
 out:
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index d07dbba..1d8af41 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -82,7 +82,7 @@ void rsi_mac80211_detach(struct rsi_hw *hw);
 u16 rsi_get_connected_channel(struct ieee80211_vif *vif);
 struct rsi_hw *rsi_91x_init(void);
 void rsi_91x_deinit(struct rsi_hw *adapter);
-int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len);
+int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len);
 #ifdef CONFIG_PM
 int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan);
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 8cab630..ee469dc 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -343,7 +343,7 @@ struct rsi_hw {
 	void *rsi_dev;
 	struct rsi_host_intf_ops *host_intf_ops;
 	int (*check_hw_queue_status)(struct rsi_hw *adapter, u8 q_num);
-	int (*rx_urb_submit)(struct rsi_hw *adapter);
+	int (*rx_urb_submit)(struct rsi_hw *adapter, u8 ep_num);
 	int (*determine_event_timeout)(struct rsi_hw *adapter);
 };
 
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 891daea..7e781d5 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -39,12 +39,20 @@
 #define RSI_USB_BUF_SIZE	     4096
 #define RSI_USB_CTRL_BUF_SIZE	     0x04
 
+struct rx_usb_ctrl_block {
+	u8 *data;
+	struct urb *rx_urb;
+	u8 *rx_buffer;
+	u8 ep_num;
+	u8 pend;
+};
+
 struct rsi_91x_usbdev {
 	struct rsi_thread rx_thread;
 	u8 endpoint;
 	struct usb_device *usbdev;
 	struct usb_interface *pfunction;
-	struct urb *rx_usb_urb[MAX_RX_URBS];
+	struct rx_usb_ctrl_block rx_cb[MAX_RX_URBS];
 	u8 *tx_buffer;
 	__le16 bulkin_size;
 	u8 bulkin_endpoint_addr;
-- 
2.7.4
