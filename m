Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47560 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0LMLk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:26 -0500
Received: by mail-ew0-f45.google.com with SMTP id 10so3803451ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:25 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/17] rt2x00: Protect queue control with mutex
Date: Mon, 13 Dec 2010 12:35:17 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131234.23502.IvDoorn@gmail.com> <201012131234.55604.IvDoorn@gmail.com>
In-Reply-To: <201012131234.55604.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131235.19063.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add wrapper functions in rt2x00queue.c to
start & stop queues. This control must be protected
using a mutex.

Queues can also be paused which will halt the flow
of packets between the driver and mac80211. This doesn't
require a mutex protection.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |   52 ++++++++
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c  |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   22 +---
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    9 --
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    8 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c  |  130 ++++++++++++++++++--
 drivers/net/wireless/rt2x00/rt2x00queue.h  |   23 ++++
 drivers/net/wireless/rt2x00/rt2x00usb.c    |  190 ++++++++++++++--------------
 9 files changed, 302 insertions(+), 141 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 617d68f..511ca91 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1072,6 +1072,58 @@ struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 					  enum queue_index index);
 
+/**
+ * rt2x00queue_pause_queue - Pause a data queue
+ * @queue: Pointer to &struct data_queue.
+ *
+ * This function will pause the data queue locally, preventing
+ * new frames to be added to the queue (while the hardware is
+ * still allowed to run).
+ */
+void rt2x00queue_pause_queue(struct data_queue *queue);
+
+/**
+ * rt2x00queue_unpause_queue - unpause a data queue
+ * @queue: Pointer to &struct data_queue.
+ *
+ * This function will unpause the data queue locally, allowing
+ * new frames to be added to the queue again.
+ */
+void rt2x00queue_unpause_queue(struct data_queue *queue);
+
+/**
+ * rt2x00queue_start_queue - Start a data queue
+ * @queue: Pointer to &struct data_queue.
+ *
+ * This function will start handling all pending frames in the queue.
+ */
+void rt2x00queue_start_queue(struct data_queue *queue);
+
+/**
+ * rt2x00queue_stop_queue - Halt a data queue
+ * @queue: Pointer to &struct data_queue.
+ *
+ * This function will stop all pending frames in the queue.
+ */
+void rt2x00queue_stop_queue(struct data_queue *queue);
+
+/**
+ * rt2x00queue_start_queues - Start all data queues
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ *
+ * This function will loop through all available queues to start them
+ */
+void rt2x00queue_start_queues(struct rt2x00_dev *rt2x00dev);
+
+/**
+ * rt2x00queue_stop_queues - Halt all data queues
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ *
+ * This function will loop through all available queues to stop
+ * any pending frames.
+ */
+void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev);
+
 /*
  * Debugfs handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index d2f1f0a..70ca937 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -146,7 +146,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * else the changes will be ignored by the device.
 	 */
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00dev->ops->lib->stop_queue(rt2x00dev->rx);
+		rt2x00queue_stop_queue(rt2x00dev->rx);
 
 	/*
 	 * Write new antenna setup to device and reset the link tuner.
@@ -160,7 +160,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	memcpy(active, &config, sizeof(config));
 
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00dev->ops->lib->start_queue(rt2x00dev->rx);
+		rt2x00queue_start_queue(rt2x00dev->rx);
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 64dfb1f..c92db32 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -339,12 +339,13 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 		return -ENOMEM;
 
 	temp = data +
-	    sprintf(data, "qid\tcount\tlimit\tlength\tindex\tdma done\tdone\n");
+	    sprintf(data, "qid\tflags\t\tcount\tlimit\tlength\tindex\tdma done\tdone\n");
 
 	queue_for_each(intf->rt2x00dev, queue) {
 		spin_lock_irqsave(&queue->index_lock, irqflags);
 
-		temp += sprintf(temp, "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", queue->qid,
+		temp += sprintf(temp, "%d\t0x%.8x\t%d\t%d\t%d\t%d\t%d\t\t%d\n",
+				queue->qid, (unsigned int)queue->flags,
 				queue->count, queue->limit, queue->length,
 				queue->index[Q_INDEX],
 				queue->index[Q_INDEX_DMA_DONE],
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 8d864b6..fbc98dd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -66,9 +66,9 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	set_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags);
 
 	/*
-	 * Enable RX.
+	 * Enable queues.
 	 */
