Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43162 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbbCTPYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 11:24:30 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: avoid duplicate TX path station lookup
Date: Fri, 20 Mar 2015 16:24:24 +0100
Message-Id: <1426865064-17707-5-git-send-email-johannes@sipsolutions.net> (sfid-20150320_162440_633925_3DF48280)
In-Reply-To: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net>
References: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of looking up the destination station twice in the TX path
(first to build the header, and then for control processing), save
it when building the header and use it later in the TX path.

To avoid having to look up the station in the many callers, allow
those to pass %NULL which keeps the existing lookup.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  2 +-
 net/mac80211/ieee80211_i.h |  3 +-
 net/mac80211/sta_info.c    |  2 +-
 net/mac80211/tx.c          | 73 +++++++++++++++++++++++++++++-----------------
 4 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 57b71432ec65..0aaf8b04a738 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3576,7 +3576,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 		nullfunc->qos_ctrl = cpu_to_le16(7);
 
 	local_bh_disable();
-	ieee80211_xmit(sdata, skb);
+	ieee80211_xmit(sdata, sta, skb);
 	local_bh_enable();
 	rcu_read_unlock();
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4f4bcc6c5dfe..ebc8135e0aaa 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1745,7 +1745,8 @@ void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int ke
 				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify);
-void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
+void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
+		    struct sta_info *sta, struct sk_buff *skb);
 
 void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb, int tid,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d94004e7ce37..aacaa1a85e63 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1231,7 +1231,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	}
 
 	info->band = chanctx_conf->def.chan->band;
-	ieee80211_xmit(sdata, skb);
+	ieee80211_xmit(sdata, sta, skb);
 	rcu_read_unlock();
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5af35ef35322..34b0e7545cc5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1120,11 +1120,13 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 
 /*
  * initialises @tx
+ * pass %NULL for the station if unknown, a valid pointer if known
+ * or an ERR_PTR() if the station is known not to exist
  */
 static ieee80211_tx_result
 ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		     struct ieee80211_tx_data *tx,
-		     struct sk_buff *skb)
+		     struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr;
@@ -1147,17 +1149,22 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
-		tx->sta = rcu_dereference(sdata->u.vlan.sta);
-		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
-			return TX_DROP;
-	} else if (info->flags & (IEEE80211_TX_CTL_INJECTED |
-				  IEEE80211_TX_INTFL_NL80211_FRAME_TX) ||
-		   tx->sdata->control_port_protocol == tx->skb->protocol) {
-		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
+	if (likely(sta)) {
+		if (!IS_ERR(sta))
+			tx->sta = sta;
+	} else {
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+			tx->sta = rcu_dereference(sdata->u.vlan.sta);
+			if (!tx->sta && sdata->wdev.use_4addr)
+				return TX_DROP;
+		} else if (info->flags & (IEEE80211_TX_INTFL_NL80211_FRAME_TX |
+					  IEEE80211_TX_CTL_INJECTED) ||
+			   tx->sdata->control_port_protocol == tx->skb->protocol) {
+			tx->sta = sta_info_get_bss(sdata, hdr->addr1);
+		}
+		if (!tx->sta && !is_multicast_ether_addr(hdr->addr1))
+			tx->sta = sta_info_get(sdata, hdr->addr1);
 	}
-	if (!tx->sta && !is_multicast_ether_addr(hdr->addr1))
-		tx->sta = sta_info_get(sdata, hdr->addr1);
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
 	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
@@ -1407,7 +1414,7 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 	struct ieee80211_tx_data tx;
 	struct sk_buff *skb2;
 
-	if (ieee80211_tx_prepare(sdata, &tx, skb) == TX_DROP)
+	if (ieee80211_tx_prepare(sdata, &tx, NULL, skb) == TX_DROP)
 		return false;
 
 	info->band = band;
@@ -1440,7 +1447,8 @@ EXPORT_SYMBOL(ieee80211_tx_prepare_skb);
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
 static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
-			 struct sk_buff *skb, bool txpending)
+			 struct sta_info *sta, struct sk_buff *skb,
+			 bool txpending)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_data tx;
@@ -1456,7 +1464,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 	/* initialises tx */
 	led_len = skb->len;
