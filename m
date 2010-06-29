Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:57874 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab0F2Tu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:50:59 -0400
Received: by ey-out-2122.google.com with SMTP id 9so26686eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:50:57 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/21] rt2x00: Merge PCI and USB versions of write_tx_data into single function.
Date: Tue, 29 Jun 2010 21:41:05 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292140.03875.IvDoorn@gmail.com> <201006292140.35163.IvDoorn@gmail.com>
In-Reply-To: <201006292140.35163.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292141.07070.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Now that rt2x00pci_write_tx_data and rt2x00usb_write_tx_data are similar
we can merge them in a single function in rt2x00queue.c.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    1 -
 drivers/net/wireless/rt2x00/rt2500pci.c   |    1 -
 drivers/net/wireless/rt2x00/rt2500usb.c   |    1 -
 drivers/net/wireless/rt2x00/rt2800pci.c   |    1 -
 drivers/net/wireless/rt2x00/rt2800usb.c   |    1 -
 drivers/net/wireless/rt2x00/rt2x00pci.c   |   43 -----------------------------
 drivers/net/wireless/rt2x00/rt2x00pci.h   |   10 -------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   43 +++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   21 --------------
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   10 -------
 drivers/net/wireless/rt2x00/rt61pci.c     |    1 -
 drivers/net/wireless/rt2x00/rt73usb.c     |    1 -
 12 files changed, 41 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 1eb882e..1ad3596 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1588,7 +1588,6 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.reset_tuner		= rt2400pci_reset_tuner,
 	.link_tuner		= rt2400pci_link_tuner,
 	.write_tx_desc		= rt2400pci_write_tx_desc,
-	.write_tx_data		= rt2x00pci_write_tx_data,
 	.write_beacon		= rt2400pci_write_beacon,
 	.kick_tx_queue		= rt2400pci_kick_tx_queue,
 	.kill_tx_queue		= rt2400pci_kill_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index a29cb21..2771ae7 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1886,7 +1886,6 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.reset_tuner		= rt2500pci_reset_tuner,
 	.link_tuner		= rt2500pci_link_tuner,
 	.write_tx_desc		= rt2500pci_write_tx_desc,
-	.write_tx_data		= rt2x00pci_write_tx_data,
 	.write_beacon		= rt2500pci_write_beacon,
 	.kick_tx_queue		= rt2500pci_kick_tx_queue,
 	.kill_tx_queue		= rt2500pci_kill_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 002db64..6cdd665 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1769,7 +1769,6 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.link_stats		= rt2500usb_link_stats,
 	.reset_tuner		= rt2500usb_reset_tuner,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
-	.write_tx_data		= rt2x00usb_write_tx_data,
 	.write_beacon		= rt2500usb_write_beacon,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index e5ea670..615a865 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1044,7 +1044,6 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.write_tx_desc		= rt2800pci_write_tx_desc,
-	.write_tx_data		= rt2x00pci_write_tx_data,
 	.write_tx_datadesc	= rt2800pci_write_tx_datadesc,
 	.write_beacon		= rt2800_write_beacon,
 	.kick_tx_queue		= rt2800pci_kick_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f18c12a..6d4de60 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -652,7 +652,6 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.write_tx_desc		= rt2800usb_write_tx_desc,
