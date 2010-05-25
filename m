Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:48098 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab0EYHq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 03:46:58 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4P7knf9009345
	for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 10:46:56 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4P7kdfq013030
	for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 10:46:40 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] mac80211: Add support for hardware ARP query filtering
Date: Tue, 25 May 2010 10:48:05 +0300
Message-Id: <1274773685-11168-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware allow extended filtering of ARP frames not intended for
this host. To perform such filtering, the hardware needs to know the current
IP address(es) of the host, bound to its interface.

Add support for ARP filtering to mac80211 by adding a new op to the driver
interface, allowing to configure the current IP addresses. Call this op when
the interface is opened (as there may be an address already configured) and
whenever the IP addresses change.

This patch adds configuration of IPv4 addresses only, as IPv6 addresses don't
need ARP filtering. IPv6 support could be added later if someone comes up with
more frame types that can be filtered in hardware already.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h     |    9 ++++++++
 net/mac80211/driver-ops.h  |   12 ++++++++++
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/iface.c       |    1 +
 net/mac80211/main.c        |   49 +++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de22cbf..2354956 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1468,6 +1468,8 @@ enum ieee80211_ampdu_mlme_action {
 	IEEE80211_AMPDU_TX_OPERATIONAL,
 };
 
+struct in_ifaddr;
+
 /**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
@@ -1535,6 +1537,11 @@ enum ieee80211_ampdu_mlme_action {
  *	of the bss parameters has changed when a call is made. The callback
  *	can sleep.
  *
+ * @configure_ip_filter: Configuration function for IP address based filters,
+ *      such as an ARP query filter. This function is called with all the IP
+ *      addresses configured to the interface as argument - all frames targeted
+ *      to any of these addresses should pass through.
+ *
  * @prepare_multicast: Prepare for multicast filter configuration.
  *	This callback is optional, and its return value is passed
  *	to configure_filter(). This callback must be atomic.
@@ -1674,6 +1681,8 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
+	int (*configure_ip_filter)(struct ieee80211_hw *hw,
+				   struct in_ifaddr *ifa_list);
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4f22713..fff6aca 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -83,6 +83,18 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 	trace_drv_bss_info_changed(local, sdata, info, changed);
 }
 
+struct in_ifaddr;
+static inline int drv_configure_ip_filter(struct ieee80211_hw *hw,
+					  struct in_ifaddr *ifa_list)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	int ret = 0;
+
+	if (local->ops->configure_ip_filter)
+		ret = local->ops->configure_ip_filter(hw, ifa_list);
+	return ret;
+}
+
 static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 					struct netdev_hw_addr_list *mc_list)
 {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1a9e2da..56e1331 100644
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
+int ieee80211_set_arp_filter(struct net_device *ndev);
 void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_channel_sw_ie *sw_elem,
 				      struct ieee80211_bss *bss,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 50deb01..5b488b8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -330,6 +330,7 @@ static int ieee80211_open(struct net_device *dev)
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
 
+	ieee80211_set_arp_filter(dev);
 	netif_tx_start_all_queues(dev);
 
 	return 0;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 22a384d..f39e065 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -20,6 +20,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/bitmap.h>
 #include <linux/pm_qos_params.h>
+#include <linux/inetdevice.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
 
@@ -329,6 +330,43 @@ static void ieee80211_recalc_smps_work(struct work_struct *work)
 	mutex_unlock(&local->iflist_mtx);
 }
 
+int ieee80211_set_arp_filter(struct net_device *ndev)
+{
+	struct ieee80211_local *local;
+	struct in_device *idev;
+	int ret;
+
+	BUG_ON(!ndev);
+
+	idev = ndev->ip_ptr;
+	if (!idev)
+		return 0;
+
+	local = wdev_priv(ndev->ieee80211_ptr);
+	ret = drv_configure_ip_filter(&local->hw, idev->ifa_list);
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
+
+	if (!wdev)
+		return NOTIFY_DONE;
+
+	if (wdev->wiphy != local->hw.wiphy)
+		return NOTIFY_DONE;
+
+	ieee80211_set_arp_filter(ndev);
+	return NOTIFY_DONE;
+}
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -612,14 +650,22 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
@@ -647,6 +693,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
 			       &local->network_latency_notifier);
+	unregister_inetaddr_notifier(&local->ifa_notifier);
 
 	rtnl_lock();
 
-- 
1.6.3.3

