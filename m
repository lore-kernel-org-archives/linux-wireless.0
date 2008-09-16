Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYIPMTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 08:19:51 -0400
Subject: [PATCH] mac80211: make master iface not wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 14:18:59 +0200
Message-Id: <1221567539.8916.34.camel@johannes.berg> (sfid-20080916_141955_850116_8B33E1B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to register the master netdev with cfg80211,
in fact, this is quite dangerous and lead to having to add
checks for the master interface all over the config handlers.
This patch removes the "ieee80211_ptr" from the master iface
in favour of having a small netdev_priv() associated with
the master interface that stores the ieee80211_local pointer.
Because of this, a lot of code in the configuration handlers
can go away. To make this patch easier to verify I have also
removed a number of wiphy_priv() calls in favour of getting
the sdata first and then the local pointer from that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c         |   59 ---------------------------------------------
 net/mac80211/debugfs_sta.c |    3 --
 net/mac80211/ieee80211_i.h |    4 +++
 net/mac80211/main.c        |   19 +++++++-------
 net/mac80211/mesh.c        |    2 -
 net/mac80211/rx.c          |   25 +++++++------------
 net/mac80211/tx.c          |   26 +++++++++----------
 7 files changed, 39 insertions(+), 99 deletions(-)

--- everything.orig/net/mac80211/main.c	2008-09-16 14:12:33.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-16 14:12:44.000000000 +0200
@@ -106,7 +106,8 @@ static const struct header_ops ieee80211
 
 static int ieee80211_master_open(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
+	struct ieee80211_local *local = mpriv->local;
 	struct ieee80211_sub_if_data *sdata;
 	int res = -EOPNOTSUPP;
 
@@ -128,7 +129,8 @@ static int ieee80211_master_open(struct 
 
 static int ieee80211_master_stop(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
+	struct ieee80211_local *local = mpriv->local;
 	struct ieee80211_sub_if_data *sdata;
 
 	/* we hold the RTNL here so can safely walk the list */
@@ -141,7 +143,8 @@ static int ieee80211_master_stop(struct 
 
 static void ieee80211_master_set_multicast_list(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
+	struct ieee80211_local *local = mpriv->local;
 
 	ieee80211_configure_filter(local);
 }
@@ -787,7 +790,7 @@ int ieee80211_register_hw(struct ieee802
 	int result;
 	enum ieee80211_band band;
 	struct net_device *mdev;
-	struct wireless_dev *mwdev;
+	struct ieee80211_master_priv *mpriv;
 
 	/*
 	 * generic code guarantees at least one band,
@@ -829,16 +832,14 @@ int ieee80211_register_hw(struct ieee802
 	if (hw->queues < 4)
 		hw->ampdu_queues = 0;
 
-	mdev = alloc_netdev_mq(sizeof(struct wireless_dev),
+	mdev = alloc_netdev_mq(sizeof(struct ieee80211_master_priv),
 			       "wmaster%d", ether_setup,
 			       ieee80211_num_queues(hw));
 	if (!mdev)
 		goto fail_mdev_alloc;
 
-	mwdev = netdev_priv(mdev);
-	mdev->ieee80211_ptr = mwdev;
-	mwdev->wiphy = local->hw.wiphy;
-
+	mpriv = netdev_priv(mdev);
+	mpriv->local = local;
 	local->mdev = mdev;
 
 	ieee80211_rx_bss_list_init(local);
--- everything.orig/net/mac80211/cfg.c	2008-09-16 14:12:33.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-16 14:12:44.000000000 +0200
@@ -84,7 +84,6 @@ static int ieee80211_change_iface(struct
 				  enum nl80211_iftype type, u32 *flags,
 				  struct vif_params *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
@@ -97,9 +96,6 @@ static int ieee80211_change_iface(struct
 	if (!nl80211_type_check(type))
 		return -EINVAL;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	ret = ieee80211_if_change_type(sdata, type);
@@ -122,16 +118,12 @@ static int ieee80211_add_key(struct wiph
 			     u8 key_idx, u8 *mac_addr,
 			     struct key_params *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta = NULL;
 	enum ieee80211_key_alg alg;
 	struct ieee80211_key *key;
 	int err;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	switch (params->cipher) {
@@ -176,14 +168,10 @@ static int ieee80211_add_key(struct wiph
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, u8 *mac_addr)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	int ret;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
@@ -224,7 +212,6 @@ static int ieee80211_get_key(struct wiph
 			     void (*callback)(void *cookie,
 					      struct key_params *params))
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta = NULL;
 	u8 seq[6] = {0};
@@ -234,9 +221,6 @@ static int ieee80211_get_key(struct wiph
 	u16 iv16;
 	int err = -ENOENT;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
@@ -312,12 +296,8 @@ static int ieee80211_config_default_key(
 					struct net_device *dev,
 					u8 key_idx)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	rcu_read_lock();
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -498,13 +478,9 @@ static int ieee80211_config_beacon(struc
 static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
 				struct beacon_parameters *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_AP)
@@ -521,13 +497,9 @@ static int ieee80211_add_beacon(struct w
 static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
 				struct beacon_parameters *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_AP)
@@ -543,13 +515,9 @@ static int ieee80211_set_beacon(struct w
 
 static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_AP)
@@ -697,9 +665,6 @@ static int ieee80211_add_station(struct 
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 
-	if (dev == local->mdev || params->vlan == local->mdev)
-		return -EOPNOTSUPP;
-
 	/* Prevent a race with changing the rate control algorithm */
 	if (!netif_running(dev))
 		return -ENETDOWN;
@@ -754,9 +719,6 @@ static int ieee80211_del_station(struct 
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (mac) {
@@ -788,9 +750,6 @@ static int ieee80211_change_station(stru
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
 
-	if (dev == local->mdev || params->vlan == local->mdev)
-		return -EOPNOTSUPP;
-
 	rcu_read_lock();
 
 	/* XXX: get sta belonging to dev */
@@ -830,9 +789,6 @@ static int ieee80211_add_mpath(struct wi
 	struct sta_info *sta;
 	int err;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
@@ -886,9 +842,6 @@ static int ieee80211_change_mpath(struct
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
@@ -960,13 +913,9 @@ static int ieee80211_get_mpath(struct wi
 			       u8 *dst, u8 *next_hop, struct mpath_info *pinfo)
 
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
@@ -988,13 +937,9 @@ static int ieee80211_dump_mpath(struct w
 				 int idx, u8 *dst, u8 *next_hop,
 				 struct mpath_info *pinfo)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
@@ -1017,13 +962,9 @@ static int ieee80211_change_bss(struct w
 				struct net_device *dev,
 				struct bss_parameters *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	u32 changed = 0;
 
-	if (dev == local->mdev)
-		return -EOPNOTSUPP;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_AP)
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-16 14:12:33.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-16 14:12:44.000000000 +0200
@@ -573,6 +573,10 @@ enum {
 /* maximum number of hardware queues we support. */
 #define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES)
 
+struct ieee80211_master_priv {
+	struct ieee80211_local *local;
+};
+
 struct ieee80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
--- everything.orig/net/mac80211/tx.c	2008-09-16 14:12:33.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-16 14:13:55.000000000 +0200
@@ -165,11 +165,10 @@ static __le16 ieee80211_duration(struct 
 	return cpu_to_le16(dur);
 }
 
-static int inline is_ieee80211_device(struct net_device *dev,
-				      struct net_device *master)
+static int inline is_ieee80211_device(struct ieee80211_local *local,
+				      struct net_device *dev)
 {
-	return (wdev_priv(dev->ieee80211_ptr) ==
-		wdev_priv(master->ieee80211_ptr));
+	return local == wdev_priv(dev->ieee80211_ptr);
 }
 
 /* tx handlers */
@@ -1001,14 +1000,14 @@ __ieee80211_tx_prepare(struct ieee80211_
 /*
  * NB: @tx is uninitialised when passed in here
  */
-static int ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
-				struct sk_buff *skb,
-				struct net_device *mdev)
+static int ieee80211_tx_prepare(struct ieee80211_local *local,
+				struct ieee80211_tx_data *tx,
+				struct sk_buff *skb)
 {
 	struct net_device *dev;
 
 	dev = dev_get_by_index(&init_net, skb->iif);
-	if (unlikely(dev && !is_ieee80211_device(dev, mdev))) {
+	if (unlikely(dev && !is_ieee80211_device(local, dev))) {
 		dev_put(dev);
 		dev = NULL;
 	}
@@ -1258,6 +1257,8 @@ static int ieee80211_skb_resize(struct i
 int ieee80211_master_start_xmit(struct sk_buff *skb,
 				struct net_device *dev)
 {
+	struct ieee80211_master_priv *mpriv = netdev_priv(dev);
+	struct ieee80211_local *local = mpriv->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct net_device *odev = NULL;
@@ -1273,7 +1274,7 @@ int ieee80211_master_start_xmit(struct s
 
 	if (skb->iif)
 		odev = dev_get_by_index(&init_net, skb->iif);
-	if (unlikely(odev && !is_ieee80211_device(odev, dev))) {
+	if (unlikely(odev && !is_ieee80211_device(local, odev))) {
 		dev_put(odev);
 		odev = NULL;
 	}
@@ -1449,8 +1450,8 @@ fail:
 int ieee80211_subif_start_xmit(struct sk_buff *skb,
 			       struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	int ret = 1, head_need;
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
@@ -1462,7 +1463,6 @@ int ieee80211_subif_start_xmit(struct sk
 	struct sta_info *sta;
 	u32 sta_flags = 0;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (unlikely(skb->len < ETH_HLEN)) {
 		ret = 0;
 		goto fail;
@@ -2032,7 +2032,7 @@ ieee80211_get_buffered_bc(struct ieee802
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		if (!ieee80211_tx_prepare(&tx, skb, local->mdev))
+		if (!ieee80211_tx_prepare(local, &tx, skb))
 			break;
 		dev_kfree_skb_any(skb);
 	}
--- everything.orig/net/mac80211/debugfs_sta.c	2008-09-16 14:11:36.000000000 +0200
+++ everything/net/mac80211/debugfs_sta.c	2008-09-16 14:12:44.000000000 +0200
@@ -173,8 +173,7 @@ static ssize_t sta_agg_status_write(stru
 		const char __user *user_buf, size_t count, loff_t *ppos)
 {
 	struct sta_info *sta = file->private_data;
-	struct net_device *dev = sta->sdata->dev;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sta->sdata->local;
 	struct ieee80211_hw *hw = &local->hw;
 	u8 *da = sta->sta.addr;
 	static int tid_static_tx[16] = {0, 0, 0, 0, 0, 0, 0, 0,
--- everything.orig/net/mac80211/rx.c	2008-09-16 14:12:36.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-16 14:12:44.000000000 +0200
@@ -651,32 +651,28 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	return result;
 }
 
-static void ap_sta_ps_start(struct net_device *dev, struct sta_info *sta)
+static void ap_sta_ps_start(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	DECLARE_MAC_BUF(mac);
 
-	sdata = sta->sdata;
-
 	atomic_inc(&sdata->bss->num_sta_ps);
 	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
-	       dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
+	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 }
 
-static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
+static int ap_sta_ps_end(struct sta_info *sta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	int sent = 0;
-	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_tx_info *info;
 	DECLARE_MAC_BUF(mac);
 
-	sdata = sta->sdata;
-
 	atomic_dec(&sdata->bss->num_sta_ps);
 
 	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
@@ -686,7 +682,7 @@ static int ap_sta_ps_end(struct net_devi
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d exits power save mode\n",
-	       dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
+	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
 	/* Send all buffered frames to the station */
@@ -702,7 +698,7 @@ static int ap_sta_ps_end(struct net_devi
 		sent++;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "%s: STA %s aid %d send PS frame "
-		       "since STA not sleeping anymore\n", dev->name,
+		       "since STA not sleeping anymore\n", sdata->dev->name,
 		       print_mac(mac, sta->sta.addr), sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 		info->flags |= IEEE80211_TX_CTL_REQUEUE;
@@ -716,7 +712,6 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
 	struct sta_info *sta = rx->sta;
-	struct net_device *dev = rx->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 
 	if (!sta)
@@ -758,10 +753,10 @@ ieee80211_rx_h_sta_process(struct ieee80
 		 * exchange sequence */
 		if (test_sta_flags(sta, WLAN_STA_PS) &&
 		    !ieee80211_has_pm(hdr->frame_control))
-			rx->sent_ps_buffered += ap_sta_ps_end(dev, sta);
+			rx->sent_ps_buffered += ap_sta_ps_end(sta);
 		else if (!test_sta_flags(sta, WLAN_STA_PS) &&
 			 ieee80211_has_pm(hdr->frame_control))
-			ap_sta_ps_start(dev, sta);
+			ap_sta_ps_start(sta);
 	}
 
 	/* Drop data::nullfunc frames silently, since they are used only to
--- everything.orig/net/mac80211/mesh.c	2008-09-16 14:11:36.000000000 +0200
+++ everything/net/mac80211/mesh.c	2008-09-16 14:12:44.000000000 +0200
@@ -351,7 +351,7 @@ static void ieee80211_mesh_path_timer(un
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = wdev_priv(&sdata->wdev);
+	struct ieee80211_local *local = sdata->local;
 
 	queue_work(local->hw.workqueue, &ifmsh->work);
 }


