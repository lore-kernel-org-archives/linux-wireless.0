Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:22911 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0E0Lkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 07:40:36 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4RBeT5w012764
	for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 14:40:34 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4RBeA73003073
	for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 14:40:11 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv6] mac80211: Add support for hardware ARP query filtering
Date: Thu, 27 May 2010 14:42:13 +0300
Message-Id: <1274960533-395-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware allow extended filtering of ARP frames not intended for
the host. To perform such filtering, the hardware needs to know the current
IP address(es) of the host, bound to its interface.

Add support for ARP filtering to mac80211 by adding a new op to the driver
interface, allowing to configure the current IP addresses. This op is called
upon association with the currently configured address(es), and when
associated whenever the IP address(es) change.

This patch adds configuration of IPv4 addresses only, as IPv6 addresses don't
need ARP filtering.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

v6: Add check for managed mode in "ieee80211_ifa_changed"
---
 include/net/mac80211.h      |   14 +++++++++
 net/mac80211/driver-ops.h   |   17 +++++++++++
 net/mac80211/driver-trace.h |   25 +++++++++++++++++
 net/mac80211/ieee80211_i.h  |    2 +
 net/mac80211/main.c         |   63 ++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mlme.c         |   11 +++++++-
 6 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de22cbf..169251c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -19,6 +19,7 @@
 #include <linux/wireless.h>
 #include <linux/device.h>
 #include <linux/ieee80211.h>
+#include <linux/inetdevice.h>
 #include <net/cfg80211.h>
 
 /**
@@ -1535,6 +1536,16 @@ enum ieee80211_ampdu_mlme_action {
  *	of the bss parameters has changed when a call is made. The callback
  *	can sleep.
  *
+ * @configure_arp_filter: Configuration function for hardware ARP query filter.
+ *	This function is called with all the IP addresses configured to the
+ *	interface as argument - all ARP queries targeted to any of these
+ *	addresses must pass through. If the hardware filter does not support
+ *	enought addresses, hardware filtering must be disabled. The ifa_list
+ *	argument may be NULL, indicating that filtering must be disabled.
+ *	This function is called upon association complete with current
+ *	address(es), and while associated whenever the IP address(es) change.
+ *	The callback can sleep.
+ *
  * @prepare_multicast: Prepare for multicast filter configuration.
  *	This callback is optional, and its return value is passed
  *	to configure_filter(). This callback must be atomic.
@@ -1674,6 +1685,9 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
+	int (*configure_arp_filter)(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct in_ifaddr *ifa_list);
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4f22713..978850e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -83,6 +83,23 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 	trace_drv_bss_info_changed(local, sdata, info, changed);
 }
 
+struct in_ifaddr;
+static inline int drv_configure_arp_filter(struct ieee80211_local *local,
+					   struct ieee80211_vif *vif,
+					   struct in_ifaddr *ifa_list)
+{
+	int ret = 0;
+
+	might_sleep();
+
+	if (local->ops->configure_arp_filter)
+		ret = local->ops->configure_arp_filter(&local->hw, vif,
+						       ifa_list);
+
+	trace_drv_configure_arp_filter(local, vif_to_sdata(vif), ifa_list, ret);
+	return ret;
+}
+
 static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 					struct netdev_hw_addr_list *mc_list)
 {
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6a9b234..577460d 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -219,6 +219,31 @@ TRACE_EVENT(drv_bss_info_changed,
 	)
 );
 
+TRACE_EVENT(drv_configure_arp_filter,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct in_ifaddr *ifa_list, int ret),
+
+	TP_ARGS(local, sdata, ifa_list, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		VIF_PR_FMT LOCAL_PR_FMT " ret:%d",
+		VIF_PR_ARG, LOCAL_PR_ARG, __entry->ret
+	)
+);
+
 TRACE_EVENT(drv_prepare_multicast,
 	TP_PROTO(struct ieee80211_local *local, int mc_count, u64 ret),
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1a9e2da..8356a08 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -851,6 +851,7 @@ struct ieee80211_local {
 	struct work_struct dynamic_ps_disable_work;
 	struct timer_list dynamic_ps_timer;
 	struct notifier_block network_latency_notifier;
+	struct notifier_block ifa_notifier;
 
 	int user_power_level; /* in dBm */
 	int power_constr_level; /* in dBm */
