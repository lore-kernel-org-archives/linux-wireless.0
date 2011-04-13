Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35840 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab1DMFxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:53:35 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so276432iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:53:35 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15087.911814.545439@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:25:59 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 30/40] ath9k_htc: Drain pending TX frames properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

When doing a channel set or a reset operation the pending
frames queued up for transmission have to be flushed and
sent to mac80211. Fixing this has to be done in two separate
steps:

  * Flush queued frames and kill the URB TX completion handler.
  * Complete all the frames that in the TX pending queue.

This patch adds proper support for draining and all the callsites
namely, channel change/reset/idle/stop are fixed. A separate queue
is used for handling failed frames.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c       |   55 +++++++++---------------
 drivers/net/wireless/ath/ath9k/htc.h           |    6 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |    8 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c  |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |   15 ++++---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c  |   31 +++++++++++++-
 6 files changed, 69 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 09b416a..a98b146 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -131,7 +131,19 @@ static inline void ath9k_skb_queue_purge(struct hif_device_usb *hif_dev,
 
 	while ((skb = __skb_dequeue(list)) != NULL) {
 		dev_kfree_skb_any(skb);
-		TX_STAT_INC(skb_dropped);
+	}
+}
+
+static inline void ath9k_skb_queue_complete(struct hif_device_usb *hif_dev,
+					    struct sk_buff_head *queue,
+					    bool txok)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(queue)) != NULL) {
+		ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
+					  skb, txok);
+		(txok) ? TX_STAT_INC(skb_success) : TX_STAT_INC(skb_failed);
 	}
 }
 
@@ -139,7 +151,7 @@ static void hif_usb_tx_cb(struct urb *urb)
 {
 	struct tx_buf *tx_buf = (struct tx_buf *) urb->context;
 	struct hif_device_usb *hif_dev;
-	struct sk_buff *skb;
+	bool txok = true;
 
 	if (!tx_buf || !tx_buf->hif_dev)
 		return;
@@ -153,10 +165,7 @@ static void hif_usb_tx_cb(struct urb *urb)
 	case -ECONNRESET:
 	case -ENODEV:
 	case -ESHUTDOWN:
-		/*
-		 * The URB has been killed, free the SKBs.
-		 */
-		ath9k_skb_queue_purge(hif_dev, &tx_buf->skb_queue);
+		txok = false;
 
 		/*
 		 * If the URBs are being flushed, no need to add this
@@ -165,41 +174,19 @@ static void hif_usb_tx_cb(struct urb *urb)
 		spin_lock(&hif_dev->tx.tx_lock);
 		if (hif_dev->tx.flags & HIF_USB_TX_FLUSH) {
 			spin_unlock(&hif_dev->tx.tx_lock);
+			ath9k_skb_queue_purge(hif_dev, &tx_buf->skb_queue);
 			return;
 		}
 		spin_unlock(&hif_dev->tx.tx_lock);
 
-		/*
-		 * In the stop() case, this URB has to be added to
-		 * the free list.
-		 */
-		goto add_free;
+		break;
 	default:
+		txok = false;
 		break;
 	}
 
-	/*
-	 * Check if TX has been stopped, this is needed because
-	 * this CB could have been invoked just after the TX lock
-	 * was released in hif_stop() and kill_urb() hasn't been
-	 * called yet.
-	 */
-	spin_lock(&hif_dev->tx.tx_lock);
-	if (hif_dev->tx.flags & HIF_USB_TX_STOP) {
-		spin_unlock(&hif_dev->tx.tx_lock);
-		ath9k_skb_queue_purge(hif_dev, &tx_buf->skb_queue);
-		goto add_free;
-	}
-	spin_unlock(&hif_dev->tx.tx_lock);
-
-	/* Complete the queued SKBs. */
-	while ((skb = __skb_dequeue(&tx_buf->skb_queue)) != NULL) {
-		ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
-					  skb, 1);
-		TX_STAT_INC(skb_completed);
-	}
+	ath9k_skb_queue_complete(hif_dev, &tx_buf->skb_queue, txok);
 
-add_free:
 	/* Re-initialize the SKB queue */
 	tx_buf->len = tx_buf->offset = 0;
 	__skb_queue_head_init(&tx_buf->skb_queue);
