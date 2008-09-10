Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYIJWPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:15:09 -0400
Message-Id: <20080910220422.683382000@sipsolutions.net> (sfid-20080911_001522_618208_FD2D3B95)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:58 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/18] mac80211: use nl80211 interface types
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's really no reason for mac80211 to be using its
own interface type defines. Use the nl80211 types and
simplify the configuration code a bit: there's no need
to translate them any more now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/adm8211.c              |   22 +++---
 drivers/net/wireless/at76_usb.c             |    2 
 drivers/net/wireless/ath5k/ath5k.h          |    4 -
 drivers/net/wireless/ath5k/attach.c         |    2 
 drivers/net/wireless/ath5k/base.c           |   50 +++++++--------
 drivers/net/wireless/ath5k/base.h           |    2 
 drivers/net/wireless/ath5k/pcu.c            |   12 +--
 drivers/net/wireless/ath5k/reset.c          |    2 
 drivers/net/wireless/ath9k/main.c           |   28 ++++----
 drivers/net/wireless/b43/main.c             |   38 +++++------
 drivers/net/wireless/b43/phy_common.c       |    4 -
 drivers/net/wireless/b43legacy/main.c       |   30 ++++-----
 drivers/net/wireless/b43legacy/phy.c        |    4 -
 drivers/net/wireless/ipw2100.c              |    2 
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    6 -
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   64 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    8 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    4 -
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   20 +++---
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   84 +++++++++++++-------------
 drivers/net/wireless/libertas_tf/main.c     |   18 ++---
 drivers/net/wireless/mac80211_hwsim.c       |    2 
 drivers/net/wireless/p54/p54common.c        |   14 ++--
 drivers/net/wireless/p54/p54pci.c           |    4 -
 drivers/net/wireless/rt2x00/rt2500usb.c     |    2 
 drivers/net/wireless/rt2x00/rt2x00.h        |    2 
 drivers/net/wireless/rt2x00/rt2x00config.c  |    8 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    8 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h     |    2 
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   18 ++---
 drivers/net/wireless/rtl8180_dev.c          |   10 +--
 drivers/net/wireless/rtl8187_dev.c          |    8 +-
 drivers/net/wireless/zd1211rw/zd_mac.c      |   20 +++---
 include/net/mac80211.h                      |   35 +----------
 net/mac80211/cfg.c                          |   57 +++++++----------
 net/mac80211/debugfs_netdev.c               |   28 ++++----
 net/mac80211/ht.c                           |    6 -
 net/mac80211/ieee80211_i.h                  |    6 -
 net/mac80211/iface.c                        |   40 ++++++------
 net/mac80211/key.c                          |    6 -
 net/mac80211/main.c                         |   89 +++++++++++++---------------
 net/mac80211/mlme.c                         |   40 ++++++------
 net/mac80211/rx.c                           |   65 ++++++++++----------
 net/mac80211/scan.c                         |    8 +-
 net/mac80211/sta_info.c                     |    4 -
 net/mac80211/tx.c                           |   28 ++++----
 net/mac80211/util.c                         |   44 +++++++------
 net/mac80211/wext.c                         |   84 +++++++++++++-------------
 55 files changed, 519 insertions(+), 553 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-09-10 23:58:03.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-10 23:58:04.000000000 +0200