-	rt2x00dev->ops->lib->start_queue(rt2x00dev->rx);
+	rt2x00queue_start_queues(rt2x00dev);
 	rt2x00link_start_tuner(rt2x00dev);
 
 	/*
@@ -76,11 +76,6 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00link_start_watchdog(rt2x00dev);
 
-	/*
-	 * Start the TX queues.
-	 */
-	ieee80211_wake_queues(rt2x00dev->hw);
-
 	return 0;
 }
 
@@ -90,21 +85,15 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
-	 * Stop the TX queues in mac80211.
-	 */
-	ieee80211_stop_queues(rt2x00dev->hw);
-	rt2x00queue_stop_queues(rt2x00dev);
-
-	/*
 	 * Stop watchdog monitoring.
 	 */
 	rt2x00link_stop_watchdog(rt2x00dev);
 
 	/*
-	 * Disable RX.
+	 * Stop all queues
 	 */
 	rt2x00link_stop_tuner(rt2x00dev);
-	rt2x00dev->ops->lib->stop_queue(rt2x00dev->rx);
+	rt2x00queue_stop_queues(rt2x00dev);
 
 	/*
 	 * Disable radio.
@@ -249,7 +238,6 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 	unsigned int header_length, i;
 	u8 rate_idx, rate_flags, retry_rates;
 	u8 skbdesc_flags = skbdesc->flags;
@@ -400,7 +388,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * is reenabled when the txdone handler has finished.
 	 */
 	if (!rt2x00queue_threshold(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, qid);
+		rt2x00queue_unpause_queue(entry->queue);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 2cf68f8..a105c50 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -178,15 +178,6 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index);
 
 /**
- * rt2x00queue_stop_queues - Halt all data queues
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- *
- * This function will loop through all available queues to stop
- * any pending outgoing frames.
- */
-void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev);
-
-/**
  * rt2x00queue_init_queues - Initialize all data queues
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  *
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 6713f1a..c4abb20 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -104,7 +104,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	enum data_queue_qid qid = skb_get_queue_mapping(skb);
-	struct data_queue *queue;
+	struct data_queue *queue = NULL;
 
 	/*
 	 * Mac80211 might be calling this function while we are trying
@@ -153,7 +153,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto exit_fail;
 
 	if (rt2x00queue_threshold(queue))
-		ieee80211_stop_queue(rt2x00dev->hw, qid);
+		rt2x00queue_pause_queue(queue);
 
 	return NETDEV_TX_OK;
 
@@ -352,7 +352,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	 * if for any reason the link tuner must be reset, this will be
 	 * handled by rt2x00lib_config().
 	 */
-	rt2x00dev->ops->lib->stop_queue(rt2x00dev->rx);
+	rt2x00queue_stop_queue(rt2x00dev->rx);
 
 	/*
 	 * When we've just turned on the radio, we want to reprogram
@@ -370,7 +370,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	rt2x00lib_config_antenna(rt2x00dev, rt2x00dev->default_ant);
 
 	/* Turn RX back on */
-	rt2x00dev->ops->lib->start_queue(rt2x00dev->rx);
+	rt2x00queue_start_queue(rt2x00dev->rx);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 2af6cea..558965f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -585,7 +585,7 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	rt2x00queue_free_skb(intf->beacon);
 
 	if (!enable_beacon) {
-		rt2x00dev->ops->lib->stop_queue(intf->beacon->queue);
+		rt2x00queue_stop_queue(intf->beacon->queue);
 		mutex_unlock(&intf->beacon_skb_mutex);
 		return 0;
 	}
@@ -738,6 +738,125 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 }
 
