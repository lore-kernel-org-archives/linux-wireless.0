Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47560 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab0LMLk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:27 -0500
Received: by mail-ew0-f45.google.com with SMTP id 10so3803451ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:27 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/17] rt2x00: Add "flush" queue command
Date: Mon, 13 Dec 2010 12:35:40 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131234.55604.IvDoorn@gmail.com> <201012131235.19063.IvDoorn@gmail.com>
In-Reply-To: <201012131235.19063.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131235.41811.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new command to the queue handlers: "flush",
this moves the flush() callback from mac80211
into rt2x00queue and adds support for flushing
the RX queue as well.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c   |    3 +-
 drivers/net/wireless/rt2x00/rt2800usb.c   |    3 +-
 drivers/net/wireless/rt2x00/rt2x00.h      |   21 +++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   32 +----------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   85 +++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   70 ++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |    4 +-
 drivers/net/wireless/rt2x00/rt73usb.c     |    3 +-
 9 files changed, 161 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index a56b38f..6b3b1de4 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -785,8 +785,6 @@ static void rt2500usb_stop_queue(struct data_queue *queue)
 	default:
 		break;
 	}
-
-	rt2x00usb_stop_queue(queue);
 }
 
 /*
@@ -1842,6 +1840,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.start_queue		= rt2500usb_start_queue,
 	.kick_queue		= rt2x00usb_kick_queue,
 	.stop_queue		= rt2500usb_stop_queue,
+	.flush_queue		= rt2x00usb_flush_queue,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
 	.write_beacon		= rt2500usb_write_beacon,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 60b5503..3e0205d 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -96,8 +96,6 @@ static void rt2800usb_stop_queue(struct data_queue *queue)
 	default:
 		break;
 	}
-
-	rt2x00usb_stop_queue(queue);
 }
 
 /*
@@ -623,6 +621,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.start_queue		= rt2800usb_start_queue,
 	.kick_queue		= rt2x00usb_kick_queue,
 	.stop_queue		= rt2800usb_stop_queue,
+	.flush_queue		= rt2x00usb_flush_queue,
 	.write_tx_desc		= rt2800usb_write_tx_desc,
 	.write_tx_data		= rt2800usb_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 511ca91..520e736 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -575,6 +575,7 @@ struct rt2x00lib_ops {
 	void (*start_queue) (struct data_queue *queue);
 	void (*kick_queue) (struct data_queue *queue);
 	void (*stop_queue) (struct data_queue *queue);
+	void (*flush_queue) (struct data_queue *queue);
 
 	/*
 	 * TX control handlers
@@ -1108,6 +1109,16 @@ void rt2x00queue_start_queue(struct data_queue *queue);
 void rt2x00queue_stop_queue(struct data_queue *queue);
 
 /**
+ * rt2x00queue_flush_queue - Flush a data queue
+ * @queue: Pointer to &struct data_queue.
+ * @drop: True to drop all pending frames.
+ *
+ * This function will flush the queue. After this call
+ * the queue is guarenteed to be empty.
+ */
+void rt2x00queue_flush_queue(struct data_queue *queue, bool drop);
+
+/**
  * rt2x00queue_start_queues - Start all data queues
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  *
@@ -1124,6 +1135,16 @@ void rt2x00queue_start_queues(struct rt2x00_dev *rt2x00dev);
  */
 void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev);
 
