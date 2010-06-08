Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27798 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0FHNGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 09:06:09 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
Subject: [PATCHv2] mac80211: Fix circular locking dependency in ARP filter handling
Date: Tue,  8 Jun 2010 16:05:35 +0300
Message-Id: <1276002335-18600-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a circular locking dependency when configuring the
hardware ARP filters on association, occurring when flushing the mac80211
workqueue. This is what happens:

[   92.026800] =======================================================
[   92.030507] [ INFO: possible circular locking dependency detected ]
[   92.030507] 2.6.34-04781-g2b2c009 #85
[   92.030507] -------------------------------------------------------
[   92.030507] modprobe/5225 is trying to acquire lock:
[   92.030507]  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<ffffffff8105b5c0>] flush_workq
ueue+0x0/0xb0
[   92.030507]
[   92.030507] but task is already holding lock:
[   92.030507]  (rtnl_mutex){+.+.+.}, at: [<ffffffff812b9ce2>] rtnl_lock+0x12/0x20
[   92.030507]
[   92.030507] which lock already depends on the new lock.
[   92.030507]
[   92.030507]
[   92.030507] the existing dependency chain (in reverse order) is:
[   92.030507]
[   92.030507] -> #2 (rtnl_mutex){+.+.+.}:
[   92.030507]        [<ffffffff810761fb>] lock_acquire+0xdb/0x110
[   92.030507]        [<ffffffff81341754>] mutex_lock_nested+0x44/0x300
[   92.030507]        [<ffffffff812b9ce2>] rtnl_lock+0x12/0x20
[   92.030507]        [<ffffffffa022d47c>] ieee80211_assoc_done+0x6c/0xe0 [mac80211]
[   92.030507]        [<ffffffffa022f2ad>] ieee80211_work_work+0x31d/0x1280 [mac80211]

