Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24037 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762988AbYCFQv4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 11:51:56 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	root <root@localhost.localdomain>
Subject: [RFC] mac80211: handling Qdisc issues
Date: Thu,  6 Mar 2008 18:51:47 +0200
Message-Id: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com> (sfid-20080306_165213_934829_7D135CAE)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: root <root@localhost.localdomain>

This patch is an expansion to Johannes Berg's patch "net_sched Vs. HT".
It includes all the original changes, with support to A-MPDU queueing and
also several changes for iwlwifi driver.
Johannes, if you see any problems with the changes from the original patch
please comment.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/adm8211.c              |    7 +-
 drivers/net/wireless/ath5k/base.c           |   10 +-
 drivers/net/wireless/ath5k/base.h           |    4 +-
 drivers/net/wireless/b43/dma.c              |   15 ++-
 drivers/net/wireless/b43/main.c             |    3 +-
 drivers/net/wireless/b43legacy/dma.c        |   14 ++-
 drivers/net/wireless/b43legacy/main.c       |    3 +-
 drivers/net/wireless/b43legacy/pio.c        |    7 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   17 +--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   23 ++---
 drivers/net/wireless/p54.h                  |    2 +-
 drivers/net/wireless/p54common.c            |   34 +++----
 drivers/net/wireless/rt2x00/rt2400pci.c     |   27 ++---
 drivers/net/wireless/rt2x00/rt2500pci.c     |   21 ++---
 drivers/net/wireless/rt2x00/rt2500usb.c     |   11 +--
 drivers/net/wireless/rt2x00/rt2x00.h        |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    8 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   25 +++--
 drivers/net/wireless/rt2x00/rt2x00pci.c     |   14 ++-
 drivers/net/wireless/rt2x00/rt2x00usb.c     |   11 ++-
 drivers/net/wireless/rt2x00/rt61pci.c       |   19 ++---
 drivers/net/wireless/rt2x00/rt73usb.c       |   11 +--
 drivers/net/wireless/rtl8180_dev.c          |    4 +-
 include/net/mac80211.h                      |   82 +++++-----------
 net/mac80211/Kconfig                        |    7 +-
 net/mac80211/Makefile                       |    2 +-
 net/mac80211/debugfs.c                      |   44 ---------
 net/mac80211/debugfs_sta.c                  |   38 --------
 net/mac80211/ieee80211.c                    |   19 ++--
 net/mac80211/ieee80211_i.h                  |   16 ---
 net/mac80211/ieee80211_sta.c                |   24 ++----
 net/mac80211/rx.c                           |    5 -
 net/mac80211/sta_info.c                     |    2 +-
 net/mac80211/sta_info.h                     |    9 --
 net/mac80211/tx.c                           |  138 +++------------------------
 net/mac80211/util.c                         |   58 ++++++++----
 net/mac80211/wme.c                          |  128 +++++++++++--------------
 37 files changed, 288 insertions(+), 579 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index a1303ae..a48a781 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -306,11 +306,10 @@ static int adm8211_get_tx_stats(struct ieee80211_hw *dev,
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
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 0b743f7..6555ab1 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1334,7 +1334,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	spin_lock_bh(&txq->lock);
 	list_add_tail(&bf->list, &txq->q);
-	sc->tx_stats.data[txq->qnum].len++;
+	sc->tx_stats[txq->qnum].len++;
 	if (txq->link == NULL) /* is this first packet? */
 		ath5k_hw_put_tx_buf(ah, txq->qnum, bf->daddr);
 	else /* no, so only link it */
@@ -1566,7 +1566,7 @@ ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		ath5k_txbuf_free(sc, bf);
 
 		spin_lock_bh(&sc->txbuflock);
-		sc->tx_stats.data[txq->qnum].len--;
+		sc->tx_stats[txq->qnum].len--;
 		list_move_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
 		spin_unlock_bh(&sc->txbuflock);
@@ -1938,10 +1938,10 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
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
@@ -2625,7 +2625,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (list_empty(&sc->txbuf)) {
 		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
 		spin_unlock_irqrestore(&sc->txbuflock, flags);
-		ieee80211_stop_queue(hw, ctl->queue);
+		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
 		return -1;
 	}
 	bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 3a97558..ba07bed 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -92,7 +92,9 @@ struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
-	struct ieee80211_tx_queue_stats tx_stats;
+	/* FIXME: how many is this really?
+	 * I can't find this driver setting hw->queues at all! */
+	struct ieee80211_tx_queue_stats tx_stats[20];
 	struct ieee80211_low_level_stats ll_stats;
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 3dfb28a..416a43e 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1294,7 +1294,12 @@ int b43_dma_tx(struct b43_wldev *dev,
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	} else {
 		/* Decide by priority where to put this frame. */
-		ring = priority_to_txring(dev, ctl->queue);
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
+		ring = priority_to_txring(dev, skb->queue_mapping);
+#else
+		/* XXX: b43 qos needs a lot of work */
+		ring = 1;
+#endif
 	}
 
 	spin_lock_irqsave(&ring->lock, flags);
@@ -1419,18 +1424,16 @@ void b43_dma_get_tx_stats(struct b43_wldev *dev,
 {
 	const int nr_queues = dev->wl->hw->queues;
 	struct b43_dmaring *ring;
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
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index f745308..25c81b0 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2708,8 +2708,7 @@ out:
 	return NETDEV_TX_OK;
 }
 
-static int b43_op_conf_tx(struct ieee80211_hw *hw,
-			  int queue,
+static int b43_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			  const struct ieee80211_tx_queue_params *params)
 {
 	return 0;
diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index e87b427..c8eeb27 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -1323,7 +1323,11 @@ int b43legacy_dma_tx(struct b43legacy_wldev *dev,
 	int err = 0;
 	unsigned long flags;
 
-	ring = priority_to_txring(dev, ctl->queue);
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
+	ring = priority_to_txring(dev, skb->queue_mapping);
+#else
+	ring = 1;
+#endif
 	spin_lock_irqsave(&ring->lock, flags);
 	B43legacy_WARN_ON(!ring->tx);
 	if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
@@ -1448,18 +1452,16 @@ void b43legacy_dma_get_tx_stats(struct b43legacy_wldev *dev,
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
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 82953dd..a1fd3c6 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2381,8 +2381,7 @@ out:
 	return NETDEV_TX_OK;
 }
 
-static int b43legacy_op_conf_tx(struct ieee80211_hw *hw,
-				int queue,
+static int b43legacy_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 				const struct ieee80211_tx_queue_params *params)
 {
 	return 0;
diff --git a/drivers/net/wireless/b43legacy/pio.c b/drivers/net/wireless/b43legacy/pio.c
index bcdd54e..4ae57e3 100644
--- a/drivers/net/wireless/b43legacy/pio.c
+++ b/drivers/net/wireless/b43legacy/pio.c
@@ -528,10 +528,9 @@ void b43legacy_pio_get_tx_stats(struct b43legacy_wldev *dev,
 	struct ieee80211_tx_queue_stats_data *data;
 
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
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3f60f85..c5b2a00 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2599,7 +2599,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl3945_tfd_frame *tfd;
 	u32 *control_flags;
-	int txq_id = ctl->queue;
+	int txq_id = skb_get_queue_mapping(skb);
 	struct iwl3945_tx_queue *txq = NULL;
 	struct iwl3945_queue *q = NULL;
 	dma_addr_t phys_addr;
@@ -2813,7 +2813,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
-		ieee80211_stop_queue(priv->hw, ctl->queue);
+		ieee80211_stop_queue(priv->hw, skb_get_queue_mapping(skb));
 	}
 
 	return 0;
@@ -3163,8 +3163,6 @@ static void iwl3945_txstatus_to_ieee(struct iwl3945_priv *priv,
 
 	tx_sta->status.ack_signal = 0;
 	tx_sta->status.excessive_retries = 0;
-	tx_sta->status.queue_length = 0;
-	tx_sta->status.queue_number = 0;
 
 	if (in_interrupt())
 		ieee80211_tx_status_irqsafe(priv->hw,
@@ -3256,9 +3254,6 @@ static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
 	tx_status = &(txq->txb[txq->q.read_ptr].status);
 
 	tx_status->retry_count = tx_resp->failure_frame;
-	tx_status->queue_number = status;
-	tx_status->queue_length = tx_resp->bt_kill_count;
-	tx_status->queue_length |= tx_resp->failure_rts;
 
 	tx_status->flags =
 	    iwl3945_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
@@ -7295,7 +7290,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return rc;
 }
 
-static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, int queue,
+static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl3945_priv *priv = hw->priv;
@@ -7369,9 +7364,9 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
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
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index a58462e..b478b74 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2697,7 +2697,7 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl4965_tfd_frame *tfd;
 	u32 *control_flags;
-	int txq_id = ctl->queue;
+	int txq_id = skb_get_queue_mapping(skb);
 	struct iwl4965_tx_queue *txq = NULL;
 	struct iwl4965_queue *q = NULL;
 	dma_addr_t phys_addr;
@@ -2919,7 +2919,7 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
-		ieee80211_stop_queue(priv->hw, ctl->queue);
+		ieee80211_stop_queue(priv->hw, skb_get_queue_mapping(skb));
 	}
 
 	return 0;
@@ -3264,8 +3264,6 @@ static void iwl4965_txstatus_to_ieee(struct iwl4965_priv *priv,
 
 	tx_sta->status.ack_signal = 0;
 	tx_sta->status.excessive_retries = 0;
-	tx_sta->status.queue_length = 0;
-	tx_sta->status.queue_number = 0;
 
 	if (in_interrupt())
 		ieee80211_tx_status_irqsafe(priv->hw,
@@ -3401,8 +3399,6 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
 
 		tx_status = &(priv->txq[txq_id].txb[idx].status);
 		tx_status->retry_count = tx_resp->failure_frame;
-		tx_status->queue_number = status & 0xff;
-		tx_status->queue_length = tx_resp->failure_rts;
 		tx_status->control.flags &= ~IEEE80211_TXCTL_AMPDU;
 		tx_status->flags = iwl4965_is_tx_success(status)?
 			IEEE80211_TX_STATUS_ACK : 0;
@@ -3561,9 +3557,6 @@ static void iwl4965_rx_reply_tx(struct iwl4965_priv *priv,
 	tx_status = &(txq->txb[txq->q.read_ptr].status);
 
 	tx_status->retry_count = tx_resp->failure_frame;
-	tx_status->queue_number = status;
-	tx_status->queue_length = tx_resp->bt_kill_count;
-	tx_status->queue_length |= tx_resp->failure_rts;
 	tx_status->flags =
 	    iwl4965_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
 	iwl4965_hwrate_to_tx_control(priv, tx_resp->rate_n_flags,
@@ -7706,7 +7699,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return rc;
 }
 
-static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
+static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl4965_priv *priv = hw->priv;
@@ -7780,9 +7773,9 @@ static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
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
@@ -8665,8 +8658,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 #ifdef CONFIG_IWL4965_HT
-	/* Enhanced value; more queues, to support 11n aggregation */
-	hw->queues = 16;
+	/* queues to support 11n aggregation */
+	hw->ampdu_queues = 8;
 #endif /* CONFIG_IWL4965_HT */
 
 	spin_lock_init(&priv->lock);
diff --git a/drivers/net/wireless/p54.h b/drivers/net/wireless/p54.h
index 06d2c67..c6f27b9 100644
--- a/drivers/net/wireless/p54.h
+++ b/drivers/net/wireless/p54.h
@@ -64,7 +64,7 @@ struct p54_common {
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	unsigned int fw_var;
-	struct ieee80211_tx_queue_stats tx_stats;
+	struct ieee80211_tx_queue_stats tx_stats[4];
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
diff --git a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
index 9ae3be4..b7aa153 100644
--- a/drivers/net/wireless/p54common.c
+++ b/drivers/net/wireless/p54common.c
@@ -144,14 +144,16 @@ void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		printk(KERN_INFO "p54: FW rev %s - Softmac protocol %x.%x\n",
 			fw_version, priv->fw_var >> 8, priv->fw_var & 0xff);
 
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
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
+#endif
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
 
@@ -371,7 +373,7 @@ static void inline p54_wake_free_queues(struct ieee80211_hw *dev)
 	 * But, what if some are full? */
 
 	for (i = 0; i < dev->queues; i++)
-		if (priv->tx_stats.data[i].len < priv->tx_stats.data[i].limit)
+		if (priv->tx_stats[i].len < priv->tx_stats[i].limit)
 			ieee80211_wake_queue(dev, i);
 }
 
@@ -409,8 +411,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 			memcpy(&status.control, range->control,
 			       sizeof(status.control));
 			kfree(range->control);
-			priv->tx_stats.data[status.control.queue].len--;
-
+			priv->tx_stats[skb_get_queue_mapping(skb)].len--;
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
@@ -547,7 +548,7 @@ static void p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control)
 {
-	struct ieee80211_tx_queue_stats_data *current_queue;
+	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
 	struct p54_tx_control_allocdata *txhdr;
@@ -555,13 +556,13 @@ static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	size_t padding, len;
 	u8 rate;
 
-	current_queue = &priv->tx_stats.data[control->queue];
+	current_queue = &priv->tx_stats[skb_get_queue_mapping(skb)];
 	if (unlikely(current_queue->len > current_queue->limit))
 		return NETDEV_TX_BUSY;
 	current_queue->len++;
 	current_queue->count++;
 	if (current_queue->len == current_queue->limit)
-		ieee80211_stop_queue(dev, control->queue);
+		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
@@ -598,7 +599,7 @@ static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	memset(txhdr->rateset, rate, 8);
 	txhdr->wep_key_present = 0;
 	txhdr->wep_key_len = 0;
-	txhdr->frame_type = cpu_to_le32(control->queue + 4);
+	txhdr->frame_type = cpu_to_le32(skb_get_queue_mapping(skb) + 4);
 	txhdr->magic4 = 0;
 	txhdr->antenna = (control->antenna_sel_tx == 0) ?
 		2 : control->antenna_sel_tx - 1;
@@ -928,7 +929,7 @@ static void p54_configure_filter(struct ieee80211_hw *dev,
 	}
 }
 
-static int p54_conf_tx(struct ieee80211_hw *dev, int queue,
+static int p54_conf_tx(struct ieee80211_hw *dev, u16 queue,
 		       const struct ieee80211_tx_queue_params *params)
 {
 	struct p54_common *priv = dev->priv;
@@ -937,7 +938,7 @@ static int p54_conf_tx(struct ieee80211_hw *dev, int queue,
 	vdcf = (struct p54_tx_control_vdcf *)(((struct p54_control_hdr *)
 		((void *)priv->cached_vdcf + priv->tx_hdr_len))->data);
 
-	if ((params) && !((queue < 0) || (queue > 4))) {
+	if (params && queue < dev->queues) {
 		P54_SET_QUEUE(vdcf->queue[queue], params->aifs,
 			params->cw_min, params->cw_max, params->txop);
 	} else
@@ -959,11 +960,8 @@ static int p54_get_tx_stats(struct ieee80211_hw *dev,
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
@@ -1000,7 +998,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_rssi = 127;
 
-	priv->tx_stats.data[0].limit = 5;
+	priv->tx_stats[0].limit = 5;
 	dev->queues = 1;
 
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index b63bc66..64324fd 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1044,9 +1044,9 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
 	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO,
-			   (queue == IEEE80211_TX_QUEUE_DATA0));
+			   (queue == 0));
 	rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
-			   (queue == IEEE80211_TX_QUEUE_DATA1));
+			   (queue == 1));
 	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
 			   (queue == RT2X00_BCN_QUEUE_ATIM));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
@@ -1086,7 +1086,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
  * Interrupt functions.
  */
 static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
-			     const enum ieee80211_tx_queue queue_idx)
+			     const u16 queue_idx)
 {
 	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
 	struct queue_entry_priv_pci_tx *priv_tx;
@@ -1159,13 +1159,13 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	 * 4 - Priority ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING))
-		rt2400pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
+		rt2400pci_txdone(rt2x00dev, 0);
 
 	/*
 	 * 5 - Tx ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
-		rt2400pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA1);
+		rt2400pci_txdone(rt2x00dev, 1);
 
 	return IRQ_HANDLED;
 }
@@ -1466,8 +1466,7 @@ static int rt2400pci_set_retry_limit(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int rt2400pci_conf_tx(struct ieee80211_hw *hw,
-			     int queue,
+static int rt2400pci_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -1477,7 +1476,7 @@ static int rt2400pci_conf_tx(struct ieee80211_hw *hw,
 	 * per queue. So by default we only configure the TX queue,
 	 * and ignore all other configurations.
 	 */
-	if (queue != IEEE80211_TX_QUEUE_DATA0)
+	if (queue != 0)
 		return -EINVAL;
 
 	if (rt2x00mac_conf_tx(hw, queue, params))
@@ -1531,13 +1530,8 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
-	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
+				RT2X00_BCN_QUEUE_BEACON);
 
 	/*
 	 * Enable beacon generation.
@@ -1545,7 +1539,8 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * and kick the beacon generator.
 	 */
 	memcpy(priv_tx->data, skb->data, skb->len);
-	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
+	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
+
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index add8aff..c4af774 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1197,9 +1197,9 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
 	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO,
-			   (queue == IEEE80211_TX_QUEUE_DATA0));
+			   (queue == 0));
 	rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
-			   (queue == IEEE80211_TX_QUEUE_DATA1));
+			   (queue == 1));
 	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
 			   (queue == RT2X00_BCN_QUEUE_ATIM));
 	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
