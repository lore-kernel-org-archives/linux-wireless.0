Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZCZL2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 07:28:14 -0400
Subject: [PATCH] mac80211: add driver ops debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 12:27:38 +0100
Message-Id: <1238066858.4331.30.camel@johannes.local> (sfid-20090326_122819_843243_E02404BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds (optional) debugging for each driver call
(except tx) that can print out the call, its parameters and
the return value from the driver. I did this by adding static
inlines for each driver operation and integrating debugging
into them, thus all driver calls are now written as

	drv_<op>(local, ...);

instead of

	local->ops-><op>(&local->hw, ...);

Some of the inlines have also gotten the existence check and
default return values for the call integrated into them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
A future plan might be to use dynamic_printk(), but I'm leaving that out
for now -- we only need to modify the driver-ops-dbg.c file then anyway.

 net/mac80211/Kconfig          |    9 
 net/mac80211/Makefile         |    1 
 net/mac80211/agg-rx.c         |   11 -
 net/mac80211/agg-tx.c         |   13 -
 net/mac80211/cfg.c            |   13 -
 net/mac80211/debugfs.c        |   17 -
 net/mac80211/driver-ops-dbg.c |  190 +++++++++++++++++++
 net/mac80211/driver-ops.h     |  417 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ibss.c           |   26 +-
 net/mac80211/iface.c          |   22 +-
 net/mac80211/key.c            |    8 
 net/mac80211/main.c           |   20 --
 net/mac80211/mlme.c           |   17 -
 net/mac80211/pm.c             |   20 +-
 net/mac80211/rx.c             |    9 
 net/mac80211/scan.c           |   27 +-
 net/mac80211/sta_info.c       |   14 -
 net/mac80211/tkip.c           |    6 
 net/mac80211/tx.c             |    3 
 net/mac80211/util.c           |    3 
 net/mac80211/wext.c           |    7 
 21 files changed, 727 insertions(+), 126 deletions(-)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/driver-ops.h	2009-03-26 12:23:17.000000000 +0100
@@ -0,0 +1,417 @@
+#ifndef __MAC80211_DRIVER_OPS
+#define __MAC80211_DRIVER_OPS
+
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+
+#ifndef CONFIG_MAC80211_DRIVER_API_DEBUG
+static inline void dbg_start(struct ieee80211_local *local, int ret)
+{
+}
+
+static inline void dbg_stop(struct ieee80211_local *local)
+{
+}
+
+static inline void dbg_add_interface(struct ieee80211_local *local,
+				     struct ieee80211_if_init_conf *conf,
+				     int ret)
+{
+}
+
+static inline void dbg_remove_interface(struct ieee80211_local *local,
+					struct ieee80211_if_init_conf *conf)
+{
+}
+
+static inline void dbg_config(struct ieee80211_local *local, u32 changed,
+			      int ret)
+{
+}
+
+static inline void dbg_config_interface(struct ieee80211_local *local,
+					struct ieee80211_vif *vif,
+					struct ieee80211_if_conf *conf, int ret)
+{
+}
+
+static inline void dbg_bss_info_changed(struct ieee80211_local *local,
+					struct ieee80211_vif *vif,
+					struct ieee80211_bss_conf *info,
+					u32 changed)
+{
+}
+
+static inline void dbg_configure_filter(struct ieee80211_local *local,
+					unsigned int changed_flags,
+					unsigned int *total_flags,
+					int mc_count,
+					struct dev_addr_list *mc_list)
+{
+}
+
+static inline void dbg_set_tim(struct ieee80211_local *local,
+			       struct ieee80211_sta *sta, bool set, int ret)
+{
+}
+
+static inline void dbg_set_key(struct ieee80211_local *local,
+			       enum set_key_cmd cmd, struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       struct ieee80211_key_conf *key, int ret)
+{
+}
+
+static inline void dbg_update_tkip_key(struct ieee80211_local *local,
+				       struct ieee80211_key_conf *conf,
+				       const u8 *address, u32 iv32,
+				       u16 *phase1key)
+{
+}
+
+static inline void dbg_hw_scan(struct ieee80211_local *local,
+			       struct cfg80211_scan_request *req, int ret)
+{
+}
+
+static inline void dbg_sw_scan_start(struct ieee80211_local *local)
+{
+}
+
+static inline void dbg_sw_scan_complete(struct ieee80211_local *local)
+{
+}
+
+static inline void dbg_get_stats(struct ieee80211_local *local,
+				 struct ieee80211_low_level_stats *stats,
+				 int ret)
+{
+}
+
+static inline void dbg_get_tkip_seq(struct ieee80211_local *local,
+				    u8 hw_key_idx, u32 *iv32, u16 *iv16)
+{
+}
+
+static inline void dbg_set_rts_threshold(struct ieee80211_local *local,
+					 u32 value, int ret)
+{
+}
+
+static inline void dbg_sta_notify(struct ieee80211_local *local,
+				  struct ieee80211_vif *vif,
+				  enum sta_notify_cmd cmd,
+				  struct ieee80211_sta *sta)
+{
+}
+
+static inline void dbg_conf_tx(struct ieee80211_local *local, u16 queue,
+			       const struct ieee80211_tx_queue_params *params,
+			       int ret)
+{
+}
+
+static inline void dbg_get_tx_stats(struct ieee80211_local *local,
+				    struct ieee80211_tx_queue_stats *stats,
+				    int ret)
+{
+}
+
+static inline void dbg_get_tsf(struct ieee80211_local *local, u64 ret)
+{
+}
+
+static inline void dbg_set_tsf(struct ieee80211_local *local, u64 tsf)
+{
+}
+
+static inline void dbg_reset_tsf(struct ieee80211_local *local)
+{
+}
+
+static inline void dbg_tx_last_beacon(struct ieee80211_local *local, int ret)
+{
+}
+
+static inline void dbg_ampdu_action(struct ieee80211_local *local,
+				    enum ieee80211_ampdu_mlme_action action,
+				    struct ieee80211_sta *sta, u16 tid,
+				    u16 *ssn, int ret)
+{
+}
+#else
+void dbg_start(struct ieee80211_local *local, int ret);
+void dbg_stop(struct ieee80211_local *local);
+void dbg_add_interface(struct ieee80211_local *local,
+		       struct ieee80211_if_init_conf *conf,
+		       int ret);
+void dbg_remove_interface(struct ieee80211_local *local,
+			  struct ieee80211_if_init_conf *conf);
+void dbg_config(struct ieee80211_local *local, u32 changed, int ret);
+void dbg_config_interface(struct ieee80211_local *local,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_if_conf *conf, int ret);
+void dbg_bss_info_changed(struct ieee80211_local *local,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_bss_conf *info, u32 changed);
+void dbg_configure_filter(struct ieee80211_local *local,
+			  unsigned int changed_flags,
+			  unsigned int *total_flags,
+			  int mc_count, struct dev_addr_list *mc_list);
+void dbg_set_tim(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta, bool set, int ret);
+void dbg_set_key(struct ieee80211_local *local,
+		 enum set_key_cmd cmd, struct ieee80211_vif *vif,
+		 struct ieee80211_sta *sta, struct ieee80211_key_conf *key,
+		 int ret);
+void dbg_update_tkip_key(struct ieee80211_local *local,
+			 struct ieee80211_key_conf *conf, const u8 *address,
+			 u32 iv32, u16 *phase1key);
+void dbg_hw_scan(struct ieee80211_local *local,
+		 struct cfg80211_scan_request *req, int ret);
+void dbg_sw_scan_start(struct ieee80211_local *local);
+void dbg_sw_scan_complete(struct ieee80211_local *local);
+void dbg_get_stats(struct ieee80211_local *local,
+		   struct ieee80211_low_level_stats *stats, int ret);
+void dbg_get_tkip_seq(struct ieee80211_local *local,
+		      u8 hw_key_idx, u32 *iv32, u16 *iv16);
+void dbg_set_rts_threshold(struct ieee80211_local *local, u32 value, int ret);
+void dbg_sta_notify(struct ieee80211_local *local,
+		    struct ieee80211_vif *vif,
+		    enum sta_notify_cmd cmd, struct ieee80211_sta *sta);
+void dbg_conf_tx(struct ieee80211_local *local, u16 queue,
+		 const struct ieee80211_tx_queue_params *params, int ret);
+void dbg_get_tx_stats(struct ieee80211_local *local,
+		      struct ieee80211_tx_queue_stats *stats, int ret);
+void dbg_get_tsf(struct ieee80211_local *local, u64 ret);
+void dbg_set_tsf(struct ieee80211_local *local, u64 tsf);
+void dbg_reset_tsf(struct ieee80211_local *local);
+void dbg_tx_last_beacon(struct ieee80211_local *local, int ret);
+void dbg_ampdu_action(struct ieee80211_local *local,
+		      enum ieee80211_ampdu_mlme_action action,
+		      struct ieee80211_sta *sta, u16 tid, u16 *ssn, int ret);
+#endif
+static inline int drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
+{
+	return local->ops->tx(&local->hw, skb);
+}
+
+static inline int drv_start(struct ieee80211_local *local)
+{
+	int ret = local->ops->start(&local->hw);
+	dbg_start(local, ret);
+	return ret;
+}
+
+static inline void drv_stop(struct ieee80211_local *local)
+{
+	local->ops->stop(&local->hw);
+	dbg_stop(local);
+}
+
+static inline int drv_add_interface(struct ieee80211_local *local,
+				    struct ieee80211_if_init_conf *conf)
+{
+	int ret = local->ops->add_interface(&local->hw, conf);
+	dbg_add_interface(local, conf, ret);
+	return ret;
+}
+
+static inline void drv_remove_interface(struct ieee80211_local *local,
+					struct ieee80211_if_init_conf *conf)
+{
+	local->ops->remove_interface(&local->hw, conf);
+	dbg_remove_interface(local, conf);
+}
+
+static inline int drv_config(struct ieee80211_local *local, u32 changed)
+{
+	int ret = local->ops->config(&local->hw, changed);
+	dbg_config(local, changed, ret);
+	return ret;
+}
+
+static inline int drv_config_interface(struct ieee80211_local *local,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_if_conf *conf)
+{
+	int ret = 0;
+	if (local->ops->config_interface)
+		local->ops->config_interface(&local->hw, vif, conf);
+	dbg_config_interface(local, vif, conf, ret);
+	return ret;
+}
+
+static inline void drv_bss_info_changed(struct ieee80211_local *local,
+					struct ieee80211_vif *vif,
+					struct ieee80211_bss_conf *info,
+					u32 changed)
+{
+	if (local->ops->bss_info_changed)
+		local->ops->bss_info_changed(&local->hw, vif, info, changed);
+	dbg_bss_info_changed(local, vif, info, changed);
+}
+
+static inline void drv_configure_filter(struct ieee80211_local *local,
+					unsigned int changed_flags,
+					unsigned int *total_flags,
+					int mc_count,
+					struct dev_addr_list *mc_list)
+{
+	local->ops->configure_filter(&local->hw, changed_flags, total_flags,
+				     mc_count, mc_list);
+	dbg_configure_filter(local, changed_flags, total_flags,
+			     mc_count, mc_list);
+}
+
+static inline int drv_set_tim(struct ieee80211_local *local,
+			      struct ieee80211_sta *sta, bool set)
+{
+	int ret = 0;
+	if (local->ops->set_tim)
+		ret = local->ops->set_tim(&local->hw, sta, set);
+	dbg_set_tim(local, sta, set, ret);
+	return ret;
+}
+
+static inline int drv_set_key(struct ieee80211_local *local,
+			      enum set_key_cmd cmd, struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct ieee80211_key_conf *key)
+{
+	int ret = local->ops->set_key(&local->hw, cmd, vif, sta, key);
+	dbg_set_key(local, cmd, vif, sta, key, ret);
+	return ret;
+}
+
+static inline void drv_update_tkip_key(struct ieee80211_local *local,
+				       struct ieee80211_key_conf *conf,
+				       const u8 *address, u32 iv32,
+				       u16 *phase1key)
+{
+	if (local->ops->update_tkip_key)
+		local->ops->update_tkip_key(&local->hw, conf, address,
+					    iv32, phase1key);
+	dbg_update_tkip_key(local, conf, address, iv32, phase1key);
+}
+
+static inline int drv_hw_scan(struct ieee80211_local *local,
+			      struct cfg80211_scan_request *req)
+{
+	int ret = local->ops->hw_scan(&local->hw, req);
+	dbg_hw_scan(local, req, ret);
+	return ret;
+}
+
+static inline void drv_sw_scan_start(struct ieee80211_local *local)
+{
+	if (local->ops->sw_scan_start)
+		local->ops->sw_scan_start(&local->hw);
+	dbg_sw_scan_start(local);
+}
+
+static inline void drv_sw_scan_complete(struct ieee80211_local *local)
+{
+	if (local->ops->sw_scan_complete)
+		local->ops->sw_scan_complete(&local->hw);
+	dbg_sw_scan_complete(local);
+}
+
+static inline int drv_get_stats(struct ieee80211_local *local,
+				struct ieee80211_low_level_stats *stats)
+{
+	int ret = local->ops->get_stats(&local->hw, stats);
+	dbg_get_stats(local, stats, ret);
+	return ret;
+}
+
+static inline void drv_get_tkip_seq(struct ieee80211_local *local,
+				    u8 hw_key_idx, u32 *iv32, u16 *iv16)
+{
+	if (local->ops->get_tkip_seq)
+		local->ops->get_tkip_seq(&local->hw, hw_key_idx, iv32, iv16);
+	dbg_get_tkip_seq(local, hw_key_idx, iv32, iv16);
+}
+
+static inline int drv_set_rts_threshold(struct ieee80211_local *local,
+					u32 value)
+{
+	int ret = 0;
+	if (local->ops->set_rts_threshold)
+		local->ops->set_rts_threshold(&local->hw, value);
+	dbg_set_rts_threshold(local, value, ret);
+	return ret;
+}
+
+static inline void drv_sta_notify(struct ieee80211_local *local,
+				  struct ieee80211_vif *vif,
+				  enum sta_notify_cmd cmd,
+				  struct ieee80211_sta *sta)
+{
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(&local->hw, vif, cmd, sta);
+	dbg_sta_notify(local, vif, cmd, sta);
+}
+
+static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
+			      const struct ieee80211_tx_queue_params *params)
+{
+	int ret = -EOPNOTSUPP;
+	if (local->ops->conf_tx)
+		local->ops->conf_tx(&local->hw, queue, params);
+	dbg_conf_tx(local, queue, params, ret);
+	return ret;
+}
+
+static inline int drv_get_tx_stats(struct ieee80211_local *local,
+				   struct ieee80211_tx_queue_stats *stats)
+{
+	int ret = local->ops->get_tx_stats(&local->hw, stats);
+	dbg_get_tx_stats(local, stats, ret);
+	return ret;
+}
+
+static inline u64 drv_get_tsf(struct ieee80211_local *local)
+{
+	u64 ret = -1ULL;
+	if (local->ops->get_tsf)
+		local->ops->get_tsf(&local->hw);
+	dbg_get_tsf(local, ret);
+	return ret;
+}
+
+static inline void drv_set_tsf(struct ieee80211_local *local, u64 tsf)
+{
+	if (local->ops->set_tsf)
+		local->ops->set_tsf(&local->hw, tsf);
+	dbg_set_tsf(local, tsf);
+}
+
+static inline void drv_reset_tsf(struct ieee80211_local *local)
+{
+	if (local->ops->reset_tsf)
+		local->ops->reset_tsf(&local->hw);
+	dbg_reset_tsf(local);
+}
+
+static inline int drv_tx_last_beacon(struct ieee80211_local *local)
+{
+	int ret = 1;
+	if (local->ops->tx_last_beacon)
+		local->ops->tx_last_beacon(&local->hw);
+	dbg_tx_last_beacon(local, ret);
+	return ret;
+}
+
+static inline int drv_ampdu_action(struct ieee80211_local *local,
+				   enum ieee80211_ampdu_mlme_action action,
+				   struct ieee80211_sta *sta, u16 tid,
+				   u16 *ssn)
+{
+	int ret = -EOPNOTSUPP;
+	if (local->ops->ampdu_action)
+		local->ops->ampdu_action(&local->hw, action, sta, tid, ssn);
+	dbg_ampdu_action(local, action, sta, tid, ssn, ret);
+	return ret;
+}
+#endif /* __MAC80211_DRIVER_OPS */
--- wireless-testing.orig/net/mac80211/iface.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-03-26 12:23:17.000000000 +0100
@@ -20,6 +20,7 @@
 #include "debugfs_netdev.h"
 #include "mesh.h"
 #include "led.h"
