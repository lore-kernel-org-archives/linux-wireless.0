Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:49822 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab0BGRvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 12:51:10 -0500
Subject: [PATCH v2 2/2] b43legacy: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 07 Feb 2010 19:51:00 +0200
Message-ID: <20100207175100.8553.75762.stgit@tikku>
In-Reply-To: <87d40hhtc5.fsf@purkki.valot.fi>
References: <87d40hhtc5.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_tx_stats() will be removed from mac80211.

Compile-tested only.

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 drivers/net/wireless/b43legacy/dma.c  |   20 --------------------
 drivers/net/wireless/b43legacy/dma.h  |   10 ----------
 drivers/net/wireless/b43legacy/main.c |   24 ------------------------
 drivers/net/wireless/b43legacy/pio.c  |   13 -------------
 drivers/net/wireless/b43legacy/pio.h  |   11 -----------
 5 files changed, 0 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index 0a86bdf..8b9387c 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -1411,7 +1411,6 @@ int b43legacy_dma_tx(struct b43legacy_wldev *dev,
 		b43legacyerr(dev->wl, "DMA tx mapping failure\n");
 		goto out_unlock;
 	}
-	ring->nr_tx_packets++;
 	if ((free_slots(ring) < SLOTS_PER_PACKET) ||
 	    should_inject_overflow(ring)) {
 		/* This TX ring is full. */
@@ -1527,25 +1526,6 @@ void b43legacy_dma_handle_txstatus(struct b43legacy_wldev *dev,
 	spin_unlock(&ring->lock);
 }
 
-void b43legacy_dma_get_tx_stats(struct b43legacy_wldev *dev,
-			      struct ieee80211_tx_queue_stats *stats)
-{
-	const int nr_queues = dev->wl->hw->queues;
-	struct b43legacy_dmaring *ring;
-	unsigned long flags;
-	int i;
-
-	for (i = 0; i < nr_queues; i++) {
-		ring = priority_to_txring(dev, i);
-
-		spin_lock_irqsave(&ring->lock, flags);
-		stats[i].len = ring->used_slots / SLOTS_PER_PACKET;
-		stats[i].limit = ring->nr_slots / SLOTS_PER_PACKET;
-		stats[i].count = ring->nr_tx_packets;
-		spin_unlock_irqrestore(&ring->lock, flags);
-	}
-}
-
 static void dma_rx(struct b43legacy_dmaring *ring,
 		   int *slot)
 {
diff --git a/drivers/net/wireless/b43legacy/dma.h b/drivers/net/wireless/b43legacy/dma.h
index 2f18600..f968104 100644
--- a/drivers/net/wireless/b43legacy/dma.h
+++ b/drivers/net/wireless/b43legacy/dma.h
@@ -243,8 +243,6 @@ struct b43legacy_dmaring {
 	int used_slots;
 	/* Currently used slot in the ring. */
 	int current_slot;
-	/* Total number of packets sent. Statistics only. */
-	unsigned int nr_tx_packets;
 	/* Frameoffset in octets. */
 	u32 frameoffset;
 	/* Descriptor buffer size. */
@@ -292,9 +290,6 @@ void b43legacy_dma_free(struct b43legacy_wldev *dev);
 void b43legacy_dma_tx_suspend(struct b43legacy_wldev *dev);
 void b43legacy_dma_tx_resume(struct b43legacy_wldev *dev);
 
-void b43legacy_dma_get_tx_stats(struct b43legacy_wldev *dev,
-				struct ieee80211_tx_queue_stats *stats);
-
 int b43legacy_dma_tx(struct b43legacy_wldev *dev,
 		     struct sk_buff *skb);
 void b43legacy_dma_handle_txstatus(struct b43legacy_wldev *dev,
@@ -315,11 +310,6 @@ void b43legacy_dma_free(struct b43legacy_wldev *dev)
 {
 }
 static inline
-void b43legacy_dma_get_tx_stats(struct b43legacy_wldev *dev,
-				struct ieee80211_tx_queue_stats *stats)
-{
-}
-static inline
 int b43legacy_dma_tx(struct b43legacy_wldev *dev,
 		     struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 874a64a..d56f86c 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2446,29 +2446,6 @@ static int b43legacy_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return 0;
 }
 
-static int b43legacy_op_get_tx_stats(struct ieee80211_hw *hw,
-				     struct ieee80211_tx_queue_stats *stats)
-{
-	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
-	struct b43legacy_wldev *dev = wl->current_dev;
-	unsigned long flags;
-	int err = -ENODEV;
-
-	if (!dev)
-		goto out;
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (likely(b43legacy_status(dev) >= B43legacy_STAT_STARTED)) {
-		if (b43legacy_using_pio(dev))
-			b43legacy_pio_get_tx_stats(dev, stats);
-		else
-			b43legacy_dma_get_tx_stats(dev, stats);
-		err = 0;
-	}
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-out:
-	return err;
-}
-
 static int b43legacy_op_get_stats(struct ieee80211_hw *hw,
 				  struct ieee80211_low_level_stats *stats)
 {
@@ -3511,7 +3488,6 @@ static const struct ieee80211_ops b43legacy_hw_ops = {
 	.bss_info_changed	= b43legacy_op_bss_info_changed,
 	.configure_filter	= b43legacy_op_configure_filter,
 	.get_stats		= b43legacy_op_get_stats,
-	.get_tx_stats		= b43legacy_op_get_tx_stats,
 	.start			= b43legacy_op_start,
 	.stop			= b43legacy_op_stop,
 	.set_tim		= b43legacy_op_beacon_set_tim,
diff --git a/drivers/net/wireless/b43legacy/pio.c b/drivers/net/wireless/b43legacy/pio.c
index 51866c9..017c0e9 100644
--- a/drivers/net/wireless/b43legacy/pio.c
+++ b/drivers/net/wireless/b43legacy/pio.c
@@ -477,7 +477,6 @@ int b43legacy_pio_tx(struct b43legacy_wldev *dev,
 
 	list_move_tail(&packet->list, &queue->txqueue);
 	queue->nr_txfree--;
-	queue->nr_tx_packets++;
 	B43legacy_WARN_ON(queue->nr_txfree >= B43legacy_PIO_MAXTXPACKETS);
 
 	tasklet_schedule(&queue->txtask);
@@ -546,18 +545,6 @@ void b43legacy_pio_handle_txstatus(struct b43legacy_wldev *dev,
 		tasklet_schedule(&queue->txtask);
 }
 
-void b43legacy_pio_get_tx_stats(struct b43legacy_wldev *dev,
-				struct ieee80211_tx_queue_stats *stats)
-{
-	struct b43legacy_pio *pio = &dev->pio;
-	struct b43legacy_pioqueue *queue;
-
-	queue = pio->queue1;
-	stats[0].len = B43legacy_PIO_MAXTXPACKETS - queue->nr_txfree;
-	stats[0].limit = B43legacy_PIO_MAXTXPACKETS;
-	stats[0].count = queue->nr_tx_packets;
-}
-
 static void pio_rx_error(struct b43legacy_pioqueue *queue,
 			 int clear_buffers,
 			 const char *error)
diff --git a/drivers/net/wireless/b43legacy/pio.h b/drivers/net/wireless/b43legacy/pio.h
index 464fec0..8e6773e 100644
--- a/drivers/net/wireless/b43legacy/pio.h
+++ b/drivers/net/wireless/b43legacy/pio.h
@@ -74,10 +74,6 @@ struct b43legacy_pioqueue {
 	 * posted to the device. We are waiting for the txstatus.
 	 */
 	struct list_head txrunning;
-	/* Total number or packets sent.
-	 * (This counter can obviously wrap).
-	 */
-	unsigned int nr_tx_packets;
 	struct tasklet_struct txtask;
 	struct b43legacy_pio_txpacket
 			 tx_packets_cache[B43legacy_PIO_MAXTXPACKETS];
@@ -106,8 +102,6 @@ int b43legacy_pio_tx(struct b43legacy_wldev *dev,
 		   struct sk_buff *skb);
 void b43legacy_pio_handle_txstatus(struct b43legacy_wldev *dev,
 				 const struct b43legacy_txstatus *status);
-void b43legacy_pio_get_tx_stats(struct b43legacy_wldev *dev,
-			      struct ieee80211_tx_queue_stats *stats);
 void b43legacy_pio_rx(struct b43legacy_pioqueue *queue);
 
 /* Suspend TX queue in hardware. */
@@ -140,11 +134,6 @@ void b43legacy_pio_handle_txstatus(struct b43legacy_wldev *dev,
 {
 }
 static inline
-void b43legacy_pio_get_tx_stats(struct b43legacy_wldev *dev,
-			      struct ieee80211_tx_queue_stats *stats)
-{
-}
-static inline
 void b43legacy_pio_rx(struct b43legacy_pioqueue *queue)
 {
 }

