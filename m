Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:40537 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaKIQua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:30 -0500
Received: by mail-wg0-f43.google.com with SMTP id y10so7215935wgg.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:29 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/16] mac80211: factor out 802.11 header building code
Date: Sun,  9 Nov 2014 18:50:10 +0200
Message-Id: <1415551822-20121-4-git-send-email-arik@wizery.com> (sfid-20141109_175040_142261_C2D1CFBB)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Factor out the 802.11 header building code from the xmit function
to be able to use it separately in a later commit.

While at it, fix up some documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/tx.c | 142 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 91 insertions(+), 51 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c4a5494..f67131a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1784,24 +1784,26 @@ static void ieee80211_tx_latency_start_msrmnt(struct ieee80211_local *local,
 }
 
 /**
- * __ieee80211_subif_start_xmit - netif start_xmit function for Ethernet-type
- * subinterfaces (wlan#, WDS, and VLAN interfaces)
- * @skb: packet to be sent
- * @dev: incoming interface
+ * ieee80211_build_hdr - build 802.11 header in the given frame
+ * @sdata: virtual interface to build the header for
+ * @skb: the skb to build the header in
  * @info_flags: skb flags to set
  *
- * On failure skb will be freed.
+ * This function takes the skb with 802.3 header and reformats the header to
+ * the appropriate IEEE 802.11 header based on which interface the packet is
+ * being transmitted on.
+ *
+ * Note that this function also takes care of the TX status request and
+ * potential unsharing of the SKB - this needs to be interleaved with the
+ * header building.
+ *
+ * The function requires the read-side RCU lock held
  *
- * This function takes in an Ethernet header and encapsulates it with suitable
- * IEEE 802.11 header based on which interface the packet is coming in. The
- * encapsulated packet will then be passed to master interface, wlan#.11, for
- * transmission (through low-level driver).
+ * Returns: the (possibly reallocated) skb or an ERR_PTR() code
  */
-void __ieee80211_subif_start_xmit(struct sk_buff *skb,
-				  struct net_device *dev,
-				  u32 info_flags)
+static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
+					   struct sk_buff *skb, u32 info_flags)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
 	int head_need;
@@ -1821,20 +1823,13 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
 	enum ieee80211_band band;
-
-	if (unlikely(skb->len < ETH_HLEN))
-		goto fail;
+	int ret;
 
 	/* convert Ethernet header to proper 802.11 header (based on
 	 * operation mode) */
 	ethertype = (skb->data[12] << 8) | skb->data[13];
 	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA);
 
-	rcu_read_lock();
-
-	/* Measure frame arrival for Tx latency statistics calculation */
-	ieee80211_tx_latency_start_msrmnt(local, skb);
-
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		sta = rcu_dereference(sdata->u.vlan.sta);
@@ -1852,8 +1847,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		ap_sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
 					u.ap);
 		chanctx_conf = rcu_dereference(ap_sdata->vif.chanctx_conf);
-		if (!chanctx_conf)
-			goto fail_rcu;
+		if (!chanctx_conf) {
+			ret = -ENOTCONN;
+			goto free;
+		}
 		band = chanctx_conf->def.chan->band;
 		if (sta)
 			break;
@@ -1861,8 +1858,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	case NL80211_IFTYPE_AP:
 		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-		if (!chanctx_conf)
-			goto fail_rcu;
+		if (!chanctx_conf) {
+			ret = -ENOTCONN;
+			goto free;
+		}
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -1949,8 +1948,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 		}
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-		if (!chanctx_conf)
-			goto fail_rcu;
+		if (!chanctx_conf) {
+			ret = -ENOTCONN;
+			goto free;
+		}
 		band = chanctx_conf->def.chan->band;
 		break;
 #endif
@@ -1980,8 +1981,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		 * of a link teardown after a TDLS sta is removed due to being
 		 * unreachable.
 		 */
