Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbYEPXD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 19:03:57 -0400
Message-Id: <20080516230007.837741000@sipsolutions.net> (sfid-20080517_010403_767539_186312FB)
References: <20080516225712.794319000@sipsolutions.net>
Date: Sat, 17 May 2008 00:57:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
	Ron Rindjunksi <ron.rindjunski@intel.com>
Subject: [PATCH 2/2] mac80211: use multi-queue master netdevice
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates mac80211 and drivers to be multi-queue aware and
use that instead of the internal queue mapping. Also does a number
of cleanups in various pieces of the code that fall out and reduces
internal mac80211 state size.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This is just ground-work. We'll be able to play with Qos much more now.

 drivers/net/wireless/ath5k/base.c           |    2 
 drivers/net/wireless/b43/dma.c              |    7 +-
 drivers/net/wireless/b43/pio.c              |    8 +-
 drivers/net/wireless/b43legacy/dma.c        |    3 
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 -
 drivers/net/wireless/p54/p54common.c        |    8 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   10 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h   |   13 ---
 drivers/net/wireless/rtl8180_dev.c          |    4 -
 include/net/mac80211.h                      |   20 +++++
 net/mac80211/Kconfig                        |   14 +++-
 net/mac80211/Makefile                       |    2 
 net/mac80211/ieee80211_i.h                  |   16 ++--
 net/mac80211/iface.c                        |    2 
 net/mac80211/main.c                         |   29 ++++++--
 net/mac80211/sta_info.c                     |    2 
 net/mac80211/tx.c                           |   97 ++++++++++++----------------
 net/mac80211/util.c                         |   29 ++++----
 net/mac80211/wme.c                          |   14 +---
 net/mac80211/wme.h                          |    2 
 21 files changed, 158 insertions(+), 132 deletions(-)

--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-05-16 23:02:20.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.c	2008-05-16 23:02:42.000000000 +0200
@@ -2657,7 +2657,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct
 	if (list_empty(&sc->txbuf)) {
 		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
 		spin_unlock_irqrestore(&sc->txbuflock, flags);
-		ieee80211_stop_queue(hw, info->queue);
+		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
 		return -1;
 	}
 	bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-16 23:02:19.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-16 23:02:42.000000000 +0200
