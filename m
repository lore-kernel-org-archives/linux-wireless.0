Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43999 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0HWR5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 13:57:18 -0400
Received: by wyb32 with SMTP id 32so7066669wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 10:57:16 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH 1/8] rt2x00: Simplify arguments to rt2x00 driver callback functions
Date: Mon, 23 Aug 2010 19:53:39 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008231953.40629.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

write_tx_desc shouldn't pass a rt2x00dev and skb pointer,
instead it should use the same format as other TX frame
callback functions, which is passing the data_entry pointer
which contains all the information which is needed to work
on a TX frame.

Most callers of the kick_tx_queue and kill_tx_queue already
have the data_queue pointer, so rather then sending the QID
with the given function, when the driver requests a new
pointer to the data_queue, it is more efficient to just
send the data_queue pointer directly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   25 ++++++++---------
 drivers/net/wireless/rt2x00/rt2500pci.c   |   25 ++++++++---------
 drivers/net/wireless/rt2x00/rt2500usb.c   |    9 +++---
 drivers/net/wireless/rt2x00/rt2800pci.c   |   41 ++++++++++++-----------------
 drivers/net/wireless/rt2x00/rt2800usb.c   |    9 +++---
 drivers/net/wireless/rt2x00/rt2x00.h      |    9 ++----
 drivers/net/wireless/rt2x00/rt2x00queue.c |   11 +++----
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   14 +++------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   12 +++-----
 drivers/net/wireless/rt2x00/rt61pci.c     |   39 +++++++++++++--------------
 drivers/net/wireless/rt2x00/rt73usb.c     |   11 +++----
 11 files changed, 90 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 8e3fbdf..a43416d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1007,12 +1007,11 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct sk_buff *skb,
+static void rt2400pci_write_tx_desc(struct queue_entry *entry,
 				    struct txentry_desc *txdesc)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	__le32 *txd = entry_priv->desc;
 	u32 word;
 
@@ -1096,7 +1095,7 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Write the TX descriptor for the beacon.
 	 */
-	rt2400pci_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+	rt2400pci_write_tx_desc(entry, txdesc);
 
 	/*
 	 * Dump beacon to userspace through debugfs.
@@ -1112,24 +1111,24 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
-static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const enum data_queue_qid queue)
+static void rt2400pci_kick_tx_queue(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue == QID_AC_BE));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue == QID_AC_BK));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, (queue == QID_ATIM));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue->qid == QID_AC_BE));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue->qid == QID_AC_BK));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, (queue->qid == QID_ATIM));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
-static void rt2400pci_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const enum data_queue_qid qid)
+static void rt2400pci_kill_tx_queue(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	u32 reg;
 
-	if (qid == QID_BEACON) {
+	if (queue->qid == QID_BEACON) {
 		rt2x00pci_register_write(rt2x00dev, CSR14, 0);
 	} else {
 		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 1d174e4..3e3aa5f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1161,12 +1161,11 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct sk_buff *skb,
+static void rt2500pci_write_tx_desc(struct queue_entry *entry,
 				    struct txentry_desc *txdesc)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	__le32 *txd = entry_priv->desc;
 	u32 word;
 
@@ -1249,7 +1248,7 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Write the TX descriptor for the beacon.
 	 */
-	rt2500pci_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+	rt2500pci_write_tx_desc(entry, txdesc);
 
 	/*
 	 * Dump beacon to userspace through debugfs.
@@ -1265,24 +1264,24 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
-static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const enum data_queue_qid queue)
+static void rt2500pci_kick_tx_queue(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue == QID_AC_BE));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue == QID_AC_BK));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, (queue == QID_ATIM));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue->qid == QID_AC_BE));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue->qid == QID_AC_BK));
+	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, (queue->qid == QID_ATIM));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
 }
 
-static void rt2500pci_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const enum data_queue_qid qid)
+static void rt2500pci_kill_tx_queue(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	u32 reg;
 
-	if (qid == QID_BEACON) {
+	if (queue->qid == QID_BEACON) {
 		rt2x00pci_register_write(rt2x00dev, CSR14, 0);
 	} else {
 		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index baadf03..7642e71 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1041,12 +1041,11 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct sk_buff *skb,
+static void rt2500usb_write_tx_desc(struct queue_entry *entry,
 				    struct txentry_desc *txdesc)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txd = (__le32 *) skb->data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	__le32 *txd = (__le32 *) entry->skb->data;
 	u32 word;
 
 	/*
@@ -1129,7 +1128,7 @@ static void rt2500usb_write_beacon(struct queue_entry *entry,
 	/*
 	 * Write the TX descriptor for the beacon.
 	 */
