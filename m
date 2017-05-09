Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35204 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754049AbdEINcG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:32:06 -0400
Received: by mail-pf0-f196.google.com with SMTP id u26so52982pfd.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 06:32:06 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 08/11] rsi: Add host interface operations as separate structure.
Date: Tue,  9 May 2017 19:00:11 +0530
Message-Id: <1494336614-2107-9-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170509_153217_742547_33720C24)
In-Reply-To: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Host interface operations are currently function pointers in rsi_hw
structure. As more host interface operations are going to be introduced,
separate structure is added for these for convenience.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c  | 16 +++++++---------
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 11 +++++++++--
 drivers/net/wireless/rsi/rsi_91x_usb.c  |  9 ++++++++-
 drivers/net/wireless/rsi/rsi_main.h     | 18 ++++++++++++++++--
 4 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 02920c9..8fbf904 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -100,9 +100,8 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 				    (skb->priority & 0xf) |
 				    (tx_params->sta_id << 8));
 
-	status = adapter->host_intf_write_pkt(common->priv,
-					      skb->data,
-					      skb->len);
+	status = adapter->host_intf_ops->write_pkt(common->priv, skb->data,
+						   skb->len);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write pkt\n",
 			__func__);
@@ -148,9 +147,9 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		}
 		skb_push(skb, extnd_size);
 		skb->data[extnd_size + 4] = extnd_size;
-		status = adapter->host_intf_write_pkt(common->priv,
-						      (u8 *)skb->data,
-						      skb->len);
+		status = adapter->host_intf_ops->write_pkt(common->priv,
+							   (u8 *)skb->data,
+							   skb->len);
 		if (status) {
 			rsi_dbg(ERR_ZONE,
 				"%s: Failed to write the packet\n", __func__);
@@ -203,9 +202,8 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 
 	msg[7] |= cpu_to_le16(vap_id << 8);
 
-	status = adapter->host_intf_write_pkt(common->priv,
-					      (u8 *)msg,
-					      skb->len);
+	status = adapter->host_intf_ops->write_pkt(common->priv, (u8 *)msg,
+						   skb->len);
 	if (status)
 		rsi_dbg(ERR_ZONE, "%s: Failed to write the packet\n", __func__);
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 39d94b3..bdbec8b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -676,8 +676,6 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 	}
 	sdio_release_host(pfunction);
 
-	adapter->host_intf_write_pkt = rsi_sdio_host_intf_write_pkt;
-	adapter->host_intf_read_pkt = rsi_sdio_host_intf_read_pkt;
 	adapter->determine_event_timeout = rsi_sdio_determine_event_timeout;
 	adapter->check_hw_queue_status = rsi_sdio_read_buffer_status_register;
 
@@ -691,6 +689,13 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 	return status;
 }
 
+static struct rsi_host_intf_ops sdio_host_intf_ops = {
+	.write_pkt		= rsi_sdio_host_intf_write_pkt,
+	.read_pkt		= rsi_sdio_host_intf_read_pkt,
+	.read_reg_multiple	= rsi_sdio_read_register_multiple,
+	.write_reg_multiple	= rsi_sdio_write_register_multiple,
+};
+
 /**
  * rsi_probe() - This function is called by kernel when the driver provided
  *		 Vendor and device IDs are matched. All the initialization
@@ -713,6 +718,8 @@ static int rsi_probe(struct sdio_func *pfunction,
 			__func__);
 		return 1;
 	}
+	adapter->rsi_host_intf = RSI_HOST_INTF_SDIO;
+	adapter->host_intf_ops = &sdio_host_intf_ops;
 
 	if (rsi_init_sdio_interface(adapter, pfunction)) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to init sdio interface\n",
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index fc52311..8b81a73 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -382,6 +382,12 @@ static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
 				  len);
 }
 
+static struct rsi_host_intf_ops usb_host_intf_ops = {
+	.write_pkt		= rsi_usb_host_intf_write_pkt,
+	.read_reg_multiple	= rsi_usb_read_register_multiple,
+	.write_reg_multiple	= rsi_usb_write_register_multiple,
+};
+
 /**
  * rsi_deinit_usb_interface() - This function deinitializes the usb interface.
  * @adapter: Pointer to the adapter structure.
@@ -447,9 +453,10 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 
 	/* Initializing function callbacks */
 	adapter->rx_urb_submit = rsi_rx_urb_submit;
-	adapter->host_intf_write_pkt = rsi_usb_host_intf_write_pkt;
 	adapter->check_hw_queue_status = rsi_usb_check_queue_status;
 	adapter->determine_event_timeout = rsi_usb_event_timeout;
+	adapter->rsi_host_intf = RSI_HOST_INTF_USB;
+	adapter->host_intf_ops = &usb_host_intf_ops;
 
 	rsi_init_event(&rsi_dev->rx_thread.event);
 	status = rsi_create_kthread(common, &rsi_dev->rx_thread,
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 1d5904b..7fdeda7 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -209,6 +209,11 @@ struct rsi_common {
 	u8 ant_in_use;
 };
 
+enum host_intf {
+	RSI_HOST_INTF_SDIO = 0,
+	RSI_HOST_INTF_USB
+};
+
 struct rsi_hw {
 	struct rsi_common *priv;
 	struct ieee80211_hw *hw;
@@ -219,16 +224,25 @@ struct rsi_hw {
 	struct device *device;
 	u8 sc_nvifs;
 
+	enum host_intf rsi_host_intf;
 #ifdef CONFIG_RSI_DEBUGFS
 	struct rsi_debugfs *dfsentry;
 	u8 num_debugfs_entries;
 #endif
 	u8 dfs_region;
 	void *rsi_dev;
-	int (*host_intf_read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
-	int (*host_intf_write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	struct rsi_host_intf_ops *host_intf_ops;
 	int (*check_hw_queue_status)(struct rsi_hw *adapter, u8 q_num);
 	int (*rx_urb_submit)(struct rsi_hw *adapter);
 	int (*determine_event_timeout)(struct rsi_hw *adapter);
 };
+
+struct rsi_host_intf_ops {
+	int (*read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	int (*write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	int (*read_reg_multiple)(struct rsi_hw *adapter, u32 addr,
+				 u8 *data, u16 count);
+	int (*write_reg_multiple)(struct rsi_hw *adapter, u32 addr,
+				  u8 *data, u16 count);
+};
 #endif
-- 
2.7.4