@@ -996,6 +997,7 @@ void ieee80211_send_pspoll(struct ieee80211_local *local,
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
 int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
+int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_channel_sw_ie *sw_elem,
 				      struct ieee80211_bss *bss,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 22a384d..d6eb0b6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -329,6 +329,58 @@ static void ieee80211_recalc_smps_work(struct work_struct *work)
 	mutex_unlock(&local->iflist_mtx);
 }
 
+int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata)
+{
+	struct in_device *idev;
+	int ret = 0;
+
+	BUG_ON(!sdata);
+	ASSERT_RTNL();
+
+	idev = sdata->dev->ip_ptr;
+	if (!idev)
+		return 0;
+
+	ret = drv_configure_arp_filter(sdata->local, &sdata->vif,
+				       idev->ifa_list);
+	return ret;
+}
+
+static int ieee80211_ifa_changed(struct notifier_block *nb,
+				 unsigned long data, void *arg)
+{
+	struct in_ifaddr *ifa = arg;
+	struct ieee80211_local *local =
+		container_of(nb, struct ieee80211_local,
+			     ifa_notifier);
+	struct net_device *ndev = ifa->ifa_dev->dev;
+	struct wireless_dev *wdev = ndev->ieee80211_ptr;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_managed *ifmgd;
+
+	/* Make sure it's our interface that got changed */
+	if (!wdev)
+		return NOTIFY_DONE;
+
+	if (wdev->wiphy != local->hw.wiphy)
+		return NOTIFY_DONE;
+
+	/* We are concerned about IP addresses only when associated */
+	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
+
+	/* ARP filtering is only supported in managed mode */
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return NOTIFY_DONE;
+
+	ifmgd = &sdata->u.mgd;
+	mutex_lock(&ifmgd->mtx);
+	if (ifmgd->associated)
+		ieee80211_set_arp_filter(sdata);
+	mutex_unlock(&ifmgd->mtx);
+
+	return NOTIFY_DONE;
+}
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -612,14 +664,22 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		ieee80211_max_network_latency;
 	result = pm_qos_add_notifier(PM_QOS_NETWORK_LATENCY,
 				     &local->network_latency_notifier);
-
 	if (result) {
 		rtnl_lock();
 		goto fail_pm_qos;
 	}
 
+	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
+	result = register_inetaddr_notifier(&local->ifa_notifier);
+	if (result)
+		goto fail_ifa;
+
 	return 0;
 
+ fail_ifa:
+	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
+			       &local->network_latency_notifier);
+	rtnl_lock();
  fail_pm_qos:
 	ieee80211_led_exit(local);
 	ieee80211_remove_interfaces(local);
@@ -647,6 +707,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
 			       &local->network_latency_notifier);
+	unregister_inetaddr_notifier(&local->ifa_notifier);
 
 	rtnl_lock();
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0839c4e..0fa1fa3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2078,8 +2078,17 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 			cfg80211_send_assoc_timeout(wk->sdata->dev,
 						    wk->filter_ta);
 			return WORK_DONE_DESTROY;
+		} else {
+			mutex_unlock(&wk->sdata->u.mgd.mtx);
+
+			/*
+			 * configure ARP filter IP addresses to the driver,
+			 * intentionally outside the mgd mutex.
+			 */
+			rtnl_lock();
+			ieee80211_set_arp_filter(wk->sdata);
+			rtnl_unlock();
 		}
-		mutex_unlock(&wk->sdata->u.mgd.mtx);
 	}
 
 	cfg80211_send_rx_assoc(wk->sdata->dev, skb->data, skb->len);
-- 
1.6.3.3

