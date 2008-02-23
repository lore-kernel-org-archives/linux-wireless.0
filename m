Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbYBWOVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:21:17 -0500
Message-Id: <20080223142017.110809000@sipsolutions.net> (sfid-20080223_142130_015133_FA5F3055)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:19 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 16/18] mac80211: clean up mesh code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various cleanups, reducing the #ifdef mess and other things.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h          |    8 ++
 net/mac80211/cfg.c              |   32 +++-------
 net/mac80211/ieee80211.c        |    9 ---
 net/mac80211/ieee80211_i.h      |   56 ++++++++++++++++--
 net/mac80211/ieee80211_iface.c  |   66 +++-------------------
 net/mac80211/ieee80211_sta.c    |   72 ++++++++++--------------
 net/mac80211/mesh.c             |   67 ++++++++++++++++++++++
 net/mac80211/mesh.h             |   13 +++-
 net/mac80211/mesh_plink.c       |   28 +++++++--
 net/mac80211/rc80211_pid_algo.c |    3 -
 net/mac80211/rx.c               |   28 ++++-----
 net/mac80211/sta_info.c         |   13 ----
 net/mac80211/sta_info.h         |    2 
 net/mac80211/tx.c               |  120 +++++++++++++++++-----------------------
 net/mac80211/util.c             |   32 ----------
 15 files changed, 277 insertions(+), 272 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-02-23 14:58:19.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-23 14:59:28.000000000 +0100
@@ -15,9 +15,7 @@
 #include "ieee80211_i.h"
 #include "cfg.h"
 #include "ieee80211_rate.h"
-#ifdef CONFIG_MAC80211_MESH
 #include "mesh.h"
-#endif
 
 #define DEFAULT_RATES 0
 
@@ -119,14 +117,10 @@ static int ieee80211_change_iface(struct
 	ieee80211_if_reinit(dev);
 	ieee80211_if_set_type(dev, itype);
 
-#ifdef CONFIG_MAC80211_MESH
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
-	    params->mesh_id_len) {
-		sdata->u.sta.mesh_id_len = params->mesh_id_len;
-		memcpy(sdata->u.sta.mesh_id, params->mesh_id,
-		       params->mesh_id_len);
-	}
-#endif
+	if (ieee80211_vif_is_mesh(&sdata->vif) && params->mesh_id_len)
+		ieee80211_if_sta_set_mesh_id(&sdata->u.sta,
+					     params->mesh_id_len,
+					     params->mesh_id);
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR || !flags)
 		return 0;
@@ -306,9 +300,7 @@ static int ieee80211_config_default_key(
 
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
-#ifdef CONFIG_MAC80211_MESH
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-#endif
 
 	sinfo->filled = STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
@@ -318,8 +310,8 @@ static void sta_set_sinfo(struct sta_inf
 	sinfo->rx_bytes = sta->rx_bytes;
 	sinfo->tx_bytes = sta->tx_bytes;
 
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
 		sinfo->filled |= STATION_INFO_LLID |
 				 STATION_INFO_PLID |
 				 STATION_INFO_PLINK_STATE;
@@ -327,8 +319,8 @@ static void sta_set_sinfo(struct sta_inf
 		sinfo->llid = le16_to_cpu(sta->llid);
 		sinfo->plid = le16_to_cpu(sta->plid);
 		sinfo->plink_state = sta->plink_state;
-	}
 #endif
+	}
 }
 
 
@@ -569,9 +561,7 @@ static void sta_apply_parameters(struct 
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
-#ifdef CONFIG_MAC80211_MESH
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-#endif
 
 	if (params->station_flags & STATION_FLAG_CHANGED) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
@@ -610,9 +600,7 @@ static void sta_apply_parameters(struct 
 		sta->supp_rates[local->oper_channel->band] = rates;
 	}
 
-#ifdef CONFIG_MAC80211_MESH
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
-	    params->plink_action)
+	if (ieee80211_vif_is_mesh(&sdata->vif) && params->plink_action) {
 		switch (params->plink_action) {
 		case PLINK_ACTION_OPEN:
 			mesh_plink_open(sta);
@@ -621,7 +609,7 @@ static void sta_apply_parameters(struct 
 			mesh_plink_block(sta);
 			break;
 		}
-#endif
+	}
 }
 
 static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
@@ -644,11 +632,9 @@ static int ieee80211_add_station(struct 
 	} else
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-#ifdef CONFIG_MAC80211_MESH
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+	if (ieee80211_vif_is_mesh(&sdata->vif))
 		sta = mesh_plink_add(mac, DEFAULT_RATES, dev);
 	else
-#endif
 		sta = sta_info_add(local, dev, mac, GFP_KERNEL);
 
 	if (IS_ERR(sta))
--- everything.orig/net/mac80211/ieee80211.c	2008-02-23 14:58:20.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-23 14:59:28.000000000 +0100
@@ -26,9 +26,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
-#ifdef CONFIG_MAC80211_MESH
 #include "mesh.h"
-#endif
 #include "wep.h"
 #include "wme.h"
 #include "aes_ccm.h"
@@ -938,11 +936,9 @@ static int __ieee80211_if_config(struct 
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
-#ifdef CONFIG_MAC80211_MESH
-	} else if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		conf.beacon = beacon;
 		ieee80211_start_mesh(dev);
-#endif
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
@@ -1824,10 +1820,9 @@ static void __exit ieee80211_exit(void)
 	rc80211_simple_exit();
 	rc80211_pid_exit();
 
