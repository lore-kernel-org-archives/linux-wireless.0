Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32797 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbbJNQEf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 12:04:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove PM-QoS listener
Date: Wed, 14 Oct 2015 18:04:32 +0200
Message-Id: <1444838672-11252-1-git-send-email-johannes@sipsolutions.net> (sfid-20151014_180440_099523_065DC031)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As this API has never really seen any use and most drivers don't
ever use the value derived from it, remove it.

Change the only driver using it (rt2x00) to simply use the DTIM
period instead of the "max sleep" time.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |  2 +-
 include/net/mac80211.h                     |  6 ---
 net/mac80211/cfg.c                         |  4 +-
 net/mac80211/ieee80211_i.h                 |  5 +--
 net/mac80211/iface.c                       |  4 +-
 net/mac80211/main.c                        | 13 ------
 net/mac80211/mlme.c                        | 69 ++++++------------------------
 net/mac80211/scan.c                        |  1 -
 net/mac80211/trace.h                       |  2 -
 net/mac80211/util.c                        |  2 +-
 10 files changed, 21 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 48a2cad29477..7e8bb1198ae9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -266,7 +266,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		if (beacon_diff > beacon_int)
 			beacon_diff = 0;
 
-		autowake_timeout = (conf->max_sleep_period * beacon_int) - beacon_diff;
+		autowake_timeout = (conf->ps_dtim_period * beacon_int) - beacon_diff;
 		queue_delayed_work(rt2x00dev->workqueue,
 				   &rt2x00dev->autowakeup_work,
 				   autowake_timeout - 15);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1bb2a2b4e187..4b9dd070aeb9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1241,11 +1241,6 @@ enum ieee80211_smps_mode {
  * @flags: configuration flags defined above
  *
  * @listen_interval: listen interval in units of beacon interval
- * @max_sleep_period: the maximum number of beacon intervals to sleep for
- *	before checking the beacon for a TIM bit (managed mode only); this
- *	value will be only achievable between DTIM frames, the hardware
- *	needs to check for the multicast traffic bit in DTIM beacons.
- *	This variable is valid only when the CONF_PS flag is set.
  * @ps_dtim_period: The DTIM period of the AP we're connected to, for use
  *	in power saving. Power saving will not be enabled until a beacon
  *	has been received and the DTIM period is known.
@@ -1275,7 +1270,6 @@ enum ieee80211_smps_mode {
 struct ieee80211_conf {
 	u32 flags;
 	int power_level, dynamic_ps_timeout;
-	int max_sleep_period;
 
 	u16 listen_interval;
 	u8 ps_dtim_period;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 63d03dad654c..276b57243298 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1428,7 +1428,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
-		ieee80211_recalc_ps(local, -1);
+		ieee80211_recalc_ps(local);
 		ieee80211_recalc_ps_vif(sdata);
 	}
 
@@ -2463,7 +2463,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	if (ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS))
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_ps(local);
 	ieee80211_recalc_ps_vif(sdata);
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f9605f13def9..99735408e99d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1305,7 +1305,6 @@ struct ieee80211_local {
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
 	struct timer_list dynamic_ps_timer;
-	struct notifier_block network_latency_notifier;
 	struct notifier_block ifa_notifier;
 	struct notifier_block ifa6_notifier;
 
@@ -1491,10 +1490,8 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_disassoc_request *req);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
-void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
+void ieee80211_recalc_ps(struct ieee80211_local *local);
 void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata);
-int ieee80211_max_network_latency(struct notifier_block *nb,
-				  unsigned long data, void *dummy);
 int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 42d7f0f65bd6..f848c75518a2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -709,7 +709,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	if (hw_reconf_flags)
 		ieee80211_hw_config(local, hw_reconf_flags);
 
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_ps(local);
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
@@ -1016,7 +1016,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			drv_remove_interface(local, sdata);
 	}
 
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_ps(local);
 
 	if (cancel_scan)
 		flush_delayed_work(&local->scan_work);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 9b813a2f3a75..e2514fadc3d7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -20,7 +20,6 @@
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
 #include <linux/bitmap.h>
-#include <linux/pm_qos.h>
 #include <linux/inetdevice.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
@@ -1083,13 +1082,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	rtnl_unlock();
 
-	local->network_latency_notifier.notifier_call =
-		ieee80211_max_network_latency;
-	result = pm_qos_add_notifier(PM_QOS_NETWORK_LATENCY,
-				     &local->network_latency_notifier);
-	if (result)
-		goto fail_pm_qos;
-
 #ifdef CONFIG_INET
 	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
 	result = register_inetaddr_notifier(&local->ifa_notifier);
@@ -1114,10 +1106,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 #endif
 #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
-	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
-			       &local->network_latency_notifier);
 #endif
- fail_pm_qos:
 	rtnl_lock();
 	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);
@@ -1143,8 +1132,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
 
-	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
-			       &local->network_latency_notifier);
 #ifdef CONFIG_INET
 	unregister_inetaddr_notifier(&local->ifa_notifier);
 #endif
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9c450ffdabe8..6158db06a5b5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -20,7 +20,6 @@
 #include <linux/etherdevice.h>
 #include <linux/moduleparam.h>
 #include <linux/rtnetlink.h>
-#include <linux/pm_qos.h>
 #include <linux/crc32.h>
 #include <linux/slab.h>
 #include <linux/export.h>
