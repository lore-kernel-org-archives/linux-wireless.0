Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52098 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0L1I6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:58:18 -0500
Received: by mail-pz0-f46.google.com with SMTP id 35so628094pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 00:58:18 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19737.42653.754539.507702@gargle.gargle.HOWL>
Date: Tue, 28 Dec 2010 14:28:05 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH v2 2/6] ath9k_htc: Handle pending URBs properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

When doing a channel change, the pending URBs have to be killed
properly on calling htc_stop().

This fixes the probe response timeout seen when sending UDP traffic at
a high rate and running background scan at the same time.

Cc: stable <stable@kernel.org>
Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   40 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index c20c8c8..5ab3084 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -153,16 +153,36 @@ static void hif_usb_tx_cb(struct urb *urb)
 	case -ENODEV:
 	case -ESHUTDOWN:
 		/*
-		 * The URB has been killed, free the SKBs
-		 * and return.
+		 * The URB has been killed, free the SKBs.
 		 */
 		ath9k_skb_queue_purge(hif_dev, &tx_buf->skb_queue);
-		return;
+
+		/*
+		 * If the URBs are being flushed, no need to add this
+		 * URB to the free list.
+		 */
+		spin_lock(&hif_dev->tx.tx_lock);
+		if (hif_dev->tx.flags & HIF_USB_TX_FLUSH) {
+			spin_unlock(&hif_dev->tx.tx_lock);
+			return;
+		}
+		spin_unlock(&hif_dev->tx.tx_lock);
+
+		/*
+		 * In the stop() case, this URB has to be added to
+		 * the free list.
+		 */
+		goto add_free;
 	default:
 		break;
 	}
 
-	/* Check if TX has been stopped */
+	/*
+	 * Check if TX has been stopped, this is needed because
+	 * this CB could have been invoked just after the TX lock
+	 * was released in hif_stop() and kill_urb() hasn't been
+	 * called yet.
+	 */
 	spin_lock(&hif_dev->tx.tx_lock);
 	if (hif_dev->tx.flags & HIF_USB_TX_STOP) {
 		spin_unlock(&hif_dev->tx.tx_lock);
@@ -314,6 +334,7 @@ static void hif_usb_start(void *hif_handle, u8 pipe_id)
 static void hif_usb_stop(void *hif_handle, u8 pipe_id)
 {
 	struct hif_device_usb *hif_dev = (struct hif_device_usb *)hif_handle;
+	struct tx_buf *tx_buf = NULL, *tx_buf_tmp = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
@@ -321,6 +342,12 @@ static void hif_usb_stop(void *hif_handle, u8 pipe_id)
 	hif_dev->tx.tx_skb_cnt = 0;
 	hif_dev->tx.flags |= HIF_USB_TX_STOP;
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
+
+	/* The pending URBs have to be canceled. */
+	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
+				 &hif_dev->tx.tx_pending, list) {
+		usb_kill_urb(tx_buf->urb);
+	}
 }
 
 static int hif_usb_send(void *hif_handle, u8 pipe_id, struct sk_buff *skb,
@@ -587,6 +614,7 @@ free:
 static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 {
 	struct tx_buf *tx_buf = NULL, *tx_buf_tmp = NULL;
+	unsigned long flags;
 
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_buf, list) {
@@ -597,6 +625,10 @@ static void ath9k_hif_usb_dealloc_tx_urbs(struct hif_device_usb *hif_dev)
 		kfree(tx_buf);
 	}
 
+	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
+	hif_dev->tx.flags |= HIF_USB_TX_FLUSH;
+	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
+
 	list_for_each_entry_safe(tx_buf, tx_buf_tmp,
 				 &hif_dev->tx.tx_pending, list) {
 		usb_kill_urb(tx_buf->urb);
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index e4a5e2e..7b9d863 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -64,6 +64,7 @@ struct tx_buf {
 };
 
 #define HIF_USB_TX_STOP  BIT(0)
+#define HIF_USB_TX_FLUSH BIT(1)
 
 struct hif_usb_tx {
 	u8 flags;
-- 
1.7.3.4

