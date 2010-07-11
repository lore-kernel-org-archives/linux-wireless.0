Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57913 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0GKKcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:01 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so640186ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:00 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/17] rt2x00: Implement watchdog monitoring
Date: Sun, 11 Jul 2010 12:25:46 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111224.48247.IvDoorn@gmail.com> <201007111225.18986.IvDoorn@gmail.com>
In-Reply-To: <201007111225.18986.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111225.47409.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement watchdog monitoring for USB devices (PCI support can
be added later). This will determine if URBs being uploaded to
the hardware are actually returning. Both rt2500usb and rt2800usb
have shown that URBs being uploaded can remain hanging without
being released by the hardware.
By using this watchdog, a queue can be reset when this occurs.
For rt2800usb it has been tested that the connection is preserved
even though this interruption.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c   |    2 +
 drivers/net/wireless/rt2x00/rt2800usb.c   |    2 +
 drivers/net/wireless/rt2x00/rt2x00.h      |    7 ++++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   10 ++++++
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   26 +++++++++++++--
 drivers/net/wireless/rt2x00/rt2x00link.c  |   38 ++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |    4 ++
 drivers/net/wireless/rt2x00/rt2x00queue.h |   11 ++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   50 +++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   10 ++++++
 drivers/net/wireless/rt2x00/rt73usb.c     |    2 +
 11 files changed, 159 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0b7888d..009323e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1736,6 +1736,7 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 		__set_bit(DRIVER_REQUIRE_COPY_IV, &rt2x00dev->flags);
 	}
+	__set_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -1772,6 +1773,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.rfkill_poll		= rt2500usb_rfkill_poll,
 	.link_stats		= rt2500usb_link_stats,
 	.reset_tuner		= rt2500usb_reset_tuner,
+	.watchdog		= rt2x00usb_watchdog,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
 	.write_beacon		= rt2500usb_write_beacon,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index e4ab4db..5aa7563 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -633,6 +633,7 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
+	__set_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -655,6 +656,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.link_stats		= rt2800_link_stats,
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
+	.watchdog		= rt2x00usb_watchdog,
 	.write_tx_desc		= rt2800usb_write_tx_desc,
 	.write_tx_data		= rt2800usb_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index bf5e3f3..97b6261 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -332,6 +332,11 @@ struct link {
 	 * Work structure for scheduling periodic link tuning.
 	 */
 	struct delayed_work work;
+
+	/*
+	 * Work structure for scheduling periodic watchdog monitoring.
+	 */
+	struct delayed_work watchdog_work;
 };
 
 /*
@@ -543,6 +548,7 @@ struct rt2x00lib_ops {
 			     struct link_qual *qual);
 	void (*link_tuner) (struct rt2x00_dev *rt2x00dev,
 			    struct link_qual *qual, const u32 count);
+	void (*watchdog) (struct rt2x00_dev *rt2x00dev);
 
 	/*
 	 * TX control handlers
@@ -648,6 +654,7 @@ enum rt2x00_flags {
 	DRIVER_SUPPORT_CONTROL_FILTERS,
 	DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL,
 	DRIVER_SUPPORT_LINK_TUNING,
+	DRIVER_SUPPORT_WATCHDOG,
 
 	/*
 	 * Driver configuration
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 12ee7bd..0906e14 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -70,6 +70,11 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON);
 
 	/*
+	 * Start watchdog monitoring.
+	 */
+	rt2x00link_start_watchdog(rt2x00dev);
+
+	/*
 	 * Start the TX queues.
 	 */
 	ieee80211_wake_queues(rt2x00dev->hw);
@@ -89,6 +94,11 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00queue_stop_queues(rt2x00dev);
 
 	/*
+	 * Stop watchdog monitoring.
+	 */
+	rt2x00link_stop_watchdog(rt2x00dev);
+
+	/*
 	 * Disable RX.
 	 */
 	rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_OFF);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index ed27de1..dc5c657 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -30,6 +30,7 @@
 /*
  * Interval defines
  */
+#define WATCHDOG_INTERVAL	round_jiffies_relative(HZ)
 #define LINK_TUNE_INTERVAL	round_jiffies_relative(HZ)
 
 /*
@@ -257,11 +258,30 @@ void rt2x00link_stop_tuner(struct rt2x00_dev *rt2x00dev);
 void rt2x00link_reset_tuner(struct rt2x00_dev *rt2x00dev, bool antenna);
 
 /**
- * rt2x00link_register - Initialize link tuning functionality
+ * rt2x00link_start_watchdog - Start periodic watchdog monitoring
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  *
- * Initialize work structure and all link tuning related
- * parameters. This will not start the link tuning process itself.
+ * This start the watchdog periodic work, this work will
+ *be executed periodically until &rt2x00link_stop_watchdog has
+ * been called.
+ */
+void rt2x00link_start_watchdog(struct rt2x00_dev *rt2x00dev);
+
+/**
+ * rt2x00link_stop_watchdog - Stop periodic watchdog monitoring
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ *
+ * After this function completed the watchdog monitoring will not
+ * be running until &rt2x00link_start_watchdog is called.
+ */
+void rt2x00link_stop_watchdog(struct rt2x00_dev *rt2x00dev);
+
+/**
+ * rt2x00link_register - Initialize link tuning & watchdog functionality
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ *
+ * Initialize work structure and all link tuning and watchdog related
+ * parameters. This will not start the periodic work itself.
  */
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 9acfc5c..666cef3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -407,7 +407,45 @@ static void rt2x00link_tuner(struct work_struct *work)
 					     &link->work, LINK_TUNE_INTERVAL);
 }
 
