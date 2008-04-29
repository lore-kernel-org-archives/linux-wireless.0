Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbYD3OHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:07:00 -0400
Message-Id: <20080429152040.485831000@sipsolutions.net> (sfid-20080430_160653_172861_BF404D8C)
References: <20080429151858.253229000@sipsolutions.net>
Date: Tue, 29 Apr 2008 17:18:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: clean up get_tx_stats callback
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The callback takes a ieee80211_tx_queue_stats with a contained
array of ieee80211_tx_queue_stats_data, remove the former, rename
the latter to ieee80211_tx_queue_stats and make tx_stats() take
the array directly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/adm8211.c              |    7 +++----
 drivers/net/wireless/ath5k/base.c           |    8 ++++----
 drivers/net/wireless/ath5k/base.h           |    3 ++-
 drivers/net/wireless/b43/dma.c              |    8 +++-----
 drivers/net/wireless/b43/pio.c              |    8 +++-----
 drivers/net/wireless/b43legacy/dma.c        |    8 +++-----
 drivers/net/wireless/b43legacy/pio.c        |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +++---
 drivers/net/wireless/p54/p54.h              |    2 +-
 drivers/net/wireless/p54/p54common.c        |   24 ++++++++++--------------
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    6 +++---
 include/net/mac80211.h                      |   13 ++++---------
 13 files changed, 45 insertions(+), 62 deletions(-)

--- everything.orig/drivers/net/wireless/adm8211.c	2008-04-29 11:20:31.000000000 +0200
+++ everything/drivers/net/wireless/adm8211.c	2008-04-29 11:20:55.000000000 +0200
@@ -306,11 +306,10 @@ static int adm8211_get_tx_stats(struct i
 				struct ieee80211_tx_queue_stats *stats)
 {
 	struct adm8211_priv *priv = dev->priv;
-	struct ieee80211_tx_queue_stats_data *data = &stats->data[0];
 
-	data->len = priv->cur_tx - priv->dirty_tx;
-	data->limit = priv->tx_ring_size - 2;
-	data->count = priv->dirty_tx;
+	stats[0].len = priv->cur_tx - priv->dirty_tx;
+	stats[0].limit = priv->tx_ring_size - 2;
+	stats[0].count = priv->dirty_tx;
 
 	return 0;
 }
--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-04-29 11:20:32.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.c	2008-04-29 11:20:55.000000000 +0200
@@ -1339,7 +1339,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc
 
 	spin_lock_bh(&txq->lock);
 	list_add_tail(&bf->list, &txq->q);
-	sc->tx_stats.data[txq->qnum].len++;
+	sc->tx_stats[txq->qnum].len++;
 	if (txq->link == NULL) /* is this first packet? */
 		ath5k_hw_put_tx_buf(ah, txq->qnum, bf->daddr);
 	else /* no, so only link it */
