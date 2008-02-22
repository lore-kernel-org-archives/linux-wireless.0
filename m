Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:22352 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbYBVHVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 02:21:36 -0500
Received: by rv-out-0910.google.com with SMTP id k20so204502rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 23:21:35 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Thu, 21 Feb 2008 20:29:14 -0800
Subject: [PATCH 13/13 v2] o11s: changes to cfg.c to support mesh path and mesh peer link operation
Message-ID: <47be77ff.15b38c0a.6468.ffff811b@mx.google.com> (sfid-20080222_072206_240429_C42FDF57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/cfg.c |  285 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 271 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a083cc7..08e139e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -15,6 +15,11 @@
 #include "ieee80211_i.h"
 #include "cfg.h"
 #include "ieee80211_rate.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
+
+#define DEFAULT_RATES 0
 
 static enum ieee80211_if_types
 nl80211_type_to_mac80211_type(enum nl80211_iftype type)
@@ -28,13 +33,16 @@ nl80211_type_to_mac80211_type(enum nl80211_iftype type)
 		return IEEE80211_IF_TYPE_STA;
 	case NL80211_IFTYPE_MONITOR:
 		return IEEE80211_IF_TYPE_MNTR;
+	case NL80211_IFTYPE_MESH_POINT:
+		return IEEE80211_IF_TYPE_MESH_POINT;
 	default:
 		return IEEE80211_IF_TYPE_INVALID;
 	}
 }
 
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
-			       enum nl80211_iftype type, u32 *flags)
+			       enum nl80211_iftype type, u32 *flags,
+			       struct vif_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	enum ieee80211_if_types itype;
@@ -48,8 +56,12 @@ static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 	itype = nl80211_type_to_mac80211_type(type);
 	if (itype == IEEE80211_IF_TYPE_INVALID)
 		return -EINVAL;
+#ifndef CONFIG_MAC80211_MESH
+	if (unlikely(itype == IEEE80211_IF_TYPE_MESH_POINT))
+		return -ENOTSUPP;
+#endif
 
-	err = ieee80211_if_add(local->mdev, name, &dev, itype);
+	err = ieee80211_if_add(local->mdev, name, &dev, itype, params);
 	if (err || itype != IEEE80211_IF_TYPE_MNTR || !flags)
 		return err;
 
@@ -78,7 +90,8 @@ static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
 }
 
 static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
-				  enum nl80211_iftype type, u32 *flags)
+				  enum nl80211_iftype type, u32 *flags,
+				  struct vif_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
@@ -99,6 +112,10 @@ static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
 	itype = nl80211_type_to_mac80211_type(type);
 	if (itype == IEEE80211_IF_TYPE_INVALID)
 		return -EINVAL;
+#ifndef MAC80211_MESH
+	if (unlikely(itype == IEEE80211_IF_TYPE_MESH_POINT))
+		return -ENOTSUPP;
+#endif
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -108,6 +125,15 @@ static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
 	ieee80211_if_reinit(dev);
 	ieee80211_if_set_type(dev, itype);
 
+#ifdef CONFIG_MAC80211_MESH
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
+	    params->mesh_id_len) {
+		sdata->u.sta.mesh_id_len = params->mesh_id_len;
+		memcpy(sdata->u.sta.mesh_id, params->mesh_id,
+		       params->mesh_id_len);
+	}
+#endif
+
 	if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR || !flags)
 		return 0;
 
@@ -284,26 +310,63 @@ static int ieee80211_config_default_key(struct wiphy *wiphy,
 	return 0;
 }
 
