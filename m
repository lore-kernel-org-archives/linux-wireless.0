Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34283 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0BGIVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 03:21:37 -0500
Subject: [PATCH 06/10] b43legacy: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 07 Feb 2010 10:21:28 +0200
Message-ID: <20100207082128.31474.84867.stgit@tikku>
In-Reply-To: <20100207082044.31474.48583.stgit@tikku>
References: <20100207082044.31474.48583.stgit@tikku>
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
 drivers/net/wireless/b43legacy/dma.c  |   19 -------------------
 drivers/net/wireless/b43legacy/dma.h  |    8 --------
 drivers/net/wireless/b43legacy/main.c |   24 ------------------------
 drivers/net/wireless/b43legacy/pio.c  |   12 ------------
 drivers/net/wireless/b43legacy/pio.h  |    7 -------
 5 files changed, 0 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index 0a86bdf..e9a33b3 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -1527,25 +1527,6 @@ void b43legacy_dma_handle_txstatus(struct b43legacy_wldev *dev,
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
index 2f18600..a7dac14 100644
--- a/drivers/net/wireless/b43legacy/dma.h
+++ b/drivers/net/wireless/b43legacy/dma.h
@@ -292,9 +292,6 @@ void b43legacy_dma_free(struct b43legacy_wldev *dev);
 void b43legacy_dma_tx_suspend(struct b43legacy_wldev *dev);
 void b43legacy_dma_tx_resume(struct b43legacy_wldev *dev);
 
-void b43legacy_dma_get_tx_stats(struct b43legacy_wldev *dev,
-				struct ieee80211_tx_queue_stats *stats);
-
 int b43legacy_dma_tx(struct b43legacy_wldev *dev,
 		     struct sk_buff *skb);
 void b43legacy_dma_handle_txstatus(struct b43legacy_wldev *dev,
@@ -315,11 +312,6 @@ void b43legacy_dma_free(struct b43legacy_wldev *dev)
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
index 51866c9..3c743f2 100644
--- a/drivers/net/wireless/b43legacy/pio.c
+++ b/drivers/net/wireless/b43legacy/pio.c
@@ -546,18 +546,6 @@ void b43legacy_pio_handle_txstatus(struct b43legacy_wldev *dev,
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
index 464fec0..dc551fc 100644
--- a/drivers/net/wireless/b43legacy/pio.h
+++ b/drivers/net/wireless/b43legacy/pio.h
@@ -106,8 +106,6 @@ int b43legacy_pio_tx(struct b43legacy_wldev *dev,
 		   struct sk_buff *skb);
 void b43legacy_pio_handle_txstatus(struct b43legacy_wldev *dev,
 				 const struct b43legacy_txstatus *status);
-void b43legacy_pio_get_tx_stats(struct b43legacy_wldev *dev,
-			      struct ieee80211_tx_queue_stats *stats);
 void b43legacy_pio_rx(struct b43legacy_pioqueue *queue);
 
 /* Suspend TX queue in hardware. */
@@ -140,11 +138,6 @@ void b43legacy_pio_handle_txstatus(struct b43legacy_wldev *dev,
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