-	rt2500usb_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+	rt2500usb_write_tx_desc(entry, txdesc);
 
 	/*
 	 * Dump beacon to userspace through debugfs.
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 4390f2b..af1c691 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -571,12 +571,11 @@ static __le32 *rt2800pci_get_txwi(struct queue_entry *entry)
 	return (__le32 *) entry->skb->data;
 }
 
-static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct sk_buff *skb,
+static void rt2800pci_write_tx_desc(struct queue_entry *entry,
 				    struct txentry_desc *txdesc)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	__le32 *txd = entry_priv->desc;
 	u32 word;
 
@@ -596,7 +595,7 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 0, word);
 
 	rt2x00_desc_read(txd, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_SD_LEN1, skb->len);
+	rt2x00_set_field32(&word, TXD_W1_SD_LEN1, entry->skb->len);
 	rt2x00_set_field32(&word, TXD_W1_LAST_SEC1,
 			   !test_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W1_BURST,
@@ -627,41 +626,35 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
-static void rt2800pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const enum data_queue_qid queue_idx)
+static void rt2800pci_kick_tx_queue(struct data_queue *queue)
 {
-	struct data_queue *queue;
-	unsigned int idx, qidx = 0;
-
-	if (queue_idx > QID_HCCA && queue_idx != QID_MGMT)
-		return;
-
-	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
-	idx = queue->index[Q_INDEX];
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	unsigned int idx = queue->index[Q_INDEX];
+	unsigned int qidx = 0;
 
-	if (queue_idx == QID_MGMT)
+	if (queue->qid == QID_MGMT)
 		qidx = 5;
 	else
-		qidx = queue_idx;
+		qidx = queue->qid;
 
 	rt2800_register_write(rt2x00dev, TX_CTX_IDX(qidx), idx);
 }
 
-static void rt2800pci_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
-				    const enum data_queue_qid qid)
+static void rt2800pci_kill_tx_queue(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	u32 reg;
 
-	if (qid == QID_BEACON) {
+	if (queue->qid == QID_BEACON) {
 		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, 0);
 		return;
 	}
 
 	rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, (qid == QID_AC_BE));
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, (qid == QID_AC_BK));
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, (qid == QID_AC_VI));
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, (qid == QID_AC_VO));
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, (queue->qid == QID_AC_BE));
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, (queue->qid == QID_AC_BK));
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, (queue->qid == QID_AC_VI));
+	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, (queue->qid == QID_AC_VO));
 	rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9ad28be..02f9589 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -329,12 +329,11 @@ static __le32 *rt2800usb_get_txwi(struct queue_entry *entry)
 		return (__le32 *) (entry->skb->data + TXINFO_DESC_SIZE);
 }
 
-static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct sk_buff *skb,
+static void rt2800usb_write_tx_desc(struct queue_entry *entry,
 				    struct txentry_desc *txdesc)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txi = (__le32 *) skb->data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	__le32 *txi = (__le32 *) entry->skb->data;
 	u32 word;
 
 	/*
@@ -342,7 +341,7 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00_desc_read(txi, 0, &word);
 	rt2x00_set_field32(&word, TXINFO_W0_USB_DMA_TX_PKT_LEN,
-			   skb->len - TXINFO_DESC_SIZE);
+			   entry->skb->len - TXINFO_DESC_SIZE);
 	rt2x00_set_field32(&word, TXINFO_W0_WIV,
 			   !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags));
 	rt2x00_set_field32(&word, TXINFO_W0_QSEL, 2);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8c65244..69308a0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -559,18 +559,15 @@ struct rt2x00lib_ops {
 	/*
 	 * TX control handlers
 	 */
