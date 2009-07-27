Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3467 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZG0OpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 10:45:25 -0400
Received: from hash ([72.83.200.195])
	(authenticated user bob@bobcopeland.com)
	by mail.deathmatch.net
	(using TLSv1/SSLv3 with cipher AES256-SHA (256 bits))
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2009 10:45:04 -0400
Received: from bob by hash with local (Exim 4.69)
	(envelope-from <me@bobcopeland.com>)
	id 1MVRRx-0001Rl-H3
	for linux-wireless@vger.kernel.org; Mon, 27 Jul 2009 10:45:13 -0400
Date: Mon, 27 Jul 2009 10:45:13 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH/RFC] wireless: remove get_tx_stats
Message-ID: <20090727144513.GA5533@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seems like a useful function, but as far as I can tell we aren't
actually calling it from anywhere.  Any reason to keep it around?
Removing it saves a few k of text on an allyesconfig kernel.

   text	   data	    bss	    dec	    hex	filename
71007474	4631733	26855960	102495167	61bf3bf	vmlinux.orig
71002218	4631585	26854216	102488019	61bd7d3	vmlinux
---
 drivers/net/wireless/adm8211.c              |   13 ---------
 drivers/net/wireless/ath/ar9170/main.c      |   13 ---------
 drivers/net/wireless/ath/ath5k/base.c       |   18 -------------
 drivers/net/wireless/ath/ath5k/base.h       |    1 -
 drivers/net/wireless/b43/main.c             |   24 ------------------
 drivers/net/wireless/b43/pio.c              |   19 --------------
 drivers/net/wireless/b43/pio.h              |    2 -
 drivers/net/wireless/b43legacy/dma.c        |   19 --------------
 drivers/net/wireless/b43legacy/dma.h        |    8 ------
 drivers/net/wireless/b43legacy/main.c       |   24 ------------------
 drivers/net/wireless/b43legacy/pio.c        |   12 ---------
 drivers/net/wireless/b43legacy/pio.h        |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c     |   36 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 drivers/net/wireless/mwl8k.c                |   18 -------------
 drivers/net/wireless/p54/main.c             |   11 --------
 drivers/net/wireless/rt2x00/rt2400pci.c     |    1 -
 drivers/net/wireless/rt2x00/rt2500pci.c     |    1 -
 drivers/net/wireless/rt2x00/rt2500usb.c     |    1 -
 drivers/net/wireless/rt2x00/rt2800usb.c     |    1 -
 drivers/net/wireless/rt2x00/rt2x00.h        |    2 -
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   16 ------------
 drivers/net/wireless/rt2x00/rt61pci.c       |    1 -
 drivers/net/wireless/rt2x00/rt73usb.c       |    1 -
 include/net/mac80211.h                      |    8 ------
 net/mac80211/driver-ops.h                   |    8 ------
 net/mac80211/driver-trace.h                 |   23 -----------------
 29 files changed, 0 insertions(+), 287 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 5695911..8ee31d6 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -302,18 +302,6 @@ static int adm8211_get_stats(struct ieee80211_hw *dev,
 	return 0;
 }
 
-static int adm8211_get_tx_stats(struct ieee80211_hw *dev,
-				struct ieee80211_tx_queue_stats *stats)
-{
-	struct adm8211_priv *priv = dev->priv;
-
-	stats[0].len = priv->cur_tx - priv->dirty_tx;
-	stats[0].limit = priv->tx_ring_size - 2;
-	stats[0].count = priv->dirty_tx;
-
-	return 0;
-}
-
 static void adm8211_interrupt_tci(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
@@ -1759,7 +1747,6 @@ static const struct ieee80211_ops adm8211_ops = {
 	.bss_info_changed	= adm8211_bss_info_changed,
 	.configure_filter	= adm8211_configure_filter,
 	.get_stats		= adm8211_get_stats,
-	.get_tx_stats		= adm8211_get_tx_stats,
 	.get_tsf		= adm8211_get_tsft
 };
 
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index c7287a8..1c6cbdd 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2434,18 +2434,6 @@ static int ar9170_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int ar9170_get_tx_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_tx_queue_stats *tx_stats)
-{
-	struct ar9170 *ar = hw->priv;
-
-	spin_lock_bh(&ar->tx_stats_lock);
-	memcpy(tx_stats, ar->tx_stats, sizeof(tx_stats[0]) * hw->queues);
-	spin_unlock_bh(&ar->tx_stats_lock);
-
-	return 0;
-}
-
 static int ar9170_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			  const struct ieee80211_tx_queue_params *param)
 {
@@ -2544,7 +2532,6 @@ static const struct ieee80211_ops ar9170_ops = {
 	.set_key		= ar9170_set_key,
 	.sta_notify		= ar9170_sta_notify,
 	.get_stats		= ar9170_get_stats,
-	.get_tx_stats		= ar9170_get_tx_stats,
 	.ampdu_action		= ar9170_ampdu_action,
 };
 
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 7db32ce..80f992b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -239,8 +239,6 @@ static int ath5k_set_key(struct ieee80211_hw *hw,
 		struct ieee80211_key_conf *key);
 static int ath5k_get_stats(struct ieee80211_hw *hw,
 		struct ieee80211_low_level_stats *stats);
-static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
-		struct ieee80211_tx_queue_stats *stats);
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
 static void ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
