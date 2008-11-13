Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:47413 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYKMWHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 17:07:38 -0500
Received: by nf-out-0910.google.com with SMTP id d3so572548nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 14:07:36 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Detect USB BULK in/out endpoints
Date: Thu, 13 Nov 2008 23:07:33 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811132307.33534.IvDoorn@gmail.com> (sfid-20081113_230745_029873_4C5A6AD1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of hardcoding the used in/out endpoints
we should detect them by walking through all
available endpoints.

rt2800usb will gain the most out of this, because
the legacy drivers indicate that there are multiple
endpoints available.
However this code might benefit at least rt73usb as
well for the MIMO queues, and if we are really lucky
rt2500usb will benefit because for the TX and PRIO
queues.

Even if rt2500usb and rt73usb do not get better performance
after this patch, the endpoint detection still belongs to
rt2x00usb, and it shouldn't hurt to always try to detect
the available endpoints.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c   |   11 ++--
 drivers/net/wireless/rt2x00/rt2x00.h      |    8 +--
 drivers/net/wireless/rt2x00/rt2x00queue.h |   22 ++++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   91 ++++++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt73usb.c     |    7 +-
 5 files changed, 111 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1c0c64c..10cb46a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1108,7 +1108,7 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
 	struct queue_entry_priv_usb_bcn *bcn_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	int pipe = usb_sndbulkpipe(usb_dev, 1);
+	int pipe = usb_sndbulkpipe(usb_dev, entry->queue->usb_endpoint);
 	int length;
 	u16 reg;
 
@@ -1134,7 +1134,7 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	 * length of the data to usb_fill_bulk_urb. Pass the skb
 	 * to the driver to determine what the length should be.
 	 */
-	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev, entry->skb);
+	length = rt2x00dev->ops->lib->get_tx_data_len(entry);
 
 	usb_fill_bulk_urb(bcn_priv->urb, usb_dev, pipe,
 			  entry->skb->data, length, rt2500usb_beacondone,
@@ -1156,8 +1156,7 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	usb_submit_urb(bcn_priv->guardian_urb, GFP_ATOMIC);
 }
 
-static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
-				     struct sk_buff *skb)
+static int rt2500usb_get_tx_data_len(struct queue_entry *entry)
 {
 	int length;
 
@@ -1165,8 +1164,8 @@ static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 	 * The length _must_ be a multiple of 2,
 	 * but it must _not_ be a multiple of the USB packet size.
 	 */
-	length = roundup(skb->len, 2);
-	length += (2 * !(length % rt2x00dev->usb_maxpacket));
+	length = roundup(entry->skb->len, 2);
+	length += (2 * !(length % entry->queue->usb_maxpacket));
 
 	return length;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index fee61be..780ba73 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -555,8 +555,7 @@ struct rt2x00lib_ops {
 			       struct txentry_desc *txdesc);
 	int (*write_tx_data) (struct queue_entry *entry);
 	void (*write_beacon) (struct queue_entry *entry);
-	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev,
-				struct sk_buff *skb);
+	int (*get_tx_data_len) (struct queue_entry *entry);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
 			       const enum data_queue_qid queue);
 
@@ -799,11 +798,6 @@ struct rt2x00_dev {
 	short lna_gain;
 
 	/*
-	 * USB Max frame size (for rt2500usb & rt73usb).
-	 */
-	u16 usb_maxpacket;
-
-	/*
 	 * Current TX power value.
 	 */
 	u16 tx_power;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 4d3c724..2e99ab5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -380,6 +380,8 @@ enum queue_index {
  * @cw_max: The cw max value for outgoing frames (field ignored in RX queue).
  * @data_size: Maximum data size for the frames in this queue.
  * @desc_size: Hardware descriptor size for the data in this queue.
+ * @usb_endpoint: Device endpoint used for communication (USB only)
+ * @usb_maxpacket: Max packet size for given endpoint (USB only)
  */
 struct data_queue {
 	struct rt2x00_dev *rt2x00dev;
@@ -401,6 +403,9 @@ struct data_queue {
 
 	unsigned short data_size;
 	unsigned short desc_size;
+
+	unsigned short usb_endpoint;
+	unsigned short usb_maxpacket;
 };
 
 /**
@@ -444,6 +449,19 @@ struct data_queue_desc {
 	&(__dev)->tx[(__dev)->ops->tx_queues]
 
 /**
+ * queue_next - Return pointer to next queue in list (HELPER MACRO).
+ * @__queue: Current queue for which we need the next queue
+ *
+ * Using the current queue address we take the address directly
+ * after the queue to take the next queue. Note that this macro
+ * should be used carefully since it does not protect against
+ * moving past the end of the list. (See macros &queue_end and
+ * &tx_queue_end for determining the end of the queue).
+ */
+#define queue_next(__queue) \
+	&(__queue)[1]
+
+/**
  * queue_loop - Loop through the queues within a specific range (HELPER MACRO).
  * @__entry: Pointer where the current queue entry will be stored in.
  * @__start: Start queue pointer.
@@ -453,8 +471,8 @@ struct data_queue_desc {
  */
 #define queue_loop(__entry, __start, __end)			\
 	for ((__entry) = (__start);				\
-	     prefetch(&(__entry)[1]), (__entry) != (__end);	\
-	     (__entry) = &(__entry)[1])
+	     prefetch(queue_next(__entry)), (__entry) != (__end);\
+	     (__entry) = queue_next(__entry))
 
 /**
  * queue_for_each - Loop through all queues
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 2fbf78f..83df312 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -234,10 +234,10 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry)
 	 * length of the data to usb_fill_bulk_urb. Pass the skb
 	 * to the driver to determine what the length should be.
 	 */
-	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev, entry->skb);
+	length = rt2x00dev->ops->lib->get_tx_data_len(entry);
 
 	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
-			  usb_sndbulkpipe(usb_dev, 1),
+			  usb_sndbulkpipe(usb_dev, entry->queue->usb_endpoint),
 			  entry->skb->data, length,
 			  rt2x00usb_interrupt_txdone, entry);
 
