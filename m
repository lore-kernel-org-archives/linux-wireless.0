Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2JOSRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 14:17:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>
Subject: [PATCH 2/3] cfg80211: add tracing to rdev-ops
Date: Mon, 15 Oct 2012 20:17:29 +0200
Message-Id: <1350325050-6994-3-git-send-email-johannes@sipsolutions.net> (sfid-20121015_201708_668051_BEC7F058)
In-Reply-To: <1350325050-6994-1-git-send-email-johannes@sipsolutions.net>
References: <1350325050-6994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Add tracing to make debugging cfg80211/mac80211
(or full-mac driver) interaction easier.

Signed-off-by: Beni Lev <beni.lev@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Hila Gonen <hila.gonen@intel.com>
Tested-by: Hila Gonen <hila.gonen@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[add a cast to int to sizeof() to avoid warning]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Makefile   |    4 +-
 net/wireless/rdev-ops.h |  459 ++++++++++---
 net/wireless/trace.c    |    7 +
 net/wireless/trace.h    | 1750 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 2141 insertions(+), 79 deletions(-)
 create mode 100644 net/wireless/trace.c
 create mode 100644 net/wireless/trace.h

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 0f7e0d6..a761670 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -10,11 +10,13 @@ obj-$(CONFIG_WEXT_SPY) += wext-spy.o
 obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
-cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o
+cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o trace.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
 
+CFLAGS_trace.o := -I$(src)
+
 ccflags-y += -D__CHECK_ENDIAN__
 
 $(obj)/regdb.c: $(src)/db.txt $(src)/genregdb.awk
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index b6fad29..4a88a39 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -4,21 +4,32 @@
 #include <linux/rtnetlink.h>
 #include <net/cfg80211.h>
 #include "core.h"
