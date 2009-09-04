Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34162 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934025AbZIDU6P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2009 16:58:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/5] b43: Remove DMA/PIO queue locks
Date: Fri, 4 Sep 2009 22:55:00 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Message-Id: <200909042255.01072.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the DMA/PIO queue locks. Locking is handled by
wl->mutex now.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-08-23 13:43:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-08-23 14:21:21.000000000 +0200
@@ -856,7 +856,6 @@ struct b43_dmaring *b43_setup_dmaring(st
 		} else
 			B43_WARN_ON(1);
 	}
-	spin_lock_init(&ring->lock);
 #ifdef CONFIG_B43_DEBUG
 	ring->last_injected_overflow = jiffies;
 #endif
@@ -1315,7 +1314,6 @@ int b43_dma_tx(struct b43_wldev *dev, st
 	struct b43_dmaring *ring;
 	struct ieee80211_hdr *hdr;
 	int err = 0;
-	unsigned long flags;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -1331,8 +1329,6 @@ int b43_dma_tx(struct b43_wldev *dev, st
 			dev, skb_get_queue_mapping(skb));
 	}
 
-	spin_lock_irqsave(&ring->lock, flags);
-
 	B43_WARN_ON(!ring->tx);
 
 	if (unlikely(ring->stopped)) {
@@ -1343,7 +1339,7 @@ int b43_dma_tx(struct b43_wldev *dev, st
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE))
 			b43err(dev->wl, "Packet after queue stopped\n");
 		err = -ENOSPC;
-		goto out_unlock;
+		goto out;
 	}
 
 	if (unlikely(WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME))) {
@@ -1351,7 +1347,7 @@ int b43_dma_tx(struct b43_wldev *dev, st
 		 * full, but queues not stopped. */
 		b43err(dev->wl, "DMA queue overflow\n");
 		err = -ENOSPC;
-		goto out_unlock;
+		goto out;
 	}
 
 	/* Assign the queue number to the ring (if not already done before)
@@ -1365,11 +1361,11 @@ int b43_dma_tx(struct b43_wldev *dev, st
 		 * anymore and must not transmit it unencrypted. */
 		dev_kfree_skb_any(skb);
 		err = 0;
-		goto out_unlock;
+		goto out;
 	}
 	if (unlikely(err)) {
 		b43err(dev->wl, "DMA tx mapping failure\n");
-		goto out_unlock;
+		goto out;
 	}
 	ring->nr_tx_packets++;
 	if ((free_slots(ring) < TX_SLOTS_PER_FRAME) ||
@@ -1381,8 +1377,7 @@ int b43_dma_tx(struct b43_wldev *dev, st
 			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
 		}
 	}
-out_unlock:
-	spin_unlock_irqrestore(&ring->lock, flags);
+out:
 
 	return err;
 }
@@ -1401,8 +1396,6 @@ void b43_dma_handle_txstatus(struct b43_
 	if (unlikely(!ring))
 		return;
 
-	spin_lock_irq(&ring->lock);
-
 	B43_WARN_ON(!ring->tx);
 	ops = ring->ops;
 	while (1) {
@@ -1461,8 +1454,6 @@ void b43_dma_handle_txstatus(struct b43_
 			b43dbg(dev->wl, "Woke up TX ring %d\n", ring->index);
 		}
 	}
-
-	spin_unlock_irq(&ring->lock);
 }
 
 void b43_dma_get_tx_stats(struct b43_wldev *dev,
@@ -1470,17 +1461,14 @@ void b43_dma_get_tx_stats(struct b43_wld
 {
 	const int nr_queues = dev->wl->hw->queues;
 	struct b43_dmaring *ring;
-	unsigned long flags;
 	int i;
 
 	for (i = 0; i < nr_queues; i++) {
 		ring = select_ring_by_priority(dev, i);
 
-		spin_lock_irqsave(&ring->lock, flags);
 		stats[i].len = ring->used_slots / TX_SLOTS_PER_FRAME;
 		stats[i].limit = ring->nr_slots / TX_SLOTS_PER_FRAME;
 		stats[i].count = ring->nr_tx_packets;
-		spin_unlock_irqrestore(&ring->lock, flags);
 	}
 }
 
@@ -1591,22 +1579,14 @@ void b43_dma_rx(struct b43_dmaring *ring
 
 static void b43_dma_tx_suspend_ring(struct b43_dmaring *ring)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&ring->lock, flags);
 	B43_WARN_ON(!ring->tx);
 	ring->ops->tx_suspend(ring);
-	spin_unlock_irqrestore(&ring->lock, flags);
 }
 
 static void b43_dma_tx_resume_ring(struct b43_dmaring *ring)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&ring->lock, flags);
 	B43_WARN_ON(!ring->tx);
 	ring->ops->tx_resume(ring);
