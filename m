Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40169 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1DRNgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:04 -0400
Received: by fxm17 with SMTP id 17so2833906fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:03 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/23] Decrease association time for USB devices
Date: Mon, 18 Apr 2011 15:31:02 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181530.02029.IvDoorn@gmail.com> <201104181530.37227.IvDoorn@gmail.com>
In-Reply-To: <201104181530.37227.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181531.03375.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

When powersaving is enabled, assocaition times are very high
(for WPA2 networks, the time can easily be around the 3 seconds).

This is caused, because the flushing of the queues takes
too much time. Without the flushing callback mac80211 assumes
a timeout of 100ms while scanning. Limit all flush waiting
loops to the same maximum.

We can apply this maximum by passing the drop status to the
driver, which makes sure the driver performs extra actions
during the waiting for the queue to become empty.

After these changes, association times fall within the
healthy range of ~0.6 seconds with powersaving enabled.
The difference between association time between powersaving
enabled and disabled is now only ~0.1 second (which can also
be due to the measuring method).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c   |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    9 +++++++++
 drivers/net/wireless/rt2x00/rt2x00pci.h   |   10 ++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |   19 +++++--------------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    9 +++++----
 drivers/net/wireless/rt2x00/rt2x00usb.h   |    8 +++++---
 drivers/net/wireless/rt2x00/rt61pci.c     |    1 +
 10 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 5d1654a..6b7206e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1740,6 +1740,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.start_queue		= rt2400pci_start_queue,
 	.kick_queue		= rt2400pci_kick_queue,
 	.stop_queue		= rt2400pci_stop_queue,
+	.flush_queue		= rt2x00pci_flush_queue,
 	.write_tx_desc		= rt2400pci_write_tx_desc,
 	.write_beacon		= rt2400pci_write_beacon,
 	.fill_rxdone		= rt2400pci_fill_rxdone,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3da954e..82e8012 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -2033,6 +2033,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.start_queue		= rt2500pci_start_queue,
 	.kick_queue		= rt2500pci_kick_queue,
 	.stop_queue		= rt2500pci_stop_queue,
+	.flush_queue		= rt2x00pci_flush_queue,
 	.write_tx_desc		= rt2500pci_write_tx_desc,
 	.write_beacon		= rt2500pci_write_beacon,
 	.fill_rxdone		= rt2500pci_fill_rxdone,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 4241f19..d2fe5fd 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1057,6 +1057,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.start_queue		= rt2800pci_start_queue,
 	.kick_queue		= rt2800pci_kick_queue,
 	.stop_queue		= rt2800pci_stop_queue,
+	.flush_queue		= rt2x00pci_flush_queue,
 	.write_tx_desc		= rt2800pci_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8f37121..dcdc50d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -571,7 +571,7 @@ struct rt2x00lib_ops {
 	void (*start_queue) (struct data_queue *queue);
 	void (*kick_queue) (struct data_queue *queue);
 	void (*stop_queue) (struct data_queue *queue);
-	void (*flush_queue) (struct data_queue *queue);
+	void (*flush_queue) (struct data_queue *queue, bool drop);
 	void (*tx_dma_done) (struct queue_entry *entry);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 9649bd0..695aecf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -99,6 +99,15 @@ bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
 
+void rt2x00pci_flush_queue(struct data_queue *queue, bool drop)
+{
+	unsigned int i;
+
+	for (i = 0; !rt2x00queue_empty(queue) && i < 10; i++)
+		msleep(10);
+}
+EXPORT_SYMBOL_GPL(rt2x00pci_flush_queue);
+
 /*
  * Device initialization handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 07961b8..5d58874 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -107,6 +107,16 @@ struct queue_entry_priv_pci {
  */
 bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev);
 
