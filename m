Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZDNIJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 04:09:36 -0400
Subject: [PATCH] mac80211: add hardware restart function
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <bcopeland@gmail.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 10:09:24 +0200
Message-Id: <1239696564.4778.2.camel@johannes.local> (sfid-20090414_100944_052004_F056CBCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware defects may require the hardware to be re-initialised
completely from scratch. Drivers would need much information (for
instance the current MAC address, crypto keys, beaconing information,
etc.) stored duplicated from mac80211 to be able to do this, so let
mac80211 help them.

The new ieee80211_restart_hw() function requires the same code as
resuming, so move that code into a new ieee80211_reconfig() function
in util.c and leave only the suspend code in pm.c.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h     |   14 +++++
 net/mac80211/ieee80211_i.h |   13 ++++-
 net/mac80211/main.c        |   24 +++++++++
 net/mac80211/pm.c          |  110 ++-------------------------------------------
 net/mac80211/util.c        |  107 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 161 insertions(+), 107 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-04-14 09:21:04.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-04-14 09:22:07.000000000 +0200
@@ -1575,6 +1575,20 @@ void ieee80211_unregister_hw(struct ieee
  */
 void ieee80211_free_hw(struct ieee80211_hw *hw);
 
+/**
+ * ieee80211_restart_hw - restart hardware completely
+ *
+ * Call this function when the hardware was restarted for some reason
+ * (hardware error, ...) and the driver is unable to restore its state
+ * by itself. mac80211 assumes that at this point the driver/hardware
+ * is completely uninitialised and stopped, it starts the process by
+ * calling the ->start() operation. The driver will need to reset all
+ * internal state that it has prior to calling this function.
+ *
+ * @hw: the hardware to restart
+ */
+void ieee80211_restart_hw(struct ieee80211_hw *hw);
+
 /* trick to avoid symbol clashes with the ieee80211 subsystem */
 void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		    struct ieee80211_rx_status *status);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-14 09:21:04.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-14 09:22:07.000000000 +0200
@@ -748,6 +748,8 @@ struct ieee80211_local {
 	int user_power_level; /* in dBm */
 	int power_constr_level; /* in dBm */
 
+	struct work_struct restart_work;
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
 		struct dentry *rcdir;
@@ -1036,15 +1038,22 @@ void ieee80211_handle_pwr_constr(struct 
 				 u16 capab_info, u8 *pwr_constr_elem,
 				 u8 pwr_constr_elem_len);
 
-/* Suspend/resume */
+/* Suspend/resume and hw reconfiguration */
+int ieee80211_reconfig(struct ieee80211_local *local);
+
 #ifdef CONFIG_PM
 int __ieee80211_suspend(struct ieee80211_hw *hw);
-int __ieee80211_resume(struct ieee80211_hw *hw);
+
+static inline int __ieee80211_resume(struct ieee80211_hw *hw)
+{
+	return ieee80211_reconfig(hw_to_local(hw));
+}
 #else
 static inline int __ieee80211_suspend(struct ieee80211_hw *hw)
 {
 	return 0;
 }
+
 static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
 	return 0;
--- wireless-testing.orig/net/mac80211/main.c	2009-04-14 09:22:05.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-14 09:22:07.000000000 +0200
@@ -696,6 +696,28 @@ void ieee80211_tx_status(struct ieee8021
 }
 EXPORT_SYMBOL(ieee80211_tx_status);
 
+static void ieee80211_restart_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, restart_work);
+
+	rtnl_lock();
+	ieee80211_reconfig(local);
+	rtnl_unlock();
+}
+
+void ieee80211_restart_hw(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	/* use this reason, __ieee80211_resume will unblock it */
+	ieee80211_stop_queues_by_reason(hw,
+		IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+
+	schedule_work(&local->restart_work);
+}
+EXPORT_SYMBOL(ieee80211_restart_hw);
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -768,6 +790,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
+	INIT_WORK(&local->restart_work, ieee80211_restart_work);
+
 	INIT_WORK(&local->dynamic_ps_enable_work,
 		  ieee80211_dynamic_ps_enable_work);
 	INIT_WORK(&local->dynamic_ps_disable_work,
--- wireless-testing.orig/net/mac80211/pm.c	2009-04-14 09:22:06.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2009-04-14 09:22:07.000000000 +0200
@@ -72,108 +72,8 @@ int __ieee80211_suspend(struct ieee80211
 	return 0;
 }
 
-int __ieee80211_resume(struct ieee80211_hw *hw)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_init_conf conf;
-	struct sta_info *sta;
-	unsigned long flags;
-	int res;
-
-	/* restart hardware */
-	if (local->open_count) {
-		res = local->ops->start(hw);
-
-		ieee80211_led_radio(local, hw->conf.radio_enabled);
-	}
-
-	/* add interfaces */
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-		    netif_running(sdata->dev)) {
-			conf.vif = &sdata->vif;
-			conf.type = sdata->vif.type;
-			conf.mac_addr = sdata->dev->dev_addr;
-			res = local->ops->add_interface(hw, &conf);
-		}
-	}
-
-	/* add STAs back */
-	if (local->ops->sta_notify) {
-		spin_lock_irqsave(&local->sta_lock, flags);
-		list_for_each_entry(sta, &local->sta_list, list) {
-			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-				sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
-					     u.ap);
-
-			local->ops->sta_notify(hw, &sdata->vif,
-				STA_NOTIFY_ADD, &sta->sta);
-		}
-		spin_unlock_irqrestore(&local->sta_lock, flags);
-	}
-
-	/* Clear Suspend state so that ADDBA requests can be processed */
-
-	rcu_read_lock();
-
-	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
-		list_for_each_entry_rcu(sta, &local->sta_list, list) {
-			clear_sta_flags(sta, WLAN_STA_SUSPEND);
-		}
-	}
-
-	rcu_read_unlock();
-
-	/* setup RTS threshold */
-	if (local->ops->set_rts_threshold)
-		local->ops->set_rts_threshold(hw, local->rts_threshold);
-
-	/* reconfigure hardware */
-	ieee80211_hw_config(local, ~0);
-
-	netif_addr_lock_bh(local->mdev);
-	ieee80211_configure_filter(local);
-	netif_addr_unlock_bh(local->mdev);
-
-	/* Finally also reconfigure all the BSS information */
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		u32 changed = ~0;
-		if (!netif_running(sdata->dev))
-			continue;
-		switch (sdata->vif.type) {
-		case NL80211_IFTYPE_STATION:
-			/* disable beacon change bits */
-			changed &= ~IEEE80211_IFCC_BEACON;
-			/* fall through */
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_MESH_POINT:
-			WARN_ON(ieee80211_if_config(sdata, changed));
-			ieee80211_bss_info_change_notify(sdata, ~0);
-			break;
-		case NL80211_IFTYPE_WDS:
-			break;
-		case NL80211_IFTYPE_AP_VLAN:
-		case NL80211_IFTYPE_MONITOR:
-			/* ignore virtual */
-			break;
-		case NL80211_IFTYPE_UNSPECIFIED:
-		case __NL80211_IFTYPE_AFTER_LAST:
-			WARN_ON(1);
-			break;
-		}
-	}
-
-	/* add back keys */
-	list_for_each_entry(sdata, &local->interfaces, list)
-		if (netif_running(sdata->dev))
-			ieee80211_enable_keys(sdata);
-
-	ieee80211_wake_queues_by_reason(hw,
-			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
-
-	return 0;
-}
+/*
+ * __ieee80211_resume() is a static inline which just calls
+ * ieee80211_reconfig(), which is also needed for hardware
+ * hang/firmware failure/etc. recovery.
+ */
--- wireless-testing.orig/net/mac80211/util.c	2009-04-14 09:21:04.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-04-14 09:22:07.000000000 +0200
@@ -28,6 +28,7 @@
 #include "rate.h"
 #include "mesh.h"
 #include "wme.h"