-	spin_unlock_irqrestore(&ring->lock, flags);
 }
 
 void b43_dma_tx_suspend(struct b43_wldev *dev)
Index: wireless-testing/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.h	2009-08-23 13:43:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.h	2009-08-23 14:21:21.000000000 +0200
@@ -2,7 +2,6 @@
 #define B43_DMA_H_
 
 #include <linux/ieee80211.h>
-#include <linux/spinlock.h>
 
 #include "b43.h"
 
@@ -244,8 +243,6 @@ struct b43_dmaring {
 	/* The QOS priority assigned to this ring. Only used for TX rings.
 	 * This is the mac80211 "queue" value. */
 	u8 queue_prio;
-	/* Lock, only used for TX. */
-	spinlock_t lock;
 	struct b43_wldev *dev;
 #ifdef CONFIG_B43_DEBUG
 	/* Maximum number of used slots. */
Index: wireless-testing/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.c	2009-08-23 13:43:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/pio.c	2009-08-23 14:21:21.000000000 +0200
@@ -144,7 +144,6 @@ static struct b43_pio_txqueue *b43_setup
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q)
 		return NULL;
-	spin_lock_init(&q->lock);
 	q->dev = dev;
 	q->rev = dev->dev->id.revision;
 	q->mmio_base = index_to_pioqueue_base(dev, index) +
@@ -179,7 +178,6 @@ static struct b43_pio_rxqueue *b43_setup
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q)
 		return NULL;
-	spin_lock_init(&q->lock);
 	q->dev = dev;
 	q->rev = dev->dev->id.revision;
 	q->mmio_base = index_to_pioqueue_base(dev, index) +
@@ -494,7 +492,6 @@ int b43_pio_tx(struct b43_wldev *dev, st
 {
 	struct b43_pio_txqueue *q;
 	struct ieee80211_hdr *hdr;
-	unsigned long flags;
 	unsigned int hdrlen, total_len;
 	int err = 0;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -512,20 +509,18 @@ int b43_pio_tx(struct b43_wldev *dev, st
 		q = select_queue_by_priority(dev, skb_get_queue_mapping(skb));
 	}
 
-	spin_lock_irqsave(&q->lock, flags);
-
 	hdrlen = b43_txhdr_size(dev);
 	total_len = roundup(skb->len + hdrlen, 4);
 
 	if (unlikely(total_len > q->buffer_size)) {
 		err = -ENOBUFS;
 		b43dbg(dev->wl, "PIO: TX packet longer than queue.\n");
-		goto out_unlock;
+		goto out;
 	}
 	if (unlikely(q->free_packet_slots == 0)) {
 		err = -ENOBUFS;
 		b43warn(dev->wl, "PIO: TX packet overflow.\n");
-		goto out_unlock;
+		goto out;
 	}
 	B43_WARN_ON(q->buffer_used > q->buffer_size);
 
@@ -534,7 +529,7 @@ int b43_pio_tx(struct b43_wldev *dev, st
 		err = -EBUSY;
 		ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb));
 		q->stopped = 1;
-		goto out_unlock;
+		goto out;
 	}
 
 	/* Assign the queue number to the ring (if not already done before)
@@ -548,11 +543,11 @@ int b43_pio_tx(struct b43_wldev *dev, st
 		 * anymore and must not transmit it unencrypted. */
 		dev_kfree_skb_any(skb);
 		err = 0;
-		goto out_unlock;
+		goto out;
 	}
 	if (unlikely(err)) {
 		b43err(dev->wl, "PIO transmission failure\n");
-		goto out_unlock;
+		goto out;
 	}
 	q->nr_tx_packets++;
 
