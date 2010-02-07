Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:45463 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0BGIV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 03:21:28 -0500
Subject: [PATCH 05/10] b43: remove get_tx_stats() mac80211 op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 07 Feb 2010 10:21:19 +0200
Message-ID: <20100207082118.31474.79247.stgit@tikku>
In-Reply-To: <20100207082044.31474.48583.stgit@tikku>
References: <20100207082044.31474.48583.stgit@tikku>
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
 drivers/net/wireless/b43/dma.c  |   16 ----------------
 drivers/net/wireless/b43/dma.h  |    3 ---
 drivers/net/wireless/b43/main.c |   22 ----------------------
 drivers/net/wireless/b43/pio.c  |   16 ----------------
 drivers/net/wireless/b43/pio.h  |    2 --
 5 files changed, 0 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 615af22..02adfdb 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1500,22 +1500,6 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
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
index f7ab37c..8c3f6bc 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -278,9 +278,6 @@ void b43_dma_free(struct b43_wldev *dev);
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
index c01b8e0..3c3e9d4 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -605,22 +605,6 @@ void b43_pio_handle_txstatus(struct b43_wldev *dev,
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
index 7b3c42f..611a32e 100644
--- a/drivers/net/wireless/b43/pio.h
+++ b/drivers/net/wireless/b43/pio.h
@@ -160,8 +160,6 @@ void b43_pio_free(struct b43_wldev *dev);
 int b43_pio_tx(struct b43_wldev *dev, struct sk_buff *skb);
 void b43_pio_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status);
-void b43_pio_get_tx_stats(struct b43_wldev *dev,
-			  struct ieee80211_tx_queue_stats *stats);
 void b43_pio_rx(struct b43_pio_rxqueue *q);
 
 void b43_pio_tx_suspend(struct b43_wldev *dev);