+void rt2x00queue_pause_queue(struct data_queue *queue)
+{
+	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags) ||
+	    !test_bit(QUEUE_STARTED, &queue->flags) ||
+	    test_and_set_bit(QUEUE_PAUSED, &queue->flags))
+		return;
+
+	switch (queue->qid) {
+	case QID_AC_BE:
+	case QID_AC_BK:
+	case QID_AC_VI:
+	case QID_AC_VO:
+		/*
+		 * For TX queues, we have to disable the queue
+		 * inside mac80211.
+		 */
+		ieee80211_stop_queue(queue->rt2x00dev->hw, queue->qid);
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_pause_queue);
+
+void rt2x00queue_unpause_queue(struct data_queue *queue)
+{
+	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags) ||
+	    !test_bit(QUEUE_STARTED, &queue->flags) ||
+	    !test_and_clear_bit(QUEUE_PAUSED, &queue->flags))
+		return;
+
+	switch (queue->qid) {
+	case QID_AC_BE:
+	case QID_AC_BK:
+	case QID_AC_VI:
+	case QID_AC_VO:
+		/*
+		 * For TX queues, we have to enable the queue
+		 * inside mac80211.
+		 */
+		ieee80211_wake_queue(queue->rt2x00dev->hw, queue->qid);
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_unpause_queue);
+
+void rt2x00queue_start_queue(struct data_queue *queue)
+{
+	mutex_lock(&queue->status_lock);
+
+	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags) ||
+	    test_and_set_bit(QUEUE_STARTED, &queue->flags)) {
+		mutex_unlock(&queue->status_lock);
+		return;
+	}
+
+	set_bit(QUEUE_PAUSED, &queue->flags);
+
+	queue->rt2x00dev->ops->lib->start_queue(queue);
+
+	rt2x00queue_unpause_queue(queue);
+
+	mutex_unlock(&queue->status_lock);
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_start_queue);
+
+void rt2x00queue_stop_queue(struct data_queue *queue)
+{
+	mutex_lock(&queue->status_lock);
+
+	if (!test_and_clear_bit(QUEUE_STARTED, &queue->flags)) {
+		mutex_unlock(&queue->status_lock);
+		return;
+	}
+
+	rt2x00queue_pause_queue(queue);
+
+	queue->rt2x00dev->ops->lib->stop_queue(queue);
+
+	mutex_unlock(&queue->status_lock);
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_stop_queue);
+
+void rt2x00queue_start_queues(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+
+	/*
+	 * rt2x00queue_start_queue will call ieee80211_wake_queue
+	 * for each queue after is has been properly initialized.
+	 */
+	tx_queue_for_each(rt2x00dev, queue)
+		rt2x00queue_start_queue(queue);
+
+	rt2x00queue_start_queue(rt2x00dev->rx);
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_start_queues);
+
+void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+
+	/*
+	 * rt2x00queue_stop_queue will call ieee80211_stop_queue
+	 * as well, but we are completely shutting doing everything
+	 * now, so it is much safer to stop all TX queues at once,
+	 * and use rt2x00queue_stop_queue for cleaning up.
+	 */
+	ieee80211_stop_queues(rt2x00dev->hw);
+
+	tx_queue_for_each(rt2x00dev, queue)
+		rt2x00queue_stop_queue(queue);
+
+	rt2x00queue_stop_queue(rt2x00dev->rx);
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_stop_queues);
+
 static void rt2x00queue_reset(struct data_queue *queue)
 {
 	unsigned long irqflags;
@@ -756,14 +875,6 @@ static void rt2x00queue_reset(struct data_queue *queue)
 	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 }
 
-void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev)
-{
-	struct data_queue *queue;
-
-	txall_queue_for_each(rt2x00dev, queue)
-		rt2x00dev->ops->lib->stop_queue(queue);
-}
-
 void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