@@ -2552,7 +2552,7 @@ static int iwl3945_tx_skb(struct iwl3945
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl3945_tfd_frame *tfd;
 	u32 *control_flags;
-	int txq_id = info->queue;
+	int txq_id = skb_get_queue_mapping(skb);
 	struct iwl3945_tx_queue *txq = NULL;
 	struct iwl3945_queue *q = NULL;
 	dma_addr_t phys_addr;
@@ -2765,7 +2765,7 @@ static int iwl3945_tx_skb(struct iwl3945
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
-		ieee80211_stop_queue(priv->hw, info->queue);
+		ieee80211_stop_queue(priv->hw, skb_get_queue_mapping(skb));
 	}
 
 	return 0;
--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-05-16 23:02:20.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-05-16 23:02:42.000000000 +0200
@@ -407,7 +407,7 @@ static void p54_rx_frame_sent(struct iee
 			last_addr = range->end_addr;
 			__skb_unlink(entry, &priv->tx_queue);
 			memset(&info->status, 0, sizeof(info->status));
-			priv->tx_stats[info->queue].len--;
+			priv->tx_stats[skb_get_queue_mapping(skb)].len--;
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
@@ -551,13 +551,13 @@ static int p54_tx(struct ieee80211_hw *d
 	size_t padding, len;
 	u8 rate;
 
-	current_queue = &priv->tx_stats[info->queue];
+	current_queue = &priv->tx_stats[skb_get_queue_mapping(skb)];
 	if (unlikely(current_queue->len > current_queue->limit))
 		return NETDEV_TX_BUSY;
 	current_queue->len++;
 	current_queue->count++;
 	if (current_queue->len == current_queue->limit)
-		ieee80211_stop_queue(dev, info->queue);
+		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
@@ -589,7 +589,7 @@ static int p54_tx(struct ieee80211_hw *d
 	memset(txhdr->rateset, rate, 8);
 	txhdr->wep_key_present = 0;
 	txhdr->wep_key_len = 0;
-	txhdr->frame_type = cpu_to_le32(info->queue + 4);
+	txhdr->frame_type = cpu_to_le32(skb_get_queue_mapping(skb) + 4);
 	txhdr->magic4 = 0;
 	txhdr->antenna = (info->antenna_sel_tx == 0) ?
 		2 : info->antenna_sel_tx - 1;
--- everything.orig/drivers/net/wireless/rtl8180_dev.c	2008-05-16 23:02:19.000000000 +0200
+++ everything/drivers/net/wireless/rtl8180_dev.c	2008-05-16 23:02:42.000000000 +0200
@@ -246,7 +246,7 @@ static int rtl8180_tx(struct ieee80211_h
 	u16 plcp_len = 0;
 	__le16 rts_duration = 0;
 
-	prio = info->queue;
+	prio = skb_get_queue_mapping(skb);
 	ring = &priv->tx_ring[prio];
 
 	mapping = pci_map_single(priv->pdev, skb->data,
@@ -298,7 +298,7 @@ static int rtl8180_tx(struct ieee80211_h
 	entry->flags = cpu_to_le32(tx_flags);
 	__skb_queue_tail(&ring->queue, skb);
 	if (ring->entries - skb_queue_len(&ring->queue) < 2)
-		ieee80211_stop_queue(dev, info->queue);
+		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
--- everything.orig/net/mac80211/Kconfig	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/Kconfig	2008-05-16 23:04:50.000000000 +0200
@@ -7,11 +7,23 @@ config MAC80211
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
+comment "QoS/HT support disabled"
+	depends on MAC80211 && !MAC80211_QOS
+comment "QoS/HT support needs CONFIG_NET_SCHED"
+	depends on MAC80211 && !NET_SCHED
+comment "QoS/HT support needs CONFIG_NETDEVICES_MULTIQUEUE"
+	depends on MAC80211 && !NETDEVICES_MULTIQUEUE
+
 menu "Rate control algorithm selection"
 	depends on MAC80211 != n
 
--- everything.orig/net/mac80211/Makefile	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/Makefile	2008-05-16 23:02:42.000000000 +0200
@@ -29,7 +29,7 @@ mac80211-y := \
 	event.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
-mac80211-$(CONFIG_NET_SCHED) += wme.o
+mac80211-$(CONFIG_MAC80211_QOS) += wme.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
 	debugfs.o \
 	debugfs_sta.o \
--- everything.orig/net/mac80211/main.c	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/main.c	2008-05-16 23:02:42.000000000 +0200
@@ -1694,12 +1694,32 @@ int ieee80211_register_hw(struct ieee802
 	if (result < 0)
 		return result;
 
+	/*
+	 * We use the number of queues for feature tests (QoS, HT) internally
+	 * so restrict them appropriately.
+	 */
+#ifdef CONFIG_MAC80211_QOS
+	if (hw->queues > IEEE80211_MAX_QUEUES)
+		hw->queues = IEEE80211_MAX_QUEUES;
+	if (hw->ampdu_queues > IEEE80211_MAX_AMPDU_QUEUES)
+		hw->ampdu_queues = IEEE80211_MAX_AMPDU_QUEUES;
+	if (hw->queues < 4)
+		hw->ampdu_queues = 0;
+#else
+	hw->queues = 1;
+	hw->ampdu_queues = 0;
+#endif
+
 	/* for now, mdev needs sub_if_data :/ */
-	mdev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
-			    "wmaster%d", ether_setup);
+	mdev = alloc_netdev_mq(sizeof(struct ieee80211_sub_if_data),
+			       "wmaster%d", ether_setup,
+			       ieee80211_num_queues(hw));
 	if (!mdev)
 		goto fail_mdev_alloc;
 
+	if (ieee80211_num_queues(hw) > 1)
+		mdev->features |= NETIF_F_MULTI_QUEUE;
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(mdev);
 	mdev->ieee80211_ptr = &sdata->wdev;
 	sdata->wdev.wiphy = local->hw.wiphy;
@@ -1788,11 +1808,6 @@ int ieee80211_register_hw(struct ieee802
 		goto fail_wep;
 	}
 
-	if (hw->queues > IEEE80211_MAX_QUEUES)
-		hw->queues = IEEE80211_MAX_QUEUES;
-	if (hw->ampdu_queues > IEEE80211_MAX_AMPDU_QUEUES)
-		hw->ampdu_queues = IEEE80211_MAX_AMPDU_QUEUES;
-
 	ieee80211_install_qdisc(local->mdev);
 
 	/* add one default STA interface */
--- everything.orig/net/mac80211/tx.c	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-05-16 23:28:58.000000000 +0200
@@ -213,18 +213,6 @@ static u16 ieee80211_duration(struct iee
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
@@ -680,7 +668,8 @@ ieee80211_tx_h_fragment(struct ieee80211
 	 * etc.
 	 */
 	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
-		    IEEE80211_SKB_CB(tx->skb)->queue >= tx->local->hw.queues))
+		    skb_get_queue_mapping(tx->skb) >=
+		    	ieee80211_num_regular_queues(&tx->local->hw)))
 		return TX_DROP;
 
 	first = tx->skb;
@@ -1098,11 +1087,9 @@ static int __ieee80211_tx(struct ieee802
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret, i;
 
-	if (!ieee80211_qdisc_installed(local->mdev) &&
-	    __ieee80211_queue_stopped(local, 0)) {
-		netif_stop_queue(local->mdev);
+	if (netif_subqueue_stopped(local->mdev, skb))
 		return IEEE80211_TX_AGAIN;
-	}
+
 	if (skb) {
 		ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 				     "TX to low-level driver", skb);
@@ -1121,7 +1108,8 @@ static int __ieee80211_tx(struct ieee802
 					 IEEE80211_TX_CTL_USE_CTS_PROTECT |
 					 IEEE80211_TX_CTL_CLEAR_PS_FILT |
 					 IEEE80211_TX_CTL_FIRST_FRAGMENT);
-			if (__ieee80211_queue_stopped(local, info->queue))
+			if (netif_subqueue_stopped(local->mdev,
+						   tx->extra_frag[i]))
 				return IEEE80211_TX_FRAG_AGAIN;
 			if (i == tx->num_extra_frag) {
 				info->tx_rate_idx = tx->last_frag_rate_idx;
@@ -1160,9 +1148,11 @@ static int ieee80211_tx(struct net_devic
 	ieee80211_tx_result res = TX_DROP, res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret, i;
-	int queue = info->queue;
+	u16 queue;
 
-	WARN_ON(__ieee80211_queue_pending(local, queue));
+	queue = skb_get_queue_mapping(skb);
+
+	WARN_ON(test_bit(queue, local->queues_pending));
 
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
@@ -1233,28 +1223,28 @@ retry:
 		 * queues, there's no reason for a driver to reject
 		 * a frame there, warn and drop it.
 		 */
-		if (WARN_ON(queue >= local->hw.queues))
+		if (WARN_ON(queue >= ieee80211_num_regular_queues(&local->hw)))
 			goto drop;
 
 		store = &local->pending_packet[queue];
 
 		if (ret == IEEE80211_TX_FRAG_AGAIN)
 			skb = NULL;
-		set_bit(IEEE80211_LINK_STATE_PENDING,
-			&local->state[queue]);
+		set_bit(queue, local->queues_pending);
 		smp_mb();
-		/* When the driver gets out of buffers during sending of
-		 * fragments and calls ieee80211_stop_queue, there is
-		 * a small window between IEEE80211_LINK_STATE_XOFF and
-		 * IEEE80211_LINK_STATE_PENDING flags are set. If a buffer
+		/*
+		 * When the driver gets out of buffers during sending of
+		 * fragments and calls ieee80211_stop_queue, the netif
+		 * subqueue is stopped. There is, however, a small window
+		 * in which the PENDING bit is not yet set. If a buffer
 		 * gets available in that window (i.e. driver calls
 		 * ieee80211_wake_queue), we would end up with ieee80211_tx
-		 * called with IEEE80211_LINK_STATE_PENDING. Prevent this by
+		 * called with the PENDING bit still set. Prevent this by
 		 * continuing transmitting here when that situation is
-		 * possible to have happened. */
-		if (!__ieee80211_queue_stopped(local, queue)) {
-			clear_bit(IEEE80211_LINK_STATE_PENDING,
-				  &local->state[queue]);
+		 * possible to have happened.
+		 */
+		if (!__netif_subqueue_stopped(local->mdev, queue)) {
+			clear_bit(queue, local->queues_pending);
 			goto retry;
 		}
 		store->skb = skb;
@@ -1554,7 +1544,8 @@ int ieee80211_subif_start_xmit(struct sk
 	}
 
 	/* receiver and we are QoS enabled, use a QoS type frame */
-	if (sta_flags & WLAN_STA_WME && local->hw.queues >= 4) {
+	if (sta_flags & WLAN_STA_WME &&
+	    ieee80211_num_regular_queues(&local->hw) >= 4) {
 		fc |= IEEE80211_STYPE_QOS_DATA;
 		hdrlen += 2;
 	}
@@ -1700,41 +1691,51 @@ int ieee80211_subif_start_xmit(struct sk
 	return ret;
 }
 
-/* helper functions for pending packets for when queues are stopped */
 
+/*
+ * ieee80211_clear_tx_pending may not be called in a context where
+ * it is possible that it packets could come in again.
+ */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local)
 {
 	int i, j;
 	struct ieee80211_tx_stored_packet *store;
 
-	for (i = 0; i < local->hw.queues; i++) {
-		if (!__ieee80211_queue_pending(local, i))
+	for (i = 0; i < ieee80211_num_regular_queues(&local->hw); i++) {
+		if (!test_bit(i, local->queues_pending))
 			continue;
 		store = &local->pending_packet[i];
 		kfree_skb(store->skb);
 		for (j = 0; j < store->num_extra_frag; j++)
 			kfree_skb(store->extra_frag[j]);
 		kfree(store->extra_frag);
-		clear_bit(IEEE80211_LINK_STATE_PENDING, &local->state[i]);
+		clear_bit(i, local->queues_pending);
 	}
 }
 
+/*
+ * Transmit all pending packets. Called from tasklet, locks master device
+ * TX lock so that no new packets can come in.
+ */
 void ieee80211_tx_pending(unsigned long data)
 {
 	struct ieee80211_local *local = (struct ieee80211_local *)data;
 	struct net_device *dev = local->mdev;
 	struct ieee80211_tx_stored_packet *store;
 	struct ieee80211_tx_data tx;
-	int i, ret, reschedule = 0;
+	int i, ret;
 
 	netif_tx_lock_bh(dev);
-	for (i = 0; i < local->hw.queues; i++) {
-		if (__ieee80211_queue_stopped(local, i))
+	for (i = 0; i < ieee80211_num_regular_queues(&local->hw); i++) {
+		/* Check that this queue is ok */
+		if (__netif_subqueue_stopped(local->mdev, i))
 			continue;
-		if (!__ieee80211_queue_pending(local, i)) {
-			reschedule = 1;
+
+		if (!test_bit(i, local->queues_pending)) {
+			ieee80211_wake_queue(&local->hw, i);
 			continue;
 		}
+
 		store = &local->pending_packet[i];
 		tx.extra_frag = store->extra_frag;
 		tx.num_extra_frag = store->num_extra_frag;
@@ -1747,19 +1748,11 @@ void ieee80211_tx_pending(unsigned long 
 			if (ret == IEEE80211_TX_FRAG_AGAIN)
 				store->skb = NULL;
 		} else {
-			clear_bit(IEEE80211_LINK_STATE_PENDING,
-				  &local->state[i]);
-			reschedule = 1;
+			clear_bit(i, local->queues_pending);
+			ieee80211_wake_queue(&local->hw, i);
 		}
 	}
 	netif_tx_unlock_bh(dev);
-	if (reschedule) {
-		if (!ieee80211_qdisc_installed(dev)) {
-			if (!__ieee80211_queue_stopped(local, 0))
-				netif_wake_queue(dev);
-		} else
-			netif_schedule(dev);
-	}
 }
 
 /* functions for drivers to get certain frames */
--- everything.orig/net/mac80211/util.c	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/util.c	2008-05-16 23:23:48.000000000 +0200
@@ -331,17 +331,15 @@ void ieee80211_wake_queue(struct ieee802
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
+	if (test_bit(queue, local->queues_pending)) {
+		tasklet_schedule(&local->tx_pending_tasklet);
+	} else {
+		if (ieee80211_is_multiqueue(local)) {
+			netif_wake_subqueue(local->mdev, queue);
+		} else {
+			WARN_ON(queue != 0);
+			netif_wake_queue(local->mdev);
+		}
 	}
 }
 EXPORT_SYMBOL(ieee80211_wake_queue);
@@ -350,9 +348,12 @@ void ieee80211_stop_queue(struct ieee802
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	if (!ieee80211_qdisc_installed(local->mdev) && queue == 0)
+	if (ieee80211_is_multiqueue(local)) {
+		netif_stop_subqueue(local->mdev, queue);
+	} else {
+		WARN_ON(queue != 0);
 		netif_stop_queue(local->mdev);
-	set_bit(IEEE80211_LINK_STATE_XOFF, &local->state[queue]);
+	}
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
@@ -360,7 +361,7 @@ void ieee80211_stop_queues(struct ieee80
 {
 	int i;
 
-	for (i = 0; i < hw->queues + hw->ampdu_queues; i++)
+	for (i = 0; i < ieee80211_num_queues(hw); i++)
 		ieee80211_stop_queue(hw, i);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
--- everything.orig/net/mac80211/wme.c	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-05-17 00:36:39.000000000 +0200
@@ -158,7 +158,7 @@ static int wme_qdiscop_enqueue(struct sk
 	u8 tid;
 
 	if (info->flags & IEEE80211_TX_CTL_REQUEUE) {
-		queue = info->queue;
+		queue = skb_get_queue_mapping(skb);
 		rcu_read_lock();
 		sta = sta_info_get(local, hdr->addr1);
 		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
@@ -219,7 +219,7 @@ static int wme_qdiscop_enqueue(struct sk
 			err = NET_XMIT_DROP;
 	} else {
 		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
-		info->queue = (unsigned int) queue;
+		skb_set_queue_mapping(skb, queue);
 		qdisc = q->queues[queue];
 		err = qdisc->enqueue(skb, qdisc);
 		if (err == NET_XMIT_SUCCESS) {
@@ -240,12 +240,11 @@ static int wme_qdiscop_enqueue(struct sk
 static int wme_qdiscop_requeue(struct sk_buff *skb, struct Qdisc* qd)
 {
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct Qdisc *qdisc;
 	int err;
 
 	/* we recorded which queue to use earlier! */
-	qdisc = q->queues[info->queue];
+	qdisc = q->queues[skb_get_queue_mapping(skb)];
 
 	if ((err = qdisc->ops->requeue(skb, qdisc)) == 0) {
 		qd->q.qlen++;
@@ -269,11 +268,8 @@ static struct sk_buff *wme_qdiscop_deque
 	/* check all the h/w queues in numeric/priority order */
 	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		/* see if there is room in this hardware queue */
-		if ((test_bit(IEEE80211_LINK_STATE_XOFF,
-				&local->state[queue])) ||
-		    (test_bit(IEEE80211_LINK_STATE_PENDING,
-				&local->state[queue])) ||
-			 (!test_bit(queue, q->qdisc_pool)))
+		if (__netif_subqueue_stopped(local->mdev, queue) ||
+		    !test_bit(queue, q->qdisc_pool))
 			continue;
 
 		/* there is space - try and get a frame */
--- everything.orig/net/mac80211/wme.h	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/wme.h	2008-05-16 23:02:42.000000000 +0200
@@ -31,7 +31,7 @@ static inline int WLAN_FC_IS_QOS_DATA(u1
 	return (fc & 0x8C) == 0x88;
 }
 
-#ifdef CONFIG_NET_SCHED
+#ifdef CONFIG_MAC80211_QOS
 void ieee80211_install_qdisc(struct net_device *dev);
 int ieee80211_qdisc_installed(struct net_device *dev);
 int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
--- everything.orig/drivers/net/wireless/b43/dma.c	2008-05-16 23:02:20.000000000 +0200
+++ everything/drivers/net/wireless/b43/dma.c	2008-05-16 23:02:42.000000000 +0200
@@ -1297,7 +1297,8 @@ int b43_dma_tx(struct b43_wldev *dev, st
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	} else {
 		/* Decide by priority where to put this frame. */
-		ring = select_ring_by_priority(dev, info->queue);
+		ring = select_ring_by_priority(
+			dev, skb_get_queue_mapping(skb));
 	}
 
 	spin_lock_irqsave(&ring->lock, flags);
@@ -1315,7 +1316,7 @@ int b43_dma_tx(struct b43_wldev *dev, st
 	/* Assign the queue number to the ring (if not already done before)
 	 * so TX status handling can use it. The queue to ring mapping is
 	 * static, so we don't need to store it per frame. */
-	ring->queue_prio = info->queue;
+	ring->queue_prio = skb_get_queue_mapping(skb);
 
 	err = dma_tx_fragment(ring, skb);
 	if (unlikely(err == -ENOKEY)) {
@@ -1333,7 +1334,7 @@ int b43_dma_tx(struct b43_wldev *dev, st
 	if ((free_slots(ring) < SLOTS_PER_PACKET) ||
 	    should_inject_overflow(ring)) {
 		/* This TX ring is full. */
-		ieee80211_stop_queue(dev->wl->hw, info->queue);
+		ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb));
 		ring->stopped = 1;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
--- everything.orig/drivers/net/wireless/b43/pio.c	2008-05-16 23:02:20.000000000 +0200
+++ everything/drivers/net/wireless/b43/pio.c	2008-05-16 23:02:42.000000000 +0200
@@ -509,7 +509,7 @@ int b43_pio_tx(struct b43_wldev *dev, st
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	} else {
 		/* Decide by priority where to put this frame. */
-		q = select_queue_by_priority(dev, info->queue);
+		q = select_queue_by_priority(dev, skb_get_queue_mapping(skb));
 	}
 
 	spin_lock_irqsave(&q->lock, flags);
@@ -532,7 +532,7 @@ int b43_pio_tx(struct b43_wldev *dev, st
 	if (total_len > (q->buffer_size - q->buffer_used)) {
 		/* Not enough memory on the queue. */
 		err = -EBUSY;
-		ieee80211_stop_queue(dev->wl->hw, info->queue);
+		ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb));
 		q->stopped = 1;
 		goto out_unlock;
 	}
@@ -540,7 +540,7 @@ int b43_pio_tx(struct b43_wldev *dev, st
 	/* Assign the queue number to the ring (if not already done before)
 	 * so TX status handling can use it. The mac80211-queue to b43-queue
 	 * mapping is static, so we don't need to store it per frame. */
-	q->queue_prio = info->queue;
+	q->queue_prio = skb_get_queue_mapping(skb);
 
 	err = pio_tx_frame(q, skb);
 	if (unlikely(err == -ENOKEY)) {
@@ -560,7 +560,7 @@ int b43_pio_tx(struct b43_wldev *dev, st
 	if (((q->buffer_size - q->buffer_used) < roundup(2 + 2 + 6, 4)) ||
 	    (q->free_packet_slots == 0)) {
 		/* The queue is full. */
-		ieee80211_stop_queue(dev->wl->hw, info->queue);
+		ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb));
 		q->stopped = 1;
 	}
 
--- everything.orig/drivers/net/wireless/b43legacy/dma.c	2008-05-16 23:02:20.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/dma.c	2008-05-17 00:06:04.000000000 +0200
@@ -1325,11 +1325,10 @@ int b43legacy_dma_tx(struct b43legacy_wl
 		     struct sk_buff *skb)
 {
 	struct b43legacy_dmaring *ring;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int err = 0;
 	unsigned long flags;
 
-	ring = priority_to_txring(dev, info->queue);
+	ring = priority_to_txring(dev, skb_get_queue_mapping(skb));
 	spin_lock_irqsave(&ring->lock, flags);
 	B43legacy_WARN_ON(!ring->tx);
 	if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-05-16 23:02:20.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-05-16 23:02:42.000000000 +0200
@@ -102,7 +102,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
-	enum data_queue_qid qid = mac80211_queue_to_qid(tx_info->queue);
+	enum data_queue_qid qid = skb_get_queue_mapping(skb);
 	struct data_queue *queue;
 	u16 frame_control;
 
@@ -149,23 +149,23 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
 			       IEEE80211_TX_CTL_USE_CTS_PROTECT)) &&
 	    !rt2x00dev->ops->hw->set_rts_threshold) {
 		if (rt2x00queue_available(queue) <= 1) {
-			ieee80211_stop_queue(rt2x00dev->hw, tx_info->queue);
+			ieee80211_stop_queue(rt2x00dev->hw, qid);
 			return NETDEV_TX_BUSY;
 		}
 
 		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb)) {
-			ieee80211_stop_queue(rt2x00dev->hw, tx_info->queue);
+			ieee80211_stop_queue(rt2x00dev->hw, qid);
 			return NETDEV_TX_BUSY;
 		}
 	}
 
 	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb)) {
-		ieee80211_stop_queue(rt2x00dev->hw, tx_info->queue);
+		ieee80211_stop_queue(rt2x00dev->hw, qid);
 		return NETDEV_TX_BUSY;
 	}
 
 	if (rt2x00queue_full(queue))
-		ieee80211_stop_queue(rt2x00dev->hw, tx_info->queue);
+		ieee80211_stop_queue(rt2x00dev->hw, qid);
 
 	if (rt2x00dev->ops->lib->kick_tx_queue)
 		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, qid);
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00queue.h	2008-05-16 23:02:20.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00queue.h	2008-05-16 23:02:42.000000000 +0200
@@ -80,19 +80,6 @@ enum data_queue_qid {
 };
 
 /**
- * mac80211_queue_to_qid - Convert mac80211 queue to rt2x00 qid
- * @queue: mac80211 queue.
- */
-static inline enum data_queue_qid mac80211_queue_to_qid(unsigned int queue)
-{
-	/* Regular TX queues are mapped directly */
-	if (queue < 4)
-		return queue;
-	WARN_ON(1);
-	return QID_OTHER;
-}
-
-/**
  * enum skb_frame_desc_flags: Flags for &struct skb_frame_desc
  *
  * @FRAME_DESC_DRIVER_GENERATED: Frame was generated inside driver
--- everything.orig/include/net/mac80211.h	2008-05-16 23:02:19.000000000 +0200
+++ everything/include/net/mac80211.h	2008-05-16 23:02:42.000000000 +0200
@@ -293,7 +293,7 @@ struct ieee80211_tx_info {
 	s8 tx_rate_idx;
 	u8 antenna_sel_tx;
 
-	u8 queue; /* use skb_queue_mapping soon */
+	/* 1 byte hole */
 
 	union {
 		struct {
@@ -802,6 +802,24 @@ static inline void SET_IEEE80211_PERM_AD
 	memcpy(hw->wiphy->perm_addr, addr, ETH_ALEN);
 }
 
+static inline int ieee80211_num_regular_queues(struct ieee80211_hw *hw)
+{
+#ifdef CONFIG_MAC80211_QOS
+	return hw->queues;
+#else
+	return 1;
+#endif
+}
+
+static inline int ieee80211_num_queues(struct ieee80211_hw *hw)
+{
+#ifdef CONFIG_MAC80211_QOS
+	return hw->queues + hw->ampdu_queues;
+#else
+	return 1;
+#endif
+}
+
 static inline struct ieee80211_rate *
 ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
 		      const struct ieee80211_tx_info *c)
--- everything.orig/net/mac80211/ieee80211_i.h	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-05-16 23:23:29.000000000 +0200
@@ -595,7 +595,7 @@ struct ieee80211_local {
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
-	unsigned long state[IEEE80211_MAX_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
+	unsigned long queues_pending[BITS_TO_LONGS(IEEE80211_MAX_QUEUES)];
 	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
@@ -759,6 +759,15 @@ struct ieee80211_local {
 #endif
 };
 
+static inline int ieee80211_is_multiqueue(struct ieee80211_local *local)
+{
+#ifdef CONFIG_MAC80211_QOS
+	return netif_is_multiqueue(local->mdev);
+#else
+	return 0;
+#endif
+}
+
 /* this struct represents 802.11n's RA/TID combination */
 struct ieee80211_ra_tid {
 	u8 ra[ETH_ALEN];
@@ -828,11 +837,6 @@ static inline struct ieee80211_hw *local
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
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-05-16 23:02:20.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-05-16 23:02:42.000000000 +0200
@@ -696,7 +696,7 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_tfd_frame *tfd;
 	u32 *control_flags;
-	int txq_id = info->queue;
+	int txq_id = skb_get_queue_mapping(skb);
 	struct iwl_tx_queue *txq = NULL;
 	struct iwl_queue *q = NULL;
 	dma_addr_t phys_addr;
@@ -917,7 +917,7 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
-		ieee80211_stop_queue(priv->hw, info->queue);
+		ieee80211_stop_queue(priv->hw, skb_get_queue_mapping(skb));
 	}
 
 	return 0;
--- everything.orig/net/mac80211/iface.c	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-05-16 23:02:42.000000000 +0200
@@ -175,7 +175,7 @@ void ieee80211_if_set_type(struct net_de
 		ifsta->flags |= IEEE80211_STA_CREATE_IBSS |
 			IEEE80211_STA_AUTO_BSSID_SEL |
 			IEEE80211_STA_AUTO_CHANNEL_SEL;
-		if (sdata->local->hw.queues >= 4)
+		if (ieee80211_num_regular_queues(&sdata->local->hw) >= 4)
 			ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
 
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
--- everything.orig/net/mac80211/sta_info.c	2008-05-16 23:02:19.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-05-16 23:02:42.000000000 +0200
@@ -255,7 +255,7 @@ struct sta_info *sta_info_alloc(struct i
 		 * sta_rx_agg_session_timer_expired for useage */
 		sta->timer_to_tid[i] = i;
 		/* tid to tx queue: initialize according to HW (0 is valid) */
-		sta->tid_to_tx_q[i] = local->hw.queues + local->hw.ampdu_queues;
+		sta->tid_to_tx_q[i] = ieee80211_num_queues(&local->hw);
 		/* rx */
 		sta->ampdu_mlme.tid_state_rx[i] = HT_AGG_STATE_IDLE;
 		sta->ampdu_mlme.tid_rx[i] = NULL;

-- 

