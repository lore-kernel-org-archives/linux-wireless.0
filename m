Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61525 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbECVnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 17:43:05 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] mac80211: add pcpu_sw_netstats field in ieee80211_sub_if_data
Date: Sun, 3 May 2015 23:43:01 +0200
Message-ID: <1430689381-2339-1-git-send-email-arend@broadcom.com> (sfid-20150503_234309_231089_3192769E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add field in struct ieee80211_sub_if_data pointing to per-cpu
net statistics. Using this instead of field in struct netdevice
makes it easier to backport the functionality.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/iface.c       | 21 +++++++++++++--------
 net/mac80211/rx.c          | 11 ++++++-----
 net/mac80211/tx.c          |  9 +++++----
 4 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e9f36f7..e231932 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -833,6 +833,7 @@ struct ieee80211_sub_if_data {
 	struct delayed_work dec_tailroom_needed_wk;
 
 	struct net_device *dev;
+	struct pcpu_sw_netstats *tstats;
 	struct ieee80211_local *local;
 
 	unsigned int flags;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index dc2d713..3f62dbb 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1097,6 +1097,7 @@ static u16 ieee80211_netdev_select_queue(struct net_device *dev,
 static struct rtnl_link_stats64 *
 ieee80211_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int i;
 
 	for_each_possible_cpu(i) {
@@ -1104,7 +1105,7 @@ ieee80211_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		u64 rx_packets, rx_bytes, tx_packets, tx_bytes;
 		unsigned int start;
 
-		tstats = per_cpu_ptr(dev->tstats, i);
+		tstats = per_cpu_ptr(sdata->tstats, i);
 
 		do {
 			start = u64_stats_fetch_begin_irq(&tstats->syncp);
@@ -1171,7 +1172,10 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
 
 static void ieee80211_if_free(struct net_device *dev)
 {
-	free_percpu(dev->tstats);
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = netdev_priv(dev);
+	free_percpu(sdata->tstats);
 	free_netdev(dev);
 }
 
@@ -1721,12 +1725,6 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			return -ENOMEM;
 		dev_net_set(ndev, wiphy_net(local->hw.wiphy));
 
-		ndev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-		if (!ndev->tstats) {
-			free_netdev(ndev);
-			return -ENOMEM;
-		}
-
 		ndev->needed_headroom = local->tx_headroom +
 					4*6 /* four MAC addresses */
 					+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
@@ -1752,6 +1750,13 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		/* don't use IEEE80211_DEV_TO_SUB_IF -- it checks too much */
 		sdata = netdev_priv(ndev);
 		ndev->ieee80211_ptr = &sdata->wdev;
+
+                sdata->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+                if (!sdata->tstats) {
+                        free_netdev(ndev);
+                        return -ENOMEM;
+                }
+
 		memcpy(sdata->vif.addr, ndev->dev_addr, ETH_ALEN);
 		memcpy(sdata->name, ndev->name, IFNAMSIZ);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e082535..d1578a2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -32,9 +32,10 @@
 #include "wme.h"
 #include "rate.h"
 
-static inline void ieee80211_rx_stats(struct net_device *dev, u32 len)
+static inline void ieee80211_rx_stats(struct ieee80211_sub_if_data *sdata,
+				      u32 len)
 {
-	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
+	struct pcpu_sw_netstats *tstats = this_cpu_ptr(sdata->tstats);
 
 	u64_stats_update_begin(&tstats->syncp);
 	tstats->rx_packets++;
@@ -539,7 +540,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		}
 
 		prev_dev = sdata->dev;
-		ieee80211_rx_stats(sdata->dev, skb->len);
+		ieee80211_rx_stats(sdata, skb->len);
 	}
 
 	if (prev_dev) {
@@ -2048,7 +2049,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	skb = rx->skb;
 	xmit_skb = NULL;
 
-	ieee80211_rx_stats(dev, skb->len);
+	ieee80211_rx_stats(sdata, skb->len);
 
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
@@ -3061,7 +3062,7 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 		}
 
 		prev_dev = sdata->dev;
-		ieee80211_rx_stats(sdata->dev, skb->len);
+		ieee80211_rx_stats(sdata, skb->len);
 	}
 
 	if (prev_dev) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 745fdf5..bca48e4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -37,9 +37,10 @@
 
 /* misc utils */
 
-static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
+static inline void ieee80211_tx_stats(struct ieee80211_sub_if_data *sdata,
+				      u32 len)
 {
-	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
+	struct pcpu_sw_netstats *tstats = this_cpu_ptr(sdata->tstats);
 
 	u64_stats_update_begin(&tstats->syncp);
 	tstats->tx_packets++;
@@ -2737,7 +2738,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 			return true;
 	}
 
-	ieee80211_tx_stats(dev, skb->len + extra_head);
+	ieee80211_tx_stats(sdata, skb->len + extra_head);
 
 	/* will not be crypto-handled beyond what we do here, so use false
 	 * as the may-encrypt argument for the resize to not account for
@@ -2918,7 +2919,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		if (IS_ERR(skb))
 			goto out;
 
-		ieee80211_tx_stats(dev, skb->len);
+		ieee80211_tx_stats(sdata, skb->len);
 
 		ieee80211_xmit(sdata, sta, skb);
 	}
-- 
1.9.1

