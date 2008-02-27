Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYB0LPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 06:15:33 -0500
Subject: [PATCH] mac80211: fix sta_info mesh timer bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 09:56:40 +0100
Message-Id: <1204102600.3729.39.camel@johannes.berg> (sfid-20080227_111542_638951_1A09AE52)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed a bug I introduced when mesh is enabled: sta_info_destroy()
will end up calling cancel_timer() on a timer that has never been
initialized because the timer is only initialized in mesh_plink_alloc(),
not in sta_info_alloc(). This patch moves the initialization of all mesh
related fields into sta_info_alloc(), adds a bit of sanity checking to
the cfg80211 handlers and sta_info_insert() and makes mesh_plink_alloc()
a static helper function that is only used from the mesh plink code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/cfg.c        |   13 +++++++------
 net/mac80211/mesh.h       |    2 --
 net/mac80211/mesh_plink.c |   31 +++++--------------------------
 net/mac80211/sta_info.c   |   33 +++++++++++++++++++++++++--------
 4 files changed, 37 insertions(+), 42 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-02-27 09:33:30.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-27 09:39:33.000000000 +0100
@@ -17,8 +17,6 @@
 #include "ieee80211_rate.h"
 #include "mesh.h"
 
-#define DEFAULT_RATES 0
-
 static enum ieee80211_if_types
 nl80211_type_to_mac80211_type(enum nl80211_iftype type)
 {
@@ -660,10 +658,13 @@ static int ieee80211_add_station(struct 
 	} else
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		sta = mesh_plink_alloc(sdata, mac, DEFAULT_RATES, GFP_KERNEL);
-	else
-		sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
+	if (compare_ether_addr(mac, dev->dev_addr) == 0)
+		return -EINVAL;
+
+	if (is_multicast_ether_addr(mac))
+		return -EINVAL;
+
+	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
 	if (!sta)
 		return -ENOMEM;
 
--- everything.orig/net/mac80211/mesh.h	2008-02-27 09:33:43.000000000 +0100
+++ everything/net/mac80211/mesh.h	2008-02-27 09:33:45.000000000 +0100
@@ -232,8 +232,6 @@ void mesh_neighbour_update(u8 *hw_addr, 
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie,
 			      struct net_device *dev);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
-struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
-				  u8 *hw_addr, u64 rates, gfp_t gfp);
 void mesh_plink_broken(struct sta_info *sta);
 void mesh_plink_deactivate(struct sta_info *sta);
 int mesh_plink_open(struct sta_info *sta);
--- everything.orig/net/mac80211/sta_info.c	2008-02-27 09:34:33.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-27 09:51:13.000000000 +0100
@@ -31,13 +31,12 @@
  * for faster lookup and a list for iteration. They are managed using
  * RCU, i.e. access to the list and hash table is protected by RCU.
  *
- * Upon allocating a STA info structure with sta_info_alloc() or
- * mesh_plink_alloc(), the caller owns that structure. It must then either
- * destroy it using sta_info_destroy() (which is pretty useless) or insert
- * it into the hash table using sta_info_insert() which demotes the reference
- * from ownership to a regular RCU-protected reference; if the function
- * is called without protection by an RCU critical section the reference
- * is instantly invalidated.
+ * Upon allocating a STA info structure with sta_info_alloc(), the caller owns
+ * that structure. It must then either destroy it using sta_info_destroy()
+ * (which is pretty useless) or insert it into the hash table using
+ * sta_info_insert() which demotes the reference from ownership to a regular
+ * RCU-protected reference; if the function is called without protection by an
+ * RCU critical section the reference is instantly invalidated.
  *
  * Because there are debugfs entries for each station, and adding those
  * must be able to sleep, it is also possible to "pin" a station entry,
@@ -244,6 +243,12 @@ struct sta_info *sta_info_alloc(struct i
 	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
+#ifdef CONFIG_MAC80211_MESH
+	sta->plink_state = LISTEN;
+	spin_lock_init(&sta->plink_lock);
+	init_timer(&sta->plink_timer);
+#endif
+
 	return sta;
 }
 
@@ -254,7 +259,19 @@ int sta_info_insert(struct sta_info *sta
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
-	WARN_ON(!netif_running(sdata->dev));
+	/*
+	 * Can't be a WARN_ON because it can be triggered through a race:
+	 * something inserts a STA (on one CPU) without holding the RTNL
+	 * and another CPU turns off the net device.
+	 */
+	if (unlikely(!netif_running(sdata->dev)))
+		return -ENETDOWN;
+
+	if (WARN_ON(compare_ether_addr(sta->addr, sdata->dev->dev_addr) == 0))
+		return -EINVAL;
+
+	if (WARN_ON(is_multicast_ether_addr(sta->addr)))
+		return -EINVAL;
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
--- everything.orig/net/mac80211/mesh_plink.c	2008-02-27 09:35:20.000000000 +0100
+++ everything/net/mac80211/mesh_plink.c	2008-02-27 09:44:36.000000000 +0100
@@ -88,40 +88,19 @@ static inline void mesh_plink_fsm_restar
 	sta->llid = sta->plid = sta->reason = sta->plink_retries = 0;
 }
 
-/**
- * mesh_plink_alloc - allocate a new mesh peer link
- *
- * @sdata: local mesh interface
- * @hw_addr: hardware address (ETH_ALEN length)
- * @rates: rates the mesh peer supports
- *
- * The initial state of the new plink is set to LISTEN
- *
- * Returns: NULL on error.
- */
-struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
-				  u8 *hw_addr, u64 rates, gfp_t gfp)
+static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
+					 u8 *hw_addr, u64 rates)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
-	if (compare_ether_addr(hw_addr, sdata->dev->dev_addr) == 0)
-		/* never add ourselves as neighbours */
-		return NULL;
-
-	if (is_multicast_ether_addr(hw_addr))
-		return NULL;
-
 	if (local->num_sta >= MESH_MAX_PLINKS)
 		return NULL;
 
-	sta = sta_info_alloc(sdata, hw_addr, gfp);
+	sta = sta_info_alloc(sdata, hw_addr, GFP_ATOMIC);
 	if (!sta)
 		return NULL;
 
-	sta->plink_state = LISTEN;
-	spin_lock_init(&sta->plink_lock);
-	init_timer(&sta->plink_timer);
 	sta->flags |= WLAN_STA_AUTHORIZED;
 	sta->supp_rates[local->hw.conf.channel->band] = rates;
 
@@ -249,7 +228,7 @@ void mesh_neighbour_update(u8 *hw_addr, 
 
 	sta = sta_info_get(local, hw_addr);
 	if (!sta) {
-		sta = mesh_plink_alloc(sdata, hw_addr, rates, GFP_ATOMIC);
+		sta = mesh_plink_alloc(sdata, hw_addr, rates);
 		if (!sta) {
 			rcu_read_unlock();
 			return;
@@ -518,7 +497,7 @@ void mesh_rx_plink_frame(struct net_devi
 		}
 
 		rates = ieee80211_sta_get_rates(local, &elems, rx_status->band);
-		sta = mesh_plink_alloc(sdata, mgmt->sa, rates, GFP_ATOMIC);
+		sta = mesh_plink_alloc(sdata, mgmt->sa, rates);
 		if (!sta) {
 			mpl_dbg("Mesh plink error: plink table full\n");
 			rcu_read_unlock();