+/**
+ * rt2x00queue_flush_queues - Flush all data queues
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @drop: True to drop all pending frames.
+ *
+ * This function will loop through all available queues to flush
+ * any pending frames.
+ */
+void rt2x00queue_flush_queues(struct rt2x00_dev *rt2x00dev, bool drop);
+
 /*
  * Debugfs handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index fbc98dd..01c8415 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -94,6 +94,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00link_stop_tuner(rt2x00dev);
 	rt2x00queue_stop_queues(rt2x00dev);
+	rt2x00queue_flush_queues(rt2x00dev, true);
 
 	/*
 	 * Disable radio.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index c4abb20..4cac7ad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -718,36 +718,8 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_queue *queue;
-	unsigned int i = 0;
 
-	ieee80211_stop_queues(hw);
-
-	/*
-	 * Run over all queues to kick them, this will force
-	 * any pending frames to be transmitted.
-	 */
-	tx_queue_for_each(rt2x00dev, queue) {
-		rt2x00dev->ops->lib->kick_queue(queue);
-	}
-
-	/**
-	 * All queues have been kicked, now wait for each queue
-	 * to become empty. With a bit of luck, we only have to wait
-	 * for the first queue to become empty, because while waiting
-	 * for the that queue, the other queues will have transmitted
-	 * all their frames as well (since they were already kicked).
-	 */
-	tx_queue_for_each(rt2x00dev, queue) {
-		for (i = 0; i < 10; i++) {
-			if (rt2x00queue_empty(queue))
-				break;
-			msleep(100);
-		}
-
-		if (!rt2x00queue_empty(queue))
-			WARNING(rt2x00dev, "Failed to flush queue %d\n", queue->qid);
-	}
-
-	ieee80211_wake_queues(hw);
+	tx_queue_for_each(rt2x00dev, queue)
+		rt2x00queue_flush_queue(queue, drop);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_flush);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 558965f..313a8fa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -780,6 +780,12 @@ void rt2x00queue_unpause_queue(struct data_queue *queue)
 		 */
 		ieee80211_wake_queue(queue->rt2x00dev->hw, queue->qid);
 		break;
+	case QID_RX:
+		/*
+		 * For RX we need to kick the queue now in order to
+		 * receive frames.
+		 */
+		queue->rt2x00dev->ops->lib->kick_queue(queue);
 	default:
 		break;
 	}
@@ -823,6 +829,74 @@ void rt2x00queue_stop_queue(struct data_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_stop_queue);
 
+void rt2x00queue_flush_queue(struct data_queue *queue, bool drop)
+{
+	unsigned int i;
+	bool started;
+	bool tx_queue =
+		(queue->qid == QID_AC_BE) ||
+		(queue->qid == QID_AC_BK) ||
+		(queue->qid == QID_AC_VI) ||
+		(queue->qid == QID_AC_VO);
+
+	mutex_lock(&queue->status_lock);
+
+	/*
+	 * If the queue has been started, we must stop it temporarily
+	 * to prevent any new frames to be queued on the device. If
+	 * we are not dropping the pending frames, the queue must
+	 * only be stopped in the software and not the hardware,
+	 * otherwise the queue will never become empty on its own.
+	 */
+	started = test_bit(QUEUE_STARTED, &queue->flags);
+	if (started) {
+		/*
+		 * Pause the queue
+		 */
+		rt2x00queue_pause_queue(queue);
+
+		/*
+		 * If we are not supposed to drop any pending
+		 * frames, this means we must force a start (=kick)
+		 * to the queue to make sure the hardware will
+		 * start transmitting.
+		 */
+		if (!drop && tx_queue)
+			queue->rt2x00dev->ops->lib->kick_queue(queue);
+	}
+
+	/*
+	 * Check if driver supports flushing, we can only guarentee
+	 * full support for flushing if the driver is able
+	 * to cancel all pending frames (drop = true).
+	 */
+	if (drop && queue->rt2x00dev->ops->lib->flush_queue)
+		queue->rt2x00dev->ops->lib->flush_queue(queue);
+
+	/*
+	 * When we don't want to drop any frames, or when
+	 * the driver doesn't fully flush the queue correcly,
+	 * we must wait for the queue to become empty.
+	 */
+	for (i = 0; !rt2x00queue_empty(queue) && i < 100; i++)
+		msleep(10);
+
+	/*
+	 * The queue flush has failed...
+	 */
+	if (unlikely(!rt2x00queue_empty(queue)))
+		WARNING(queue->rt2x00dev, "Queue %d failed to flush", queue->qid);
+
+	/*
+	 * Restore the queue to the previous status
+	 */
+	if (started)
+		rt2x00queue_unpause_queue(queue);
+
+	mutex_unlock(&queue->status_lock);
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_flush_queue);
+
 void rt2x00queue_start_queues(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
@@ -857,6 +931,17 @@ void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_stop_queues);
 
+void rt2x00queue_flush_queues(struct rt2x00_dev *rt2x00dev, bool drop)
+{
+	struct data_queue *queue;
+
+	tx_queue_for_each(rt2x00dev, queue)
+		rt2x00queue_flush_queue(queue, drop);
+
+	rt2x00queue_flush_queue(rt2x00dev->rx, drop);
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_flush_queues);
+
 static void rt2x00queue_reset(struct data_queue *queue)
 {
 	unsigned long irqflags;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index fca29ae..cd80eec 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -366,7 +366,7 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kick_queue);
 
