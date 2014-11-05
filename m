Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13959 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbaKEGFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 01:05:16 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <cluo@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [Patch v2 1/5] mwifiex: rx workqueue support for USB interface
Date: Wed, 5 Nov 2014 17:04:27 +0530
Message-ID: <1415187271-17914-1-git-send-email-akarwar@marvell.com> (sfid-20141105_070528_125808_5A691B25)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds RX workqueue support for USB interfaces.
Currently rx_pending is applicable for cmd/events and Rx
data in USB interface. Let's use it only for Rx data.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 14 --------------
 drivers/net/wireless/mwifiex/main.c |  8 +-------
 drivers/net/wireless/mwifiex/main.h |  6 +-----
 drivers/net/wireless/mwifiex/usb.c  |  9 +++------
 4 files changed, 5 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 580aa45..bd740b6 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -449,7 +449,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 	spin_lock_init(&adapter->scan_pending_q_lock);
 	spin_lock_init(&adapter->rx_proc_lock);
 
-	skb_queue_head_init(&adapter->usb_rx_data_q);
 	skb_queue_head_init(&adapter->rx_data_q);
 
 	for (i = 0; i < adapter->priv_num; ++i) {
@@ -668,19 +667,6 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 
 	spin_lock(&adapter->mwifiex_lock);
 
-	if (adapter->if_ops.data_complete) {
-		while ((skb = skb_dequeue(&adapter->usb_rx_data_q))) {
-			struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
-
-			priv = adapter->priv[rx_info->bss_num];
-			if (priv)
-				priv->stats.rx_dropped++;
-
-			dev_kfree_skb_any(skb);
-			adapter->if_ops.data_complete(adapter);
-		}
-	}
-
 	mwifiex_adapter_cleanup(adapter);
 
 	spin_unlock(&adapter->mwifiex_lock);
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index f26420d..cb23ca3 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -178,7 +178,6 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 {
 	int ret = 0;
 	unsigned long flags;
-	struct sk_buff *skb;
 
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 
@@ -253,11 +252,6 @@ process_start:
 			}
 		}
 
-		/* Check Rx data for USB */
-		if (adapter->iface_type == MWIFIEX_USB)
-			while ((skb = skb_dequeue(&adapter->usb_rx_data_q)))
-				mwifiex_handle_rx_packet(adapter, skb);
-
 		/* Check for event */
 		if (adapter->event_received) {
 			adapter->event_received = false;
@@ -864,7 +858,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	adapter->cmd_wait_q.status = 0;
 	adapter->scan_wait_q_woken = false;
 
-	if (num_possible_cpus() > 1) {
+	if ((num_possible_cpus() > 1) || adapter->iface_type == MWIFIEX_USB) {
 		adapter->rx_work_enabled = true;
 		pr_notice("rx work enabled, cpus %d\n", num_possible_cpus());
 	}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index cb39319..a9eea9b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -106,10 +106,7 @@ enum {
  */
 #define IS_CARD_RX_RCVD(adapter) (adapter->cmd_resp_received || \
 				adapter->event_received || \
-				((adapter->iface_type != MWIFIEX_USB) && \
-				adapter->data_received) || \
-				((adapter->iface_type == MWIFIEX_USB) && \
-				!skb_queue_empty(&adapter->usb_rx_data_q)))
+				adapter->data_received)
 
 #define MWIFIEX_TYPE_CMD				1
 #define MWIFIEX_TYPE_DATA				0
@@ -767,7 +764,6 @@ struct mwifiex_adapter {
 	spinlock_t scan_pending_q_lock;
 	/* spin lock for RX processing routine */
 	spinlock_t rx_proc_lock;
-	struct sk_buff_head usb_rx_data_q;
 	u32 scan_processing;
 	u16 region_code;
 	struct mwifiex_802_11d_domain_reg domain_reg;
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 4371e12..00afcf6 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -125,8 +125,10 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
 			dev_err(dev, "DATA: skb->len too large\n");
 			return -1;
 		}
-		skb_queue_tail(&adapter->usb_rx_data_q, skb);
+
+		skb_queue_tail(&adapter->rx_data_q, skb);
 		adapter->data_received = true;
+		atomic_inc(&adapter->rx_pending);
 		break;
 	default:
 		dev_err(dev, "%s: unknown endport %#x\n", __func__, ep);
@@ -176,7 +178,6 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 		else
 			skb_put(skb, recv_length - skb->len);
 
-		atomic_inc(&adapter->rx_pending);
 		status = mwifiex_usb_recv(adapter, skb, context->ep);
 
 		dev_dbg(adapter->dev, "info: recv_length=%d, status=%d\n",
@@ -191,7 +192,6 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 			if (card->rx_cmd_ep == context->ep)
 				return;
 		} else {
-			atomic_dec(&adapter->rx_pending);
 			if (status == -1)
 				dev_err(adapter->dev,
 					"received data processing failed!\n");
@@ -962,7 +962,6 @@ static void mwifiex_submit_rx_urb(struct mwifiex_adapter *adapter, u8 ep)
 static int mwifiex_usb_cmd_event_complete(struct mwifiex_adapter *adapter,
 				       struct sk_buff *skb)
 {
-	atomic_dec(&adapter->rx_pending);
 	mwifiex_submit_rx_urb(adapter, MWIFIEX_USB_EP_CMD_EVENT);
 
 	return 0;
@@ -970,8 +969,6 @@ static int mwifiex_usb_cmd_event_complete(struct mwifiex_adapter *adapter,
 
 static int mwifiex_usb_data_complete(struct mwifiex_adapter *adapter)
 {
-	atomic_dec(&adapter->rx_pending);
-
 	return 0;
 }
 
-- 
1.8.1.4