-static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
-				 u8 *mac, struct station_stats *stats)
+static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
+{
+#ifdef CONFIG_MAC80211_MESH
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+#endif
+
+	sinfo->filled = STATION_INFO_INACTIVE_TIME |
+			STATION_INFO_RX_BYTES |
+			STATION_INFO_TX_BYTES;
+
+	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
+	sinfo->rx_bytes = sta->rx_bytes;
+	sinfo->tx_bytes = sta->tx_bytes;
+
+#ifdef CONFIG_MAC80211_MESH
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+		sinfo->filled |= STATION_INFO_LLID |
+				 STATION_INFO_PLID |
+				 STATION_INFO_PLINK_STATE;
+
+		sinfo->llid = le16_to_cpu(sta->llid);
+		sinfo->plid = le16_to_cpu(sta->plid);
+		sinfo->plink_state = sta->plink_state;
+	}
+#endif
+}
+
+
+static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
+				 int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 
-	sta = sta_info_get(local, mac);
+	sta = sta_info_get_by_idx(local, idx, dev);
 	if (!sta)
 		return -ENOENT;
 
-	/* XXX: verify sta->dev == dev */
+	memcpy(mac, sta->addr, ETH_ALEN);
+	sta_set_sinfo(sta, sinfo);
+	sta_info_put(sta);
 
-	stats->filled = STATION_STAT_INACTIVE_TIME |
-			STATION_STAT_RX_BYTES |
-			STATION_STAT_TX_BYTES;
+	return 0;
+}
+
+static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
+				 u8 *mac, struct station_info *sinfo)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
 
-	stats->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
-	stats->rx_bytes = sta->rx_bytes;
-	stats->tx_bytes = sta->tx_bytes;
+	sta = sta_info_get(local, mac);
+	if (!sta)
+		return -ENOENT;
 
+	/* XXX: verify sta->dev == dev */
+	sta_set_sinfo(sta, sinfo);
 	sta_info_put(sta);
 
 	return 0;
@@ -512,6 +575,9 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
+#ifdef CONFIG_MAC80211_MESH
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+#endif
 
 	if (params->station_flags & STATION_FLAG_CHANGED) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
@@ -549,6 +615,19 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 		}
 		sta->supp_rates[local->oper_channel->band] = rates;
 	}
+
+#ifdef CONFIG_MAC80211_MESH
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
+	    params->plink_action)
+		switch (params->plink_action) {
+		case PLINK_ACTION_OPEN:
+			mesh_plink_open(sta);
+			break;
+		case PLINK_ACTION_BLOCK:
+			mesh_plink_block(sta);
+			break;
+		}
+#endif
 }
 
 static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
@@ -578,7 +657,13 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	} else
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	sta = sta_info_add(local, dev, mac, GFP_KERNEL);
+#ifdef CONFIG_MAC80211_MESH
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+		sta = mesh_plink_add(mac, DEFAULT_RATES, dev);
+	else
+#endif
+		sta = sta_info_add(local, dev, mac, GFP_KERNEL);
+
 	if (!sta)
 		return -ENOMEM;
 
@@ -650,6 +735,170 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	return 0;
 }
 