-static void rt2x00usb_kill_entry(struct queue_entry *entry)
+static void rt2x00usb_flush_entry(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
@@ -385,37 +385,61 @@ static void rt2x00usb_kill_entry(struct queue_entry *entry)
 		usb_kill_urb(bcn_priv->guardian_urb);
 }
 
-void rt2x00usb_stop_queue(struct data_queue *queue)
+void rt2x00usb_flush_queue(struct data_queue *queue)
 {
+	struct work_struct *completion;
+	unsigned int i;
+
 	rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
-				   rt2x00usb_kill_entry);
+				   rt2x00usb_flush_entry);
+
+	/*
+	 * Obtain the queue completion handler
+	 */
+	switch (queue->qid) {
+	case QID_AC_BE:
+	case QID_AC_BK:
+	case QID_AC_VI:
+	case QID_AC_VO:
+		completion = &queue->rt2x00dev->txdone_work;
+		break;
+	case QID_RX:
+		completion = &queue->rt2x00dev->rxdone_work;
+		break;
+	default:
+		return;
+	}
+
+	for (i = 0; i < 20; i++) {
+		/*
+		 * Check if the driver is already done, otherwise we
+		 * have to sleep a little while to give the driver/hw
+		 * the oppurtunity to complete interrupt process itself.
+		 */
+		if (rt2x00queue_empty(queue))
+			break;
+
+		/*
+		 * Schedule the completion handler manually, when this
+		 * worker function runs, it should cleanup the queue.
+		 */
+		ieee80211_queue_work(queue->rt2x00dev->hw, completion);
+
+		/*
+		 * Wait for a little while to give the driver
+		 * the oppurtunity to recover itself.
+		 */
+		msleep(10);
+	}
 }
-EXPORT_SYMBOL_GPL(rt2x00usb_stop_queue);
+EXPORT_SYMBOL_GPL(rt2x00usb_flush_queue);
 
 static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 {
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-
 	WARNING(queue->rt2x00dev, "TX queue %d DMA timed out,"
 		" invoke forced forced reset\n", queue->qid);
 
-	/*
-	 * Temporarily disable the TX queue, this will force mac80211
-	 * to use the other queues until this queue has been restored.
-	 */
-	rt2x00queue_stop_queue(queue);
-
-	/*
-	 * In case that a driver has overriden the txdone_work
-	 * function, we invoke the TX done through there.
-	 */
-	rt2x00dev->txdone_work.func(&rt2x00dev->txdone_work);
-
-	/*
-	 * The queue has been reset, and mac80211 is allowed to use the
-	 * queue again.
-	 */
-	rt2x00queue_start_queue(queue);
+	rt2x00queue_flush_queue(queue, true);
 }
 
 static void rt2x00usb_watchdog_tx_status(struct data_queue *queue)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 05a5424..6aaf51f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -387,13 +387,13 @@ struct queue_entry_priv_usb_bcn {
 void rt2x00usb_kick_queue(struct data_queue *queue);
 
 /**
- * rt2x00usb_stop_queue - Stop data queue
+ * rt2x00usb_flush_queue - Flush data queue
  * @queue: Data queue to stop
  *
  * This will walk through all entries of the queue and kill all
  * URB's which were send to the device.
  */
-void rt2x00usb_stop_queue(struct data_queue *queue);
+void rt2x00usb_flush_queue(struct data_queue *queue);
 
 /**
  * rt2x00usb_watchdog - Watchdog for USB communication
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index f55e74e..0b3959b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1077,8 +1077,6 @@ static void rt73usb_stop_queue(struct data_queue *queue)
 	default:
 		break;
 	}
-
-	rt2x00usb_stop_queue(queue);
 }
 
 /*
@@ -2309,6 +2307,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.start_queue		= rt73usb_start_queue,
 	.kick_queue		= rt2x00usb_kick_queue,
 	.stop_queue		= rt73usb_stop_queue,
+	.flush_queue		= rt2x00usb_flush_queue,
 	.write_tx_desc		= rt73usb_write_tx_desc,
 	.write_beacon		= rt73usb_write_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
-- 
1.7.2.3