@@ -905,6 +1016,7 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev)
 static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 			     struct data_queue *queue, enum data_queue_qid qid)
 {
+	mutex_init(&queue->status_lock);
 	spin_lock_init(&queue->index_lock);
 
 	queue->rt2x00dev = rt2x00dev;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 29b051a..baa39b7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -392,12 +392,32 @@ enum queue_index {
 };
 
 /**
+ * enum data_queue_flags: Status flags for data queues
+ *
+ * @QUEUE_STARTED: The queue has been started. Fox RX queues this means the
+ *	device might be DMA'ing skbuffers. TX queues will accept skbuffers to
+ *	be transmitted and beacon queues will start beaconing the configured
+ *	beacons.
+ * @QUEUE_PAUSED: The queue has been started but is currently paused.
+ *	When this bit is set, the queue has been stopped in mac80211,
+ *	preventing new frames to be enqueued. However, a few frames
+ *	might still appear shortly after the pausing...
+ */
+enum data_queue_flags {
+	QUEUE_STARTED,
+	QUEUE_PAUSED,
+};
+
+/**
  * struct data_queue: Data queue
  *
  * @rt2x00dev: Pointer to main &struct rt2x00dev where this queue belongs to.
  * @entries: Base address of the &struct queue_entry which are
  *	part of this queue.
  * @qid: The queue identification, see &enum data_queue_qid.
+ * @flags: Entry flags, see &enum queue_entry_flags.
+ * @status_lock: The mutex for protecting the start/stop/flush
+ *	handling on this queue.
  * @index_lock: Spinlock to protect index handling. Whenever @index, @index_done or
  *	@index_crypt needs to be changed this lock should be grabbed to prevent
  *	index corruption due to concurrency.
@@ -421,8 +441,11 @@ struct data_queue {
 	struct queue_entry *entries;
 
 	enum data_queue_qid qid;
+	unsigned long flags;
 
+	struct mutex status_lock;
 	spinlock_t index_lock;
+
 	unsigned int count;
 	unsigned short limit;
 	unsigned short threshold;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index d4361dc..fca29ae 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -261,6 +261,89 @@ static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 	}
 }
 
+/*
+ * RX data handlers.
+ */
+static void rt2x00usb_work_rxdone(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, rxdone_work);
+	struct queue_entry *entry;
+	struct skb_frame_desc *skbdesc;
+	u8 rxd[32];
+
+	while (!rt2x00queue_empty(rt2x00dev->rx)) {
+		entry = rt2x00queue_get_entry(rt2x00dev->rx, Q_INDEX_DONE);
+
+		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+			break;
+
+		/*
+		 * Fill in desc fields of the skb descriptor
+		 */
+		skbdesc = get_skb_frame_desc(entry->skb);
+		skbdesc->desc = rxd;
+		skbdesc->desc_len = entry->queue->desc_size;
+
+		/*
+		 * Send the frame to rt2x00lib for further processing.
+		 */
+		rt2x00lib_rxdone(entry);
+	}
+}
+
+static void rt2x00usb_interrupt_rxdone(struct urb *urb)
+{
+	struct queue_entry *entry = (struct queue_entry *)urb->context;
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+
+	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+		return;
+
+	/*
+	 * Report the frame as DMA done
+	 */
+	rt2x00lib_dmadone(entry);
+
+	/*
+	 * Check if the received data is simply too small
+	 * to be actually valid, or if the urb is signaling
+	 * a problem.
+	 */
+	if (urb->actual_length < entry->queue->desc_size || urb->status)
+		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
+
+	/*
+	 * Schedule the delayed work for reading the RX status
+	 * from the device.
+	 */
+	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
+}
+
+static void rt2x00usb_kick_rx_entry(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
+	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
+	int status;
+
+	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+		return;
+
+	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
+			  usb_rcvbulkpipe(usb_dev, entry->queue->usb_endpoint),
+			  entry->skb->data, entry->skb->len,
+			  rt2x00usb_interrupt_rxdone, entry);
+
+	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
+	if (status) {
+		if (status == -ENODEV)
+			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
+		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
+		rt2x00lib_dmadone(entry);
+	}
+}
+
 void rt2x00usb_kick_queue(struct data_queue *queue)
 {
 	switch (queue->qid) {
@@ -272,6 +355,11 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
 			rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
 						   rt2x00usb_kick_tx_entry);
 		break;
+	case QID_RX:
+		if (!rt2x00queue_full(queue))
+			rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
+						   rt2x00usb_kick_rx_entry);
+		break;
 	default:
 		break;
 	}