@@ -272,7 +259,7 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 	ret = usb_submit_urb(tx_buf->urb, GFP_ATOMIC);
 	if (ret) {
 		tx_buf->len = tx_buf->offset = 0;
-		ath9k_skb_queue_purge(hif_dev, &tx_buf->skb_queue);
+		ath9k_skb_queue_complete(hif_dev, &tx_buf->skb_queue, false);
 		__skb_queue_head_init(&tx_buf->skb_queue);
 		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
 		hif_dev->tx.tx_buf_cnt++;
@@ -342,7 +329,7 @@ static void hif_usb_stop(void *hif_handle, u8 pipe_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
-	ath9k_skb_queue_purge(hif_dev, &hif_dev->tx.tx_skb_queue);
+	ath9k_skb_queue_complete(hif_dev, &hif_dev->tx.tx_skb_queue, false);
 	hif_dev->tx.tx_skb_cnt = 0;
 	hif_dev->tx.flags |= HIF_USB_TX_STOP;
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 45cf755..0d2e2b1 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -271,6 +271,7 @@ struct ath9k_htc_tx {
 	u8 flags;
 	int queued_cnt;
 	struct sk_buff_head tx_queue;
+	struct sk_buff_head tx_failed;
 	DECLARE_BITMAP(tx_slot, MAX_TX_BUF_NUM);
 	spinlock_t tx_lock;
 };
@@ -305,8 +306,8 @@ struct ath_tx_stats {
 	u32 buf_queued;
 	u32 buf_completed;
 	u32 skb_queued;
-	u32 skb_completed;
-	u32 skb_dropped;
+	u32 skb_success;
+	u32 skb_failed;
 	u32 cab_queued;
 	u32 queue_stats[WME_NUM_AC];
 };
@@ -544,6 +545,7 @@ void ath9k_htc_check_stop_queues(struct ath9k_htc_priv *priv);
 void ath9k_htc_check_wake_queues(struct ath9k_htc_priv *priv);
 int ath9k_htc_tx_get_slot(struct ath9k_htc_priv *priv);
 void ath9k_htc_tx_clear_slot(struct ath9k_htc_priv *priv, int slot);
+void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv);
 
 int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 6fc6cb7..91a486c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -88,11 +88,11 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 			"%20s : %10u\n", "SKBs queued",
 			priv->debug.tx_stats.skb_queued);
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "SKBs completed",
-			priv->debug.tx_stats.skb_completed);
+			"%20s : %10u\n", "SKBs success",
+			priv->debug.tx_stats.skb_success);
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "SKBs dropped",
-			priv->debug.tx_stats.skb_dropped);
+			"%20s : %10u\n", "SKBs failed",
+			priv->debug.tx_stats.skb_failed);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "CAB queued",
 			priv->debug.tx_stats.cab_queued);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 92e4b31..dc0b33d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -429,9 +429,8 @@ void ath9k_htc_radio_disable(struct ieee80211_hw *hw)
 
 	/* Stop TX */
 	ieee80211_stop_queues(hw);
-	htc_stop(priv->htc);
+	ath9k_htc_tx_drain(priv);
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
-	skb_queue_purge(&priv->tx.tx_queue);
 
 	/* Stop RX */
 	WMI_CMD(WMI_STOP_RECV_CMDID);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c7e056b..fb9ff11 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -193,7 +193,9 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 
 	ath9k_htc_stop_ani(priv);
 	ieee80211_stop_queues(priv->hw);
-	htc_stop(priv->htc);
+
+	ath9k_htc_tx_drain(priv);
+
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
@@ -248,7 +250,9 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	fastcc = !!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL);
 
 	ath9k_htc_ps_wakeup(priv);
-	htc_stop(priv->htc);
+
+	ath9k_htc_tx_drain(priv);
+
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
@@ -263,6 +267,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 
 	if (!fastcc)
 		caldata = &priv->caldata;
+
 	ret = ath9k_hw_reset(ah, hchan, caldata, fastcc);
 	if (ret) {
 		ath_err(common,
@@ -960,16 +965,14 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	}
 
 	ath9k_htc_ps_wakeup(priv);
-	htc_stop(priv->htc);
+
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 
 	tasklet_kill(&priv->rx_tasklet);
-	tasklet_kill(&priv->tx_tasklet);
-
-	skb_queue_purge(&priv->tx.tx_queue);
 
+	ath9k_htc_tx_drain(priv);
 	ath9k_wmi_event_drain(priv);
 
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 944440c..9e0c34b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -423,6 +423,26 @@ send_mac80211:
 	ieee80211_tx_status(priv->hw, skb);
 }
 
+void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv)
+{
+	struct sk_buff *skb = NULL;
+
+	/*
+	 * Ensure that all pending TX frames are flushed,
+	 * and that the TX completion tasklet is killed.
+	 */
+	htc_stop(priv->htc);
+	tasklet_kill(&priv->tx_tasklet);
+
+	while ((skb = skb_dequeue(&priv->tx.tx_queue)) != NULL) {
+		ath9k_htc_tx_process(priv, skb);
+	}
+
+	while ((skb = skb_dequeue(&priv->tx.tx_failed)) != NULL) {
+		ath9k_htc_tx_process(priv, skb);
+	}
+}
+
 void ath9k_tx_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
@@ -432,6 +452,10 @@ void ath9k_tx_tasklet(unsigned long data)
 		ath9k_htc_tx_process(priv, skb);
 	}
 
+	while ((skb = skb_dequeue(&priv->tx.tx_failed)) != NULL) {
+		ath9k_htc_tx_process(priv, skb);
+	}
+
 	/* Wake TX queues if needed */
 	ath9k_htc_check_wake_queues(priv);
 }
@@ -445,13 +469,18 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 	tx_ctl = HTC_SKB_CB(skb);
 	tx_ctl->txok = txok;
 
-	skb_queue_tail(&priv->tx.tx_queue, skb);
+	if (txok)
+		skb_queue_tail(&priv->tx.tx_queue, skb);
+	else
+		skb_queue_tail(&priv->tx.tx_failed, skb);
+
 	tasklet_schedule(&priv->tx_tasklet);
 }
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv)
 {
 	skb_queue_head_init(&priv->tx.tx_queue);
+	skb_queue_head_init(&priv->tx.tx_failed);
 	return 0;
 }
 
-- 
1.7.4.4

