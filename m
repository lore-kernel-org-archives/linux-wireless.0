Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbYBUKJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 05:09:50 -0500
Subject: [PATCH v2] mac80211: atomically check whether STA exists already
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203549853.17534.98.camel@johannes.berg> (sfid-20080221_092523_845571_EDF31CA1)
References: <1203549853.17534.98.camel@johannes.berg>
	 (sfid-20080221_092523_845571_EDF31CA1)
Content-Type: text/plain
Date: Thu, 21 Feb 2008 11:09:42 +0100
Message-Id: <1203588582.17534.141.camel@johannes.berg> (sfid-20080221_100953_696094_F22A8795)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a STA structure is added, it is often checked whether it
already exists before adding it. This, however, isn't done
atomically so there is a race condition that could lead to two
STA structures being added with the same MAC address. This
patch changes sta_info_add() to return an ERR_PTR in case
of failure and adds the failure mode -EEXIST when the STA
already exists.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Carlos Cobo <luisca@cozybit.com>
---
Luis, I don't think the check for max # of STA structs is important
enough to verify, it is only done for IBSS and it can't really
happen that we add too many because we process incoming packets in
order. If you get problems with mesh there feel free to add a strict
check for the maximum number within the locked section in
sta_info_add().

v2 fixes a small %d vs. %ld warning.

 net/mac80211/cfg.c           |   11 ++---------
 net/mac80211/ieee80211.c     |    4 ++--
 net/mac80211/ieee80211_sta.c |    6 +++---
 net/mac80211/sta_info.c      |   37 ++++++++++++++++++++++++++-----------
 net/mac80211/sta_info.h      |    4 ++--
 5 files changed, 35 insertions(+), 27 deletions(-)

--- everything.orig/net/mac80211/sta_info.c	2008-02-21 11:04:18.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-21 11:08:46.000000000 +0100
@@ -55,19 +55,28 @@ static int sta_info_hash_del(struct ieee
 	return -ENOENT;
 }
 
-struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr)
+/* must hold local->sta_lock */
+static struct sta_info *__sta_info_find(struct ieee80211_local *local,
+					u8 *addr)
 {
 	struct sta_info *sta;
 
-	read_lock_bh(&local->sta_lock);
 	sta = local->sta_hash[STA_HASH(addr)];
 	while (sta) {
-		if (memcmp(sta->addr, addr, ETH_ALEN) == 0) {
-			__sta_info_get(sta);
+		if (compare_ether_addr(sta->addr, addr) == 0)
 			break;
-		}
 		sta = sta->hnext;
 	}
+	return sta;
+}
+
+struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr)
+{
+	struct sta_info *sta;
+
+	read_lock_bh(&local->sta_lock);
+	sta = __sta_info_find(local, addr);
+	__sta_info_get(sta);
 	read_unlock_bh(&local->sta_lock);
 
 	return sta;
@@ -110,8 +119,8 @@ void sta_info_put(struct sta_info *sta)
 EXPORT_SYMBOL(sta_info_put);
 
 
-struct sta_info * sta_info_add(struct ieee80211_local *local,
-			       struct net_device *dev, u8 *addr, gfp_t gfp)
+struct sta_info *sta_info_add(struct ieee80211_local *local,
+			      struct net_device *dev, u8 *addr, gfp_t gfp)
 {
 	struct sta_info *sta;
 	int i;
@@ -119,7 +128,7 @@ struct sta_info * sta_info_add(struct ie
 
 	sta = kzalloc(sizeof(*sta), gfp);
 	if (!sta)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	kref_init(&sta->kref);
 
@@ -128,7 +137,7 @@ struct sta_info * sta_info_add(struct ie
 	if (!sta->rate_ctrl_priv) {
 		rate_control_put(sta->rate_ctrl);
 		kfree(sta);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	memcpy(sta->addr, addr, ETH_ALEN);
@@ -158,9 +167,15 @@ struct sta_info * sta_info_add(struct ie
 	}
 	skb_queue_head_init(&sta->ps_tx_buf);
 	skb_queue_head_init(&sta->tx_filtered);
-	__sta_info_get(sta);	/* sta used by caller, decremented by
-				 * sta_info_put() */
 	write_lock_bh(&local->sta_lock);
+	/* mark sta as used (by caller) */
+	__sta_info_get(sta);
+	/* check if STA exists already */
+	if (__sta_info_find(local, addr)) {
+		write_unlock_bh(&local->sta_lock);
+		sta_info_put(sta);
+		return ERR_PTR(-EEXIST);
+	}
 	list_add(&sta->list, &local->sta_list);
 	local->num_sta++;
 	sta_info_hash_add(local, sta);
--- everything.orig/net/mac80211/sta_info.h	2008-02-21 11:08:39.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-21 11:08:46.000000000 +0100
@@ -239,8 +239,8 @@ static inline void __sta_info_get(struct
 
 struct sta_info * sta_info_get(struct ieee80211_local *local, u8 *addr);
 void sta_info_put(struct sta_info *sta);
-struct sta_info * sta_info_add(struct ieee80211_local *local,
-			       struct net_device *dev, u8 *addr, gfp_t gfp);
+struct sta_info *sta_info_add(struct ieee80211_local *local,
+			      struct net_device *dev, u8 *addr, gfp_t gfp);
 void sta_info_remove(struct sta_info *sta);
 void sta_info_free(struct sta_info *sta);
 void sta_info_init(struct ieee80211_local *local);
--- everything.orig/net/mac80211/cfg.c	2008-02-21 11:04:29.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-21 11:08:46.000000000 +0100
@@ -568,13 +568,6 @@ static int ieee80211_add_station(struct 
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
-	/* XXX: get sta belonging to dev */
-	sta = sta_info_get(local, mac);
-	if (sta) {
-		sta_info_put(sta);
-		return -EEXIST;
-	}
-
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
@@ -585,8 +578,8 @@ static int ieee80211_add_station(struct 
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	sta = sta_info_add(local, dev, mac, GFP_KERNEL);
-	if (!sta)
-		return -ENOMEM;
+	if (IS_ERR(sta))
+		return PTR_ERR(sta);
 
 	sta->dev = sdata->dev;
 	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN ||
--- everything.orig/net/mac80211/ieee80211.c	2008-02-21 11:08:39.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-21 11:08:46.000000000 +0100
@@ -838,8 +838,8 @@ int ieee80211_if_update_wds(struct net_d
 
 	/* Create STA entry for the new peer */
 	sta = sta_info_add(local, dev, remote_addr, GFP_KERNEL);
-	if (!sta)
-		return -ENOMEM;
+	if (IS_ERR(sta))
+		return PTR_ERR(sta);
 
 	sta->flags |= WLAN_STA_AUTHORIZED;
 
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-21 11:04:32.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-21 11:08:46.000000000 +0100
@@ -1806,9 +1806,9 @@ static void ieee80211_rx_mgmt_assoc_resp
 	if (!sta) {
 		struct ieee80211_sta_bss *bss;
 		sta = sta_info_add(local, dev, ifsta->bssid, GFP_KERNEL);
-		if (!sta) {
+		if (IS_ERR(sta)) {
 			printk(KERN_DEBUG "%s: failed to add STA entry for the"
-			       " AP\n", dev->name);
+			       " AP (error %ld)\n", dev->name, PTR_ERR(sta));
 			return;
 		}
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
@@ -3819,7 +3819,7 @@ struct sta_info * ieee80211_ibss_add_sta
 	       wiphy_name(local->hw.wiphy), print_mac(mac, addr), dev->name);
 
 	sta = sta_info_add(local, dev, addr, GFP_ATOMIC);
-	if (!sta)
+	if (IS_ERR(sta))
 		return NULL;
 
 	sta->flags |= WLAN_STA_AUTHORIZED;