@@ -307,7 +395,6 @@ EXPORT_SYMBOL_GPL(rt2x00usb_stop_queue);
 static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 {
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	unsigned short threshold = queue->threshold;
 
 	WARNING(queue->rt2x00dev, "TX queue %d DMA timed out,"
 		" invoke forced forced reset\n", queue->qid);
@@ -315,18 +402,8 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 	/*
 	 * Temporarily disable the TX queue, this will force mac80211
 	 * to use the other queues until this queue has been restored.
-	 *
-	 * Set the queue threshold to the queue limit. This prevents the
-	 * queue from being enabled during the txdone handler.
 	 */
-	queue->threshold = queue->limit;
-	ieee80211_stop_queue(rt2x00dev->hw, queue->qid);
-
-	/*
-	 * Kill all entries in the queue, afterwards we need to
-	 * wait a bit for all URBs to be cancelled.
-	 */
-	rt2x00usb_stop_queue(queue);
+	rt2x00queue_stop_queue(queue);
 
 	/*
 	 * In case that a driver has overriden the txdone_work
@@ -338,8 +415,7 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 	 * The queue has been reset, and mac80211 is allowed to use the
 	 * queue again.
 	 */
-	queue->threshold = threshold;
-	ieee80211_wake_queue(rt2x00dev->hw, queue->qid);
+	rt2x00queue_start_queue(queue);
 }
 
 static void rt2x00usb_watchdog_tx_status(struct data_queue *queue)
@@ -366,73 +442,12 @@ void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev)
 EXPORT_SYMBOL_GPL(rt2x00usb_watchdog);
 
 /*
- * RX data handlers.
- */
-static void rt2x00usb_work_rxdone(struct work_struct *work)
-{
-	struct rt2x00_dev *rt2x00dev =
-	    container_of(work, struct rt2x00_dev, rxdone_work);
-	struct queue_entry *entry;
-	struct skb_frame_desc *skbdesc;
-	u8 rxd[32];
-
-	while (!rt2x00queue_empty(rt2x00dev->rx)) {
-		entry = rt2x00queue_get_entry(rt2x00dev->rx, Q_INDEX_DONE);
-
-		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
-			break;
-
-		/*
-		 * Fill in desc fields of the skb descriptor
-		 */
-		skbdesc = get_skb_frame_desc(entry->skb);
-		skbdesc->desc = rxd;
-		skbdesc->desc_len = entry->queue->desc_size;
-
-		/*
-		 * Send the frame to rt2x00lib for further processing.
-		 */
-		rt2x00lib_rxdone(entry);
-	}
-}
-
-static void rt2x00usb_interrupt_rxdone(struct urb *urb)
-{
-	struct queue_entry *entry = (struct queue_entry *)urb->context;
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-
-	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
-		return;
-
-	/*
-	 * Report the frame as DMA done
-	 */
-	rt2x00lib_dmadone(entry);
-
-	/*
-	 * Check if the received data is simply too small
-	 * to be actually valid, or if the urb is signaling
-	 * a problem.
-	 */
-	if (urb->actual_length < entry->queue->desc_size || urb->status)
-		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
-
-	/*
-	 * Schedule the delayed work for reading the RX status
-	 * from the device.
-	 */
-	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
-}
-
-/*
  * Radio handlers
  */
 void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_RX_CONTROL, 0, 0,
 				    REGISTER_TIMEOUT);
-
-	rt2x00dev->ops->lib->stop_queue(rt2x00dev->rx);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
 
@@ -441,31 +456,10 @@ EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
  */
 void rt2x00usb_clear_entry(struct queue_entry *entry)
 {
-	struct usb_device *usb_dev =
-	    to_usb_device_intf(entry->queue->rt2x00dev->dev);
-	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
-	int pipe;
-	int status;
-
 	entry->flags = 0;
 
-	if (entry->queue->qid == QID_RX) {
-		pipe = usb_rcvbulkpipe(usb_dev, entry->queue->usb_endpoint);
-		usb_fill_bulk_urb(entry_priv->urb, usb_dev, pipe,
-				entry->skb->data, entry->skb->len,
-				rt2x00usb_interrupt_rxdone, entry);
-
-		set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-
-		status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
-		if (status) {
-			if (status == -ENODEV)
-				clear_bit(DEVICE_STATE_PRESENT,
-					  &entry->queue->rt2x00dev->flags);
-			set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
-			rt2x00lib_dmadone(entry);
-		}
-	}
+	if (entry->queue->qid == QID_RX)
+		rt2x00usb_kick_rx_entry(entry);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_clear_entry);
 
-- 
1.7.2.3

