Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZKPOxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 09:53:07 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1NA2x3-00043x-UC
	for linux-wireless@vger.kernel.org; Mon, 16 Nov 2009 15:53:11 +0100
Subject: [RFC] mac80211: make station management completely depend on vif
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 15:53:09 +0100
Message-ID: <1258383189.32159.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The station management currently uses the virtual
interface, but you cannot add the same station to
multiple virtual interfaces if you're communicating
with it in multiple ways.

This restriction should be lifted so that in the
future we can, for instance, support bluetooth 3
with an access point that mac80211 is already
associated to.

We can do that by requiring all sta_info_get users
to provide the virtual interface and making the RX
code aware that an address may match more than one
station struct. Thanks to the previous patches this
one isn't all that large and except for the RX and
TX status paths changes has low complexity.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c     |    2 
 net/mac80211/agg-tx.c     |    4 -
 net/mac80211/cfg.c        |   25 +++------
 net/mac80211/ibss.c       |    2 
 net/mac80211/key.c        |    2 
 net/mac80211/main.c       |    8 +--
 net/mac80211/mesh_hwmp.c  |    2 
 net/mac80211/mesh_plink.c |    4 -
 net/mac80211/mlme.c       |   10 +--
 net/mac80211/rx.c         |  119 ++++++++++++++++++++++++----------------------
 net/mac80211/sta_info.c   |   18 ++++--
 net/mac80211/sta_info.h   |   29 ++++++++++-
 net/mac80211/tx.c         |    9 +--
 13 files changed, 133 insertions(+), 101 deletions(-)

--- wireless-testing.orig/net/mac80211/sta_info.h	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-11-16 15:29:38.000000000 +0100
@@ -403,9 +403,34 @@ static inline u32 get_sta_flags(struct s
 #define STA_INFO_CLEANUP_INTERVAL (10 * HZ)
 
 /*
- * Get a STA info, must have be under RCU read lock.
+ * Get a STA info, must be under RCU read lock.
  */
-struct sta_info *sta_info_get(struct ieee80211_local *local, const u8 *addr);
+struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
+			      const u8 *addr);
+
+static inline
+void for_each_sta_info_type_check(struct ieee80211_local *local,
+				  const u8 *addr,
+				  struct sta_info *sta,
+				  struct sta_info *nxt)
+{
+}
+
+#define for_each_sta_info(local, _addr, sta, nxt) 			\
+	for (	/* initialise loop */					\
+		sta = rcu_dereference(local->sta_hash[STA_HASH(_addr)]),\
+		nxt = sta ? rcu_dereference(sta->hnext) : NULL;		\
+		/* typecheck */						\
+		for_each_sta_info_type_check(local, (_addr), sta, nxt),	\
+		/* continue condition */				\
+		sta;							\
+		/* advance loop */					\
+		sta = nxt,						\
+		nxt = sta ? rcu_dereference(sta->hnext) : NULL		\
+	     )								\
+	/* compare address and run code only if it matches */		\
+	if (memcmp(sta->sta.addr, (_addr), ETH_ALEN) == 0)
+
 /*
  * Get STA info by index, BROKEN!
  */
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-11-16 15:29:38.000000000 +0100
@@ -103,13 +103,16 @@ static int sta_info_hash_del(struct ieee
 }
 
 /* protected by RCU */
