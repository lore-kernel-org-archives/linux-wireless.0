Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZDWQx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 12:53:28 -0400
Subject: [PATCH] mac80211: add driver ops wrappers
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 18:52:52 +0200
Message-Id: <1240505572.30082.233.camel@johannes.local> (sfid-20090423_185334_663207_775F6FAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to later add tracing or verifications to the driver
calls mac80211 makes, this patch adds static inline wrappers
for all operations.

All calls are now written as

	drv_<op>(local, ...);

instead of

	local->ops-><op>(&local->hw, ...);

Where necessary, the wrappers also do existence checking and
return default values as appropriate.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c     |   11 +-
 net/mac80211/agg-tx.c     |   13 +--
 net/mac80211/cfg.c        |   24 ++----
 net/mac80211/debugfs.c    |   20 ++---
 net/mac80211/driver-ops.h |  184 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ibss.c       |   26 +++---
 net/mac80211/iface.c      |   22 ++---
 net/mac80211/key.c        |    8 +-
 net/mac80211/main.c       |   17 +---
 net/mac80211/mlme.c       |   14 +--
 net/mac80211/pm.c         |    9 +-
 net/mac80211/rx.c         |    9 --
 net/mac80211/scan.c       |   28 +++----
 net/mac80211/sta_info.c   |   14 +--
 net/mac80211/tkip.c       |    6 -
 net/mac80211/tx.c         |    3 
 net/mac80211/util.c       |   14 +--
 17 files changed, 292 insertions(+), 130 deletions(-)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/driver-ops.h	2009-04-23 18:50:44.000000000 +0200
@@ -0,0 +1,184 @@
+#ifndef __MAC80211_DRIVER_OPS
+#define __MAC80211_DRIVER_OPS
+
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+
+static inline int drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
+{
+	return local->ops->tx(&local->hw, skb);
+}
+
+static inline int drv_start(struct ieee80211_local *local)
+{
+	return local->ops->start(&local->hw);
+}
+
+static inline void drv_stop(struct ieee80211_local *local)
+{
+	local->ops->stop(&local->hw);
+}
+
+static inline int drv_add_interface(struct ieee80211_local *local,
+				    struct ieee80211_if_init_conf *conf)
+{
+	return local->ops->add_interface(&local->hw, conf);
+}
+
+static inline void drv_remove_interface(struct ieee80211_local *local,
+					struct ieee80211_if_init_conf *conf)
+{
+	local->ops->remove_interface(&local->hw, conf);
+}
+
+static inline int drv_config(struct ieee80211_local *local, u32 changed)
+{
+	return local->ops->config(&local->hw, changed);
+}
+
+static inline void drv_bss_info_changed(struct ieee80211_local *local,
+					struct ieee80211_vif *vif,
+					struct ieee80211_bss_conf *info,
+					u32 changed)
+{
+	if (local->ops->bss_info_changed)
+		local->ops->bss_info_changed(&local->hw, vif, info, changed);
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
+}
+
+static inline int drv_set_tim(struct ieee80211_local *local,
+			      struct ieee80211_sta *sta, bool set)
+{
+	if (local->ops->set_tim)
+		return local->ops->set_tim(&local->hw, sta, set);
+	return 0;
+}
+
+static inline int drv_set_key(struct ieee80211_local *local,
+			      enum set_key_cmd cmd, struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct ieee80211_key_conf *key)
+{
+	return local->ops->set_key(&local->hw, cmd, vif, sta, key);
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
+}
+
+static inline int drv_hw_scan(struct ieee80211_local *local,
+			      struct cfg80211_scan_request *req)
+{
+	return local->ops->hw_scan(&local->hw, req);
+}
+
+static inline void drv_sw_scan_start(struct ieee80211_local *local)
+{
+	if (local->ops->sw_scan_start)
+		local->ops->sw_scan_start(&local->hw);
+}
+
+static inline void drv_sw_scan_complete(struct ieee80211_local *local)
+{
+	if (local->ops->sw_scan_complete)
+		local->ops->sw_scan_complete(&local->hw);
+}
+
+static inline int drv_get_stats(struct ieee80211_local *local,
+				struct ieee80211_low_level_stats *stats)
+{
+	if (!local->ops->get_stats)
+		return -EOPNOTSUPP;
+	return local->ops->get_stats(&local->hw, stats);
+}
+
+static inline void drv_get_tkip_seq(struct ieee80211_local *local,
+				    u8 hw_key_idx, u32 *iv32, u16 *iv16)
+{
+	if (local->ops->get_tkip_seq)
+		local->ops->get_tkip_seq(&local->hw, hw_key_idx, iv32, iv16);
+}
+
+static inline int drv_set_rts_threshold(struct ieee80211_local *local,
+					u32 value)
+{
+	if (local->ops->set_rts_threshold)
+		return local->ops->set_rts_threshold(&local->hw, value);
+	return 0;
+}
+
+static inline void drv_sta_notify(struct ieee80211_local *local,
+				  struct ieee80211_vif *vif,
+				  enum sta_notify_cmd cmd,
+				  struct ieee80211_sta *sta)
+{
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(&local->hw, vif, cmd, sta);
+}
+
+static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
+			      const struct ieee80211_tx_queue_params *params)
+{
+	if (local->ops->conf_tx)
+		return local->ops->conf_tx(&local->hw, queue, params);
+	return -EOPNOTSUPP;
+}
+
+static inline int drv_get_tx_stats(struct ieee80211_local *local,
+				   struct ieee80211_tx_queue_stats *stats)
+{
+	return local->ops->get_tx_stats(&local->hw, stats);
+}
+
+static inline u64 drv_get_tsf(struct ieee80211_local *local)
+{
+	if (local->ops->get_tsf)
+		return local->ops->get_tsf(&local->hw);
+	return -1ULL;
+}
+
+static inline void drv_set_tsf(struct ieee80211_local *local, u64 tsf)
+{
+	if (local->ops->set_tsf)
+		local->ops->set_tsf(&local->hw, tsf);
+}
+
+static inline void drv_reset_tsf(struct ieee80211_local *local)
+{
+	if (local->ops->reset_tsf)
+		local->ops->reset_tsf(&local->hw);
+}
+
+static inline int drv_tx_last_beacon(struct ieee80211_local *local)
+{
+	if (local->ops->tx_last_beacon)
+		return local->ops->tx_last_beacon(&local->hw);
+	return 1;
+}
+
+static inline int drv_ampdu_action(struct ieee80211_local *local,
+				   enum ieee80211_ampdu_mlme_action action,
+				   struct ieee80211_sta *sta, u16 tid,
+				   u16 *ssn)
+{
+	if (local->ops->ampdu_action)
+		return local->ops->ampdu_action(&local->hw, action,
+						sta, tid, ssn);
+	return -EOPNOTSUPP;
+}
+#endif /* __MAC80211_DRIVER_OPS */
--- wireless-testing.orig/net/mac80211/iface.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-04-23 18:03:10.000000000 +0200
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
 