@@ -264,7 +262,6 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.set_key 	= ath5k_set_key,
 	.get_stats 	= ath5k_get_stats,
 	.conf_tx 	= NULL,
-	.get_tx_stats 	= ath5k_get_tx_stats,
 	.get_tsf 	= ath5k_get_tsf,
 	.set_tsf 	= ath5k_set_tsf,
 	.reset_tsf 	= ath5k_reset_tsf,
@@ -1313,7 +1310,6 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	spin_lock_bh(&txq->lock);
 	list_add_tail(&bf->list, &txq->q);
-	sc->tx_stats[txq->qnum].len++;
 	if (txq->link == NULL) /* is this first packet? */
 		ath5k_hw_set_txdp(ah, txq->qnum, bf->daddr);
 	else /* no, so only link it */
@@ -1546,7 +1542,6 @@ ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		ath5k_txbuf_free(sc, bf);
 
 		spin_lock_bh(&sc->txbuflock);
-		sc->tx_stats[txq->qnum].len--;
 		list_move_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
 		spin_unlock_bh(&sc->txbuflock);
@@ -1980,10 +1975,8 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		}
 
 		ieee80211_tx_status(sc->hw, skb);
-		sc->tx_stats[txq->qnum].count++;
 
 		spin_lock(&sc->txbuflock);
-		sc->tx_stats[txq->qnum].len--;
 		list_move_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
 		spin_unlock(&sc->txbuflock);
@@ -3039,17 +3032,6 @@ ath5k_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int
-ath5k_get_tx_stats(struct ieee80211_hw *hw,
-		struct ieee80211_tx_queue_stats *stats)
-{
-	struct ath5k_softc *sc = hw->priv;
-
-	memcpy(stats, &sc->tx_stats, sizeof(sc->tx_stats));
-
-	return 0;
-}
-
 static u64
 ath5k_get_tsf(struct ieee80211_hw *hw)
 {
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 778e422..1912ee7 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -114,7 +114,6 @@ struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
-	struct ieee80211_tx_queue_stats tx_stats[AR5K_NUM_TX_QUEUES];
 	struct ieee80211_low_level_stats ll_stats;
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 3f4360a..5fce8de 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3229,29 +3229,6 @@ out_unlock:
 	return err;
 }
 
