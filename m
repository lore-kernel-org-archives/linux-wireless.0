Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48340 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1KCNlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 09:41:18 -0400
Subject: [PATCH] mac80211: verify virtual interfaces in driver API
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 14:41:13 +0100
Message-ID: <1320327673.3950.45.camel@jlt3.sipsolutions.net> (sfid-20111103_144135_283271_23E3EBF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The driver is never informed about monitor or
AP_VLAN interfaces, so whenever we pass those
to it later this is a bug. Verify we don't as
there are some cases where this could happen.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/driver-ops.h  |   68 +++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/iface.c       |    6 +--
 net/mac80211/pm.c          |    2 -
 net/mac80211/util.c        |    2 -
 5 files changed, 69 insertions(+), 11 deletions(-)

--- a/net/mac80211/driver-ops.h	2011-11-03 10:54:18.000000000 +0100
+++ b/net/mac80211/driver-ops.h	2011-11-03 11:52:47.000000000 +0100
@@ -5,6 +5,11 @@
 #include "ieee80211_i.h"
 #include "driver-trace.h"
 
+static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
+{
+	WARN_ON(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER));
+}
+
 static inline void drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
 {
 	local->ops->tx(&local->hw, skb);
@@ -69,15 +74,23 @@ static inline int drv_resume(struct ieee
 #endif
 
 static inline int drv_add_interface(struct ieee80211_local *local,
-				    struct ieee80211_vif *vif)
+				    struct ieee80211_sub_if_data *sdata)
 {
 	int ret;
 
 	might_sleep();
 
-	trace_drv_add_interface(local, vif_to_sdata(vif));
-	ret = local->ops->add_interface(&local->hw, vif);
+	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    sdata->vif.type == NL80211_IFTYPE_MONITOR))
+		return -EINVAL;
+
+	trace_drv_add_interface(local, sdata);
+	ret = local->ops->add_interface(&local->hw, &sdata->vif);
 	trace_drv_return_int(local, ret);
+
+	if (ret == 0)
+		sdata->flags |= IEEE80211_SDATA_IN_DRIVER;
+
 	return ret;
 }
 
@@ -89,6 +102,8 @@ static inline int drv_change_interface(s
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_change_interface(local, sdata, type, p2p);
 	ret = local->ops->change_interface(&local->hw, &sdata->vif, type, p2p);
 	trace_drv_return_int(local, ret);
@@ -96,12 +111,15 @@ static inline int drv_change_interface(s
 }
 
 static inline void drv_remove_interface(struct ieee80211_local *local,
-					struct ieee80211_vif *vif)
+					struct ieee80211_sub_if_data *sdata)
 {
 	might_sleep();
 
-	trace_drv_remove_interface(local, vif_to_sdata(vif));
-	local->ops->remove_interface(&local->hw, vif);
+	check_sdata_in_driver(sdata);
+
+	trace_drv_remove_interface(local, sdata);
+	local->ops->remove_interface(&local->hw, &sdata->vif);
+	sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
 	trace_drv_return_void(local);
 }
 