@@ -241,7 +240,7 @@ static int ieee80211_open(struct net_dev
 		conf.vif = &sdata->vif;
 		conf.type = sdata->vif.type;
 		conf.mac_addr = dev->dev_addr;
-		res = local->ops->add_interface(local_to_hw(local), &conf);
+		res = drv_add_interface(local, &conf);
 		if (res)
 			goto err_stop;
 
@@ -328,10 +327,10 @@ static int ieee80211_open(struct net_dev
 
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
@@ -544,7 +543,7 @@ static int ieee80211_stop(struct net_dev
 		conf.mac_addr = dev->dev_addr;
 		/* disable all keys for as long as this netdev is down */
 		ieee80211_disable_keys(sdata);
-		local->ops->remove_interface(local_to_hw(local), &conf);
+		drv_remove_interface(local, &conf);
 	}
 
 	sdata->bss = NULL;
@@ -553,8 +552,7 @@ static int ieee80211_stop(struct net_dev
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
 
-		if (local->ops->stop)
-			local->ops->stop(local_to_hw(local));
+		drv_stop(local);
 
 		ieee80211_led_radio(local, 0);
 
--- wireless-testing.orig/net/mac80211/key.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/key.c	2009-04-23 17:27:00.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/main.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-23 18:03:10.000000000 +0200
@@ -26,6 +26,7 @@
 #include <net/cfg80211.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 #include "mesh.h"
 #include "wep.h"
@@ -81,10 +82,9 @@ void ieee80211_configure_filter(struct i
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
 
@@ -192,7 +192,7 @@ int ieee80211_hw_config(struct ieee80211
 	}
 
 	if (changed && local->open_count) {
-		ret = local->ops->config(local_to_hw(local), changed);
+		ret = drv_config(local, changed);
 		/*
 		 * Goal:
 		 * HW reconfiguration should never fail, the driver has told
@@ -276,11 +276,8 @@ void ieee80211_bss_info_change_notify(st
 		}
 	}
 
-	if (local->ops->bss_info_changed)
-		local->ops->bss_info_changed(local_to_hw(local),
-					     &sdata->vif,
-					     &sdata->vif.bss_conf,
-					     changed);
+	drv_bss_info_changed(local, &sdata->vif,
+			     &sdata->vif.bss_conf, changed);
 
 	/*
 	 * DEPRECATED
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-23 17:27:00.000000000 +0200
@@ -23,6 +23,7 @@
 #include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 #include "led.h"
 
@@ -683,11 +684,10 @@ static void ieee80211_sta_wmm_params(str
 		       local->mdev->name, queue, aci, acm, params.aifs, params.cw_min,
 		       params.cw_max, params.txop);
 #endif
-		if (local->ops->conf_tx &&
-		    local->ops->conf_tx(local_to_hw(local), queue, &params)) {
+		if (drv_conf_tx(local, queue, &params) && local->ops->conf_tx)
 			printk(KERN_DEBUG "%s: failed to set TX queue "
-			       "parameters for queue %d\n", local->mdev->name, queue);
-		}
+			       "parameters for queue %d\n", local->mdev->name,
+			       queue);
 	}
 }
 
@@ -1982,10 +1982,8 @@ static void ieee80211_sta_reset_auth(str
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
-	if (local->ops->reset_tsf) {
-		/* Reset own TSF to allow time synchronization work. */
-		local->ops->reset_tsf(local_to_hw(local));
-	}
+	/* Reset own TSF to allow time synchronization work. */
+	drv_reset_tsf(local);
 
 	ifmgd->wmm_last_param_set = -1; /* allow any WMM update */
 
--- wireless-testing.orig/net/mac80211/pm.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2009-04-23 18:03:10.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/util.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-04-23 18:03:10.000000000 +0200
@@ -26,6 +26,7 @@
 #include <net/rtnetlink.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 #include "mesh.h"
 #include "wme.h"
@@ -726,7 +727,7 @@ void ieee80211_set_wmm_default(struct ie
 	qparam.txop = 0;
 
 	for (i = 0; i < local_to_hw(local)->queues; i++)
-		local->ops->conf_tx(local_to_hw(local), i, &qparam);
+		drv_conf_tx(local, i, &qparam);
 }
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
@@ -1000,7 +1001,7 @@ int ieee80211_reconfig(struct ieee80211_
 
 	/* restart hardware */
 	if (local->open_count) {
-		res = local->ops->start(hw);
+		res = drv_start(local);
 
 		ieee80211_led_radio(local, hw->conf.radio_enabled);
 	}
@@ -1013,7 +1014,7 @@ int ieee80211_reconfig(struct ieee80211_
 			conf.vif = &sdata->vif;
 			conf.type = sdata->vif.type;
 			conf.mac_addr = sdata->dev->dev_addr;
-			res = local->ops->add_interface(hw, &conf);
+			res = drv_add_interface(local, &conf);
 		}
 	}
 
@@ -1026,8 +1027,8 @@ int ieee80211_reconfig(struct ieee80211_
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-			local->ops->sta_notify(hw, &sdata->vif,
-				STA_NOTIFY_ADD, &sta->sta);
+			drv_sta_notify(local, &sdata->vif, STA_NOTIFY_ADD,
+				       &sta->sta);
 		}
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 	}
@@ -1045,8 +1046,7 @@ int ieee80211_reconfig(struct ieee80211_
 	rcu_read_unlock();
 
 	/* setup RTS threshold */
-	if (local->ops->set_rts_threshold)
-		local->ops->set_rts_threshold(hw, hw->wiphy->rts_threshold);
+	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
 
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
--- wireless-testing.orig/net/mac80211/rx.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-04-23 17:27:00.000000000 +0200
@@ -19,6 +19,7 @@
 #include <net/ieee80211_radiotap.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "led.h"
 #include "mesh.h"
 #include "wep.h"
@@ -773,9 +774,7 @@ static void ap_sta_ps_start(struct sta_i
 
 	atomic_inc(&sdata->bss->num_sta_ps);
 	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
-	if (local->ops->sta_notify)
-		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-					STA_NOTIFY_SLEEP, &sta->sta);
+	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d enters power save mode\n",
 	       sdata->dev->name, sta->sta.addr, sta->sta.aid);
@@ -792,9 +791,7 @@ static int ap_sta_ps_end(struct sta_info
 	atomic_dec(&sdata->bss->num_sta_ps);
 
 	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
-	if (local->ops->sta_notify)
-		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-					STA_NOTIFY_AWAKE, &sta->sta);
+	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
--- wireless-testing.orig/net/mac80211/scan.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-04-23 17:27:00.000000000 +0200
@@ -21,6 +21,7 @@
 #include <net/iw_handler.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "mesh.h"
 
 #define IEEE80211_PROBE_DELAY (HZ / 33)
@@ -316,17 +317,15 @@ void ieee80211_scan_completed(struct iee
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
@@ -375,8 +374,7 @@ static int ieee80211_start_sw_scan(struc
 	 * nullfunc frames and probe requests will be dropped in
 	 * ieee80211_tx_h_check_assoc().
 	 */
-	if (local->ops->sw_scan_start)
-		local->ops->sw_scan_start(local_to_hw(local));
+	drv_sw_scan_start(local);
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -405,11 +403,10 @@ static int ieee80211_start_sw_scan(struc
 
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
@@ -477,8 +474,7 @@ static int __ieee80211_start_scan(struct
 	mutex_unlock(&local->scan_mtx);
 
 	if (local->ops->hw_scan)
-		rc = local->ops->hw_scan(local_to_hw(local),
-					 local->scan_req);
+		rc = drv_hw_scan(local, local->scan_req);
 	else
 		rc = ieee80211_start_sw_scan(local);
 
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2009-04-23 17:27:00.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/tkip.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/tkip.c	2009-04-23 17:27:00.000000000 +0200
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
 
--- wireless-testing.orig/net/mac80211/tx.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-04-23 17:27:00.000000000 +0200
@@ -25,6 +25,7 @@
 #include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "led.h"
 #include "mesh.h"
 #include "wep.h"
@@ -1162,7 +1163,7 @@ static int __ieee80211_tx(struct ieee802
 
 		next = skb->next;
 		len = skb->len;
-		ret = local->ops->tx(local_to_hw(local), skb);
+		ret = drv_tx(local, skb);
 		if (WARN_ON(ret != NETDEV_TX_OK && skb->len != len)) {
 			dev_kfree_skb(skb);
 			ret = NETDEV_TX_OK;
--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2009-04-23 17:27:00.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2009-04-23 17:27:00.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/cfg.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-04-23 18:03:10.000000000 +0200
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
@@ -1115,7 +1114,7 @@ static int ieee80211_set_txq_params(stru
 	p.cw_max = params->cwmax;
 	p.cw_min = params->cwmin;
 	p.txop = params->txop;
-	if (local->ops->conf_tx(local_to_hw(local), params->queue, &p)) {
+	if (drv_conf_tx(local, params->queue, &p)) {
 		printk(KERN_DEBUG "%s: failed to set TX queue "
 		       "parameters for queue %d\n", local->mdev->name,
 		       params->queue);
@@ -1296,16 +1295,13 @@ static int ieee80211_leave_ibss(struct w
 static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	int err;
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
-		int err;
+		err = drv_set_rts_threshold(local, wiphy->rts_threshold);
 
-		if (local->ops->set_rts_threshold) {
-			err = local->ops->set_rts_threshold(
-				local_to_hw(local), wiphy->rts_threshold);
-			if (err)
-				return err;
-		}
+		if (err)
+			return err;
 	}
 
 	if (changed & WIPHY_PARAM_RETRY_SHORT)
--- wireless-testing.orig/net/mac80211/debugfs.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs.c	2009-04-23 18:50:52.000000000 +0200
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
@@ -150,14 +150,12 @@ static ssize_t format_devstat_counter(st
 	char buf[20];
 	int res;
 
-	if (!local->ops->get_stats)
-		return -EOPNOTSUPP;
-
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
 
--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-23 17:26:59.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-23 17:27:00.000000000 +0200
@@ -22,6 +22,7 @@
 #include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 #include "rate.h"
 
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
@@ -75,10 +76,9 @@ static void __ieee80211_sta_join_ibss(st
 	struct ieee80211_supported_band *sband;
 	u32 bss_change;
 
-	if (local->ops->reset_tsf) {
-		/* Reset own TSF to allow time synchronization work. */
-		local->ops->reset_tsf(local_to_hw(local));
-	}
+
+	/* Reset own TSF to allow time synchronization work. */
+	drv_reset_tsf(local);
 
 	skb = ifibss->skb;
 	rcu_assign_pointer(ifibss->presp, NULL);
@@ -315,12 +315,13 @@ static void ieee80211_rx_bss_info(struct
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
@@ -591,10 +592,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	    len < 24 + 2 || !ifibss->presp)
 		return;
 
-	if (local->ops->tx_last_beacon)
-		tx_last_beacon = local->ops->tx_last_beacon(local_to_hw(local));
-	else
-		tx_last_beacon = 1;
+	tx_last_beacon = drv_tx_last_beacon(local);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: RX ProbeReq SA=%pM DA=%pM BSSID=%pM"