-static int b43_op_get_tx_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_tx_queue_stats *stats)
-{
-	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev = wl->current_dev;
-	unsigned long flags;
-	int err = -ENODEV;
-
-	if (!dev)
-		goto out;
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (likely(b43_status(dev) >= B43_STAT_STARTED)) {
-		if (b43_using_pio_transfers(dev))
-			b43_pio_get_tx_stats(dev, stats);
-		else
-			b43_dma_get_tx_stats(dev, stats);
-		err = 0;
-	}
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-out:
-	return err;
-}
-
 static int b43_op_get_stats(struct ieee80211_hw *hw,
 			    struct ieee80211_low_level_stats *stats)
 {
@@ -4444,7 +4421,6 @@ static const struct ieee80211_ops b43_hw_ops = {
 	.configure_filter	= b43_op_configure_filter,
 	.set_key		= b43_op_set_key,
 	.get_stats		= b43_op_get_stats,
-	.get_tx_stats		= b43_op_get_tx_stats,
 	.get_tsf		= b43_op_get_tsf,
 	.set_tsf		= b43_op_set_tsf,
 	.start			= b43_op_start,
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 69138e8..07b4491 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -607,25 +607,6 @@ void b43_pio_handle_txstatus(struct b43_wldev *dev,
 	spin_unlock(&q->lock);
 }
 
-void b43_pio_get_tx_stats(struct b43_wldev *dev,
-			  struct ieee80211_tx_queue_stats *stats)
-{
-	const int nr_queues = dev->wl->hw->queues;
-	struct b43_pio_txqueue *q;
-	unsigned long flags;
-	int i;
-
-	for (i = 0; i < nr_queues; i++) {
-		q = select_queue_by_priority(dev, i);
-
-		spin_lock_irqsave(&q->lock, flags);
-		stats[i].len = B43_PIO_MAX_NR_TXPACKETS - q->free_packet_slots;
-		stats[i].limit = B43_PIO_MAX_NR_TXPACKETS;
-		stats[i].count = q->nr_tx_packets;
-		spin_unlock_irqrestore(&q->lock, flags);
-	}
-}
-
 /* Returns whether we should fetch another frame. */
 static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 {
diff --git a/drivers/net/wireless/b43/pio.h b/drivers/net/wireless/b43/pio.h
index 6c174c9..603820c 100644
--- a/drivers/net/wireless/b43/pio.h
+++ b/drivers/net/wireless/b43/pio.h
@@ -168,8 +168,6 @@ void b43_pio_free(struct b43_wldev *dev);
 int b43_pio_tx(struct b43_wldev *dev, struct sk_buff *skb);
 void b43_pio_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status);
-void b43_pio_get_tx_stats(struct b43_wldev *dev,
-			  struct ieee80211_tx_queue_stats *stats);
 void b43_pio_rx(struct b43_pio_rxqueue *q);
 
 void b43_pio_tx_suspend(struct b43_wldev *dev);
diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index 2f90fb9..505812e 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -1504,25 +1504,6 @@ void b43legacy_dma_handle_txstatus(struct b43legacy_wldev *dev,
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
index c4973c1..cc8498c 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2443,29 +2443,6 @@ static int b43legacy_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
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
@@ -3506,7 +3483,6 @@ static const struct ieee80211_ops b43legacy_hw_ops = {
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
index 464fec0..d89ebca 100644
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4cb1a1b..fb7039c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2799,7 +2799,6 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.set_key = iwl_mac_set_key,
 	.update_tkip_key = iwl_mac_update_tkip_key,
 	.get_stats = iwl_mac_get_stats,
-	.get_tx_stats = iwl_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b6db955..4bc15ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2859,42 +2859,6 @@ out:
 }
 EXPORT_SYMBOL(iwl_mac_config);
 
-int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
-			 struct ieee80211_tx_queue_stats *stats)
-{
-	struct iwl_priv *priv = hw->priv;
-	int i, avail;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	unsigned long flags;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	for (i = 0; i < AC_NUM; i++) {
-		txq = &priv->txq[i];
-		q = &txq->q;
-		avail = iwl_queue_space(q);
-
-		stats[i].len = q->n_window - avail;
-		stats[i].limit = q->n_window - q->high_mark;
-		stats[i].count = q->n_window;
-
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_mac_get_tx_stats);
-
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index febcf76..653a120 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -294,8 +294,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf);
 int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
 void iwl_config_ap(struct iwl_priv *priv);
-int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
-			 struct ieee80211_tx_queue_stats *stats);
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5ded898..66dbba2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3810,7 +3810,6 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.config = iwl_mac_config,
 	.configure_filter = iwl_configure_filter,
 	.set_key = iwl3945_mac_set_key,
-	.get_tx_stats = iwl_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 4f72547..8fe9aaa 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3372,23 +3372,6 @@ static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return rc;
 }
 