+#include "trace.h"
 
 static inline int rdev_suspend(struct cfg80211_registered_device *rdev)
 {
-	return rdev->ops->suspend(&rdev->wiphy, rdev->wowlan);
+	int ret;
+	trace_rdev_suspend(&rdev->wiphy, rdev->wowlan);
+	ret = rdev->ops->suspend(&rdev->wiphy, rdev->wowlan);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_resume(struct cfg80211_registered_device *rdev)
 {
-	return rdev->ops->resume(&rdev->wiphy);
+	int ret;
+	trace_rdev_resume(&rdev->wiphy);
+	ret = rdev->ops->resume(&rdev->wiphy);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline void rdev_set_wakeup(struct cfg80211_registered_device *rdev,
 				   bool enabled)
 {
+	trace_rdev_set_wakeup(&rdev->wiphy, enabled);
 	rdev->ops->set_wakeup(&rdev->wiphy, enabled);
+	trace_rdev_return_void(&rdev->wiphy);
 }
 
 static inline struct wireless_dev
@@ -26,15 +37,23 @@ static inline struct wireless_dev
 		       enum nl80211_iftype type, u32 *flags,
 		       struct vif_params *params)
 {
-	return rdev->ops->add_virtual_intf(&rdev->wiphy, name, type, flags,
-					   params);
+	struct wireless_dev *ret;
+	trace_rdev_add_virtual_intf(&rdev->wiphy, name, type);
+	ret = rdev->ops->add_virtual_intf(&rdev->wiphy, name, type, flags,
+					  params);
+	trace_rdev_return_wdev(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
 rdev_del_virtual_intf(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev)
 {
-	return rdev->ops->del_virtual_intf(&rdev->wiphy, wdev);
+	int ret;
+	trace_rdev_del_virtual_intf(&rdev->wiphy, wdev);
+	ret = rdev->ops->del_virtual_intf(&rdev->wiphy, wdev);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
@@ -42,8 +61,12 @@ rdev_change_virtual_intf(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev, enum nl80211_iftype type,
 			 u32 *flags, struct vif_params *params)
 {
-	return rdev->ops->change_virtual_intf(&rdev->wiphy, dev, type, flags,
-					      params);
+	int ret;
+	trace_rdev_change_virtual_intf(&rdev->wiphy, dev, type);
+	ret = rdev->ops->change_virtual_intf(&rdev->wiphy, dev, type, flags,
+					     params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_add_key(struct cfg80211_registered_device *rdev,
@@ -51,8 +74,12 @@ static inline int rdev_add_key(struct cfg80211_registered_device *rdev,
 			       bool pairwise, const u8 *mac_addr,
 			       struct key_params *params)
 {
-	return rdev->ops->add_key(&rdev->wiphy, netdev, key_index, pairwise,
+	int ret;
+	trace_rdev_add_key(&rdev->wiphy, netdev, key_index, pairwise, mac_addr);
+	ret = rdev->ops->add_key(&rdev->wiphy, netdev, key_index, pairwise,
 				  mac_addr, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
@@ -60,16 +87,24 @@ rdev_get_key(struct cfg80211_registered_device *rdev, struct net_device *netdev,
 	     u8 key_index, bool pairwise, const u8 *mac_addr, void *cookie,
 	     void (*callback)(void *cookie, struct key_params*))
 {
-	return rdev->ops->get_key(&rdev->wiphy, netdev, key_index, pairwise,
+	int ret;
+	trace_rdev_get_key(&rdev->wiphy, netdev, key_index, pairwise, mac_addr);
+	ret = rdev->ops->get_key(&rdev->wiphy, netdev, key_index, pairwise,
 				  mac_addr, cookie, callback);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_del_key(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u8 key_index,
 			       bool pairwise, const u8 *mac_addr)
 {
-	return rdev->ops->del_key(&rdev->wiphy, netdev, key_index, pairwise,
+	int ret;
+	trace_rdev_del_key(&rdev->wiphy, netdev, key_index, pairwise, mac_addr);
+	ret = rdev->ops->del_key(&rdev->wiphy, netdev, key_index, pairwise,
 				  mac_addr);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
@@ -77,96 +112,154 @@ rdev_set_default_key(struct cfg80211_registered_device *rdev,
 		     struct net_device *netdev, u8 key_index, bool unicast,
 		     bool multicast)
 {
-	return rdev->ops->set_default_key(&rdev->wiphy, netdev, key_index,
+	int ret;
+	trace_rdev_set_default_key(&rdev->wiphy, netdev, key_index,
+				   unicast, multicast);
+	ret = rdev->ops->set_default_key(&rdev->wiphy, netdev, key_index,
 					  unicast, multicast);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
 rdev_set_default_mgmt_key(struct cfg80211_registered_device *rdev,
 			  struct net_device *netdev, u8 key_index)
 {
-	return rdev->ops->set_default_mgmt_key(&rdev->wiphy, netdev,
+	int ret;
+	trace_rdev_set_default_mgmt_key(&rdev->wiphy, netdev, key_index);
+	ret = rdev->ops->set_default_mgmt_key(&rdev->wiphy, netdev,
 					       key_index);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_start_ap(struct cfg80211_registered_device *rdev,
 				struct net_device *dev,
 				struct cfg80211_ap_settings *settings)
 {
-	return rdev->ops->start_ap(&rdev->wiphy, dev, settings);
+	int ret;
+	trace_rdev_start_ap(&rdev->wiphy, dev, settings);
+	ret = rdev->ops->start_ap(&rdev->wiphy, dev, settings);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_change_beacon(struct cfg80211_registered_device *rdev,
 				     struct net_device *dev,
 				     struct cfg80211_beacon_data *info)
 {
-	return rdev->ops->change_beacon(&rdev->wiphy, dev, info);
+	int ret;
+	trace_rdev_change_beacon(&rdev->wiphy, dev, info);
+	ret = rdev->ops->change_beacon(&rdev->wiphy, dev, info);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_stop_ap(struct cfg80211_registered_device *rdev,
 			       struct net_device *dev)
 {
-	return rdev->ops->stop_ap(&rdev->wiphy, dev);
+	int ret;
+	trace_rdev_stop_ap(&rdev->wiphy, dev);
+	ret = rdev->ops->stop_ap(&rdev->wiphy, dev);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_add_station(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev, u8 *mac,
 				   struct station_parameters *params)
 {
-	return rdev->ops->add_station(&rdev->wiphy, dev, mac, params);
+	int ret;
+	trace_rdev_add_station(&rdev->wiphy, dev, mac, params);
+	ret = rdev->ops->add_station(&rdev->wiphy, dev, mac, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_del_station(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev, u8 *mac)
 {
-	return rdev->ops->del_station(&rdev->wiphy, dev, mac);
+	int ret;
+	trace_rdev_del_station(&rdev->wiphy, dev, mac);
+	ret = rdev->ops->del_station(&rdev->wiphy, dev, mac);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_change_station(struct cfg80211_registered_device *rdev,
 				      struct net_device *dev, u8 *mac,
 				      struct station_parameters *params)
 {
-	return rdev->ops->change_station(&rdev->wiphy, dev, mac, params);
+	int ret;
+	trace_rdev_change_station(&rdev->wiphy, dev, mac, params);
+	ret = rdev->ops->change_station(&rdev->wiphy, dev, mac, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_get_station(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev, u8 *mac,
 				   struct station_info *sinfo)
 {
-	return rdev->ops->get_station(&rdev->wiphy, dev, mac, sinfo);
+	int ret;
+	trace_rdev_get_station(&rdev->wiphy, dev, mac);
+	ret = rdev->ops->get_station(&rdev->wiphy, dev, mac, sinfo);
+	trace_rdev_return_int_station_info(&rdev->wiphy, ret, sinfo);
+	return ret;
 }
 
 static inline int rdev_dump_station(struct cfg80211_registered_device *rdev,
 				    struct net_device *dev, int idx, u8 *mac,
 				    struct station_info *sinfo)
 {
-	return rdev->ops->dump_station(&rdev->wiphy, dev, idx, mac, sinfo);
+	int ret;
+	trace_rdev_dump_station(&rdev->wiphy, dev, idx, mac);
+	ret = rdev->ops->dump_station(&rdev->wiphy, dev, idx, mac, sinfo);
+	trace_rdev_return_int_station_info(&rdev->wiphy, ret, sinfo);
+	return ret;
 }
 
 static inline int rdev_add_mpath(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev, u8 *dst, u8 *next_hop)
 {
-	return rdev->ops->add_mpath(&rdev->wiphy, dev, dst, next_hop);
+	int ret;
+	trace_rdev_add_mpath(&rdev->wiphy, dev, dst, next_hop);
+	ret = rdev->ops->add_mpath(&rdev->wiphy, dev, dst, next_hop);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_del_mpath(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev, u8 *dst)
 {
-	return rdev->ops->del_mpath(&rdev->wiphy, dev, dst);
+	int ret;
+	trace_rdev_del_mpath(&rdev->wiphy, dev, dst);
+	ret = rdev->ops->del_mpath(&rdev->wiphy, dev, dst);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_change_mpath(struct cfg80211_registered_device *rdev,
 				    struct net_device *dev, u8 *dst,
 				    u8 *next_hop)
 {
-	return rdev->ops->change_mpath(&rdev->wiphy, dev, dst, next_hop);
+	int ret;
+	trace_rdev_change_mpath(&rdev->wiphy, dev, dst, next_hop);
+	ret = rdev->ops->change_mpath(&rdev->wiphy, dev, dst, next_hop);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_get_mpath(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev, u8 *dst, u8 *next_hop,
 				 struct mpath_info *pinfo)
 {
-	return rdev->ops->get_mpath(&rdev->wiphy, dev, dst, next_hop, pinfo);
+	int ret;
+	trace_rdev_get_mpath(&rdev->wiphy, dev, dst, next_hop);
+	ret = rdev->ops->get_mpath(&rdev->wiphy, dev, dst, next_hop, pinfo);
+	trace_rdev_return_int_mpath_info(&rdev->wiphy, ret, pinfo);
+	return ret;
+
 }
 
 static inline int rdev_dump_mpath(struct cfg80211_registered_device *rdev,
@@ -174,15 +267,23 @@ static inline int rdev_dump_mpath(struct cfg80211_registered_device *rdev,
 				  u8 *next_hop, struct mpath_info *pinfo)
 
 {
-	return rdev->ops->dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop,
+	int ret;
+	trace_rdev_dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop);
+	ret = rdev->ops->dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop,
 				     pinfo);
+	trace_rdev_return_int_mpath_info(&rdev->wiphy, ret, pinfo);
+	return ret;
 }
 
 static inline int
 rdev_get_mesh_config(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev, struct mesh_config *conf)
 {
-	return rdev->ops->get_mesh_config(&rdev->wiphy, dev, conf);
+	int ret;
+	trace_rdev_get_mesh_config(&rdev->wiphy, dev);
+	ret = rdev->ops->get_mesh_config(&rdev->wiphy, dev, conf);
+	trace_rdev_return_int_mesh_config(&rdev->wiphy, ret, conf);
+	return ret;
 }
 
 static inline int
@@ -190,7 +291,11 @@ rdev_update_mesh_config(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u32 mask,
 			const struct mesh_config *nconf)
 {
-	return rdev->ops->update_mesh_config(&rdev->wiphy, dev, mask, nconf);
+	int ret;
+	trace_rdev_update_mesh_config(&rdev->wiphy, dev, mask, nconf);
+	ret = rdev->ops->update_mesh_config(&rdev->wiphy, dev, mask, nconf);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_join_mesh(struct cfg80211_registered_device *rdev,
@@ -198,14 +303,22 @@ static inline int rdev_join_mesh(struct cfg80211_registered_device *rdev,
 				 const struct mesh_config *conf,
 				 const struct mesh_setup *setup)
 {
-	return rdev->ops->join_mesh(&rdev->wiphy, dev, conf, setup);
+	int ret;
+	trace_rdev_join_mesh(&rdev->wiphy, dev, conf, setup);
+	ret = rdev->ops->join_mesh(&rdev->wiphy, dev, conf, setup);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 
 static inline int rdev_leave_mesh(struct cfg80211_registered_device *rdev,
 				  struct net_device *dev)
 {
-	return rdev->ops->leave_mesh(&rdev->wiphy, dev);
+	int ret;
+	trace_rdev_leave_mesh(&rdev->wiphy, dev);
+	ret = rdev->ops->leave_mesh(&rdev->wiphy, dev);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_change_bss(struct cfg80211_registered_device *rdev,
@@ -213,7 +326,11 @@ static inline int rdev_change_bss(struct cfg80211_registered_device *rdev,
 				  struct bss_parameters *params)
 
 {
-	return rdev->ops->change_bss(&rdev->wiphy, dev, params);
+	int ret;
+	trace_rdev_change_bss(&rdev->wiphy, dev, params);
+	ret = rdev->ops->change_bss(&rdev->wiphy, dev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_set_txq_params(struct cfg80211_registered_device *rdev,
@@ -221,7 +338,11 @@ static inline int rdev_set_txq_params(struct cfg80211_registered_device *rdev,
 				      struct ieee80211_txq_params *params)
 
 {
-	return rdev->ops->set_txq_params(&rdev->wiphy, dev, params);
+	int ret;
+	trace_rdev_set_txq_params(&rdev->wiphy, dev, params);
+	ret = rdev->ops->set_txq_params(&rdev->wiphy, dev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
@@ -229,7 +350,11 @@ rdev_libertas_set_mesh_channel(struct cfg80211_registered_device *rdev,
 			       struct net_device *dev,
 			       struct ieee80211_channel *chan)
 {
-	return rdev->ops->libertas_set_mesh_channel(&rdev->wiphy, dev, chan);
+	int ret;
+	trace_rdev_libertas_set_mesh_channel(&rdev->wiphy, dev, chan);
+	ret = rdev->ops->libertas_set_mesh_channel(&rdev->wiphy, dev, chan);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
@@ -237,97 +362,154 @@ rdev_set_monitor_channel(struct cfg80211_registered_device *rdev,
 			 struct ieee80211_channel *chan,
 			 enum nl80211_channel_type channel_type)
 {
-	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan,
-					      channel_type);
+	int ret;
+	trace_rdev_set_monitor_channel(&rdev->wiphy, chan, channel_type);
+	ret = rdev->ops->set_monitor_channel(&rdev->wiphy, chan, channel_type);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_scan(struct cfg80211_registered_device *rdev,
 			    struct cfg80211_scan_request *request)
 {
-	return rdev->ops->scan(&rdev->wiphy, request);
+	int ret;
+	trace_rdev_scan(&rdev->wiphy, request);
+	ret = rdev->ops->scan(&rdev->wiphy, request);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_auth(struct cfg80211_registered_device *rdev,
 			    struct net_device *dev,
 			    struct cfg80211_auth_request *req)
 {
-	return rdev->ops->auth(&rdev->wiphy, dev, req);
+	int ret;
+	trace_rdev_auth(&rdev->wiphy, dev, req);
+	ret = rdev->ops->auth(&rdev->wiphy, dev, req);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_assoc(struct cfg80211_registered_device *rdev,
 			     struct net_device *dev,
 			     struct cfg80211_assoc_request *req)
 {
-	return rdev->ops->assoc(&rdev->wiphy, dev, req);
+	int ret;
+	trace_rdev_assoc(&rdev->wiphy, dev, req);
+	ret = rdev->ops->assoc(&rdev->wiphy, dev, req);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_deauth(struct cfg80211_registered_device *rdev,
 			      struct net_device *dev,
 			      struct cfg80211_deauth_request *req)
 {
-	return rdev->ops->deauth(&rdev->wiphy, dev, req);
+	int ret;
+	trace_rdev_deauth(&rdev->wiphy, dev, req);
+	ret = rdev->ops->deauth(&rdev->wiphy, dev, req);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_disassoc(struct cfg80211_registered_device *rdev,
 				struct net_device *dev,
 				struct cfg80211_disassoc_request *req)
 {
-	return rdev->ops->disassoc(&rdev->wiphy, dev, req);
+	int ret;
+	trace_rdev_disassoc(&rdev->wiphy, dev, req);
+	ret = rdev->ops->disassoc(&rdev->wiphy, dev, req);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_connect(struct cfg80211_registered_device *rdev,
 			       struct net_device *dev,
 			       struct cfg80211_connect_params *sme)
 {
-	return rdev->ops->connect(&rdev->wiphy, dev, sme);
+	int ret;
+	trace_rdev_connect(&rdev->wiphy, dev, sme);
+	ret = rdev->ops->connect(&rdev->wiphy, dev, sme);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_disconnect(struct cfg80211_registered_device *rdev,
 				  struct net_device *dev, u16 reason_code)
 {
-	return rdev->ops->disconnect(&rdev->wiphy, dev, reason_code);
+	int ret;
+	trace_rdev_disconnect(&rdev->wiphy, dev, reason_code);
+	ret = rdev->ops->disconnect(&rdev->wiphy, dev, reason_code);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_join_ibss(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev,
 				 struct cfg80211_ibss_params *params)
 {
-	return rdev->ops->join_ibss(&rdev->wiphy, dev, params);
+	int ret;
+	trace_rdev_join_ibss(&rdev->wiphy, dev, params);
+	ret = rdev->ops->join_ibss(&rdev->wiphy, dev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_leave_ibss(struct cfg80211_registered_device *rdev,
 				  struct net_device *dev)
 {
-	return rdev->ops->leave_ibss(&rdev->wiphy, dev);
+	int ret;
+	trace_rdev_leave_ibss(&rdev->wiphy, dev);
+	ret = rdev->ops->leave_ibss(&rdev->wiphy, dev);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
 rdev_set_wiphy_params(struct cfg80211_registered_device *rdev, u32 changed)
 {
-	return rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
+	int ret;
+	trace_rdev_set_wiphy_params(&rdev->wiphy, changed);
+	ret = rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_set_tx_power(struct cfg80211_registered_device *rdev,
 				    enum nl80211_tx_power_setting type, int mbm)
 {
-	return rdev->ops->set_tx_power(&rdev->wiphy, type, mbm);
+	int ret;
+	trace_rdev_set_tx_power(&rdev->wiphy, type, mbm);
+	ret = rdev->ops->set_tx_power(&rdev->wiphy, type, mbm);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_get_tx_power(struct cfg80211_registered_device *rdev,
 				    int *dbm)
 {
-	return rdev->ops->get_tx_power(&rdev->wiphy, dbm);
+	int ret;
+	trace_rdev_get_tx_power(&rdev->wiphy);
+	ret = rdev->ops->get_tx_power(&rdev->wiphy, dbm);
+	trace_rdev_return_int_int(&rdev->wiphy, ret, *dbm);
+	return ret;
 }
 
 static inline int rdev_set_wds_peer(struct cfg80211_registered_device *rdev,
 				    struct net_device *dev, const u8 *addr)
 {
-	return rdev->ops->set_wds_peer(&rdev->wiphy, dev, addr);
+	int ret;
+	trace_rdev_set_wds_peer(&rdev->wiphy, dev, addr);
+	ret = rdev->ops->set_wds_peer(&rdev->wiphy, dev, addr);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline void rdev_rfkill_poll(struct cfg80211_registered_device *rdev)
 {
+	trace_rdev_rfkill_poll(&rdev->wiphy);
 	rdev->ops->rfkill_poll(&rdev->wiphy);
+	trace_rdev_return_void(&rdev->wiphy);
 }
 
 
@@ -335,7 +517,11 @@ static inline void rdev_rfkill_poll(struct cfg80211_registered_device *rdev)
 static inline int rdev_testmode_cmd(struct cfg80211_registered_device *rdev,
 				    void *data, int len)
 {
-	return rdev->ops->testmode_cmd(&rdev->wiphy, data, len);
+	int ret;
+	trace_rdev_testmode_cmd(&rdev->wiphy);
+	ret = rdev->ops->testmode_cmd(&rdev->wiphy, data, len);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_testmode_dump(struct cfg80211_registered_device *rdev,
@@ -343,8 +529,11 @@ static inline int rdev_testmode_dump(struct cfg80211_registered_device *rdev,
 				     struct netlink_callback *cb, void *data,
 				     int len)
 {
-	return rdev->ops->testmode_dump(&rdev->wiphy, skb, cb, data,
-					len);
+	int ret;
+	trace_rdev_testmode_dump(&rdev->wiphy);
+	ret = rdev->ops->testmode_dump(&rdev->wiphy, skb, cb, data, len);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 #endif
 
@@ -353,34 +542,57 @@ rdev_set_bitrate_mask(struct cfg80211_registered_device *rdev,
 		      struct net_device *dev, const u8 *peer,
 		      const struct cfg80211_bitrate_mask *mask)
 {
-	return rdev->ops->set_bitrate_mask(&rdev->wiphy, dev, peer, mask);
+	int ret;
+	trace_rdev_set_bitrate_mask(&rdev->wiphy, dev, peer, mask);
+	ret = rdev->ops->set_bitrate_mask(&rdev->wiphy, dev, peer, mask);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_dump_survey(struct cfg80211_registered_device *rdev,
 				   struct net_device *netdev, int idx,
 				   struct survey_info *info)
 {
-	return rdev->ops->dump_survey(&rdev->wiphy, netdev, idx, info);
+	int ret;
+	trace_rdev_dump_survey(&rdev->wiphy, netdev, idx);
+	ret = rdev->ops->dump_survey(&rdev->wiphy, netdev, idx, info);
+	if (ret < 0)
+		trace_rdev_return_int(&rdev->wiphy, ret);
+	else
+		trace_rdev_return_int_survey_info(&rdev->wiphy, ret, info);
+	return ret;
 }
 
 static inline int rdev_set_pmksa(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev,
 				 struct cfg80211_pmksa *pmksa)
 {
-	return rdev->ops->set_pmksa(&rdev->wiphy, netdev, pmksa);
+	int ret;
+	trace_rdev_set_pmksa(&rdev->wiphy, netdev, pmksa);
+	ret = rdev->ops->set_pmksa(&rdev->wiphy, netdev, pmksa);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_del_pmksa(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev,
 				 struct cfg80211_pmksa *pmksa)
 {
-	return rdev->ops->del_pmksa(&rdev->wiphy, netdev, pmksa);
+	int ret;
+	trace_rdev_del_pmksa(&rdev->wiphy, netdev, pmksa);
+	ret = rdev->ops->del_pmksa(&rdev->wiphy, netdev, pmksa);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_flush_pmksa(struct cfg80211_registered_device *rdev,
 				   struct net_device *netdev)
 {
-	return rdev->ops->flush_pmksa(&rdev->wiphy, netdev);
+	int ret;
+	trace_rdev_flush_pmksa(&rdev->wiphy, netdev);
+	ret = rdev->ops->flush_pmksa(&rdev->wiphy, netdev);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
@@ -390,15 +602,24 @@ rdev_remain_on_channel(struct cfg80211_registered_device *rdev,
 		       enum nl80211_channel_type channel_type,
 		       unsigned int duration, u64 *cookie)
 {
-	return rdev->ops->remain_on_channel(&rdev->wiphy, wdev, chan,
+	int ret;
+	trace_rdev_remain_on_channel(&rdev->wiphy, wdev, chan, channel_type,
+				     duration);
+	ret = rdev->ops->remain_on_channel(&rdev->wiphy, wdev, chan,
 					    channel_type, duration, cookie);
+	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
+	return ret;
 }
 
 static inline int
 rdev_cancel_remain_on_channel(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev, u64 cookie)
 {
-	return rdev->ops->cancel_remain_on_channel(&rdev->wiphy, wdev, cookie);
+	int ret;
+	trace_rdev_cancel_remain_on_channel(&rdev->wiphy, wdev, cookie);
+	ret = rdev->ops->cancel_remain_on_channel(&rdev->wiphy, wdev, cookie);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
@@ -409,72 +630,113 @@ static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
 			       const u8 *buf, size_t len, bool no_cck,
 			       bool dont_wait_for_ack, u64 *cookie)
 {
-	return rdev->ops->mgmt_tx(&rdev->wiphy, wdev, chan, offchan,
+	int ret;
+	trace_rdev_mgmt_tx(&rdev->wiphy, wdev, chan, offchan, channel_type,
+			   channel_type_valid, wait, no_cck, dont_wait_for_ack);
+	ret = rdev->ops->mgmt_tx(&rdev->wiphy, wdev, chan, offchan,
 				  channel_type, channel_type_valid, wait, buf,
 				  len, no_cck, dont_wait_for_ack, cookie);
+	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
+	return ret;
 }
 
 static inline int
 rdev_mgmt_tx_cancel_wait(struct cfg80211_registered_device *rdev,
 			 struct wireless_dev *wdev, u64 cookie)
 {
-	return rdev->ops->mgmt_tx_cancel_wait(&rdev->wiphy, wdev, cookie);
+	int ret;
+	trace_rdev_mgmt_tx_cancel_wait(&rdev->wiphy, wdev, cookie);
+	ret = rdev->ops->mgmt_tx_cancel_wait(&rdev->wiphy, wdev, cookie);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_set_power_mgmt(struct cfg80211_registered_device *rdev,
 				      struct net_device *dev, bool enabled,
 				      int timeout)
 {
-	return rdev->ops->set_power_mgmt(&rdev->wiphy, dev, enabled, timeout);
+	int ret;
+	trace_rdev_set_power_mgmt(&rdev->wiphy, dev, enabled, timeout);
+	ret = rdev->ops->set_power_mgmt(&rdev->wiphy, dev, enabled, timeout);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
 rdev_set_cqm_rssi_config(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev, s32 rssi_thold, u32 rssi_hyst)
 {
-	return rdev->ops->set_cqm_rssi_config(&rdev->wiphy, dev, rssi_thold,
-					      rssi_hyst);
+	int ret;
+	trace_rdev_set_cqm_rssi_config(&rdev->wiphy, dev, rssi_thold,
+				       rssi_hyst);
+	ret = rdev->ops->set_cqm_rssi_config(&rdev->wiphy, dev, rssi_thold,
+				       rssi_hyst);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
 rdev_set_cqm_txe_config(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u32 rate, u32 pkts, u32 intvl)
 {
-	return rdev->ops->set_cqm_txe_config(&rdev->wiphy, dev, rate, pkts,
+	int ret;
+	trace_rdev_set_cqm_txe_config(&rdev->wiphy, dev, rate, pkts, intvl);
+	ret = rdev->ops->set_cqm_txe_config(&rdev->wiphy, dev, rate, pkts,
 					     intvl);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline void
 rdev_mgmt_frame_register(struct cfg80211_registered_device *rdev,
 			 struct wireless_dev *wdev, u16 frame_type, bool reg)
 {
-	rdev->ops->mgmt_frame_register(&rdev->wiphy, wdev , frame_type,
-					      reg);
+	trace_rdev_mgmt_frame_register(&rdev->wiphy, wdev , frame_type, reg);
+	rdev->ops->mgmt_frame_register(&rdev->wiphy, wdev , frame_type, reg);
+	trace_rdev_return_void(&rdev->wiphy);
 }
 
 static inline int rdev_set_antenna(struct cfg80211_registered_device *rdev,
 				   u32 tx_ant, u32 rx_ant)
 {
-	return rdev->ops->set_antenna(&rdev->wiphy, tx_ant, rx_ant);
+	int ret;
+	trace_rdev_set_antenna(&rdev->wiphy, tx_ant, rx_ant);
+	ret = rdev->ops->set_antenna(&rdev->wiphy, tx_ant, rx_ant);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_get_antenna(struct cfg80211_registered_device *rdev,
 				   u32 *tx_ant, u32 *rx_ant)
 {
-	return rdev->ops->get_antenna(&rdev->wiphy, tx_ant, rx_ant);
+	int ret;
+	trace_rdev_get_antenna(&rdev->wiphy);
+	ret = rdev->ops->get_antenna(&rdev->wiphy, tx_ant, rx_ant);
+	if (ret)
+		trace_rdev_return_int(&rdev->wiphy, ret);
+	else
+		trace_rdev_return_int_tx_rx(&rdev->wiphy, ret, *tx_ant,
+					    *rx_ant);
+	return ret;
 }
 
 static inline int rdev_set_ringparam(struct cfg80211_registered_device *rdev,
 				     u32 tx, u32 rx)
 {
-	return rdev->ops->set_ringparam(&rdev->wiphy, tx, rx);
+	int ret;
+	trace_rdev_set_ringparam(&rdev->wiphy, tx, rx);
+	ret = rdev->ops->set_ringparam(&rdev->wiphy, tx, rx);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline void rdev_get_ringparam(struct cfg80211_registered_device *rdev,
 				      u32 *tx, u32 *tx_max, u32 *rx,
 				      u32 *rx_max)
 {
+	trace_rdev_get_ringparam(&rdev->wiphy);
 	rdev->ops->get_ringparam(&rdev->wiphy, tx, tx_max, rx, rx_max);
+	trace_rdev_return_void_tx_rx(&rdev->wiphy, *tx, *tx_max, *rx, *rx_max);
 }
 
 static inline int
@@ -482,20 +744,32 @@ rdev_sched_scan_start(struct cfg80211_registered_device *rdev,
 		      struct net_device *dev,
 		      struct cfg80211_sched_scan_request *request)
 {
-	return rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
+	int ret;
+	trace_rdev_sched_scan_start(&rdev->wiphy, dev, request);
+	ret = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_sched_scan_stop(struct cfg80211_registered_device *rdev,
 				       struct net_device *dev)
 {
-	return rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
+	int ret;
+	trace_rdev_sched_scan_stop(&rdev->wiphy, dev);
+	ret = rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_set_rekey_data(struct cfg80211_registered_device *rdev,
 				      struct net_device *dev,
 				      struct cfg80211_gtk_rekey_data *data)
 {
-	return rdev->ops->set_rekey_data(&rdev->wiphy, dev, data);
+	int ret;
+	trace_rdev_set_rekey_data(&rdev->wiphy, dev);
+	ret = rdev->ops->set_rekey_data(&rdev->wiphy, dev, data);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_tdls_mgmt(struct cfg80211_registered_device *rdev,
@@ -503,56 +777,85 @@ static inline int rdev_tdls_mgmt(struct cfg80211_registered_device *rdev,
 				 u8 action_code, u8 dialog_token,
 				 u16 status_code, const u8 *buf, size_t len)
 {
-	return rdev->ops->tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
-				    dialog_token, status_code, buf, len);
+	int ret;
+	trace_rdev_tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
+			     dialog_token, status_code, buf, len);
+	ret = rdev->ops->tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
+				   dialog_token, status_code, buf, len);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_tdls_oper(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev, u8 *peer,
 				 enum nl80211_tdls_operation oper)
 {
-	return rdev->ops->tdls_oper(&rdev->wiphy, dev, peer, oper);
+	int ret;
+	trace_rdev_tdls_oper(&rdev->wiphy, dev, peer, oper);
+	ret = rdev->ops->tdls_oper(&rdev->wiphy, dev, peer, oper);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int rdev_probe_client(struct cfg80211_registered_device *rdev,
 				    struct net_device *dev, const u8 *peer,
 				    u64 *cookie)
 {
-	return rdev->ops->probe_client(&rdev->wiphy, dev, peer, cookie);
+	int ret;
+	trace_rdev_probe_client(&rdev->wiphy, dev, peer);
+	ret = rdev->ops->probe_client(&rdev->wiphy, dev, peer, cookie);
+	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
+	return ret;
 }
 
 static inline int rdev_set_noack_map(struct cfg80211_registered_device *rdev,
 				     struct net_device *dev, u16 noack_map)
 {
-	return rdev->ops->set_noack_map(&rdev->wiphy, dev, noack_map);
+	int ret;
+	trace_rdev_set_noack_map(&rdev->wiphy, dev, noack_map);
+	ret = rdev->ops->set_noack_map(&rdev->wiphy, dev, noack_map);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline int
 rdev_get_et_sset_count(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev, int sset)
 {
-	return rdev->ops->get_et_sset_count(&rdev->wiphy, dev, sset);
+	int ret;
+	trace_rdev_get_et_sset_count(&rdev->wiphy, dev, sset);
+	ret = rdev->ops->get_et_sset_count(&rdev->wiphy, dev, sset);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
 }
 
 static inline void rdev_get_et_stats(struct cfg80211_registered_device *rdev,
 				     struct net_device *dev,
 				     struct ethtool_stats *stats, u64 *data)
 {
+	trace_rdev_get_et_stats(&rdev->wiphy, dev);
 	rdev->ops->get_et_stats(&rdev->wiphy, dev, stats, data);
+	trace_rdev_return_void(&rdev->wiphy);
 }
 
 static inline void rdev_get_et_strings(struct cfg80211_registered_device *rdev,
 				       struct net_device *dev, u32 sset,
 				       u8 *data)
 {
+	trace_rdev_get_et_strings(&rdev->wiphy, dev, sset);
 	rdev->ops->get_et_strings(&rdev->wiphy, dev, sset, data);
+	trace_rdev_return_void(&rdev->wiphy);
 }
 
 static inline struct ieee80211_channel
 *rdev_get_channel(struct cfg80211_registered_device *rdev,
 		  struct wireless_dev *wdev, enum nl80211_channel_type *type)
 {
-	return rdev->ops->get_channel(&rdev->wiphy, wdev, type);
+	struct ieee80211_channel *ret;
+	trace_rdev_get_channel(&rdev->wiphy, wdev);
+	ret = rdev->ops->get_channel(&rdev->wiphy, wdev, type);
+	trace_rdev_return_channel(&rdev->wiphy, ret, *type);
+	return ret;
 }
 
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.c b/net/wireless/trace.c
new file mode 100644
index 0000000..95f997f
--- /dev/null
+++ b/net/wireless/trace.c
@@ -0,0 +1,7 @@
+#include <linux/module.h>
+
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+#endif
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
new file mode 100644
index 0000000..0940e91
--- /dev/null
+++ b/net/wireless/trace.h
@@ -0,0 +1,1750 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cfg80211
+
+#if !defined(__RDEV_OPS_TRACE) || defined(TRACE_HEADER_MULTI_READ)
+#define __RDEV_OPS_TRACE
+
+#include <linux/tracepoint.h>
+
+#include <linux/rtnetlink.h>
+#include <net/cfg80211.h>
+#include "core.h"
+
+#define MAC_ENTRY(entry_mac) __array(u8, entry_mac, ETH_ALEN)
+#define MAC_ASSIGN(entry_mac, given_mac) do {			     \
+	if (given_mac)						     \
+		memcpy(__entry->entry_mac, given_mac, ETH_ALEN);     \
+	else							     \
+		memset(__entry->entry_mac, 0, ETH_ALEN);	     \
+	} while (0)
+#define MAC_PR_FMT "%pM"
+#define MAC_PR_ARG(entry_mac) (__entry->entry_mac)
+
+#define WIPHY_ENTRY MAC_ENTRY(wiphy_mac)
+#define WIPHY_ASSIGN MAC_ASSIGN(wiphy_mac, wiphy->perm_addr)
+#define WIPHY_PR_FMT "wiphy " MAC_PR_FMT
+#define WIPHY_PR_ARG MAC_PR_ARG(wiphy_mac)
+
+#define WDEV_ENTRY __field(u32, id)
+#define WDEV_ASSIGN (__entry->id) = (wdev->identifier)
+#define WDEV_PR_FMT ", wdev id: %u"
+#define WDEV_PR_ARG (__entry->id)
+
+#define NETDEV_ENTRY __array(char, name, IFNAMSIZ) \
+		     MAC_ENTRY(netdev_addr)	   \
+		     __field(int, ifindex)
+#define NETDEV_ASSIGN					       \
+	do {						       \
+		memcpy(__entry->name, netdev->name, IFNAMSIZ); \
+		MAC_ASSIGN(netdev_addr, netdev->dev_addr);     \
+		(__entry->ifindex) = (netdev->ifindex);	       \
+	} while (0)
+#define NETDEV_PR_FMT ", netdev - name: %s, addr: " MAC_PR_FMT \
+		      ", intf index: %d"
+#define NETDEV_PR_ARG (__entry->name), MAC_PR_ARG(netdev_addr), \
+		      (__entry->ifindex)
+
+#define MESH_CFG_ENTRY __field(u16, dot11MeshRetryTimeout)		   \
+		       __field(u16, dot11MeshConfirmTimeout)		   \
+		       __field(u16, dot11MeshHoldingTimeout)		   \
+		       __field(u16, dot11MeshMaxPeerLinks)		   \
+		       __field(u8, dot11MeshMaxRetries)			   \
+		       __field(u8, dot11MeshTTL)			   \
+		       __field(u8, element_ttl)				   \
+		       __field(bool, auto_open_plinks)			   \
+		       __field(u32, dot11MeshNbrOffsetMaxNeighbor)	   \
+		       __field(u8, dot11MeshHWMPmaxPREQretries)		   \
+		       __field(u32, path_refresh_time)			   \
+		       __field(u32, dot11MeshHWMPactivePathTimeout)	   \
+		       __field(u16, min_discovery_timeout)		   \
+		       __field(u16, dot11MeshHWMPpreqMinInterval)	   \
+		       __field(u16, dot11MeshHWMPperrMinInterval)	   \
+		       __field(u16, dot11MeshHWMPnetDiameterTraversalTime) \
+		       __field(u8, dot11MeshHWMPRootMode)		   \
+		       __field(u16, dot11MeshHWMPRannInterval)		   \
+		       __field(bool, dot11MeshGateAnnouncementProtocol)	   \
+		       __field(bool, dot11MeshForwarding)		   \
+		       __field(s32, rssi_threshold)			   \
+		       __field(u16, ht_opmode)				   \
+		       __field(u32, dot11MeshHWMPactivePathToRootTimeout)  \
+		       __field(u16, dot11MeshHWMProotInterval)		   \
+		       __field(u16, dot11MeshHWMPconfirmationInterval)
+#define MESH_CFG_ASSIGN							      \
+	do {								      \
+		__entry->dot11MeshRetryTimeout = conf->dot11MeshRetryTimeout; \
+		__entry->dot11MeshConfirmTimeout =			      \
+				conf->dot11MeshConfirmTimeout;		      \
+		__entry->dot11MeshHoldingTimeout =			      \
+				conf->dot11MeshHoldingTimeout;		      \
+		__entry->dot11MeshMaxPeerLinks = conf->dot11MeshMaxPeerLinks; \
+		__entry->dot11MeshMaxRetries = conf->dot11MeshMaxRetries;     \
+		__entry->dot11MeshTTL = conf->dot11MeshTTL;		      \
+		__entry->element_ttl = conf->element_ttl;		      \
+		__entry->auto_open_plinks = conf->auto_open_plinks;	      \
+		__entry->dot11MeshNbrOffsetMaxNeighbor =		      \
+				conf->dot11MeshNbrOffsetMaxNeighbor;	      \
+		__entry->dot11MeshHWMPmaxPREQretries =			      \
+				conf->dot11MeshHWMPmaxPREQretries;	      \
+		__entry->path_refresh_time = conf->path_refresh_time;	      \
+		__entry->dot11MeshHWMPactivePathTimeout =		      \
+				conf->dot11MeshHWMPactivePathTimeout;	      \
+		__entry->min_discovery_timeout = conf->min_discovery_timeout; \
+		__entry->dot11MeshHWMPpreqMinInterval =			      \
+				conf->dot11MeshHWMPpreqMinInterval;	      \
+		__entry->dot11MeshHWMPperrMinInterval =			      \
+				conf->dot11MeshHWMPperrMinInterval;	      \
+		__entry->dot11MeshHWMPnetDiameterTraversalTime =	      \
+				conf->dot11MeshHWMPnetDiameterTraversalTime;  \
+		__entry->dot11MeshHWMPRootMode = conf->dot11MeshHWMPRootMode; \
+		__entry->dot11MeshHWMPRannInterval =			      \
+				conf->dot11MeshHWMPRannInterval;	      \
+		__entry->dot11MeshGateAnnouncementProtocol =		      \
+				conf->dot11MeshGateAnnouncementProtocol;      \
+		__entry->dot11MeshForwarding = conf->dot11MeshForwarding;     \
+		__entry->rssi_threshold = conf->rssi_threshold;		      \
+		__entry->ht_opmode = conf->ht_opmode;			      \
+		__entry->dot11MeshHWMPactivePathToRootTimeout =		      \
+				conf->dot11MeshHWMPactivePathToRootTimeout;   \
+		__entry->dot11MeshHWMProotInterval =			      \
+				conf->dot11MeshHWMProotInterval;	      \
+		__entry->dot11MeshHWMPconfirmationInterval =		      \
+				conf->dot11MeshHWMPconfirmationInterval;      \
+	} while (0)
+
+#define CHAN_ENTRY __field(enum ieee80211_band, band) \
+		   __field(u16, center_freq)
+#define CHAN_ASSIGN(chan)					  \
+	do {							  \
+		if (chan) {					  \
+			__entry->band = chan->band;		  \
+			__entry->center_freq = chan->center_freq; \
+		} else {					  \
+			__entry->band = 0;			  \
+			__entry->center_freq = 0;		  \
+		}						  \
+	} while (0)
+#define CHAN_PR_FMT ", band: %d, freq: %u"
+#define CHAN_PR_ARG __entry->band, __entry->center_freq
+
+#define SINFO_ENTRY __field(int, generation)	    \
+		    __field(u32, connected_time)    \
+		    __field(u32, inactive_time)	    \
+		    __field(u32, rx_bytes)	    \
+		    __field(u32, tx_bytes)	    \
+		    __field(u32, rx_packets)	    \
+		    __field(u32, tx_packets)	    \
+		    __field(u32, tx_retries)	    \
+		    __field(u32, tx_failed)	    \
+		    __field(u32, rx_dropped_misc)   \
+		    __field(u32, beacon_loss_count) \
+		    __field(u16, llid)		    \
+		    __field(u16, plid)		    \
+		    __field(u8, plink_state)
+#define SINFO_ASSIGN						       \
+	do {							       \
+		__entry->generation = sinfo->generation;	       \
+		__entry->connected_time = sinfo->connected_time;       \
+		__entry->inactive_time = sinfo->inactive_time;	       \
+		__entry->rx_bytes = sinfo->rx_bytes;		       \
+		__entry->tx_bytes = sinfo->tx_bytes;		       \
+		__entry->rx_packets = sinfo->rx_packets;	       \
+		__entry->tx_packets = sinfo->tx_packets;	       \
+		__entry->tx_retries = sinfo->tx_retries;	       \
+		__entry->tx_failed = sinfo->tx_failed;		       \
+		__entry->rx_dropped_misc = sinfo->rx_dropped_misc;     \
+		__entry->beacon_loss_count = sinfo->beacon_loss_count; \
+		__entry->llid = sinfo->llid;			       \
+		__entry->plid = sinfo->plid;			       \
+		__entry->plink_state = sinfo->plink_state;	       \
+	} while (0)
+
+#define BOOL_TO_STR(bo) (bo) ? "true" : "false"
+
+/*************************************************************
+ *			rdev->ops traces		     *
+ *************************************************************/
+
+TRACE_EVENT(rdev_suspend,
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_wowlan *wow),
+	TP_ARGS(wiphy, wow),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(bool, any)
+		__field(bool, disconnect)
+		__field(bool, magic_pkt)
+		__field(bool, gtk_rekey_failure)
+		__field(bool, eap_identity_req)
+		__field(bool, four_way_handshake)
+		__field(bool, rfkill_release)
+		__field(bool, valid_wow)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		if (wow) {
+			__entry->any = wow->any;
+			__entry->disconnect = wow->disconnect;
+			__entry->magic_pkt = wow->magic_pkt;
+			__entry->gtk_rekey_failure = wow->gtk_rekey_failure;
+			__entry->eap_identity_req = wow->eap_identity_req;
+			__entry->four_way_handshake = wow->four_way_handshake;
+			__entry->rfkill_release = wow->rfkill_release;
+			__entry->valid_wow = true;
+		} else {
+			__entry->valid_wow = false;
+		}
+	),
+	TP_printk(WIPHY_PR_FMT ", wow%s - any: %d, disconnect: %d, "
+		  "magic pkt: %d, gtk rekey failure: %d, eap identify req: %d, "
+		  "four way handshake: %d, rfkill release: %d.",
+		  WIPHY_PR_ARG, __entry->valid_wow ? "" : "(Not configured!)",
+		  __entry->any, __entry->disconnect, __entry->magic_pkt,
+		  __entry->gtk_rekey_failure, __entry->eap_identity_req,
+		  __entry->four_way_handshake, __entry->rfkill_release)
+);
+
+TRACE_EVENT(rdev_return_int,
+	TP_PROTO(struct wiphy *wiphy, int ret),
+	TP_ARGS(wiphy, ret),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(int, ret)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->ret = ret;
+	),
+	TP_printk(WIPHY_PR_FMT ", returned: %d", WIPHY_PR_ARG, __entry->ret)
+);
+
+TRACE_EVENT(rdev_scan,
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_scan_request *request),
+	TP_ARGS(wiphy, request),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT, WIPHY_PR_ARG)
+);
+
+DECLARE_EVENT_CLASS(wiphy_only_evt,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT, WIPHY_PR_ARG)
+);
+
+DEFINE_EVENT(wiphy_only_evt, rdev_resume,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
+DEFINE_EVENT(wiphy_only_evt, rdev_return_void,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
+DEFINE_EVENT(wiphy_only_evt, rdev_get_ringparam,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
+DEFINE_EVENT(wiphy_only_evt, rdev_get_antenna,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
+DEFINE_EVENT(wiphy_only_evt, rdev_get_tx_power,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
+DEFINE_EVENT(wiphy_only_evt, rdev_rfkill_poll,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
+DECLARE_EVENT_CLASS(wiphy_enabled_evt,
+	TP_PROTO(struct wiphy *wiphy, bool enabled),
+	TP_ARGS(wiphy, enabled),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(bool, enabled)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->enabled = enabled;
+	),
+	TP_printk(WIPHY_PR_FMT ", %senabled ",
+		  WIPHY_PR_ARG, __entry->enabled ? "" : "not ")
+);
+
+DEFINE_EVENT(wiphy_enabled_evt, rdev_set_wakeup,
+	TP_PROTO(struct wiphy *wiphy, bool enabled),
+	TP_ARGS(wiphy, enabled)
+);
+
+TRACE_EVENT(rdev_add_virtual_intf,
+	TP_PROTO(struct wiphy *wiphy, char *name, enum nl80211_iftype type),
+	TP_ARGS(wiphy, name, type),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__string(vir_intf_name, name ? name : "<noname>")
+		__field(enum nl80211_iftype, type)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__assign_str(vir_intf_name, name ? name : "<noname>");
+		__entry->type = type;
+	),
+	TP_printk(WIPHY_PR_FMT ", virtual intf name: %s, type: %d",
+		  WIPHY_PR_ARG, __get_str(vir_intf_name), __entry->type)
+);
+
+DECLARE_EVENT_CLASS(wiphy_wdev_evt,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
+);
+
+DEFINE_EVENT(wiphy_wdev_evt, rdev_return_wdev,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
+DEFINE_EVENT(wiphy_wdev_evt, rdev_del_virtual_intf,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
+TRACE_EVENT(rdev_change_virtual_intf,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 enum nl80211_iftype type),
+	TP_ARGS(wiphy, netdev, type),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(enum nl80211_iftype, type)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->type = type;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", type: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->type)
+);
+
+DECLARE_EVENT_CLASS(key_handle,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+		 bool pairwise, const u8 *mac_addr),
+	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(mac_addr)
+		__field(u8, key_index)
+		__field(bool, pairwise)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(mac_addr, mac_addr);
+		__entry->key_index = key_index;
+		__entry->pairwise = pairwise;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", key_index: %u, pairwise: %s, mac addr: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->key_index,
+		  BOOL_TO_STR(__entry->pairwise), MAC_PR_ARG(mac_addr))
+);
+
+DEFINE_EVENT(key_handle, rdev_add_key,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+		 bool pairwise, const u8 *mac_addr),
+	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr)
+);
+
+DEFINE_EVENT(key_handle, rdev_get_key,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+		 bool pairwise, const u8 *mac_addr),
+	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr)
+);
+
+DEFINE_EVENT(key_handle, rdev_del_key,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+		 bool pairwise, const u8 *mac_addr),
+	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr)
+);
+
+TRACE_EVENT(rdev_set_default_key,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
+		 bool unicast, bool multicast),
+	TP_ARGS(wiphy, netdev, key_index, unicast, multicast),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u8, key_index)
+		__field(bool, unicast)
+		__field(bool, multicast)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->key_index = key_index;
+		__entry->unicast = unicast;
+		__entry->multicast = multicast;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", key index: %u, unicast: %s, multicast: %s",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->key_index,
+		  BOOL_TO_STR(__entry->unicast),
+		  BOOL_TO_STR(__entry->multicast))
+);
+
+TRACE_EVENT(rdev_set_default_mgmt_key,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index),
+	TP_ARGS(wiphy, netdev, key_index),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u8, key_index)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->key_index = key_index;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", key index: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->key_index)
+);
+
+TRACE_EVENT(rdev_start_ap,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_ap_settings *settings),
+	TP_ARGS(wiphy, netdev, settings),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		CHAN_ENTRY
+		__field(int, beacon_interval)
+		__field(int, dtim_period)
+		__array(char, ssid, IEEE80211_MAX_SSID_LEN + 1)
+		__field(enum nl80211_hidden_ssid, hidden_ssid)
+		__field(u32, wpa_ver)
+		__field(bool, privacy)
+		__field(enum nl80211_auth_type, auth_type)
+		__field(int, inactivity_timeout)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		CHAN_ASSIGN(settings->channel);
+		__entry->beacon_interval = settings->beacon_interval;
+		__entry->dtim_period = settings->dtim_period;
+		__entry->hidden_ssid = settings->hidden_ssid;
+		__entry->wpa_ver = settings->crypto.wpa_versions;
+		__entry->privacy = settings->privacy;
+		__entry->auth_type = settings->auth_type;
+		__entry->inactivity_timeout = settings->inactivity_timeout;
+		memset(__entry->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
+		memcpy(__entry->ssid, settings->ssid, settings->ssid_len);
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", AP settings - ssid: %s, "
+		  CHAN_PR_FMT ", beacon interval: %d, dtim period: %d, "
+		  "hidden ssid: %d, wpa versions: %u, privacy: %s, "
+		  "auth type: %d, inactivity timeout: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->ssid, CHAN_PR_ARG,
+		  __entry->beacon_interval, __entry->dtim_period,
+		  __entry->hidden_ssid, __entry->wpa_ver,
+		  BOOL_TO_STR(__entry->privacy), __entry->auth_type,
+		  __entry->inactivity_timeout)
+);
+
+TRACE_EVENT(rdev_change_beacon,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_beacon_data *info),
+	TP_ARGS(wiphy, netdev, info),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__dynamic_array(u8, head, info ? info->head_len : 0)
+		__dynamic_array(u8, tail, info ? info->tail_len : 0)
+		__dynamic_array(u8, beacon_ies, info ? info->beacon_ies_len : 0)
+		__dynamic_array(u8, proberesp_ies,
+				info ? info->proberesp_ies_len : 0)
+		__dynamic_array(u8, assocresp_ies,
+				info ? info->assocresp_ies_len : 0)
+		__dynamic_array(u8, probe_resp, info ? info->probe_resp_len : 0)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		if (info) {
+			if (info->head)
+				memcpy(__get_dynamic_array(head), info->head,
+				       info->head_len);
+			if (info->tail)
+				memcpy(__get_dynamic_array(tail), info->tail,
+				       info->tail_len);
+			if (info->beacon_ies)
+				memcpy(__get_dynamic_array(beacon_ies),
+				       info->beacon_ies, info->beacon_ies_len);
+			if (info->proberesp_ies)
+				memcpy(__get_dynamic_array(proberesp_ies),
+				       info->proberesp_ies,
+				       info->proberesp_ies_len);
+			if (info->assocresp_ies)
+				memcpy(__get_dynamic_array(assocresp_ies),
+				       info->assocresp_ies,
+				       info->assocresp_ies_len);
+			if (info->probe_resp)
+				memcpy(__get_dynamic_array(probe_resp),
+				       info->probe_resp, info->probe_resp_len);
+		}
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT, WIPHY_PR_ARG, NETDEV_PR_ARG)
+);
+
+DECLARE_EVENT_CLASS(wiphy_netdev_evt,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT, WIPHY_PR_ARG, NETDEV_PR_ARG)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_stop_ap,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_get_et_stats,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_sched_scan_stop,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_set_rekey_data,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_get_mesh_config,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_leave_mesh,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_leave_ibss,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_flush_pmksa,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DECLARE_EVENT_CLASS(station_add_change,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 *mac,
+		 struct station_parameters *params),
+	TP_ARGS(wiphy, netdev, mac, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(sta_mac)
+		__field(u32, sta_flags_mask)
+		__field(u32, sta_flags_set)
+		__field(u32, sta_modify_mask)
+		__field(int, listen_interval)
+		__field(u16, aid)
+		__field(u8, plink_action)
+		__field(u8, plink_state)
+		__field(u8, uapsd_queues)
+		__array(u8, ht_capa, (int)sizeof(struct ieee80211_ht_cap))
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(sta_mac, mac);
+		__entry->sta_flags_mask = params->sta_flags_mask;
+		__entry->sta_flags_set = params->sta_flags_set;
+		__entry->sta_modify_mask = params->sta_modify_mask;
+		__entry->listen_interval = params->listen_interval;
+		__entry->aid = params->aid;
+		__entry->plink_action = params->plink_action;
+		__entry->plink_state = params->plink_state;
+		__entry->uapsd_queues = params->uapsd_queues;
+		memset(__entry->ht_capa, 0, sizeof(struct ieee80211_ht_cap));
+		if (params->ht_capa)
+			memcpy(__entry->ht_capa, params->ht_capa,
+			       sizeof(struct ieee80211_ht_cap));
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", station mac: " MAC_PR_FMT
+		  ", station flags mask: %u, station flags set: %u, "
+		  "station modify mask: %u, listen interval: %d, aid: %u, "
+		  "plink action: %u, plink state: %u, uapsd queues: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(sta_mac),
+		  __entry->sta_flags_mask, __entry->sta_flags_set,
+		  __entry->sta_modify_mask, __entry->listen_interval,
+		  __entry->aid, __entry->plink_action, __entry->plink_state,
+		  __entry->uapsd_queues)
+);
+
+DEFINE_EVENT(station_add_change, rdev_add_station,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 *mac,
+		 struct station_parameters *params),
+	TP_ARGS(wiphy, netdev, mac, params)
+);
+
+DEFINE_EVENT(station_add_change, rdev_change_station,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 *mac,
+		 struct station_parameters *params),
+	TP_ARGS(wiphy, netdev, mac, params)
+);
+
+DECLARE_EVENT_CLASS(wiphy_netdev_mac_evt,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *mac),
+	TP_ARGS(wiphy, netdev, mac),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(sta_mac)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(sta_mac, mac);
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", mac: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(sta_mac))
+);
+
+DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_del_station,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *mac),
+	TP_ARGS(wiphy, netdev, mac)
+);
+
+DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_get_station,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *mac),
+	TP_ARGS(wiphy, netdev, mac)
+);
+
+DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_del_mpath,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *mac),
+	TP_ARGS(wiphy, netdev, mac)
+);
+
+DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_set_wds_peer,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *mac),
+	TP_ARGS(wiphy, netdev, mac)
+);
+
+TRACE_EVENT(rdev_dump_station,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int idx,
+		 u8 *mac),
+	TP_ARGS(wiphy, netdev, idx, mac),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(sta_mac)
+		__field(int, idx)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(sta_mac, mac);
+		__entry->idx = idx;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", station mac: " MAC_PR_FMT ", idx: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(sta_mac),
+		  __entry->idx)
+);
+
+TRACE_EVENT(rdev_return_int_station_info,
+	TP_PROTO(struct wiphy *wiphy, int ret, struct station_info *sinfo),
+	TP_ARGS(wiphy, ret, sinfo),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(int, ret)
+		SINFO_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->ret = ret;
+		SINFO_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT ", returned %d" ,
+		  WIPHY_PR_ARG, __entry->ret)
+);
+
+DECLARE_EVENT_CLASS(mpath_evt,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 *dst,
+		 u8 *next_hop),
+	TP_ARGS(wiphy, netdev, dst, next_hop),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(dst)
+		MAC_ENTRY(next_hop)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(dst, dst);
+		MAC_ASSIGN(next_hop, next_hop);
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", destination: " MAC_PR_FMT ", next hop: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(dst),
+		  MAC_PR_ARG(next_hop))
+);
+
+DEFINE_EVENT(mpath_evt, rdev_add_mpath,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 *dst,
+		 u8 *next_hop),
+	TP_ARGS(wiphy, netdev, dst, next_hop)
+);
+
+DEFINE_EVENT(mpath_evt, rdev_change_mpath,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 *dst,
+		 u8 *next_hop),
+	TP_ARGS(wiphy, netdev, dst, next_hop)
+);
+
+DEFINE_EVENT(mpath_evt, rdev_get_mpath,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 *dst,
+		 u8 *next_hop),
+	TP_ARGS(wiphy, netdev, dst, next_hop)
+);
+
+TRACE_EVENT(rdev_dump_mpath,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int idx,
+		 u8 *dst, u8 *next_hop),
+	TP_ARGS(wiphy, netdev, idx, dst, next_hop),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(dst)
+		MAC_ENTRY(next_hop)
+		__field(int, idx)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(dst, dst);
+		MAC_ASSIGN(next_hop, next_hop);
+		__entry->idx = idx;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", index: %d, destination: "
+		  MAC_PR_FMT ", next hop: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->idx, MAC_PR_ARG(dst),
+		  MAC_PR_ARG(next_hop))
+);
+
+TRACE_EVENT(rdev_return_int_mpath_info,
+	TP_PROTO(struct wiphy *wiphy, int ret, struct mpath_info *pinfo),
+	TP_ARGS(wiphy, ret, pinfo),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(int, ret)
+		__field(int, generation)
+		__field(u32, filled)
+		__field(u32, frame_qlen)
+		__field(u32, sn)
+		__field(u32, metric)
+		__field(u32, exptime)
+		__field(u32, discovery_timeout)
+		__field(u8, discovery_retries)
+		__field(u8, flags)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->ret = ret;
+		__entry->generation = pinfo->generation;
+		__entry->filled = pinfo->filled;
+		__entry->frame_qlen = pinfo->frame_qlen;
+		__entry->sn = pinfo->sn;
+		__entry->metric = pinfo->metric;
+		__entry->exptime = pinfo->exptime;
+		__entry->discovery_timeout = pinfo->discovery_timeout;
+		__entry->discovery_retries = pinfo->discovery_retries;
+		__entry->flags = pinfo->flags;
+	),
+	TP_printk(WIPHY_PR_FMT ", returned %d. mpath info - generation: %d, "
+		  "filled: %u, frame qlen: %u, sn: %u, metric: %u, exptime: %u,"
+		  " discovery timeout: %u, discovery retries: %u, flags: %u",
+		  WIPHY_PR_ARG, __entry->ret, __entry->generation,
+		  __entry->filled, __entry->frame_qlen, __entry->sn,
+		  __entry->metric, __entry->exptime, __entry->discovery_timeout,
+		  __entry->discovery_retries, __entry->flags)
+);
+
+TRACE_EVENT(rdev_return_int_mesh_config,
+	TP_PROTO(struct wiphy *wiphy, int ret, struct mesh_config *conf),
+	TP_ARGS(wiphy, ret, conf),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		MESH_CFG_ENTRY
+		__field(int, ret)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		MESH_CFG_ASSIGN;
+		__entry->ret = ret;
+	),
+	TP_printk(WIPHY_PR_FMT ", returned: %d",
+		  WIPHY_PR_ARG, __entry->ret)
+);
+
+TRACE_EVENT(rdev_update_mesh_config,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u32 mask,
+		 const struct mesh_config *conf),
+	TP_ARGS(wiphy, netdev, mask, conf),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MESH_CFG_ENTRY
+		__field(u32, mask)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MESH_CFG_ASSIGN;
+		__entry->mask = mask;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", mask: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->mask)
+);
+
+TRACE_EVENT(rdev_join_mesh,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const struct mesh_config *conf,
+		 const struct mesh_setup *setup),
+	TP_ARGS(wiphy, netdev, conf, setup),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MESH_CFG_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MESH_CFG_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG)
+);
+
+TRACE_EVENT(rdev_change_bss,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct bss_parameters *params),
+	TP_ARGS(wiphy, netdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(int, use_cts_prot)
+		__field(int, use_short_preamble)
+		__field(int, use_short_slot_time)
+		__field(int, ap_isolate)
+		__field(int, ht_opmode)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->use_cts_prot = params->use_cts_prot;
+		__entry->use_short_preamble = params->use_short_preamble;
+		__entry->use_short_slot_time = params->use_short_slot_time;
+		__entry->ap_isolate = params->ap_isolate;
+		__entry->ht_opmode = params->ht_opmode;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", use cts prot: %d, "
+		  "use short preamble: %d, use short slot time: %d, "
+		  "ap isolate: %d, ht opmode: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->use_cts_prot,
+		  __entry->use_short_preamble, __entry->use_short_slot_time,
+		  __entry->ap_isolate, __entry->ht_opmode)
+);
+
+TRACE_EVENT(rdev_set_txq_params,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct ieee80211_txq_params *params),
+	TP_ARGS(wiphy, netdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(enum nl80211_ac, ac)
+		__field(u16, txop)
+		__field(u16, cwmin)
+		__field(u16, cwmax)
+		__field(u8, aifs)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->ac = params->ac;
+		__entry->txop = params->txop;
+		__entry->cwmin = params->cwmin;
+		__entry->cwmax = params->cwmax;
+		__entry->aifs = params->aifs;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", ac: %d, txop: %u, cwmin: %u, cwmax: %u, aifs: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->ac, __entry->txop,
+		  __entry->cwmin, __entry->cwmax, __entry->aifs)
+);
+
+TRACE_EVENT(rdev_libertas_set_mesh_channel,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct ieee80211_channel *chan),
+	TP_ARGS(wiphy, netdev, chan),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		CHAN_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		CHAN_ASSIGN(chan);
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT CHAN_PR_FMT, WIPHY_PR_ARG,
+		  NETDEV_PR_ARG, CHAN_PR_ARG)
+);
+
+TRACE_EVENT(rdev_set_monitor_channel,
+	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *chan,
+		 enum nl80211_channel_type chan_type),
+	TP_ARGS(wiphy, chan, chan_type),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		CHAN_ENTRY
+		__field(enum nl80211_channel_type, chan_type)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		CHAN_ASSIGN(chan);
+		__entry->chan_type = chan_type;
+	),
+	TP_printk(WIPHY_PR_FMT CHAN_PR_FMT ", channel type : %d",
+		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->chan_type)
+);
+
+TRACE_EVENT(rdev_auth,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_auth_request *req),
+	TP_ARGS(wiphy, netdev, req),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(bssid)
+		__field(enum nl80211_auth_type, auth_type)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		if (req->bss)
+			MAC_ASSIGN(bssid, req->bss->bssid);
+		else
+			memset(__entry->bssid, 0, ETH_ALEN);
+		__entry->auth_type = req->auth_type;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", auth type: %d, bssid: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->auth_type,
+		  MAC_PR_ARG(bssid))
+);
+
+TRACE_EVENT(rdev_assoc,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_assoc_request *req),
+	TP_ARGS(wiphy, netdev, req),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(bssid)
+		MAC_ENTRY(prev_bssid)
+		__field(bool, use_mfp)
+		__field(u32, flags)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		if (req->bss)
+			MAC_ASSIGN(bssid, req->bss->bssid);
+		else
+			memset(__entry->bssid, 0, ETH_ALEN);
+		MAC_ASSIGN(prev_bssid, req->prev_bssid);
+		__entry->use_mfp = req->use_mfp;
+		__entry->flags = req->flags;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", bssid: " MAC_PR_FMT
+		  ", previous bssid: " MAC_PR_FMT ", use mfp: %s, flags: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(bssid),
+		  MAC_PR_ARG(prev_bssid), BOOL_TO_STR(__entry->use_mfp),
+		  __entry->flags)
+);
+
+TRACE_EVENT(rdev_deauth,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_deauth_request *req),
+	TP_ARGS(wiphy, netdev, req),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(bssid)
+		__field(u16, reason_code)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(bssid, req->bssid);
+		__entry->reason_code = req->reason_code;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", bssid: " MAC_PR_FMT ", reason: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(bssid),
+		  __entry->reason_code)
+);
+
+TRACE_EVENT(rdev_disassoc,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_disassoc_request *req),
+	TP_ARGS(wiphy, netdev, req),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(bssid)
+		__field(u16, reason_code)
+		__field(bool, local_state_change)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		if (req->bss)
+			MAC_ASSIGN(bssid, req->bss->bssid);
+		else
+			memset(__entry->bssid, 0, ETH_ALEN);
+		__entry->reason_code = req->reason_code;
+		__entry->local_state_change = req->local_state_change;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", bssid: " MAC_PR_FMT
+		  ", reason: %u, local state change: %s",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(bssid),
+		  __entry->reason_code,
+		  BOOL_TO_STR(__entry->local_state_change))
+);
+
+TRACE_EVENT(rdev_mgmt_tx_cancel_wait,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct wireless_dev *wdev, u64 cookie),
+	TP_ARGS(wiphy, wdev, cookie),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u64, cookie)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->cookie = cookie;
+	),
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT ", cookie: %llu ",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->cookie)
+);
+
+TRACE_EVENT(rdev_set_power_mgmt,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 bool enabled, int timeout),
+	TP_ARGS(wiphy, netdev, enabled, timeout),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(bool, enabled)
+		__field(int, timeout)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->enabled = enabled;
+		__entry->timeout = timeout;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", %senabled, timeout: %d ",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  __entry->enabled ? "" : "not ", __entry->timeout)
+);
+
+TRACE_EVENT(rdev_connect,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_connect_params *sme),
+	TP_ARGS(wiphy, netdev, sme),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(bssid)
+		__array(char, ssid, IEEE80211_MAX_SSID_LEN + 1)
+		__field(enum nl80211_auth_type, auth_type)
+		__field(bool, privacy)
+		__field(u32, wpa_versions)
+		__field(u32, flags)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(bssid, sme->bssid);
+		memset(__entry->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
+		memcpy(__entry->ssid, sme->ssid, sme->ssid_len);
+		__entry->auth_type = sme->auth_type;
+		__entry->privacy = sme->privacy;
+		__entry->wpa_versions = sme->crypto.wpa_versions;
+		__entry->flags = sme->flags;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", bssid: " MAC_PR_FMT
+		  ", ssid: %s, auth type: %d, privacy: %s, wpa versions: %u, "
+		  "flags: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(bssid), __entry->ssid,
+		  __entry->auth_type, BOOL_TO_STR(__entry->privacy),
+		  __entry->wpa_versions, __entry->flags)
+);
+
+TRACE_EVENT(rdev_set_cqm_rssi_config,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct net_device *netdev, s32 rssi_thold,
+		 u32 rssi_hyst),
+	TP_ARGS(wiphy, netdev, rssi_thold, rssi_hyst),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(s32, rssi_thold)
+		__field(u32, rssi_hyst)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->rssi_thold = rssi_thold;
+		__entry->rssi_hyst = rssi_hyst;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT
+		  ", rssi_thold: %d, rssi_hyst: %u ",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG,
+		 __entry->rssi_thold, __entry->rssi_hyst)
+);
+
+TRACE_EVENT(rdev_set_cqm_txe_config,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u32 rate,
+		 u32 pkts, u32 intvl),
+	TP_ARGS(wiphy, netdev, rate, pkts, intvl),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u32, rate)
+		__field(u32, pkts)
+		__field(u32, intvl)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->rate = rate;
+		__entry->pkts = pkts;
+		__entry->intvl = intvl;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", rate: %u, packets: %u, interval: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->rate, __entry->pkts,
+		  __entry->intvl)
+);
+
+TRACE_EVENT(rdev_disconnect,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u16 reason_code),
+	TP_ARGS(wiphy, netdev, reason_code),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u16, reason_code)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->reason_code = reason_code;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", reason code: %u", WIPHY_PR_ARG,
+		  NETDEV_PR_ARG, __entry->reason_code)
+);
+
+TRACE_EVENT(rdev_join_ibss,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_ibss_params *params),
+	TP_ARGS(wiphy, netdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(bssid)
+		__array(char, ssid, IEEE80211_MAX_SSID_LEN + 1)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(bssid, params->bssid);
+		memset(__entry->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
+		memcpy(__entry->ssid, params->ssid, params->ssid_len);
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", bssid: " MAC_PR_FMT ", ssid: %s",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(bssid), __entry->ssid)
+);
+
+TRACE_EVENT(rdev_set_wiphy_params,
+	TP_PROTO(struct wiphy *wiphy, u32 changed),
+	TP_ARGS(wiphy, changed),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(u32, changed)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->changed = changed;
+	),
+	TP_printk(WIPHY_PR_FMT ", changed: %u",
+		  WIPHY_PR_ARG, __entry->changed)
+);
+
+TRACE_EVENT(rdev_set_tx_power,
+	TP_PROTO(struct wiphy *wiphy, enum nl80211_tx_power_setting type,
+		 int mbm),
+	TP_ARGS(wiphy, type, mbm),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(enum nl80211_tx_power_setting, type)
+		__field(int, mbm)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->type = type;
+		__entry->mbm = mbm;
+	),
+	TP_printk(WIPHY_PR_FMT ", type: %d, mbm: %d",
+		  WIPHY_PR_ARG, __entry->type, __entry->mbm)
+);
+
+TRACE_EVENT(rdev_return_int_int,
+	TP_PROTO(struct wiphy *wiphy, int func_ret, int func_fill),
+	TP_ARGS(wiphy, func_ret, func_fill),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(int, func_ret)
+		__field(int, func_fill)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->func_ret = func_ret;
+		__entry->func_fill = func_fill;
+	),
+	TP_printk(WIPHY_PR_FMT ", function returns: %d, function filled: %d",
+		  WIPHY_PR_ARG, __entry->func_ret, __entry->func_fill)
+);
+
+#ifdef CONFIG_NL80211_TESTMODE
+TRACE_EVENT(rdev_testmode_cmd,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT, WIPHY_PR_ARG)
+);
+
+TRACE_EVENT(rdev_testmode_dump,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT, WIPHY_PR_ARG)
+);
+#endif /* CONFIG_NL80211_TESTMODE */
+
+TRACE_EVENT(rdev_set_bitrate_mask,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *peer, const struct cfg80211_bitrate_mask *mask),
+	TP_ARGS(wiphy, netdev, peer, mask),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", peer: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer))
+);
+
+TRACE_EVENT(rdev_mgmt_frame_register,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 u16 frame_type, bool reg),
+	TP_ARGS(wiphy, wdev, frame_type, reg),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u16, frame_type)
+		__field(bool, reg)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->frame_type = frame_type;
+		__entry->reg = reg;
+	),
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT ", frame_type: %u, reg: %s ",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->frame_type,
+		  __entry->reg ? "true" : "false")
+);
+
+TRACE_EVENT(rdev_return_int_tx_rx,
+	TP_PROTO(struct wiphy *wiphy, int ret, u32 tx, u32 rx),
+	TP_ARGS(wiphy, ret, tx, rx),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(int, ret)
+		__field(u32, tx)
+		__field(u32, rx)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->ret = ret;
+		__entry->tx = tx;
+		__entry->rx = rx;
+	),
+	TP_printk(WIPHY_PR_FMT ", returned %d, tx: %u, rx: %u",
+		  WIPHY_PR_ARG, __entry->ret, __entry->tx, __entry->rx)
+);
+
+TRACE_EVENT(rdev_return_void_tx_rx,
+	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 tx_max,
+		 u32 rx, u32 rx_max),
+	TP_ARGS(wiphy, tx, tx_max, rx, rx_max),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(u32, tx)
+		__field(u32, tx_max)
+		__field(u32, rx)
+		__field(u32, rx_max)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->tx = tx;
+		__entry->tx_max = tx_max;
+		__entry->rx = rx;
+		__entry->rx_max = rx_max;
+	),
+	TP_printk(WIPHY_PR_FMT ", tx: %u, tx_max: %u, rx: %u, rx_max: %u ",
+		  WIPHY_PR_ARG, __entry->tx, __entry->tx_max, __entry->rx,
+		  __entry->rx_max)
+);
+
+DECLARE_EVENT_CLASS(tx_rx_evt,
+	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
+	TP_ARGS(wiphy, rx, tx),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(u32, tx)
+		__field(u32, rx)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->tx = tx;
+		__entry->rx = rx;
+	),
+	TP_printk(WIPHY_PR_FMT ", tx: %u, rx: %u ",
+		  WIPHY_PR_ARG, __entry->tx, __entry->rx)
+);
+
+DEFINE_EVENT(tx_rx_evt, rdev_set_ringparam,
+	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
+	TP_ARGS(wiphy, rx, tx)
+);
+
+DEFINE_EVENT(tx_rx_evt, rdev_set_antenna,
+	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
+	TP_ARGS(wiphy, rx, tx)
+);
+
+TRACE_EVENT(rdev_sched_scan_start,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_sched_scan_request *request),
+	TP_ARGS(wiphy, netdev, request),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG)
+);
+
+TRACE_EVENT(rdev_tdls_mgmt,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u8 *peer, u8 action_code, u8 dialog_token,
+		 u16 status_code, const u8 *buf, size_t len),
+	TP_ARGS(wiphy, netdev, peer, action_code, dialog_token, status_code,
+		buf, len),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(u8, action_code)
+		__field(u8, dialog_token)
+		__field(u16, status_code)
+		__dynamic_array(u8, buf, len)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->action_code = action_code;
+		__entry->dialog_token = dialog_token;
+		__entry->status_code = status_code;
+		memcpy(__get_dynamic_array(buf), buf, len);
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT MAC_PR_FMT ", action_code: %u, "
+		  "dialog_token: %u, status_code: %u, buf: %#.2x ",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->action_code, __entry->dialog_token,
+		  __entry->status_code, ((u8 *)__get_dynamic_array(buf))[0])
+);
+
+TRACE_EVENT(rdev_dump_survey,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int idx),
+	TP_ARGS(wiphy, netdev, idx),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(int, idx)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->idx = idx;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", index: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->idx)
+);
+
+TRACE_EVENT(rdev_return_int_survey_info,
+	TP_PROTO(struct wiphy *wiphy, int ret, struct survey_info *info),
+	TP_ARGS(wiphy, ret, info),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		CHAN_ENTRY
+		__field(int, ret)
+		__field(u64, channel_time)
+		__field(u64, channel_time_busy)
+		__field(u64, channel_time_ext_busy)
+		__field(u64, channel_time_rx)
+		__field(u64, channel_time_tx)
+		__field(u32, filled)
+		__field(s8, noise)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		CHAN_ASSIGN(info->channel);
+		__entry->ret = ret;
+		__entry->channel_time = info->channel_time;
+		__entry->channel_time_busy = info->channel_time_busy;
+		__entry->channel_time_ext_busy = info->channel_time_ext_busy;
+		__entry->channel_time_rx = info->channel_time_rx;
+		__entry->channel_time_tx = info->channel_time_tx;
+		__entry->filled = info->filled;
+		__entry->noise = info->noise;
+	),
+	TP_printk(WIPHY_PR_FMT ", returned: %d, " CHAN_PR_FMT
+		  ", channel time: %llu, channel time busy: %llu, "
+		  "channel time extension busy: %llu, channel time rx: %llu, "
+		  "channel time tx: %llu, filled: %u, noise: %d",
+		  WIPHY_PR_ARG, __entry->ret, CHAN_PR_ARG,
+		  __entry->channel_time, __entry->channel_time_busy,
+		  __entry->channel_time_ext_busy, __entry->channel_time_rx,
+		  __entry->channel_time_tx, __entry->filled, __entry->noise)
+);
+
+TRACE_EVENT(rdev_tdls_oper,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u8 *peer, enum nl80211_tdls_operation oper),
+	TP_ARGS(wiphy, netdev, peer, oper),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(enum nl80211_tdls_operation, oper)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->oper = oper;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT MAC_PR_FMT ", oper: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer), __entry->oper)
+);
+
+DECLARE_EVENT_CLASS(rdev_pmksa,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_pmksa *pmksa),
+	TP_ARGS(wiphy, netdev, pmksa),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(bssid)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(bssid, pmksa->bssid);
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", bssid: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(bssid))
+);
+
+TRACE_EVENT(rdev_probe_client,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *peer),
+	TP_ARGS(wiphy, netdev, peer),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer))
+);
+
+DEFINE_EVENT(rdev_pmksa, rdev_set_pmksa,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_pmksa *pmksa),
+	TP_ARGS(wiphy, netdev, pmksa)
+);
+
+DEFINE_EVENT(rdev_pmksa, rdev_del_pmksa,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_pmksa *pmksa),
+	TP_ARGS(wiphy, netdev, pmksa)
+);
+
+TRACE_EVENT(rdev_remain_on_channel,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct ieee80211_channel *chan,
+		 enum nl80211_channel_type channel_type, unsigned int duration),
+	TP_ARGS(wiphy, wdev, chan, channel_type, duration),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		CHAN_ENTRY
+		__field(enum nl80211_channel_type, channel_type)
+		__field(unsigned int, duration)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		CHAN_ASSIGN(chan);
+		__entry->channel_type = channel_type;
+		__entry->duration = duration;
+	),
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT CHAN_PR_FMT ", channel type: %d, duration: %u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, CHAN_PR_ARG, __entry->channel_type,
+		  __entry->duration)
+);
+
+TRACE_EVENT(rdev_return_int_cookie,
+	TP_PROTO(struct wiphy *wiphy, int ret, u64 cookie),
+	TP_ARGS(wiphy, ret, cookie),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(int, ret)
+		__field(u64, cookie)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->ret = ret;
+		__entry->cookie = cookie;
+	),
+	TP_printk(WIPHY_PR_FMT ", returned %d, cookie: %llu",
+		  WIPHY_PR_ARG, __entry->ret, __entry->cookie)
+);
+
+TRACE_EVENT(rdev_cancel_remain_on_channel,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, u64 cookie),
+	TP_ARGS(wiphy, wdev, cookie),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u64, cookie)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->cookie = cookie;
+	),
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT ", cookie: %llu",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->cookie)
+);
+
+TRACE_EVENT(rdev_mgmt_tx,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct ieee80211_channel *chan, bool offchan,
+		 enum nl80211_channel_type channel_type,
+		 bool channel_type_valid, unsigned int wait, bool no_cck,
+		 bool dont_wait_for_ack),
+	TP_ARGS(wiphy, wdev, chan, offchan, channel_type, channel_type_valid,
+		wait, no_cck, dont_wait_for_ack),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		CHAN_ENTRY
+		__field(bool, offchan)
+		__field(enum nl80211_channel_type, channel_type)
+		__field(bool, channel_type_valid)
+		__field(unsigned int, wait)
+		__field(bool, no_cck)
+		__field(bool, dont_wait_for_ack)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		CHAN_ASSIGN(chan);
+		__entry->offchan = offchan;
+		__entry->channel_type = channel_type;
+		__entry->channel_type_valid = channel_type_valid;
+		__entry->wait = wait;
+		__entry->no_cck = no_cck;
+		__entry->dont_wait_for_ack = dont_wait_for_ack;
+	),
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT CHAN_PR_FMT ", offchan: %s, "
+		  "channel type: %d, channel type valid: %s, wait: %u, "
+		  "no cck: %s, dont wait for ack: %s",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, CHAN_PR_ARG,
+		  BOOL_TO_STR(__entry->offchan), __entry->channel_type,
+		  BOOL_TO_STR(__entry->channel_type_valid), __entry->wait,
+		  BOOL_TO_STR(__entry->no_cck),
+		  BOOL_TO_STR(__entry->dont_wait_for_ack))
+);
+
+TRACE_EVENT(rdev_set_noack_map,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u16 noack_map),
+	TP_ARGS(wiphy, netdev, noack_map),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u16, noack_map)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->noack_map = noack_map;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", noack_map: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->noack_map)
+);
+
+TRACE_EVENT(rdev_get_et_sset_count,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int sset),
+	TP_ARGS(wiphy, netdev, sset),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(int, sset)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->sset = sset;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", sset: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->sset)
+);
+
+TRACE_EVENT(rdev_get_et_strings,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u32 sset),
+	TP_ARGS(wiphy, netdev, sset),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u32, sset)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->sset = sset;
+	),
+	TP_printk(WIPHY_PR_FMT NETDEV_PR_FMT ", sset: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->sset)
+);
+
+DEFINE_EVENT(wiphy_wdev_evt, rdev_get_channel,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
+TRACE_EVENT(rdev_return_channel,
+	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *chan,
+		 enum nl80211_channel_type type),
+	TP_ARGS(wiphy, chan, type),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		CHAN_ENTRY
+		__field(enum nl80211_channel_type, type)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		CHAN_ASSIGN(chan);
+		__entry->type = type;
+	),
+	TP_printk(WIPHY_PR_FMT CHAN_PR_FMT ", channel type: %d",
+		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->type)
+);
+
+#endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
-- 
1.7.10.4