@@ -1236,7 +1236,7 @@ static void rt2500pci_fill_rxdone(struct queue_entry *entry,
  * Interrupt functions.
  */
 static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
-			     const enum ieee80211_tx_queue queue_idx)
+			     const u16 queue_idx)
 {
 	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
 	struct queue_entry_priv_pci_tx *priv_tx;
@@ -1309,13 +1309,13 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	 * 4 - Priority ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING))
-		rt2500pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
+		rt2500pci_txdone(rt2x00dev, 0);
 
 	/*
 	 * 5 - Tx ring transmit done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
-		rt2500pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA1);
+		rt2500pci_txdone(rt2x00dev, 1);
 
 	return IRQ_HANDLED;
 }
@@ -1842,13 +1842,8 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
-	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
+				RT2X00_BCN_QUEUE_BEACON);
 
 	/*
 	 * Enable beacon generation.
@@ -1856,7 +1851,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * and kick the beacon generator.
 	 */
 	memcpy(priv_tx->data, skb->data, skb->len);
-	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
+	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index d9643c5..c54db90 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1760,13 +1760,8 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
-	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
+				RT2X00_BCN_QUEUE_BEACON);
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
@@ -1797,7 +1792,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	/*
 	 * Enable beacon generation.
 	 */
-	rt2500usb_kick_tx_queue(rt2x00dev, control->queue);
+	rt2500usb_kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d0f027a..9c0f9d9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -960,7 +960,8 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
  */
 void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			     struct sk_buff *skb,