-	.write_tx_data		= rt2x00usb_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 10eaffd..1c9ccc3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -61,49 +61,6 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
 EXPORT_SYMBOL_GPL(rt2x00pci_regbusy_read);
 
 /*
- * TX data handlers.
- */
-int rt2x00pci_write_tx_data(struct queue_entry *entry,
-			    struct txentry_desc *txdesc)
-{
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-
-	/*
-	 * This should not happen, we already checked the entry
-	 * was ours. When the hardware disagrees there has been
-	 * a queue corruption!
-	 */
-	if (unlikely(rt2x00dev->ops->lib->get_entry_state(entry))) {
-		ERROR(rt2x00dev,
-		      "Corrupt queue %d, accessing entry which is not ours.\n"
-		      "Please file bug report to %s.\n",
-		      entry->queue->qid, DRV_PROJECT);
-		return -EINVAL;
-	}
-
-	/*
-	 * Add the requested extra tx headroom in front of the skb.
-	 */
-	skb_push(entry->skb, rt2x00dev->ops->extra_tx_headroom);
-	memset(entry->skb->data, 0, rt2x00dev->ops->extra_tx_headroom);
-
-	/*
-	 * Call the driver's write_tx_datadesc function, if it exists.
-	 */
-	if (rt2x00dev->ops->lib->write_tx_datadesc)
-		rt2x00dev->ops->lib->write_tx_datadesc(entry, txdesc);
-
-	/*
-	 * Map the skb to DMA.
-	 */
-	if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags))
-		rt2x00queue_map_txskb(rt2x00dev, entry->skb);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
-
-/*
  * TX/RX data handlers.
  */
 void rt2x00pci_txdone(struct queue_entry *entry,
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 00528b8..2dca185 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -86,16 +86,6 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
 			   u32 *reg);
 
 /**
- * rt2x00pci_write_tx_data - Initialize data for TX operation
- * @entry: The entry where the frame is located
- *
- * This function will initialize the DMA and skb descriptor
- * to prepare the entry for the actual TX operation.
- */
-int rt2x00pci_write_tx_data(struct queue_entry *entry,
-			    struct txentry_desc *txdesc);
-
-/**
  * struct queue_entry_priv_pci: Per entry PCI specific information
  *
  * @desc: Pointer to device descriptor
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index f916371..b9cc253 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -404,6 +404,46 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, hwrate);
 }
 
+static int rt2x00queue_write_tx_data(struct queue_entry *entry,
+				     struct txentry_desc *txdesc)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+
+	/*
+	 * This should not happen, we already checked the entry
+	 * was ours. When the hardware disagrees there has been
+	 * a queue corruption!
+	 */
+	if (unlikely(rt2x00dev->ops->lib->get_entry_state &&
+		     rt2x00dev->ops->lib->get_entry_state(entry))) {
+		ERROR(rt2x00dev,
+		      "Corrupt queue %d, accessing entry which is not ours.\n"
+		      "Please file bug report to %s.\n",
+		      entry->queue->qid, DRV_PROJECT);
+		return -EINVAL;
+	}
+
+	/*
+	 * Add the requested extra tx headroom in front of the skb.
+	 */
+	skb_push(entry->skb, rt2x00dev->ops->extra_tx_headroom);
+	memset(entry->skb->data, 0, rt2x00dev->ops->extra_tx_headroom);
+
+	/*
+	 * Call the driver's write_tx_datadesc function, if it exists.
+	 */
+	if (rt2x00dev->ops->lib->write_tx_datadesc)
+		rt2x00dev->ops->lib->write_tx_datadesc(entry, txdesc);
+
+	/*
+	 * Map the skb to DMA.
+	 */
+	if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags))
+		rt2x00queue_map_txskb(rt2x00dev, entry->skb);
+
+	return 0;
+}
+
 static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 					    struct txentry_desc *txdesc)
 {
@@ -515,8 +555,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	 * call failed. Since we always return NETDEV_TX_OK to mac80211,
 	 * this frame will simply be dropped.
 	 */
-	if (unlikely(queue->rt2x00dev->ops->lib->write_tx_data(entry,
-							       &txdesc))) {
+	if (unlikely(rt2x00queue_write_tx_data(entry, &txdesc))) {
 		clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 		entry->skb = NULL;
 		return -EIO;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 1c91812..f78ebb4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -207,27 +207,6 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	rt2x00lib_txdone(entry, &txdesc);
 }
 
-int rt2x00usb_write_tx_data(struct queue_entry *entry,
-			    struct txentry_desc *txdesc)
-{
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-
-	/*
-	 * Add the descriptor in front of the skb.
-	 */
-	skb_push(entry->skb, entry->queue->desc_size);
-	memset(entry->skb->data, 0, entry->queue->desc_size);
-
-	/*
-	 * Call the driver's write_tx_datadesc function, if it exists.
-	 */
-	if (rt2x00dev->ops->lib->write_tx_datadesc)
-		rt2x00dev->ops->lib->write_tx_datadesc(entry, txdesc);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00usb_write_tx_data);
-
 static inline void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 255b81e..2b7a188 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -351,16 +351,6 @@ int rt2x00usb_regbusy_read(struct rt2x00_dev *rt2x00dev,
 void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev);
 
 /**
- * rt2x00usb_write_tx_data - Initialize URB for TX operation
- * @entry: The entry where the frame is located
- *
- * This function will initialize the URB and skb descriptor
- * to prepare the entry for the actual TX operation.
- */
-int rt2x00usb_write_tx_data(struct queue_entry *entry,
-			    struct txentry_desc *txdesc);
-
-/**
  * struct queue_entry_priv_usb: Per entry USB specific information
  *
  * @urb: Urb structure used for device communication.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 7ca3834..cb6e20a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2800,7 +2800,6 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.reset_tuner		= rt61pci_reset_tuner,
 	.link_tuner		= rt61pci_link_tuner,
 	.write_tx_desc		= rt61pci_write_tx_desc,
-	.write_tx_data		= rt2x00pci_write_tx_data,
 	.write_beacon		= rt61pci_write_beacon,
 	.kick_tx_queue		= rt61pci_kick_tx_queue,
 	.kill_tx_queue		= rt61pci_kill_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d06d90f..286dd97 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2249,7 +2249,6 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.reset_tuner		= rt73usb_reset_tuner,
 	.link_tuner		= rt73usb_link_tuner,
 	.write_tx_desc		= rt73usb_write_tx_desc,
-	.write_tx_data		= rt2x00usb_write_tx_data,
 	.write_beacon		= rt73usb_write_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-- 
1.6.6.1