@@ -1570,7 +1570,7 @@ ath5k_txq_drainq(struct ath5k_softc *sc,
 		ath5k_txbuf_free(sc, bf);
 
 		spin_lock_bh(&sc->txbuflock);
-		sc->tx_stats.data[txq->qnum].len--;
+		sc->tx_stats[txq->qnum].len--;
 		list_move_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
 		spin_unlock_bh(&sc->txbuflock);
@@ -1983,10 +1983,10 @@ ath5k_tx_processq(struct ath5k_softc *sc
 		}
 
 		ieee80211_tx_status(sc->hw, skb, &txs);
-		sc->tx_stats.data[txq->qnum].count++;
+		sc->tx_stats[txq->qnum].count++;
 
 		spin_lock(&sc->txbuflock);
-		sc->tx_stats.data[txq->qnum].len--;
+		sc->tx_stats[txq->qnum].len--;
 		list_move_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
 		spin_unlock(&sc->txbuflock);
--- everything.orig/drivers/net/wireless/ath5k/base.h	2008-04-29 11:20:32.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.h	2008-04-29 11:20:55.000000000 +0200
@@ -92,7 +92,8 @@ struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
-	struct ieee80211_tx_queue_stats tx_stats;
+	/* FIXME: how many does it really need? */
+	struct ieee80211_tx_queue_stats tx_stats[16];
 	struct ieee80211_low_level_stats ll_stats;
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
--- everything.orig/drivers/net/wireless/b43legacy/dma.c	2008-04-29 11:20:32.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/dma.c	2008-04-29 11:20:55.000000000 +0200
@@ -1455,18 +1455,16 @@ void b43legacy_dma_get_tx_stats(struct b
 {
 	const int nr_queues = dev->wl->hw->queues;
 	struct b43legacy_dmaring *ring;
-	struct ieee80211_tx_queue_stats_data *data;
 	unsigned long flags;
 	int i;
 
 	for (i = 0; i < nr_queues; i++) {
-		data = &(stats->data[i]);
 		ring = priority_to_txring(dev, i);
 
 		spin_lock_irqsave(&ring->lock, flags);
-		data->len = ring->used_slots / SLOTS_PER_PACKET;
-		data->limit = ring->nr_slots / SLOTS_PER_PACKET;
-		data->count = ring->nr_tx_packets;
+		stats[i].len = ring->used_slots / SLOTS_PER_PACKET;
+		stats[i].limit = ring->nr_slots / SLOTS_PER_PACKET;
+		stats[i].count = ring->nr_tx_packets;
 		spin_unlock_irqrestore(&ring->lock, flags);
 	}
 }
--- everything.orig/drivers/net/wireless/b43legacy/pio.c	2008-04-29 11:20:32.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/pio.c	2008-04-29 11:20:55.000000000 +0200
@@ -525,13 +525,11 @@ void b43legacy_pio_get_tx_stats(struct b
 {
 	struct b43legacy_pio *pio = &dev->pio;
 	struct b43legacy_pioqueue *queue;
-	struct ieee80211_tx_queue_stats_data *data;
 
 	queue = pio->queue1;
-	data = &(stats->data[0]);
-	data->len = B43legacy_PIO_MAXTXPACKETS - queue->nr_txfree;
-	data->limit = B43legacy_PIO_MAXTXPACKETS;
-	data->count = queue->nr_tx_packets;
+	stats[0].len = B43legacy_PIO_MAXTXPACKETS - queue->nr_txfree;
+	stats[0].limit = B43legacy_PIO_MAXTXPACKETS;
+	stats[0].count = queue->nr_tx_packets;
 }
 
 static void pio_rx_error(struct b43legacy_pioqueue *queue,
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-04-29 11:20:31.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-04-29 11:20:55.000000000 +0200
@@ -7231,9 +7231,9 @@ static int iwl3945_mac_get_tx_stats(stru
 		q = &txq->q;
 		avail = iwl3945_queue_space(q);
 
-		stats->data[i].len = q->n_window - avail;
-		stats->data[i].limit = q->n_window - q->high_mark;
-		stats->data[i].count = q->n_window;
+		stats[i].len = q->n_window - avail;
+		stats[i].limit = q->n_window - q->high_mark;
+		stats[i].count = q->n_window;
 
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-29 11:20:31.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-29 11:20:55.000000000 +0200
@@ -6972,9 +6972,9 @@ static int iwl4965_mac_get_tx_stats(stru
 		q = &txq->q;
 		avail = iwl4965_queue_space(q);
 
-		stats->data[i].len = q->n_window - avail;
-		stats->data[i].limit = q->n_window - q->high_mark;
-		stats->data[i].count = q->n_window;
+		stats[i].len = q->n_window - avail;
+		stats[i].limit = q->n_window - q->high_mark;
+		stats[i].count = q->n_window;
 
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
--- everything.orig/drivers/net/wireless/p54/p54.h	2008-04-29 11:20:31.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54.h	2008-04-29 11:20:55.000000000 +0200
@@ -64,7 +64,7 @@ struct p54_common {
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	unsigned int fw_var;
-	struct ieee80211_tx_queue_stats tx_stats;
+	struct ieee80211_tx_queue_stats tx_stats[4];
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-04-29 11:20:31.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-04-29 11:20:55.000000000 +0200
@@ -146,10 +146,10 @@ void p54_parse_firmware(struct ieee80211
 
 	if (priv->fw_var >= 0x300) {
 		/* Firmware supports QoS, use it! */
-		priv->tx_stats.data[0].limit = 3;
-		priv->tx_stats.data[1].limit = 4;
-		priv->tx_stats.data[2].limit = 3;
-		priv->tx_stats.data[3].limit = 1;
+		priv->tx_stats[0].limit = 3;
+		priv->tx_stats[1].limit = 4;
+		priv->tx_stats[2].limit = 3;
+		priv->tx_stats[3].limit = 1;
 		dev->queues = 4;
 	}
 }
@@ -379,7 +379,7 @@ static void inline p54_wake_free_queues(
 	 * But, what if some are full? */
 
 	for (i = 0; i < dev->queues; i++)
-		if (priv->tx_stats.data[i].len < priv->tx_stats.data[i].limit)
+		if (priv->tx_stats[i].len < priv->tx_stats[i].limit)
 			ieee80211_wake_queue(dev, i);
 }
 
@@ -417,8 +417,7 @@ static void p54_rx_frame_sent(struct iee
 			memcpy(&status.control, range->control,
 			       sizeof(status.control));
 			kfree(range->control);
-			priv->tx_stats.data[status.control.queue].len--;
-
+			priv->tx_stats[status.control.queue].len--;
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
@@ -555,7 +554,7 @@ static void p54_assign_address(struct ie
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control)
 {
-	struct ieee80211_tx_queue_stats_data *current_queue;
+	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_allocdata *txhdr;
@@ -563,7 +562,7 @@ static int p54_tx(struct ieee80211_hw *d
 	size_t padding, len;
 	u8 rate;
 
-	current_queue = &priv->tx_stats.data[control->queue];
+	current_queue = &priv->tx_stats[control->queue];
 	if (unlikely(current_queue->len > current_queue->limit))
 		return NETDEV_TX_BUSY;
 	current_queue->len++;
@@ -967,11 +966,8 @@ static int p54_get_tx_stats(struct ieee8
 			    struct ieee80211_tx_queue_stats *stats)
 {
 	struct p54_common *priv = dev->priv;
-	unsigned int i;
 
-	for (i = 0; i < dev->queues; i++)
-		memcpy(&stats->data[i], &priv->tx_stats.data[i],
-			sizeof(stats->data[i]));
+	memcpy(stats, &priv->tx_stats, sizeof(stats[0]) * dev->queues);
 
 	return 0;
 }
@@ -1008,7 +1004,7 @@ struct ieee80211_hw *p54_init_common(siz
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_rssi = 127;
 
-	priv->tx_stats.data[0].limit = 5;
+	priv->tx_stats[0].limit = 5;
 	dev->queues = 1;
 
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-04-29 11:20:50.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-04-29 11:20:55.000000000 +0200
@@ -457,9 +457,9 @@ int rt2x00mac_get_tx_stats(struct ieee80
 	unsigned int i;
 
 	for (i = 0; i < hw->queues; i++) {
-		stats->data[i].len = rt2x00dev->tx[i].length;
-		stats->data[i].limit = rt2x00dev->tx[i].limit;
-		stats->data[i].count = rt2x00dev->tx[i].count;
+		stats[i].len = rt2x00dev->tx[i].length;
+		stats[i].limit = rt2x00dev->tx[i].limit;
+		stats[i].count = rt2x00dev->tx[i].count;
 	}
 
 	return 0;
--- everything.orig/include/net/mac80211.h	2008-04-29 11:20:31.000000000 +0200
+++ everything/include/net/mac80211.h	2008-04-29 11:20:55.000000000 +0200
@@ -117,13 +117,13 @@ struct ieee80211_tx_queue_params {
 };
 
 /**
- * struct ieee80211_tx_queue_stats_data - transmit queue statistics
+ * struct ieee80211_tx_queue_stats - transmit queue statistics
  *
  * @len: number of packets in queue
  * @limit: queue length limit
  * @count: number of frames sent
  */
-struct ieee80211_tx_queue_stats_data {
+struct ieee80211_tx_queue_stats {
 	unsigned int len;
 	unsigned int limit;
 	unsigned int count;
@@ -165,10 +165,6 @@ enum ieee80211_tx_queue {
 	NUM_TX_DATA_QUEUES_AMPDU = 16
 };
 
-struct ieee80211_tx_queue_stats {
-	struct ieee80211_tx_queue_stats_data data[NUM_TX_DATA_QUEUES_AMPDU];
-};
-
 struct ieee80211_low_level_stats {
 	unsigned int dot11ACKFailureCount;
 	unsigned int dot11RTSFailureCount;
@@ -1069,9 +1065,8 @@ enum ieee80211_ampdu_mlme_action {
  * @get_tx_stats: Get statistics of the current TX queue status. This is used
  *	to get number of currently queued packets (queue length), maximum queue
  *	size (limit), and total number of packets sent using each TX queue
- *	(count). This information is used for WMM to find out which TX
- *	queues have room for more packets and by hostapd to provide
- *	statistics about the current queueing state to external programs.
+ *	(count). The 'stats' pointer points to an array that has hw->queues +
+ *	hw->ampdu_queues items.
  *
  * @get_tsf: Get the current TSF timer value from firmware/hardware. Currently,
  *	this is only used for IBSS mode debugging and, as such, is not a
--- everything.orig/drivers/net/wireless/b43/dma.c	2008-04-29 11:20:31.000000000 +0200
+++ everything/drivers/net/wireless/b43/dma.c	2008-04-29 11:20:55.000000000 +0200
@@ -1427,18 +1427,16 @@ void b43_dma_get_tx_stats(struct b43_wld
 {
 	const int nr_queues = dev->wl->hw->queues;
 	struct b43_dmaring *ring;
-	struct ieee80211_tx_queue_stats_data *data;
 	unsigned long flags;
 	int i;
 
 	for (i = 0; i < nr_queues; i++) {
-		data = &(stats->data[i]);
 		ring = select_ring_by_priority(dev, i);
 
 		spin_lock_irqsave(&ring->lock, flags);
-		data->len = ring->used_slots / SLOTS_PER_PACKET;
-		data->limit = ring->nr_slots / SLOTS_PER_PACKET;
-		data->count = ring->nr_tx_packets;
+		stats[i].len = ring->used_slots / SLOTS_PER_PACKET;
+		stats[i].limit = ring->nr_slots / SLOTS_PER_PACKET;
+		stats[i].count = ring->nr_tx_packets;
 		spin_unlock_irqrestore(&ring->lock, flags);
 	}
 }
--- everything.orig/drivers/net/wireless/b43/pio.c	2008-04-29 11:20:31.000000000 +0200
+++ everything/drivers/net/wireless/b43/pio.c	2008-04-29 11:20:55.000000000 +0200
@@ -611,18 +611,16 @@ void b43_pio_get_tx_stats(struct b43_wld
 {
 	const int nr_queues = dev->wl->hw->queues;
 	struct b43_pio_txqueue *q;
-	struct ieee80211_tx_queue_stats_data *data;
 	unsigned long flags;
 	int i;
 
 	for (i = 0; i < nr_queues; i++) {
-		data = &(stats->data[i]);
 		q = select_queue_by_priority(dev, i);
 
 		spin_lock_irqsave(&q->lock, flags);
-		data->len = B43_PIO_MAX_NR_TXPACKETS - q->free_packet_slots;
-		data->limit = B43_PIO_MAX_NR_TXPACKETS;
-		data->count = q->nr_tx_packets;
+		stats[i].len = B43_PIO_MAX_NR_TXPACKETS - q->free_packet_slots;
+		stats[i].limit = B43_PIO_MAX_NR_TXPACKETS;
+		stats[i].count = q->nr_tx_packets;
 		spin_unlock_irqrestore(&q->lock, flags);
 	}
 }

-- 