-			     struct ieee80211_tx_control *control);
+			     struct ieee80211_tx_control *control,
+			     u16 queue);
 
 /*
  * mac80211 handlers.
@@ -985,7 +986,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_bss_conf *bss_conf,
 				u32 changes);
-int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue,
+int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 015738a..6d011bf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -527,9 +527,6 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
 	}
 
-	tx_status.queue_length = entry->queue->limit;
-	tx_status.queue_number = tx_status.control.queue;
-
 	if (tx_status.control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
 		if (success)
 			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;
@@ -623,7 +620,8 @@ EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
  */
 void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			     struct sk_buff *skb,
-			     struct ieee80211_tx_control *control)
+			     struct ieee80211_tx_control *control,
+			     u16 queue)
 {
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
@@ -685,7 +683,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Beacons and probe responses require the tsf timestamp
 	 * to be inserted into the frame.
 	 */
-	if (control->queue == RT2X00_BCN_QUEUE_BEACON ||
+	if (queue == RT2X00_BCN_QUEUE_BEACON ||
 	    is_probe_resp(frame_control))
 		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc.flags);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index a54f687..dffd25f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -99,12 +99,12 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	/*
 	 * Determine which queue to put packet on.
 	 */
-	queue = rt2x00queue_get_queue(rt2x00dev, control->queue);
+	queue = rt2x00queue_get_queue(rt2x00dev, skb_get_queue_mapping(skb));
 	if (unlikely(!queue)) {
 		ERROR(rt2x00dev,
 		      "Attempt to send packet over invalid queue %d.\n"
 		      "Please file bug report to %s.\n",
-		      control->queue, DRV_PROJECT);
+		      skb_get_queue_mapping(skb), DRV_PROJECT);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
@@ -120,12 +120,14 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	    (control->flags & (IEEE80211_TXCTL_USE_RTS_CTS |
 			       IEEE80211_TXCTL_USE_CTS_PROTECT))) {
 		if (rt2x00queue_available(queue) <= 1) {
-			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+			ieee80211_stop_queue(rt2x00dev->hw,
+					     skb_get_queue_mapping(skb));
 			return NETDEV_TX_BUSY;
 		}
 
 		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb, control)) {
-			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+			ieee80211_stop_queue(rt2x00dev->hw,
+					     skb_get_queue_mapping(skb));
 			return NETDEV_TX_BUSY;
 		}
 	}
@@ -137,15 +139,16 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	memset(skbdesc, 0, sizeof(*skbdesc));
 
 	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb, control)) {
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		ieee80211_stop_queue(rt2x00dev->hw, skb_get_queue_mapping(skb));
 		return NETDEV_TX_BUSY;
 	}
 
 	if (rt2x00queue_full(queue))
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+		ieee80211_stop_queue(rt2x00dev->hw, skb_get_queue_mapping(skb));
 
 	if (rt2x00dev->ops->lib->kick_tx_queue)
-		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
+		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev,
+						   skb_get_queue_mapping(skb));
 
 	return NETDEV_TX_OK;
 }
@@ -399,9 +402,9 @@ int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
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
@@ -446,7 +449,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
 
-int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue_idx,
+int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 		      const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 1960d93..54dbd74 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -53,7 +53,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 		ERROR(rt2x00dev,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
-		      control->queue, DRV_PROJECT);
+		      skb_get_queue_mapping(skb), DRV_PROJECT);
 		return -EINVAL;
 	}
 
@@ -68,7 +68,10 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skbdesc->entry = entry;
 
 	memcpy(priv_tx->data, skb->data, skb->len);
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+#if TODO
+Is this correct??
+#endif
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control, queue->qid);
 
 	rt2x00queue_index_inc(queue, Q_INDEX);
 
@@ -175,10 +178,13 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 	 * If the data queue was full before the txdone handler
 	 * we must make sure the packet queue in the mac80211 stack
 	 * is reenabled when the txdone handler has finished.
+	 *
+	 * XXX: Is this correct wrt. the queue number?
 	 */
+#if TODO
+#endif
 	if (!rt2x00queue_full(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, priv_tx->control.queue);
-
+		ieee80211_wake_queue(rt2x00dev->hw, entry->queue->qid);
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 063b167..604e64c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -164,9 +164,13 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * If the data queue was full before the txdone handler
 	 * we must make sure the packet queue in the mac80211 stack
 	 * is reenabled when the txdone handler has finished.
+	 *
+	 * XXX: Is  this correct wrt. the queue number?
 	 */
+#if TODO
+#endif
 	if (!rt2x00queue_full(entry->queue))
-		ieee80211_wake_queue(rt2x00dev->hw, priv_tx->control.queue);
+		ieee80211_wake_queue(rt2x00dev->hw, entry->queue->qid);
 }
 
 int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
@@ -186,7 +190,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 		ERROR(rt2x00dev,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
-		      control->queue, DRV_PROJECT);
+		      skb_get_queue_mapping(skb), DRV_PROJECT);
 		return -EINVAL;
 	}
 
@@ -206,7 +210,8 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
 
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
+				skb_get_queue_mapping(skb));
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 70cfdad..dd52183 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1566,13 +1566,13 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0,
-			   (queue == IEEE80211_TX_QUEUE_DATA0));
+			   (queue == 0));
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1,
-			   (queue == IEEE80211_TX_QUEUE_DATA1));
+			   (queue == 1));
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2,
-			   (queue == IEEE80211_TX_QUEUE_DATA2));
+			   (queue == 2));
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3,
-			   (queue == IEEE80211_TX_QUEUE_DATA3));
+			   (queue == 3));
 	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 }
 
