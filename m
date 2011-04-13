Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35840 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1DMFyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:54:21 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so276432iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:54:21 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15134.11643.7196@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:26:46 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 37/40] ath9k_htc: Use separate URB pool for management frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Beacon transmission needs to involve as little latency
as possible after receiving a SWBA event from the target.
Since packets are buffered to use TX stream mode, beacon
frames sometimes gets queued up and are not sent out immediately.
Fix this by decoupling management frame transmission from the
normal data path and send them out immediately.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |  116 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
 2 files changed, 108 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 1d18b1c..5686711 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -78,7 +78,7 @@ static void hif_usb_regout_cb(struct urb *urb)
 
 	if (cmd) {
 		ath9k_htc_txcompletion_cb(cmd->hif_dev->htc_handle,
-					  cmd->skb, 1);
+					  cmd->skb, true);
 		kfree(cmd);
 	}
 
@@ -124,6 +124,90 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 	return ret;
 }
 
+static void hif_usb_mgmt_cb(struct urb *urb)
+{
+	struct cmd_buf *cmd = (struct cmd_buf *)urb->context;
+	struct hif_device_usb *hif_dev = cmd->hif_dev;
+	bool txok = true;
+
+	if (!cmd || !cmd->skb || !cmd->hif_dev)
+		return;
+
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ENODEV:
+	case -ESHUTDOWN:
+		txok = false;
+
+		/*
+		 * If the URBs are being flushed, no need to complete
+		 * this packet.
+		 */
+		spin_lock(&hif_dev->tx.tx_lock);
+		if (hif_dev->tx.flags & HIF_USB_TX_FLUSH) {
+			spin_unlock(&hif_dev->tx.tx_lock);
+			dev_kfree_skb_any(cmd->skb);
+			kfree(cmd);
+			return;
+		}
+		spin_unlock(&hif_dev->tx.tx_lock);
+
+		break;
+	default:
+		txok = false;
+		break;
+	}
+
+	skb_pull(cmd->skb, 4);
+	ath9k_htc_txcompletion_cb(cmd->hif_dev->htc_handle,
+				  cmd->skb, txok);
+	kfree(cmd);
+}
+
+static int hif_usb_send_mgmt(struct hif_device_usb *hif_dev,
+			     struct sk_buff *skb)
+{
+	struct urb *urb;
+	struct cmd_buf *cmd;
+	int ret = 0;
+	__le16 *hdr;
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (urb == NULL)
+		return -ENOMEM;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
+	if (cmd == NULL) {
+		usb_free_urb(urb);
+		return -ENOMEM;
+	}
+
+	cmd->skb = skb;
+	cmd->hif_dev = hif_dev;
+
+	hdr = (__le16 *) skb_push(skb, 4);
+	*hdr++ = cpu_to_le16(skb->len - 4);
+	*hdr++ = cpu_to_le16(ATH_USB_TX_STREAM_MODE_TAG);
+
+	usb_fill_bulk_urb(urb, hif_dev->udev,
+			 usb_sndbulkpipe(hif_dev->udev, USB_WLAN_TX_PIPE),
+			 skb->data, skb->len,
+			 hif_usb_mgmt_cb, cmd);
+
+	usb_anchor_urb(urb, &hif_dev->mgmt_submitted);
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret) {
+		usb_unanchor_urb(urb);
+		kfree(cmd);
+	}
+	usb_free_urb(urb);
+
+	return ret;
+}
+
 static inline void ath9k_skb_queue_purge(struct hif_device_usb *hif_dev,
 					 struct sk_buff_head *list)
 {
@@ -275,6 +359,7 @@ static int hif_usb_send_tx(struct hif_device_usb *hif_dev, struct sk_buff *skb)
 {
 	struct ath9k_htc_tx_ctl *tx_ctl;
 	unsigned long flags;
+	int ret = 0;
 
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
 
@@ -289,25 +374,33 @@ static int hif_usb_send_tx(struct hif_device_usb *hif_dev, struct sk_buff *skb)
 		return -ENOMEM;
 	}
 
-	__skb_queue_tail(&hif_dev->tx.tx_skb_queue, skb);
-	hif_dev->tx.tx_skb_cnt++;
+	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
 	tx_ctl = HTC_SKB_CB(skb);
 
-	/* Send normal/mgmt/beacon frames immediately */
-	if (tx_ctl->type != ATH9K_HTC_AMPDU)
-		__hif_usb_tx(hif_dev);
+	/* Mgmt/Beacon frames don't use the TX buffer pool */
+	if ((tx_ctl->type == ATH9K_HTC_MGMT) ||
+	    (tx_ctl->type == ATH9K_HTC_BEACON)) {
+		ret = hif_usb_send_mgmt(hif_dev, skb);
+	}
+
+	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
+
+	if ((tx_ctl->type == ATH9K_HTC_NORMAL) ||
+	    (tx_ctl->type == ATH9K_HTC_AMPDU)) {
+		__skb_queue_tail(&hif_dev->tx.tx_skb_queue, skb);
+		hif_dev->tx.tx_skb_cnt++;
+	}
 
 	/* Check if AMPDUs have to be sent immediately */
-	if ((tx_ctl->type == ATH9K_HTC_AMPDU) &&
-	    (hif_dev->tx.tx_buf_cnt == MAX_TX_URB_NUM) &&
+	if ((hif_dev->tx.tx_buf_cnt == MAX_TX_URB_NUM) &&
 	    (hif_dev->tx.tx_skb_cnt < 2)) {
 		__hif_usb_tx(hif_dev);
 	}
 
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 
-	return 0;
+	return ret;
 }
 
 static void hif_usb_start(void *hif_handle)
@@ -339,6 +432,8 @@ static void hif_usb_stop(void *hif_handle)
 				 &hif_dev->tx.tx_pending, list) {
 		usb_kill_urb(tx_buf->urb);
 	}
+
+	usb_kill_anchored_urbs(&hif_dev->mgmt_submitted);
 }
 
 static int hif_usb_send(void *hif_handle, u8 pipe_id, struct sk_buff *skb)
@@ -657,6 +752,8 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 		kfree(tx_buf->buf);
 		kfree(tx_buf);
 	}
+
+	usb_kill_anchored_urbs(&hif_dev->mgmt_submitted);
 }
 
 static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
@@ -668,6 +765,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
 	INIT_LIST_HEAD(&hif_dev->tx.tx_pending);
 	spin_lock_init(&hif_dev->tx.tx_lock);
 	__skb_queue_head_init(&hif_dev->tx.tx_skb_queue);
+	init_usb_anchor(&hif_dev->mgmt_submitted);
 
 	for (i = 0; i < MAX_TX_URB_NUM; i++) {
 		tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 8b98d64..f59df48 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -93,6 +93,7 @@ struct hif_device_usb {
 	struct usb_anchor regout_submitted;
 	struct usb_anchor rx_submitted;
 	struct usb_anchor reg_in_submitted;
+	struct usb_anchor mgmt_submitted;
 	struct sk_buff *remain_skb;
 	const char *fw_name;
 	int rx_remain_len;
-- 
1.7.4.4

