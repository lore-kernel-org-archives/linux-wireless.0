Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3ANOQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 09:16:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: allow drivers to access IPv6 information
Date: Mon, 14 Jan 2013 15:16:50 +0100
Message-Id: <1358173010-16985-1-git-send-email-johannes@sipsolutions.net> (sfid-20130114_151631_494051_DB12C072)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To be able to implement NS response offloading (in
regular operation or while in WoWLAN) drivers need
to know the IPv6 addresses assigned to interfaces.
Implement an IPv6 notifier in mac80211 to call the
driver when addresses change.

Unlike for IPv4, implement it as a callback rather
than as a list in the BSS configuration, that is
more flexible.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 10 ++++++++++
 net/mac80211/driver-ops.h  | 12 ++++++++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/main.c        | 45 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h       |  8 ++++++++
 5 files changed, 76 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 23daed3..1921da3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2487,6 +2487,10 @@ enum ieee80211_rate_control_changed {
  * @restart_complete: Called after a call to ieee80211_restart_hw(), when the
  *	reconfiguration has completed. This can help the driver implement the
  *	reconfiguration step. This callback may sleep.
+ *
+ * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
+ *	Currently, this is only called for managed or P2P client interfaces.
+ *	This callback is optional; it must not sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2660,6 +2664,12 @@ struct ieee80211_ops {
 				     struct ieee80211_chanctx_conf *ctx);
 
 	void (*restart_complete)(struct ieee80211_hw *hw);
+
+#ifdef CONFIG_IPV6
+	void (*ipv6_addr_change)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct inet6_dev *idev);
+#endif
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0c07f94..0b60392 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1020,4 +1020,16 @@ static inline void drv_restart_complete(struct ieee80211_local *local)
 	trace_drv_return_void(local);
 }
 
+#ifdef CONFIG_IPV6
+static inline void drv_ipv6_addr_change(struct ieee80211_local *local,
+					struct ieee80211_sub_if_data *sdata,
+					struct inet6_dev *idev)
+{
+	trace_drv_ipv6_addr_change(local, sdata);
+	if (local->ops->ipv6_addr_change)
+		local->ops->ipv6_addr_change(&local->hw, &sdata->vif, idev);
+	trace_drv_return_void(local);
+}
+#endif
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0fa44a9..93cfa90 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1129,6 +1129,7 @@ struct ieee80211_local {
 	struct timer_list dynamic_ps_timer;
 	struct notifier_block network_latency_notifier;
 	struct notifier_block ifa_notifier;
+	struct notifier_block ifa6_notifier;
 
 	/*
 	 * The dynamic ps timeout configured from user space via WEXT -
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 39cfe8f..08ac59d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -23,6 +23,7 @@
 #include <linux/inetdevice.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
+#include <net/addrconf.h>
 
 #include "ieee80211_i.h"
 #include "driver-ops.h"
@@ -377,6 +378,37 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 }
 #endif
 
+#ifdef CONFIG_IPV6
+static int ieee80211_ifa6_changed(struct notifier_block *nb,
+				  unsigned long data, void *arg)
+{
+	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)arg;
+	struct inet6_dev *idev = ifa->idev;
+	struct net_device *ndev = ifa->idev->dev;
+	struct ieee80211_local *local =
+		container_of(nb, struct ieee80211_local, ifa6_notifier);
+	struct wireless_dev *wdev = ndev->ieee80211_ptr;
+	struct ieee80211_sub_if_data *sdata;
+
+	/* Make sure it's our interface that got changed */
+	if (!wdev || wdev->wiphy != local->hw.wiphy)
+		return NOTIFY_DONE;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
+
+	/*
+	 * For now only support station mode. This is mostly because
+	 * doing AP would have to handle AP_VLAN in some way ...
+	 */
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return NOTIFY_DONE;
+
+	drv_ipv6_addr_change(local, sdata, idev);
+
+	return NOTIFY_DONE;
+}
+#endif
+
 static int ieee80211_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct ieee80211_local *local =
@@ -985,12 +1017,25 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_ifa;
 #endif
 
+#ifdef CONFIG_IPV6
+	local->ifa6_notifier.notifier_call = ieee80211_ifa6_changed;
+	result = register_inet6addr_notifier(&local->ifa6_notifier);
+	if (result)
+		goto fail_ifa6;
+#endif
+
 	netif_napi_add(&local->napi_dev, &local->napi, ieee80211_napi_poll,
 			local->hw.napi_weight);
 
 	return 0;
 
+#ifdef CONFIG_IPV6
+ fail_ifa6:
 #ifdef CONFIG_INET
+	unregister_inetaddr_notifier(&local->ifa_notifier);
+#endif
+#endif
+#if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
 	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
 			       &local->network_latency_notifier);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a8270b4..cad8629 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1426,6 +1426,14 @@ DEFINE_EVENT(local_only_evt, drv_restart_complete,
 	TP_ARGS(local)
 );
 
+#ifdef CONFIG_IPV6
+DEFINE_EVENT(local_sdata_evt, drv_ipv6_addr_change,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
+);
+#endif
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.8.0