-	void (*write_tx_desc) (struct rt2x00_dev *rt2x00dev,
-			       struct sk_buff *skb,
+	void (*write_tx_desc) (struct queue_entry *entry,
 			       struct txentry_desc *txdesc);
 	void (*write_tx_data) (struct queue_entry *entry,
 			       struct txentry_desc *txdesc);
 	void (*write_beacon) (struct queue_entry *entry,
 			      struct txentry_desc *txdesc);
 	int (*get_tx_data_len) (struct queue_entry *entry);
-	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
-			       const enum data_queue_qid queue);
-	void (*kill_tx_queue) (struct rt2x00_dev *rt2x00dev,
-			       const enum data_queue_qid queue);
+	void (*kick_tx_queue) (struct data_queue *queue);
+	void (*kill_tx_queue) (struct data_queue *queue);
 
 	/*
 	 * RX control handlers
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 480d33a..a083857 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -449,15 +449,14 @@ static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 					    struct txentry_desc *txdesc)
 {
 	struct data_queue *queue = entry->queue;
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 
-	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry->skb, txdesc);
+	queue->rt2x00dev->ops->lib->write_tx_desc(entry, txdesc);
 
 	/*
 	 * All processing on the frame has been completed, this means
 	 * it is now ready to be dumped to userspace through debugfs.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TX, entry->skb);
+	rt2x00debug_dump_frame(queue->rt2x00dev, DUMP_FRAME_TX, entry->skb);
 }
 
 static void rt2x00queue_kick_tx_queue(struct queue_entry *entry,
@@ -477,7 +476,7 @@ static void rt2x00queue_kick_tx_queue(struct queue_entry *entry,
 	 */
 	if (rt2x00queue_threshold(queue) ||
 	    !test_bit(ENTRY_TXD_BURST, &txdesc->flags))
-		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, queue->qid);
+		rt2x00dev->ops->lib->kick_tx_queue(queue);
 }
 
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
@@ -591,7 +590,7 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	intf->beacon->skb = NULL;
 
 	if (!enable_beacon) {
-		rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev, QID_BEACON);
+		rt2x00dev->ops->lib->kill_tx_queue(intf->beacon->queue);
 		mutex_unlock(&intf->beacon_skb_mutex);
 		return 0;
 	}
@@ -719,7 +718,7 @@ void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 
 	txall_queue_for_each(rt2x00dev, queue)
-		rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev, queue->qid);
+		rt2x00dev->ops->lib->kill_tx_queue(queue);
 }
 
 void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index f76014f..52ed3f4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -249,10 +249,8 @@ static inline void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 	}
 }
 
-void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-			     const enum data_queue_qid qid)
+void rt2x00usb_kick_tx_queue(struct data_queue *queue)
 {
-	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, qid);
 	unsigned long irqflags;
 	unsigned int index;
 	unsigned int index_done;
@@ -286,10 +284,8 @@ void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kick_tx_queue);
 
-void rt2x00usb_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
-			     const enum data_queue_qid qid)
+void rt2x00usb_kill_tx_queue(struct data_queue *queue)
 {
-	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, qid);
 	struct queue_entry_priv_usb *entry_priv;
 	struct queue_entry_priv_usb_bcn *bcn_priv;
 	unsigned int i;
@@ -300,8 +296,8 @@ void rt2x00usb_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
 	 * the beacon guard byte.
 	 */
 	kill_guard =
-	    (qid == QID_BEACON) &&
-	    (test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags));
+	    (queue->qid == QID_BEACON) &&
+	    (test_bit(DRIVER_REQUIRE_BEACON_GUARD, &queue->rt2x00dev->flags));
 
 	/*
 	 * Cancel all entries.
@@ -447,7 +443,7 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 * The USB version of kill_tx_queue also works
 	 * on the RX queue.
 	 */
-	rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev, QID_RX);
+	rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev->rx);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index d3d3ddc..c2d997f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -379,25 +379,21 @@ struct queue_entry_priv_usb_bcn {
 
 /**
  * rt2x00usb_kick_tx_queue - Kick data queue
- * @rt2x00dev: Pointer to &struct rt2x00_dev
- * @qid: Data queue to kick
+ * @queue: Data queue to kick
  *
  * This will walk through all entries of the queue and push all pending
  * frames to the hardware as a single burst.
  */
-void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-			     const enum data_queue_qid qid);
+void rt2x00usb_kick_tx_queue(struct data_queue *queue);
 
 /**
  * rt2x00usb_kill_tx_queue - Kill data queue
- * @rt2x00dev: Pointer to &struct rt2x00_dev
- * @qid: Data queue to kill
+ * @queue: Data queue to kill
  *
  * This will walk through all entries of the queue and kill all
  * previously kicked frames before they can be send.
  */
