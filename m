Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbYBWOVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:21:04 -0500
Message-Id: <20080223142016.018195000@sipsolutions.net> (sfid-20080223_142113_697972_E632EA6E)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:17 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 14/18] mac80211: mesh path and mesh peer configuration
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis Carlos Cobo <luisca@cozybit.com>

This adds code to allow adding mesh interfaces and configuring
mesh peers etc. Also, it adds code for station dumping.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |  269 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 259 insertions(+), 10 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-02-23 14:42:23.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-23 14:42:40.000000000 +0100
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
@@ -28,6 +33,10 @@ nl80211_type_to_mac80211_type(enum nl802
 		return IEEE80211_IF_TYPE_STA;
 	case NL80211_IFTYPE_MONITOR:
 		return IEEE80211_IF_TYPE_MNTR;
+#ifdef CONFIG_MAC80211_MESH
+	case NL80211_IFTYPE_MESH_POINT:
+		return IEEE80211_IF_TYPE_MESH_POINT;
+#endif
 	default:
 		return IEEE80211_IF_TYPE_INVALID;
 	}
@@ -110,6 +119,15 @@ static int ieee80211_change_iface(struct
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
 
@@ -286,6 +304,51 @@ static int ieee80211_config_default_key(
 	return 0;
 }
 
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
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+
+	sta = sta_info_get_by_idx(local, idx, dev);
+	if (!sta)
+		return -ENOENT;
+
+	memcpy(mac, sta->addr, ETH_ALEN);
+	sta_set_sinfo(sta, sinfo);
+	sta_info_put(sta);
+
+	return 0;
+}
+
 static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac, struct station_info *sinfo)
 {
@@ -297,15 +360,7 @@ static int ieee80211_get_station(struct 
 		return -ENOENT;
 
 	/* XXX: verify sta->dev == dev */
-
-	sinfo->filled = STATION_INFO_INACTIVE_TIME |
-			STATION_INFO_RX_BYTES |
-			STATION_INFO_TX_BYTES;
-
-	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
-	sinfo->rx_bytes = sta->rx_bytes;
-	sinfo->tx_bytes = sta->tx_bytes;
-
+	sta_set_sinfo(sta, sinfo);
 	sta_info_put(sta);
 
 	return 0;
@@ -514,6 +569,9 @@ static void sta_apply_parameters(struct 
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
+#ifdef CONFIG_MAC80211_MESH
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+#endif
 
 	if (params->station_flags & STATION_FLAG_CHANGED) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
@@ -551,6 +609,19 @@ static void sta_apply_parameters(struct 
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
@@ -573,7 +644,13 @@ static int ieee80211_add_station(struct 
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
 	if (IS_ERR(sta))
 		return PTR_ERR(sta);
 
@@ -645,6 +722,170 @@ static int ieee80211_change_station(stru
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
@@ -660,4 +901,12 @@ struct cfg80211_ops mac80211_config_ops 
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