-#ifdef CONFIG_MAC80211_MESH
 	if (mesh_allocated)
 		ieee80211s_stop();
-#endif
+
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
 }
--- everything.orig/net/mac80211/ieee80211_iface.c	2008-02-23 14:57:46.000000000 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2008-02-23 14:59:28.000000000 +0100
@@ -15,9 +15,7 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 #include "debugfs_netdev.h"
-#ifdef CONFIG_MAC80211_MESH
 #include "mesh.h"
-#endif
 
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata)
 {
@@ -82,14 +80,11 @@ int ieee80211_if_add(struct net_device *
 	ieee80211_debugfs_add_netdev(sdata);
 	ieee80211_if_set_type(ndev, type);
 
-#ifdef CONFIG_MAC80211_MESH
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
-	    params && params->mesh_id_len) {
-		sdata->u.sta.mesh_id_len = params->mesh_id_len;
-		memcpy(sdata->u.sta.mesh_id, params->mesh_id,
-		       params->mesh_id_len);
-	}
-#endif
+	if (ieee80211_vif_is_mesh(&sdata->vif) &&
+	    params && params->mesh_id_len)
+		ieee80211_if_sta_set_mesh_id(&sdata->u.sta,
+					     params->mesh_id_len,
+					     params->mesh_id);
 
 	/* we're under RTNL so all this is fine */
 	if (unlikely(local->reg_state == IEEE80211_DEV_UNREGISTERED)) {
@@ -170,47 +165,8 @@ void ieee80211_if_set_type(struct net_de
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
 		sdata->bss = &msdata->u.ap;
 
-#ifdef CONFIG_MAC80211_MESH
-		if (type == IEEE80211_IF_TYPE_MESH_POINT) {
-			ifsta->mshcfg.dot11MeshRetryTimeout = MESH_RET_T;
-			ifsta->mshcfg.dot11MeshConfirmTimeout = MESH_CONF_T;
-			ifsta->mshcfg.dot11MeshHoldingTimeout = MESH_HOLD_T;
-			ifsta->mshcfg.dot11MeshMaxRetries = MESH_MAX_RETR;
-			ifsta->mshcfg.dot11MeshTTL = MESH_TTL;
-			ifsta->mshcfg.auto_open_plinks = true;
-			ifsta->mshcfg.dot11MeshMaxPeerLinks =
-				MESH_MAX_ESTAB_PLINKS;
-			ifsta->mshcfg.dot11MeshHWMPactivePathTimeout =
-				MESH_PATH_TIMEOUT;
-			ifsta->mshcfg.dot11MeshHWMPpreqMinInterval =
-				MESH_PREQ_MIN_INT;
-			ifsta->mshcfg.dot11MeshHWMPnetDiameterTraversalTime =
-				MESH_DIAM_TRAVERSAL_TIME;
-			ifsta->mshcfg.dot11MeshHWMPmaxPREQretries =
-				MESH_MAX_PREQ_RETRIES;
-			ifsta->mshcfg.path_refresh_time =
-				MESH_PATH_REFRESH_TIME;
-			ifsta->mshcfg.min_discovery_timeout =
-				MESH_MIN_DISCOVERY_TIMEOUT;
-			ifsta->accepting_plinks = true;
-			ifsta->preq_id = 0;
-			ifsta->dsn = 0;
-			atomic_set(&ifsta->mpaths, 0);
-			mesh_rmc_init(dev);
-			ifsta->last_preq = jiffies;
-			/* Allocate all mesh structures when creating the first
-			 * mesh interface.
-			 */
-			if (!mesh_allocated)
-				ieee80211s_init();
-			mesh_ids_set_default(ifsta);
-			setup_timer(&ifsta->mesh_path_timer,
-				    ieee80211_mesh_path_timer,
-				    (unsigned long) sdata);
-			INIT_LIST_HEAD(&ifsta->preq_queue.list);
-			spin_lock_init(&ifsta->mesh_preq_queue_lock);
-		}
-#endif
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			ieee80211_mesh_init_sdata(sdata);
 		break;
 	}
 	case IEEE80211_IF_TYPE_MNTR:
@@ -240,6 +196,10 @@ void ieee80211_if_reinit(struct net_devi
 
 	ieee80211_if_sdata_deinit(sdata);
 
+	/* Need to handle mesh specially to allow eliding the function call */
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		mesh_rmc_free(dev);
+
 	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_INVALID:
 		/* cannot happen */
@@ -288,10 +248,6 @@ void ieee80211_if_reinit(struct net_devi
 		}
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
-#ifdef CONFIG_MAC80211_MESH
-		mesh_rmc_free(dev);
-#endif
-		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		kfree(sdata->u.sta.extra_ie);
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-23 14:58:14.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-23 14:59:28.000000000 +0100
@@ -31,9 +31,7 @@
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "ieee80211_led.h"
-#ifdef CONFIG_MAC80211_MESH
 #include "mesh.h"
-#endif
 
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
 #define IEEE80211_AUTH_MAX_TRIES 3
@@ -1896,12 +1894,13 @@ static void __ieee80211_rx_bss_hash_add(
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	u8 hash_idx;
-#ifdef CONFIG_MAC80211_MESH
-	if (bss->mesh_cfg)
-		hash_idx = mesh_id_hash(bss->mesh_id, bss->mesh_id_len);
+
+	if (bss_mesh_cfg(bss))
+		hash_idx = mesh_id_hash(bss_mesh_id(bss),
+					bss_mesh_id_len(bss));
 	else
-#endif
 		hash_idx = STA_HASH(bss->bssid);
+
 	bss->hnext = local->sta_bss_hash[hash_idx];
 	local->sta_bss_hash[hash_idx] = bss;
 }
@@ -1966,7 +1965,8 @@ ieee80211_rx_bss_get(struct net_device *
 	spin_lock_bh(&local->sta_bss_lock);
 	bss = local->sta_bss_hash[STA_HASH(bssid)];
 	while (bss) {
-		if (!bss->mesh_cfg && !memcmp(bss->bssid, bssid, ETH_ALEN) &&
+		if (!bss_mesh_cfg(bss) &&
+		    !memcmp(bss->bssid, bssid, ETH_ALEN) &&
 		    bss->freq == freq &&
 		    bss->ssid_len == ssid_len &&
 		    (ssid_len == 0 || !memcmp(bss->ssid, ssid, ssid_len))) {
@@ -1990,8 +1990,8 @@ ieee80211_rx_mesh_bss_get(struct net_dev
 	spin_lock_bh(&local->sta_bss_lock);
 	bss = local->sta_bss_hash[mesh_id_hash(mesh_id, mesh_id_len)];
 	while (bss) {
-		if (bss->mesh_cfg &&
-		    !memcmp(bss->mesh_cfg, mesh_cfg, MESH_CFG_CMP_LEN) &&
+		if (bss_mesh_cfg(bss) &&
+		    !memcmp(bss_mesh_cfg(bss), mesh_cfg, MESH_CFG_CMP_LEN) &&
 		    bss->freq == freq &&
 		    mesh_id_len == bss->mesh_id_len &&
 		    (mesh_id_len == 0 || !memcmp(bss->mesh_id, mesh_id,
@@ -2052,10 +2052,8 @@ static void ieee80211_rx_bss_free(struct
 	kfree(bss->rsn_ie);
 	kfree(bss->wmm_ie);
 	kfree(bss->ht_ie);
-#ifdef CONFIG_MAC80211_MESH
-	kfree(bss->mesh_id);
-	kfree(bss->mesh_cfg);
-#endif
+	kfree(bss_mesh_id(bss));
+	kfree(bss_mesh_cfg(bss));
 	kfree(bss);
 }
 
@@ -2321,16 +2319,14 @@ static void ieee80211_rx_bss_info(struct
 	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
-#ifdef CONFIG_MAC80211_MESH
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT && elems.mesh_id
-			&& elems.mesh_config)
-		if (mesh_matches_local(&elems, dev)) {
-			u64 rates = ieee80211_sta_get_rates(local, &elems,
-							rx_status->band);
-			mesh_neighbour_update(mgmt->sa, rates, dev,
-				mesh_peer_accepts_plinks(&elems, dev));
-		}
-#endif
+	if (ieee80211_vif_is_mesh(&sdata->vif) && elems.mesh_id &&
+	    elems.mesh_config && mesh_matches_local(&elems, dev)) {
+		u64 rates = ieee80211_sta_get_rates(local, &elems,
+						rx_status->band);
+
+		mesh_neighbour_update(mgmt->sa, rates, dev,
+				      mesh_peer_accepts_plinks(&elems, dev));
+	}
 
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
@@ -2711,9 +2707,7 @@ static void ieee80211_rx_mgmt_action(str
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
 {
-#ifdef CONFIG_MAC80211_MESH
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-#endif
 
 	if (len < IEEE80211_MIN_ACTION_SIZE)
 		return;
@@ -2746,17 +2740,14 @@ static void ieee80211_rx_mgmt_action(str
 			break;
 		}
 		break;
-#ifdef CONFIG_MAC80211_MESH
 	case PLINK_CATEGORY:
-		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+		if (ieee80211_vif_is_mesh(&sdata->vif))
 			mesh_rx_plink_frame(dev, mgmt, len, rx_status);
 		break;
-
 	case MESH_PATH_SEL_CATEGORY:
-		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+		if (ieee80211_vif_is_mesh(&sdata->vif))
 			mesh_rx_path_sel_frame(dev, mgmt, len);
 		break;
-#endif
 	default:
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: Rx unknown action frame - "
@@ -3026,8 +3017,9 @@ void ieee80211_sta_work(struct work_stru
 		ieee80211_sta_rx_queued_mgmt(dev, skb);
 
 #ifdef CONFIG_MAC80211_MESH
-	if (ifsta->preq_queue_len && time_after(jiffies, ifsta->last_preq +
-		msecs_to_jiffies(ifsta->mshcfg.dot11MeshHWMPpreqMinInterval)))
+	if (ifsta->preq_queue_len &&
+	    time_after(jiffies,
+	    	       ifsta->last_preq + msecs_to_jiffies(ifsta->mshcfg.dot11MeshHWMPpreqMinInterval)))
 		mesh_path_start_discovery(dev);
 #endif
 
@@ -3809,13 +3801,11 @@ ieee80211_sta_scan_result(struct net_dev
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWESSID;
-	if (bss->mesh_cfg) {
-#ifdef CONFIG_MAC80211_MESH
-		iwe.u.data.length = bss->mesh_id_len;
+	if (bss_mesh_cfg(bss)) {
+		iwe.u.data.length = bss_mesh_id_len(bss);
 		iwe.u.data.flags = 1;
 		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
-						  bss->mesh_id);
-#endif
+						  bss_mesh_id(bss));
 	} else {
 		iwe.u.data.length = bss->ssid_len;
 		iwe.u.data.flags = 1;
@@ -3824,10 +3814,10 @@ ieee80211_sta_scan_result(struct net_dev
 	}
 
 	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS
-	    || bss->mesh_cfg)) {
+	    || bss_mesh_cfg(bss))) {
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = SIOCGIWMODE;
-		if (bss->mesh_cfg)
+		if (bss_mesh_cfg(bss))
 			iwe.u.mode = IW_MODE_MESH;
 		else if (bss->capability & WLAN_CAPABILITY_ESS)
 			iwe.u.mode = IW_MODE_MASTER;
@@ -3918,9 +3908,9 @@ ieee80211_sta_scan_result(struct net_dev
 		}
 	}
 
-	if (bss->mesh_cfg) {
+	if (bss_mesh_cfg(bss)) {
 		char *buf;
-		u8 *cfg = bss->mesh_cfg;
+		u8 *cfg = bss_mesh_cfg(bss);
 		buf = kmalloc(200, GFP_ATOMIC);
 		if (buf) {
 			memset(&iwe, 0, sizeof(iwe));
--- everything.orig/net/mac80211/mesh_plink.c	2008-02-23 14:58:16.000000000 +0100
+++ everything/net/mac80211/mesh_plink.c	2008-02-23 14:59:28.000000000 +0100
@@ -6,11 +6,11 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
+#include <linux/kernel.h>
+#include <linux/random.h>
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "mesh.h"
-#include <linux/random.h>
 
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 #define mpl_dbg(fmt, args...)	printk(KERN_DEBUG fmt, ##args)
@@ -131,7 +131,7 @@ struct sta_info *mesh_plink_add(u8 *hw_a
 }
 
 /**
- * mesh_plink_deactivate - deactivate mesh peer link
+ * __mesh_plink_deactivate - deactivate mesh peer link
  *
  * @sta: mesh peer link to deactivate
  *
@@ -139,7 +139,7 @@ struct sta_info *mesh_plink_add(u8 *hw_a
  *
  * Locking: the caller must hold sta->plink_lock
  */
-void mesh_plink_deactivate(struct sta_info *sta)
+static void __mesh_plink_deactivate(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sta->plink_state == ESTAB)
@@ -148,6 +148,20 @@ void mesh_plink_deactivate(struct sta_in
 	mesh_path_flush_by_nexthop(sta);
 }
 
+/**
+ * __mesh_plink_deactivate - deactivate mesh peer link
+ *
+ * @sta: mesh peer link to deactivate
+ *
+ * All mesh paths with this peer as next hop will be flushed
+ */
+void mesh_plink_deactivate(struct sta_info *sta)
+{
+	spin_lock_bh(&sta->plink_lock);
+	__mesh_plink_deactivate(sta);
+	spin_unlock_bh(&sta->plink_lock);
+}
+
 static int mesh_plink_frame_tx(struct net_device *dev,
 		enum plink_frame_type action, u8 *da, __le16 llid, __le16 plid,
 		__le16 reason) {
@@ -365,7 +379,7 @@ void mesh_plink_block(struct sta_info *s
 #endif
 
 	spin_lock_bh(&sta->plink_lock);
-	mesh_plink_deactivate(sta);
+	__mesh_plink_deactivate(sta);
 	sta->plink_state = BLOCKED;
 	spin_unlock_bh(&sta->plink_lock);
 }
@@ -390,7 +404,7 @@ int mesh_plink_close(struct sta_info *st
 		sta_info_put(sta);
 		return 0;
 	} else if (sta->plink_state == ESTAB) {
-		mesh_plink_deactivate(sta);
+		__mesh_plink_deactivate(sta);
 		/* The timer should not be running */
 		if (!mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata)))
 			__sta_info_get(sta);
@@ -699,7 +713,7 @@ void mesh_rx_plink_frame(struct net_devi
 		case CLS_ACPT:
 			reason = cpu_to_le16(MESH_CLOSE_RCVD);
 			sta->reason = reason;
-			mesh_plink_deactivate(sta);
+			__mesh_plink_deactivate(sta);
 			sta->plink_state = HOLDING;
 			llid = sta->llid;
 			if (!mod_plink_timer(sta,
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-02-23 14:57:45.000000000 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-02-23 14:59:28.000000000 +0100
@@ -15,10 +15,7 @@
 #include <linux/debugfs.h>
 #include <net/mac80211.h>
 #include "ieee80211_rate.h"
-#ifdef CONFIG_MAC80211_MESH
 #include "mesh.h"
-#endif
-
 #include "rc80211_pid.h"
 
 
--- everything.orig/net/mac80211/rx.c	2008-02-23 14:57:45.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-02-23 14:59:28.000000000 +0100
@@ -20,9 +20,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
-#ifdef CONFIG_MAC80211_MESH
 #include "mesh.h"
-#endif
 #include "wep.h"
 #include "wpa.h"
 #include "tkip.h"
@@ -439,6 +437,13 @@ ieee80211_rx_mesh_check(struct ieee80211
 	else
 		return RX_CONTINUE;
 }
+#undef msh_h_get
+#else
+static inline ieee80211_rx_result
+ieee80211_rx_mesh_check(struct ieee80211_txrx_data *rx)
+{
+	return RX_CONTINUE;
+}
 #endif
 
 
@@ -477,10 +482,8 @@ ieee80211_rx_h_check(struct ieee80211_tx
 	 * responsible for filtering on both auth and assoc states.
 	 */
 
-#ifdef CONFIG_MAC80211_MESH
-	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+	if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 		return ieee80211_rx_mesh_check(rx);
-#endif
 
 	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
 		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
@@ -1111,8 +1114,7 @@ ieee80211_data_to_8023(struct ieee80211_
 
 	hdrlen = ieee80211_get_hdrlen(fc);
 
-#ifdef CONFIG_MAC80211_MESH
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		int meshhdrlen = ieee80211_get_mesh_hdrlen(
 				(struct ieee80211s_hdr *) (skb->data + hdrlen));
 		/* Copy on cb:
@@ -1126,7 +1128,6 @@ ieee80211_data_to_8023(struct ieee80211_
 		memcpy(MESH_PREQ(skb), hdr->addr2, ETH_ALEN);
 		hdrlen += meshhdrlen;
 	}
-#endif
 
 	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
 	 * header
@@ -1306,9 +1307,8 @@ ieee80211_deliver_skb(struct ieee80211_t
 		}
 	}
 
-#ifdef CONFIG_MAC80211_MESH
 	/* Mesh forwarding */
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		u8 *mesh_ttl = &((struct ieee80211s_hdr *)skb->cb)->ttl;
 		(*mesh_ttl)--;
 
@@ -1321,12 +1321,13 @@ ieee80211_deliver_skb(struct ieee80211_t
 				else
 					xmit_skb->pkt_type = PACKET_OTHERHOST;
 			} else
-				sdata->u.sta.mshstats.dropped_frames_ttl++;
-
+				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.sta,
+							     dropped_frames_ttl);
 		} else if (skb->pkt_type != PACKET_OTHERHOST &&
 			compare_ether_addr(dev->dev_addr, skb->data) != 0) {
 			if (*mesh_ttl == 0) {
-				sdata->u.sta.mshstats.dropped_frames_ttl++;
+				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.sta,
+							     dropped_frames_ttl);
 				dev_kfree_skb(skb);
 				skb = NULL;
 			} else {
@@ -1337,7 +1338,6 @@ ieee80211_deliver_skb(struct ieee80211_t
 			}
 		}
 	}
-#endif
 
 	if (skb) {
 		/* deliver to local stack */
--- everything.orig/net/mac80211/sta_info.c	2008-02-23 14:57:46.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-23 14:59:28.000000000 +0100
@@ -21,9 +21,7 @@
 #include "ieee80211_rate.h"
 #include "sta_info.h"
 #include "debugfs_sta.h"
-#ifdef CONFIG_MAC80211_MESH
 #include "mesh.h"
-#endif
 
 /* Caller must hold local->sta_lock */
 static void sta_info_hash_add(struct ieee80211_local *local,
@@ -309,10 +307,8 @@ void sta_info_remove(struct sta_info *st
 	}
 	local->num_sta--;
 
-#ifdef CONFIG_MAC80211_MESH
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata->dev);
-#endif
 }
 
 void sta_info_free(struct sta_info *sta)
@@ -329,13 +325,8 @@ void sta_info_free(struct sta_info *sta)
 	sta_info_remove(sta);
 	write_unlock_bh(&local->sta_lock);
 
-#ifdef CONFIG_MAC80211_MESH
-	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
-		spin_lock_bh(&sta->plink_lock);
+	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_plink_deactivate(sta);
-		spin_unlock_bh(&sta->plink_lock);
-	}
-#endif
 
 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
 		local->total_ps_buffered--;
--- everything.orig/net/mac80211/tx.c	2008-02-23 14:57:45.000000000 +0100
+++ everything/net/mac80211/tx.c	2008-02-23 14:59:28.000000000 +0100
@@ -26,9 +26,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
-#ifdef CONFIG_MAC80211_MESH
 #include "mesh.h"
-#endif
 #include "wep.h"
 #include "wpa.h"
 #include "wme.h"
@@ -1460,7 +1458,7 @@ int ieee80211_subif_start_xmit(struct sk
 				goto fail;
 			}
 			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
-					sdata);
+							       sdata);
 		}
 		hdrlen = 30;
 		break;
@@ -1778,40 +1776,6 @@ static void ieee80211_beacon_add_tim(str
 	read_unlock_bh(&local->sta_lock);
 }
 
-#ifdef CONFIG_MAC80211_MESH
-static struct sk_buff *ieee80211_mesh_beacon_get(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
-	struct ieee80211_mgmt *mgmt;
-	u8 *pos;
-
-	if (!skb)
-		return NULL;
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-	mgmt = (struct ieee80211_mgmt *)
-		skb_put(skb, 24 + sizeof(mgmt->u.beacon));
-	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_BEACON);
-	memset(mgmt->da, 0xff, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-	/* BSSID is left zeroed, wildcard value */
-	mgmt->u.beacon.beacon_int =
-		cpu_to_le16(local->hw.conf.beacon_int);
-	mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
-
-	pos = skb_put(skb, 2);
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = 0x0;
-
-	mesh_mgmt_ies_add(skb, dev);
-
-	return skb;
-}
-#endif
-
-
 struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_tx_control *control)
@@ -1824,8 +1788,10 @@ struct sk_buff *ieee80211_beacon_get(str
 	struct rate_selection rsel;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_mgmt *mgmt;
 	int *num_beacons;
-	int err = 0;
+	bool err = true;
+	u8 *pos;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
@@ -1834,47 +1800,65 @@ struct sk_buff *ieee80211_beacon_get(str
 	sdata = vif_to_sdata(vif);
 	bdev = sdata->dev;
 
-	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_AP:
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		ap = &sdata->u.ap;
 		beacon = rcu_dereference(ap->beacon);
-		if (!ap || !beacon) {
-			err = -1;
-			break;
-		}
+		if (ap && beacon) {
+			/*
+			 * headroom, head length,
+			 * tail length and maximum TIM length
+			 */
+			skb = dev_alloc_skb(local->tx_headroom +
+					    beacon->head_len +
+					    beacon->tail_len + 256);
+			if (!skb)
+				goto out;
 
-		/* headroom, head length, tail length and maximum TIM length */
-		skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
-				    beacon->tail_len + 256);
-		if (!skb)
-			goto out;
+			skb_reserve(skb, local->tx_headroom);
+			memcpy(skb_put(skb, beacon->head_len), beacon->head,
+			       beacon->head_len);
 
-		skb_reserve(skb, local->tx_headroom);
-		memcpy(skb_put(skb, beacon->head_len), beacon->head,
-		       beacon->head_len);
+			ieee80211_include_sequence(sdata,
+					(struct ieee80211_hdr *)skb->data);
 
-		ieee80211_include_sequence(sdata,
-					   (struct ieee80211_hdr *)skb->data);
+			ieee80211_beacon_add_tim(local, ap, skb, beacon);
 
-		ieee80211_beacon_add_tim(local, ap, skb, beacon);
+			if (beacon->tail)
+				memcpy(skb_put(skb, beacon->tail_len),
+				       beacon->tail, beacon->tail_len);
 
-		if (beacon->tail)
-			memcpy(skb_put(skb, beacon->tail_len), beacon->tail,
-			       beacon->tail_len);
+			num_beacons = &ap->num_beacons;
 
-		num_beacons = &ap->num_beacons;
-		break;
+			err = false;
+		}
+	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		/* headroom, head length, tail length and maximum TIM length */
+		skb = dev_alloc_skb(local->tx_headroom + 400);
+		if (!skb)
+			goto out;
+
+		skb_reserve(skb, local->hw.extra_tx_headroom);
+		mgmt = (struct ieee80211_mgmt *)
+			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
+		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
+		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+						   IEEE80211_STYPE_BEACON);
+		memset(mgmt->da, 0xff, ETH_ALEN);
+		memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+		/* BSSID is left zeroed, wildcard value */
+		mgmt->u.beacon.beacon_int =
+			cpu_to_le16(local->hw.conf.beacon_int);
+		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
+
+		pos = skb_put(skb, 2);
+		*pos++ = WLAN_EID_SSID;
+		*pos++ = 0x0;
+
+		mesh_mgmt_ies_add(skb, sdata->dev);
 
-#ifdef CONFIG_MAC80211_MESH
-	case IEEE80211_IF_TYPE_MESH_POINT:
-		skb = ieee80211_mesh_beacon_get(bdev);
 		num_beacons = &sdata->u.sta.num_beacons;
-		break;
-#endif
 
-	default:
-		err = -1;
-		break;
+		err = false;
 	}
 
 	if (err) {
--- everything.orig/net/mac80211/util.c	2008-02-23 14:57:45.000000000 +0100
+++ everything/net/mac80211/util.c	2008-02-23 14:59:28.000000000 +0100
@@ -26,9 +26,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
-#ifdef CONFIG_MAC80211_MESH
 #include "mesh.h"
-#endif
 #include "wme.h"
 
 /* privid for wiphys to determine whether they belong to us or not */
@@ -149,7 +147,6 @@ int ieee80211_get_hdrlen_from_skb(const 
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
-#ifdef CONFIG_MAC80211_MESH
 int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 {
 	int ae = meshhdr->flags & IEEE80211S_FLAGS_AE;
@@ -167,7 +164,6 @@ int ieee80211_get_mesh_hdrlen(struct iee
 		return 5;
 	}
 }
-#endif
 
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx)
 {
@@ -418,31 +414,3 @@ void ieee80211_iterate_active_interfaces
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
-
-#ifdef CONFIG_MAC80211_MESH
-/**
- * ieee80211_new_mesh_header - create a new mesh header
- * @meshhdr:    uninitialized mesh header
- * @sdata:	mesh interface to be used
- *
- * Return the header length.
- */
-int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
-		struct ieee80211_sub_if_data *sdata)
-{
-	meshhdr->flags = 0;
-	meshhdr->ttl = sdata->u.sta.mshcfg.dot11MeshTTL;
-
-	meshhdr->seqnum[0] = sdata->u.sta.mesh_seqnum[0]++;
-	meshhdr->seqnum[1] = sdata->u.sta.mesh_seqnum[1];
-	meshhdr->seqnum[2] = sdata->u.sta.mesh_seqnum[2];
-
-	if (sdata->u.sta.mesh_seqnum[0] == 0) {
-		sdata->u.sta.mesh_seqnum[1]++;
-		if (sdata->u.sta.mesh_seqnum[1] == 0)
-			sdata->u.sta.mesh_seqnum[2]++;
-	}
-
-	return 5;
-}
-#endif
--- everything.orig/net/mac80211/ieee80211_i.h	2008-02-23 14:58:05.000000000 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-02-23 14:59:45.000000000 +0100
@@ -93,9 +93,8 @@ struct ieee80211_sta_bss {
 #ifdef CONFIG_MAC80211_MESH
 	u8 *mesh_id;
 	size_t mesh_id_len;
-#endif
-	/* mesh_cfg left out the ifdef to reduce clutter on bss handling */
 	u8 *mesh_cfg;
+#endif
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	size_t supp_rates_len;
@@ -113,6 +112,30 @@ struct ieee80211_sta_bss {
 	u8 erp_value;
 };
 
+static inline u8 *bss_mesh_cfg(struct ieee80211_sta_bss *bss)
+{
+#ifdef CONFIG_MAC80211_MESH
+	return bss->mesh_cfg;
+#endif
+	return NULL;
+}
+
+static inline u8 *bss_mesh_id(struct ieee80211_sta_bss *bss)
+{
+#ifdef CONFIG_MAC80211_MESH
+	return bss->mesh_id;
+#endif
+	return NULL;
+}
+
+static inline u8 bss_mesh_id_len(struct ieee80211_sta_bss *bss)
+{
+#ifdef CONFIG_MAC80211_MESH
+	return bss->mesh_id_len;
+#endif
+	return 0;
+}
+
 
 typedef unsigned __bitwise__ ieee80211_tx_result;
 #define TX_CONTINUE	((__force ieee80211_tx_result) 0u)
@@ -233,7 +256,6 @@ struct ieee80211_if_vlan {
 	struct list_head list;
 };
 
-#ifdef CONFIG_MAC80211_MESH
 struct mesh_stats {
 	__u32 fwded_frames;		/* Mesh forwarded frames */
 	__u32 dropped_frames_ttl;	/* Not transmitted since mesh_ttl == 0*/
@@ -249,7 +271,6 @@ struct mesh_preq_queue {
 	u8 flags;
 };
 
-
 struct mesh_config {
 	/* Timeouts in ms */
 	/* Mesh plink management parameters */
@@ -268,7 +289,7 @@ struct mesh_config {
 	u32 path_refresh_time;
 	u16 min_discovery_timeout;
 };
-#endif
+
 
 /* flags used in struct ieee80211_if_sta.flags */
 #define IEEE80211_STA_SSID_SET		BIT(0)
@@ -361,6 +382,22 @@ struct ieee80211_if_sta {
 	int num_beacons; /* number of TXed beacon frames by this STA */
 };
 
+static inline void ieee80211_if_sta_set_mesh_id(struct ieee80211_if_sta *ifsta,
+						u8 mesh_id_len, u8 *mesh_id)
+{
+#ifdef CONFIG_MAC80211_MESH
+	ifsta->mesh_id_len = mesh_id_len;
+	memcpy(ifsta->mesh_id, mesh_id, mesh_id_len);
+#endif
+}
+
+#ifdef CONFIG_MAC80211_MESH
+#define IEEE80211_IFSTA_MESH_CTR_INC(sta, name)	\
+	do { (sta)->mshstats.name++; } while (0)
+#else
+#define IEEE80211_IFSTA_MESH_CTR_INC(sta, name) \
+	do { } while (0)
+#endif
 
 /* flags used in struct ieee80211_sub_if_data.flags */
 #define IEEE80211_SDATA_ALLMULTI	BIT(0)
@@ -472,7 +509,7 @@ struct ieee80211_sub_if_data {
 		struct dentry *dropped_frames_ttl;
 		struct dentry *dropped_frames_no_route;
 		struct dentry *estab_plinks;
-	struct timer_list mesh_path_timer;
+		struct timer_list mesh_path_timer;
 	} mesh_stats;
 
 	struct dentry *mesh_config_dir;
@@ -884,12 +921,17 @@ void sta_addba_resp_timer_expired(unsign
 u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
-void ieee80211_start_mesh(struct net_device *dev);
 void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb,
 		int encrypt);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 				   struct ieee802_11_elems *elems);
 
+#ifdef CONFIG_MAC80211_MESH
+void ieee80211_start_mesh(struct net_device *dev);
+#else
+static inline void ieee80211_start_mesh(struct net_device *dev)
+{}
+#endif
 
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
--- everything.orig/net/mac80211/mesh.h	2008-02-23 14:57:45.000000000 +0100
+++ everything/net/mac80211/mesh.h	2008-02-23 14:59:28.000000000 +0100
@@ -11,10 +11,10 @@
 #ifndef IEEE80211S_H
 #define IEEE80211S_H
 
-#include "ieee80211_i.h"
+#include <linux/types.h>
 #include <linux/jhash.h>
+#include "ieee80211_i.h"
 
-extern int mesh_allocated;
 
 /* Data structures */
 
@@ -211,6 +211,8 @@ void mesh_rmc_free(struct net_device *de
 int mesh_rmc_init(struct net_device *dev);
 void ieee80211s_init(void);
 void ieee80211s_stop(void);
+void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
+
 /* Mesh paths */
 int mesh_nexthop_lookup(u8 *next_hop, struct sk_buff *skb,
 		struct net_device *dev);
@@ -257,6 +259,9 @@ void mesh_path_timer(unsigned long data)
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
 void mesh_path_discard_frame(struct sk_buff *skb, struct net_device *dev);
 
+#ifdef CONFIG_MAC80211_MESH
+extern int mesh_allocated;
+
 static inline int mesh_plink_free_count(struct ieee80211_sub_if_data *sdata)
 {
 	return sdata->u.sta.mshcfg.dot11MeshMaxPeerLinks -
@@ -278,6 +283,10 @@ static inline void mesh_path_activate(st
 	for (i = 0; i <= x->hash_mask; i++) \
 		hlist_for_each_entry_rcu(node, p, &x->hash_buckets[i], list)
 
+#else
+#define mesh_allocated	0
+#endif
+
 #define MESH_PREQ(skb)	(skb->cb + 30)
 
 #endif /* IEEE80211S_H */
--- everything.orig/include/net/mac80211.h	2008-02-23 14:57:45.000000000 +0100
+++ everything/include/net/mac80211.h	2008-02-23 14:59:28.000000000 +0100
@@ -461,6 +461,14 @@ struct ieee80211_vif {
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
+static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
+{
+#ifdef CONFIG_MAC80211_MESH
+	return vif->type == IEEE80211_IF_TYPE_MESH_POINT;
+#endif
+	return false;
+}
+
 /**
  * struct ieee80211_if_init_conf - initial configuration of an interface
  *
--- everything.orig/net/mac80211/sta_info.h	2008-02-23 14:57:45.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-23 14:59:28.000000000 +0100
@@ -107,7 +107,6 @@ struct tid_ampdu_rx {
 	struct timer_list session_timer;
 };
 
-#ifdef CONFIG_MAC80211_MESH
 enum plink_state {
 	LISTEN,
 	OPN_SNT,
@@ -117,7 +116,6 @@ enum plink_state {
 	HOLDING,
 	BLOCKED
 };
-#endif
 
 /**
  * struct sta_ampdu_mlme - STA aggregation information.
--- everything.orig/net/mac80211/mesh.c	2008-02-23 14:57:45.000000000 +0100
+++ everything/net/mac80211/mesh.c	2008-02-23 14:59:28.000000000 +0100
@@ -381,3 +381,70 @@ endgrow:
 	else
 		return newtbl;
 }
+
+/**
+ * ieee80211_new_mesh_header - create a new mesh header
+ * @meshhdr:    uninitialized mesh header
+ * @sdata:	mesh interface to be used
+ *
+ * Return the header length.
+ */
+int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
+		struct ieee80211_sub_if_data *sdata)
+{
+	meshhdr->flags = 0;
+	meshhdr->ttl = sdata->u.sta.mshcfg.dot11MeshTTL;
+
+	meshhdr->seqnum[0] = sdata->u.sta.mesh_seqnum[0]++;
+	meshhdr->seqnum[1] = sdata->u.sta.mesh_seqnum[1];
+	meshhdr->seqnum[2] = sdata->u.sta.mesh_seqnum[2];
+
+	if (sdata->u.sta.mesh_seqnum[0] == 0) {
+		sdata->u.sta.mesh_seqnum[1]++;
+		if (sdata->u.sta.mesh_seqnum[1] == 0)
+			sdata->u.sta.mesh_seqnum[2]++;
+	}
+
+	return 5;
+}
+
+void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+
+	ifsta->mshcfg.dot11MeshRetryTimeout = MESH_RET_T;
+	ifsta->mshcfg.dot11MeshConfirmTimeout = MESH_CONF_T;
+	ifsta->mshcfg.dot11MeshHoldingTimeout = MESH_HOLD_T;
+	ifsta->mshcfg.dot11MeshMaxRetries = MESH_MAX_RETR;
+	ifsta->mshcfg.dot11MeshTTL = MESH_TTL;
+	ifsta->mshcfg.auto_open_plinks = true;
+	ifsta->mshcfg.dot11MeshMaxPeerLinks =
+		MESH_MAX_ESTAB_PLINKS;
+	ifsta->mshcfg.dot11MeshHWMPactivePathTimeout =
+		MESH_PATH_TIMEOUT;
+	ifsta->mshcfg.dot11MeshHWMPpreqMinInterval =
+		MESH_PREQ_MIN_INT;
+	ifsta->mshcfg.dot11MeshHWMPnetDiameterTraversalTime =
+		MESH_DIAM_TRAVERSAL_TIME;
+	ifsta->mshcfg.dot11MeshHWMPmaxPREQretries =
+		MESH_MAX_PREQ_RETRIES;
+	ifsta->mshcfg.path_refresh_time =
+		MESH_PATH_REFRESH_TIME;
+	ifsta->mshcfg.min_discovery_timeout =
+		MESH_MIN_DISCOVERY_TIMEOUT;
+	ifsta->accepting_plinks = true;
+	ifsta->preq_id = 0;
+	ifsta->dsn = 0;
+	atomic_set(&ifsta->mpaths, 0);
+	mesh_rmc_init(sdata->dev);
+	ifsta->last_preq = jiffies;
+	/* Allocate all mesh structures when creating the first mesh interface. */
+	if (!mesh_allocated)
+		ieee80211s_init();
+	mesh_ids_set_default(ifsta);
+	setup_timer(&ifsta->mesh_path_timer,
+		    ieee80211_mesh_path_timer,
+		    (unsigned long) sdata);
+	INIT_LIST_HEAD(&ifsta->preq_queue.list);
+	spin_lock_init(&ifsta->mesh_preq_queue_lock);
+}

-- 