+#ifdef CONFIG_MAC80211_MESH
+static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
+				 u8 *dst, u8 *next_hop)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mesh_path *mpath;
+	struct sta_info *sta;
+	int err;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+		return -ENOTSUPP;
+
+	sta = sta_info_get(local, next_hop);
+	if (!sta)
+		return -ENOENT;
+
+	err = mesh_path_add(dst, dev);
+	if (err)
+		return err;
+
+	rcu_read_lock();
+	mpath = mesh_path_lookup(dst, dev);
+	if (!mpath) {
+		rcu_read_unlock();
+		sta_info_put(sta);
+		return -ENXIO;
+	}
+	mesh_path_fix_nexthop(mpath, sta);
+	sta_info_put(sta);
+	rcu_read_unlock();
+	return 0;
+}
+
+static int ieee80211_del_mpath(struct wiphy *wiphy, struct net_device *dev,
+				 u8 *dst)
+{
+	if (dst)
+		return mesh_path_del(dst, dev);
+
+	mesh_path_flush(dev);
+	return 0;
+}
+
+static int ieee80211_change_mpath(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    u8 *dst, u8 *next_hop)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mesh_path *mpath;
+	struct sta_info *sta;
+
+	if (!netif_running(dev))
+		return -ENETDOWN;
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+		return -ENOTSUPP;
+
+	sta = sta_info_get(local, next_hop);
+	if (!sta)
+		return -ENOENT;
+
+	rcu_read_lock();
+	mpath = mesh_path_lookup(dst, dev);
+	if (!mpath) {
+		rcu_read_unlock();
+		sta_info_put(sta);
+		return -ENOENT;
+	}
+
+	mesh_path_fix_nexthop(mpath, sta);
+	sta_info_put(sta);
+	rcu_read_unlock();
+	return 0;
+}
+
+static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
+			    struct mpath_info *pinfo)
+{
+	if (mpath->next_hop)
+		memcpy(next_hop, mpath->next_hop->addr, ETH_ALEN);
+	else
+		memset(next_hop, 0, ETH_ALEN);
+
+	pinfo->filled = MPATH_INFO_FRAME_QLEN |
+			MPATH_INFO_DSN |
+			MPATH_INFO_METRIC |
+			MPATH_INFO_EXPTIME |
+			MPATH_INFO_DISCOVERY_TIMEOUT |
+			MPATH_INFO_DISCOVERY_RETRIES |
+			MPATH_INFO_FLAGS;
+
+	pinfo->frame_qlen = mpath->frame_queue.qlen;
+	pinfo->dsn = mpath->dsn;
+	pinfo->metric = mpath->metric;
+	if (time_before(jiffies, mpath->exp_time))
+		pinfo->exptime = jiffies_to_msecs(mpath->exp_time - jiffies);
+	pinfo->discovery_timeout =
+			jiffies_to_msecs(mpath->discovery_timeout);
+	pinfo->discovery_retries = mpath->discovery_retries;
+	pinfo->flags = 0;
+	if (mpath->flags & MESH_PATH_ACTIVE)
+		pinfo->flags |= NL80211_MPATH_FLAG_ACTIVE;
+	if (mpath->flags & MESH_PATH_RESOLVING)
+		pinfo->flags |= NL80211_MPATH_FLAG_RESOLVING;
+	if (mpath->flags & MESH_PATH_DSN_VALID)
+		pinfo->flags |= NL80211_MPATH_FLAG_DSN_VALID;
+	if (mpath->flags & MESH_PATH_FIXED)
+		pinfo->flags |= NL80211_MPATH_FLAG_FIXED;
+	if (mpath->flags & MESH_PATH_RESOLVING)
+		pinfo->flags |= NL80211_MPATH_FLAG_RESOLVING;
+
+	pinfo->flags = mpath->flags;
+}
+
+static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *dst, u8 *next_hop, struct mpath_info *pinfo)
+
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mesh_path *mpath;
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+		return -ENOTSUPP;
+
+	rcu_read_lock();
+	mpath = mesh_path_lookup(dst, dev);
+	if (!mpath) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+	memcpy(dst, mpath->dst, ETH_ALEN);
+	mpath_set_pinfo(mpath, next_hop, pinfo);
+	rcu_read_unlock();
+	return 0;
+}
+
+static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
+				 int idx, u8 *dst, u8 *next_hop,
+				 struct mpath_info *pinfo)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mesh_path *mpath;
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+		return -ENOTSUPP;
+
+	rcu_read_lock();
+	mpath = mesh_path_lookup_by_idx(idx, dev);
+	if (!mpath) {
+		rcu_read_unlock();
+		return -ENOENT;
+	}
+	memcpy(dst, mpath->dst, ETH_ALEN);
+	mpath_set_pinfo(mpath, next_hop, pinfo);
+	rcu_read_unlock();
+	return 0;
+}
+#endif
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -665,4 +914,12 @@ struct cfg80211_ops mac80211_config_ops = {
 	.del_station = ieee80211_del_station,
 	.change_station = ieee80211_change_station,
 	.get_station = ieee80211_get_station,
+	.dump_station = ieee80211_dump_station,
+#ifdef CONFIG_MAC80211_MESH
+	.add_mpath = ieee80211_add_mpath,
+	.del_mpath = ieee80211_del_mpath,
+	.change_mpath = ieee80211_change_mpath,
+	.get_mpath = ieee80211_get_mpath,
+	.dump_mpath = ieee80211_dump_mpath,
+#endif
 };
-- 
1.5.2.5



