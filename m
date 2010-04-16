Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22973 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab0DPGYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 02:24:40 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 23:24:40 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19400.640.637451.935311@gargle.gargle.HOWL>
Date: Fri, 16 Apr 2010 11:54:00 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/10] ath9k_htc: Add dropped SKB count to debugfs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |   13 +++++++++----
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 +++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index fe994e2..3091bb3 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -129,6 +129,7 @@ static void hif_usb_tx_cb(struct urb *urb)
 				TX_STAT_INC(skb_completed);
 			} else {
 				dev_kfree_skb_any(skb);
+				TX_STAT_INC(skb_dropped);
 			}
 		}
 
@@ -149,11 +150,15 @@ static void hif_usb_tx_cb(struct urb *urb)
 	}
 }
 
-static inline void ath9k_skb_queue_purge(struct sk_buff_head *list)
+static inline void ath9k_skb_queue_purge(struct hif_device_usb *hif_dev,
+					 struct sk_buff_head *list)
 {
 	struct sk_buff *skb;
-	while ((skb = __skb_dequeue(list)) != NULL)
+
+	while ((skb = __skb_dequeue(list)) != NULL) {
 		dev_kfree_skb_any(skb);
+		TX_STAT_INC(skb_dropped);
+	}
 }
 
 /* TX lock has to be taken */
@@ -214,7 +219,7 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 	ret = usb_submit_urb(tx_buf->urb, GFP_ATOMIC);
 	if (ret) {
 		tx_buf->len = tx_buf->offset = 0;
-		ath9k_skb_queue_purge(&tx_buf->skb_queue);
+		ath9k_skb_queue_purge(hif_dev, &tx_buf->skb_queue);
 		__skb_queue_head_init(&tx_buf->skb_queue);
 		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
 		hif_dev->tx.tx_buf_cnt++;
@@ -281,7 +286,7 @@ static void hif_usb_stop(void *hif_handle, u8 pipe_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
-	ath9k_skb_queue_purge(&hif_dev->tx.tx_skb_queue);
+	ath9k_skb_queue_purge(hif_dev, &hif_dev->tx.tx_skb_queue);
 	hif_dev->tx.tx_skb_cnt = 0;
 	hif_dev->tx.flags |= HIF_USB_TX_STOP;
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 78213fc..6a4614a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -261,6 +261,7 @@ struct ath_tx_stats {
 	u32 buf_completed;
 	u32 skb_queued;
 	u32 skb_completed;
+	u32 skb_dropped;
 };
 
 struct ath_rx_stats {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 2cea577..081f445 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -609,6 +609,9 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "SKBs completed",
 			priv->debug.tx_stats.skb_completed);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "SKBs dropped",
+			priv->debug.tx_stats.skb_dropped);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
-- 
1.7.0.5