@@ -124,6 +142,8 @@ static inline void drv_bss_info_changed(
 {
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_bss_info_changed(local, sdata, info, changed);
 	if (local->ops->bss_info_changed)
 		local->ops->bss_info_changed(&local->hw, &sdata->vif, info, changed);
@@ -139,6 +159,8 @@ static inline int drv_tx_sync(struct iee
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_tx_sync(local, sdata, bssid, type);
 	if (local->ops->tx_sync)
 		ret = local->ops->tx_sync(&local->hw, &sdata->vif,
@@ -154,6 +176,8 @@ static inline void drv_finish_tx_sync(st
 {
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_finish_tx_sync(local, sdata, bssid, type);
 	if (local->ops->finish_tx_sync)
 		local->ops->finish_tx_sync(&local->hw, &sdata->vif,
@@ -211,6 +235,8 @@ static inline int drv_set_key(struct iee
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_set_key(local, cmd, sdata, sta, key);
 	ret = local->ops->set_key(&local->hw, cmd, &sdata->vif, sta, key);
 	trace_drv_return_int(local, ret);
@@ -228,6 +254,8 @@ static inline void drv_update_tkip_key(s
 	if (sta)
 		ista = &sta->sta;
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_update_tkip_key(local, sdata, conf, ista, iv32);
 	if (local->ops->update_tkip_key)
 		local->ops->update_tkip_key(&local->hw, &sdata->vif, conf,
@@ -243,6 +271,8 @@ static inline int drv_hw_scan(struct iee
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_hw_scan(local, sdata);
 	ret = local->ops->hw_scan(&local->hw, &sdata->vif, req);
 	trace_drv_return_int(local, ret);
@@ -254,6 +284,8 @@ static inline void drv_cancel_hw_scan(st
 {
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_cancel_hw_scan(local, sdata);
 	local->ops->cancel_hw_scan(&local->hw, &sdata->vif);
 	trace_drv_return_void(local);
@@ -269,6 +301,8 @@ drv_sched_scan_start(struct ieee80211_lo
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_sched_scan_start(local, sdata);
 	ret = local->ops->sched_scan_start(&local->hw, &sdata->vif,
 					      req, ies);
@@ -281,6 +315,8 @@ static inline void drv_sched_scan_stop(s
 {
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_sched_scan_stop(local, sdata);
 	local->ops->sched_scan_stop(&local->hw, &sdata->vif);
 	trace_drv_return_void(local);
@@ -377,6 +413,8 @@ static inline void drv_sta_notify(struct
 				  enum sta_notify_cmd cmd,
 				  struct ieee80211_sta *sta)
 {
+	check_sdata_in_driver(sdata);
+
 	trace_drv_sta_notify(local, sdata, cmd, sta);
 	if (local->ops->sta_notify)
 		local->ops->sta_notify(&local->hw, &sdata->vif, cmd, sta);
@@ -391,6 +429,8 @@ static inline int drv_sta_add(struct iee
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_sta_add(local, sdata, sta);
 	if (local->ops->sta_add)
 		ret = local->ops->sta_add(&local->hw, &sdata->vif, sta);
@@ -406,6 +446,8 @@ static inline void drv_sta_remove(struct
 {
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_sta_remove(local, sdata, sta);
 	if (local->ops->sta_remove)
 		local->ops->sta_remove(&local->hw, &sdata->vif, sta);
@@ -421,6 +463,8 @@ static inline int drv_conf_tx(struct iee
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_conf_tx(local, sdata, queue, params);
 	if (local->ops->conf_tx)
 		ret = local->ops->conf_tx(&local->hw, &sdata->vif,
@@ -436,6 +480,8 @@ static inline u64 drv_get_tsf(struct iee
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_get_tsf(local, sdata);
 	if (local->ops->get_tsf)
 		ret = local->ops->get_tsf(&local->hw, &sdata->vif);
@@ -449,6 +495,8 @@ static inline void drv_set_tsf(struct ie
 {
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_set_tsf(local, sdata, tsf);
 	if (local->ops->set_tsf)
 		local->ops->set_tsf(&local->hw, &sdata->vif, tsf);
@@ -460,6 +508,8 @@ static inline void drv_reset_tsf(struct
 {
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_reset_tsf(local, sdata);
 	if (local->ops->reset_tsf)
 		local->ops->reset_tsf(&local->hw, &sdata->vif);
@@ -489,6 +539,8 @@ static inline int drv_ampdu_action(struc
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, buf_size);
 
 	if (local->ops->ampdu_action)
@@ -644,6 +696,8 @@ static inline int drv_set_bitrate_mask(s
 
 	might_sleep();
 
+	check_sdata_in_driver(sdata);
+
 	trace_drv_set_bitrate_mask(local, sdata, mask);
 	if (local->ops->set_bitrate_mask)
 		ret = local->ops->set_bitrate_mask(&local->hw,
@@ -657,6 +711,8 @@ static inline void drv_set_rekey_data(st
 				      struct ieee80211_sub_if_data *sdata,
 				      struct cfg80211_gtk_rekey_data *data)
 {
+	check_sdata_in_driver(sdata);
+
 	trace_drv_set_rekey_data(local, sdata, data);
 	if (local->ops->set_rekey_data)
 		local->ops->set_rekey_data(&local->hw, &sdata->vif, data);
--- a/net/mac80211/ieee80211_i.h	2011-11-03 11:52:43.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-11-03 11:52:47.000000000 +0100
@@ -543,6 +543,7 @@ struct ieee80211_if_mesh {
  *	associated stations and deliver multicast frames both
  *	back to wireless media and to the local net stack.
  * @IEEE80211_SDATA_DISCONNECT_RESUME: Disconnect after resume.
+ * @IEEE80211_SDATA_IN_DRIVER: indicates interface was added to driver
  */
 enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_ALLMULTI		= BIT(0),
@@ -550,6 +551,7 @@ enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_OPERATING_GMODE		= BIT(2),
 	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
 	IEEE80211_SDATA_DISCONNECT_RESUME	= BIT(4),
+	IEEE80211_SDATA_IN_DRIVER		= BIT(5),
 };
 
 /**
--- a/net/mac80211/iface.c	2011-11-03 10:54:17.000000000 +0100
+++ b/net/mac80211/iface.c	2011-11-03 11:52:47.000000000 +0100
@@ -265,7 +265,7 @@ static int ieee80211_do_open(struct net_
 		break;
 	default:
 		if (coming_up) {
-			res = drv_add_interface(local, &sdata->vif);
+			res = drv_add_interface(local, sdata);
 			if (res)
 				goto err_stop;
 		}
@@ -345,7 +345,7 @@ static int ieee80211_do_open(struct net_
 
 	return 0;
  err_del_interface:
-	drv_remove_interface(local, &sdata->vif);
+	drv_remove_interface(local, sdata);
  err_stop:
 	if (!local->open_count)
 		drv_stop(local);
@@ -520,7 +520,7 @@ static void ieee80211_do_stop(struct iee
 		ieee80211_free_keys(sdata);
 
 		if (going_down)
-			drv_remove_interface(local, &sdata->vif);
+			drv_remove_interface(local, sdata);
 	}
 
 	sdata->bss = NULL;
--- a/net/mac80211/util.c	2011-11-03 10:54:18.000000000 +0100
+++ b/net/mac80211/util.c	2011-11-03 11:52:47.000000000 +0100
@@ -1021,7 +1021,7 @@ int ieee80211_reconfig(struct ieee80211_
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
 		    ieee80211_sdata_running(sdata))
-			res = drv_add_interface(local, &sdata->vif);
+			res = drv_add_interface(local, sdata);
 	}
 
 	/* add STAs back */
--- a/net/mac80211/pm.c	2011-11-03 10:54:18.000000000 +0100
+++ b/net/mac80211/pm.c	2011-11-03 11:52:47.000000000 +0100
@@ -125,7 +125,7 @@ int __ieee80211_suspend(struct ieee80211
 		ieee80211_bss_info_change_notify(sdata,
 			BSS_CHANGED_BEACON_ENABLED);
 
-		drv_remove_interface(local, &sdata->vif);
+		drv_remove_interface(local, sdata);
 	}
 
 	/* stop hardware - this must stop RX */


