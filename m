Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:42588 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbYFHVhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:37 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1213448ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:34 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/10] rt2x00: Don't kick TX queue after each frame
Date: Sun, 8 Jun 2008 23:43:56 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com> <200806082342.40422.IvDoorn@gmail.com> <200806082343.17344.IvDoorn@gmail.com>
In-Reply-To: <200806082343.17344.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082343.56928.IvDoorn@gmail.com> (sfid-20080608_233740_845750_87A174B0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX queues shouldn't be kicked after each frame that is put into the queue.
This could cause problems during RTS and CTS-to-self as well as
with fragmentation. In all those cases you want all frames to be send
out in a single burst. Off course we shouldn't let the queue fill up
entirely, thus we introduce a 10% threshold which, when reached,
will force the frames to be send out regardless of the frame.

In addition we should prevent queues to become full in such a way that the tx()
handler can fail. Instead of stopping the queue when it is full, we should stop
it when it is below the threshold.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    1 -
 drivers/net/wireless/rt2x00/rt2500pci.c   |    1 -
 drivers/net/wireless/rt2x00/rt2500usb.c   |    1 -
 drivers/net/wireless/rt2x00/rt2x00.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   10 +---------
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   28 +++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2x00queue.h |   19 ++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    6 +++---
 drivers/net/wireless/rt2x00/rt61pci.c     |    1 -
 drivers/net/wireless/rt2x00/rt73usb.c     |    1 -
 11 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 94226b4..b5b0ded 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1507,7 +1507,6 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index c8cf8c1..74b54c9 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1823,7 +1823,6 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 6abb4c5..0762214 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1711,7 +1711,6 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data + intf->beacon->queue->desc_size;
 	skbdesc->data_len = skb->len - intf->beacon->queue->desc_size;
 	skbdesc->desc = skb->data;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index c7da3c2..938d375 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -826,7 +826,7 @@ struct rt2x00_dev {
 	 * The Beacon array also contains the Atim queue
 	 * if that is supported by the device.
 	 */
-	int data_queues;
+	unsigned int data_queues;
 	struct data_queue *rx;
 	struct data_queue *tx;
 	struct data_queue *bcn;
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index e7f544c..59f273b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -34,7 +34,6 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 				struct sk_buff *frag_skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(frag_skb);
-	struct skb_frame_desc *skbdesc;
 	struct ieee80211_tx_info *rts_info;
 	struct sk_buff *skb;
 	int size;
@@ -82,13 +81,6 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 				  frag_skb->data, size, tx_info,
 				  (struct ieee80211_rts *)(skb->data));
 
-	/*
-	 * Initialize skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
-
 	if (rt2x00queue_write_tx_frame(queue, skb)) {
 		WARNING(rt2x00dev, "Failed to send RTS/CTS frame.\n");
 		return NETDEV_TX_BUSY;
@@ -163,7 +155,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return NETDEV_TX_BUSY;
 	}
 
-	if (rt2x00queue_full(queue))
+	if (rt2x00queue_threshold(queue))
 		ieee80211_stop_queue(rt2x00dev->hw, qid);
 
 	return NETDEV_TX_OK;
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 83a35b1..945ed71 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -170,11 +170,11 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
 
 	/*
-	 * If the data queue was full before the txdone handler
-	 * we must make sure the packet queue in the mac80211 stack
+	 * If the data queue was below the threshold before the txdone
+	 * handler we must make sure the packet queue in the mac80211 stack
 	 * is reenabled when the txdone handler has finished.
 	 */
-	if (!rt2x00queue_full(entry->queue))
+	if (!rt2x00queue_threshold(entry->queue))
 		ieee80211_wake_queue(rt2x00dev->hw, qid);
 
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index f875b7a..4930665 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -163,8 +163,8 @@ EXPORT_SYMBOL_GPL(rt2x00queue_create_tx_descriptor);
 void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 				     struct txentry_desc *txdesc)
 {
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct data_queue *queue = entry->queue;
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 
 	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry->skb, txdesc);
 