[   92.030507] -> #1 ((&local->work_work)){+.+.+.}:
[   92.030507]        [<ffffffff810761fb>] lock_acquire+0xdb/0x110
[   92.030507]        [<ffffffff8105a51a>] worker_thread+0x22a/0x370
[   92.030507]        [<ffffffff8105ecc6>] kthread+0x96/0xb0
[   92.030507]        [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10
[   92.030507]
[   92.030507] -> #0 ((wiphy_name(local->hw.wiphy))){+.+.+.}:
[   92.030507]        [<ffffffff81075fdc>] __lock_acquire+0x1c0c/0x1d50
[   92.030507]        [<ffffffff810761fb>] lock_acquire+0xdb/0x110
[   92.030507]        [<ffffffff8105b60e>] flush_workqueue+0x4e/0xb0
[   92.030507]        [<ffffffffa023ff7b>] ieee80211_stop_device+0x2b/0xb0 [mac80211]
[   92.030507]        [<ffffffffa0231635>] ieee80211_stop+0x3e5/0x680 [mac80211]

The locking in this case is quite complex. Fix the problem by rewriting the
way the hardware ARP filter list is handled - i.e. make a copy of the address
list to the bss_conf struct, and provide that list to the hardware driver
when needed.

Additionally, this patch ensures that hardware ARP filtering is not enabled
when promiscuous mode is set.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
v2: Do not enable ARP filtering if in promiscuous mode

 include/net/mac80211.h      |   34 +++++----
 net/mac80211/driver-ops.h   |   17 -----
 net/mac80211/driver-trace.h |   25 -------
 net/mac80211/ieee80211_i.h  |    2 +
 net/mac80211/main.c         |  168 +++++++++++++++++++++++++++++--------------
 net/mac80211/mlme.c         |   39 ++++++----
 6 files changed, 159 insertions(+), 126 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e3c1d47..f409d00 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -19,7 +19,6 @@
 #include <linux/wireless.h>
 #include <linux/device.h>
 #include <linux/ieee80211.h>
-#include <linux/inetdevice.h>
 #include <net/cfg80211.h>
 
 /**
@@ -147,6 +146,7 @@ struct ieee80211_low_level_stats {
  *	enabled/disabled (beaconing modes)
  * @BSS_CHANGED_CQM: Connection quality monitor config changed
  * @BSS_CHANGED_IBSS: IBSS join status changed
+ * @BSS_CHANGED_ARP_FILTER: Hardware ARP filter address list or state changed.
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -161,10 +161,18 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_BEACON_ENABLED	= 1<<9,
 	BSS_CHANGED_CQM			= 1<<10,
 	BSS_CHANGED_IBSS		= 1<<11,
+	BSS_CHANGED_ARP_FILTER		= 1<<12,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
 
+/*
+ * The maximum number of IPv4 addresses listed for ARP filtering. If the number
+ * of addresses for an interface increase beyond this value, hardware ARP
+ * filtering will be disabled.
+ */
+#define IEEE80211_BSS_ARP_ADDR_LIST_LEN 4
+
 /**
  * struct ieee80211_bss_conf - holds the BSS's changing parameters
  *
@@ -200,6 +208,14 @@ enum ieee80211_bss_change {
  * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
  *	implies disabled
  * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
+ * @arp_addr_list: List of IPv4 addresses for hardware ARP filtering. The
+ *	may filter ARP queries targeted for other addresses than listed here.
+ *	The driver must allow ARP queries targeted for all address listed here
+ *	to pass through. An empty list implies no ARP queries need to pass.
+ * @arp_addr_cnt: Number of addresses currently on the list.
+ * @arp_filter_enabled: Enable ARP filtering - if enabled, the hardware may
+ *      filter ARP queries based on the @arp_addr_list, if disabled, the
+ *      hardware must not perform any ARP filtering.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -220,6 +236,9 @@ struct ieee80211_bss_conf {
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
 	enum nl80211_channel_type channel_type;
+	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
+	u8 arp_addr_cnt;
+	bool arp_filter_enabled;
 };
 
 /**
@@ -1529,16 +1548,6 @@ enum ieee80211_ampdu_mlme_action {
  *	of the bss parameters has changed when a call is made. The callback
  *	can sleep.
  *
- * @configure_arp_filter: Configuration function for hardware ARP query filter.
- *	This function is called with all the IP addresses configured to the
- *	interface as argument - all ARP queries targeted to any of these
- *	addresses must pass through. If the hardware filter does not support
- *	enought addresses, hardware filtering must be disabled. The ifa_list
- *	argument may be NULL, indicating that filtering must be disabled.
- *	This function is called upon association complete with current
- *	address(es), and while associated whenever the IP address(es) change.
- *	The callback can sleep.
- *
  * @prepare_multicast: Prepare for multicast filter configuration.
  *	This callback is optional, and its return value is passed
  *	to configure_filter(). This callback must be atomic.
@@ -1678,9 +1687,6 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
-	int (*configure_arp_filter)(struct ieee80211_hw *hw,
-				    struct ieee80211_vif *vif,
-				    struct in_ifaddr *ifa_list);
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index d1139e4..bbea3bc 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -83,23 +83,6 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 	trace_drv_bss_info_changed(local, sdata, info, changed);
 }
 
-struct in_ifaddr;
-static inline int drv_configure_arp_filter(struct ieee80211_local *local,
-					   struct ieee80211_vif *vif,
-					   struct in_ifaddr *ifa_list)
-{
-	int ret = 0;
-
-	might_sleep();
-
-	if (local->ops->configure_arp_filter)
-		ret = local->ops->configure_arp_filter(&local->hw, vif,
-						       ifa_list);
-
-	trace_drv_configure_arp_filter(local, vif_to_sdata(vif), ifa_list, ret);
-	return ret;
-}
-
 static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 					struct netdev_hw_addr_list *mc_list)
 {
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6b90630..1e293df 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -219,31 +219,6 @@ TRACE_EVENT(drv_bss_info_changed,
 	)
 );
 
-TRACE_EVENT(drv_configure_arp_filter,
-	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
-		 struct in_ifaddr *ifa_list, int ret),
-
-	TP_ARGS(local, sdata, ifa_list, ret),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		VIF_ENTRY
-		__field(int, ret)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		VIF_ASSIGN;
-		__entry->ret = ret;
-	),
-
-	TP_printk(
-		VIF_PR_FMT LOCAL_PR_FMT " ret:%d",
-		VIF_PR_ARG, LOCAL_PR_ARG, __entry->ret
-	)
-);
-
 TRACE_EVENT(drv_prepare_multicast,
 	TP_PROTO(struct ieee80211_local *local, int mc_count, u64 ret),
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4d3883e..79e366e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -517,6 +517,8 @@ struct ieee80211_sub_if_data {
 
 	u16 sequence_number;
 
+	bool arp_filter_state;
+
 	/*
 	 * AP this belongs to: self in AP mode and
 	 * corresponding AP in VLAN mode, NULL for
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5706156..8398d36 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -20,6 +20,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/bitmap.h>
 #include <linux/pm_qos_params.h>
+#include <linux/inetdevice.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
 
@@ -84,12 +85,125 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
 	local->filter_flags = new_flags & ~(1<<31);
 }
 
+#ifdef CONFIG_INET
+static void ieee80211_reconfig_arp_filter(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_managed *ifmgd;
+	struct ieee80211_bss_conf *bss_conf;
+	u32 changed;
+	bool promisc;
+	bool old_state;
+
+	/* Check ARP filtering state for each interface */
+	rtnl_lock();
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+				continue;
+
+		ifmgd = &sdata->u.mgd;
+		mutex_lock(&ifmgd->mtx);
+		if (!ifmgd->associated) {
+			mutex_unlock(&ifmgd->mtx);
+			continue;
+		}
+
+		bss_conf = &sdata->vif.bss_conf;
+
+		old_state = !!(bss_conf->arp_filter_enabled);
+
+		promisc = sdata->flags & IEEE80211_SDATA_PROMISC;
+		if (promisc)
+			bss_conf->arp_filter_enabled = 0;
+		else
+			bss_conf->arp_filter_enabled = sdata->arp_filter_state;
+
+		if (old_state != bss_conf->arp_filter_enabled) {
+			changed = BSS_CHANGED_ARP_FILTER;
+			ieee80211_bss_info_change_notify(sdata, changed);
+		}
+
+		mutex_unlock(&ifmgd->mtx);
+	}
+	rtnl_unlock();
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
+	struct in_device *idev;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_bss_conf *bss_conf;
+	struct ieee80211_if_managed *ifmgd;
+	int c = 0;
+
+	/* Make sure it's our interface that got changed */
+	if (!wdev)
+		return NOTIFY_DONE;
+
+	if (wdev->wiphy != local->hw.wiphy)
+		return NOTIFY_DONE;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
+	bss_conf = &sdata->vif.bss_conf;
+
+	/* ARP filtering is only supported in managed mode */
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return NOTIFY_DONE;
+
+	idev = sdata->dev->ip_ptr;
+	if (!idev)
+		return NOTIFY_DONE;
+
+	ifmgd = &sdata->u.mgd;
+	mutex_lock(&ifmgd->mtx);
+
+	/* Copy the addresses to the bss_conf list */
+	ifa = idev->ifa_list;
+	while (c < IEEE80211_BSS_ARP_ADDR_LIST_LEN && ifa) {
+		bss_conf->arp_addr_list[c] = ifa->ifa_address;
+		ifa = ifa->ifa_next;
+		c++;
+	}
+
+	/* If not all addresses fit the list, disable filtering */
+	if (ifa) {
+		sdata->arp_filter_state = false;
+		c = 0;
+	} else {
+		sdata->arp_filter_state = true;
+	}
+	bss_conf->arp_addr_cnt = c;
+
+	/* Configure driver only if associated and not in promiscuous mode */
+	if (ifmgd->associated && !(sdata->flags & IEEE80211_SDATA_PROMISC)) {
+		bss_conf->arp_filter_enabled = sdata->arp_filter_state;
+		ieee80211_bss_info_change_notify(sdata,
+						 BSS_CHANGED_ARP_FILTER);
+	}
+
+	mutex_unlock(&ifmgd->mtx);
+
+	return NOTIFY_DONE;
+}
+#endif
+
 static void ieee80211_reconfig_filter(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, reconfig_filter);
 
 	ieee80211_configure_filter(local);
