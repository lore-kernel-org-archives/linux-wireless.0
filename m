Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:35891 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab0BGRvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 12:51:03 -0500
Subject: [PATCH v2 1/2] b43: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 07 Feb 2010 19:50:50 +0200
Message-ID: <20100207175050.8553.90786.stgit@tikku>
In-Reply-To: <87d40hhtc5.fsf@purkki.valot.fi>
References: <87d40hhtc5.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_tx_stats() will be removed from mac80211.

Compile-tested only.

Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 drivers/net/wireless/b43/dma.c  |   17 -----------------
 drivers/net/wireless/b43/dma.h  |    5 -----
 drivers/net/wireless/b43/main.c |   22 ----------------------
 drivers/net/wireless/b43/pio.c  |   17 -----------------
 drivers/net/wireless/b43/pio.h  |    5 -----
 5 files changed, 0 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 615af22..be7abf8 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1369,7 +1369,6 @@ int b43_dma_tx(struct b43_wldev *dev, struct sk_buff *skb)
 		b43err(dev->wl, "DMA tx mapping failure\n");
 		goto out;
 	}
-	ring->nr_tx_packets++;
 	if ((free_slots(ring) < TX_SLOTS_PER_FRAME) ||
 	    should_inject_overflow(ring)) {
 		/* This TX ring is full. */
@@ -1500,22 +1499,6 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 	}
 }
 
-void b43_dma_get_tx_stats(struct b43_wldev *dev,
-			  struct ieee80211_tx_queue_stats *stats)
-{
-	const int nr_queues = dev->wl->hw->queues;
-	struct b43_dmaring *ring;
-	int i;
-
-	for (i = 0; i < nr_queues; i++) {
-		ring = select_ring_by_priority(dev, i);
-
-		stats[i].len = ring->used_slots / TX_SLOTS_PER_FRAME;
-		stats[i].limit = ring->nr_slots / TX_SLOTS_PER_FRAME;
-		stats[i].count = ring->nr_tx_packets;
-	}
-}
-
 static void dma_rx(struct b43_dmaring *ring, int *slot)
 {
 	const struct b43_dma_ops *ops = ring->ops;
diff --git a/drivers/net/wireless/b43/dma.h b/drivers/net/wireless/b43/dma.h
index f7ab37c..dc91944 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -228,8 +228,6 @@ struct b43_dmaring {
 	int used_slots;
 	/* Currently used slot in the ring. */
 	int current_slot;
-	/* Total number of packets sent. Statistics only. */
-	unsigned int nr_tx_packets;
 	/* Frameoffset in octets. */
 	u32 frameoffset;
 	/* Descriptor buffer size. */
@@ -278,9 +276,6 @@ void b43_dma_free(struct b43_wldev *dev);
 void b43_dma_tx_suspend(struct b43_wldev *dev);
 void b43_dma_tx_resume(struct b43_wldev *dev);
 
-void b43_dma_get_tx_stats(struct b43_wldev *dev,
-			  struct ieee80211_tx_queue_stats *stats);
-
 int b43_dma_tx(struct b43_wldev *dev,
 	       struct sk_buff *skb);
 void b43_dma_handle_txstatus(struct b43_wldev *dev,
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 6a87e08..eba3978 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3356,27 +3356,6 @@ out_unlock:
 	return err;
 }
 
-static int b43_op_get_tx_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_tx_queue_stats *stats)
-{
-	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev;
-	int err = -ENODEV;
-
-	mutex_lock(&wl->mutex);
-	dev = wl->current_dev;
-	if (dev && b43_status(dev) >= B43_STAT_STARTED) {
-		if (b43_using_pio_transfers(dev))
-			b43_pio_get_tx_stats(dev, stats);
-		else
-			b43_dma_get_tx_stats(dev, stats);
-		err = 0;
-	}
-	mutex_unlock(&wl->mutex);
-
-	return err;
-}
-
 static int b43_op_get_stats(struct ieee80211_hw *hw,
 			    struct ieee80211_low_level_stats *stats)
 {
@@ -4603,7 +4582,6 @@ static const struct ieee80211_ops b43_hw_ops = {
 	.set_key		= b43_op_set_key,
 	.update_tkip_key	= b43_op_update_tkip_key,
 	.get_stats		= b43_op_get_stats,
-	.get_tx_stats		= b43_op_get_tx_stats,
 	.get_tsf		= b43_op_get_tsf,
 	.set_tsf		= b43_op_set_tsf,
 	.start			= b43_op_start,
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index c01b8e0..a6062c3 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -559,7 +559,6 @@ int b43_pio_tx(struct b43_wldev *dev, struct sk_buff *skb)
 		b43err(dev->wl, "PIO transmission failure\n");
 		goto out;
 	}
-	q->nr_tx_packets++;
 
 	B43_WARN_ON(q->buffer_used > q->buffer_size);
 	if (((q->buffer_size - q->buffer_used) < roundup(2 + 2 + 6, 4)) ||
@@ -605,22 +604,6 @@ void b43_pio_handle_txstatus(struct b43_wldev *dev,
 	}
 }
 
-void b43_pio_get_tx_stats(struct b43_wldev *dev,
-			  struct ieee80211_tx_queue_stats *stats)
-{
-	const int nr_queues = dev->wl->hw->queues;
-	struct b43_pio_txqueue *q;
-	int i;
-
-	for (i = 0; i < nr_queues; i++) {
-		q = select_queue_by_priority(dev, i);
-
-		stats[i].len = B43_PIO_MAX_NR_TXPACKETS - q->free_packet_slots;
-		stats[i].limit = B43_PIO_MAX_NR_TXPACKETS;
-		stats[i].count = q->nr_tx_packets;
-	}
-}
-
 /* Returns whether we should fetch another frame. */
 static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 {
diff --git a/drivers/net/wireless/b43/pio.h b/drivers/net/wireless/b43/pio.h
index 7b3c42f..1e51614 100644
--- a/drivers/net/wireless/b43/pio.h
+++ b/drivers/net/wireless/b43/pio.h
@@ -90,9 +90,6 @@ struct b43_pio_txqueue {
 	struct b43_pio_txpacket packets[B43_PIO_MAX_NR_TXPACKETS];
 	struct list_head packets_list;
 
-	/* Total number of transmitted packets. */
-	unsigned int nr_tx_packets;
-
 	/* Shortcut to the 802.11 core revision. This is to
 	 * avoid horrible pointer dereferencing in the fastpaths. */
 	u8 rev;
@@ -160,8 +157,6 @@ void b43_pio_free(struct b43_wldev *dev);
 int b43_pio_tx(struct b43_wldev *dev, struct sk_buff *skb);
 void b43_pio_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status);
-void b43_pio_get_tx_stats(struct b43_wldev *dev,
-			  struct ieee80211_tx_queue_stats *stats);
 void b43_pio_rx(struct b43_pio_rxqueue *q);
 
 void b43_pio_tx_suspend(struct b43_wldev *dev);