@@ -175,16 +175,21 @@ void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TX, entry->skb);
 
 	/*
-	 * We are done writing the frame to the queue entry,
-	 * also kick the queue in case the correct flags are set,
-	 * note that this will automatically filter beacons and
-	 * RTS/CTS frames since those frames don't have this flag
-	 * set.
+	 * Check if we need to kick the queue, there are however a few rules
+	 *	1) Don't kick beacon queue
+	 *	2) Don't kick unless this is the last in frame in a burst.
+	 *	   When the burst flag is set, this frame is always followed
+	 *	   by another frame which in some way are related to eachother.
+	 *	   This is true for fragments, RTS or CTS-to-self frames.
+	 *	3) Rule 2 can be broken when the available entries
+	 *	   in the queue are less then a certain threshold.
 	 */
-	if (rt2x00dev->ops->lib->kick_tx_queue &&
-	    !(skbdesc->flags & FRAME_DESC_DRIVER_GENERATED))
-		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev,
-						   entry->queue->qid);
+	if (entry->queue->qid == QID_BEACON)
+		return;
+
+	if (rt2x00queue_threshold(queue) ||
+	    !test_bit(ENTRY_TXD_BURST, &txdesc->flags))
+		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, queue->qid);
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_write_tx_descriptor);
 
@@ -349,6 +354,7 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 	rt2x00queue_reset(queue);
 
 	queue->limit = qdesc->entry_num;
+	queue->threshold = DIV_ROUND_UP(qdesc->entry_num, 10);
 	queue->data_size = qdesc->data_size;
 	queue->desc_size = qdesc->desc_size;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 303d556..623fc27 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -82,12 +82,10 @@ enum data_queue_qid {
 /**
  * enum skb_frame_desc_flags: Flags for &struct skb_frame_desc
  *
- * @FRAME_DESC_DRIVER_GENERATED: Frame was generated inside driver
- *	and should not be reported back to mac80211 during txdone.
  */
-enum skb_frame_desc_flags {
-	FRAME_DESC_DRIVER_GENERATED = 1 << 0,
-};
+//enum skb_frame_desc_flags {
+//	TEMPORARILY EMPTY
+//};
 
 /**
  * struct skb_frame_desc: Descriptor information for the skb buffer
@@ -325,6 +323,7 @@ enum queue_index {
  *	index corruption due to concurrency.
  * @count: Number of frames handled in the queue.
  * @limit: Maximum number of entries in the queue.
+ * @threshold: Minimum number of free entries before queue is kicked by force.
  * @length: Number of frames in queue.
  * @index: Index pointers to entry positions in the queue,
  *	use &enum queue_index to get a specific index field.
@@ -343,6 +342,7 @@ struct data_queue {
 	spinlock_t lock;
 	unsigned int count;
 	unsigned short limit;
+	unsigned short threshold;
 	unsigned short length;
 	unsigned short index[Q_INDEX_MAX];
 
@@ -467,6 +467,15 @@ static inline int rt2x00queue_available(struct data_queue *queue)
 }
 
 /**
+ * rt2x00queue_threshold - Check if the queue is below threshold
+ * @queue: Queue to check.
+ */
+static inline int rt2x00queue_threshold(struct data_queue *queue)
+{
+	return rt2x00queue_available(queue) < queue->threshold;
+}
+
+/**
  * rt2x00_desc_read - Read a word from the hardware descriptor.
  * @desc: Base descriptor address
  * @word: Word index from where the descriptor should be read.
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 0d1be58..bed595f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -165,11 +165,11 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
 
 	/*
-	 * If the data queue was full before the txdone handler
-	 * we must make sure the packet queue in the mac80211 stack
+	 * If the data queue was below the threshold before the txdone
+	 * handler we must make sure the packet queue in the mac80211 stack
 	 * is reenabled when the txdone handler has finished.
 	 */
-	if (!rt2x00queue_full(entry->queue))
+	if (!rt2x00queue_threshold(entry->queue))
 		ieee80211_wake_queue(rt2x00dev->hw, qid);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index aa9ef66..746f87c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2375,7 +2375,6 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 5e5f603..ae50f63 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1980,7 +1980,6 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data + intf->beacon->queue->desc_size;
 	skbdesc->data_len = skb->len - intf->beacon->queue->desc_size;
 	skbdesc->desc = skb->data;
-- 
1.5.5.3