+
+#ifdef CONFIG_INET
+	ieee80211_reconfig_arp_filter(local);
+#endif
 }
 
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
@@ -329,60 +443,6 @@ static void ieee80211_recalc_smps_work(struct work_struct *work)
 	mutex_unlock(&local->iflist_mtx);
 }
 
-#ifdef CONFIG_INET
-int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata)
-{
-	struct in_device *idev;
-	int ret = 0;
-
-	BUG_ON(!sdata);
-	ASSERT_RTNL();
-
-	idev = sdata->dev->ip_ptr;
-	if (!idev)
-		return 0;
-
-	ret = drv_configure_arp_filter(sdata->local, &sdata->vif,
-				       idev->ifa_list);
-	return ret;
-}
-
-static int ieee80211_ifa_changed(struct notifier_block *nb,
-				 unsigned long data, void *arg)
-{
-	struct in_ifaddr *ifa = arg;
-	struct ieee80211_local *local =
-		container_of(nb, struct ieee80211_local,
-			     ifa_notifier);
-	struct net_device *ndev = ifa->ifa_dev->dev;
-	struct wireless_dev *wdev = ndev->ieee80211_ptr;
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_managed *ifmgd;
-
-	/* Make sure it's our interface that got changed */
-	if (!wdev)
-		return NOTIFY_DONE;
-
-	if (wdev->wiphy != local->hw.wiphy)
-		return NOTIFY_DONE;
-
-	/* We are concerned about IP addresses only when associated */
-	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
-
-	/* ARP filtering is only supported in managed mode */
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return NOTIFY_DONE;
-
-	ifmgd = &sdata->u.mgd;
-	mutex_lock(&ifmgd->mtx);
-	if (ifmgd->associated)
-		ieee80211_set_arp_filter(sdata);
-	mutex_unlock(&ifmgd->mtx);
-
-	return NOTIFY_DONE;
-}
-#endif
-
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ac68c41..d328e9a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -806,11 +806,12 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 
 	bss_info_changed |= BSS_CHANGED_ASSOC;
 	/* set timing information */
