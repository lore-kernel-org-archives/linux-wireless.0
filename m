Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55199 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933365AbbDVPLu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 11:11:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use per-CPU TX/RX statistics
Date: Wed, 22 Apr 2015 17:11:47 +0200
Message-Id: <1429715507-4978-1-git-send-email-johannes@sipsolutions.net> (sfid-20150422_171212_827861_135778A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This isn't all that relevant for RX right now, but TX can be concurrent
due to multi-queue and the accounting is therefore broken.

Use the standard per-CPU statistics to avoid this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/rx.c    | 21 ++++++++++++++-------
 net/mac80211/tx.c    | 16 ++++++++++++----
 3 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f8ed1f72d1b7..6c1a0d9da3ea 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1146,6 +1146,35 @@ static int ieee80211_netdev_set_features(struct net_device *dev,
 	return 0;
 }
 
+static struct rtnl_link_stats64 *
+ieee80211_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		const struct pcpu_sw_netstats *tstats;
+		u64 rx_packets, rx_bytes, tx_packets, tx_bytes;
+		unsigned int start;
+
+		tstats = per_cpu_ptr(dev->tstats, i);
+
+		do {
+			start = u64_stats_fetch_begin_irq(&tstats->syncp);
+			rx_packets = tstats->rx_packets;
+			tx_packets = tstats->tx_packets;
+			rx_bytes = tstats->rx_bytes;
+			tx_bytes = tstats->tx_bytes;
+		} while (u64_stats_fetch_retry_irq(&tstats->syncp, start));
+
+		stats->rx_packets += rx_packets;
+		stats->tx_packets += tx_packets;
+		stats->rx_bytes   += rx_bytes;
+		stats->tx_bytes   += tx_bytes;
+	}
+
+	return stats;
+}
+
 static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_open		= ieee80211_open,
 	.ndo_stop		= ieee80211_stop,
@@ -1156,6 +1185,7 @@ static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_set_mac_address 	= ieee80211_change_mac,
 	.ndo_select_queue	= ieee80211_netdev_select_queue,
 	.ndo_set_features	= ieee80211_netdev_set_features,
+	.ndo_get_stats64	= ieee80211_get_stats64,
 };
 
 static u16 ieee80211_monitor_select_queue(struct net_device *dev,
@@ -1189,14 +1219,21 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
 	.ndo_change_mtu 	= ieee80211_change_mtu,
 	.ndo_set_mac_address 	= ieee80211_change_mac,
 	.ndo_select_queue	= ieee80211_monitor_select_queue,
+	.ndo_get_stats64	= ieee80211_get_stats64,
 };
 
+static void ieee80211_if_free(struct net_device *dev)
+{
+	free_percpu(dev->tstats);
+	free_netdev(dev);
+}
+
 static void ieee80211_if_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 	dev->netdev_ops = &ieee80211_dataif_ops;
-	dev->destructor = free_netdev;
+	dev->destructor = ieee80211_if_free;
 }
 
 static void ieee80211_iface_work(struct work_struct *work)
@@ -1737,6 +1774,12 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			return -ENOMEM;
 		dev_net_set(ndev, wiphy_net(local->hw.wiphy));
 
+		ndev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+		if (!ndev->tstats) {
+			free_netdev(ndev);
+			return -ENOMEM;
+		}
+
 		ndev->needed_headroom = local->tx_headroom +
 					4*6 /* four MAC addresses */
 					+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6e3b564b6dea..570487fbaaf0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -32,6 +32,16 @@
 #include "wme.h"
 #include "rate.h"
 
+static inline void ieee80211_rx_stats(struct net_device *dev, u32 len)
+{
+	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
+
+	u64_stats_update_begin(&tstats->syncp);
+	tstats->rx_packets++;
+	tstats->rx_bytes += len;
+	u64_stats_update_end(&tstats->syncp);
+}
+
 /*
  * monitor mode reception
  *
@@ -529,8 +539,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		}
 
 		prev_dev = sdata->dev;
-		sdata->dev->stats.rx_packets++;
-		sdata->dev->stats.rx_bytes += skb->len;
+		ieee80211_rx_stats(sdata->dev, skb->len);
 	}
 
 	if (prev_dev) {
@@ -2058,12 +2067,11 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	struct sta_info *dsta;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += rx->skb->len;
-
 	skb = rx->skb;
 	xmit_skb = NULL;
 
+	ieee80211_rx_stats(dev, skb->len);
+
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
@@ -3078,8 +3086,7 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 		}
 
 		prev_dev = sdata->dev;
-		sdata->dev->stats.rx_packets++;
-		sdata->dev->stats.rx_bytes += skb->len;
+		ieee80211_rx_stats(sdata->dev, skb->len);
 	}
 
 	if (prev_dev) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 83e3261dbf67..745fdf5c2722 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -37,6 +37,16 @@
 
 /* misc utils */
 
+static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
+{
+	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
+
+	u64_stats_update_begin(&tstats->syncp);
+	tstats->tx_packets++;
+	tstats->tx_bytes += len;
+	u64_stats_update_end(&tstats->syncp);
+}
+
 static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 				 struct sk_buff *skb, int group_addr,
 				 int next_frag_len)
@@ -2727,8 +2737,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 			return true;
 	}
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len + extra_head;
+	ieee80211_tx_stats(dev, skb->len + extra_head);
 
 	/* will not be crypto-handled beyond what we do here, so use false
 	 * as the may-encrypt argument for the resize to not account for
@@ -2909,8 +2918,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		if (IS_ERR(skb))
 			goto out;
 
-		dev->stats.tx_packets++;
-		dev->stats.tx_bytes += skb->len;
+		ieee80211_tx_stats(dev, skb->len);
 
 		ieee80211_xmit(sdata, sta, skb);
 	}
-- 
2.1.4

