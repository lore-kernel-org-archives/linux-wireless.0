Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZFRLcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 07:32:04 -0400
Subject: [PATCH] mac80211: cooperate more with network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 13:31:32 +0200
Message-Id: <1245324692.13790.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are still two places in mac80211 that hardcode
the initial net namespace (init_net). One of them is
mandated by cfg80211 and will be removed by a separate
patch, the other one is used for finding the network
device of a pending packet via its ifindex.

Remove the latter use by keeping track of the device
pointer itself, via the vif pointer, and avoid it
going stale by dropping pending frames for a given
interface when the interface is removed.

To keep track of the vif pointer for the correct
interface, change the info->control.vif pointer's
internal use to always be the correct vif, and only
move it to the vif the driver expects (or NULL for
monitor interfaces and injected packets) right before
giving the packet to the driver.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/iface.c |   16 ++++++++++
 net/mac80211/rx.c    |    2 -
 net/mac80211/tx.c    |   75 ++++++++++++++++++++-------------------------------
 3 files changed, 46 insertions(+), 47 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2009-06-18 03:47:42.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-06-18 03:51:25.000000000 +0200
@@ -338,7 +338,10 @@ static int ieee80211_stop(struct net_dev
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
+	unsigned long flags;
+	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
+	int i;
 
 	/*
 	 * Stop TX on this interface first.
@@ -571,6 +574,18 @@ static int ieee80211_stop(struct net_dev
 	if (hw_reconf_flags)
 		ieee80211_hw_config(local, hw_reconf_flags);
 
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
+		skb_queue_walk_safe(&local->pending[i], skb, tmp) {
+			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+			if (info->control.vif == &sdata->vif) {
+				__skb_unlink(skb, &local->pending[i]);
+				dev_kfree_skb_irq(skb);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+
 	return 0;
 }
 
@@ -813,7 +828,6 @@ int ieee80211_if_add(struct ieee80211_lo
 
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
-	ndev->features |= NETIF_F_NETNS_LOCAL;
 
 	/* don't use IEEE80211_DEV_TO_SUB_IF because it checks too much */
 	sdata = netdev_priv(ndev);
--- wireless-testing.orig/net/mac80211/tx.c	2009-06-18 03:47:42.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-06-18 03:52:55.000000000 +0200
@@ -400,6 +400,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 			sta_info_set_tim_bit(sta);
 
 		info->control.jiffies = jiffies;
+		info->control.vif = &tx->sdata->vif;
 		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 		skb_queue_tail(&sta->ps_tx_buf, tx->skb);
 		return TX_QUEUED;
@@ -676,7 +677,7 @@ ieee80211_tx_h_sequence(struct ieee80211
 	 * number, if we have no matching interface then we
 	 * neither assign one ourselves nor ask the driver to.
 	 */
-	if (unlikely(!info->control.vif))
+	if (unlikely(info->control.vif->type == NL80211_IFTYPE_MONITOR))
 		return TX_CONTINUE;
 
 	if (unlikely(ieee80211_is_ctl(hdr->frame_control)))
@@ -1072,6 +1073,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 		} else if (*state != HT_AGG_STATE_IDLE) {
 			/* in progress */
 			queued = true;
+			info->control.vif = &sdata->vif;
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			__skb_queue_tail(&tid_tx->pending, skb);
 		}
@@ -1123,6 +1125,7 @@ static int __ieee80211_tx(struct ieee802
 {
 	struct sk_buff *skb = *skbp, *next;
 	struct ieee80211_tx_info *info;
+	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
 	int ret, len;
 	bool fragm = false;
@@ -1147,7 +1150,24 @@ static int __ieee80211_tx(struct ieee802
 
 		next = skb->next;
 		len = skb->len;
+
+		sdata = vif_to_sdata(info->control.vif);
+
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_MONITOR:
+			info->control.vif = NULL;
+			break;
+		case NL80211_IFTYPE_AP_VLAN:
+			info->control.vif = &container_of(sdata->bss,
+				struct ieee80211_sub_if_data, u.ap)->vif;
+			break;
+		default:
+			/* keep */
+			break;
+		}
+
 		ret = drv_tx(local, skb);
+		info->control.vif = &sdata->vif;
 		if (WARN_ON(ret != NETDEV_TX_OK && skb->len != len)) {
 			dev_kfree_skb(skb);
 			ret = NETDEV_TX_OK;
@@ -1366,11 +1386,6 @@ static void ieee80211_xmit(struct ieee80
 	struct ieee80211_sub_if_data *tmp_sdata;
 	int headroom;
 	bool may_encrypt;
-	enum {
-		NOT_MONITOR,
-		FOUND_SDATA,
-		UNKNOWN_ADDRESS,
-	} monitor_iface = NOT_MONITOR;
 
 	dev_hold(sdata->dev);
 
@@ -1407,7 +1422,6 @@ static void ieee80211_xmit(struct ieee80
 		u16 len_rthdr;
 
 		info->flags |= IEEE80211_TX_CTL_INJECTED;
-		monitor_iface = UNKNOWN_ADDRESS;
 
 		len_rthdr = ieee80211_get_radiotap_len(skb->data);
 		hdr = (struct ieee80211_hdr *)skb->data + len_rthdr;
@@ -1437,7 +1451,6 @@ static void ieee80211_xmit(struct ieee80
 					dev_hold(tmp_sdata->dev);
 					dev_put(sdata->dev);
 					sdata = tmp_sdata;
-					monitor_iface = FOUND_SDATA;
 					break;
 				}
 			}
@@ -1459,13 +1472,7 @@ static void ieee80211_xmit(struct ieee80
 		return;
 	}
 
-	tmp_sdata = sdata;
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		tmp_sdata = container_of(sdata->bss,
-					 struct ieee80211_sub_if_data,
-					 u.ap);
-	if (likely(monitor_iface != UNKNOWN_ADDRESS))
-		info->control.vif = &tmp_sdata->vif;
+	info->control.vif = &sdata->vif;
 
 	ieee80211_select_queue(local, skb);
 	ieee80211_tx(sdata, skb, false);
@@ -1517,9 +1524,6 @@ int ieee80211_monitor_start_xmit(struct 
 	if (unlikely(skb->len < len_rthdr))
 		goto fail; /* skb too short for claimed rt header extent */
 
-	/* needed because we set skb device to master */
-	skb->iif = dev->ifindex;
-
 	/*
 	 * fix up the pointers accounting for the radiotap
 	 * header still being in there.  We are being given
@@ -1793,8 +1797,6 @@ int ieee80211_subif_start_xmit(struct sk
 	nh_pos += hdrlen;
 	h_pos += hdrlen;
 
-	skb->iif = dev->ifindex;
-
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
 
@@ -1839,32 +1841,13 @@ static bool ieee80211_tx_pending_skb(str
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr;
-	struct net_device *dev;
 	int ret;
 	bool result = true;
 
-	/* does interface still exist? */
-	dev = dev_get_by_index(&init_net, skb->iif);
-	if (!dev) {
-		dev_kfree_skb(skb);
-		return true;
-	}
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data,
-				     u.ap);
-
-	if (unlikely(info->control.vif && info->control.vif != &sdata->vif)) {
-		dev_kfree_skb(skb);
-		result = true;
-		goto out;
-	}
+	sdata = vif_to_sdata(info->control.vif);
 
 	if (info->flags & IEEE80211_TX_INTFL_NEED_TXPROCESSING) {
-		/* do not use sdata, it may have been changed above */
-		ieee80211_tx(IEEE80211_DEV_TO_SUB_IF(dev), skb, true);
+		ieee80211_tx(sdata, skb, true);
 	} else {
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(local, hdr->addr1);
@@ -1874,9 +1857,6 @@ static bool ieee80211_tx_pending_skb(str
 			result = false;
 	}
 
- out:
-	dev_put(dev);
-
 	return result;
 }
 
@@ -1904,10 +1884,16 @@ void ieee80211_tx_pending(unsigned long 
 
 		while (!skb_queue_empty(&local->pending[i])) {
 			struct sk_buff *skb = __skb_dequeue(&local->pending[i]);
+			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+			struct ieee80211_sub_if_data *sdata;
+
+			sdata = vif_to_sdata(info->control.vif);
+			dev_hold(sdata->dev);
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 						flags);
 
 			txok = ieee80211_tx_pending_skb(local, skb);
+			dev_put(sdata->dev);
 			if (!txok)
 				__skb_queue_head(&local->pending[i], skb);
 			spin_lock_irqsave(&local->queue_stop_reason_lock,
@@ -2217,7 +2203,6 @@ void ieee80211_tx_skb(struct ieee80211_s
 	skb_set_network_header(skb, 0);
 	skb_set_transport_header(skb, 0);
 
-	skb->iif = sdata->dev->ifindex;
 	if (!encrypt)
 		info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
--- wireless-testing.orig/net/mac80211/rx.c	2009-06-18 03:47:42.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-06-18 03:51:25.000000000 +0200
@@ -1545,7 +1545,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 			info = IEEE80211_SKB_CB(fwd_skb);
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
-			fwd_skb->iif = rx->dev->ifindex;
+			info->control.vif = &rx->sdata->vif;
 			ieee80211_select_queue(local, fwd_skb);
 			ieee80211_add_pending_skb(local, fwd_skb);
 		}


