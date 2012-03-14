Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030720Ab2CNKQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 06:16:55 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/5] rt2x00: rt2800usb: rework txstatus code
Date: Wed, 14 Mar 2012 11:16:19 +0100
Message-Id: <1331720181-18564-3-git-send-email-sgruszka@redhat.com> (sfid-20120314_111701_195659_56667C26)
In-Reply-To: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
References: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we read tx status register after each urb data transfer. As
callback procedure also trigger reading, that causing we have many
"threads" of reading status. To prevent that introduce TX_STATUS_READING
flags, and check if we are already in process of sequential reading
TX_STA_FIFO, before requesting new reads.

Change timer to hrtimer, that make TX_STA_FIFO overruns less possible.
Use 200 us for initial timeout, and then reschedule in 100 us period,
this values probably have to be tuned.

Make changes on txdone work. Schedule it from
rt2800usb_tx_sta_fifo_read_completed() callback when first valid status
show up. Check in callback if tx status timeout happens, and schedule
work on that condition too. That make possible to remove tx status
timeout from generic watchdog. I moved that to rt2800usb.

Loop in txdone work, that should prevent situation when we queue work,
which is already processed, and after finish work is not rescheduled
again.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c   |  120 +++++++++++++++++++++-------
 drivers/net/wireless/rt2x00/rt2x00.h      |   10 ++-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h |   12 ---
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   21 +-----
 5 files changed, 101 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 4eaa628..eacf94b 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -114,45 +114,103 @@ static bool rt2800usb_txstatus_pending(struct rt2x00_dev *rt2x00dev)
 	return false;
 }
 
+static inline bool rt2800usb_entry_txstatus_timeout(struct queue_entry *entry)
+{
+	bool tout;
+
+	if (!test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
+		return false;
+
+	tout = time_after(jiffies, entry->last_action + msecs_to_jiffies(100));
+	if (unlikely(tout))
+		WARNING(entry->queue->rt2x00dev,
+			"TX status timeout for entry %d in queue %d\n",
+			entry->entry_idx, entry->queue->qid);
+	return tout;
+
+}
+
+static bool rt2800usb_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+	struct queue_entry *entry;
+
+	tx_queue_for_each(rt2x00dev, queue) {
+		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+		if (rt2800usb_entry_txstatus_timeout(entry))
+			return true;
+	}
+	return false;
+}
+
 static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 						 int urb_status, u32 tx_status)
 {
+	bool valid;
+
 	if (urb_status) {
-		WARNING(rt2x00dev, "rt2x00usb_register_read_async failed: %d\n", urb_status);
-		return false;
+		WARNING(rt2x00dev, "TX status read failed %d\n", urb_status);
+
+		goto stop_reading;
 	}
 
-	/* try to read all TX_STA_FIFO entries before scheduling txdone_work */
-	if (rt2x00_get_field32(tx_status, TX_STA_FIFO_VALID)) {
-		if (!kfifo_put(&rt2x00dev->txstatus_fifo, &tx_status)) {
-			WARNING(rt2x00dev, "TX status FIFO overrun, "
-				"drop tx status report.\n");
-			queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
-		} else
-			return true;
-	} else if (!kfifo_is_empty(&rt2x00dev->txstatus_fifo)) {
+	valid = rt2x00_get_field32(tx_status, TX_STA_FIFO_VALID);
+	if (valid) {
+		if (!kfifo_put(&rt2x00dev->txstatus_fifo, &tx_status))
+			WARNING(rt2x00dev, "TX status FIFO overrun\n");
+
 		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
+
+		/* Reschedule urb to read TX status again instantly */
+		return true;
 	} else if (rt2800usb_txstatus_pending(rt2x00dev)) {
-		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(2));
+		/* Read register after 250 us */
+		hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 250000),
+			      HRTIMER_MODE_REL);
+		return false;
 	}
 
-	return false;
+stop_reading:
+	clear_bit(TX_STATUS_READING, &rt2x00dev->flags);
+	/*
+	 * There is small race window above, between txstatus pending check and
+	 * clear_bit someone could do rt2x00usb_interrupt_txdone, so recheck
+	 * here again if status reading is needed.
+	 */
+	if (rt2800usb_txstatus_pending(rt2x00dev) &&
+	    test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
+		return true;
+	else
+		return false;
+}
+
+static void rt2800usb_async_read_tx_status(struct rt2x00_dev *rt2x00dev)
+{
+
+	if (test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
+		return;
+
+	/* Read TX_STA_FIFO register after 500 us */
+	hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 500000),
+		      HRTIMER_MODE_REL);
 }
 
 static void rt2800usb_tx_dma_done(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 
-	rt2x00usb_register_read_async(rt2x00dev, TX_STA_FIFO,
-				      rt2800usb_tx_sta_fifo_read_completed);
+	rt2800usb_async_read_tx_status(rt2x00dev);
 }
 