-static int mwl8k_get_tx_stats(struct ieee80211_hw *hw,
-			      struct ieee80211_tx_queue_stats *stats)
-{
-	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_tx_queue *txq;
-	int index;
-
-	spin_lock_bh(&priv->tx_lock);
-	for (index = 0; index < MWL8K_TX_QUEUES; index++) {
-		txq = priv->txq + index;
-		memcpy(&stats[index], &txq->tx_stats,
-			sizeof(struct ieee80211_tx_queue_stats));
-	}
-	spin_unlock_bh(&priv->tx_lock);
-	return 0;
-}
-
 struct mwl8k_get_stats_worker {
 	struct mwl8k_work_struct header;
 	struct ieee80211_low_level_stats *stats;
@@ -3437,7 +3420,6 @@ static const struct ieee80211_ops mwl8k_ops = {
 	.configure_filter	= mwl8k_configure_filter,
 	.set_rts_threshold	= mwl8k_set_rts_threshold,
 	.conf_tx		= mwl8k_conf_tx,
-	.get_tx_stats		= mwl8k_get_tx_stats,
 	.get_stats		= mwl8k_get_stats,
 };
 
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 955f6d7..f7f0446 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -353,16 +353,6 @@ static int p54_get_stats(struct ieee80211_hw *dev,
 	return 0;
 }
 
-static int p54_get_tx_stats(struct ieee80211_hw *dev,
-			    struct ieee80211_tx_queue_stats *stats)
-{
-	struct p54_common *priv = dev->priv;
-
-	memcpy(stats, &priv->tx_stats[P54_QUEUE_DATA],
-	       sizeof(stats[0]) * dev->queues);
-	return 0;
-}
-
 static void p54_bss_info_changed(struct ieee80211_hw *dev,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
@@ -517,7 +507,6 @@ static const struct ieee80211_ops p54_ops = {
 	.configure_filter	= p54_configure_filter,
 	.conf_tx		= p54_conf_tx,
 	.get_stats		= p54_get_stats,
-	.get_tx_stats		= p54_get_tx_stats
 };
 
 struct ieee80211_hw *p54_init_common(size_t priv_data_len)
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 30185ad..38ebd8e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1565,7 +1565,6 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2400pci_conf_tx,
-	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2400pci_get_tsf,
 	.tx_last_beacon		= rt2400pci_tx_last_beacon,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3b31715..4ef5946 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1864,7 +1864,6 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
-	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2500pci_get_tsf,
 	.tx_last_beacon		= rt2500pci_tx_last_beacon,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index de48c5c..36bf046 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1901,7 +1901,6 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
-	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9efb417..fc2a5c3 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2791,7 +2791,6 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 	.set_rts_threshold	= rt2800usb_set_rts_threshold,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2800usb_conf_tx,
-	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2800usb_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index cbec91e..329478c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -973,8 +973,6 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 #endif /* CONFIG_RT2X00_LIB_CRYPTO */
 int rt2x00mac_get_stats(struct ieee80211_hw *hw,
 			struct ieee80211_low_level_stats *stats);
-int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
-			   struct ieee80211_tx_queue_stats *stats);
 void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_bss_conf *bss_conf,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 7de1a2c..7cbf5c4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -560,22 +560,6 @@ int rt2x00mac_get_stats(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_get_stats);
 
-int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
-			   struct ieee80211_tx_queue_stats *stats)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	unsigned int i;
-
-	for (i = 0; i < rt2x00dev->ops->tx_queues; i++) {
-		stats[i].len = rt2x00dev->tx[i].length;
-		stats[i].limit = rt2x00dev->tx[i].limit;
-		stats[i].count = rt2x00dev->tx[i].count;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00mac_get_tx_stats);
-
 void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_bss_conf *bss_conf,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index fb95b8c..41f665c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2721,7 +2721,6 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt61pci_conf_tx,
-	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt61pci_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4f9b177..de0296c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2246,7 +2246,6 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt73usb_conf_tx,
-	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt73usb_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 };
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d4e09a0..8e3b982 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1388,12 +1388,6 @@ enum ieee80211_ampdu_mlme_action {
  *	bursting) for a hardware TX queue.
  *	Returns a negative error code on failure.
  *
- * @get_tx_stats: Get statistics of the current TX queue status. This is used
- *	to get number of currently queued packets (queue length), maximum queue
- *	size (limit), and total number of packets sent using each TX queue
- *	(count). The 'stats' pointer points to an array that has hw->queues
- *	items.
- *
  * @get_tsf: Get the current TSF timer value from firmware/hardware. Currently,
  *	this is only used for IBSS mode BSSID merging and debugging. Is not a
  *	required function.
@@ -1464,8 +1458,6 @@ struct ieee80211_ops {
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
-	int (*get_tx_stats)(struct ieee80211_hw *hw,
-			    struct ieee80211_tx_queue_stats *stats);
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
 	void (*set_tsf)(struct ieee80211_hw *hw, u64 tsf);
 	void (*reset_tsf)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4100c36..e7f3e8b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -170,14 +170,6 @@ static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
 	return ret;
 }
 
-static inline int drv_get_tx_stats(struct ieee80211_local *local,
-				   struct ieee80211_tx_queue_stats *stats)
-{
-	int ret = local->ops->get_tx_stats(&local->hw, stats);
-	trace_drv_get_tx_stats(local, stats, ret);
-	return ret;
-}
-
 static inline u64 drv_get_tsf(struct ieee80211_local *local)
 {
 	u64 ret = -1ULL;
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 5a10da2..54086cc 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -504,29 +504,6 @@ TRACE_EVENT(drv_conf_tx,
 	)
 );
 
-TRACE_EVENT(drv_get_tx_stats,
-	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_tx_queue_stats *stats,
-		 int ret),
-
-	TP_ARGS(local, stats, ret),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		__field(int, ret)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		__entry->ret = ret;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT " ret:%d",
-		LOCAL_PR_ARG, __entry->ret
-	)
-);
-
 TRACE_EVENT(drv_get_tsf,
 	TP_PROTO(struct ieee80211_local *local, u64 ret),
 
-- 
1.6.2.5

-- 
Bob Copeland %% www.bobcopeland.com