-struct sta_info *sta_info_get(struct ieee80211_local *local, const u8 *addr)
+struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
+			      const u8 *addr)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
 	sta = rcu_dereference(local->sta_hash[STA_HASH(addr)]);
 	while (sta) {
-		if (memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
+		if (sta->sdata == sdata &&
+		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference(sta->hnext);
 	}
@@ -377,7 +380,7 @@ int sta_info_insert(struct sta_info *sta
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
-	if (sta_info_get(local, sta->sta.addr)) {
+	if (sta_info_get(sdata, sta->sta.addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 		err = -EEXIST;
 		goto out_free;
@@ -843,11 +846,12 @@ void ieee80211_sta_expire(struct ieee802
 struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
 					       const u8 *addr)
 {
-	struct sta_info *sta = sta_info_get(hw_to_local(hw), addr);
+	struct sta_info *sta, *nxt;
 
-	if (!sta)
-		return NULL;
-	return &sta->sta;
+	/* Just return a random station ... first in list ... */
+	for_each_sta_info(hw_to_local(hw), addr, sta, nxt)
+		return &sta->sta;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(ieee80211_find_sta_by_hw);
 
--- wireless-testing.orig/net/mac80211/ibss.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2009-11-16 15:29:38.000000000 +0100
@@ -252,7 +252,7 @@ static void ieee80211_rx_bss_info(struct
 
 		rcu_read_lock();
 
-		sta = sta_info_get(local, mgmt->sa);
+		sta = sta_info_get(sdata, mgmt->sa);
 		if (sta) {
 			u32 prev_rates;
 
--- wireless-testing.orig/net/mac80211/key.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/key.c	2009-11-16 15:29:38.000000000 +0100
@@ -421,7 +421,7 @@ void ieee80211_key_link(struct ieee80211
 			 */
 
 			/* same here, the AP could be using QoS */
-			ap = sta_info_get(key->local, key->sdata->u.mgd.bssid);
+			ap = sta_info_get(key->sdata, key->sdata->u.mgd.bssid);
 			if (ap) {
 				if (test_sta_flags(ap, WLAN_STA_WME))
 					key->conf.flags |=
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2009-11-16 15:29:38.000000000 +0100
@@ -290,7 +290,7 @@ static u32 hwmp_route_info_get(struct ie
 	bool process = true;
 
 	rcu_read_lock();
-	sta = sta_info_get(local, mgmt->sa);
+	sta = sta_info_get(sdata, mgmt->sa);
 	if (!sta) {
 		rcu_read_unlock();
 		return 0;
--- wireless-testing.orig/net/mac80211/mesh_plink.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_plink.c	2009-11-16 15:29:38.000000000 +0100
@@ -233,7 +233,7 @@ void mesh_neighbour_update(u8 *hw_addr, 
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, hw_addr);
+	sta = sta_info_get(sdata, hw_addr);
 	if (!sta) {
 		sta = mesh_plink_alloc(sdata, hw_addr, rates);
 		if (!sta) {
@@ -454,7 +454,7 @@ void mesh_rx_plink_frame(struct ieee8021
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, mgmt->sa);
+	sta = sta_info_get(sdata, mgmt->sa);
 	if (!sta && ftype != PLINK_OPEN) {
 		mpl_dbg("Mesh plink: cls or cnf from unknown peer\n");
 		rcu_read_unlock();
--- wireless-testing.orig/net/mac80211/mlme.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-11-16 15:29:38.000000000 +0100
@@ -202,7 +202,7 @@ static u32 ieee80211_enable_ht(struct ie
 		ieee80211_hw_config(local, 0);
 
 		rcu_read_lock();
-		sta = sta_info_get(local, bssid);
+		sta = sta_info_get(sdata, bssid);
 		if (sta)
 			rate_control_rate_update(local, sband, sta,
 						 IEEE80211_RC_HT_CHANGED);
@@ -1065,7 +1065,7 @@ static void ieee80211_set_disassoc(struc
 	netif_carrier_off(sdata->dev);
 
 	rcu_read_lock();
-	sta = sta_info_get(local, bssid);
+	sta = sta_info_get(sdata, bssid);
 	if (sta)
 		ieee80211_sta_tear_down_BA_sessions(sta);
 	rcu_read_unlock();
@@ -1104,7 +1104,7 @@ static void ieee80211_set_disassoc(struc
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, bssid);
+	sta = sta_info_get(sdata, bssid);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
@@ -1484,7 +1484,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	rcu_read_lock();
 
 	/* Add STA entry for the AP */
-	sta = sta_info_get(local, wk->bss->cbss.bssid);
+	sta = sta_info_get(sdata, wk->bss->cbss.bssid);
 	if (!sta) {
 		newsta = true;
 
@@ -1852,7 +1852,7 @@ static void ieee80211_rx_mgmt_beacon(str
 
 		rcu_read_lock();
 
-		sta = sta_info_get(local, bssid);
+		sta = sta_info_get(sdata, bssid);
 		if (WARN_ON(!sta)) {
 			rcu_read_unlock();
 			return;
--- wireless-testing.orig/net/mac80211/rx.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-16 15:29:38.000000000 +0100
@@ -1473,7 +1473,6 @@ ieee80211_deliver_skb(struct ieee80211_r
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct net_device *dev = sdata->dev;
-	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb, *xmit_skb;
 	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
 	struct sta_info *dsta;
@@ -1495,8 +1494,8 @@ ieee80211_deliver_skb(struct ieee80211_r
 				printk(KERN_DEBUG "%s: failed to clone "
 				       "multicast frame\n", dev->name);
 		} else {
-			dsta = sta_info_get(local, skb->data);
-			if (dsta && dsta->sdata->dev == dev) {
+			dsta = sta_info_get(sdata, skb->data);
+			if (dsta) {
 				/*
 				 * The destination station is associated to
 				 * this AP (in this VLAN), so send the frame
@@ -2363,6 +2362,8 @@ static void __ieee80211_rx_handle_packet
 	int prepares;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
+	struct sta_info *sta, *tmp;
+	bool found_sta = false;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	memset(&rx, 0, sizeof(rx));
@@ -2379,68 +2380,74 @@ static void __ieee80211_rx_handle_packet
 	ieee80211_parse_qos(&rx);
 	ieee80211_verify_alignment(&rx);
 
-	rx.sta = sta_info_get(local, hdr->addr2);
-	if (rx.sta)
-		rx.sdata = rx.sta->sdata;
-
-	if (rx.sdata && ieee80211_is_data(hdr->frame_control)) {
-		rx.flags |= IEEE80211_RX_RA_MATCH;
-		prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
-		if (prepares) {
-			if (status->flag & RX_FLAG_MMIC_ERROR) {
-				if (rx.flags & IEEE80211_RX_RA_MATCH)
-					ieee80211_rx_michael_mic_report(hdr, &rx);
-			} else
-				prev = rx.sdata;
+	if (ieee80211_is_data(hdr->frame_control)) {
+		for_each_sta_info(local, hdr->addr2, sta, tmp) {
+			rx.sta = sta;
+			found_sta = true;
+			rx.sdata = sta->sdata;
+
+			rx.flags |= IEEE80211_RX_RA_MATCH;
+			prepares = prepare_for_handlers(rx.sdata, &rx, hdr);
+			if (prepares) {
+				if (status->flag & RX_FLAG_MMIC_ERROR) {
+					if (rx.flags & IEEE80211_RX_RA_MATCH)
+						ieee80211_rx_michael_mic_report(hdr, &rx);
+				} else
+					prev = rx.sdata;
+			}
 		}
-	} else list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
-			continue;
-
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
-		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-			continue;
+	}
+	if (!found_sta) {
+		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+			if (!netif_running(sdata->dev))
+				continue;
+
+			if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+			    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+				continue;
 
-		rx.flags |= IEEE80211_RX_RA_MATCH;
-		prepares = prepare_for_handlers(sdata, &rx, hdr);
+			rx.flags |= IEEE80211_RX_RA_MATCH;
+			prepares = prepare_for_handlers(sdata, &rx, hdr);
 
-		if (!prepares)
-			continue;
+			if (!prepares)
+				continue;
 
-		if (status->flag & RX_FLAG_MMIC_ERROR) {
-			rx.sdata = sdata;
-			if (rx.flags & IEEE80211_RX_RA_MATCH)
-				ieee80211_rx_michael_mic_report(hdr, &rx);
-			continue;
-		}
+			if (status->flag & RX_FLAG_MMIC_ERROR) {
+				rx.sdata = sdata;
+				if (rx.flags & IEEE80211_RX_RA_MATCH)
+					ieee80211_rx_michael_mic_report(hdr,
+									&rx);
+				continue;
+			}
 
-		/*
-		 * frame is destined for this interface, but if it's not
-		 * also for the previous one we handle that after the
-		 * loop to avoid copying the SKB once too much
-		 */
+			/*
+			 * frame is destined for this interface, but if it's
+			 * not also for the previous one we handle that after
+			 * the loop to avoid copying the SKB once too much
+			 */
 
-		if (!prev) {
-			prev = sdata;
-			continue;
-		}
+			if (!prev) {
+				prev = sdata;
+				continue;
+			}
 
-		/*
-		 * frame was destined for the previous interface
-		 * so invoke RX handlers for it
-		 */
+			/*
+			 * frame was destined for the previous interface
+			 * so invoke RX handlers for it
+			 */
 
-		skb_new = skb_copy(skb, GFP_ATOMIC);
-		if (!skb_new) {
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: failed to copy "
-				       "multicast frame for %s\n",
-				       wiphy_name(local->hw.wiphy),
-				       prev->dev->name);
-			continue;
+			skb_new = skb_copy(skb, GFP_ATOMIC);
+			if (!skb_new) {
+				if (net_ratelimit())
+					printk(KERN_DEBUG "%s: failed to copy "
+					       "multicast frame for %s\n",
+					       wiphy_name(local->hw.wiphy),
+					       prev->dev->name);
+				continue;
+			}
+			ieee80211_invoke_rx_handlers(prev, &rx, skb_new, rate);
+			prev = sdata;
 		}
-		ieee80211_invoke_rx_handlers(prev, &rx, skb_new, rate);
-		prev = sdata;
 	}
 	if (prev)
 		ieee80211_invoke_rx_handlers(prev, &rx, skb, rate);
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-11-16 15:29:38.000000000 +0100
@@ -434,7 +434,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 	}
 
 	rcu_read_lock();
-	sta = sta_info_get(local, ra);
+	sta = sta_info_get(sdata, ra);
 	if (!sta) {
 		rcu_read_unlock();
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -561,7 +561,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	rcu_read_lock();
-	sta = sta_info_get(local, ra);
+	sta = sta_info_get(sdata, ra);
 	if (!sta) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Could not find station: %pM\n", ra);
--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-11-16 15:29:38.000000000 +0100
@@ -92,7 +92,7 @@ void ieee80211_sta_stop_rx_ba_session(st
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, ra);
+	sta = sta_info_get(sdata, ra);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
--- wireless-testing.orig/net/mac80211/cfg.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-11-16 15:29:38.000000000 +0100
@@ -155,7 +155,7 @@ static int ieee80211_add_key(struct wiph
 	rcu_read_lock();
 
 	if (mac_addr) {
-		sta = sta_info_get(sdata->local, mac_addr);
+		sta = sta_info_get(sdata, mac_addr);
 		if (!sta) {
 			ieee80211_key_free(key);
 			err = -ENOENT;
@@ -186,7 +186,7 @@ static int ieee80211_del_key(struct wiph
 	if (mac_addr) {
 		ret = -ENOENT;
 
-		sta = sta_info_get(sdata->local, mac_addr);
+		sta = sta_info_get(sdata, mac_addr);
 		if (!sta)
 			goto out_unlock;
 
@@ -233,7 +233,7 @@ static int ieee80211_get_key(struct wiph
 	rcu_read_lock();
 
 	if (mac_addr) {
-		sta = sta_info_get(sdata->local, mac_addr);
+		sta = sta_info_get(sdata, mac_addr);
 		if (!sta)
 			goto out;
 
@@ -419,15 +419,13 @@ static int ieee80211_dump_station(struct
 static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac, struct station_info *sinfo)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
 	int ret = -ENOENT;
 
 	rcu_read_lock();
 
-	/* XXX: verify sta->dev == dev */
-
-	sta = sta_info_get(local, mac);
+	sta = sta_info_get(sdata, mac);
 	if (sta) {
 		ret = 0;
 		sta_set_sinfo(sta, sinfo);
@@ -783,8 +781,7 @@ static int ieee80211_del_station(struct 
 	if (mac) {
 		rcu_read_lock();
 
-		/* XXX: get sta belonging to dev */
-		sta = sta_info_get(local, mac);
+		sta = sta_info_get(sdata, mac);
 		if (!sta) {
 			rcu_read_unlock();
 			return -ENOENT;
@@ -805,14 +802,14 @@ static int ieee80211_change_station(stru
 				    u8 *mac,
 				    struct station_parameters *params)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
 
 	rcu_read_lock();
 
-	/* XXX: get sta belonging to dev */
-	sta = sta_info_get(local, mac);
+	sta = sta_info_get(sdata, mac);
 	if (!sta) {
 		rcu_read_unlock();
 		return -ENOENT;
@@ -849,7 +846,6 @@ static int ieee80211_change_station(stru
 static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *dst, u8 *next_hop)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
@@ -858,7 +854,7 @@ static int ieee80211_add_mpath(struct wi
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
-	sta = sta_info_get(local, next_hop);
+	sta = sta_info_get(sdata, next_hop);
 	if (!sta) {
 		rcu_read_unlock();
 		return -ENOENT;
@@ -897,7 +893,6 @@ static int ieee80211_change_mpath(struct
 				    struct net_device *dev,
 				    u8 *dst, u8 *next_hop)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
@@ -906,7 +901,7 @@ static int ieee80211_change_mpath(struct
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, next_hop);
+	sta = sta_info_get(sdata, next_hop);
 	if (!sta) {
 		rcu_read_unlock();
 		return -ENOENT;
--- wireless-testing.orig/net/mac80211/tx.c	2009-11-16 15:29:06.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-11-16 15:29:38.000000000 +0100
@@ -1054,7 +1054,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 	if ((sdata->vif.type == NL80211_IFTYPE_AP_VLAN) && sdata->use_4addr)
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 	if (!tx->sta)
-		tx->sta = sta_info_get(local, hdr->addr1);
+		tx->sta = sta_info_get(sdata, hdr->addr1);
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
 	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
@@ -1761,9 +1761,8 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	 */
 	if (!is_multicast_ether_addr(hdr.addr1)) {
 		rcu_read_lock();
-		sta = sta_info_get(local, hdr.addr1);
-		/* XXX: in the future, use sdata to look up the sta */
-		if (sta && sta->sdata == sdata)
+		sta = sta_info_get(sdata, hdr.addr1);
+		if (sta)
 			sta_flags = get_sta_flags(sta);
 		rcu_read_unlock();
 	}
@@ -1922,7 +1921,7 @@ static bool ieee80211_tx_pending_skb(str
 		ieee80211_tx(sdata, skb, true);
 	} else {
 		hdr = (struct ieee80211_hdr *)skb->data;
-		sta = sta_info_get(local, hdr->addr1);
+		sta = sta_info_get(sdata, hdr->addr1);
 
 		ret = __ieee80211_tx(local, &skb, sta, true);
 		if (ret != IEEE80211_TX_OK)
--- wireless-testing.orig/net/mac80211/main.c	2009-11-16 15:45:44.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-16 15:50:12.000000000 +0100
@@ -423,7 +423,7 @@ void ieee80211_tx_status(struct ieee8021
 	struct ieee80211_tx_status_rtap_hdr *rthdr;
 	struct ieee80211_sub_if_data *sdata;
 	struct net_device *prev_dev = NULL;
-	struct sta_info *sta;
+	struct sta_info *sta, *tmp;
 	int retry_count = -1, i;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
@@ -442,9 +442,11 @@ void ieee80211_tx_status(struct ieee8021
 
 	sband = local->hw.wiphy->bands[info->band];
 
-	sta = sta_info_get(local, hdr->addr1);
+	for_each_sta_info(local, hdr->addr1, sta, tmp) {
+		/* skip wrong virtual interface */
+		if (memcmp(hdr->addr2, sta->sdata->dev->dev_addr, ETH_ALEN))
+			continue;
 
-	if (sta) {
 		if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
 		    test_sta_flags(sta, WLAN_STA_PS_STA)) {
 			/*