@@ -378,10 +378,11 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
 	struct usb_device *usb_dev =
 	    to_usb_device_intf(entry->queue->rt2x00dev->dev);
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
+	int pipe;
 
 	if (entry->queue->qid == QID_RX) {
-		usb_fill_bulk_urb(entry_priv->urb, usb_dev,
-				usb_rcvbulkpipe(usb_dev, 1),
+		pipe = usb_rcvbulkpipe(usb_dev, entry->queue->usb_endpoint);
+		usb_fill_bulk_urb(entry_priv->urb, usb_dev, pipe,
 				entry->skb->data, entry->skb->len,
 				rt2x00usb_interrupt_rxdone, entry);
 
@@ -393,6 +394,76 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_clear_entry);
 
+static void rt2x00usb_assign_endpoint(struct data_queue *queue,
+				      struct usb_endpoint_descriptor *ep_desc)
+{
+	struct usb_device *usb_dev = to_usb_device_intf(queue->rt2x00dev->dev);
+	int pipe;
+
+	queue->usb_endpoint = usb_endpoint_num(ep_desc);
+
+	if (queue->qid == QID_RX) {
+		pipe = usb_rcvbulkpipe(usb_dev, queue->usb_endpoint);
+		queue->usb_maxpacket = usb_maxpacket(usb_dev, pipe, 0);
+	} else {
+		pipe = usb_sndbulkpipe(usb_dev, queue->usb_endpoint);
+		queue->usb_maxpacket = usb_maxpacket(usb_dev, pipe, 1);
+	}
+
+	if (!queue->usb_maxpacket)
+		queue->usb_maxpacket = 1;
+}
+
+static int rt2x00usb_find_endpoints(struct rt2x00_dev *rt2x00dev)
+{
+	struct usb_interface *intf = to_usb_interface(rt2x00dev->dev);
+	struct usb_host_interface *intf_desc = intf->cur_altsetting;
+	struct usb_endpoint_descriptor *ep_desc;
+	struct data_queue *queue = rt2x00dev->tx;
+	struct usb_endpoint_descriptor *tx_ep_desc = NULL;
+	unsigned int i;
+
+	/*
+	 * Walk through all available endpoints to search for "bulk in"
+	 * and "bulk out" endpoints. When we find such endpoints collect
+	 * the information we need from the descriptor and assign it
+	 * to the queue.
+	 */
+	for (i = 0; i < intf_desc->desc.bNumEndpoints; i++) {
+		ep_desc = &intf_desc->endpoint[i].desc;
+
+		if (usb_endpoint_is_bulk_in(ep_desc)) {
+			rt2x00usb_assign_endpoint(rt2x00dev->rx, ep_desc);
+		} else if (usb_endpoint_is_bulk_out(ep_desc)) {
+			rt2x00usb_assign_endpoint(queue, ep_desc);
+
+			if (queue != queue_end(rt2x00dev))
+				queue = queue_next(queue);
+			tx_ep_desc = ep_desc;
+		}
+	}
+
+	/*
+	 * At least 1 endpoint for RX and 1 endpoint for TX must be available.
+	 */
+	if (!rt2x00dev->rx->usb_endpoint || !rt2x00dev->tx->usb_endpoint) {
+		ERROR(rt2x00dev, "Bulk-in/Bulk-out endpoints not found\n");
+		return -EPIPE;
+	}
+
+	/*
+	 * It might be possible not all queues have a dedicated endpoint.
+	 * Loop through all TX queues and copy the endpoint information
+	 * which we have gathered from already assigned endpoints.
+	 */
+	txall_queue_for_each(rt2x00dev, queue) {
+		if (!queue->usb_endpoint)
+			rt2x00usb_assign_endpoint(queue, tx_ep_desc);
+	}
+
+	return 0;
+}
+
 static int rt2x00usb_alloc_urb(struct rt2x00_dev *rt2x00dev,
 			       struct data_queue *queue)
 {
@@ -464,6 +535,13 @@ int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev)
 	int status;
 
 	/*
+	 * Find endpoints for each queue
+	 */
+	status = rt2x00usb_find_endpoints(rt2x00dev);
+	if (status)
+		goto exit;
+
+	/*
 	 * Allocate DMA
 	 */
 	queue_for_each(rt2x00dev, queue) {
@@ -554,11 +632,6 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 
-	rt2x00dev->usb_maxpacket =
-	    usb_maxpacket(usb_dev, usb_sndbulkpipe(usb_dev, 1), 1);
-	if (!rt2x00dev->usb_maxpacket)
-		rt2x00dev->usb_maxpacket = 1;
-
 	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
 		goto exit_free_device;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index bf4e41f..0c39384 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1508,8 +1508,7 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 	entry->skb = NULL;
 }
 
-static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
-				   struct sk_buff *skb)
+static int rt73usb_get_tx_data_len(struct queue_entry *entry)
 {
 	int length;
 
@@ -1517,8 +1516,8 @@ static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 	 * The length _must_ be a multiple of 4,
 	 * but it must _not_ be a multiple of the USB packet size.
 	 */
-	length = roundup(skb->len, 4);
-	length += (4 * !(length % rt2x00dev->usb_maxpacket));
+	length = roundup(entry->skb->len, 4);
+	length += (4 * !(length % entry->queue->usb_maxpacket));
 
 	return length;
 }
-- 
1.5.6.1

