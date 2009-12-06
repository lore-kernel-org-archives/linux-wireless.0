Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:54018 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbZLFNkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 08:40:25 -0500
Message-ID: <4B1BB44E.90706@gmail.com>
Date: Sun, 06 Dec 2009 14:40:30 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Tim Blechmann <tim@klingt.org>
CC: rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in	2.6.32
References: <20091204233202.GA13658@basil.fritz.box>
In-Reply-To: <20091204233202.GA13658@basil.fritz.box>
Content-Type: multipart/mixed;
 boundary="------------080001070906020002000302"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080001070906020002000302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/05/09 00:32, Andi Kleen wrote:
> [Rafael, something for your regression list]
> 
> I upgraded a system which was running 2.6.30 to 2.6.32.
> It has a 
> 
> 06:02.0 Network controller: RaLink RT2561/RT61 802.11g PCI
> 
> wireless PCI card. Now regularly even under moderate traffic
> I see messages like
> 
> phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
> Please file bug report to http://rt2x00.serialmonkey.com.
> 
> and loss of connectivity, often until the wireless connection
> is restarted. This wasn't the case in 2.6.30, there the driver
> ran stable without any problems. The problem currently
> happens every few minutes.
> 

Andi, Tim,

Both of you have reported this problem on 2.6.32.

In the past this always has occurred due to queue locking problems. This led me
to audit the queue locking code, and that certainly looked suspicious to me.

Would you be able to test whether the attached test patch fixes the problem for
you. The patch basically applies proper queue locking to the code, although in 
a very course manner. The patch is relative to 2.6.32.

Note: I am not 100% sure that this is where the problem is, but at least the test
patch should confirm whether I am searching in the right direction.

---
Gertjan.


--------------080001070906020002000302
Content-Type: text/plain;
 name="2.6.32-tx_entry_not_free.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2.6.32-tx_entry_not_free.diff"

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index e7f4640..6f10de1 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1193,6 +1193,9 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 	struct queue_entry *entry;
 	struct txdone_entry_desc txdesc;
 	u32 word;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&queue->lock, irqflags);
 
 	while (!rt2x00queue_empty(queue)) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
@@ -1222,6 +1225,8 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 
 		rt2x00lib_txdone(entry, &txdesc);
 	}
+
+	spin_unlock_irqrestore(&queue->lock, irqflags);
 }
 
 static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 408fcfc..7e3a724 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1330,6 +1330,9 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 	struct queue_entry *entry;
 	struct txdone_entry_desc txdesc;
 	u32 word;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&queue->lock, irqflags);
 
 	while (!rt2x00queue_empty(queue)) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
@@ -1359,6 +1362,8 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 
 		rt2x00lib_txdone(entry, &txdesc);
 	}
+
+	spin_unlock_irqrestore(&queue->lock, irqflags);
 }
 
 static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 801be43..60c0be5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -101,6 +101,9 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 	struct queue_entry *entry;
 	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(&queue->lock, irqflags);
 
 	while (1) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX);
@@ -121,6 +124,8 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		 */
 		rt2x00lib_rxdone(rt2x00dev, entry);
 	}
+
+	spin_unlock_irqrestore(&queue->lock, irqflags);
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 3d8fb68..3577627 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -453,20 +453,29 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 			       bool local)
 {
 	struct ieee80211_tx_info *tx_info;
-	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
+	struct queue_entry *entry;
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc;
 	u8 rate_idx, rate_flags;
+	unsigned long irqflags;
+	int ret = 0;
 
-	if (unlikely(rt2x00queue_full(queue)))
-		return -ENOBUFS;
+	spin_lock_irqsave(&queue->lock, irqflags);
+
+	entry = rt2x00queue_get_entry(queue, Q_INDEX);
+
+	if (unlikely(rt2x00queue_full(queue))) {
+		ret = -ENOBUFS;
+		goto out;
+	}
 
 	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags)) {
 		ERROR(queue->rt2x00dev,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
 		      queue->qid, DRV_PROJECT);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/*
@@ -528,7 +537,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	if (unlikely(queue->rt2x00dev->ops->lib->write_tx_data(entry))) {
 		clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 		entry->skb = NULL;
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	if (test_bit(DRIVER_REQUIRE_DMA, &queue->rt2x00dev->flags))
@@ -539,6 +549,9 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	rt2x00queue_index_inc(queue, Q_INDEX);
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 
+out:
+	spin_unlock_irqrestore(&queue->lock, irqflags);
+
 	return 0;
 }
 
@@ -642,7 +655,6 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 					  enum queue_index index)
 {
 	struct queue_entry *entry;
-	unsigned long irqflags;
 
 	if (unlikely(index >= Q_INDEX_MAX)) {
 		ERROR(queue->rt2x00dev,
@@ -650,28 +662,20 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 		return NULL;
 	}
 
-	spin_lock_irqsave(&queue->lock, irqflags);
-
 	entry = &queue->entries[queue->index[index]];
 
-	spin_unlock_irqrestore(&queue->lock, irqflags);
-
 	return entry;
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_get_entry);
 
 void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 {
-	unsigned long irqflags;
-
 	if (unlikely(index >= Q_INDEX_MAX)) {
 		ERROR(queue->rt2x00dev,
 		      "Index change on invalid index type (%d)\n", index);
 		return;
 	}
 
-	spin_lock_irqsave(&queue->lock, irqflags);
-
 	queue->index[index]++;
 	if (queue->index[index] >= queue->limit)
 		queue->index[index] = 0;
@@ -682,8 +686,6 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 		queue->length--;
 		queue->count++;
 	}
-
-	spin_unlock_irqrestore(&queue->lock, irqflags);
 }
 
 static void rt2x00queue_reset(struct data_queue *queue)
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 0a751e7..3b05a29 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -270,7 +270,6 @@ void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 			     const enum data_queue_qid qid)
 {
 	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, qid);
-	unsigned long irqflags;
 	unsigned int index;
 	unsigned int index_done;
 	unsigned int i;
@@ -281,10 +280,8 @@ void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	 * it should not be kicked during this run, since it
 	 * is part of another TX operation.
 	 */
-	spin_lock_irqsave(&queue->lock, irqflags);
 	index = queue->index[Q_INDEX];
 	index_done = queue->index[Q_INDEX_DONE];
-	spin_unlock_irqrestore(&queue->lock, irqflags);
 
 	/*
 	 * Start from the TX done pointer, this guarentees that we will
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 687e17d..6ed29c8 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2037,6 +2037,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	u32 old_reg;
 	int type;
 	int index;
+	unsigned long irqflags;
 
 	/*
 	 * During each loop we will compare the freshly read
@@ -2074,13 +2075,17 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		if (unlikely(index >= queue->limit))
 			continue;
 
+		spin_lock_irqsave(&queue->lock, irqflags);
+
 		entry = &queue->entries[index];
 		entry_priv = entry->priv_data;
 		rt2x00_desc_read(entry_priv->desc, 0, &word);
 
 		if (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
-		    !rt2x00_get_field32(word, TXD_W0_VALID))
+		    !rt2x00_get_field32(word, TXD_W0_VALID)) {
+			spin_unlock_irqrestore(&queue->lock, irqflags);
 			return;
+		}
 
 		entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		while (entry != entry_done) {
@@ -2116,6 +2121,8 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		txdesc.retry = rt2x00_get_field32(reg, STA_CSR4_RETRY_COUNT);
 
 		rt2x00lib_txdone(entry, &txdesc);
+
+		spin_unlock_irqrestore(&queue->lock, irqflags);
 	}
 }
 

--------------080001070906020002000302--