@@ -2403,13 +2403,8 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
-	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
+				RT2X00_BCN_QUEUE_BEACON);
 
 	/*
 	 * Write entire beacon with descriptor to register,
@@ -2418,7 +2413,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
 	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
 				      skb->data, skb->len);
-	rt61pci_kick_tx_queue(rt2x00dev, control->queue);
+	rt61pci_kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 7d6ee97..d1a2523 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2007,13 +2007,8 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
-	/*
-	 * mac80211 doesn't provide the control->queue variable
-	 * for beacons. Set our own queue identification so
-	 * it can be used during descriptor initialization.
-	 */
-	control->queue = RT2X00_BCN_QUEUE_BEACON;
-	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
+	rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
+				RT2X00_BCN_QUEUE_BEACON);
 
 	/*
 	 * Write entire beacon with descriptor to register,
@@ -2024,7 +2019,7 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
 				 USB_VENDOR_REQUEST_OUT, beacon_base, 0,
 				 skb->data, skb->len, timeout);
-	rt73usb_kick_tx_queue(rt2x00dev, control->queue);
+	rt73usb_kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index b1b3a47..1a4adab 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -251,7 +251,7 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	u16 plcp_len = 0;
 	__le16 rts_duration = 0;
 
-	prio = control->queue;
+	prio = skb_get_queue_mapping(skb);
 	ring = &priv->tx_ring[prio];
 
 	mapping = pci_map_single(priv->pdev, skb->data,
@@ -309,7 +309,7 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	entry->flags = cpu_to_le32(tx_flags);
 	__skb_queue_tail(&ring->queue, skb);
 	if (ring->entries - skb_queue_len(&ring->queue) < 2)
-		ieee80211_stop_queue(dev, control->queue);
+		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 53884cd..5cee90f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -86,6 +86,18 @@ struct ieee80211_ht_bss_info {
 };
 
 /**
+ * enum ieee80211_max_queues - maximum number of queues
+ *
+ * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
+ * @IEEE80211_MAX_AMPDU_QUEUES: Maximum number of queues usable
+ *	for A-MPDU operation.
+ */
+enum ieee80211_max_queues {
+	IEEE80211_MAX_QUEUES =		16,
+	IEEE80211_MAX_AMPDU_QUEUES =	16,
+};
+
+/**
  * struct ieee80211_tx_queue_params - transmit queue configuration
  *
  * The information provided in this structure is required for QoS
@@ -105,58 +117,18 @@ struct ieee80211_tx_queue_params {
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
 };
 
-/**
- * enum ieee80211_tx_queue - transmit queue number
- *
- * These constants are used with some callbacks that take a
- * queue number to set parameters for a queue.
- *
- * @IEEE80211_TX_QUEUE_DATA0: data queue 0
- * @IEEE80211_TX_QUEUE_DATA1: data queue 1
- * @IEEE80211_TX_QUEUE_DATA2: data queue 2
- * @IEEE80211_TX_QUEUE_DATA3: data queue 3
- * @IEEE80211_TX_QUEUE_DATA4: data queue 4
- * @IEEE80211_TX_QUEUE_SVP: ??
- * @NUM_TX_DATA_QUEUES: number of data queues
- * @IEEE80211_TX_QUEUE_AFTER_BEACON: transmit queue for frames to be
- *	sent after a beacon
- * @IEEE80211_TX_QUEUE_BEACON: transmit queue for beacon frames
- * @NUM_TX_DATA_QUEUES_AMPDU: adding more queues for A-MPDU
- */
-enum ieee80211_tx_queue {
-	IEEE80211_TX_QUEUE_DATA0,
-	IEEE80211_TX_QUEUE_DATA1,
-	IEEE80211_TX_QUEUE_DATA2,
-	IEEE80211_TX_QUEUE_DATA3,
-	IEEE80211_TX_QUEUE_DATA4,
-	IEEE80211_TX_QUEUE_SVP,
-
-	NUM_TX_DATA_QUEUES,
-
-/* due to stupidity in the sub-ioctl userspace interface, the items in
- * this struct need to have fixed values. As soon as it is removed, we can
- * fix these entries. */
-	IEEE80211_TX_QUEUE_AFTER_BEACON = 6,
-	IEEE80211_TX_QUEUE_BEACON = 7,
-	NUM_TX_DATA_QUEUES_AMPDU = 16
-};
-
-struct ieee80211_tx_queue_stats {
-	struct ieee80211_tx_queue_stats_data data[NUM_TX_DATA_QUEUES_AMPDU];
-};
-
 struct ieee80211_low_level_stats {
 	unsigned int dot11ACKFailureCount;
 	unsigned int dot11RTSFailureCount;
@@ -281,9 +253,6 @@ struct ieee80211_tx_control {
 				 * position represents antenna number used */
 	u8 icv_len;		/* length of the ICV/MIC field in octets */
 	u8 iv_len;		/* length of the IV field in octets */
-	u8 queue;		/* hardware queue to use for this frame;
-				 * 0 = highest, hw->queues-1 = lowest */
-	int type;	/* internal */
 };
 
 
@@ -382,8 +351,6 @@ enum ieee80211_tx_status_flags {
  * @ampdu_ack_map: block ack bit map for the aggregation.
  * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
  * @ack_signal: signal strength of the ACK frame
- * @queue_length: ?? REMOVE
- * @queue_number: ?? REMOVE
  */
 struct ieee80211_tx_status {
 	struct ieee80211_tx_control control;
@@ -393,8 +360,6 @@ struct ieee80211_tx_status {
 	u8 ampdu_ack_len;
 	u64 ampdu_ack_map;
 	int ack_signal;
-	int queue_length;
-	int queue_number;
 };
 
 /**
@@ -714,7 +679,12 @@ enum ieee80211_hw_flags {
  * @max_noise: like @max_rssi, but for the noise value.
  *
  * @queues: number of available hardware transmit queues for
- *	data packets. WMM/QoS requires at least four.
+ *	data packets. WMM/QoS requires at least four, these
+ *	queues need to have configurable access parameters.
+ *
+ * @ampdu_queues: number of available hardware transmit queues
+ *	for A-MPDU packets, these have no access parameters
+ *	because they're used only for A-MPDU frames.
  *
  * @rate_control_algorithm: rate control algorithm for this hardware.
  *	If unset (NULL), the default algorithm will be used. Must be
@@ -733,7 +703,7 @@ struct ieee80211_hw {
 	unsigned int extra_tx_headroom;
 	int channel_change_time;
 	int vif_data_size;
-	u8 queues;
+	u16 queues, ampdu_queues;
 	s8 max_rssi;
 	s8 max_signal;
 	s8 max_noise;
@@ -998,15 +968,13 @@ enum ieee80211_ampdu_mlme_action {
  *	of assocaited station or AP.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
- *	bursting) for a hardware TX queue. The @queue parameter uses the
- *	%IEEE80211_TX_QUEUE_* constants. Must be atomic.
+ *	bursting) for a hardware TX queue. Must be atomic.
  *
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
@@ -1077,7 +1045,7 @@ struct ieee80211_ops {
 			       u32 short_retry, u32 long_retr);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, const u8 *addr);
-	int (*conf_tx)(struct ieee80211_hw *hw, int queue,
+	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
 			    struct ieee80211_tx_queue_stats *stats);
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 45c7c0c..91ca532 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -7,11 +7,16 @@ config MAC80211
 	select CRC32
 	select WIRELESS_EXT
 	select CFG80211
-	select NET_SCH_FIFO
 	---help---
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.
 
+config MAC80211_QOS
+	def_bool y
+	depends on MAC80211
+	depends on NET_SCHED
+	depends on NETDEVICES_MULTIQUEUE
+
 menu "Rate control algorithm selection"
 	depends on MAC80211 != n
 
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 9d7a195..2426372 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -29,7 +29,7 @@ mac80211-y := \
 	event.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
-mac80211-$(CONFIG_NET_SCHED) += wme.o
+mac80211-$(CONFIG_MAC80211_QOS) += wme.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
 	debugfs.o \
 	debugfs_sta.o \
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 4736c64..92e95e0 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -196,46 +196,6 @@ DEBUGFS_STATS_FILE(rx_handlers_fragments, 20, "%u",
 		   local->rx_handlers_fragments);
 DEBUGFS_STATS_FILE(tx_status_drop, 20, "%u",
 		   local->tx_status_drop);
-
-static ssize_t stats_wme_rx_queue_read(struct file *file,
-				       char __user *userbuf,
-				       size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	char buf[NUM_RX_DATA_QUEUES*15], *p = buf;
-	int i;
-
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p,
-			       "%u\n", local->wme_rx_queue[i]);
-
-	return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
-}
-
-static const struct file_operations stats_wme_rx_queue_ops = {
-	.read = stats_wme_rx_queue_read,
-	.open = mac80211_open_file_generic,
-};
-
-static ssize_t stats_wme_tx_queue_read(struct file *file,
-				       char __user *userbuf,
-				       size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	char buf[NUM_TX_DATA_QUEUES*15], *p = buf;
-	int i;
-
-	for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p,
-			       "%u\n", local->wme_tx_queue[i]);
-
-	return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
-}
-
-static const struct file_operations stats_wme_tx_queue_ops = {
-	.read = stats_wme_tx_queue_read,
-	.open = mac80211_open_file_generic,
-};
 #endif
 
 DEBUGFS_DEVSTATS_FILE(dot11ACKFailureCount);
@@ -303,8 +263,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_STATS_ADD(rx_expand_skb_head2);
 	DEBUGFS_STATS_ADD(rx_handlers_fragments);
 	DEBUGFS_STATS_ADD(tx_status_drop);
-	DEBUGFS_STATS_ADD(wme_tx_queue);
-	DEBUGFS_STATS_ADD(wme_rx_queue);
 #endif
 	DEBUGFS_STATS_ADD(dot11ACKFailureCount);
 	DEBUGFS_STATS_ADD(dot11RTSFailureCount);
@@ -356,8 +314,6 @@ void debugfs_hw_del(struct ieee80211_local *local)
 	DEBUGFS_STATS_DEL(rx_expand_skb_head2);
 	DEBUGFS_STATS_DEL(rx_handlers_fragments);
 	DEBUGFS_STATS_DEL(tx_status_drop);
-	DEBUGFS_STATS_DEL(wme_tx_queue);
-	DEBUGFS_STATS_DEL(wme_rx_queue);
 #endif
 	DEBUGFS_STATS_DEL(dot11ACKFailureCount);
 	DEBUGFS_STATS_DEL(dot11RTSFailureCount);
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 47db0d4..bc20a44 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -148,36 +148,6 @@ static ssize_t sta_last_seq_ctrl_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(last_seq_ctrl);
 
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-static ssize_t sta_wme_rx_queue_read(struct file *file, char __user *userbuf,
-				     size_t count, loff_t *ppos)
-{
-	char buf[15*NUM_RX_DATA_QUEUES], *p = buf;
-	int i;
-	struct sta_info *sta = file->private_data;
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%u ",
-			       sta->wme_rx_queue[i]);
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
-	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
-}
-STA_OPS(wme_rx_queue);
-
-static ssize_t sta_wme_tx_queue_read(struct file *file, char __user *userbuf,
-				     size_t count, loff_t *ppos)
-{
-	char buf[15*NUM_TX_DATA_QUEUES], *p = buf;
-	int i;
-	struct sta_info *sta = file->private_data;
-	for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%u ",
-			       sta->wme_tx_queue[i]);
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
-	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
-}
-STA_OPS(wme_tx_queue);
-#endif
-
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
@@ -314,10 +284,6 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(last_ack_ms);
 	DEBUGFS_ADD(inactive_ms);
 	DEBUGFS_ADD(last_seq_ctrl);
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	DEBUGFS_ADD(wme_rx_queue);
-	DEBUGFS_ADD(wme_tx_queue);
-#endif
 	DEBUGFS_ADD(agg_status);
 }
 
@@ -329,10 +295,6 @@ void ieee80211_sta_debugfs_remove(struct sta_info *sta)
 	DEBUGFS_DEL(last_ack_ms);
 	DEBUGFS_DEL(inactive_ms);
 	DEBUGFS_DEL(last_seq_ctrl);
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	DEBUGFS_DEL(wme_rx_queue);
-	DEBUGFS_DEL(wme_tx_queue);
-#endif
 	DEBUGFS_DEL(agg_status);
 
 	debugfs_remove(sta->debugfs.dir);
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 7df1479..0f47b29 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -290,7 +290,6 @@ static int ieee80211_open(struct net_device *dev)
 	if (local->open_count == 0) {
 		res = dev_open(local->mdev);
 		WARN_ON(res);
-		tasklet_enable(&local->tx_pending_tasklet);
 		tasklet_enable(&local->tasklet);
 	}
 
@@ -443,7 +442,6 @@ static int ieee80211_stop(struct net_device *dev)
 
 		ieee80211_led_radio(local, 0);
 
-		tasklet_disable(&local->tx_pending_tasklet);
 		tasklet_disable(&local->tasklet);
 	}
 
@@ -1133,7 +1131,6 @@ static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 		pkt_data->flags |= IEEE80211_TXPD_REQUEUE;
 	if (control->flags & IEEE80211_TXCTL_EAPOL_FRAME)
 		pkt_data->flags |= IEEE80211_TXPD_EAPOL_FRAME;
-	pkt_data->queue = control->queue;
 
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 
@@ -1437,10 +1434,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	sta_info_init(local);
 
-	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
-		     (unsigned long)local);
-	tasklet_disable(&local->tx_pending_tasklet);
-
 	tasklet_init(&local->tasklet,
 		     ieee80211_tasklet_handler,
 		     (unsigned long) local);
@@ -1485,8 +1478,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		return result;
 
 	/* for now, mdev needs sub_if_data :/ */
-	mdev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
-			    "wmaster%d", ether_setup);
+	mdev = alloc_netdev_mq(sizeof(struct ieee80211_sub_if_data),
+			       "wmaster%d", ether_setup,
+			       hw->queues + hw->ampdu_queues);
 	if (!mdev)
 		goto fail_mdev_alloc;
 
@@ -1578,6 +1572,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_wep;
 	}
 
+	if (hw->queues > IEEE80211_MAX_QUEUES)
+		hw->queues = IEEE80211_MAX_QUEUES;
+	if (hw->ampdu_queues > IEEE80211_MAX_AMPDU_QUEUES)
+		hw->ampdu_queues = IEEE80211_MAX_AMPDU_QUEUES;
+
 	ieee80211_install_qdisc(local->mdev);
 
 	/* add one default STA interface */
@@ -1619,7 +1618,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata, *tmp;
 
-	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
 
 	rtnl_lock();
@@ -1653,7 +1651,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	rtnl_unlock();
 
 	ieee80211_rx_bss_list_deinit(local->mdev);
-	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);
 	rate_control_deinitialize(local);
 	debugfs_hw_del(local);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b07b3cb..63e2b6f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -179,7 +179,6 @@ struct ieee80211_tx_packet_data {
 	int ifindex;
 	unsigned long jiffies;
 	unsigned int flags;
-	u8 queue;
 };
 
 struct ieee80211_tx_stored_packet {
@@ -450,10 +449,6 @@ struct ieee80211_local {
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
-	unsigned long state[NUM_TX_DATA_QUEUES_AMPDU];
-	struct ieee80211_tx_stored_packet pending_packet[NUM_TX_DATA_QUEUES_AMPDU];
-	struct tasklet_struct tx_pending_tasklet;
-
 	/* number of interfaces with corresponding IFF_ flags */
 	atomic_t iff_allmultis, iff_promiscs;
 
@@ -538,8 +533,6 @@ struct ieee80211_local {
 	unsigned int rx_expand_skb_head2;
 	unsigned int rx_handlers_fragments;
 	unsigned int tx_status_drop;
-	unsigned int wme_rx_queue[NUM_RX_DATA_QUEUES];
-	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
 #define I802_DEBUG_INC(c) (c)++
 #else /* CONFIG_MAC80211_DEBUG_COUNTERS */
 #define I802_DEBUG_INC(c) do { } while (0)
@@ -597,8 +590,6 @@ struct ieee80211_local {
 			struct dentry *rx_expand_skb_head2;
 			struct dentry *rx_handlers_fragments;
 			struct dentry *tx_status_drop;
-			struct dentry *wme_tx_queue;
-			struct dentry *wme_rx_queue;
 #endif
 			struct dentry *dot11ACKFailureCount;
 			struct dentry *dot11RTSFailureCount;
@@ -629,11 +620,6 @@ static inline struct ieee80211_hw *local_to_hw(
 	return &local->hw;
 }
 
-enum ieee80211_link_state_t {
-	IEEE80211_LINK_STATE_XOFF = 0,
-	IEEE80211_LINK_STATE_PENDING,
-};
-
 struct sta_attribute {
 	struct attribute attr;
 	ssize_t (*show)(const struct sta_info *, char *buf);
@@ -738,8 +724,6 @@ void ieee80211_if_free(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
 
 /* tx handling */
-void ieee80211_clear_tx_pending(struct ieee80211_local *local);
-void ieee80211_tx_pending(unsigned long data);
 int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 453d14a..0f4e56f 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -263,26 +263,26 @@ static void ieee80211_sta_wmm_params(struct net_device *dev,
 
 		switch (aci) {
 		case 1:
-			queue = IEEE80211_TX_QUEUE_DATA3;
+			queue = 3;
 			if (acm) {
 				local->wmm_acm |= BIT(0) | BIT(3);
 			}
 			break;
 		case 2:
-			queue = IEEE80211_TX_QUEUE_DATA1;
+			queue = 1;
 			if (acm) {
 				local->wmm_acm |= BIT(4) | BIT(5);
 			}
 			break;
 		case 3:
-			queue = IEEE80211_TX_QUEUE_DATA0;
+			queue = 0;
 			if (acm) {
 				local->wmm_acm |= BIT(6) | BIT(7);
 			}
 			break;
 		case 0:
 		default:
-			queue = IEEE80211_TX_QUEUE_DATA2;
+			queue = 2;
 			if (acm) {
 				local->wmm_acm |= BIT(1) | BIT(2);
 			}
@@ -3243,8 +3243,6 @@ int ieee80211_sta_set_ssid(struct net_device *dev, char *ssid, size_t len)
 	if (len > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;
 
-	/* TODO: This should always be done for IBSS, even if IEEE80211_QOS is
-	 * not defined. */
 	if (local->ops->conf_tx) {
 		struct ieee80211_tx_queue_params qparam;
 		int i;
@@ -3262,17 +3260,9 @@ int ieee80211_sta_set_ssid(struct net_device *dev, char *ssid, size_t len)
 		qparam.cw_max = 1023;
 		qparam.txop = 0;
 
-		for (i = IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
-			local->ops->conf_tx(local_to_hw(local),
-					   i + IEEE80211_TX_QUEUE_DATA0,
-					   &qparam);
-
-		/* IBSS uses different parameters for Beacon sending */
-		qparam.cw_min++;
-		qparam.cw_min *= 2;
-		qparam.cw_min--;
-		local->ops->conf_tx(local_to_hw(local),
-				   IEEE80211_TX_QUEUE_BEACON, &qparam);
+		for (i = 0; i < local_to_hw(local)->queues; i++)
+			local->ops->conf_tx(local_to_hw(local), i,
+					    &qparam);
 	}
 
 	ifsta = &sdata->u.sta;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 48574f6..dd2cdb0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -274,11 +274,6 @@ static void ieee80211_parse_qos(struct ieee80211_txrx_data *rx)
 		}
 	}
 
-	I802_DEBUG_INC(rx->local->wme_rx_queue[tid]);
-	/* only a debug counter, sta might not be assigned properly yet */
-	if (rx->sta)
-		I802_DEBUG_INC(rx->sta->wme_rx_queue[tid]);
-
 	rx->u.rx.queue = tid;
 	/* Set skb->priority to 1d tag if highest order bit of TID is not set.
 	 * For now, set skb->priority to 0 for other cases. */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b31a627..9a8a56a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -142,7 +142,7 @@ struct sta_info * sta_info_add(struct ieee80211_local *local,
 		 * sta_rx_agg_session_timer_expired for useage */
 		sta->timer_to_tid[i] = i;
 		/* tid to tx queue: initialize according to HW (0 is valid) */
-		sta->tid_to_tx_q[i] = local->hw.queues;
+		sta->tid_to_tx_q[i] = local->hw.queues + local->hw.ampdu_queues;
 		/* rx timers */
 		sta->ampdu_mlme.tid_rx[i].session_timer.function =
 			sta_rx_agg_session_timer_expired;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4099ece..6a6f40f 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -180,11 +180,6 @@ struct sta_info {
 	int channel_use;
 	int channel_use_raw;
 
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	unsigned int wme_rx_queue[NUM_RX_DATA_QUEUES];
-	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
-#endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
-
 	u16 listen_interval;
 
 	struct ieee80211_ht_info ht_info; /* 802.11n HT capabilities
@@ -202,10 +197,6 @@ struct sta_info {
 		struct dentry *last_ack_ms;
 		struct dentry *inactive_ms;
 		struct dentry *last_seq_ctrl;
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-		struct dentry *wme_rx_queue;
-		struct dentry *wme_tx_queue;
-#endif
 		struct dentry *agg_status;
 	} debugfs;
 #endif
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 69fdb76..f5cefa0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -31,9 +31,6 @@
 #include "wme.h"
 #include "ieee80211_rate.h"
 
-#define IEEE80211_TX_OK		0
-#define IEEE80211_TX_AGAIN	1
-#define IEEE80211_TX_FRAG_AGAIN	2
 
 /* misc utils */
 
@@ -211,18 +208,6 @@ static u16 ieee80211_duration(struct ieee80211_txrx_data *tx, int group_addr,
 	return dur;
 }
 
-static inline int __ieee80211_queue_stopped(const struct ieee80211_local *local,
-					    int queue)
-{
-	return test_bit(IEEE80211_LINK_STATE_XOFF, &local->state[queue]);
-}
-
-static inline int __ieee80211_queue_pending(const struct ieee80211_local *local,
-					    int queue)
-{
-	return test_bit(IEEE80211_LINK_STATE_PENDING, &local->state[queue]);
-}
-
 static int inline is_ieee80211_device(struct net_device *dev,
 				      struct net_device *master)
 {
@@ -1067,17 +1052,12 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 	struct ieee80211_tx_control *control = tx->u.tx.control;
 	int ret, i;
 
-	if (!ieee80211_qdisc_installed(local->mdev) &&
-	    __ieee80211_queue_stopped(local, 0)) {
-		netif_stop_queue(local->mdev);
-		return IEEE80211_TX_AGAIN;
-	}
 	if (skb) {
 		ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 				     "TX to low-level driver", skb);
 		ret = local->ops->tx(local_to_hw(local), skb, control);
 		if (ret)
-			return IEEE80211_TX_AGAIN;
+			return NETDEV_TX_BUSY;
 		local->mdev->trans_start = jiffies;
 		ieee80211_led_tx(local, 1);
 	}
@@ -1089,8 +1069,14 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
 			if (!tx->u.tx.extra_frag[i])
 				continue;
-			if (__ieee80211_queue_stopped(local, control->queue))
-				return IEEE80211_TX_FRAG_AGAIN;
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
+			if (__netif_subqueue_stopped(local->mdev,
+					tx->u.tx.extra_frag[i]->queue_mapping))
+				return NETDEV_TX_BUSY; /* XXX: FRAG AGAIN! */
+#else
+			if (netif_queue_stopped(local->mdev))
+				return NETDEV_TX_BUSY; /* XXX: FRAG AGAIN! */
+#endif
 			if (i == tx->u.tx.num_extra_frag) {
 				control->tx_rate = tx->u.tx.last_frag_rate;
 
@@ -1109,7 +1095,7 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 					    tx->u.tx.extra_frag[i],
 					    control);
 			if (ret)
-				return IEEE80211_TX_FRAG_AGAIN;
+				return NETDEV_TX_BUSY; /* XXX: FRAG AGAIN! */
 			local->mdev->trans_start = jiffies;
 			ieee80211_led_tx(local, 1);
 			tx->u.tx.extra_frag[i] = NULL;
@@ -1117,7 +1103,7 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 		kfree(tx->u.tx.extra_frag);
 		tx->u.tx.extra_frag = NULL;
 	}
-	return IEEE80211_TX_OK;
+	return NETDEV_TX_OK;
 }
 
 static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
@@ -1130,8 +1116,6 @@ static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
 	ieee80211_tx_result res = TX_DROP, res_prepare;
 	int ret, i;
 
-	WARN_ON(__ieee80211_queue_pending(local, control->queue));
-
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
 		return 0;
@@ -1195,42 +1179,9 @@ static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
 		}
 	}
 
-retry:
 	ret = __ieee80211_tx(local, skb, &tx);
-	if (ret) {
-		struct ieee80211_tx_stored_packet *store =
-			&local->pending_packet[control->queue];
-
-		if (ret == IEEE80211_TX_FRAG_AGAIN)
-			skb = NULL;
-		set_bit(IEEE80211_LINK_STATE_PENDING,
-			&local->state[control->queue]);
-		smp_mb();
-		/* When the driver gets out of buffers during sending of
-		 * fragments and calls ieee80211_stop_queue, there is
-		 * a small window between IEEE80211_LINK_STATE_XOFF and
-		 * IEEE80211_LINK_STATE_PENDING flags are set. If a buffer
-		 * gets available in that window (i.e. driver calls
-		 * ieee80211_wake_queue), we would end up with ieee80211_tx
-		 * called with IEEE80211_LINK_STATE_PENDING. Prevent this by
-		 * continuing transmitting here when that situation is
-		 * possible to have happened. */
-		if (!__ieee80211_queue_stopped(local, control->queue)) {
-			clear_bit(IEEE80211_LINK_STATE_PENDING,
-				  &local->state[control->queue]);
-			goto retry;
-		}
-		memcpy(&store->control, control,
-		       sizeof(struct ieee80211_tx_control));
-		store->skb = skb;
-		store->extra_frag = tx.u.tx.extra_frag;
-		store->num_extra_frag = tx.u.tx.num_extra_frag;
-		store->last_frag_rate = tx.u.tx.last_frag_rate;
-		store->last_frag_rate_ctrl_probe =
-			!!(tx.flags & IEEE80211_TXRXD_TXPROBE_LAST_FRAG);
-	}
 	rcu_read_unlock();
-	return 0;
+	return ret;
 
  drop:
 	if (skb)
@@ -1287,7 +1238,6 @@ int ieee80211_master_start_xmit(struct sk_buff *skb,
 	}
 
 	control.vif = &osdata->vif;
-	control.type = osdata->vif.type;
 	if (pkt_data->flags & IEEE80211_TXPD_REQ_TX_STATUS)
 		control.flags |= IEEE80211_TXCTL_REQ_TX_STATUS;
 	if (pkt_data->flags & IEEE80211_TXPD_DO_NOT_ENCRYPT)
@@ -1298,7 +1248,6 @@ int ieee80211_master_start_xmit(struct sk_buff *skb,
 		control.flags |= IEEE80211_TXCTL_EAPOL_FRAME;
 	if (pkt_data->flags & IEEE80211_TXPD_AMPDU)
 		control.flags |= IEEE80211_TXCTL_AMPDU;
-	control.queue = pkt_data->queue;
 
 	ret = ieee80211_tx(odev, skb, &control);
 	dev_put(odev);
@@ -1604,69 +1553,6 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-/* helper functions for pending packets for when queues are stopped */
-
-void ieee80211_clear_tx_pending(struct ieee80211_local *local)
-{
-	int i, j;
-	struct ieee80211_tx_stored_packet *store;
-
-	for (i = 0; i < local->hw.queues; i++) {
-		if (!__ieee80211_queue_pending(local, i))
-			continue;
-		store = &local->pending_packet[i];
-		kfree_skb(store->skb);
-		for (j = 0; j < store->num_extra_frag; j++)
-			kfree_skb(store->extra_frag[j]);
-		kfree(store->extra_frag);
-		clear_bit(IEEE80211_LINK_STATE_PENDING, &local->state[i]);
-	}
-}
-
-void ieee80211_tx_pending(unsigned long data)
-{
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
-	struct net_device *dev = local->mdev;
-	struct ieee80211_tx_stored_packet *store;
-	struct ieee80211_txrx_data tx;
-	int i, ret, reschedule = 0;
-
-	netif_tx_lock_bh(dev);
-	for (i = 0; i < local->hw.queues; i++) {
-		if (__ieee80211_queue_stopped(local, i))
-			continue;
-		if (!__ieee80211_queue_pending(local, i)) {
-			reschedule = 1;
-			continue;
-		}
-		store = &local->pending_packet[i];
-		tx.u.tx.control = &store->control;
-		tx.u.tx.extra_frag = store->extra_frag;
-		tx.u.tx.num_extra_frag = store->num_extra_frag;
-		tx.u.tx.last_frag_rate = store->last_frag_rate;
-		tx.flags = 0;
-		if (store->last_frag_rate_ctrl_probe)
-			tx.flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
-		ret = __ieee80211_tx(local, store->skb, &tx);
-		if (ret) {
-			if (ret == IEEE80211_TX_FRAG_AGAIN)
-				store->skb = NULL;
-		} else {
-			clear_bit(IEEE80211_LINK_STATE_PENDING,
-				  &local->state[i]);
-			reschedule = 1;
-		}
-	}
-	netif_tx_unlock_bh(dev);
-	if (reschedule) {
-		if (!ieee80211_qdisc_installed(dev)) {
-			if (!__ieee80211_queue_stopped(local, 0))
-				netif_wake_queue(dev);
-		} else
-			netif_schedule(dev);
-	}
-}
-
 /* functions for drivers to get certain frames */
 
 static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f64804f..a9225d4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -302,22 +302,28 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 
+void ieee80211_start_queue(struct ieee80211_hw *hw, int queue)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
+	netif_start_subqueue(local->mdev, queue);
+#else
+	WARN_ON(queue != 0);
+	netif_start_queue(local->mdev);
+#endif
+}
+EXPORT_SYMBOL(ieee80211_start_queue);
+
 void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	if (test_and_clear_bit(IEEE80211_LINK_STATE_XOFF,
-			       &local->state[queue])) {
-		if (test_bit(IEEE80211_LINK_STATE_PENDING,
-			     &local->state[queue]))
-			tasklet_schedule(&local->tx_pending_tasklet);
-		else
-			if (!ieee80211_qdisc_installed(local->mdev)) {
-				if (queue == 0)
-					netif_wake_queue(local->mdev);
-			} else
-				__netif_schedule(local->mdev);
-	}
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
+	netif_wake_subqueue(local->mdev, queue);
+#else
+	WARN_ON(queue != 0);
+	netif_wake_queue(local->mdev);
+#endif
 }
 EXPORT_SYMBOL(ieee80211_wake_queue);
 
@@ -325,39 +331,51 @@ void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	if (!ieee80211_qdisc_installed(local->mdev) && queue == 0)
-		netif_stop_queue(local->mdev);
-	set_bit(IEEE80211_LINK_STATE_XOFF, &local->state[queue]);
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
+	netif_stop_subqueue(local->mdev, queue);
+#else
+	WARN_ON(queue != 0);
+	netif_stop_queue(local->mdev);
+#endif
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
 void ieee80211_start_queues(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
 	int i;
 
-	for (i = 0; i < local->hw.queues; i++)
-		clear_bit(IEEE80211_LINK_STATE_XOFF, &local->state[i]);
-	if (!ieee80211_qdisc_installed(local->mdev))
-		netif_start_queue(local->mdev);
+	for (i = 0; i < hw->queues; i++)
+		ieee80211_start_queue(hw, i);
+#else
+	netif_start_queue(local->mdev);
+#endif
 }
 EXPORT_SYMBOL(ieee80211_start_queues);
 
 void ieee80211_stop_queues(struct ieee80211_hw *hw)
 {
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
 	int i;
 
 	for (i = 0; i < hw->queues; i++)
 		ieee80211_stop_queue(hw, i);
+#else
+	netif_stop_queue(local->mdev);
+#endif
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
 void ieee80211_wake_queues(struct ieee80211_hw *hw)
 {
+#ifdef CONFIG_NETDEVICES_MULTIQUEUE
 	int i;
 
 	for (i = 0; i < hw->queues; i++)
 		ieee80211_wake_queue(hw, i);
+#else
+	netif_wake_queue(local->mdev);
+#endif
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 8cc036d..cde6811 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -19,16 +19,22 @@
 #include "wme.h"
 
 /* maximum number of hardware queues we support. */
-#define TC_80211_MAX_QUEUES 16
+#define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES)
+/* current number of hardware queues we support. */
+#define QD_NUM(hw) hw->queues + hw->ampdu_queues
 
+/*
+ * Default mapping in classifier to work with default
+ * queue setup.
+ */
 const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
 
 struct ieee80211_sched_data
 {
-	unsigned long qdisc_pool[BITS_TO_LONGS(TC_80211_MAX_QUEUES)];
+	unsigned long qdisc_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
 	struct tcf_proto *filter_list;
-	struct Qdisc *queues[TC_80211_MAX_QUEUES];
-	struct sk_buff_head requeued[TC_80211_MAX_QUEUES];
+	struct Qdisc *queues[QD_MAX_QUEUES];
+	struct sk_buff_head requeued[QD_MAX_QUEUES];
 };
 
 static const char llc_ip_hdr[8] = {0xAA, 0xAA, 0x3, 0, 0, 0, 0x08, 0};
@@ -95,7 +101,7 @@ static inline int wme_downgrade_ac(struct sk_buff *skb)
 
 /* positive return value indicates which queue to use
  * negative return value indicates to drop the frame */
-static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
+static int classify80211(struct sk_buff *skb, struct Qdisc *qd)
 {
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -106,7 +112,7 @@ static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
 	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)) {
 		/* management frames go on AC_VO queue, but are sent
 		* without QoS control fields */
-		return IEEE80211_TX_QUEUE_DATA0;
+		return 0;
 	}
 
 	if (0 /* injected */) {
@@ -141,23 +147,26 @@ static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
 static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 {
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
 	struct ieee80211_tx_packet_data *pkt_data =
 		(struct ieee80211_tx_packet_data *) skb->cb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	struct Qdisc *qdisc;
-	int err, queue;
+	int err;
+	int queue;
 	struct sta_info *sta;
 	u8 tid;
 
+
 	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE) {
-		queue = pkt_data->queue;
+		queue = skb->queue_mapping;
 		sta = sta_info_get(local, hdr->addr1);
 		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
-			if ((ampdu_queue < local->hw.queues) &&
+			if ((ampdu_queue < QD_NUM(hw)) &&
 			    test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
 				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
@@ -190,7 +199,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
-			if ((ampdu_queue < local->hw.queues) &&
+			if ((ampdu_queue < QD_NUM(hw)) &&
 				test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
 				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
@@ -201,12 +210,12 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 		}
 	}
 
-	if (unlikely(queue >= local->hw.queues)) {
+	if (unlikely(queue >= QD_NUM(hw))) {
 #if 0
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s - queue=%d (hw does not "
 			       "support) -> %d\n",
-			       __func__, queue, local->hw.queues - 1);
+			       __func__, queue, QD_NUM(hw) - 1);
 		}
 #endif
 		queue = local->hw.queues - 1;
@@ -217,7 +226,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 			err = NET_XMIT_DROP;
 	} else {
 		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
-		pkt_data->queue = (unsigned int) queue;
+		skb->queue_mapping = (u16) queue;
 		qdisc = q->queues[queue];
 		err = qdisc->enqueue(skb, qdisc);
 		if (err == NET_XMIT_SUCCESS) {
@@ -238,13 +247,11 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 static int wme_qdiscop_requeue(struct sk_buff *skb, struct Qdisc* qd)
 {
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
-	struct ieee80211_tx_packet_data *pkt_data =
-		(struct ieee80211_tx_packet_data *) skb->cb;
 	struct Qdisc *qdisc;
 	int err;
 
 	/* we recorded which queue to use earlier! */
-	qdisc = q->queues[pkt_data->queue];
+	qdisc = q->queues[skb->queue_mapping];
 
 	if ((err = qdisc->ops->requeue(skb, qdisc)) == 0) {
 		qd->q.qlen++;
@@ -266,13 +273,9 @@ static struct sk_buff *wme_qdiscop_dequeue(struct Qdisc* qd)
 	int queue;
 
 	/* check all the h/w queues in numeric/priority order */
-	for (queue = 0; queue < hw->queues; queue++) {
+	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		/* see if there is room in this hardware queue */
-		if ((test_bit(IEEE80211_LINK_STATE_XOFF,
-				&local->state[queue])) ||
-		    (test_bit(IEEE80211_LINK_STATE_PENDING,
-				&local->state[queue])) ||
-			 (!test_bit(queue, q->qdisc_pool)))
+		if (__netif_subqueue_stopped(local->mdev, queue))
 			continue;
 
 		/* there is space - try and get a frame */
@@ -304,7 +307,7 @@ static void wme_qdiscop_reset(struct Qdisc* qd)
 
 	/* QUESTION: should we have some hardware flush functionality here? */
 
-	for (queue = 0; queue < hw->queues; queue++) {
+	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		skb_queue_purge(&q->requeued[queue]);
 		qdisc_reset(q->queues[queue]);
 	}
@@ -322,7 +325,7 @@ static void wme_qdiscop_destroy(struct Qdisc* qd)
 	tcf_destroy_chain(q->filter_list);
 	q->filter_list = NULL;
 
-	for (queue=0; queue < hw->queues; queue++) {
+	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		skb_queue_purge(&q->requeued[queue]);
 		qdisc_destroy(q->queues[queue]);
 		q->queues[queue] = &noop_qdisc;
@@ -333,17 +336,6 @@ static void wme_qdiscop_destroy(struct Qdisc* qd)
 /* called whenever parameters are updated on existing qdisc */
 static int wme_qdiscop_tune(struct Qdisc *qd, struct nlattr *opt)
 {
-/*	struct ieee80211_sched_data *q = qdisc_priv(qd);
-*/
-	/* check our options block is the right size */
-	/* copy any options to our local structure */
-/*	Ignore options block for now - always use static mapping
-	struct tc_ieee80211_qopt *qopt = nla_data(opt);
-
-	if (opt->nla_len < nla_attr_size(sizeof(*qopt)))
-		return -EINVAL;
-	memcpy(q->tag2queue, qopt->tag2queue, sizeof(qopt->tag2queue));
-*/
 	return 0;
 }
 
@@ -354,7 +346,7 @@ static int wme_qdiscop_init(struct Qdisc *qd, struct nlattr *opt)
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
 	struct net_device *dev = qd->dev;
 	struct ieee80211_local *local;
-	int queues;
+	struct ieee80211_hw *hw;
 	int err = 0, i;
 
 	/* check that device is a mac80211 device */
@@ -362,29 +354,26 @@ static int wme_qdiscop_init(struct Qdisc *qd, struct nlattr *opt)
 	    dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
 		return -EINVAL;
 
-	/* check this device is an ieee80211 master type device */
-	if (dev->type != ARPHRD_IEEE80211)
+	local = wdev_priv(dev->ieee80211_ptr);
+	hw = &local->hw;
+
+	/* only allow on master dev */
+	if (dev != local->mdev)
 		return -EINVAL;
 
-	/* check that there is no qdisc currently attached to device
-	 * this ensures that we will be the root qdisc. (I can't find a better
-	 * way to test this explicitly) */
-	if (dev->qdisc_sleeping != &noop_qdisc)
+	/* ensure that we are root qdisc */
+	if (qd->parent != TC_H_ROOT)
 		return -EINVAL;
 
 	if (qd->flags & TCQ_F_INGRESS)
 		return -EINVAL;
 
-	local = wdev_priv(dev->ieee80211_ptr);
-	queues = local->hw.queues;
-
 	/* if options were passed in, set them */
-	if (opt) {
+	if (opt)
 		err = wme_qdiscop_tune(qd, opt);
-	}
 
 	/* create child queues */
-	for (i = 0; i < queues; i++) {
+	for (i = 0; i < QD_NUM(hw); i++) {
 		skb_queue_head_init(&q->requeued[i]);
 		q->queues[i] = qdisc_create_dflt(qd->dev, &pfifo_qdisc_ops,
 						 qd->handle);
@@ -394,25 +383,15 @@ static int wme_qdiscop_init(struct Qdisc *qd, struct nlattr *opt)
 		}
 	}
 
-	/* reserve all legacy QoS queues */
-	for (i = 0; i < min(IEEE80211_TX_QUEUE_DATA4, queues); i++)
-		set_bit(i, q->qdisc_pool);
+	/* reserve legacy queues */
+	for (i = 0; i < local->hw.queues; i++)
+		set_bit(i, &q->qdisc_pool);
 
 	return err;
 }
 
 static int wme_qdiscop_dump(struct Qdisc *qd, struct sk_buff *skb)
 {
-/*	struct ieee80211_sched_data *q = qdisc_priv(qd);
-	unsigned char *p = skb->tail;
-	struct tc_ieee80211_qopt opt;
-
-	memcpy(&opt.tag2queue, q->tag2queue, TC_80211_MAX_TAG + 1);
-	NLA_PUT(skb, TCA_OPTIONS, sizeof(opt), &opt);
-*/	return skb->len;
-/*
-nla_put_failure:
-	skb_trim(skb, p - skb->data);*/
 	return -1;
 }
 
@@ -425,7 +404,7 @@ static int wme_classop_graft(struct Qdisc *qd, unsigned long arg,
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long queue = arg - 1;
 
-	if (queue >= hw->queues)
+	if (queue >= QD_NUM(hw))
 		return -EINVAL;
 
 	if (!new)
@@ -449,7 +428,7 @@ wme_classop_leaf(struct Qdisc *qd, unsigned long arg)
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long queue = arg - 1;
 
-	if (queue >= hw->queues)
+	if (queue >= QD_NUM(hw))
 		return NULL;
 
 	return q->queues[queue];
@@ -462,7 +441,7 @@ static unsigned long wme_classop_get(struct Qdisc *qd, u32 classid)
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long queue = TC_H_MIN(classid);
 
-	if (queue - 1 >= hw->queues)
+	if (queue - 1 >= QD_NUM(hw))
 		return 0;
 
 	return queue;
@@ -488,7 +467,7 @@ static int wme_classop_change(struct Qdisc *qd, u32 handle, u32 parent,
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 
-	if (cl - 1 > hw->queues)
+	if (cl - 1 > QD_NUM(hw))
 		return -ENOENT;
 
 	/* TODO: put code to program hardware queue parameters here,
@@ -505,7 +484,7 @@ static int wme_classop_delete(struct Qdisc *qd, unsigned long cl)
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 
-	if (cl - 1 > hw->queues)
+	if (cl - 1 > QD_NUM(hw))
 		return -ENOENT;
 	return 0;
 }
@@ -518,7 +497,7 @@ static int wme_classop_dump_class(struct Qdisc *qd, unsigned long cl,
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 
-	if (cl - 1 > hw->queues)
+	if (cl - 1 > QD_NUM(hw))
 		return -ENOENT;
 	tcm->tcm_handle = TC_H_MIN(cl);
 	tcm->tcm_parent = qd->handle;
@@ -536,7 +515,7 @@ static void wme_classop_walk(struct Qdisc *qd, struct qdisc_walker *arg)
 	if (arg->stop)
 		return;
 
-	for (queue = 0; queue < hw->queues; queue++) {
+	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		if (arg->count < arg->skip) {
 			arg->count++;
 			continue;
@@ -653,10 +632,13 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 	DECLARE_MAC_BUF(mac);
 
 	/* prepare the filter and save it for the SW queue
-	 * matching the recieved HW queue */
+	 * matching the received HW queue */
+
+	if (!local->hw.ampdu_queues)
+		return -EPERM;
 
 	/* try to get a Qdisc from the pool */
-	for (i = IEEE80211_TX_QUEUE_BEACON; i < local->hw.queues; i++)
+	for (i = local->hw.queues; i < local->hw.ampdu_queues; i++)
 		if (!test_and_set_bit(i, q->qdisc_pool)) {
 			ieee80211_stop_queue(local_to_hw(local), i);
 			sta->tid_to_tx_q[tid] = i;
@@ -665,13 +647,10 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 			 * on this tid first we need to drain them
 			 * on the previous queue
 			 * since HT is strict in order */
-#ifdef CONFIG_MAC80211_HT_DEBUG
-			if (net_ratelimit())
 				printk(KERN_DEBUG "allocated aggregation queue"
 					" %d tid %d addr %s pool=0x%lX",
 					i, tid, print_mac(mac, sta->addr),
 					q->qdisc_pool[0]);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
 			return 0;
 		}
 
@@ -685,13 +664,14 @@ void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
 				   struct sta_info *sta, u16 tid,
 				   u8 requeue)
 {
+	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sched_data *q =
 		qdisc_priv(local->mdev->qdisc_sleeping);
 	int agg_queue = sta->tid_to_tx_q[tid];
 
 	/* return the qdisc to the pool */
 	clear_bit(agg_queue, q->qdisc_pool);
-	sta->tid_to_tx_q[tid] = local->hw.queues;
+	sta->tid_to_tx_q[tid] = QD_NUM(hw);
 
 	if (requeue)
 		ieee80211_requeue(local, agg_queue);
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