-	sdata->vif.bss_conf.beacon_int = cbss->beacon_interval;
-	sdata->vif.bss_conf.timestamp = cbss->tsf;
+	bss_conf->beacon_int = cbss->beacon_interval;
+	bss_conf->timestamp = cbss->tsf;
 
 	bss_info_changed |= BSS_CHANGED_BEACON_INT;
 	bss_info_changed |= ieee80211_handle_bss_capability(sdata,
@@ -835,7 +836,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_led_assoc(local, 1);
 
-	sdata->vif.bss_conf.assoc = 1;
+	bss_conf->assoc = 1;
 	/*
 	 * For now just always ask the driver to update the basic rateset
 	 * when we have associated, we aren't checking whether it actually
@@ -848,9 +849,18 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	/* Tell the driver to monitor connection quality (if supported) */
 	if ((local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI) &&
-	    sdata->vif.bss_conf.cqm_rssi_thold)
+	    bss_conf->cqm_rssi_thold)
 		bss_info_changed |= BSS_CHANGED_CQM;
 
+#ifdef CONFIG_INET
+	/* Enable ARP filtering unless in promisc mode */
+	if (!(sdata->flags & IEEE80211_SDATA_PROMISC) &&
+	    bss_conf->arp_filter_enabled != sdata->arp_filter_state) {
+		bss_conf->arp_filter_enabled = sdata->arp_filter_state;
+		bss_info_changed |= BSS_CHANGED_ARP_FILTER;
+	}
+#endif
+
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	mutex_lock(&local->iflist_mtx);
@@ -932,6 +942,13 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_hw_config(local, config_changed);
 
+	/* Disable ARP filtering */
+	if (sdata->vif.bss_conf.arp_filter_enabled) {
+		sdata->vif.bss_conf.arp_filter_enabled = false;
+		changed |= BSS_CHANGED_ARP_FILTER;
+	}
+
+
 	/* The BSSID (not really interesting) and HT changed */
 	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
@@ -2116,19 +2133,9 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 			cfg80211_send_assoc_timeout(wk->sdata->dev,
 						    wk->filter_ta);
 			return WORK_DONE_DESTROY;
-#ifdef CONFIG_INET
-		} else {
-			mutex_unlock(&wk->sdata->u.mgd.mtx);
-
-			/*
-			 * configure ARP filter IP addresses to the driver,
-			 * intentionally outside the mgd mutex.
-			 */
-			rtnl_lock();
-			ieee80211_set_arp_filter(wk->sdata);
-			rtnl_unlock();
-#endif
 		}
+
+		mutex_unlock(&wk->sdata->u.mgd.mtx);
 	}
 
 	cfg80211_send_rx_assoc(wk->sdata->dev, skb->data, skb->len);
-- 
1.6.3.3