-		if (tdls_peer && !tdls_auth && !tdls_setup_frame)
-			goto fail_rcu;
+		if (tdls_peer && !tdls_auth && !tdls_setup_frame) {
+			ret = -EINVAL;
+			goto free;
+		}
 
 		/* send direct packets to authorized TDLS peers */
 		if (tdls_peer && tdls_auth) {
@@ -2009,8 +2012,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 			hdrlen = 24;
 		}
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-		if (!chanctx_conf)
-			goto fail_rcu;
+		if (!chanctx_conf) {
+			ret = -ENOTCONN;
+			goto free;
+		}
 		band = chanctx_conf->def.chan->band;
 		break;
 	case NL80211_IFTYPE_OCB:
@@ -2020,8 +2025,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		eth_broadcast_addr(hdr.addr3);
 		hdrlen = 24;
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-		if (!chanctx_conf)
-			goto fail_rcu;
+		if (!chanctx_conf) {
+			ret = -ENOTCONN;
+			goto free;
+		}
 		band = chanctx_conf->def.chan->band;
 		break;
 	case NL80211_IFTYPE_ADHOC:
@@ -2031,12 +2038,15 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		memcpy(hdr.addr3, sdata->u.ibss.bssid, ETH_ALEN);
 		hdrlen = 24;
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-		if (!chanctx_conf)
-			goto fail_rcu;
+		if (!chanctx_conf) {
+			ret = -ENOTCONN;
+			goto free;
+		}
 		band = chanctx_conf->def.chan->band;
 		break;
 	default:
-		goto fail_rcu;
+		ret = -EINVAL;
+		goto free;
 	}
 
 	/*
@@ -2079,7 +2089,8 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 		I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);
 
-		goto fail_rcu;
+		ret = -EPERM;
+		goto free;
 	}
 
 	if (unlikely(!multicast && skb->sk &&
@@ -2116,8 +2127,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		skb = skb_clone(skb, GFP_ATOMIC);
 		kfree_skb(tmp_skb);
 
-		if (!skb)
-			goto fail_rcu;
+		if (!skb) {
+			ret = -ENOMEM;
+			goto free;
+		}
 	}
 
 	hdr.frame_control = fc;
@@ -2166,7 +2179,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		if (ieee80211_skb_resize(sdata, skb, head_need, true)) {
 			ieee80211_free_txskb(&local->hw, skb);
 			skb = NULL;
-			goto fail_rcu;
+			return ERR_PTR(-ENOMEM);
 		}
 	}
 
@@ -2200,9 +2213,6 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	nh_pos += hdrlen;
 	h_pos += hdrlen;
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
-
 	/* Update skb pointers to various headers since this modified frame
 	 * is going to go through Linux networking code that may potentially
 	 * need things like pointer to IP header. */
@@ -2213,23 +2223,53 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	info = IEEE80211_SKB_CB(skb);
 	memset(info, 0, sizeof(*info));
 
-	dev->trans_start = jiffies;
-
 	info->flags = info_flags;
 	info->ack_frame_id = info_id;
 	info->band = band;
 
-	ieee80211_xmit(sdata, skb);
-	rcu_read_unlock();
+	return skb;
+ free:
+	kfree_skb(skb);
+	return ERR_PTR(ret);
+}
+
+void __ieee80211_subif_start_xmit(struct sk_buff *skb,
+				  struct net_device *dev,
+				  u32 info_flags)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	if (unlikely(skb->len < ETH_HLEN)) {
+		kfree_skb(skb);
+		return;
+	}
+
+	rcu_read_lock();
+
+	/* Measure frame arrival for Tx latency statistics calculation */
+	ieee80211_tx_latency_start_msrmnt(local, skb);
+
+	skb = ieee80211_build_hdr(sdata, skb, info_flags);
+	if (IS_ERR(skb))
+		goto out;
 
-	return;
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
+	dev->trans_start = jiffies;
 
- fail_rcu:
+	ieee80211_xmit(sdata, skb);
+ out:
 	rcu_read_unlock();
- fail:
-	dev_kfree_skb(skb);
 }
 
+/**
+ * ieee80211_subif_start_xmit - netif start_xmit function for 802.3 vifs
+ * @skb: packet to be sent
+ * @dev: incoming interface
+ *
+ * On failure skb will be freed.
+ */
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev)
 {
-- 
1.9.1

