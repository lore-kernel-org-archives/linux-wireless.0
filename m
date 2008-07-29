Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbYG2LXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:23:53 -0400
Message-Id: <20080729112307.703166000@sipsolutions.net> (sfid-20080729_132356_510557_240BCC54)
References: <20080729112249.877813000@sipsolutions.net>
Date: Tue, 29 Jul 2008 13:22:52 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: fix cfg80211 hooks for master interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The master interface is a virtual interface that is registered
to mac80211, changing that does not seem like a good idea at
the moment. However, since it has no sdata, we cannot accept
any configuration for it. This patch makes the cfg80211 hooks
reject any such attempt.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |  103 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 88 insertions(+), 15 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-07-29 13:15:44.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-07-29 13:16:05.000000000 +0200
@@ -81,6 +81,7 @@ static int ieee80211_change_iface(struct
 				  enum nl80211_iftype type, u32 *flags,
 				  struct vif_params *params)
 {
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
 	enum ieee80211_if_types itype;
 	struct ieee80211_sub_if_data *sdata;
@@ -95,6 +96,9 @@ static int ieee80211_change_iface(struct
 	if (itype == IEEE80211_IF_TYPE_INVALID)
 		return -EINVAL;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	ret = ieee80211_if_change_type(sdata, itype);
@@ -117,12 +121,16 @@ static int ieee80211_add_key(struct wiph
 			     u8 key_idx, u8 *mac_addr,
 			     struct key_params *params)
 {
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta = NULL;
 	enum ieee80211_key_alg alg;
 	struct ieee80211_key *key;
 	int err;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	switch (params->cipher) {
@@ -167,10 +175,14 @@ static int ieee80211_add_key(struct wiph
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, u8 *mac_addr)
 {
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	int ret;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
@@ -211,7 +223,8 @@ static int ieee80211_get_key(struct wiph
 			     void (*callback)(void *cookie,
 					      struct key_params *params))
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta = NULL;
 	u8 seq[6] = {0};
 	struct key_params params;
@@ -220,6 +233,11 @@ static int ieee80211_get_key(struct wiph
 	u16 iv16;
 	int err = -ENOENT;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	rcu_read_lock();
 
 	if (mac_addr) {
@@ -293,8 +311,12 @@ static int ieee80211_config_default_key(
 					struct net_device *dev,
 					u8 key_idx)
 {
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
 	rcu_read_lock();
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -475,9 +497,15 @@ static int ieee80211_config_beacon(struc
 static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
 				struct beacon_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
 		return -EINVAL;
 
@@ -492,9 +520,15 @@ static int ieee80211_add_beacon(struct w
 static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
 				struct beacon_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
 		return -EINVAL;
 
@@ -508,9 +542,15 @@ static int ieee80211_set_beacon(struct w
 
 static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
 		return -EINVAL;
 
@@ -646,11 +686,14 @@ static void sta_apply_parameters(struct 
 static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac, struct station_parameters *params)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 
+	if (dev == local->mdev || params->vlan == local->mdev)
+		return -EOPNOTSUPP;
+
 	/* Prevent a race with changing the rate control algorithm */
 	if (!netif_running(dev))
 		return -ENETDOWN;
@@ -701,10 +744,15 @@ static int ieee80211_add_station(struct 
 static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (mac) {
 		rcu_read_lock();
 
@@ -730,10 +778,13 @@ static int ieee80211_change_station(stru
 				    u8 *mac,
 				    struct station_parameters *params)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
 
+	if (dev == local->mdev || params->vlan == local->mdev)
+		return -EOPNOTSUPP;
+
 	rcu_read_lock();
 
 	/* XXX: get sta belonging to dev */
@@ -752,7 +803,7 @@ static int ieee80211_change_station(stru
 			return -EINVAL;
 		}
 
-		sta->sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
+		sta->sdata = vlansdata;
 		ieee80211_send_layer2_update(sta);
 	}
 
@@ -767,15 +818,20 @@ static int ieee80211_change_station(stru
 static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *dst, u8 *next_hop)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 	int err;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
 
@@ -817,14 +873,19 @@ static int ieee80211_change_mpath(struct
 				    struct net_device *dev,
 				    u8 *dst, u8 *next_hop)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
 
@@ -891,9 +952,15 @@ static int ieee80211_get_mpath(struct wi
 			       u8 *dst, u8 *next_hop, struct mpath_info *pinfo)
 
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
 
@@ -913,9 +980,15 @@ static int ieee80211_dump_mpath(struct w
 				 int idx, u8 *dst, u8 *next_hop,
 				 struct mpath_info *pinfo)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
 

-- 