-	res_prepare = ieee80211_tx_prepare(sdata, &tx, skb);
+	res_prepare = ieee80211_tx_prepare(sdata, &tx, sta, skb);
 
 	if (unlikely(res_prepare == TX_DROP)) {
 		ieee80211_free_txskb(&local->hw, skb);
@@ -1512,7 +1520,8 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
+		    struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1547,7 +1556,7 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	}
 
 	ieee80211_set_qos_hdr(sdata, skb);
-	ieee80211_tx(sdata, skb, false);
+	ieee80211_tx(sdata, sta, skb, false);
 }
 
 static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
@@ -1768,7 +1777,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 		goto fail_rcu;
 
 	info->band = chandef->chan->band;
-	ieee80211_xmit(sdata, skb);
+	ieee80211_xmit(sdata, NULL, skb);
 	rcu_read_unlock();
 
 	return NETDEV_TX_OK;
@@ -1799,7 +1808,8 @@ fail:
  * Returns: the (possibly reallocated) skb or an ERR_PTR() code
  */
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
-					   struct sk_buff *skb, u32 info_flags)
+					   struct sk_buff *skb, u32 info_flags,
+					   struct sta_info **sta_out)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
@@ -1842,6 +1852,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			wme_sta = sta->sta.wme;
 			have_station = true;
+			*sta_out = sta;
 		} else if (sdata->wdev.use_4addr) {
 			ret = -ENOLINK;
 			goto free;
@@ -1995,6 +2006,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			have_station = true;
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			wme_sta = sta->sta.wme;
+			*sta_out = sta;
 		}  else if (sdata->u.mgd.use_4addr &&
 			    cpu_to_be16(ethertype) != sdata->control_port_protocol) {
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
@@ -2058,13 +2070,18 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	 * and mesh mode checks authorization later.
 	 */
 	multicast = is_multicast_ether_addr(hdr.addr1);
-	if (!multicast && !have_station &&
-	    !ieee80211_vif_is_mesh(&sdata->vif)) {
-		sta = sta_info_get(sdata, hdr.addr1);
+	if (multicast) {
+		*sta_out = ERR_PTR(-ENOENT);
+	} else if (!have_station && !ieee80211_vif_is_mesh(&sdata->vif)) {
+		if (sdata->control_port_protocol == skb->protocol)
+			sta = sta_info_get_bss(sdata, hdr.addr1);
+		else
+			sta = sta_info_get(sdata, hdr.addr1);
 		if (sta) {
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			wme_sta = sta->sta.wme;
 		}
+		*sta_out = sta ?: ERR_PTR(-ENOENT);
 	}
 
 	/* For mesh, the use of the QoS header is mandatory */
@@ -2242,6 +2259,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  u32 info_flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta = NULL;
 
 	if (unlikely(skb->len < ETH_HLEN)) {
 		kfree_skb(skb);
@@ -2250,7 +2268,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	rcu_read_lock();
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags);
+	skb = ieee80211_build_hdr(sdata, skb, info_flags, &sta);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -2258,7 +2276,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	dev->stats.tx_bytes += skb->len;
 	dev->trans_start = jiffies;
 
-	ieee80211_xmit(sdata, skb);
+	ieee80211_xmit(sdata, sta, skb);
  out:
 	rcu_read_unlock();
 }
@@ -2286,10 +2304,11 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 		.local = sdata->local,
 		.sdata = sdata,
 	};
+	struct sta_info *sta_ignore;
 
 	rcu_read_lock();
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags);
+	skb = ieee80211_build_hdr(sdata, skb, info_flags, &sta_ignore);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -2347,7 +2366,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 			return true;
 		}
 		info->band = chanctx_conf->def.chan->band;
-		result = ieee80211_tx(sdata, skb, true);
+		result = ieee80211_tx(sdata, NULL, skb, true);
 	} else {
 		struct sk_buff_head skbs;
 
@@ -3085,7 +3104,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
-		if (!ieee80211_tx_prepare(sdata, &tx, skb))
+		if (!ieee80211_tx_prepare(sdata, &tx, NULL, skb))
 			break;
 		dev_kfree_skb_any(skb);
 	}
@@ -3217,6 +3236,6 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 	 */
 	local_bh_disable();
 	IEEE80211_SKB_CB(skb)->band = band;
-	ieee80211_xmit(sdata, skb);
+	ieee80211_xmit(sdata, NULL, skb);
 	local_bh_enable();
 }
-- 
2.1.4