+/**
+ * rt2x00pci_flush_queue - Flush data queue
+ * @queue: Data queue to stop
+ * @drop: True to drop all pending frames.
+ *
+ * This will wait for a maximum of 100ms, waiting for the queues
+ * to become empty.
+ */
+void rt2x00pci_flush_queue(struct data_queue *queue, bool drop);
+
 /*
  * Device initialization handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index df8817f..0d79278 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -849,7 +849,6 @@ EXPORT_SYMBOL_GPL(rt2x00queue_stop_queue);
 
 void rt2x00queue_flush_queue(struct data_queue *queue, bool drop)
 {
-	unsigned int i;
 	bool started;
 	bool tx_queue =
 		(queue->qid == QID_AC_VO) ||
@@ -884,20 +883,12 @@ void rt2x00queue_flush_queue(struct data_queue *queue, bool drop)
 	}
 
 	/*
-	 * Check if driver supports flushing, we can only guarentee
-	 * full support for flushing if the driver is able
-	 * to cancel all pending frames (drop = true).
-	 */
-	if (drop && queue->rt2x00dev->ops->lib->flush_queue)
-		queue->rt2x00dev->ops->lib->flush_queue(queue);
-
-	/*
-	 * When we don't want to drop any frames, or when
-	 * the driver doesn't fully flush the queue correcly,
-	 * we must wait for the queue to become empty.
+	 * Check if driver supports flushing, if that is the case we can
+	 * defer the flushing to the driver. Otherwise we must use the
+	 * alternative which just waits for the queue to become empty.
 	 */
-	for (i = 0; !rt2x00queue_empty(queue) && i < 100; i++)
-		msleep(10);
+	if (likely(queue->rt2x00dev->ops->lib->flush_queue))
+		queue->rt2x00dev->ops->lib->flush_queue(queue, drop);
 
 	/*
 	 * The queue flush has failed...
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 34b8a88..9957579 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -458,13 +458,14 @@ static bool rt2x00usb_flush_entry(struct queue_entry *entry, void* data)
 	return false;
 }
 
-void rt2x00usb_flush_queue(struct data_queue *queue)
+void rt2x00usb_flush_queue(struct data_queue *queue, bool drop)
 {
 	struct work_struct *completion;
 	unsigned int i;
 
-	rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX, NULL,
-				   rt2x00usb_flush_entry);
+	if (drop)
+		rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX, NULL,
+					   rt2x00usb_flush_entry);
 
 	/*
 	 * Obtain the queue completion handler
@@ -483,7 +484,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue)
 		return;
 	}
 
-	for (i = 0; i < 20; i++) {
+	for (i = 0; i < 10; i++) {
 		/*
 		 * Check if the driver is already done, otherwise we
 		 * have to sleep a little while to give the driver/hw
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index e3faca6..6aeba71 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -404,11 +404,13 @@ void rt2x00usb_kick_queue(struct data_queue *queue);
 /**
  * rt2x00usb_flush_queue - Flush data queue
  * @queue: Data queue to stop
+ * @drop: True to drop all pending frames.
  *
- * This will walk through all entries of the queue and kill all
- * URB's which were send to the device.
+ * This will walk through all entries of the queue and will optionally
+ * kill all URB's which were send to the device, or at least wait until
+ * they have been returned from the device..
  */
-void rt2x00usb_flush_queue(struct data_queue *queue);
+void rt2x00usb_flush_queue(struct data_queue *queue, bool drop);
 
 /**
  * rt2x00usb_watchdog - Watchdog for USB communication
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index c16c150..35c5d20 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -3003,6 +3003,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.start_queue		= rt61pci_start_queue,
 	.kick_queue		= rt61pci_kick_queue,
 	.stop_queue		= rt61pci_stop_queue,
+	.flush_queue		= rt2x00pci_flush_queue,
 	.write_tx_desc		= rt61pci_write_tx_desc,
 	.write_beacon		= rt61pci_write_beacon,
 	.clear_beacon		= rt61pci_clear_beacon,
-- 
1.7.2.3