-void rt2x00usb_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
-			      const enum data_queue_qid qid);
+void rt2x00usb_kill_tx_queue(struct data_queue *queue);
 
 /**
  * rt2x00usb_watchdog - Watchdog for USB communication
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3f8d10b..a756d5b 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1766,12 +1766,11 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				  struct sk_buff *skb,
+static void rt61pci_write_tx_desc(struct queue_entry *entry,
 				  struct txentry_desc *txdesc)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	struct queue_entry_priv_pci *entry_priv = skbdesc->entry->priv_data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	__le32 *txd = entry_priv->desc;
 	u32 word;
 
@@ -1802,11 +1801,11 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	}
 
 	rt2x00_desc_read(txd, 5, &word);
-	rt2x00_set_field32(&word, TXD_W5_PID_TYPE, skbdesc->entry->queue->qid);
+	rt2x00_set_field32(&word, TXD_W5_PID_TYPE, entry->queue->qid);
 	rt2x00_set_field32(&word, TXD_W5_PID_SUBTYPE,
 			   skbdesc->entry->entry_idx);
 	rt2x00_set_field32(&word, TXD_W5_TX_POWER,
-			   TXPOWER_TO_DEV(rt2x00dev->tx_power));
+			   TXPOWER_TO_DEV(entry->queue->rt2x00dev->tx_power));
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
@@ -1882,7 +1881,7 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	/*
 	 * Write the TX descriptor for the beacon.
 	 */
-	rt61pci_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+	rt61pci_write_tx_desc(entry, txdesc);
 
 	/*
 	 * Dump beacon to userspace through debugfs.
@@ -1918,34 +1917,34 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	entry->skb = NULL;
 }
 
-static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
-				  const enum data_queue_qid queue)
+static void rt61pci_kick_tx_queue(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, (queue == QID_AC_BE));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, (queue == QID_AC_BK));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, (queue == QID_AC_VI));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, (queue == QID_AC_VO));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, (queue->qid == QID_AC_BE));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, (queue->qid == QID_AC_BK));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, (queue->qid == QID_AC_VI));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, (queue->qid == QID_AC_VO));
 	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 }
 
-static void rt61pci_kill_tx_queue(struct rt2x00_dev *rt2x00dev,
-				  const enum data_queue_qid qid)
+static void rt61pci_kill_tx_queue(struct data_queue *queue)
 {
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	u32 reg;
 
-	if (qid == QID_BEACON) {
+	if (queue->qid == QID_BEACON) {
 		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, 0);
 		return;
 	}
 
 	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC0, (qid == QID_AC_BE));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC1, (qid == QID_AC_BK));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, (qid == QID_AC_VI));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, (qid == QID_AC_VO));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC0, (queue->qid == QID_AC_BE));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC1, (queue->qid == QID_AC_BK));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, (queue->qid == QID_AC_VI));
+	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, (queue->qid == QID_AC_VO));
 	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 8ca19f7..d46bfd4 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1426,12 +1426,11 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				  struct sk_buff *skb,
+static void rt73usb_write_tx_desc(struct queue_entry *entry,
 				  struct txentry_desc *txdesc)
 {
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	__le32 *txd = (__le32 *) skb->data;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	__le32 *txd = (__le32 *) entry->skb->data;
 	u32 word;
 
 	/*
@@ -1487,7 +1486,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_desc_read(txd, 5, &word);
 	rt2x00_set_field32(&word, TXD_W5_TX_POWER,
-			   TXPOWER_TO_DEV(rt2x00dev->tx_power));
+			   TXPOWER_TO_DEV(entry->queue->rt2x00dev->tx_power));
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
@@ -1526,7 +1525,7 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	/*
 	 * Write the TX descriptor for the beacon.
 	 */
-	rt73usb_write_tx_desc(rt2x00dev, entry->skb, txdesc);
+	rt73usb_write_tx_desc(entry, txdesc);
 
 	/*
 	 * Dump beacon to userspace through debugfs.
-- 
1.7.2.1