@@ -1476,7 +1475,7 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 }
 
 /* need to hold RTNL or interface lock */
-void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
+void ieee80211_recalc_ps(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata, *found = NULL;
 	int count = 0;
@@ -1505,48 +1504,23 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 	}
 
 	if (count == 1 && ieee80211_powersave_allowed(found)) {
+		u8 dtimper = found->u.mgd.dtim_period;
 		s32 beaconint_us;
 
-		if (latency < 0)
-			latency = pm_qos_request(PM_QOS_NETWORK_LATENCY);
-
 		beaconint_us = ieee80211_tu_to_usec(
 					found->vif.bss_conf.beacon_int);
 
 		timeout = local->dynamic_ps_forced_timeout;
-		if (timeout < 0) {
-			/*
-			 * Go to full PSM if the user configures a very low
-			 * latency requirement.
-			 * The 2000 second value is there for compatibility
-			 * until the PM_QOS_NETWORK_LATENCY is configured
-			 * with real values.
-			 */
-			if (latency > (1900 * USEC_PER_MSEC) &&
-			    latency != (2000 * USEC_PER_SEC))
-				timeout = 0;
-			else
-				timeout = 100;
-		}
+		if (timeout < 0)
+			timeout = 100;
 		local->hw.conf.dynamic_ps_timeout = timeout;
 
-		if (beaconint_us > latency) {
-			local->ps_sdata = NULL;
-		} else {
-			int maxslp = 1;
-			u8 dtimper = found->u.mgd.dtim_period;
-
-			/* If the TIM IE is invalid, pretend the value is 1 */
-			if (!dtimper)
-				dtimper = 1;
-			else if (dtimper > 1)
-				maxslp = min_t(int, dtimper,
-						    latency / beaconint_us);
-
-			local->hw.conf.max_sleep_period = maxslp;
-			local->hw.conf.ps_dtim_period = dtimper;
-			local->ps_sdata = found;
-		}
+		/* If the TIM IE is invalid, pretend the value is 1 */
+		if (!dtimper)
+			dtimper = 1;
+
+		local->hw.conf.ps_dtim_period = dtimper;
+		local->ps_sdata = found;
 	} else {
 		local->ps_sdata = NULL;
 	}
@@ -1997,7 +1971,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	mutex_lock(&local->iflist_mtx);
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_ps(local);
 	mutex_unlock(&local->iflist_mtx);
 
 	ieee80211_recalc_smps(sdata);
@@ -2165,7 +2139,7 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 	__ieee80211_stop_poll(sdata);
 
 	mutex_lock(&local->iflist_mtx);
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_ps(local);
 	mutex_unlock(&local->iflist_mtx);
 
 	if (ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
@@ -2341,7 +2315,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 		goto out;
 
 	mutex_lock(&sdata->local->iflist_mtx);
-	ieee80211_recalc_ps(sdata->local, -1);
+	ieee80211_recalc_ps(sdata->local);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
 	ifmgd->probe_send_count = 0;
@@ -3548,7 +3522,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ifmgd->have_beacon = true;
 
 		mutex_lock(&local->iflist_mtx);
-		ieee80211_recalc_ps(local, -1);
+		ieee80211_recalc_ps(local);
 		mutex_unlock(&local->iflist_mtx);
 
 		ieee80211_recalc_ps_vif(sdata);
@@ -4152,21 +4126,6 @@ void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 	rcu_read_unlock();
 }
 
-int ieee80211_max_network_latency(struct notifier_block *nb,
-				  unsigned long data, void *dummy)
-{
-	s32 latency_usec = (s32) data;
-	struct ieee80211_local *local =
-		container_of(nb, struct ieee80211_local,
-			     network_latency_notifier);
-
-	mutex_lock(&local->iflist_mtx);
-	ieee80211_recalc_ps(local, latency_usec);
-	mutex_unlock(&local->iflist_mtx);
-
-	return NOTIFY_OK;
-}
-
 static u8 ieee80211_ht_vht_rx_chains(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_bss *cbss)
 {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a368a1d6caff..b64fd2b2d95a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -16,7 +16,6 @@
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
-#include <linux/pm_qos.h>
 #include <net/sch_generic.h>
 #include <linux/slab.h>
 #include <linux/export.h>
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 314e3bd7fbdb..5cf8f4ea077f 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -325,7 +325,6 @@ TRACE_EVENT(drv_config,
 		__field(u32, flags)
 		__field(int, power_level)
 		__field(int, dynamic_ps_timeout)
-		__field(int, max_sleep_period)
 		__field(u16, listen_interval)
 		__field(u8, long_frame_max_tx_count)
 		__field(u8, short_frame_max_tx_count)
@@ -339,7 +338,6 @@ TRACE_EVENT(drv_config,
 		__entry->flags = local->hw.conf.flags;
 		__entry->power_level = local->hw.conf.power_level;
 		__entry->dynamic_ps_timeout = local->hw.conf.dynamic_ps_timeout;
-		__entry->max_sleep_period = local->hw.conf.max_sleep_period;
 		__entry->listen_interval = local->hw.conf.listen_interval;
 		__entry->long_frame_max_tx_count =
 			local->hw.conf.long_frame_max_tx_count;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8f0fa357a5a7..8274c86296f9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1951,7 +1951,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		}
 	}
 
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_ps(local);
 
 	/*
 	 * The sta might be in psm against the ap (e.g. because
-- 
2.5.1