+void rt2x00link_start_watchdog(struct rt2x00_dev *rt2x00dev)
+{
+	struct link *link = &rt2x00dev->link;
+
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
+	    !test_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags))
+		return;
+
+	ieee80211_queue_delayed_work(rt2x00dev->hw,
+				     &link->watchdog_work, WATCHDOG_INTERVAL);
+}
+
+void rt2x00link_stop_watchdog(struct rt2x00_dev *rt2x00dev)
+{
+	cancel_delayed_work_sync(&rt2x00dev->link.watchdog_work);
+}
+
+static void rt2x00link_watchdog(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, link.watchdog_work.work);
+	struct link *link = &rt2x00dev->link;
+
+	/*
+	 * When the radio is shutting down we should
+	 * immediately cease the watchdog monitoring.
+	 */
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	rt2x00dev->ops->lib->watchdog(rt2x00dev);
+
+	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
+		ieee80211_queue_delayed_work(rt2x00dev->hw,
+					     &link->watchdog_work, WATCHDOG_INTERVAL);
+}
+
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
 {
+	INIT_DELAYED_WORK(&rt2x00dev->link.watchdog_work, rt2x00link_watchdog);
 	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00link_tuner);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 5097fe0..a3401d3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -688,9 +688,11 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 
 	if (index == Q_INDEX) {
 		queue->length++;
+		queue->last_index = jiffies;
 	} else if (index == Q_INDEX_DONE) {
 		queue->length--;
 		queue->count++;
+		queue->last_index_done = jiffies;
 	}
 
 	spin_unlock_irqrestore(&queue->lock, irqflags);
@@ -704,6 +706,8 @@ static void rt2x00queue_reset(struct data_queue *queue)
 
 	queue->count = 0;
 	queue->length = 0;
+	queue->last_index = jiffies;
+	queue->last_index_done = jiffies;
 	memset(queue->index, 0, sizeof(queue->index));
 
 	spin_unlock_irqrestore(&queue->lock, irqflags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index bd54f55..191e777 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -446,6 +446,8 @@ struct data_queue {
 	enum data_queue_qid qid;
 
 	spinlock_t lock;
+	unsigned long last_index;
+	unsigned long last_index_done;
 	unsigned int count;
 	unsigned short limit;
 	unsigned short threshold;
@@ -599,6 +601,15 @@ static inline int rt2x00queue_threshold(struct data_queue *queue)
 }
 
 /**
+ * rt2x00queue_timeout - Check if a timeout occured for this queue
+ * @queue: Queue to check.
+ */
+static inline int rt2x00queue_timeout(struct data_queue *queue)
+{
+	return time_after(queue->last_index, queue->last_index_done + (HZ / 10));
+}
+
+/**
  * _rt2x00_desc_read - Read a word from the hardware descriptor.
  * @desc: Base descriptor address
  * @word: Word index from where the descriptor should be read.
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index a22837c..ff3a366 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -292,6 +292,56 @@ void rt2x00usb_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kill_tx_queue);
 
+static void rt2x00usb_watchdog_reset_tx(struct data_queue *queue)
+{
+	struct queue_entry_priv_usb *entry_priv;
+	unsigned short threshold = queue->threshold;
+
+	WARNING(queue->rt2x00dev, "TX queue %d timed out, invoke reset", queue->qid);
+
+	/*
+	 * Temporarily disable the TX queue, this will force mac80211
+	 * to use the other queues until this queue has been restored.
+	 *
+	 * Set the queue threshold to the queue limit. This prevents the
+	 * queue from being enabled during the txdone handler.
+	 */
+	queue->threshold = queue->limit;
+	ieee80211_stop_queue(queue->rt2x00dev->hw, queue->qid);
+
+	/*
+	 * Reset all currently uploaded TX frames.
+	 */
+	while (!rt2x00queue_empty(queue)) {
+		entry_priv = rt2x00queue_get_entry(queue, Q_INDEX_DONE)->priv_data;
+		usb_kill_urb(entry_priv->urb);
+
+		/*
+		 * We need a short delay here to wait for
+		 * the URB to be canceled and invoked the tx_done handler.
+		 */
+		udelay(200);
+	}
+
+	/*
+	 * The queue has been reset, and mac80211 is allowed to use the
+	 * queue again.
+	 */
+	queue->threshold = threshold;
+	ieee80211_wake_queue(queue->rt2x00dev->hw, queue->qid);
+}
+
+void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+
+	tx_queue_for_each(rt2x00dev, queue) {
+		if (rt2x00queue_timeout(queue))
+			rt2x00usb_watchdog_reset_tx(queue);
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00usb_watchdog);
+
 /*
  * RX data handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 2b7a188..d3d3ddc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -399,6 +399,16 @@ void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 void rt2x00usb_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
 			      const enum data_queue_qid qid);
 
+/**
+ * rt2x00usb_watchdog - Watchdog for USB communication
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ *
+ * Check the health of the USB communication and determine
+ * if timeouts have occured. If this is the case, this function
+ * will reset all communication to restore functionality again.
+ */
+void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev);
+
 /*
  * Device initialization handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 9ea6a67..cad07b6 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2136,6 +2136,7 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
+	__set_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -2251,6 +2252,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.link_stats		= rt73usb_link_stats,
 	.reset_tuner		= rt73usb_reset_tuner,
 	.link_tuner		= rt73usb_link_tuner,
+	.watchdog		= rt2x00usb_watchdog,
 	.write_tx_desc		= rt73usb_write_tx_desc,
 	.write_beacon		= rt73usb_write_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
-- 
1.7.1.1