-static void rt2800usb_tx_sta_fifo_timeout(unsigned long data)
+static enum hrtimer_restart rt2800usb_tx_sta_fifo_timeout(struct hrtimer *timer)
 {
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(timer, struct rt2x00_dev, txstatus_timer);
 
 	rt2x00usb_register_read_async(rt2x00dev, TX_STA_FIFO,
 				      rt2800usb_tx_sta_fifo_read_completed);
+
+	return HRTIMER_NORESTART;
 }
 
 /*
@@ -540,7 +598,7 @@ static void rt2800usb_txdone_nostatus(struct rt2x00_dev *rt2x00dev)
 
 			if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
 				rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
-			else if (rt2x00queue_status_timeout(entry))
+			else if (rt2800usb_entry_txstatus_timeout(entry))
 				rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
 			else
 				break;
@@ -553,17 +611,21 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, txdone_work);
 
-	rt2800usb_txdone(rt2x00dev);
+	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo) ||
+	       rt2800usb_txstatus_timeout(rt2x00dev)) {
 
-	rt2800usb_txdone_nostatus(rt2x00dev);
+		rt2800usb_txdone(rt2x00dev);
 
-	/*
-	 * The hw may delay sending the packet after DMA complete
-	 * if the medium is busy, thus the TX_STA_FIFO entry is
-	 * also delayed -> use a timer to retrieve it.
-	 */
-	if (rt2800usb_txstatus_pending(rt2x00dev))
-		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(2));
+		rt2800usb_txdone_nostatus(rt2x00dev);
+
+		/*
+		 * The hw may delay sending the packet after DMA complete
+		 * if the medium is busy, thus the TX_STA_FIFO entry is
+		 * also delayed -> use a timer to retrieve it.
+		 */
+		if (rt2800usb_txstatus_pending(rt2x00dev))
+			rt2800usb_async_read_tx_status(rt2x00dev);
+	}
 }
 
 /*
@@ -705,9 +767,7 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
 	__set_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags);
 
-	setup_timer(&rt2x00dev->txstatus_timer,
-		    rt2800usb_tx_sta_fifo_timeout,
-		    (unsigned long) rt2x00dev);
+	rt2x00dev->txstatus_timer.function = rt2800usb_tx_sta_fifo_timeout,
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 65275ef..471f87c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -38,7 +38,7 @@
 #include <linux/etherdevice.h>
 #include <linux/input-polldev.h>
 #include <linux/kfifo.h>
-#include <linux/timer.h>
+#include <linux/hrtimer.h>
 
 #include <net/mac80211.h>
 
@@ -692,6 +692,12 @@ enum rt2x00_state_flags {
 	 */
 	CONFIG_CHANNEL_HT40,
 	CONFIG_POWERSAVING,
+
+	/*
+	 * Mark we currently are sequentially reading TX_STA_FIFO register
+	 * FIXME: this is for only rt2800usb, should go to private data
+	 */
+	TX_STATUS_READING,
 };
 
 /*
@@ -974,7 +980,7 @@ struct rt2x00_dev {
 	/*
 	 * Timer to ensure tx status reports are read (rt2800usb).
 	 */
-	struct timer_list txstatus_timer;
+	struct hrtimer txstatus_timer;
 
 	/*
 	 * Tasklet for processing tx status reports (rt2800pci).
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 61a5042..fc9901e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1236,7 +1236,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
 	cancel_work_sync(&rt2x00dev->sleep_work);
 	if (rt2x00_is_usb(rt2x00dev)) {
-		del_timer_sync(&rt2x00dev->txstatus_timer);
+		hrtimer_cancel(&rt2x00dev->txstatus_timer);
 		cancel_work_sync(&rt2x00dev->rxdone_work);
 		cancel_work_sync(&rt2x00dev->txdone_work);
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 349008d..5f1392c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -636,18 +636,6 @@ static inline int rt2x00queue_threshold(struct data_queue *queue)
 {
 	return rt2x00queue_available(queue) < queue->threshold;
 }
-
-/**
- * rt2x00queue_status_timeout - Check if a timeout occurred for STATUS reports
- * @entry: Queue entry to check.
- */
-static inline int rt2x00queue_status_timeout(struct queue_entry *entry)
-{
-	if (!test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
-		return false;
-	return time_after(jiffies, entry->last_action + msecs_to_jiffies(100));
-}
-
 /**
  * rt2x00queue_dma_timeout - Check if a timeout occurred for DMA transfers
  * @entry: Queue entry to check.
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 2eea386..66094eb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -526,22 +526,6 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 	rt2x00queue_flush_queue(queue, true);
 }
 
-static void rt2x00usb_watchdog_tx_status(struct data_queue *queue)
-{
-	WARNING(queue->rt2x00dev, "TX queue %d status timed out,"
-		" invoke forced tx handler\n", queue->qid);
-
-	queue_work(queue->rt2x00dev->workqueue, &queue->rt2x00dev->txdone_work);
-}
-
-static int rt2x00usb_status_timeout(struct data_queue *queue)
-{
-	struct queue_entry *entry;
-
-	entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-	return rt2x00queue_status_timeout(entry);
-}
-
 static int rt2x00usb_dma_timeout(struct data_queue *queue)
 {
 	struct queue_entry *entry;
@@ -558,8 +542,6 @@ void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev)
 		if (!rt2x00queue_empty(queue)) {
 			if (rt2x00usb_dma_timeout(queue))
 				rt2x00usb_watchdog_tx_dma(queue);
-			if (rt2x00usb_status_timeout(queue))
-				rt2x00usb_watchdog_tx_status(queue);
 		}
 	}
 }
@@ -829,7 +811,8 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 
 	INIT_WORK(&rt2x00dev->rxdone_work, rt2x00usb_work_rxdone);
 	INIT_WORK(&rt2x00dev->txdone_work, rt2x00usb_work_txdone);
-	init_timer(&rt2x00dev->txstatus_timer);
+	hrtimer_init(&rt2x00dev->txstatus_timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_REL);
 
 	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
-- 
1.7.1