+#include "driver-ops.h"
 
 /**
  * DOC: Interface list locking
@@ -164,9 +165,7 @@ static int ieee80211_open(struct net_dev
 	}
 
 	if (local->open_count == 0) {
-		res = 0;
-		if (local->ops->start)
-			res = local->ops->start(local_to_hw(local));
+		res = drv_start(local);
 		if (res)
 			goto err_del_bss;
 		/* we're brought up, everything changes */
@@ -199,8 +198,8 @@ static int ieee80211_open(struct net_dev
 	 * Validate the MAC address for this device.
 	 */
 	if (!is_valid_ether_addr(dev->dev_addr)) {
-		if (!local->open_count && local->ops->stop)
-			local->ops->stop(local_to_hw(local));
+		if (!local->open_count)
+			drv_stop(local);
 		return -EADDRNOTAVAIL;
 	}
 
@@ -245,7 +244,7 @@ static int ieee80211_open(struct net_dev
 		conf.vif = &sdata->vif;
 		conf.type = sdata->vif.type;
 		conf.mac_addr = dev->dev_addr;
-		res = local->ops->add_interface(local_to_hw(local), &conf);
+		res = drv_add_interface(local, &conf);
 		if (res)
 			goto err_stop;
 
@@ -332,10 +331,10 @@ static int ieee80211_open(struct net_dev
 
 	return 0;
  err_del_interface:
-	local->ops->remove_interface(local_to_hw(local), &conf);
+	drv_remove_interface(local, &conf);
  err_stop:
-	if (!local->open_count && local->ops->stop)
-		local->ops->stop(local_to_hw(local));
+	if (!local->open_count)
+		drv_stop(local);
  err_del_bss:
 	sdata->bss = NULL;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -549,7 +548,7 @@ static int ieee80211_stop(struct net_dev
 		conf.mac_addr = dev->dev_addr;
 		/* disable all keys for as long as this netdev is down */
 		ieee80211_disable_keys(sdata);
-		local->ops->remove_interface(local_to_hw(local), &conf);
+		drv_remove_interface(local, &conf);
 	}
 
 	sdata->bss = NULL;
@@ -558,8 +557,7 @@ static int ieee80211_stop(struct net_dev
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
 
-		if (local->ops->stop)
-			local->ops->stop(local_to_hw(local));
+		drv_stop(local);
 
 		ieee80211_led_radio(local, 0);
 
--- wireless-testing.orig/net/mac80211/key.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/key.c	2009-03-26 12:23:17.000000000 +0100
@@ -16,6 +16,7 @@
 #include <linux/rtnetlink.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "debugfs_key.h"
 #include "aes_ccm.h"
 #include "aes_cmac.h"
@@ -136,8 +137,7 @@ static void ieee80211_key_enable_hw_acce
 				     struct ieee80211_sub_if_data,
 				     u.ap);
 
-	ret = key->local->ops->set_key(local_to_hw(key->local), SET_KEY,
-				       &sdata->vif, sta, &key->conf);
+	ret = drv_set_key(key->local, SET_KEY, &sdata->vif, sta, &key->conf);
 
 	if (!ret) {
 		spin_lock(&todo_lock);
@@ -179,8 +179,8 @@ static void ieee80211_key_disable_hw_acc
 				     struct ieee80211_sub_if_data,
 				     u.ap);
 
-	ret = key->local->ops->set_key(local_to_hw(key->local), DISABLE_KEY,
-				       &sdata->vif, sta, &key->conf);
+	ret = drv_set_key(key->local, DISABLE_KEY, &sdata->vif,
+			  sta, &key->conf);
 
 	if (ret)
 		printk(KERN_ERR "mac80211-%s: failed to remove key "
--- wireless-testing.orig/net/mac80211/main.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-03-26 12:23:17.000000000 +0100
@@ -25,6 +25,7 @@
 #include <net/cfg80211.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 #include "mesh.h"
 #include "wep.h"
@@ -80,10 +81,9 @@ void ieee80211_configure_filter(struct i
 	/* be a bit nasty */
 	new_flags |= (1<<31);
 
-	local->ops->configure_filter(local_to_hw(local),
-				     changed_flags, &new_flags,
-				     local->mdev->mc_count,
-				     local->mdev->mc_list);
+	drv_configure_filter(local, changed_flags, &new_flags,
+			     local->mdev->mc_count,
+			     local->mdev->mc_list);
 
 	WARN_ON(new_flags & (1<<31));
 
@@ -223,8 +223,7 @@ int ieee80211_if_config(struct ieee80211
 
 	conf.changed = changed;
 
-	return local->ops->config_interface(local_to_hw(local),
-					    &sdata->vif, &conf);
+	return drv_config_interface(local, &sdata->vif, &conf);
 }
 
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
@@ -267,7 +266,7 @@ int ieee80211_hw_config(struct ieee80211
 	}
 
 	if (changed && local->open_count) {
-		ret = local->ops->config(local_to_hw(local), changed);
+		ret = drv_config(local, changed);
 		/*
 		 * Goal:
 		 * HW reconfiguration should never fail, the driver has told
@@ -299,11 +298,8 @@ void ieee80211_bss_info_change_notify(st
 	if (!changed)
 		return;
 
-	if (local->ops->bss_info_changed)
-		local->ops->bss_info_changed(local_to_hw(local),
-					     &sdata->vif,
-					     &sdata->vif.bss_conf,
-					     changed);
+	drv_bss_info_changed(local, &sdata->vif,
+			     &sdata->vif.bss_conf, changed);
 }
 
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/mlme.c	2009-03-26 12:22:35.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-03-26 12:23:17.000000000 +0100
@@ -21,6 +21,7 @@
 #include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 #include "led.h"
 
@@ -369,6 +370,9 @@ static void ieee80211_sta_wmm_params(str
 	int count;
 	u8 *pos;
 
+	if (!local->ops->conf_tx)
+		return;
+
 	if (!(ifmgd->flags & IEEE80211_STA_WMM_ENABLED))
 		return;
 
@@ -427,11 +431,10 @@ static void ieee80211_sta_wmm_params(str
 		       local->mdev->name, queue, aci, acm, params.aifs, params.cw_min,
 		       params.cw_max, params.txop);
 #endif
-		if (local->ops->conf_tx &&
-		    local->ops->conf_tx(local_to_hw(local), queue, &params)) {
+		if (drv_conf_tx(local, queue, &params))
 			printk(KERN_DEBUG "%s: failed to set TX queue "
-			       "parameters for queue %d\n", local->mdev->name, queue);
-		}
+			       "parameters for queue %d\n", local->mdev->name,
+			       queue);
 	}
 }
 
@@ -1712,10 +1715,8 @@ static void ieee80211_sta_reset_auth(str
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
-	if (local->ops->reset_tsf) {
-		/* Reset own TSF to allow time synchronization work. */
-		local->ops->reset_tsf(local_to_hw(local));
-	}
+	/* Reset own TSF to allow time synchronization work. */
+	drv_reset_tsf(local);
 
 	ifmgd->wmm_last_param_set = -1; /* allow any WMM update */
 
--- wireless-testing.orig/net/mac80211/pm.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/pm.c	2009-03-26 12:23:17.000000000 +0100
@@ -2,6 +2,7 @@
 #include <net/rtnetlink.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "led.h"
 
 int __ieee80211_suspend(struct ieee80211_hw *hw)
@@ -43,8 +44,8 @@ int __ieee80211_suspend(struct ieee80211
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-			local->ops->sta_notify(hw, &sdata->vif,
-				STA_NOTIFY_REMOVE, &sta->sta);
+			drv_sta_notify(local, &sdata->vif, STA_NOTIFY_REMOVE,
+				       &sta->sta);
 		}
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 	}
@@ -57,7 +58,7 @@ int __ieee80211_suspend(struct ieee80211
 			conf.vif = &sdata->vif;
 			conf.type = sdata->vif.type;
 			conf.mac_addr = sdata->dev->dev_addr;
-			local->ops->remove_interface(hw, &conf);
+			drv_remove_interface(local, &conf);
 		}
 	}
 
@@ -67,7 +68,7 @@ int __ieee80211_suspend(struct ieee80211
 	/* stop hardware */
 	if (local->open_count) {
 		ieee80211_led_radio(local, false);
-		local->ops->stop(hw);
+		drv_stop(local);
 	}
 	return 0;
 }
@@ -83,7 +84,7 @@ int __ieee80211_resume(struct ieee80211_
 
 	/* restart hardware */
 	if (local->open_count) {
-		res = local->ops->start(hw);
+		res = drv_start(local);
 
 		ieee80211_led_radio(local, hw->conf.radio_enabled);
 	}
@@ -96,7 +97,7 @@ int __ieee80211_resume(struct ieee80211_
 			conf.vif = &sdata->vif;
 			conf.type = sdata->vif.type;
 			conf.mac_addr = sdata->dev->dev_addr;
-			res = local->ops->add_interface(hw, &conf);
+			res = drv_add_interface(local, &conf);
 		}
 	}
 
@@ -109,8 +110,8 @@ int __ieee80211_resume(struct ieee80211_
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-			local->ops->sta_notify(hw, &sdata->vif,
-				STA_NOTIFY_ADD, &sta->sta);
+			drv_sta_notify(local, &sdata->vif, STA_NOTIFY_ADD,
+				       &sta->sta);
 		}
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 	}
@@ -133,8 +134,7 @@ int __ieee80211_resume(struct ieee80211_
 			ieee80211_enable_keys(sdata);
 
 	/* setup RTS threshold */
-	if (local->ops->set_rts_threshold)
-		local->ops->set_rts_threshold(hw, local->rts_threshold);
+	drv_set_rts_threshold(local, local->rts_threshold);
 
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
--- wireless-testing.orig/net/mac80211/rx.c	2009-03-26 12:22:35.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-03-26 12:23:17.000000000 +0100
@@ -19,6 +19,7 @@
 #include <net/ieee80211_radiotap.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "led.h"
 #include "mesh.h"
 #include "wep.h"
@@ -772,9 +773,7 @@ static void ap_sta_ps_start(struct sta_i
 
 	atomic_inc(&sdata->bss->num_sta_ps);
 	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
-	if (local->ops->sta_notify)
-		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-					STA_NOTIFY_SLEEP, &sta->sta);
+	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d enters power save mode\n",
 	       sdata->dev->name, sta->sta.addr, sta->sta.aid);
@@ -791,9 +790,7 @@ static int ap_sta_ps_end(struct sta_info
 	atomic_dec(&sdata->bss->num_sta_ps);
 
 	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
-	if (local->ops->sta_notify)
-		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-					STA_NOTIFY_AWAKE, &sta->sta);
+	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
--- wireless-testing.orig/net/mac80211/scan.c	2009-03-26 12:22:35.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-03-26 12:23:17.000000000 +0100
@@ -21,6 +21,7 @@
 #include <net/iw_handler.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "mesh.h"
 
 #define IEEE80211_PROBE_DELAY (HZ / 33)
@@ -308,17 +309,15 @@ void ieee80211_scan_completed(struct iee
 	netif_tx_lock_bh(local->mdev);
 	netif_addr_lock(local->mdev);
 	local->filter_flags &= ~FIF_BCN_PRBRESP_PROMISC;
-	local->ops->configure_filter(local_to_hw(local),
-				     FIF_BCN_PRBRESP_PROMISC,
-				     &local->filter_flags,
-				     local->mdev->mc_count,
-				     local->mdev->mc_list);
+	drv_configure_filter(local, FIF_BCN_PRBRESP_PROMISC,
+			     &local->filter_flags,
+			     local->mdev->mc_count,
+			     local->mdev->mc_list);
 
 	netif_addr_unlock(local->mdev);
 	netif_tx_unlock_bh(local->mdev);
 
-	if (local->ops->sw_scan_complete)
-		local->ops->sw_scan_complete(local_to_hw(local));
+	drv_sw_scan_complete(local);
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -460,7 +459,7 @@ int ieee80211_start_scan(struct ieee8021
 		int rc;
 
 		local->hw_scanning = true;
-		rc = local->ops->hw_scan(local_to_hw(local), req);
+		rc = drv_hw_scan(local, req);
 		if (rc) {
 			local->hw_scanning = false;
 			return rc;
@@ -483,8 +482,7 @@ int ieee80211_start_scan(struct ieee8021
 	 * ieee80211_tx_h_check_assoc().
 	 */
 	local->sw_scanning = true;
-	if (local->ops->sw_scan_start)
-		local->ops->sw_scan_start(local_to_hw(local));
+	drv_sw_scan_start(local);
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -515,11 +513,10 @@ int ieee80211_start_scan(struct ieee8021
 
 	netif_addr_lock_bh(local->mdev);
 	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
-	local->ops->configure_filter(local_to_hw(local),
-				     FIF_BCN_PRBRESP_PROMISC,
-				     &local->filter_flags,
-				     local->mdev->mc_count,
-				     local->mdev->mc_list);
+	drv_configure_filter(local, FIF_BCN_PRBRESP_PROMISC,
+			     &local->filter_flags,
+			     local->mdev->mc_count,
+			     local->mdev->mc_list);
 	netif_addr_unlock_bh(local->mdev);
 
 	/* TODO: start scan as soon as all nullfunc frames are ACKed */
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-03-26 12:23:17.000000000 +0100
@@ -19,6 +19,7 @@
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 #include "sta_info.h"
 #include "debugfs_sta.h"
@@ -346,8 +347,7 @@ int sta_info_insert(struct sta_info *sta
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-				       STA_NOTIFY_ADD, &sta->sta);
+		drv_sta_notify(local, &sdata->vif, STA_NOTIFY_ADD, &sta->sta);
 	}
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -405,8 +405,7 @@ static void __sta_info_set_tim_bit(struc
 
 	if (sta->local->ops->set_tim) {
 		sta->local->tim_in_locked_section = true;
-		sta->local->ops->set_tim(local_to_hw(sta->local),
-					 &sta->sta, true);
+		drv_set_tim(sta->local, &sta->sta, true);
 		sta->local->tim_in_locked_section = false;
 	}
 }
@@ -431,8 +430,7 @@ static void __sta_info_clear_tim_bit(str
 
 	if (sta->local->ops->set_tim) {
 		sta->local->tim_in_locked_section = true;
-		sta->local->ops->set_tim(local_to_hw(sta->local),
-					 &sta->sta, false);
+		drv_set_tim(sta->local, &sta->sta, false);
 		sta->local->tim_in_locked_section = false;
 	}
 }
@@ -482,8 +480,8 @@ static void __sta_info_unlink(struct sta
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-				       STA_NOTIFY_REMOVE, &(*sta)->sta);
+		drv_sta_notify(local, &sdata->vif, STA_NOTIFY_REMOVE,
+			       &(*sta)->sta);
 	}
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
--- wireless-testing.orig/net/mac80211/tkip.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/tkip.c	2009-03-26 12:23:17.000000000 +0100
@@ -13,6 +13,7 @@
 #include <asm/unaligned.h>
 
 #include <net/mac80211.h>
+#include "driver-ops.h"
 #include "key.h"
 #include "tkip.h"
 #include "wep.h"
@@ -307,9 +308,8 @@ int ieee80211_tkip_decrypt_data(struct c
 			if (is_multicast_ether_addr(ra))
 				sta_addr = bcast;
 
-			key->local->ops->update_tkip_key(
-				local_to_hw(key->local), &key->conf,
-				sta_addr, iv32, key->u.tkip.rx[queue].p1k);
+			drv_update_tkip_key(key->local, &key->conf, sta_addr,
+					    iv32, key->u.tkip.rx[queue].p1k);
 		}
 	}
 
--- wireless-testing.orig/net/mac80211/tx.c	2009-03-26 12:22:35.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-03-26 12:23:17.000000000 +0100
@@ -25,6 +25,7 @@
 #include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "led.h"
 #include "mesh.h"
 #include "wep.h"
@@ -1147,7 +1148,7 @@ static int __ieee80211_tx(struct ieee802
 
 		next = skb->next;
 		len = skb->len;
-		ret = local->ops->tx(local_to_hw(local), skb);
+		ret = drv_tx(local, skb);
 		if (WARN_ON(ret != NETDEV_TX_OK && skb->len != len)) {
 			dev_kfree_skb(skb);
 			ret = NETDEV_TX_OK;
--- wireless-testing.orig/net/mac80211/util.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-03-26 12:23:17.000000000 +0100
@@ -25,6 +25,7 @@
 #include <net/rtnetlink.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 #include "mesh.h"
 #include "wme.h"
@@ -704,7 +705,7 @@ void ieee80211_set_wmm_default(struct ie
 	qparam.txop = 0;
 
 	for (i = 0; i < local_to_hw(local)->queues; i++)
-		local->ops->conf_tx(local_to_hw(local), i, &qparam);
+		drv_conf_tx(local, i, &qparam);
 }
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/wext.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-03-26 12:23:17.000000000 +0100
@@ -21,6 +21,7 @@
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "led.h"
 #include "rate.h"
 #include "wpa.h"
@@ -481,11 +482,7 @@ static int ieee80211_ioctl_siwrts(struct
 	/* If the wlan card performs RTS/CTS in hardware/firmware,
 	 * configure it here */
 
-	if (local->ops->set_rts_threshold)
-		local->ops->set_rts_threshold(local_to_hw(local),
-					     local->rts_threshold);
-
-	return 0;
+	return drv_set_rts_threshold(local, local->rts_threshold);
 }
 
 static int ieee80211_ioctl_giwrts(struct net_device *dev,
--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-03-26 12:22:35.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-03-26 12:23:17.000000000 +0100
@@ -16,12 +16,12 @@
 #include <linux/ieee80211.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				    u16 initiator, u16 reason)
 {
 	struct ieee80211_local *local = sta->local;
-	struct ieee80211_hw *hw = &local->hw;
 	int i;
 
 	/* check if TID is in operational state */
@@ -41,8 +41,8 @@ void __ieee80211_stop_rx_ba_session(stru
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	if (local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
-				     &sta->sta, tid, NULL))
+	if (drv_ampdu_action(local, IEEE80211_AMPDU_RX_STOP,
+			     &sta->sta, tid, NULL))
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
 
@@ -278,9 +278,8 @@ void ieee80211_process_addba_request(str
 		goto end;
 	}
 
-	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
-					       &sta->sta, tid, &start_seq_num);
+	ret = drv_ampdu_action(local, IEEE80211_AMPDU_RX_START,
+			       &sta->sta, tid, &start_seq_num);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-03-26 12:23:17.000000000 +0100
@@ -16,6 +16,7 @@
 #include <linux/ieee80211.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "wme.h"
 
 /**
@@ -134,8 +135,8 @@ static int ___ieee80211_stop_tx_ba_sessi
 	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
 
-	ret = local->ops->ampdu_action(&local->hw, IEEE80211_AMPDU_TX_STOP,
-				       &sta->sta, tid, NULL);
+	ret = drv_ampdu_action(local, IEEE80211_AMPDU_TX_STOP,
+			       &sta->sta, tid, NULL);
 
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
@@ -306,8 +307,8 @@ int ieee80211_start_tx_ba_session(struct
 
 	start_seq_num = sta->tid_seq[tid];
 
-	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
-				       &sta->sta, tid, &start_seq_num);
+	ret = drv_ampdu_action(local, IEEE80211_AMPDU_TX_START,
+			       &sta->sta, tid, &start_seq_num);
 
 	if (ret) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -418,8 +419,8 @@ static void ieee80211_agg_tx_operational
 	ieee80211_agg_splice_finish(local, sta, tid);
 	spin_unlock(&local->ampdu_lock);
 
-	local->ops->ampdu_action(&local->hw, IEEE80211_AMPDU_TX_OPERATIONAL,
-				 &sta->sta, tid, NULL);
+	drv_ampdu_action(local, IEEE80211_AMPDU_TX_OPERATIONAL,
+			 &sta->sta, tid, NULL);
 }
 
 void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid)
--- wireless-testing.orig/net/mac80211/cfg.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-03-26 12:23:17.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/rcupdate.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "cfg.h"
 #include "rate.h"
 #include "mesh.h"
@@ -245,12 +246,10 @@ static int ieee80211_get_key(struct wiph
 		iv32 = key->u.tkip.tx.iv32;
 		iv16 = key->u.tkip.tx.iv16;
 
-		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
-		    sdata->local->ops->get_tkip_seq)
-			sdata->local->ops->get_tkip_seq(
-				local_to_hw(sdata->local),
-				key->conf.hw_key_idx,
-				&iv32, &iv16);
+		if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+			drv_get_tkip_seq(sdata->local,
+					 key->conf.hw_key_idx,
+					 &iv32, &iv16);
 
 		seq[0] = iv16 & 0xff;
 		seq[1] = (iv16 >> 8) & 0xff;
@@ -1120,7 +1119,7 @@ static int ieee80211_set_txq_params(stru
 	p.cw_max = params->cwmax;
 	p.cw_min = params->cwmin;
 	p.txop = params->txop;
-	if (local->ops->conf_tx(local_to_hw(local), params->queue, &p)) {
+	if (drv_conf_tx(local, params->queue, &p)) {
 		printk(KERN_DEBUG "%s: failed to set TX queue "
 		       "parameters for queue %d\n", local->mdev->name,
 		       params->queue);
--- wireless-testing.orig/net/mac80211/debugfs.c	2009-03-26 12:22:35.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs.c	2009-03-26 12:23:17.000000000 +0100
@@ -10,6 +10,7 @@
 #include <linux/debugfs.h>
 #include <linux/rtnetlink.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 #include "debugfs.h"
 
@@ -70,11 +71,10 @@ static ssize_t tsf_read(struct file *fil
 			     size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
-	u64 tsf = 0;
+	u64 tsf;
 	char buf[100];
 
-	if (local->ops->get_tsf)
-		tsf = local->ops->get_tsf(local_to_hw(local));
+	tsf = drv_get_tsf(local);
 
 	snprintf(buf, sizeof(buf), "0x%016llx\n", (unsigned long long) tsf);
 
@@ -97,13 +97,13 @@ static ssize_t tsf_write(struct file *fi
 
 	if (strncmp(buf, "reset", 5) == 0) {
 		if (local->ops->reset_tsf) {
-			local->ops->reset_tsf(local_to_hw(local));
+			drv_reset_tsf(local);
 			printk(KERN_INFO "%s: debugfs reset TSF\n", wiphy_name(local->hw.wiphy));
 		}
 	} else {
 		tsf = simple_strtoul(buf, NULL, 0);
 		if (local->ops->set_tsf) {
-			local->ops->set_tsf(local_to_hw(local), tsf);
+			drv_set_tsf(local, tsf);
 			printk(KERN_INFO "%s: debugfs set TSF to %#018llx\n", wiphy_name(local->hw.wiphy), tsf);
 		}
 	}
@@ -154,10 +154,11 @@ static ssize_t format_devstat_counter(st
 		return -EOPNOTSUPP;
 
 	rtnl_lock();
-	res = local->ops->get_stats(local_to_hw(local), &stats);
+	res = drv_get_stats(local, &stats);
 	rtnl_unlock();
-	if (!res)
-		res = printvalue(&stats, buf, sizeof(buf));
+	if (res)
+		return res;
+	res = printvalue(&stats, buf, sizeof(buf));
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 
--- wireless-testing.orig/net/mac80211/ibss.c	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2009-03-26 12:23:17.000000000 +0100
@@ -22,6 +22,7 @@
 #include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
@@ -75,10 +76,9 @@ static int __ieee80211_sta_join_ibss(str
 	struct ieee80211_supported_band *sband;
 	union iwreq_data wrqu;
 
-	if (local->ops->reset_tsf) {
-		/* Reset own TSF to allow time synchronization work. */
-		local->ops->reset_tsf(local_to_hw(local));
-	}
+
+	/* Reset own TSF to allow time synchronization work. */
+	drv_reset_tsf(local);
 
 	if ((ifibss->flags & IEEE80211_IBSS_PREV_BSSID_SET) &&
 	   memcmp(ifibss->bssid, bssid, ETH_ALEN) == 0)
@@ -322,12 +322,13 @@ static void ieee80211_rx_bss_info(struct
 				bitrates[rx_status->rate_idx].bitrate;
 
 		rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);
-	} else if (local && local->ops && local->ops->get_tsf)
-		/* second best option: get current TSF */
-		rx_timestamp = local->ops->get_tsf(local_to_hw(local));
-	else
-		/* can't merge without knowing the TSF */
-		rx_timestamp = -1LLU;
+	} else {
+		/*
+		 * second best option: get current TSF
+		 * (will return -1 if not supported)
+		 */
+		rx_timestamp = drv_get_tsf(local);
+	}
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "RX beacon SA=%pM BSSID="
@@ -617,10 +618,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	    len < 24 + 2 || !ifibss->probe_resp)
 		return;
 
-	if (local->ops->tx_last_beacon)
-		tx_last_beacon = local->ops->tx_last_beacon(local_to_hw(local));
-	else
-		tx_last_beacon = 1;
+	tx_last_beacon = drv_tx_last_beacon(local);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: RX ProbeReq SA=%pM DA=%pM BSSID=%pM"
--- wireless-testing.orig/net/mac80211/Kconfig	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/Kconfig	2009-03-26 12:26:20.000000000 +0100
@@ -209,3 +209,12 @@ config MAC80211_VERBOSE_SPECT_MGMT_DEBUG
 	---help---
 	  Say Y here to print out verbose Spectrum Management (IEEE 802.11h)
 	  debug messages.
+
+config MAC80211_DRIVER_API_DEBUG
+	bool "Verbose driver call debugging"
+	depends on MAC80211_DEBUG_MENU
+	help
+	  Say Y here to print out verbose driver API messages, for all
+	  driver method calls. This generates a lot of output!
+
+	  If unsure, say N.
--- wireless-testing.orig/net/mac80211/Makefile	2009-03-26 12:22:36.000000000 +0100
+++ wireless-testing/net/mac80211/Makefile	2009-03-26 12:23:17.000000000 +0100
@@ -40,6 +40,7 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh_hwmp.o
 
 mac80211-$(CONFIG_PM) += pm.o
+mac80211-$(CONFIG_MAC80211_DRIVER_API_DEBUG) += driver-ops-dbg.o
 
 # objects for PID algorithm
 rc80211_pid-y := rc80211_pid_algo.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/driver-ops-dbg.c	2009-03-26 12:23:17.000000000 +0100
@@ -0,0 +1,190 @@
+/*
+ * mac80211 driver op debug
+ *
+ * Copyright 2009 Johannes Berg <johannes@sipsolutions.net>
+ *
+ * GPLv2, cf. COPYING.
+ */
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+#include "driver-ops.h"
+
+void dbg_start(struct ieee80211_local *local, int ret)
+{
+	printk(KERN_DEBUG "%s: start() = %d\n",
+	       wiphy_name(local->hw.wiphy), ret);
+}
+
+void dbg_stop(struct ieee80211_local *local)
+{
+	printk(KERN_DEBUG "%s: stop()\n",
+	       wiphy_name(local->hw.wiphy));
+}
+
+void dbg_add_interface(struct ieee80211_local *local,
+		       struct ieee80211_if_init_conf *conf, int ret)
+{
+	printk(KERN_DEBUG "%s: add_interface({vif:%p, %d, %pM}) = %d\n",
+	       wiphy_name(local->hw.wiphy),
+	       conf->vif, conf->type, conf->mac_addr, ret);
+}
+
+void dbg_remove_interface(struct ieee80211_local *local,
+			  struct ieee80211_if_init_conf *conf)
+{
+	printk(KERN_DEBUG "%s: remove_interface({vif:%p, %d, %pM})\n",
+	       wiphy_name(local->hw.wiphy),
+	       conf->vif, conf->type, conf->mac_addr);
+}
+
+void dbg_config(struct ieee80211_local *local, u32 changed, int ret)
+{
+	printk(KERN_DEBUG "%s: config(%#x) = %d\n",
+	       wiphy_name(local->hw.wiphy), changed, ret);
+}
+
+void dbg_config_interface(struct ieee80211_local *local,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_if_conf *conf, int ret)
+{
+	printk(KERN_DEBUG "%s: config_interface(vif:%p, {%#x, %pM, %d}) = %d\n",
+	       wiphy_name(local->hw.wiphy), vif, conf->changed, conf->bssid,
+	       conf->enable_beacon, ret);
+}
+
+void dbg_bss_info_changed(struct ieee80211_local *local,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_bss_conf *info, u32 changed)
+{
+	printk(KERN_DEBUG "%s: bss_info_changed(vif:%p, {assoc:%d, aid:%d}, %#x)\n",
+	       wiphy_name(local->hw.wiphy), vif, info->assoc, info->aid,
+	       changed);
+}
+
+void dbg_configure_filter(struct ieee80211_local *local,
+			  unsigned int changed_flags,
+			  unsigned int *total_flags,
+			  int mc_count, struct dev_addr_list *mc_list)
+{
+	printk(KERN_DEBUG "%s: configure_filter(%#x, %#x, %d)\n",
+	       wiphy_name(local->hw.wiphy),
+	       changed_flags, *total_flags, mc_count);
+}
+
+void dbg_set_tim(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta, bool set, int ret)
+{
+	printk(KERN_DEBUG "%s: set_tim(%pM=%d) = %d\n",
+	       wiphy_name(local->hw.wiphy), sta->addr, set, ret);
+}
+
+void dbg_set_key(struct ieee80211_local *local,
+		 enum set_key_cmd cmd, struct ieee80211_vif *vif,
+		 struct ieee80211_sta *sta,
+		 struct ieee80211_key_conf *key, int ret)
+{
+	printk(KERN_DEBUG "%s: set_key(%d, vif:%p, %pM, alg:%d) = %d\n",
+	       wiphy_name(local->hw.wiphy), cmd, vif, sta ? sta->addr : NULL,
+	       key->alg, ret);
+}
+
+void dbg_update_tkip_key(struct ieee80211_local *local,
+			 struct ieee80211_key_conf *conf,
+			 const u8 *address, u32 iv32, u16 *phase1key)
+{
+	printk(KERN_DEBUG "%s: update_tkip_key(...)\n",
+	       wiphy_name(local->hw.wiphy));
+}
+
+void dbg_hw_scan(struct ieee80211_local *local,
+		 struct cfg80211_scan_request *req, int ret)
+{
+	printk(KERN_DEBUG "%s: hw_scan(...) = %d\n",
+	       wiphy_name(local->hw.wiphy), ret);
+}
+
+void dbg_sw_scan_start(struct ieee80211_local *local)
+{
+	printk(KERN_DEBUG "%s: sw_scan_start()\n",
+	       wiphy_name(local->hw.wiphy));
+}
+
+void dbg_sw_scan_complete(struct ieee80211_local *local)
+{
+	printk(KERN_DEBUG "%s: sw_scan_complete()\n",
+	       wiphy_name(local->hw.wiphy));
+}
+
+void dbg_get_stats(struct ieee80211_local *local,
+		   struct ieee80211_low_level_stats *stats, int ret)
+{
+	printk(KERN_DEBUG "%s: get_stats() = %d\n",
+	       wiphy_name(local->hw.wiphy), ret);
+}
+
+void dbg_get_tkip_seq(struct ieee80211_local *local,
+		      u8 hw_key_idx, u32 *iv32, u16 *iv16)
+{
+	printk(KERN_DEBUG "%s: get_tkip_seq(...)\n",
+	       wiphy_name(local->hw.wiphy));
+}
+
+void dbg_set_rts_threshold(struct ieee80211_local *local, u32 value, int ret)
+{
+	printk(KERN_DEBUG "%s: set_rts_threshold(%d) = %d\n",
+	       wiphy_name(local->hw.wiphy), value, ret);
+}
+
+void dbg_sta_notify(struct ieee80211_local *local,
+		    struct ieee80211_vif *vif,
+		    enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
+{
+	printk(KERN_DEBUG "%s: sta_notify(vif:%p, %d, %pM)\n",
+	       wiphy_name(local->hw.wiphy), vif, cmd, sta->addr);
+}
+
+void dbg_conf_tx(struct ieee80211_local *local, u16 queue,
+		 const struct ieee80211_tx_queue_params *params, int ret)
+{
+	printk(KERN_DEBUG "%s: conf_tx(...) = %d\n",
+	       wiphy_name(local->hw.wiphy), ret);
+}
+
+void dbg_get_tx_stats(struct ieee80211_local *local,
+		      struct ieee80211_tx_queue_stats *stats, int ret)
+{
+	printk(KERN_DEBUG "%s: get_tx_stats(...) = %d\n",
+	       wiphy_name(local->hw.wiphy), ret);
+}
+
+void dbg_get_tsf(struct ieee80211_local *local, u64 ret)
+{
+	printk(KERN_DEBUG "%s: get_tsf() = %llu\n",
+	       wiphy_name(local->hw.wiphy), (unsigned long long)ret);
+}
+
+void dbg_set_tsf(struct ieee80211_local *local, u64 tsf)
+{
+	printk(KERN_DEBUG "%s: set_tsf()\n",
+	       wiphy_name(local->hw.wiphy));
+}
+
+void dbg_reset_tsf(struct ieee80211_local *local)
+{
+	printk(KERN_DEBUG "%s: reset_tsf()\n",
+	       wiphy_name(local->hw.wiphy));
+}
+
+void dbg_tx_last_beacon(struct ieee80211_local *local, int ret)
+{
+	printk(KERN_DEBUG "%s: tx_last_beacon() = %d\n",
+	       wiphy_name(local->hw.wiphy), ret);
+}
+
+void dbg_ampdu_action(struct ieee80211_local *local,
+		      enum ieee80211_ampdu_mlme_action action,
+		      struct ieee80211_sta *sta, u16 tid, u16 *ssn, int ret)
+{
+	printk(KERN_DEBUG "%s: ampdu_action(%d, %pM, %d, %d) = %d\n",
+	       wiphy_name(local->hw.wiphy), action, sta->addr, tid, *ssn, ret);
+}