@@ -564,9 +559,7 @@ int b43_pio_tx(struct b43_wldev *dev, st
 		q->stopped = 1;
 	}
 
-out_unlock:
-	spin_unlock_irqrestore(&q->lock, flags);
-
+out:
 	return err;
 }
 
@@ -583,8 +576,6 @@ void b43_pio_handle_txstatus(struct b43_
 		return;
 	B43_WARN_ON(!pack);
 
-	spin_lock_irq(&q->lock);
-
 	info = IEEE80211_SKB_CB(pack->skb);
 
 	b43_fill_txstatus_report(dev, info, status);
@@ -602,8 +593,6 @@ void b43_pio_handle_txstatus(struct b43_
 		ieee80211_wake_queue(dev->wl->hw, q->queue_prio);
 		q->stopped = 0;
 	}
-
-	spin_unlock_irq(&q->lock);
 }
 
 void b43_pio_get_tx_stats(struct b43_wldev *dev,
@@ -611,17 +600,14 @@ void b43_pio_get_tx_stats(struct b43_wld
 {
 	const int nr_queues = dev->wl->hw->queues;
 	struct b43_pio_txqueue *q;
-	unsigned long flags;
 	int i;
 
 	for (i = 0; i < nr_queues; i++) {
 		q = select_queue_by_priority(dev, i);
 
-		spin_lock_irqsave(&q->lock, flags);
 		stats[i].len = B43_PIO_MAX_NR_TXPACKETS - q->free_packet_slots;
 		stats[i].limit = B43_PIO_MAX_NR_TXPACKETS;
 		stats[i].count = q->nr_tx_packets;
-		spin_unlock_irqrestore(&q->lock, flags);
 	}
 }
 
@@ -768,9 +754,9 @@ static void b43_pio_rx_work(struct work_
 	bool stop;
 
 	do {
-		spin_lock_irq(&q->lock);
+		mutex_lock(&q->dev->wl->mutex);
 		stop = (pio_rx_frame(q) == 0);
-		spin_unlock_irq(&q->lock);
+		mutex_unlock(&q->dev->wl->mutex);
 		cond_resched();
 		if (stop)
 			break;
@@ -787,9 +773,6 @@ void b43_pio_rx(struct b43_pio_rxqueue *
 
 static void b43_pio_tx_suspend_queue(struct b43_pio_txqueue *q)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->lock, flags);
 	if (q->rev >= 8) {
 		b43_piotx_write32(q, B43_PIO8_TXCTL,
 				  b43_piotx_read32(q, B43_PIO8_TXCTL)
@@ -799,14 +782,10 @@ static void b43_pio_tx_suspend_queue(str
 				  b43_piotx_read16(q, B43_PIO_TXCTL)
 				  | B43_PIO_TXCTL_SUSPREQ);
 	}
-	spin_unlock_irqrestore(&q->lock, flags);
 }
 
 static void b43_pio_tx_resume_queue(struct b43_pio_txqueue *q)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->lock, flags);
 	if (q->rev >= 8) {
 		b43_piotx_write32(q, B43_PIO8_TXCTL,
 				  b43_piotx_read32(q, B43_PIO8_TXCTL)
@@ -816,7 +795,6 @@ static void b43_pio_tx_resume_queue(stru
 				  b43_piotx_read16(q, B43_PIO_TXCTL)
 				  & ~B43_PIO_TXCTL_SUSPREQ);
 	}
-	spin_unlock_irqrestore(&q->lock, flags);
 }
 
 void b43_pio_tx_suspend(struct b43_wldev *dev)
Index: wireless-testing/drivers/net/wireless/b43/pio.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.h	2009-08-23 13:43:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/pio.h	2009-08-23 14:21:21.000000000 +0200
@@ -70,7 +70,6 @@ struct b43_pio_txpacket {
 
 struct b43_pio_txqueue {
 	struct b43_wldev *dev;
-	spinlock_t lock;
 	u16 mmio_base;
 
 	/* The device queue buffer size in bytes. */
@@ -103,7 +102,6 @@ struct b43_pio_txqueue {
 
 struct b43_pio_rxqueue {
 	struct b43_wldev *dev;
-	spinlock_t lock;
 	u16 mmio_base;
 
 	/* Work to reduce latency issues on RX. */

-- 
Greetings, Michael.