+#include "led.h"
 
 /* privid for wiphys to determine whether they belong to us or not */
 void *mac80211_wiphy_privid = &mac80211_wiphy_privid;
@@ -966,3 +967,109 @@ u32 ieee80211_sta_get_rates(struct ieee8
 	}
 	return supp_rates;
 }
+
+int ieee80211_reconfig(struct ieee80211_local *local)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_init_conf conf;
+	struct sta_info *sta;
+	unsigned long flags;
+	int res;
+
+	/* restart hardware */
+	if (local->open_count) {
+		res = local->ops->start(hw);
+
+		ieee80211_led_radio(local, hw->conf.radio_enabled);
+	}
+
+	/* add interfaces */
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
+		    netif_running(sdata->dev)) {
+			conf.vif = &sdata->vif;
+			conf.type = sdata->vif.type;
+			conf.mac_addr = sdata->dev->dev_addr;
+			res = local->ops->add_interface(hw, &conf);
+		}
+	}
+
+	/* add STAs back */
+	if (local->ops->sta_notify) {
+		spin_lock_irqsave(&local->sta_lock, flags);
+		list_for_each_entry(sta, &local->sta_list, list) {
+			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+				sdata = container_of(sdata->bss,
+					     struct ieee80211_sub_if_data,
+					     u.ap);
+
+			local->ops->sta_notify(hw, &sdata->vif,
+				STA_NOTIFY_ADD, &sta->sta);
+		}
+		spin_unlock_irqrestore(&local->sta_lock, flags);
+	}
+
+	/* Clear Suspend state so that ADDBA requests can be processed */
+
+	rcu_read_lock();
+
+	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+			clear_sta_flags(sta, WLAN_STA_SUSPEND);
+		}
+	}
+
+	rcu_read_unlock();
+
+	/* setup RTS threshold */
+	if (local->ops->set_rts_threshold)
+		local->ops->set_rts_threshold(hw, local->rts_threshold);
+
+	/* reconfigure hardware */
+	ieee80211_hw_config(local, ~0);
+
+	netif_addr_lock_bh(local->mdev);
+	ieee80211_configure_filter(local);
+	netif_addr_unlock_bh(local->mdev);
+
+	/* Finally also reconfigure all the BSS information */
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		u32 changed = ~0;
+		if (!netif_running(sdata->dev))
+			continue;
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_STATION:
+			/* disable beacon change bits */
+			changed &= ~IEEE80211_IFCC_BEACON;
+			/* fall through */
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_MESH_POINT:
+			WARN_ON(ieee80211_if_config(sdata, changed));
+			ieee80211_bss_info_change_notify(sdata, ~0);
+			break;
+		case NL80211_IFTYPE_WDS:
+			break;
+		case NL80211_IFTYPE_AP_VLAN:
+		case NL80211_IFTYPE_MONITOR:
+			/* ignore virtual */
+			break;
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case __NL80211_IFTYPE_AFTER_LAST:
+			WARN_ON(1);
+			break;
+		}
+	}
+
+	/* add back keys */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (netif_running(sdata->dev))
+			ieee80211_enable_keys(sdata);
+
+	ieee80211_wake_queues_by_reason(hw,
+			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+
+	return 0;
+}