@@ -478,33 +478,6 @@ struct ieee80211_conf {
 };
 
 /**
- * enum ieee80211_if_types - types of 802.11 network interfaces
- *
- * @IEEE80211_IF_TYPE_INVALID: invalid interface type, not used
- *	by mac80211 itself
- * @IEEE80211_IF_TYPE_AP: interface in AP mode.
- * @IEEE80211_IF_TYPE_MGMT: special interface for communication with hostap
- *	daemon. Drivers should never see this type.
- * @IEEE80211_IF_TYPE_STA: interface in STA (client) mode.
- * @IEEE80211_IF_TYPE_IBSS: interface in IBSS (ad-hoc) mode.
- * @IEEE80211_IF_TYPE_MNTR: interface in monitor (rfmon) mode.
- * @IEEE80211_IF_TYPE_WDS: interface in WDS mode.
- * @IEEE80211_IF_TYPE_VLAN: VLAN interface bound to an AP, drivers
- *	will never see this type.
- * @IEEE80211_IF_TYPE_MESH_POINT: 802.11s mesh point
- */
-enum ieee80211_if_types {
-	IEEE80211_IF_TYPE_INVALID,
-	IEEE80211_IF_TYPE_AP,
-	IEEE80211_IF_TYPE_STA,
-	IEEE80211_IF_TYPE_IBSS,
-	IEEE80211_IF_TYPE_MESH_POINT,
-	IEEE80211_IF_TYPE_MNTR,
-	IEEE80211_IF_TYPE_WDS,
-	IEEE80211_IF_TYPE_VLAN,
-};
-
-/**
  * struct ieee80211_vif - per-interface data
  *
  * Data in this structure is continually present for driver
@@ -515,7 +488,7 @@ enum ieee80211_if_types {
  *	sizeof(void *).
  */
 struct ieee80211_vif {
-	enum ieee80211_if_types type;
+	enum nl80211_iftype type;
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
@@ -523,7 +496,7 @@ struct ieee80211_vif {
 static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
 {
 #ifdef CONFIG_MAC80211_MESH
-	return vif->type == IEEE80211_IF_TYPE_MESH_POINT;
+	return vif->type == NL80211_IFTYPE_MESH_POINT;
 #endif
 	return false;
 }
@@ -534,7 +507,7 @@ static inline bool ieee80211_vif_is_mesh
  * @vif: pointer to a driver-use per-interface structure. The pointer
  *	itself is also used for various functions including
  *	ieee80211_beacon_get() and ieee80211_get_buffered_bc().
- * @type: one of &enum ieee80211_if_types constants. Determines the type of
+ * @type: one of &enum nl80211_iftype constants. Determines the type of
  *	added/removed interface.
  * @mac_addr: pointer to MAC address of the interface. This pointer is valid
  *	until the interface is removed (i.e. it cannot be used after
@@ -550,7 +523,7 @@ static inline bool ieee80211_vif_is_mesh
  * in pure monitor mode.
  */
 struct ieee80211_if_init_conf {
-	enum ieee80211_if_types type;
+	enum nl80211_iftype type;
 	struct ieee80211_vif *vif;
 	void *mac_addr;
 };
--- everything.orig/net/mac80211/cfg.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-10 23:58:04.000000000 +0200
@@ -17,26 +17,19 @@
 #include "rate.h"
 #include "mesh.h"
 
-static enum ieee80211_if_types
-nl80211_type_to_mac80211_type(enum nl80211_iftype type)
+static bool nl80211_type_check(enum nl80211_iftype type)
 {
 	switch (type) {
-	case NL80211_IFTYPE_UNSPECIFIED:
-		return IEEE80211_IF_TYPE_STA;
 	case NL80211_IFTYPE_ADHOC:
-		return IEEE80211_IF_TYPE_IBSS;
 	case NL80211_IFTYPE_STATION:
-		return IEEE80211_IF_TYPE_STA;
 	case NL80211_IFTYPE_MONITOR:
-		return IEEE80211_IF_TYPE_MNTR;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
-		return IEEE80211_IF_TYPE_MESH_POINT;
 #endif
 	case NL80211_IFTYPE_WDS:
-		return IEEE80211_IF_TYPE_WDS;
+		return true;
 	default:
-		return IEEE80211_IF_TYPE_INVALID;
+		return false;
 	}
 }
 
@@ -45,17 +38,15 @@ static int ieee80211_add_iface(struct wi
 			       struct vif_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
-	enum ieee80211_if_types itype;
 	struct net_device *dev;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 
-	itype = nl80211_type_to_mac80211_type(type);
-	if (itype == IEEE80211_IF_TYPE_INVALID)
+	if (!nl80211_type_check(type))
 		return -EINVAL;
 
-	err = ieee80211_if_add(local, name, &dev, itype, params);
-	if (err || itype != IEEE80211_IF_TYPE_MNTR || !flags)
+	err = ieee80211_if_add(local, name, &dev, type, params);
+	if (err || type != NL80211_IFTYPE_MONITOR || !flags)
 		return err;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -86,7 +77,6 @@ static int ieee80211_change_iface(struct
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
-	enum ieee80211_if_types itype;
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
 
@@ -95,8 +85,7 @@ static int ieee80211_change_iface(struct
 	if (!dev)
 		return -ENODEV;
 
-	itype = nl80211_type_to_mac80211_type(type);
-	if (itype == IEEE80211_IF_TYPE_INVALID)
+	if (!nl80211_type_check(type))
 		return -EINVAL;
 
 	if (dev == local->mdev)
@@ -104,7 +93,7 @@ static int ieee80211_change_iface(struct
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	ret = ieee80211_if_change_type(sdata, itype);
+	ret = ieee80211_if_change_type(sdata, type);
 	if (ret)
 		return ret;
 
@@ -113,7 +102,7 @@ static int ieee80211_change_iface(struct
 					    params->mesh_id_len,
 					    params->mesh_id);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR || !flags)
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR || !flags)
 		return 0;
 
 	sdata->u.mntr_flags = *flags;
@@ -509,7 +498,7 @@ static int ieee80211_add_beacon(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EINVAL;
 
 	old = sdata->u.ap.beacon;
@@ -532,7 +521,7 @@ static int ieee80211_set_beacon(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EINVAL;
 
 	old = sdata->u.ap.beacon;
@@ -554,7 +543,7 @@ static int ieee80211_del_beacon(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EINVAL;
 
 	old = sdata->u.ap.beacon;
@@ -709,8 +698,8 @@ static int ieee80211_add_station(struct 
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
-		if (sdata->vif.type != IEEE80211_IF_TYPE_VLAN &&
-		    sdata->vif.type != IEEE80211_IF_TYPE_AP)
+		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type != NL80211_IFTYPE_AP)
 			return -EINVAL;
 	} else
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -740,8 +729,8 @@ static int ieee80211_add_station(struct 
 		return err;
 	}
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+	    sdata->vif.type == NL80211_IFTYPE_AP)
 		ieee80211_send_layer2_update(sta);
 
 	rcu_read_unlock();
@@ -805,8 +794,8 @@ static int ieee80211_change_station(stru
 	if (params->vlan && params->vlan != sta->sdata->dev) {
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
-		if (vlansdata->vif.type != IEEE80211_IF_TYPE_VLAN &&
-		    vlansdata->vif.type != IEEE80211_IF_TYPE_AP) {
+		if (vlansdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    vlansdata->vif.type != NL80211_IFTYPE_AP) {
 			rcu_read_unlock();
 			return -EINVAL;
 		}
@@ -840,7 +829,7 @@ static int ieee80211_add_mpath(struct wi
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
 		return -ENOTSUPP;
 
 	rcu_read_lock();
@@ -896,7 +885,7 @@ static int ieee80211_change_mpath(struct
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
 		return -ENOTSUPP;
 
 	rcu_read_lock();
@@ -971,7 +960,7 @@ static int ieee80211_get_mpath(struct wi
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
 		return -ENOTSUPP;
 
 	rcu_read_lock();
@@ -999,7 +988,7 @@ static int ieee80211_dump_mpath(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
 		return -ENOTSUPP;
 
 	rcu_read_lock();
@@ -1028,7 +1017,7 @@ static int ieee80211_change_bss(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EINVAL;
 
 	if (params->use_cts_prot >= 0) {
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-09-10 23:58:04.000000000 +0200
@@ -345,26 +345,26 @@ static void add_files(struct ieee80211_s
 		return;
 
 	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT:
 #ifdef CONFIG_MAC80211_MESH
 		add_mesh_stats(sdata);
 		add_mesh_config(sdata);
 #endif
 		break;
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		add_sta_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		add_ap_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_WDS:
+	case NL80211_IFTYPE_WDS:
 		add_wds_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		add_monitor_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
+	case NL80211_IFTYPE_AP_VLAN:
 		add_vlan_files(sdata);
 		break;
 	default:
@@ -482,26 +482,26 @@ static void del_files(struct ieee80211_s
 		return;
 
 	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT:
 #ifdef CONFIG_MAC80211_MESH
 		del_mesh_stats(sdata);
 		del_mesh_config(sdata);
 #endif
 		break;
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		del_sta_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		del_ap_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_WDS:
+	case NL80211_IFTYPE_WDS:
 		del_wds_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		del_monitor_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
+	case NL80211_IFTYPE_AP_VLAN:
 		del_vlan_files(sdata);
 		break;
 	default:
--- everything.orig/net/mac80211/ht.c	2008-09-10 23:50:20.000000000 +0200
+++ everything/net/mac80211/ht.c	2008-09-10 23:58:04.000000000 +0200
@@ -89,7 +89,7 @@ static void ieee80211_send_addba_request
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
@@ -139,7 +139,7 @@ static void ieee80211_send_addba_resp(st
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
@@ -185,7 +185,7 @@ static void ieee80211_send_delba(struct 
 	memset(mgmt, 0, 24);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
--- everything.orig/net/mac80211/iface.c	2008-09-10 23:58:03.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-09-10 23:58:04.000000000 +0200
@@ -41,7 +41,7 @@ static void ieee80211_teardown_sdata(str
 	sdata->fragment_next = 0;
 
 	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		beacon = sdata->u.ap.beacon;
 		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
 		synchronize_rcu();
@@ -53,22 +53,23 @@ static void ieee80211_teardown_sdata(str
 		}
 
 		break;
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			mesh_rmc_free(sdata);
 		break;
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		kfree(sdata->u.sta.extra_ie);
 		kfree(sdata->u.sta.assocreq_ies);
 		kfree(sdata->u.sta.assocresp_ies);
 		kfree_skb(sdata->u.sta.probe_resp);
 		break;
-	case IEEE80211_IF_TYPE_WDS:
-	case IEEE80211_IF_TYPE_VLAN:
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_MONITOR:
 		break;
-	case IEEE80211_IF_TYPE_INVALID:
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case __NL80211_IFTYPE_AFTER_LAST:
 		BUG();
 		break;
 	}
@@ -81,7 +82,7 @@ static void ieee80211_teardown_sdata(str
  * Helper function to initialise an interface to a specific type.
  */
 static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
-				  enum ieee80211_if_types type)
+				  enum nl80211_iftype type)
 {
 	/* clear type-dependent union */
 	memset(&sdata->u, 0, sizeof(sdata->u));
@@ -93,28 +94,29 @@ static void ieee80211_setup_sdata(struct
 	sdata->dev->type = ARPHRD_ETHER;
 
 	switch (type) {
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		ieee80211_sta_setup_sdata(sdata);
 		break;
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			ieee80211_mesh_init_sdata(sdata);
 		break;
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
 		sdata->dev->hard_start_xmit = ieee80211_monitor_start_xmit;
 		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
 				      MONITOR_FLAG_OTHER_BSS;
 		break;
-	case IEEE80211_IF_TYPE_WDS:
-	case IEEE80211_IF_TYPE_VLAN:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_AP_VLAN:
 		break;
-	case IEEE80211_IF_TYPE_INVALID:
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case __NL80211_IFTYPE_AFTER_LAST:
 		BUG();
 		break;
 	}
@@ -123,7 +125,7 @@ static void ieee80211_setup_sdata(struct
 }
 
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
-			     enum ieee80211_if_types type)
+			     enum nl80211_iftype type)
 {
 	ASSERT_RTNL();
 
@@ -153,7 +155,7 @@ int ieee80211_if_change_type(struct ieee
 }
 
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
-		     struct net_device **new_dev, enum ieee80211_if_types type,
+		     struct net_device **new_dev, enum nl80211_iftype type,
 		     struct vif_params *params)
 {
 	struct net_device *ndev;
--- everything.orig/net/mac80211/key.c	2008-09-10 23:50:20.000000000 +0200
+++ everything/net/mac80211/key.c	2008-09-10 23:58:04.000000000 +0200
@@ -118,8 +118,8 @@ static const u8 *get_mac_for_key(struct 
 	 * address to indicate a transmit-only key.
 	 */
 	if (key->conf.alg != ALG_WEP &&
-	    (key->sdata->vif.type == IEEE80211_IF_TYPE_AP ||
-	     key->sdata->vif.type == IEEE80211_IF_TYPE_VLAN))
+	    (key->sdata->vif.type == NL80211_IFTYPE_AP ||
+	     key->sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
 		addr = zero_addr;
 
 	if (key->sta)
@@ -331,7 +331,7 @@ void ieee80211_key_link(struct ieee80211
 		 */
 		key->conf.flags |= IEEE80211_KEY_FLAG_PAIRWISE;
 	} else {
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			struct sta_info *ap;
 
 			/*
--- everything.orig/net/mac80211/main.c	2008-09-10 23:58:02.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-10 23:58:04.000000000 +0200
@@ -146,7 +146,7 @@ static int ieee80211_change_mtu(struct n
 	int meshhdrlen;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	meshhdrlen = (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) ? 5 : 0;
+	meshhdrlen = (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) ? 5 : 0;
 
 	/* FIX: what would be proper limits for MTU?
 	 * This interface uses 802.3 frames. */
@@ -164,18 +164,16 @@ static int ieee80211_change_mtu(struct n
 
 static inline int identical_mac_addr_allowed(int type1, int type2)
 {
-	return (type1 == IEEE80211_IF_TYPE_MNTR ||
-		type2 == IEEE80211_IF_TYPE_MNTR ||
-		(type1 == IEEE80211_IF_TYPE_AP &&
-		 type2 == IEEE80211_IF_TYPE_WDS) ||
-		(type1 == IEEE80211_IF_TYPE_WDS &&
-		 (type2 == IEEE80211_IF_TYPE_WDS ||
-		  type2 == IEEE80211_IF_TYPE_AP)) ||
-		(type1 == IEEE80211_IF_TYPE_AP &&
-		 type2 == IEEE80211_IF_TYPE_VLAN) ||
-		(type1 == IEEE80211_IF_TYPE_VLAN &&
-		 (type2 == IEEE80211_IF_TYPE_AP ||
-		  type2 == IEEE80211_IF_TYPE_VLAN)));
+	return type1 == NL80211_IFTYPE_MONITOR ||
+		type2 == NL80211_IFTYPE_MONITOR ||
+		(type1 == NL80211_IFTYPE_AP && type2 == NL80211_IFTYPE_WDS) ||
+		(type1 == NL80211_IFTYPE_WDS &&
+			(type2 == NL80211_IFTYPE_WDS ||
+			 type2 == NL80211_IFTYPE_AP)) ||
+		(type1 == NL80211_IFTYPE_AP && type2 == NL80211_IFTYPE_AP_VLAN) ||
+		(type1 == NL80211_IFTYPE_AP_VLAN &&
+			(type2 == NL80211_IFTYPE_AP ||
+			 type2 == NL80211_IFTYPE_AP_VLAN));
 }
 
 static int ieee80211_open(struct net_device *dev)
@@ -211,8 +209,8 @@ static int ieee80211_open(struct net_dev
 			 * belonging to the same hardware. Then, however, we're
 			 * faced with having to adopt two different TSF timers...
 			 */
-			if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
-			    nsdata->vif.type == IEEE80211_IF_TYPE_IBSS)
+			if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
+			    nsdata->vif.type == NL80211_IFTYPE_ADHOC)
 				return -EBUSY;
 
 			/*
@@ -232,37 +230,38 @@ static int ieee80211_open(struct net_dev
 			/*
 			 * can only add VLANs to enabled APs
 			 */
-			if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN &&
-			    nsdata->vif.type == IEEE80211_IF_TYPE_AP)
+			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			    nsdata->vif.type == NL80211_IFTYPE_AP)
 				sdata->bss = &nsdata->u.ap;
 		}
 	}
 
 	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_WDS:
+	case NL80211_IFTYPE_WDS:
 		if (!is_valid_ether_addr(sdata->u.wds.remote_addr))
 			return -ENOLINK;
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
+	case NL80211_IFTYPE_AP_VLAN:
 		if (!sdata->bss)
 			return -ENOLINK;
 		list_add(&sdata->u.vlan.list, &sdata->bss->vlans);
 		break;
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		sdata->bss = &sdata->u.ap;
 		break;
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
 		/* mesh ifaces must set allmulti to forward mcast traffic */
 		atomic_inc(&local->iff_allmultis);
 		break;
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_MNTR:
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_ADHOC:
 		/* no special treatment */
 		break;
-	case IEEE80211_IF_TYPE_INVALID:
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case __NL80211_IFTYPE_AFTER_LAST:
 		/* cannot happen */
 		WARN_ON(1);
 		break;
@@ -309,10 +308,10 @@ static int ieee80211_open(struct net_dev
 	}
 
 	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_VLAN:
+	case NL80211_IFTYPE_AP_VLAN:
 		/* no need to tell driver */
 		break;
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
 			local->cooked_mntrs++;
 			break;
@@ -336,8 +335,8 @@ static int ieee80211_open(struct net_dev
 		ieee80211_configure_filter(local);
 		netif_addr_unlock_bh(local->mdev);
 		break;
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		sdata->u.sta.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 		/* fall through */
 	default:
@@ -354,14 +353,14 @@ static int ieee80211_open(struct net_dev
 		ieee80211_bss_info_change_notify(sdata, changed);
 		ieee80211_enable_keys(sdata);
 
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
+		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 		    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 			netif_carrier_off(dev);
 		else
 			netif_carrier_on(dev);
 	}
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
+	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		/* Create STA entry for the WDS peer */
 		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
 				     GFP_KERNEL);
@@ -417,8 +416,8 @@ static int ieee80211_open(struct net_dev
 	 * yet be effective. Trigger execution of ieee80211_sta_work
 	 * to fix this.
 	 */
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 		queue_work(local->hw.workqueue, &ifsta->work);
 	}
@@ -433,7 +432,7 @@ static int ieee80211_open(struct net_dev
 		local->ops->stop(local_to_hw(local));
  err_del_bss:
 	sdata->bss = NULL;
-	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		list_del(&sdata->u.vlan.list);
 	return res;
 }
@@ -496,7 +495,7 @@ static int ieee80211_stop(struct net_dev
 	dev_mc_unsync(local->mdev, dev);
 
 	/* APs need special treatment */
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		struct ieee80211_sub_if_data *vlan, *tmp;
 		struct beacon_data *old_beacon = sdata->u.ap.beacon;
 
@@ -515,11 +514,11 @@ static int ieee80211_stop(struct net_dev
 	local->open_count--;
 
 	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_VLAN:
+	case NL80211_IFTYPE_AP_VLAN:
 		list_del(&sdata->u.vlan.list);
 		/* no need to tell driver */
 		break;
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
 			local->cooked_mntrs--;
 			break;
@@ -542,8 +541,8 @@ static int ieee80211_stop(struct net_dev
 		ieee80211_configure_filter(local);
 		netif_addr_unlock_bh(local->mdev);
 		break;
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		sdata->u.sta.state = IEEE80211_STA_MLME_DISABLED;
 		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
 		del_timer_sync(&sdata->u.sta.timer);
@@ -569,7 +568,7 @@ static int ieee80211_stop(struct net_dev
 		sdata->u.sta.extra_ie = NULL;
 		sdata->u.sta.extra_ie_len = 0;
 		/* fall through */
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif)) {
 			/* allmulti is always set on mesh ifaces */
 			atomic_dec(&local->iff_allmultis);
@@ -698,12 +697,12 @@ int ieee80211_if_config(struct ieee80211
 	memset(&conf, 0, sizeof(conf));
 	conf.changed = changed;
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
-	} else if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
+	} else if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		conf.bssid = sdata->dev->dev_addr;
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
@@ -1204,7 +1203,7 @@ void ieee80211_tx_status(struct ieee8021
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->vif.type == IEEE80211_IF_TYPE_MNTR) {
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
 			if (!netif_running(sdata->dev))
 				continue;
 
@@ -1450,7 +1449,7 @@ int ieee80211_register_hw(struct ieee802
 
 	/* add one default STA interface */
 	result = ieee80211_if_add(local, "wlan%d", NULL,
-				  IEEE80211_IF_TYPE_STA, NULL);
+				  NL80211_IFTYPE_STATION, NULL);
 	if (result)
 		printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
 		       wiphy_name(local->hw.wiphy));
--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:58:03.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:58:04.000000000 +0200
@@ -709,7 +709,7 @@ static void ieee80211_set_associated(str
 
 	ifsta->flags |= IEEE80211_STA_ASSOCIATED;
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return;
 
 	bss = ieee80211_rx_bss_get(local, ifsta->bssid,
@@ -1033,17 +1033,17 @@ static void ieee80211_rx_mgmt_auth(struc
 	DECLARE_MAC_BUF(mac);
 
 	if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return;
 
 	if (len < 24 + 6)
 		return;
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 	    memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0)
 		return;
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
@@ -1051,7 +1051,7 @@ static void ieee80211_rx_mgmt_auth(struc
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
 	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		/*
 		 * IEEE 802.11 standard does not require authentication in IBSS
 		 * networks and most implementations do not seem to use it.
@@ -1518,7 +1518,7 @@ static void ieee80211_rx_bss_info(struct
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems->supp_rates &&
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 
@@ -1563,14 +1563,14 @@ static void ieee80211_rx_bss_info(struct
 	 * In STA mode, the remaining parameters should not be overridden
 	 * by beacons because they're not necessarily accurate there.
 	 */
-	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 	    bss->last_probe_resp && beacon) {
 		ieee80211_rx_bss_put(local, bss);
 		return;
 	}
 
 	/* check if we need to merge IBSS */
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && beacon &&
 	    bss->capability & WLAN_CAPABILITY_IBSS &&
 	    bss->freq == local->oper_channel->center_freq &&
 	    elems->ssid_len == sdata->u.sta.ssid_len &&
@@ -1680,7 +1680,7 @@ static void ieee80211_rx_mgmt_beacon(str
 
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return;
 	ifsta = &sdata->u.sta;
 
@@ -1731,7 +1731,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	DECLARE_MAC_BUF(mac3);
 #endif
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS ||
+	if (sdata->vif.type != NL80211_IFTYPE_ADHOC ||
 	    ifsta->state != IEEE80211_STA_MLME_IBSS_JOINED ||
 	    len < 24 + 2 || !ifsta->probe_resp)
 		return;
@@ -2243,8 +2243,8 @@ static void ieee80211_sta_work(struct wo
 	if (local->sw_scanning || local->hw_scanning)
 		return;
 
-	if (WARN_ON(sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-		    sdata->vif.type != IEEE80211_IF_TYPE_IBSS))
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC))
 		return;
 	ifsta = &sdata->u.sta;
 
@@ -2304,7 +2304,7 @@ static void ieee80211_sta_work(struct wo
 
 static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 {
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		queue_work(sdata->local->hw.workqueue,
 			   &sdata->u.sta.work);
 }
@@ -2386,7 +2386,7 @@ void ieee80211_sta_req_auth(struct ieee8
 {
 	struct ieee80211_local *local = sdata->local;
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return;
 
 	if ((ifsta->flags & (IEEE80211_STA_BSSID_SET |
@@ -2438,7 +2438,7 @@ int ieee80211_sta_set_ssid(struct ieee80
 	else
 		ifsta->flags &= ~IEEE80211_STA_SSID_SET;
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
 	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
 		ifsta->ibss_join_req = jiffies;
 		ifsta->state = IEEE80211_STA_MLME_IBSS_SEARCH;
@@ -2513,8 +2513,8 @@ int ieee80211_sta_deauthenticate(struct 
 	printk(KERN_DEBUG "%s: deauthenticating by local choice (reason=%d)\n",
 	       sdata->dev->name, reason);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return -EINVAL;
 
 	ieee80211_set_disassoc(sdata, ifsta, true, true, reason);
@@ -2528,7 +2528,7 @@ int ieee80211_sta_disassociate(struct ie
 	printk(KERN_DEBUG "%s: disassociating by local choice (reason=%d)\n",
 	       sdata->dev->name, reason);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
 	if (!(ifsta->flags & IEEE80211_STA_ASSOCIATED))
@@ -2544,7 +2544,7 @@ void ieee80211_mlme_notify_scan_complete
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	struct ieee80211_if_sta *ifsta;
 
-	if (sdata && sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata && sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		ifsta = &sdata->u.sta;
 		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
 		    (!(ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED) &&
@@ -2570,7 +2570,7 @@ void ieee80211_notify_mac(struct ieee802
 	case IEEE80211_NOTIFY_RE_ASSOC:
 		rcu_read_lock();
 		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-			if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
 
 			ieee80211_sta_req_auth(sdata, &sdata->u.sta);
--- everything.orig/net/mac80211/rx.c	2008-09-10 23:58:03.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-10 23:58:04.000000000 +0200
@@ -295,7 +295,7 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		if (!netif_running(sdata->dev))
 			continue;
 
-		if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR)
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
 			continue;
 
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES)
@@ -512,7 +512,7 @@ ieee80211_rx_h_check(struct ieee80211_rx
 
 	if (unlikely((ieee80211_is_data(hdr->frame_control) ||
 		      ieee80211_is_pspoll(hdr->frame_control)) &&
-		     rx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
 		if ((!ieee80211_has_fromds(hdr->frame_control) &&
 		     !ieee80211_has_tods(hdr->frame_control) &&
@@ -724,14 +724,14 @@ ieee80211_rx_h_sta_process(struct ieee80
 	/* Update last_rx only for IBSS packets which are for the current
 	 * BSSID to avoid keeping the current IBSS network alive in cases where
 	 * other STAs are using different BSSID. */
-	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (rx->sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
-						IEEE80211_IF_TYPE_IBSS);
+						NL80211_IFTYPE_ADHOC);
 		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) == 0)
 			sta->last_rx = jiffies;
 	} else
 	if (!is_multicast_ether_addr(hdr->addr1) ||
-	    rx->sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+	    rx->sdata->vif.type == NL80211_IFTYPE_STATION) {
 		/* Update last_rx only for unicast frames in order to prevent
 		 * the Probe Request frames (the only broadcast frames from a
 		 * STA in infrastructure mode) from keeping a connection alive.
@@ -751,8 +751,8 @@ ieee80211_rx_h_sta_process(struct ieee80
 	sta->last_noise = rx->status->noise;
 
 	if (!ieee80211_has_morefrags(hdr->frame_control) &&
-	    (rx->sdata->vif.type == IEEE80211_IF_TYPE_AP ||
-	     rx->sdata->vif.type == IEEE80211_IF_TYPE_VLAN)) {
+	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
+	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
 		/* Change STA power saving mode only in the end of a frame
 		 * exchange sequence */
 		if (test_sta_flags(sta, WLAN_STA_PS) &&
@@ -982,8 +982,8 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		   !(rx->flags & IEEE80211_RX_RA_MATCH)))
 		return RX_CONTINUE;
 
-	if ((sdata->vif.type != IEEE80211_IF_TYPE_AP) &&
-	    (sdata->vif.type != IEEE80211_IF_TYPE_VLAN))
+	if ((sdata->vif.type != NL80211_IFTYPE_AP) &&
+	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN))
 		return RX_DROP_UNUSABLE;
 
 	skb = skb_dequeue(&rx->sta->tx_filtered);
@@ -1131,23 +1131,23 @@ ieee80211_data_to_8023(struct ieee80211_
 	switch (hdr->frame_control &
 		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
 	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS):
-		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_AP &&
-			     sdata->vif.type != IEEE80211_IF_TYPE_VLAN))
+		if (unlikely(sdata->vif.type != NL80211_IFTYPE_AP &&
+			     sdata->vif.type != NL80211_IFTYPE_AP_VLAN))
 			return -1;
 		break;
 	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
-		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_WDS &&
-			     sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT))
+		if (unlikely(sdata->vif.type != NL80211_IFTYPE_WDS &&
+			     sdata->vif.type != NL80211_IFTYPE_MESH_POINT))
 			return -1;
 		break;
 	case __constant_cpu_to_le16(IEEE80211_FCTL_FROMDS):
-		if (sdata->vif.type != IEEE80211_IF_TYPE_STA ||
+		if (sdata->vif.type != NL80211_IFTYPE_STATION ||
 		    (is_multicast_ether_addr(dst) &&
 		     !compare_ether_addr(src, dev->dev_addr)))
 			return -1;
 		break;
 	case __constant_cpu_to_le16(0):
-		if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
+		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			return -1;
 		break;
 	}
@@ -1221,8 +1221,8 @@ ieee80211_deliver_skb(struct ieee80211_r
 	skb = rx->skb;
 	xmit_skb = NULL;
 
-	if ((sdata->vif.type == IEEE80211_IF_TYPE_AP ||
-	     sdata->vif.type == IEEE80211_IF_TYPE_VLAN) &&
+	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
 	    (rx->flags & IEEE80211_RX_RA_MATCH)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
@@ -1536,8 +1536,8 @@ ieee80211_rx_h_action(struct ieee80211_r
 	 * FIXME: revisit this, I'm sure we should handle most
 	 *	  of these frames in other modes as well!
 	 */
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return RX_DROP_MONITOR;
 
 	switch (mgmt->u.action.category) {
@@ -1595,8 +1595,8 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		return ieee80211_mesh_rx_mgmt(sdata, rx->skb, rx->status);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return RX_DROP_MONITOR;
 
 	if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
@@ -1632,7 +1632,7 @@ static void ieee80211_rx_michael_mic_rep
 	if (!ieee80211_has_protected(hdr->frame_control))
 		goto ignore;
 
-	if (rx->sdata->vif.type == IEEE80211_IF_TYPE_AP && keyidx) {
+	if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx) {
 		/*
 		 * APs with pairwise keys should never receive Michael MIC
 		 * errors for non-zero keyidx because these are reserved for
@@ -1702,7 +1702,7 @@ static void ieee80211_rx_cooked_monitor(
 		if (!netif_running(sdata->dev))
 			continue;
 
-		if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR ||
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR ||
 		    !(sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES))
 			continue;
 
@@ -1801,7 +1801,7 @@ static int prepare_for_handlers(struct i
 	int multicast = is_multicast_ether_addr(hdr->addr1);
 
 	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		if (!bssid)
 			return 0;
 		if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
@@ -1816,7 +1816,7 @@ static int prepare_for_handlers(struct i
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		break;
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		if (!bssid)
 			return 0;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
@@ -1837,7 +1837,7 @@ static int prepare_for_handlers(struct i
 						bssid, hdr->addr2,
 						BIT(rx->status->rate_idx));
 		break;
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (!multicast &&
 		    compare_ether_addr(sdata->dev->dev_addr,
 				       hdr->addr1) != 0) {
@@ -1847,8 +1847,8 @@ static int prepare_for_handlers(struct i
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_AP:
 		if (!bssid) {
 			if (compare_ether_addr(sdata->dev->dev_addr,
 					       hdr->addr1))
@@ -1860,16 +1860,17 @@ static int prepare_for_handlers(struct i
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		}
 		break;
-	case IEEE80211_IF_TYPE_WDS:
+	case NL80211_IFTYPE_WDS:
 		if (bssid || !ieee80211_is_data(hdr->frame_control))
 			return 0;
 		if (compare_ether_addr(sdata->u.wds.remote_addr, hdr->addr2))
 			return 0;
 		break;
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		/* take everything */
 		break;
-	case IEEE80211_IF_TYPE_INVALID:
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case __NL80211_IFTYPE_AFTER_LAST:
 		/* should never get here */
 		WARN_ON(1);
 		break;
@@ -1930,7 +1931,7 @@ static void __ieee80211_rx_handle_packet
 		if (!netif_running(sdata->dev))
 			continue;
 
-		if (sdata->vif.type == IEEE80211_IF_TYPE_MNTR)
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
 			continue;
 
 		bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
--- everything.orig/net/mac80211/scan.c	2008-09-10 23:58:02.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-10 23:58:04.000000000 +0200
@@ -475,7 +475,7 @@ void ieee80211_scan_completed(struct iee
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		/* Tell AP we're back */
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
 				ieee80211_send_nullfunc(local, sdata, 0);
 				netif_tx_wake_all_queues(sdata->dev);
@@ -539,7 +539,7 @@ void ieee80211_scan_work(struct work_str
 		chan = &sband->channels[local->scan_channel_idx];
 
 		if (chan->flags & IEEE80211_CHAN_DISABLED ||
-		    (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
+		    (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
 		     chan->flags & IEEE80211_CHAN_NO_IBSS))
 			skip = 1;
 
@@ -638,7 +638,7 @@ int ieee80211_start_scan(struct ieee8021
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
 				netif_tx_stop_all_queues(sdata->dev);
 				ieee80211_send_nullfunc(local, sdata, 1);
@@ -681,7 +681,7 @@ int ieee80211_request_scan(struct ieee80
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_sta *ifsta;
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return ieee80211_start_scan(sdata, ssid, ssid_len);
 
 	/*
--- everything.orig/net/mac80211/sta_info.c	2008-09-10 23:57:50.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-09-10 23:58:04.000000000 +0200
@@ -319,7 +319,7 @@ int sta_info_insert(struct sta_info *sta
 
 	/* notify driver */
 	if (local->ops->sta_notify) {
-		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			sdata = container_of(sdata->bss,
 					     struct ieee80211_sub_if_data,
 					     u.ap);
@@ -456,7 +456,7 @@ static void __sta_info_unlink(struct sta
 	local->num_sta--;
 
 	if (local->ops->sta_notify) {
-		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			sdata = container_of(sdata->bss,
 					     struct ieee80211_sub_if_data,
 					     u.ap);
--- everything.orig/net/mac80211/tx.c	2008-09-10 23:58:03.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-10 23:58:04.000000000 +0200
@@ -226,7 +226,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	    !ieee80211_is_probe_req(hdr->frame_control))
 		return TX_DROP;
 
-	if (tx->sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+	if (tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 		return TX_CONTINUE;
 
 	if (tx->flags & IEEE80211_TX_PS_BUFFERED)
@@ -236,7 +236,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 
 	if (likely(tx->flags & IEEE80211_TX_UNICAST)) {
 		if (unlikely(!(sta_flags & WLAN_STA_ASSOC) &&
-			     tx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+			     tx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 			     ieee80211_is_data(hdr->frame_control))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			DECLARE_MAC_BUF(mac);
@@ -250,7 +250,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	} else {
 		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
 			     tx->local->num_sta == 0 &&
-			     tx->sdata->vif.type != IEEE80211_IF_TYPE_IBSS)) {
+			     tx->sdata->vif.type != NL80211_IFTYPE_ADHOC)) {
 			/*
 			 * No associated STAs - no need to send multicast
 			 * frames.
@@ -281,7 +281,7 @@ static void purge_old_ps_buffers(struct 
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		struct ieee80211_if_ap *ap;
-		if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
+		if (sdata->vif.type != NL80211_IFTYPE_AP)
 			continue;
 		ap = &sdata->u.ap;
 		skb = skb_dequeue(&ap->ps_bc_buf);
@@ -979,7 +979,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 
 	/* process and remove the injection radiotap header */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (unlikely(sdata->vif.type == IEEE80211_IF_TYPE_MNTR)) {
+	if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
 		if (__ieee80211_parse_tx_radiotap(tx, skb) == TX_DROP)
 			return TX_DROP;
 
@@ -1457,8 +1457,8 @@ int ieee80211_subif_start_xmit(struct sk
 	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA);
 
 	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_AP:
-	case IEEE80211_IF_TYPE_VLAN:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -1466,7 +1466,7 @@ int ieee80211_subif_start_xmit(struct sk
 		memcpy(hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 24;
 		break;
-	case IEEE80211_IF_TYPE_WDS:
+	case NL80211_IFTYPE_WDS:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 		/* RA TA DA SA */
 		memcpy(hdr.addr1, sdata->u.wds.remote_addr, ETH_ALEN);
@@ -1476,7 +1476,7 @@ int ieee80211_subif_start_xmit(struct sk
 		hdrlen = 30;
 		break;
 #ifdef CONFIG_MAC80211_MESH
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_MESH_POINT:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 		/* RA TA DA SA */
 		memset(hdr.addr1, 0, ETH_ALEN);
@@ -1493,7 +1493,7 @@ int ieee80211_subif_start_xmit(struct sk
 		hdrlen = 30;
 		break;
 #endif
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
 		/* BSSID SA DA */
 		memcpy(hdr.addr1, sdata->u.sta.bssid, ETH_ALEN);
@@ -1501,7 +1501,7 @@ int ieee80211_subif_start_xmit(struct sk
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		hdrlen = 24;
 		break;
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		/* DA SA BSSID */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
 		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
@@ -1814,7 +1814,7 @@ struct sk_buff *ieee80211_beacon_get(str
 	sdata = vif_to_sdata(vif);
 	bdev = sdata->dev;
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		ap = &sdata->u.ap;
 		beacon = rcu_dereference(ap->beacon);
 		if (ap && beacon) {
@@ -1856,7 +1856,7 @@ struct sk_buff *ieee80211_beacon_get(str
 			num_beacons = &ap->num_beacons;
 		} else
 			goto out;
-	} else if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		struct ieee80211_hdr *hdr;
 		ifsta = &sdata->u.sta;
 
@@ -1996,7 +1996,7 @@ ieee80211_get_buffered_bc(struct ieee802
 	rcu_read_lock();
 	beacon = rcu_dereference(bss->beacon);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_AP || !beacon || !beacon->head)
+	if (sdata->vif.type != NL80211_IFTYPE_AP || !beacon || !beacon->head)
 		goto out;
 
 	if (bss->dtim_count != 0)
--- everything.orig/net/mac80211/util.c	2008-09-10 23:58:03.000000000 +0200
+++ everything/net/mac80211/util.c	2008-09-10 23:58:04.000000000 +0200
@@ -43,7 +43,7 @@ const unsigned char bridge_tunnel_header
 
 
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
-			enum ieee80211_if_types type)
+			enum nl80211_iftype type)
 {
 	__le16 fc = hdr->frame_control;
 
@@ -77,10 +77,10 @@ u8 *ieee80211_get_bssid(struct ieee80211
 
 		if (ieee80211_is_back_req(fc)) {
 			switch (type) {
-			case IEEE80211_IF_TYPE_STA:
+			case NL80211_IFTYPE_STATION:
 				return hdr->addr2;
-			case IEEE80211_IF_TYPE_AP:
-			case IEEE80211_IF_TYPE_VLAN:
+			case NL80211_IFTYPE_AP:
+			case NL80211_IFTYPE_AP_VLAN:
 				return hdr->addr1;
 			default:
 				break; /* fall through to the return */
@@ -376,15 +376,16 @@ void ieee80211_iterate_active_interfaces
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
-		case IEEE80211_IF_TYPE_INVALID:
-		case IEEE80211_IF_TYPE_MNTR:
-		case IEEE80211_IF_TYPE_VLAN:
+		case __NL80211_IFTYPE_AFTER_LAST:
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case NL80211_IFTYPE_MONITOR:
+		case NL80211_IFTYPE_AP_VLAN:
 			continue;
-		case IEEE80211_IF_TYPE_AP:
-		case IEEE80211_IF_TYPE_STA:
-		case IEEE80211_IF_TYPE_IBSS:
-		case IEEE80211_IF_TYPE_WDS:
-		case IEEE80211_IF_TYPE_MESH_POINT:
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
 			break;
 		}
 		if (netif_running(sdata->dev))
@@ -409,15 +410,16 @@ void ieee80211_iterate_active_interfaces
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
-		case IEEE80211_IF_TYPE_INVALID:
-		case IEEE80211_IF_TYPE_MNTR:
-		case IEEE80211_IF_TYPE_VLAN:
+		case __NL80211_IFTYPE_AFTER_LAST:
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case NL80211_IFTYPE_MONITOR:
+		case NL80211_IFTYPE_AP_VLAN:
 			continue;
-		case IEEE80211_IF_TYPE_AP:
-		case IEEE80211_IF_TYPE_STA:
-		case IEEE80211_IF_TYPE_IBSS:
-		case IEEE80211_IF_TYPE_WDS:
-		case IEEE80211_IF_TYPE_MESH_POINT:
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
 			break;
 		}
 		if (netif_running(sdata->dev))
@@ -622,7 +624,7 @@ int ieee80211_set_freq(struct ieee80211_
 	chan = ieee80211_get_channel(local->hw.wiphy, freqMHz);
 
 	if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
-		if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
+		if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
 		    chan->flags & IEEE80211_CHAN_NO_IBSS) {
 			printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
 				"%d MHz\n", sdata->dev->name, chan->center_freq);
--- everything.orig/net/mac80211/wext.c	2008-09-10 23:58:02.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-09-10 23:58:04.000000000 +0200
@@ -122,8 +122,8 @@ static int ieee80211_ioctl_siwgenie(stru
 	if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
 		return -EOPNOTSUPP;
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		int ret = ieee80211_sta_set_extra_ie(sdata, extra, data->length);
 		if (ret)
 			return ret;
@@ -273,21 +273,21 @@ static int ieee80211_ioctl_siwmode(struc
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int type;
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		return -EOPNOTSUPP;
 
 	switch (*mode) {
 	case IW_MODE_INFRA:
-		type = IEEE80211_IF_TYPE_STA;
+		type = NL80211_IFTYPE_STATION;
 		break;
 	case IW_MODE_ADHOC:
-		type = IEEE80211_IF_TYPE_IBSS;
+		type = NL80211_IFTYPE_ADHOC;
 		break;
 	case IW_MODE_REPEAT:
-		type = IEEE80211_IF_TYPE_WDS;
+		type = NL80211_IFTYPE_WDS;
 		break;
 	case IW_MODE_MONITOR:
-		type = IEEE80211_IF_TYPE_MNTR;
+		type = NL80211_IFTYPE_MONITOR;
 		break;
 	default:
 		return -EINVAL;
@@ -305,22 +305,22 @@ static int ieee80211_ioctl_giwmode(struc
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		*mode = IW_MODE_MASTER;
 		break;
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		*mode = IW_MODE_INFRA;
 		break;
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		*mode = IW_MODE_ADHOC;
 		break;
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		*mode = IW_MODE_MONITOR;
 		break;
-	case IEEE80211_IF_TYPE_WDS:
+	case NL80211_IFTYPE_WDS:
 		*mode = IW_MODE_REPEAT;
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
+	case NL80211_IFTYPE_AP_VLAN:
 		*mode = IW_MODE_SECOND;		/* FIXME */
 		break;
 	default:
@@ -336,13 +336,13 @@ static int ieee80211_ioctl_siwfreq(struc
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
 	if (freq->e == 0) {
 		if (freq->m < 0) {
-			if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
+			if (sdata->vif.type == NL80211_IFTYPE_STATION)
 				sdata->u.sta.flags |=
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;
@@ -386,8 +386,8 @@ static int ieee80211_ioctl_siwessid(stru
 		len--;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		int ret;
 		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
 			if (len > IEEE80211_MAX_SSID_LEN)
@@ -407,7 +407,7 @@ static int ieee80211_ioctl_siwessid(stru
 		return 0;
 	}
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		memcpy(sdata->u.ap.ssid, ssid, len);
 		memset(sdata->u.ap.ssid + len, 0,
 		       IEEE80211_MAX_SSID_LEN - len);
@@ -426,8 +426,8 @@ static int ieee80211_ioctl_giwessid(stru
 
 	struct ieee80211_sub_if_data *sdata;
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		int res = ieee80211_sta_get_ssid(sdata, ssid, &len);
 		if (res == 0) {
 			data->length = len;
@@ -437,7 +437,7 @@ static int ieee80211_ioctl_giwessid(stru
 		return res;
 	}
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		len = sdata->u.ap.ssid_len;
 		if (len > IW_ESSID_MAX_SIZE)
 			len = IW_ESSID_MAX_SIZE;
@@ -457,8 +457,8 @@ static int ieee80211_ioctl_siwap(struct 
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		int ret;
 		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
 			memcpy(sdata->u.sta.bssid, (u8 *) &ap_addr->sa_data,
@@ -477,7 +477,7 @@ static int ieee80211_ioctl_siwap(struct 
 			return ret;
 		ieee80211_sta_req_auth(sdata, &sdata->u.sta);
 		return 0;
-	} else if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
+	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		/*
 		 * If it is necessary to update the WDS peer address
 		 * while the interface is running, then we need to do
@@ -505,8 +505,8 @@ static int ieee80211_ioctl_giwap(struct 
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		if (sdata->u.sta.state == IEEE80211_STA_MLME_ASSOCIATED ||
 		    sdata->u.sta.state == IEEE80211_STA_MLME_IBSS_JOINED) {
 			ap_addr->sa_family = ARPHRD_ETHER;
@@ -516,7 +516,7 @@ static int ieee80211_ioctl_giwap(struct 
 			memset(&ap_addr->sa_data, 0, ETH_ALEN);
 			return 0;
 		}
-	} else if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
+	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		ap_addr->sa_family = ARPHRD_ETHER;
 		memcpy(&ap_addr->sa_data, sdata->u.wds.remote_addr, ETH_ALEN);
 		return 0;
@@ -538,10 +538,10 @@ static int ieee80211_ioctl_siwscan(struc
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_AP)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
+	    sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EOPNOTSUPP;
 
 	/* if SSID was specified explicitly then use that */
@@ -627,7 +627,7 @@ static int ieee80211_ioctl_giwrate(struc
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
@@ -858,8 +858,8 @@ static int ieee80211_ioctl_siwmlme(struc
 	struct iw_mlme *mlme = (struct iw_mlme *) extra;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return -EINVAL;
 
 	switch (mlme->cmd) {
@@ -954,7 +954,7 @@ static int ieee80211_ioctl_giwencode(str
 	erq->length = sdata->keys[idx]->conf.keylen;
 	erq->flags |= IW_ENCODE_ENABLED;
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 		switch (ifsta->auth_alg) {
 		case WLAN_AUTH_OPEN:
@@ -1028,7 +1028,7 @@ static int ieee80211_ioctl_siwauth(struc
 		sdata->drop_unencrypted = !!data->value;
 		break;
 	case IW_AUTH_PRIVACY_INVOKED:
-		if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			ret = -EINVAL;
 		else {
 			sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
@@ -1043,8 +1043,8 @@ static int ieee80211_ioctl_siwauth(struc
 		}
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-		    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
+		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 			sdata->u.sta.auth_algs = data->value;
 		else
 			ret = -EOPNOTSUPP;
@@ -1066,8 +1066,8 @@ static struct iw_statistics *ieee80211_g
 
 	rcu_read_lock();
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		sta = sta_info_get(local, sdata->u.sta.bssid);
 	if (!sta) {
 		wstats->discard.fragment = 0;
@@ -1097,8 +1097,8 @@ static int ieee80211_ioctl_giwauth(struc
 
 	switch (data->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_80211_AUTH_ALG:
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-		    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
+		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 			data->value = sdata->u.sta.auth_algs;
 		else
 			ret = -EOPNOTSUPP;
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-10 23:58:03.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-10 23:58:04.000000000 +0200
@@ -954,10 +954,10 @@ void ieee80211_rx_bss_put(struct ieee802
 /* interface handling */
 void ieee80211_if_setup(struct net_device *dev);
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
-		     struct net_device **new_dev, enum ieee80211_if_types type,
+		     struct net_device **new_dev, enum nl80211_iftype type,
 		     struct vif_params *params);
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
-			     enum ieee80211_if_types type);
+			     enum nl80211_iftype type);
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
 
@@ -1001,7 +1001,7 @@ extern void *mac80211_wiphy_privid; /* f
 extern const unsigned char rfc1042_header[6];
 extern const unsigned char bridge_tunnel_header[6];
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
-			enum ieee80211_if_types type);
+			enum nl80211_iftype type);
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
--- everything.orig/drivers/net/wireless/ath5k/ath5k.h	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/ath5k.h	2008-09-10 23:58:04.000000000 +0200
@@ -1008,7 +1008,7 @@ struct ath5k_hw {
 
 	enum ath5k_int		ah_imr;
 
-	enum ieee80211_if_types	ah_op_mode;
+	enum nl80211_iftype	ah_op_mode;
 	enum ath5k_power_mode	ah_power_mode;
 	struct ieee80211_channel ah_current_channel;
 	bool			ah_turbo;
@@ -1117,7 +1117,7 @@ extern void ath5k_hw_detach(struct ath5k
 
 /* Reset Functions */
 extern int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial);
-extern int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode, struct ieee80211_channel *channel, bool change_channel);
+extern int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode, struct ieee80211_channel *channel, bool change_channel);
 /* Power management functions */
 extern int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode, bool set_chip, u16 sleep_duration);
 
--- everything.orig/drivers/net/wireless/ath5k/base.h	2008-09-10 23:50:23.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.h	2008-09-10 23:58:04.000000000 +0200
@@ -113,7 +113,7 @@ struct ath5k_softc {
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
 	struct ieee80211_rate	rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
 	u8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
-	enum ieee80211_if_types	opmode;
+	enum nl80211_iftype	opmode;
 	struct ath5k_hw		*ah;		/* Atheros HW */
 
 	struct ieee80211_supported_band		*curband;
--- everything.orig/drivers/net/wireless/ath5k/reset.c	2008-09-10 23:50:23.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/reset.c	2008-09-10 23:58:04.000000000 +0200
@@ -399,7 +399,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw 
 /*
  * Main reset function
  */
-int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
+int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	struct ieee80211_channel *channel, bool change_channel)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
--- everything.orig/drivers/net/wireless/ath9k/main.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/main.c	2008-09-10 23:58:04.000000000 +0200
@@ -140,7 +140,7 @@ static int ath_key_config(struct ath_sof
 	struct ath9k_keyval hk;
 	const u8 *mac = NULL;
 	int ret = 0;
-	enum ieee80211_if_types opmode;
+	enum nl80211_iftype opmode;
 
 	memset(&hk, 0, sizeof(hk));
 
@@ -179,14 +179,14 @@ static int ath_key_config(struct ath_sof
 	 */
 	if (is_broadcast_ether_addr(addr)) {
 		switch (opmode) {
-		case IEEE80211_IF_TYPE_STA:
+		case NL80211_IFTYPE_STATION:
 			/* default key:  could be group WPA key
 			 * or could be static WEP key */
 			mac = NULL;
 			break;
-		case IEEE80211_IF_TYPE_IBSS:
+		case NL80211_IFTYPE_ADHOC:
 			break;
-		case IEEE80211_IF_TYPE_AP:
+		case NL80211_IFTYPE_AP:
 			break;
 		default:
 			ASSERT(0);
@@ -428,13 +428,13 @@ static int ath9k_add_interface(struct ie
 		return -ENOBUFS;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		ic_opmode = ATH9K_M_STA;
 		break;
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		ic_opmode = ATH9K_M_IBSS;
 		break;
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		ic_opmode = ATH9K_M_HOSTAP;
 		break;
 	default:
@@ -556,7 +556,7 @@ static int ath9k_config_interface(struct
 
 	/* TODO: Need to decide which hw opmode to use for multi-interface
 	 * cases */
-	if (vif->type == IEEE80211_IF_TYPE_AP &&
+	if (vif->type == NL80211_IFTYPE_AP &&
 	    ah->ah_opmode != ATH9K_M_HOSTAP) {
 		ah->ah_opmode = ATH9K_M_HOSTAP;
 		ath9k_hw_setopmode(ah);
@@ -568,8 +568,8 @@ static int ath9k_config_interface(struct
 	if ((conf->changed & IEEE80211_IFCC_BSSID) &&
 	    !is_zero_ether_addr(conf->bssid)) {
 		switch (vif->type) {
-		case IEEE80211_IF_TYPE_STA:
-		case IEEE80211_IF_TYPE_IBSS:
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_ADHOC:
 			/* Update ratectrl about the new state */
 			ath_rate_newstate(sc, avp);
 
@@ -614,8 +614,8 @@ static int ath9k_config_interface(struct
 	}
 
 	if ((conf->changed & IEEE80211_IFCC_BEACON) &&
-	    ((vif->type == IEEE80211_IF_TYPE_IBSS) ||
-	     (vif->type == IEEE80211_IF_TYPE_AP))) {
+	    ((vif->type == NL80211_IFTYPE_ADHOC) ||
+	     (vif->type == NL80211_IFTYPE_AP))) {
 		/*
 		 * Allocate and setup the beacon frame.
 		 *
@@ -634,7 +634,7 @@ static int ath9k_config_interface(struct
 	}
 
 	/* Check for WLAN_CAPABILITY_PRIVACY ? */
-	if ((avp->av_opmode != IEEE80211_IF_TYPE_STA)) {
+	if ((avp->av_opmode != NL80211_IFTYPE_STATION)) {
 		for (i = 0; i < IEEE80211_WEP_NKID; i++)
 			if (ath9k_hw_keyisvalid(sc->sc_ah, (u16)i))
 				ath9k_hw_keysetmac(sc->sc_ah,
@@ -643,7 +643,7 @@ static int ath9k_config_interface(struct
 	}
 
 	/* Only legacy IBSS for now */
-	if (vif->type == IEEE80211_IF_TYPE_IBSS)
+	if (vif->type == NL80211_IFTYPE_ADHOC)
 		ath_update_chainmask(sc, 0);
 
 	return 0;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-09-10 23:58:04.000000000 +0200
@@ -851,7 +851,7 @@ struct iwl3945_priv {
 	/* eeprom */
 	struct iwl3945_eeprom eeprom;
 
-	enum ieee80211_if_types iw_mode;
+	enum nl80211_iftype iw_mode;
 
 	struct sk_buff *ibss_beacon;
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-09-10 23:58:04.000000000 +0200
@@ -954,7 +954,7 @@ struct iwl_priv {
 	u8 *eeprom;
 	struct iwl_eeprom_calib_info *calib_info;
 
-	enum ieee80211_if_types iw_mode;
+	enum nl80211_iftype iw_mode;
 
 	struct sk_buff *ibss_beacon;
 
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2008-09-10 23:58:04.000000000 +0200
@@ -483,7 +483,7 @@ struct rt2x00intf_conf {
 	/*
 	 * Interface type
 	 */
-	enum ieee80211_if_types type;
+	enum nl80211_iftype type;
 
 	/*
 	 * TSF sync value, this is dependant on the operation type.
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00config.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00config.c	2008-09-10 23:58:04.000000000 +0200
@@ -31,7 +31,7 @@
 
 void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 			   struct rt2x00_intf *intf,
-			   enum ieee80211_if_types type,
+			   enum nl80211_iftype type,
 			   u8 *mac, u8 *bssid)
 {
 	struct rt2x00intf_conf conf;
@@ -40,11 +40,11 @@ void rt2x00lib_config_intf(struct rt2x00
 	conf.type = type;
 
 	switch (type) {
-	case IEEE80211_IF_TYPE_IBSS:
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
 		conf.sync = TSF_SYNC_BEACON;
 		break;
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		conf.sync = TSF_SYNC_INFRA;
 		break;
 	default:
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00lib.h	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00lib.h	2008-09-10 23:58:04.000000000 +0200
@@ -88,7 +88,7 @@ void rt2x00lib_stop(struct rt2x00_dev *r
  */
 void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 			   struct rt2x00_intf *intf,
-			   enum ieee80211_if_types type,
+			   enum nl80211_iftype type,
 			   u8 *mac, u8 *bssid);
 void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 			  struct rt2x00_intf *intf,
--- everything.orig/drivers/net/wireless/adm8211.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/adm8211.c	2008-09-10 23:58:04.000000000 +0200
@@ -765,11 +765,11 @@ static void adm8211_update_mode(struct i
 
 	priv->soft_rx_crc = 0;
 	switch (priv->mode) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		priv->nar &= ~(ADM8211_NAR_PR | ADM8211_NAR_EA);
 		priv->nar |= ADM8211_NAR_ST | ADM8211_NAR_SR;
 		break;
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		priv->nar &= ~ADM8211_NAR_PR;
 		priv->nar |= ADM8211_NAR_EA | ADM8211_NAR_ST | ADM8211_NAR_SR;
 
@@ -777,7 +777,7 @@ static void adm8211_update_mode(struct i
 		if (priv->pdev->revision >= ADM8211_REV_BA)
 			priv->soft_rx_crc = 1;
 		break;
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		priv->nar &= ~(ADM8211_NAR_EA | ADM8211_NAR_ST);
 		priv->nar |= ADM8211_NAR_PR | ADM8211_NAR_SR;
 		break;
@@ -1410,11 +1410,11 @@ static int adm8211_add_interface(struct 
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct adm8211_priv *priv = dev->priv;
-	if (priv->mode != IEEE80211_IF_TYPE_MNTR)
+	if (priv->mode != NL80211_IFTYPE_MONITOR)
 		return -EOPNOTSUPP;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		priv->mode = conf->type;
 		break;
 	default:
@@ -1437,7 +1437,7 @@ static void adm8211_remove_interface(str
 				     struct ieee80211_if_init_conf *conf)
 {
 	struct adm8211_priv *priv = dev->priv;
-	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->mode = NL80211_IFTYPE_MONITOR;
 }
 
 static int adm8211_init_rings(struct ieee80211_hw *dev)
@@ -1556,7 +1556,7 @@ static int adm8211_start(struct ieee8021
 	ADM8211_CSR_WRITE(IER, ADM8211_IER_NIE | ADM8211_IER_AIE |
 			       ADM8211_IER_RCIE | ADM8211_IER_TCIE |
 			       ADM8211_IER_TDUIE | ADM8211_IER_GPTIE);
-	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->mode = NL80211_IFTYPE_MONITOR;
 	adm8211_update_mode(dev);
 	ADM8211_CSR_WRITE(RDR, 0);
 
@@ -1571,7 +1571,7 @@ static void adm8211_stop(struct ieee8021
 {
 	struct adm8211_priv *priv = dev->priv;
 
-	priv->mode = IEEE80211_IF_TYPE_INVALID;
+	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	priv->nar = 0;
 	ADM8211_CSR_WRITE(NAR, 0);
 	ADM8211_CSR_WRITE(IER, 0);
@@ -1896,7 +1896,7 @@ static int __devinit adm8211_probe(struc
 	priv->tx_power = 0x40;
 	priv->lpf_cutoff = 0xFF;
 	priv->lnags_threshold = 0xFF;
-	priv->mode = IEEE80211_IF_TYPE_INVALID;
+	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 
 	/* Power-on issue. EEPROM won't read correctly without */
 	if (pdev->revision >= ADM8211_REV_BA) {
@@ -1986,7 +1986,7 @@ static int adm8211_suspend(struct pci_de
 	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
 	struct adm8211_priv *priv = dev->priv;
 
-	if (priv->mode != IEEE80211_IF_TYPE_INVALID) {
+	if (priv->mode != NL80211_IFTYPE_UNSPECIFIED) {
 		ieee80211_stop_queues(dev);
 		adm8211_stop(dev);
 	}
@@ -2004,7 +2004,7 @@ static int adm8211_resume(struct pci_dev
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	if (priv->mode != IEEE80211_IF_TYPE_INVALID) {
+	if (priv->mode != NL80211_IFTYPE_UNSPECIFIED) {
 		adm8211_start(dev);
 		ieee80211_wake_queues(dev);
 	}
--- everything.orig/drivers/net/wireless/at76_usb.c	2008-09-10 23:50:20.000000000 +0200
+++ everything/drivers/net/wireless/at76_usb.c	2008-09-10 23:58:04.000000000 +0200
@@ -1928,7 +1928,7 @@ static int at76_add_interface(struct iee
 	mutex_lock(&priv->mtx);
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		priv->iw_mode = IW_MODE_INFRA;
 		break;
 	default:
--- everything.orig/drivers/net/wireless/ath5k/attach.c	2008-09-10 23:50:23.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/attach.c	2008-09-10 23:58:04.000000000 +0200
@@ -124,7 +124,7 @@ struct ath5k_hw *ath5k_hw_attach(struct 
 	/*
 	 * HW information
 	 */
-	ah->ah_op_mode = IEEE80211_IF_TYPE_STA;
+	ah->ah_op_mode = NL80211_IFTYPE_STATION;
 	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
 	ah->ah_turbo = false;
 	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-09-10 23:50:23.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.c	2008-09-10 23:58:04.000000000 +0200
@@ -507,7 +507,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 
 	sc->iobase = mem; /* So we can unmap it on detach */
 	sc->cachelsz = csz * sizeof(u32); /* convert to bytes */
-	sc->opmode = IEEE80211_IF_TYPE_STA;
+	sc->opmode = NL80211_IFTYPE_STATION;
 	mutex_init(&sc->lock);
 	spin_lock_init(&sc->rxbuflock);
 	spin_lock_init(&sc->txbuflock);
@@ -1377,8 +1377,8 @@ ath5k_beaconq_config(struct ath5k_softc 
 	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret)
 		return ret;
-	if (sc->opmode == IEEE80211_IF_TYPE_AP ||
-		sc->opmode == IEEE80211_IF_TYPE_MESH_POINT) {
+	if (sc->opmode == NL80211_IFTYPE_AP ||
+		sc->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/*
 		 * Always burst out beacon and CAB traffic
 		 * (aifs = cwmin = cwmax = 0)
@@ -1386,7 +1386,7 @@ ath5k_beaconq_config(struct ath5k_softc 
 		qi.tqi_aifs = 0;
 		qi.tqi_cw_min = 0;
 		qi.tqi_cw_max = 0;
-	} else if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+	} else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
 		/*
 		 * Adhoc mode; backoff between 0 and (2 * cw_min).
 		 */
@@ -1714,7 +1714,7 @@ ath5k_tasklet_rx(unsigned long data)
 			/* let crypto-error packets fall through in MNTR */
 			if ((rs.rs_status &
 				~(AR5K_RXERR_DECRYPT|AR5K_RXERR_MIC)) ||
-					sc->opmode != IEEE80211_IF_TYPE_MNTR)
+					sc->opmode != NL80211_IFTYPE_MONITOR)
 				goto next;
 		}
 accept:
@@ -1777,7 +1777,7 @@ accept:
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
 
 		/* check beacons in IBSS mode */
-		if (sc->opmode == IEEE80211_IF_TYPE_IBSS)
+		if (sc->opmode == NL80211_IFTYPE_ADHOC)
 			ath5k_check_ibss_tsf(sc, skb, &rxs);
 
 		__ieee80211_rx(sc->hw, skb, &rxs);
@@ -1892,7 +1892,7 @@ ath5k_beacon_setup(struct ath5k_softc *s
 	ds = bf->desc;
 
 	flags = AR5K_TXDESC_NOACK;
-	if (sc->opmode == IEEE80211_IF_TYPE_IBSS && ath5k_hw_hasveol(ah)) {
+	if (sc->opmode == NL80211_IFTYPE_ADHOC && ath5k_hw_hasveol(ah)) {
 		ds->ds_link = bf->daddr;	/* self-linked */
 		flags |= AR5K_TXDESC_VEOL;
 		/*
@@ -1941,8 +1941,8 @@ ath5k_beacon_send(struct ath5k_softc *sc
 
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
-	if (unlikely(bf->skb == NULL || sc->opmode == IEEE80211_IF_TYPE_STA ||
-			sc->opmode == IEEE80211_IF_TYPE_MNTR)) {
+	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION ||
+			sc->opmode == NL80211_IFTYPE_MONITOR)) {
 		ATH5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
 		return;
 	}
@@ -2116,9 +2116,9 @@ ath5k_beacon_config(struct ath5k_softc *
 	sc->bmisscount = 0;
 	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
 
-	if (sc->opmode == IEEE80211_IF_TYPE_STA) {
+	if (sc->opmode == NL80211_IFTYPE_STATION) {
 		sc->imask |= AR5K_INT_BMISS;
-	} else if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+	} else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
 		/*
 		 * In IBSS mode we use a self-linked tx descriptor and let the
 		 * hardware send the beacons automatically. We have to load it
@@ -2323,7 +2323,7 @@ ath5k_intr(int irq, void *dev_id)
 				* transmission time) in order to detect wether
 				* automatic TSF updates happened.
 				*/
-				if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+				if (sc->opmode == NL80211_IFTYPE_ADHOC) {
 					 /* XXX: only if VEOL suppported */
 					u64 tsf = ath5k_hw_get_tsf64(ah);
 					sc->nexttbtt += sc->bintval;
@@ -2553,7 +2553,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct
 
 	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
 
-	if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
+	if (sc->opmode == NL80211_IFTYPE_MONITOR)
 		ATH5K_DBG(sc, ATH5K_DEBUG_XMIT, "tx in monitor (scan?)\n");
 
 	/*
@@ -2688,9 +2688,9 @@ static int ath5k_add_interface(struct ie
 	sc->vif = conf->vif;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MONITOR:
 		sc->opmode = conf->type;
 		break;
 	default:
@@ -2761,7 +2761,7 @@ ath5k_config_interface(struct ieee80211_
 	}
 
 	if (conf->changed & IEEE80211_IFCC_BEACON &&
-	    vif->type == IEEE80211_IF_TYPE_IBSS) {
+	    vif->type == NL80211_IFTYPE_ADHOC) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon) {
 			ret = -ENOMEM;
@@ -2880,17 +2880,17 @@ static void ath5k_configure_filter(struc
 
 	/* XXX move these to mac80211, and add a beacon IFF flag to mac80211 */
 
-	if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
+	if (sc->opmode == NL80211_IFTYPE_MONITOR)
 		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
 			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
-	if (sc->opmode != IEEE80211_IF_TYPE_STA)
+	if (sc->opmode != NL80211_IFTYPE_STATION)
 		rfilt |= AR5K_RX_FILTER_PROBEREQ;
-	if (sc->opmode != IEEE80211_IF_TYPE_AP &&
-		sc->opmode != IEEE80211_IF_TYPE_MESH_POINT &&
+	if (sc->opmode != NL80211_IFTYPE_AP &&
+		sc->opmode != NL80211_IFTYPE_MESH_POINT &&
 		test_bit(ATH_STAT_PROMISC, sc->status))
 		rfilt |= AR5K_RX_FILTER_PROM;
-	if (sc->opmode == IEEE80211_IF_TYPE_STA ||
-		sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+	if (sc->opmode == NL80211_IFTYPE_STATION ||
+		sc->opmode == NL80211_IFTYPE_ADHOC) {
 		rfilt |= AR5K_RX_FILTER_BEACON;
 	}
 
@@ -2995,7 +2995,7 @@ ath5k_reset_tsf(struct ieee80211_hw *hw)
 	 * in IBSS mode we need to update the beacon timers too.
 	 * this will also reset the TSF if we call it with 0
 	 */
-	if (sc->opmode == IEEE80211_IF_TYPE_IBSS)
+	if (sc->opmode == NL80211_IFTYPE_ADHOC)
 		ath5k_beacon_update_timers(sc, 0);
 	else
 		ath5k_hw_reset_tsf(sc->ah);
@@ -3010,7 +3010,7 @@ ath5k_beacon_update(struct ieee80211_hw 
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	if (sc->opmode != IEEE80211_IF_TYPE_IBSS) {
+	if (sc->opmode != NL80211_IFTYPE_ADHOC) {
 		ret = -EIO;
 		goto end;
 	}
--- everything.orig/drivers/net/wireless/ath5k/pcu.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/pcu.c	2008-09-10 23:58:04.000000000 +0200
@@ -52,26 +52,26 @@ int ath5k_hw_set_opmode(struct ath5k_hw 
 	ATH5K_TRACE(ah->ah_sc);
 
 	switch (ah->ah_op_mode) {
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_DESC_ANTENNA |
 			(ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
 		beacon_reg |= AR5K_BCR_ADHOC;
 		break;
 
-	case IEEE80211_IF_TYPE_AP:
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
 		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_RTS_DEF_ANTENNA |
 			(ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
 		beacon_reg |= AR5K_BCR_AP;
 		break;
 
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
 			(ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_PWR_SV : 0);
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
 			(ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
@@ -649,7 +649,7 @@ void ath5k_hw_init_beacon(struct ath5k_h
 	 * Set the additional timers by mode
 	 */
 	switch (ah->ah_op_mode) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		if (ah->ah_version == AR5K_AR5210) {
 			timer1 = 0xffffffff;
 			timer2 = 0xffffffff;
--- everything.orig/drivers/net/wireless/b43/main.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/b43/main.c	2008-09-10 23:58:04.000000000 +0200
@@ -1244,13 +1244,13 @@ generate_new:
 
 static void handle_irq_tbtt_indication(struct b43_wldev *dev)
 {
-	if (b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP)) {
+	if (b43_is_mode(dev->wl, NL80211_IFTYPE_AP)) {
 		///TODO: PS TBTT
 	} else {
 		if (1 /*FIXME: the last PSpoll frame was sent successfully */ )
 			b43_power_saving_ctl_bits(dev, 0);
 	}
-	if (b43_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS))
+	if (b43_is_mode(dev->wl, NL80211_IFTYPE_ADHOC))
 		dev->dfq_valid = 1;
 }
 
@@ -1599,8 +1599,8 @@ static void handle_irq_beacon(struct b43
 	struct b43_wl *wl = dev->wl;
 	u32 cmd, beacon0_valid, beacon1_valid;
 
-	if (!b43_is_mode(wl, IEEE80211_IF_TYPE_AP) &&
-	    !b43_is_mode(wl, IEEE80211_IF_TYPE_MESH_POINT))
+	if (!b43_is_mode(wl, NL80211_IFTYPE_AP) &&
+	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
 		return;
 
 	/* This is the bottom half of the asynchronous beacon update. */
@@ -2568,10 +2568,10 @@ static void b43_adjust_opmode(struct b43
 	ctl &= ~B43_MACCTL_BEACPROMISC;
 	ctl |= B43_MACCTL_INFRA;
 
-	if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP) ||
-	    b43_is_mode(wl, IEEE80211_IF_TYPE_MESH_POINT))
+	if (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
+	    b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
 		ctl |= B43_MACCTL_AP;
-	else if (b43_is_mode(wl, IEEE80211_IF_TYPE_IBSS))
+	else if (b43_is_mode(wl, NL80211_IFTYPE_ADHOC))
 		ctl &= ~B43_MACCTL_INFRA;
 
 	if (wl->filter_flags & FIF_CONTROL)
@@ -3406,8 +3406,8 @@ static int b43_op_config(struct ieee8021
 		phy->ops->set_rx_antenna(dev, antenna);
 
 	/* Update templates for AP/mesh mode. */
-	if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP) ||
-	    b43_is_mode(wl, IEEE80211_IF_TYPE_MESH_POINT))
+	if (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
+	    b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
 		b43_set_beacon_int(dev, conf->beacon_int);
 
 	if (!!conf->radio_enabled != phy->radio_on) {
@@ -3595,14 +3595,14 @@ static int b43_op_config_interface(struc
 	else
 		memset(wl->bssid, 0, ETH_ALEN);
 	if (b43_status(dev) >= B43_STAT_INITIALIZED) {
-		if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP) ||
-		    b43_is_mode(wl, IEEE80211_IF_TYPE_MESH_POINT)) {
+		if (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
+		    b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT)) {
 			B43_WARN_ON(vif->type != wl->if_type);
 			if (conf->changed & IEEE80211_IFCC_SSID)
 				b43_set_ssid(dev, conf->ssid, conf->ssid_len);
 			if (conf->changed & IEEE80211_IFCC_BEACON)
 				b43_update_templates(wl);
-		} else if (b43_is_mode(wl, IEEE80211_IF_TYPE_IBSS)) {
+		} else if (b43_is_mode(wl, NL80211_IFTYPE_ADHOC)) {
 			if (conf->changed & IEEE80211_IFCC_BEACON)
 				b43_update_templates(wl);
 		}
@@ -3903,7 +3903,7 @@ static void b43_set_synth_pu_delay(struc
 		pu_delay = 3700;
 	else
 		pu_delay = 1050;
-	if (b43_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS) || idle)
+	if (b43_is_mode(dev->wl, NL80211_IFTYPE_ADHOC) || idle)
 		pu_delay = 500;
 	if ((dev->phy.radio_ver == 0x2050) && (dev->phy.radio_rev == 8))
 		pu_delay = max(pu_delay, (u16)2400);
@@ -3917,7 +3917,7 @@ static void b43_set_pretbtt(struct b43_w
 	u16 pretbtt;
 
 	/* The time value is in microseconds. */
-	if (b43_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS)) {
+	if (b43_is_mode(dev->wl, NL80211_IFTYPE_ADHOC)) {
 		pretbtt = 2;
 	} else {
 		if (dev->phy.type == B43_PHYTYPE_A)
@@ -4084,11 +4084,11 @@ static int b43_op_add_interface(struct i
 
 	/* TODO: allow WDS/AP devices to coexist */
 
-	if (conf->type != IEEE80211_IF_TYPE_AP &&
-	    conf->type != IEEE80211_IF_TYPE_MESH_POINT &&
-	    conf->type != IEEE80211_IF_TYPE_STA &&
-	    conf->type != IEEE80211_IF_TYPE_WDS &&
-	    conf->type != IEEE80211_IF_TYPE_IBSS)
+	if (conf->type != NL80211_IFTYPE_AP &&
+	    conf->type != NL80211_IFTYPE_MESH_POINT &&
+	    conf->type != NL80211_IFTYPE_STATION &&
+	    conf->type != NL80211_IFTYPE_WDS &&
+	    conf->type != NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&wl->mutex);
--- everything.orig/drivers/net/wireless/b43/phy_common.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/b43/phy_common.c	2008-09-10 23:58:04.000000000 +0200
@@ -162,7 +162,7 @@ void b43_phy_lock(struct b43_wldev *dev)
 #endif
 	B43_WARN_ON(dev->dev->id.revision < 3);
 
-	if (!b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
+	if (!b43_is_mode(dev->wl, NL80211_IFTYPE_AP))
 		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
 }
 
@@ -174,7 +174,7 @@ void b43_phy_unlock(struct b43_wldev *de
 #endif
 	B43_WARN_ON(dev->dev->id.revision < 3);
 
-	if (!b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
+	if (!b43_is_mode(dev->wl, NL80211_IFTYPE_AP))
 		b43_power_saving_ctl_bits(dev, 0);
 }
 
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-09-10 23:58:04.000000000 +0200
@@ -888,13 +888,13 @@ generate_new:
 
 static void handle_irq_tbtt_indication(struct b43legacy_wldev *dev)
 {
-	if (b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_AP)) {
+	if (b43legacy_is_mode(dev->wl, NL80211_IFTYPE_AP)) {
 		/* TODO: PS TBTT */
 	} else {
 		if (1/*FIXME: the last PSpoll frame was sent successfully */)
 			b43legacy_power_saving_ctl_bits(dev, -1, -1);
 	}
-	if (b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS))
+	if (b43legacy_is_mode(dev->wl, NL80211_IFTYPE_ADHOC))
 		dev->dfq_valid = 1;
 }
 
@@ -1201,7 +1201,7 @@ static void handle_irq_beacon(struct b43
 	struct b43legacy_wl *wl = dev->wl;
 	u32 cmd;
 
-	if (!b43legacy_is_mode(wl, IEEE80211_IF_TYPE_AP))
+	if (!b43legacy_is_mode(wl, NL80211_IFTYPE_AP))
 		return;
 
 	/* This is the bottom half of the asynchronous beacon update. */
@@ -1936,9 +1936,9 @@ static void b43legacy_adjust_opmode(stru
 	ctl &= ~B43legacy_MACCTL_BEACPROMISC;
 	ctl |= B43legacy_MACCTL_INFRA;
 
-	if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_AP))
+	if (b43legacy_is_mode(wl, NL80211_IFTYPE_AP))
 		ctl |= B43legacy_MACCTL_AP;
-	else if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_IBSS))
+	else if (b43legacy_is_mode(wl, NL80211_IFTYPE_ADHOC))
 		ctl &= ~B43legacy_MACCTL_INFRA;
 
 	if (wl->filter_flags & FIF_CONTROL)
@@ -2646,7 +2646,7 @@ static int b43legacy_op_dev_config(struc
 	b43legacy_mgmtframe_txantenna(dev, antenna_tx);
 
 	/* Update templates for AP mode. */
-	if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_AP))
+	if (b43legacy_is_mode(wl, NL80211_IFTYPE_AP))
 		b43legacy_set_beacon_int(dev, conf->beacon_int);
 
 
@@ -2733,12 +2733,12 @@ static int b43legacy_op_config_interface
 	else
 		memset(wl->bssid, 0, ETH_ALEN);
 	if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED) {
-		if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
-			B43legacy_WARN_ON(vif->type != IEEE80211_IF_TYPE_AP);
+		if (b43legacy_is_mode(wl, NL80211_IFTYPE_AP)) {
+			B43legacy_WARN_ON(vif->type != NL80211_IFTYPE_AP);
 			b43legacy_set_ssid(dev, conf->ssid, conf->ssid_len);
 			if (conf->changed & IEEE80211_IFCC_BEACON)
 				b43legacy_update_templates(wl);
-		} else if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_IBSS)) {
+		} else if (b43legacy_is_mode(wl, NL80211_IFTYPE_ADHOC)) {
 			if (conf->changed & IEEE80211_IFCC_BEACON)
 				b43legacy_update_templates(wl);
 		}
@@ -3020,7 +3020,7 @@ static void b43legacy_set_synth_pu_delay
 					  bool idle) {
 	u16 pu_delay = 1050;
 
-	if (b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS) || idle)
+	if (b43legacy_is_mode(dev->wl, NL80211_IFTYPE_ADHOC) || idle)
 		pu_delay = 500;
 	if ((dev->phy.radio_ver == 0x2050) && (dev->phy.radio_rev == 8))
 		pu_delay = max(pu_delay, (u16)2400);
@@ -3035,7 +3035,7 @@ static void b43legacy_set_pretbtt(struct
 	u16 pretbtt;
 
 	/* The time value is in microseconds. */
-	if (b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS))
+	if (b43legacy_is_mode(dev->wl, NL80211_IFTYPE_ADHOC))
 		pretbtt = 2;
 	else
 		pretbtt = 250;
@@ -3259,10 +3259,10 @@ static int b43legacy_op_add_interface(st
 
 	/* TODO: allow WDS/AP devices to coexist */
 
-	if (conf->type != IEEE80211_IF_TYPE_AP &&
-	    conf->type != IEEE80211_IF_TYPE_STA &&
-	    conf->type != IEEE80211_IF_TYPE_WDS &&
-	    conf->type != IEEE80211_IF_TYPE_IBSS)
+	if (conf->type != NL80211_IFTYPE_AP &&
+	    conf->type != NL80211_IFTYPE_STATION &&
+	    conf->type != NL80211_IFTYPE_WDS &&
+	    conf->type != NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&wl->mutex);
--- everything.orig/drivers/net/wireless/b43legacy/phy.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/phy.c	2008-09-10 23:58:04.000000000 +0200
@@ -103,7 +103,7 @@ void b43legacy_phy_lock(struct b43legacy
 	if (dev->dev->id.revision < 3) {
 		b43legacy_mac_suspend(dev);
 	} else {
-		if (!b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
+		if (!b43legacy_is_mode(dev->wl, NL80211_IFTYPE_AP))
 			b43legacy_power_saving_ctl_bits(dev, -1, 1);
 	}
 }
@@ -118,7 +118,7 @@ void b43legacy_phy_unlock(struct b43lega
 	if (dev->dev->id.revision < 3) {
 		b43legacy_mac_enable(dev);
 	} else {
-		if (!b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
+		if (!b43legacy_is_mode(dev->wl, NL80211_IFTYPE_AP))
 			b43legacy_power_saving_ctl_bits(dev, -1, -1);
 	}
 }
--- everything.orig/drivers/net/wireless/ipw2100.c	2008-09-10 23:50:20.000000000 +0200
+++ everything/drivers/net/wireless/ipw2100.c	2008-09-10 23:58:04.000000000 +0200
@@ -1,4 +1,4 @@
-/******************************************************************************
+,/******************************************************************************
 
   Copyright(c) 2003 - 2006 Intel Corporation. All rights reserved.
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-10 23:58:04.000000000 +0200
@@ -682,7 +682,7 @@ static void rs_get_rate(void *priv_rate,
 
 	rs_sta = (void *)sta->rate_ctrl_priv;
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !rs_sta->ibss_sta_added) {
 		u8 sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.c	2008-09-10 23:58:04.000000000 +0200
@@ -520,10 +520,10 @@ static int iwl3945_is_network_packet(str
 	/* Filter incoming packets to determine if they are targeted toward
 	 * this network, discarding packets coming from ourselves */
 	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_IBSS: /* Header: Dest. | Source    | BSSID */
+	case NL80211_IFTYPE_ADHOC: /* Header: Dest. | Source    | BSSID */
 		/* packets to our IBSS update information */
 		return !compare_ether_addr(header->addr3, priv->bssid);
-	case IEEE80211_IF_TYPE_STA: /* Header: Dest. | AP{BSSID} | Source */
+	case NL80211_IFTYPE_STATION: /* Header: Dest. | AP{BSSID} | Source */
 		/* packets to our IBSS update information */
 		return !compare_ether_addr(header->addr2, priv->bssid);
 	default:
@@ -807,7 +807,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct
 
 	priv->stations[sta_id].current_rate.rate_n_flags = rate;
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    (sta_id != priv->hw_setting.bcast_sta_id) &&
 		(sta_id != IWL_MULTICAST_ID))
 		priv->stations[IWL_STA_ID].current_rate.rate_n_flags = rate;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-10 23:58:04.000000000 +0200
@@ -821,7 +821,7 @@ static void rs_tx_status(void *priv_rate
 
 	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added)
 		goto out;
 
@@ -2093,7 +2093,7 @@ static void rs_initialize_lq(struct iwl_
 	i = sta->last_txrate_idx;
 
 	if ((lq_sta->lq.sta_id == 0xff) &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
+	    (priv->iw_mode == NL80211_IFTYPE_ADHOC))
 		goto out;
 
 	valid_tx_ant = priv->hw_params.valid_tx_ant;
@@ -2163,7 +2163,7 @@ static void rs_get_rate(void *priv_rate,
 	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
 	i = sta->last_txrate_idx;
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added) {
 		u8 sta_id = iwl_find_station(priv, hdr->addr1);
 		DECLARE_MAC_BUF(mac);
@@ -2243,7 +2243,7 @@ static void rs_rate_init(void *priv_rate
 	 * after assoc.. */
 
 	lq_sta->ibss_sta_added = 0;
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {
 		u8 sta_id = iwl_find_station(priv, sta->addr);
 		DECLARE_MAC_BUF(mac);
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-09-10 23:58:04.000000000 +0200
@@ -337,7 +337,7 @@ static int iwl4965_commit_rxon(struct iw
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
 	if (new_assoc) {
-		if (priv->iw_mode == IEEE80211_IF_TYPE_STA) {
+		if (priv->iw_mode == NL80211_IFTYPE_STATION) {
 			ret = iwl_rxon_add_station(priv,
 					   priv->active_rxon.bssid_addr, 1);
 			if (ret == IWL_INVALID_STATION) {
@@ -448,8 +448,8 @@ static unsigned int iwl_fill_beacon_fram
 					  const u8 *dest, int left)
 {
 	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
-	    ((priv->iw_mode != IEEE80211_IF_TYPE_IBSS) &&
-	     (priv->iw_mode != IEEE80211_IF_TYPE_AP)))
+	    ((priv->iw_mode != NL80211_IFTYPE_ADHOC) &&
+	     (priv->iw_mode != NL80211_IFTYPE_AP)))
 		return 0;
 
 	if (priv->ibss_beacon->len > left)
@@ -672,7 +672,7 @@ static void iwl4965_setup_rxon_timing(st
 	beacon_int = priv->beacon_int;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_STA) {
+	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
 		if (beacon_int == 0) {
 			priv->rxon_timing.beacon_interval = cpu_to_le16(100);
 			priv->rxon_timing.beacon_init_val = cpu_to_le32(102400);
@@ -721,7 +721,7 @@ static void iwl_set_flags_for_band(struc
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
@@ -740,23 +740,23 @@ static void iwl4965_connection_init_rx_c
 	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 
 	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_AP;
 		break;
 
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_ESS;
 		priv->staging_rxon.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_IBSS;
 		priv->staging_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
 		priv->staging_rxon.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
 						  RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_SNIFFER;
 		priv->staging_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
 		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
@@ -785,7 +785,7 @@ static void iwl4965_connection_init_rx_c
 	 * in some case A channels are all non IBSS
 	 * in this case force B/G channel
 	 */
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !(is_channel_ibss(ch_info)))
 		ch_info = &priv->channel_info[0];
 
@@ -1182,7 +1182,7 @@ static void iwl4965_rx_beacon_notif(stru
 		le32_to_cpu(beacon->low_tsf), rate);
 #endif
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_AP) &&
 	    (!test_bit(STATUS_EXIT_PENDING, &priv->status)))
 		queue_work(priv->workqueue, &priv->beacon_update);
 }
@@ -2388,7 +2388,7 @@ static void iwl4965_bg_set_monitor(struc
 
 	mutex_lock(&priv->mutex);
 
-	ret = iwl4965_set_mode(priv, IEEE80211_IF_TYPE_MNTR);
+	ret = iwl4965_set_mode(priv, NL80211_IFTYPE_MONITOR);
 
 	if (ret) {
 		if (ret == -EAGAIN)
@@ -2469,7 +2469,7 @@ static void iwl4965_post_associate(struc
 	DECLARE_MAC_BUF(mac);
 	unsigned long flags;
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {
 		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
 		return;
 	}
@@ -2524,7 +2524,7 @@ static void iwl4965_post_associate(struc
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 	}
@@ -2532,10 +2532,10 @@ static void iwl4965_post_associate(struc
 	iwl4965_commit_rxon(priv);
 
 	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		break;
 
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 
 		/* assume default assoc id */
 		priv->assoc_id = 1;
@@ -2551,7 +2551,7 @@ static void iwl4965_post_associate(struc
 		break;
 	}
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
 		priv->assoc_station_added = 1;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -2828,7 +2828,7 @@ static int iwl4965_mac_config(struct iee
 		goto out;
 	}
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS &&
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
 	    !is_channel_ibss(ch_info)) {
 		IWL_ERROR("channel %d in band %d not IBSS channel\n",
 			conf->channel->hw_value, conf->channel->band);
@@ -2943,7 +2943,7 @@ static void iwl4965_config_ap(struct iwl
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 
-			if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
+			if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 		}
@@ -2982,7 +2982,7 @@ static int iwl4965_mac_config_interface(
 		return 0;
 	}
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS &&
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
 	    conf->changed & IEEE80211_IFCC_BEACON) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon)
@@ -2992,7 +2992,7 @@ static int iwl4965_mac_config_interface(
 			return rc;
 	}
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_AP) &&
 	    (!conf->ssid_len)) {
 		IWL_DEBUG_MAC80211
 		    ("Leaving in AP mode because HostAPD is not ready.\n");
@@ -3015,7 +3015,7 @@ static int iwl4965_mac_config_interface(
 	    !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
  */
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {
 		if (!conf->bssid) {
 			conf->bssid = priv->mac_addr;
 			memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
@@ -3050,11 +3050,11 @@ static int iwl4965_mac_config_interface(
 		 * to verify) - jpk */
 		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 
-		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
+		if (priv->iw_mode == NL80211_IFTYPE_AP)
 			iwl4965_config_ap(priv);
 		else {
 			rc = iwl4965_commit_rxon(priv);
-			if ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && rc)
+			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
 				iwl_rxon_add_station(
 					priv, priv->active_rxon.bssid_addr, 1);
 		}
@@ -3090,7 +3090,7 @@ static void iwl4965_configure_filter(str
 
 	if (changed_flags & (*total_flags) & FIF_OTHER_BSS) {
 		IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
-				   IEEE80211_IF_TYPE_MNTR,
+				   NL80211_IFTYPE_MONITOR,
 				   changed_flags, *total_flags);
 		/* queue work 'cuz mac80211 is holding a lock which
 		 * prevents us from issuing (synchronous) f/w cmds */
@@ -3204,7 +3204,7 @@ static int iwl_mac_hw_scan(struct ieee80
 		goto out_unlock;
 	}
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {	/* APs don't scan */
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {	/* APs don't scan */
 		ret = -EIO;
 		IWL_ERROR("ERROR: APs don't scan\n");
 		goto out_unlock;
@@ -3329,7 +3329,7 @@ static int iwl4965_mac_set_key(struct ie
 	 * in 1X mode.
 	 * In legacy wep mode, we use another host command to the uCode */
 	if (key->alg == ALG_WEP && sta_id == priv->hw_params.bcast_sta_id &&
-		priv->iw_mode != IEEE80211_IF_TYPE_AP) {
+		priv->iw_mode != NL80211_IFTYPE_AP) {
 		if (cmd == SET_KEY)
 			is_default_wep_key = !priv->key_mapping_key;
 		else
@@ -3400,7 +3400,7 @@ static int iwl4965_mac_conf_tx(struct ie
 	priv->qos_data.def_qos_parm.ac[q].reserved1 = 0;
 	priv->qos_data.qos_active = 1;
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
+	if (priv->iw_mode == NL80211_IFTYPE_AP)
 		iwl_activate_qos(priv, 1);
 	else if (priv->assoc_id && iwl_is_associated(priv))
 		iwl_activate_qos(priv, 0);
@@ -3518,7 +3518,7 @@ static void iwl4965_mac_reset_tsf(struct
 
 	priv->beacon_int = priv->hw->conf.beacon_int;
 	priv->timestamp = 0;
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_STA))
+	if ((priv->iw_mode == NL80211_IFTYPE_STATION))
 		priv->beacon_int = 0;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -3532,7 +3532,7 @@ static void iwl4965_mac_reset_tsf(struct
 	/* we are restarting association process
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	 */
-	if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode != NL80211_IFTYPE_AP) {
 		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
@@ -3541,7 +3541,7 @@ static void iwl4965_mac_reset_tsf(struct
 	iwl_power_update_mode(priv, 0);
 
 	/* Per mac80211.h: This is only used in IBSS mode... */
-	if (priv->iw_mode != IEEE80211_IF_TYPE_IBSS) {
+	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 
 		/* switch to CAM during association period.
 		 * the ucode will block any association/authentication
@@ -3580,7 +3580,7 @@ static int iwl4965_mac_beacon_update(str
 		return -EIO;
 	}
 
-	if (priv->iw_mode != IEEE80211_IF_TYPE_IBSS) {
+	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 		IWL_DEBUG_MAC80211("leave - not IBSS\n");
 		mutex_unlock(&priv->mutex);
 		return -EIO;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-core.c	2008-09-10 23:58:04.000000000 +0200
@@ -306,14 +306,14 @@ void iwl_reset_qos(struct iwl_priv *priv
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->qos_data.qos_active = 0;
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS) {
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC) {
 		if (priv->qos_data.qos_enable)
 			priv->qos_data.qos_active = 1;
 		if (!(priv->active_rate & 0xfff0)) {
 			cw_min = 31;
 			is_legacy = 1;
 		}
-	} else if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+	} else if (priv->iw_mode == NL80211_IFTYPE_AP) {
 		if (priv->qos_data.qos_enable)
 			priv->qos_data.qos_active = 1;
 	} else if (!(priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK)) {
@@ -932,7 +932,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->ieee_rates = NULL;
 	priv->band = IEEE80211_BAND_2GHZ;
 
-	priv->iw_mode = IEEE80211_IF_TYPE_STA;
+	priv->iw_mode = NL80211_IFTYPE_STATION;
 
 	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
 	priv->current_ht_config.sm_ps = WLAN_HT_CAP_SM_PS_DISABLED;
@@ -1396,7 +1396,7 @@ void iwl_radio_kill_sw_disable_radio(str
 
 	iwl_scan_cancel(priv);
 	/* FIXME: This is a workaround for AP */
-	if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode != NL80211_IFTYPE_AP) {
 		spin_lock_irqsave(&priv->lock, flags);
 		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_SW_BIT_RFKILL);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-power.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-power.c	2008-09-10 23:58:04.000000000 +0200
@@ -290,7 +290,7 @@ int iwl_power_update_mode(struct iwl_pri
 		final_mode = setting->critical_power_setting;
 
 	/* driver only support CAM for non STA network */
-	if (priv->iw_mode != IEEE80211_IF_TYPE_STA)
+	if (priv->iw_mode != NL80211_IFTYPE_STATION)
 		final_mode = IWL_POWER_MODE_CAM;
 
 	if (!iwl_is_rfkill(priv) && !setting->power_disabled &&
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-rx.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-rx.c	2008-09-10 23:58:05.000000000 +0200
@@ -1026,10 +1026,10 @@ static int iwl_is_network_packet(struct 
 	/* Filter incoming packets to determine if they are targeted toward
 	 * this network, discarding packets coming from ourselves */
 	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_IBSS: /* Header: Dest. | Source    | BSSID */
+	case NL80211_IFTYPE_ADHOC: /* Header: Dest. | Source    | BSSID */
 		/* packets to our IBSS update information */
 		return !compare_ether_addr(header->addr3, priv->bssid);
-	case IEEE80211_IF_TYPE_STA: /* Header: Dest. | AP{BSSID} | Source */
+	case NL80211_IFTYPE_STATION: /* Header: Dest. | AP{BSSID} | Source */
 		/* packets to our IBSS update information */
 		return !compare_ether_addr(header->addr2, priv->bssid);
 	default:
@@ -1169,7 +1169,7 @@ void iwl_rx_reply_rx(struct iwl_priv *pr
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
 	/* Take shortcut when only in monitor mode */
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
+	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		iwl_pass_packet_to_mac80211(priv, include_phy,
 						 rxb, &rx_status);
 		return;
@@ -1186,7 +1186,7 @@ void iwl_rx_reply_rx(struct iwl_priv *pr
 	switch (fc & IEEE80211_FCTL_FTYPE) {
 	case IEEE80211_FTYPE_MGMT:
 	case IEEE80211_FTYPE_DATA:
-		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
+		if (priv->iw_mode == NL80211_IFTYPE_AP)
 			iwl_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
 						header->addr2);
 		/* fall through */
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-scan.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-scan.c	2008-09-10 23:58:05.000000000 +0200
@@ -463,7 +463,7 @@ void iwl_init_scan_params(struct iwl_pri
 
 int iwl_scan_initiate(struct iwl_priv *priv)
 {
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {
 		IWL_ERROR("APs don't scan.\n");
 		return 0;
 	}
@@ -868,7 +868,7 @@ static void iwl_bg_request_scan(struct w
 
 	scan->tx_cmd.len = cpu_to_le16(cmd_len);
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
+	if (priv->iw_mode == NL80211_IFTYPE_MONITOR)
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
 	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-sta.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-sta.c	2008-09-10 23:58:05.000000000 +0200
@@ -47,8 +47,8 @@ u8 iwl_find_station(struct iwl_priv *pri
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) ||
-	    (priv->iw_mode == IEEE80211_IF_TYPE_AP))
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) ||
+	    (priv->iw_mode == NL80211_IFTYPE_AP))
 		start = IWL_STA_ID;
 
 	if (is_broadcast_ether_addr(addr))
@@ -74,7 +74,7 @@ EXPORT_SYMBOL(iwl_find_station);
 
 int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 {
-	if (priv->iw_mode == IEEE80211_IF_TYPE_STA) {
+	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
 		return IWL_AP_ID;
 	} else {
 		u8 *da = ieee80211_get_DA(hdr);
@@ -286,7 +286,7 @@ u8 iwl_add_station_flags(struct iwl_priv
 
 	/* BCAST station and IBSS stations do not work in HT mode */
 	if (sta_id != priv->hw_params.bcast_sta_id &&
-	    priv->iw_mode != IEEE80211_IF_TYPE_IBSS)
+	    priv->iw_mode != NL80211_IFTYPE_ADHOC)
 		iwl_set_ht_add_station(priv, sta_id, ht_info);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -817,7 +817,7 @@ int iwl_send_lq_cmd(struct iwl_priv *pri
 	};
 
 	if ((lq->sta_id == 0xFF) &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
+	    (priv->iw_mode == NL80211_IFTYPE_ADHOC))
 		return -EINVAL;
 
 	if (lq->sta_id == 0xFF)
@@ -904,7 +904,7 @@ int iwl_rxon_add_station(struct iwl_priv
 
 	if ((is_ap) &&
 	    (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_STA))
+	    (priv->iw_mode == NL80211_IFTYPE_STATION))
 		sta_id = iwl_add_station_flags(priv, addr, is_ap,
 						   0, cur_ht_config);
 	else
@@ -938,11 +938,11 @@ int iwl_get_sta_id(struct iwl_priv *priv
 
 	/* If we are a client station in a BSS network, use the special
 	 * AP station entry (that's the only station we communicate with) */
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		return IWL_AP_ID;
 
 	/* If we are an AP, then find the station, or use BCAST */
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		sta_id = iwl_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
@@ -950,7 +950,7 @@ int iwl_get_sta_id(struct iwl_priv *priv
 
 	/* If this frame is going out to an IBSS network, find the station,
 	 * or create a new station table entry */
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		sta_id = iwl_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
@@ -970,7 +970,7 @@ int iwl_get_sta_id(struct iwl_priv *priv
 
 	/* If we are in monitor mode, use BCAST. This is required for
 	 * packet injection. */
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		return priv->hw_params.bcast_sta_id;
 
 	default:
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-09-10 23:58:05.000000000 +0200
@@ -814,10 +814,10 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 
 	/* drop all data frame if we are not associated */
 	if (ieee80211_is_data(fc) &&
-	    (priv->iw_mode != IEEE80211_IF_TYPE_MNTR ||
+	    (priv->iw_mode != NL80211_IFTYPE_MONITOR ||
 	    !(info->flags & IEEE80211_TX_CTL_INJECTED)) && /* packet injection */
 	    (!iwl_is_associated(priv) ||
-	     ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id) ||
+	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id) ||
 	     !priv->assoc_station_added)) {
 		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
 		goto drop_unlock;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-09-10 23:58:05.000000000 +0200
@@ -1160,7 +1160,7 @@ static int iwl3945_commit_rxon(struct iw
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
 	if (iwl3945_is_associated(priv) &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_STA))
+	    (priv->iw_mode == NL80211_IFTYPE_STATION))
 		if (iwl3945_add_station(priv, priv->active_rxon.bssid_addr, 1, 0)
 		    == IWL_INVALID_STATION) {
 			IWL_ERROR("Error adding AP address for transmit.\n");
@@ -1447,8 +1447,8 @@ unsigned int iwl3945_fill_beacon_frame(s
 {
 
 	if (!iwl3945_is_associated(priv) || !priv->ibss_beacon ||
-	    ((priv->iw_mode != IEEE80211_IF_TYPE_IBSS) &&
-	     (priv->iw_mode != IEEE80211_IF_TYPE_AP)))
+	    ((priv->iw_mode != NL80211_IFTYPE_ADHOC) &&
+	     (priv->iw_mode != NL80211_IFTYPE_AP)))
 		return 0;
 
 	if (priv->ibss_beacon->len > left)
@@ -1746,14 +1746,14 @@ static void iwl3945_reset_qos(struct iwl
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->qos_data.qos_active = 0;
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS) {
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC) {
 		if (priv->qos_data.qos_enable)
 			priv->qos_data.qos_active = 1;
 		if (!(priv->active_rate & 0xfff0)) {
 			cw_min = 31;
 			is_legacy = 1;
 		}
-	} else if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+	} else if (priv->iw_mode == NL80211_IFTYPE_AP) {
 		if (priv->qos_data.qos_enable)
 			priv->qos_data.qos_active = 1;
 	} else if (!(priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK)) {
@@ -2120,7 +2120,7 @@ static void iwl3945_setup_rxon_timing(st
 	beacon_int = priv->beacon_int;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_STA) {
+	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
 		if (beacon_int == 0) {
 			priv->rxon_timing.beacon_interval = cpu_to_le16(100);
 			priv->rxon_timing.beacon_init_val = cpu_to_le32(102400);
@@ -2156,7 +2156,7 @@ static void iwl3945_setup_rxon_timing(st
 
 static int iwl3945_scan_initiate(struct iwl3945_priv *priv)
 {
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {
 		IWL_ERROR("APs don't scan.\n");
 		return 0;
 	}
@@ -2218,7 +2218,7 @@ static void iwl3945_set_flags_for_phymod
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
@@ -2237,23 +2237,23 @@ static void iwl3945_connection_init_rx_c
 	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 
 	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_AP;
 		break;
 
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_ESS;
 		priv->staging_rxon.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_IBSS;
 		priv->staging_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
 		priv->staging_rxon.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
 						  RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		priv->staging_rxon.dev_type = RXON_DEV_TYPE_SNIFFER;
 		priv->staging_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
 		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
@@ -2282,7 +2282,7 @@ static void iwl3945_connection_init_rx_c
 	 * in some case A channels are all non IBSS
 	 * in this case force B/G channel
 	 */
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !(is_channel_ibss(ch_info)))
 		ch_info = &priv->channel_info[0];
 
@@ -2302,7 +2302,7 @@ static void iwl3945_connection_init_rx_c
 
 static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 {
-	if (mode == IEEE80211_IF_TYPE_IBSS) {
+	if (mode == NL80211_IFTYPE_ADHOC) {
 		const struct iwl3945_channel_info *ch_info;
 
 		ch_info = iwl3945_get_channel_info(priv,
@@ -2469,11 +2469,11 @@ static int iwl3945_get_sta_id(struct iwl
 
 	/* If we are a client station in a BSS network, use the special
 	 * AP station entry (that's the only station we communicate with) */
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		return IWL_AP_ID;
 
 	/* If we are an AP, then find the station, or use BCAST */
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
@@ -2481,7 +2481,7 @@ static int iwl3945_get_sta_id(struct iwl
 
 	/* If this frame is going out to an IBSS network, find the station,
 	 * or create a new station table entry */
-	case IEEE80211_IF_TYPE_IBSS: {
+	case NL80211_IFTYPE_ADHOC: {
 		DECLARE_MAC_BUF(mac);
 
 		/* Create new station table entry */
@@ -2502,7 +2502,7 @@ static int iwl3945_get_sta_id(struct iwl
 	}
 	/* If we are in monitor mode, use BCAST. This is required for
 	 * packet injection. */
-	case IEEE80211_IF_TYPE_MNTR:
+	case NL80211_IFTYPE_MONITOR:
 		return priv->hw_setting.bcast_sta_id;
 
 	default:
@@ -2565,9 +2565,9 @@ static int iwl3945_tx_skb(struct iwl3945
 
 	/* drop all data frame if we are not associated */
 	if (ieee80211_is_data(fc) &&
-	    (priv->iw_mode != IEEE80211_IF_TYPE_MNTR) && /* packet injection */
+	    (priv->iw_mode != NL80211_IFTYPE_MONITOR) && /* packet injection */
 	    (!iwl3945_is_associated(priv) ||
-	     ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id))) {
+	     ((priv->iw_mode == NL80211_IFTYPE_STATION) && !priv->assoc_id))) {
 		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
 		goto drop_unlock;
 	}
@@ -2806,7 +2806,7 @@ static void iwl3945_radio_kill_sw(struct
 	if (disable_radio) {
 		iwl3945_scan_cancel(priv);
 		/* FIXME: This is a workaround for AP */
-		if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
+		if (priv->iw_mode != NL80211_IFTYPE_AP) {
 			spin_lock_irqsave(&priv->lock, flags);
 			iwl3945_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_SW_BIT_RFKILL);
@@ -3161,7 +3161,7 @@ static void iwl3945_rx_beacon_notif(stru
 		le32_to_cpu(beacon->low_tsf), rate);
 #endif
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_AP) &&
 	    (!test_bit(STATUS_EXIT_PENDING, &priv->status)))
 		queue_work(priv->workqueue, &priv->beacon_update);
 }
@@ -6059,7 +6059,7 @@ static void iwl3945_bg_set_monitor(struc
 	if (!iwl3945_is_ready(priv))
 		IWL_DEBUG(IWL_DL_STATE, "leave - not ready\n");
 	else
-		if (iwl3945_set_mode(priv, IEEE80211_IF_TYPE_MNTR) != 0)
+		if (iwl3945_set_mode(priv, NL80211_IFTYPE_MONITOR) != 0)
 			IWL_ERROR("iwl3945_set_mode() failed\n");
 
 	mutex_unlock(&priv->mutex);
@@ -6248,7 +6248,7 @@ static void iwl3945_bg_request_scan(stru
 	/* select Rx antennas */
 	scan->flags |= iwl3945_get_antenna_flags(priv);
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
+	if (priv->iw_mode == NL80211_IFTYPE_MONITOR)
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
 	scan->channel_count =
@@ -6323,7 +6323,7 @@ static void iwl3945_post_associate(struc
 	struct ieee80211_conf *conf = NULL;
 	DECLARE_MAC_BUF(mac);
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {
 		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
 		return;
 	}
@@ -6372,7 +6372,7 @@ static void iwl3945_post_associate(struc
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 	}
@@ -6380,11 +6380,11 @@ static void iwl3945_post_associate(struc
 	iwl3945_commit_rxon(priv);
 
 	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		iwl3945_rate_scale_init(priv->hw, IWL_AP_ID);
 		break;
 
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_ADHOC:
 
 		/* clear out the station table */
 		iwl3945_clear_stations_table(priv);
@@ -6754,7 +6754,7 @@ static void iwl3945_config_ap(struct iwl
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 
-			if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
+			if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
 				priv->staging_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 		}
@@ -6791,7 +6791,7 @@ static int iwl3945_mac_config_interface(
 	}
 
 	/* handle this temporarily here */
-	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS &&
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
 	    conf->changed & IEEE80211_IFCC_BEACON) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon)
@@ -6803,7 +6803,7 @@ static int iwl3945_mac_config_interface(
 
 	/* XXX: this MUST use conf->mac_addr */
 
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_AP) &&
 	    (!conf->ssid_len)) {
 		IWL_DEBUG_MAC80211
 		    ("Leaving in AP mode because HostAPD is not ready.\n");
@@ -6826,7 +6826,7 @@ static int iwl3945_mac_config_interface(
 	    !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
  */
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {
 		if (!conf->bssid) {
 			conf->bssid = priv->mac_addr;
 			memcpy(priv->bssid, priv->mac_addr, ETH_ALEN);
@@ -6861,11 +6861,11 @@ static int iwl3945_mac_config_interface(
 		 * to verify) - jpk */
 		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 
-		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
+		if (priv->iw_mode == NL80211_IFTYPE_AP)
 			iwl3945_config_ap(priv);
 		else {
 			rc = iwl3945_commit_rxon(priv);
-			if ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && rc)
+			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
 				iwl3945_add_station(priv,
 					priv->active_rxon.bssid_addr, 1, 0);
 		}
@@ -6901,7 +6901,7 @@ static void iwl3945_configure_filter(str
 
 	if (changed_flags & (*total_flags) & FIF_OTHER_BSS) {
 		IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
-				   IEEE80211_IF_TYPE_MNTR,
+				   NL80211_IFTYPE_MONITOR,
 				   changed_flags, *total_flags);
 		/* queue work 'cuz mac80211 is holding a lock which
 		 * prevents us from issuing (synchronous) f/w cmds */
@@ -7010,7 +7010,7 @@ static int iwl3945_mac_hw_scan(struct ie
 		goto out_unlock;
 	}
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {	/* APs don't scan */
+	if (priv->iw_mode == NL80211_IFTYPE_AP) {	/* APs don't scan */
 		rc = -EIO;
 		IWL_ERROR("ERROR: APs don't scan\n");
 		goto out_unlock;
@@ -7152,7 +7152,7 @@ static int iwl3945_mac_conf_tx(struct ie
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	mutex_lock(&priv->mutex);
-	if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
+	if (priv->iw_mode == NL80211_IFTYPE_AP)
 		iwl3945_activate_qos(priv, 1);
 	else if (priv->assoc_id && iwl3945_is_associated(priv))
 		iwl3945_activate_qos(priv, 0);
@@ -7239,7 +7239,7 @@ static void iwl3945_mac_reset_tsf(struct
 	priv->beacon_int = priv->hw->conf.beacon_int;
 	priv->timestamp1 = 0;
 	priv->timestamp0 = 0;
-	if ((priv->iw_mode == IEEE80211_IF_TYPE_STA))
+	if ((priv->iw_mode == NL80211_IFTYPE_STATION))
 		priv->beacon_int = 0;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -7253,14 +7253,14 @@ static void iwl3945_mac_reset_tsf(struct
 	/* we are restarting association process
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	*/
-	if (priv->iw_mode != IEEE80211_IF_TYPE_AP) {
+	if (priv->iw_mode != NL80211_IFTYPE_AP) {
 		iwl3945_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
 
 	/* Per mac80211.h: This is only used in IBSS mode... */
-	if (priv->iw_mode != IEEE80211_IF_TYPE_IBSS) {
+	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 
 		IWL_DEBUG_MAC80211("leave - not in IBSS\n");
 		mutex_unlock(&priv->mutex);
@@ -7289,7 +7289,7 @@ static int iwl3945_mac_beacon_update(str
 		return -EIO;
 	}
 
-	if (priv->iw_mode != IEEE80211_IF_TYPE_IBSS) {
+	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 		IWL_DEBUG_MAC80211("leave - not IBSS\n");
 		mutex_unlock(&priv->mutex);
 		return -EIO;
@@ -7996,7 +7996,7 @@ static int iwl3945_pci_probe(struct pci_
 		IWL_DEBUG_INFO("Radio disabled.\n");
 	}
 
-	priv->iw_mode = IEEE80211_IF_TYPE_STA;
+	priv->iw_mode = NL80211_IFTYPE_STATION;
 
 	printk(KERN_INFO DRV_NAME
 		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
--- everything.orig/drivers/net/wireless/libertas_tf/main.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/libertas_tf/main.c	2008-09-10 23:58:05.000000000 +0200
@@ -219,7 +219,7 @@ static void lbtf_tx_work(struct work_str
 	struct sk_buff *skb = NULL;
 	int err;
 
-	if ((priv->vif->type == IEEE80211_IF_TYPE_AP) &&
+	if ((priv->vif->type == NL80211_IFTYPE_AP) &&
 	    (!skb_queue_empty(&priv->bc_ps_buf)))
 		skb = skb_dequeue(&priv->bc_ps_buf);
 	else if (priv->skb_to_tx) {
@@ -326,11 +326,11 @@ static int lbtf_op_add_interface(struct 
 
 	priv->vif = conf->vif;
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_MESH_POINT:
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_AP:
 		lbtf_set_mode(priv, LBTF_AP_MODE);
 		break;
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		lbtf_set_mode(priv, LBTF_STA_MODE);
 		break;
 	default:
@@ -346,8 +346,8 @@ static void lbtf_op_remove_interface(str
 {
 	struct lbtf_private *priv = hw->priv;
 
-	if (priv->vif->type == IEEE80211_IF_TYPE_AP ||
-	    priv->vif->type == IEEE80211_IF_TYPE_MESH_POINT)
+	if (priv->vif->type == NL80211_IFTYPE_AP ||
+	    priv->vif->type == NL80211_IFTYPE_MESH_POINT)
 		lbtf_beacon_ctrl(priv, 0, 0);
 	lbtf_set_mode(priv, LBTF_PASSIVE_MODE);
 	lbtf_set_bssid(priv, 0, NULL);
@@ -372,8 +372,8 @@ static int lbtf_op_config_interface(stru
 	struct sk_buff *beacon;
 
 	switch (priv->vif->type) {
-	case IEEE80211_IF_TYPE_AP:
-	case IEEE80211_IF_TYPE_MESH_POINT:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
 		beacon = ieee80211_beacon_get(hw, vif);
 		if (beacon) {
 			lbtf_beacon_set(priv, beacon);
@@ -614,7 +614,7 @@ void lbtf_bcn_sent(struct lbtf_private *
 {
 	struct sk_buff *skb = NULL;
 
-	if (priv->vif->type != IEEE80211_IF_TYPE_AP)
+	if (priv->vif->type != NL80211_IFTYPE_AP)
 		return;
 
 	if (skb_queue_empty(&priv->bc_ps_buf)) {
--- everything.orig/drivers/net/wireless/mac80211_hwsim.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/mac80211_hwsim.c	2008-09-10 23:58:05.000000000 +0200
@@ -267,7 +267,7 @@ static void mac80211_hwsim_beacon_tx(voi
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
 
-	if (vif->type != IEEE80211_IF_TYPE_AP)
+	if (vif->type != NL80211_IFTYPE_AP)
 		return;
 
 	skb = ieee80211_beacon_get(hw, vif);
--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-09-10 23:58:05.000000000 +0200
@@ -1139,7 +1139,7 @@ static int p54_start(struct ieee80211_hw
 
 	err = priv->open(dev);
 	if (!err)
-		priv->mode = IEEE80211_IF_TYPE_MNTR;
+		priv->mode = NL80211_IFTYPE_MONITOR;
 
 	p54_init_vdcf(dev);
 
@@ -1157,7 +1157,7 @@ static void p54_stop(struct ieee80211_hw
 		kfree_skb(skb);
 	priv->stop(dev);
 	priv->tsf_high32 = priv->tsf_low32 = 0;
-	priv->mode = IEEE80211_IF_TYPE_INVALID;
+	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 }
 
 static int p54_add_interface(struct ieee80211_hw *dev,
@@ -1165,11 +1165,11 @@ static int p54_add_interface(struct ieee
 {
 	struct p54_common *priv = dev->priv;
 
-	if (priv->mode != IEEE80211_IF_TYPE_MNTR)
+	if (priv->mode != NL80211_IFTYPE_MONITOR)
 		return -EOPNOTSUPP;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		priv->mode = conf->type;
 		break;
 	default:
@@ -1181,7 +1181,7 @@ static int p54_add_interface(struct ieee
 	p54_set_filter(dev, 0, NULL);
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		p54_set_filter(dev, 1, NULL);
 		break;
 	default:
@@ -1198,7 +1198,7 @@ static void p54_remove_interface(struct 
 				 struct ieee80211_if_init_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
-	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->mode = NL80211_IFTYPE_MONITOR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
 	p54_set_filter(dev, 0, NULL);
 }
@@ -1380,7 +1380,7 @@ struct ieee80211_hw *p54_init_common(siz
 		return NULL;
 
 	priv = dev->priv;
-	priv->mode = IEEE80211_IF_TYPE_INVALID;
+	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	skb_queue_head_init(&priv->tx_queue);
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
 		     IEEE80211_HW_RX_INCLUDES_FCS |
--- everything.orig/drivers/net/wireless/p54/p54pci.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54pci.c	2008-09-10 23:58:05.000000000 +0200
@@ -616,7 +616,7 @@ static int p54p_suspend(struct pci_dev *
 	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
 	struct p54p_priv *priv = dev->priv;
 
-	if (priv->common.mode != IEEE80211_IF_TYPE_INVALID) {
+	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED) {
 		ieee80211_stop_queues(dev);
 		p54p_stop(dev);
 	}
@@ -634,7 +634,7 @@ static int p54p_resume(struct pci_dev *p
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	if (priv->common.mode != IEEE80211_IF_TYPE_INVALID) {
+	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED) {
 		p54p_open(dev);
 		ieee80211_wake_queues(dev);
 	}
--- everything.orig/drivers/net/wireless/rt2x00/rt2500usb.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2500usb.c	2008-09-10 23:58:05.000000000 +0200
@@ -384,7 +384,7 @@ static void rt2500usb_config_intf(struct
 		rt2500usb_register_read(rt2x00dev, TXRX_CSR20, &reg);
 		rt2x00_set_field16(&reg, TXRX_CSR20_OFFSET, bcn_preload >> 6);
 		rt2x00_set_field16(&reg, TXRX_CSR20_BCN_EXPECT_WINDOW,
-				   2 * (conf->type != IEEE80211_IF_TYPE_STA));
+				   2 * (conf->type != NL80211_IFTYPE_STATION));
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR20, reg);
 
 		/*
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-09-10 23:58:05.000000000 +0200
@@ -467,8 +467,8 @@ static void rt2x00lib_beacondone_iter(vo
 	struct rt2x00_dev *rt2x00dev = data;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 
-	if (vif->type != IEEE80211_IF_TYPE_AP &&
-	    vif->type != IEEE80211_IF_TYPE_IBSS)
+	if (vif->type != NL80211_IFTYPE_AP &&
+	    vif->type != NL80211_IFTYPE_ADHOC)
 		return;
 
 	/*
@@ -1212,8 +1212,8 @@ static void rt2x00lib_resume_intf(void *
 	/*
 	 * Master or Ad-hoc mode require a new beacon update.
 	 */
-	if (vif->type == IEEE80211_IF_TYPE_AP ||
-	    vif->type == IEEE80211_IF_TYPE_IBSS)
+	if (vif->type == NL80211_IFTYPE_AP ||
+	    vif->type == NL80211_IFTYPE_ADHOC)
 		intf->delayed_flags |= DELAYED_UPDATE_BEACON;
 
 	spin_unlock(&intf->lock);
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-09-10 23:50:21.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-09-10 23:58:05.000000000 +0200
@@ -211,7 +211,7 @@ int rt2x00mac_add_interface(struct ieee8
 		return -ENODEV;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_AP:
+	case NL80211_IFTYPE_AP:
 		/*
 		 * We don't support mixed combinations of
 		 * sta and ap interfaces.
@@ -227,8 +227,8 @@ int rt2x00mac_add_interface(struct ieee8
 			return -ENOBUFS;
 
 		break;
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		/*
 		 * We don't support mixed combinations of
 		 * sta and ap interfaces.
@@ -268,7 +268,7 @@ int rt2x00mac_add_interface(struct ieee8
 	 * increase interface count and start initialization.
 	 */
 
-	if (conf->type == IEEE80211_IF_TYPE_AP)
+	if (conf->type == NL80211_IFTYPE_AP)
 		rt2x00dev->intf_ap_count++;
 	else
 		rt2x00dev->intf_sta_count++;
@@ -277,7 +277,7 @@ int rt2x00mac_add_interface(struct ieee8
 	spin_lock_init(&intf->seqlock);
 	intf->beacon = entry;
 
-	if (conf->type == IEEE80211_IF_TYPE_AP)
+	if (conf->type == NL80211_IFTYPE_AP)
 		memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
 	memcpy(&intf->mac, conf->mac_addr, ETH_ALEN);
 
@@ -311,11 +311,11 @@ void rt2x00mac_remove_interface(struct i
 	 * no interface is present.
 	 */
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
-	    (conf->type == IEEE80211_IF_TYPE_AP && !rt2x00dev->intf_ap_count) ||
-	    (conf->type != IEEE80211_IF_TYPE_AP && !rt2x00dev->intf_sta_count))
+	    (conf->type == NL80211_IFTYPE_AP && !rt2x00dev->intf_ap_count) ||
+	    (conf->type != NL80211_IFTYPE_AP && !rt2x00dev->intf_sta_count))
 		return;
 
-	if (conf->type == IEEE80211_IF_TYPE_AP)
+	if (conf->type == NL80211_IFTYPE_AP)
 		rt2x00dev->intf_ap_count--;
 	else
 		rt2x00dev->intf_sta_count--;
@@ -331,7 +331,7 @@ void rt2x00mac_remove_interface(struct i
 	 * are cleared to prevent false ACKing of frames.
 	 */
 	rt2x00lib_config_intf(rt2x00dev, intf,
-			      IEEE80211_IF_TYPE_INVALID, NULL, NULL);
+			      NL80211_IFTYPE_UNSPECIFIED, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_remove_interface);
 
--- everything.orig/drivers/net/wireless/rtl8180_dev.c	2008-09-10 23:50:20.000000000 +0200
+++ everything/drivers/net/wireless/rtl8180_dev.c	2008-09-10 23:58:05.000000000 +0200
@@ -615,7 +615,7 @@ static int rtl8180_start(struct ieee8021
 	reg |= RTL818X_CMD_TX_ENABLE;
 	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
 
-	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->mode = NL80211_IFTYPE_MONITOR;
 	return 0;
 
  err_free_rings:
@@ -633,7 +633,7 @@ static void rtl8180_stop(struct ieee8021
 	u8 reg;
 	int i;
 
-	priv->mode = IEEE80211_IF_TYPE_INVALID;
+	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
 
@@ -661,11 +661,11 @@ static int rtl8180_add_interface(struct 
 {
 	struct rtl8180_priv *priv = dev->priv;
 
-	if (priv->mode != IEEE80211_IF_TYPE_MNTR)
+	if (priv->mode != NL80211_IFTYPE_MONITOR)
 		return -EOPNOTSUPP;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		priv->mode = conf->type;
 		break;
 	default:
@@ -688,7 +688,7 @@ static void rtl8180_remove_interface(str
 				     struct ieee80211_if_init_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->mode = NL80211_IFTYPE_MONITOR;
 	priv->vif = NULL;
 }
 
--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/rtl8187_dev.c	2008-09-10 23:58:05.000000000 +0200
@@ -836,11 +836,11 @@ static int rtl8187_add_interface(struct 
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
 
-	if (priv->mode != IEEE80211_IF_TYPE_MNTR)
+	if (priv->mode != NL80211_IFTYPE_MONITOR)
 		return -EOPNOTSUPP;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_STA:
+	case NL80211_IFTYPE_STATION:
 		priv->mode = conf->type;
 		break;
 	default:
@@ -865,7 +865,7 @@ static void rtl8187_remove_interface(str
 {
 	struct rtl8187_priv *priv = dev->priv;
 	mutex_lock(&priv->conf_mutex);
-	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->mode = NL80211_IFTYPE_MONITOR;
 	priv->vif = NULL;
 	mutex_unlock(&priv->conf_mutex);
 }
@@ -1057,7 +1057,7 @@ static int __devinit rtl8187_probe(struc
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 
 
-	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->mode = NL80211_IFTYPE_MONITOR;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS;
 
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-09-10 23:50:22.000000000 +0200
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2008-09-10 23:58:05.000000000 +0200
@@ -684,15 +684,15 @@ static int zd_op_add_interface(struct ie
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 
-	/* using IEEE80211_IF_TYPE_INVALID to indicate no mode selected */
-	if (mac->type != IEEE80211_IF_TYPE_INVALID)
+	/* using NL80211_IFTYPE_UNSPECIFIED to indicate no mode selected */
+	if (mac->type != NL80211_IFTYPE_UNSPECIFIED)
 		return -EOPNOTSUPP;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_MNTR:
-	case IEEE80211_IF_TYPE_MESH_POINT:
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		mac->type = conf->type;
 		break;
 	default:
@@ -706,7 +706,7 @@ static void zd_op_remove_interface(struc
 				    struct ieee80211_if_init_conf *conf)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
-	mac->type = IEEE80211_IF_TYPE_INVALID;
+	mac->type = NL80211_IFTYPE_UNSPECIFIED;
 	zd_set_beacon_interval(&mac->chip, 0);
 	zd_write_mac_addr(&mac->chip, NULL);
 }
@@ -725,8 +725,8 @@ static int zd_op_config_interface(struct
 	int associated;
 	int r;
 
-	if (mac->type == IEEE80211_IF_TYPE_MESH_POINT ||
-	    mac->type == IEEE80211_IF_TYPE_IBSS) {
+	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
+	    mac->type == NL80211_IFTYPE_ADHOC) {
 		associated = true;
 		if (conf->changed & IEEE80211_IFCC_BEACON) {
 			struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
@@ -923,7 +923,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 	spin_lock_init(&mac->lock);
 	mac->hw = hw;
 
-	mac->type = IEEE80211_IF_TYPE_INVALID;
+	mac->type = NL80211_IFTYPE_UNSPECIFIED;
 
 	memcpy(mac->channels, zd_channels, sizeof(zd_channels));
 	memcpy(mac->rates, zd_rates, sizeof(zd_rates));

-- 

