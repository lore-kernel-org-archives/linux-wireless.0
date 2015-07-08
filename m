Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758350AbbGHMmU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/10] mac80211: enable changing netdev features with ethtool
Date: Wed,  8 Jul 2015 15:41:52 +0300
Message-Id: <1436359312-26533-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144237_229138_0E3078CD)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

For drivers that have offloading features, these are currently
forced and cannot be modified in any way. Enable that so users
can change the features if needed, but of course this requires
driver interaction.

For AP_VLAN don't allow direct changes but propagate them from
the AP interface.

Additionally, add NETIF_F_RXCSUM to the whitelist, if a driver
has this capability it doesn't have to advertise this but can
just set the skb->checksum field accordingly, but advertising
it will allow it to be changed with ethtool.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h     |  6 ++++++
 net/mac80211/driver-ops.h  | 22 ++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  6 ++++++
 net/mac80211/iface.c       | 39 +++++++++++++++++++++++++++++++++++++++
 net/mac80211/main.c        |  5 +----
 net/mac80211/trace.h       | 28 ++++++++++++++++++++++++++++
 6 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4caef55..6348cd9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3080,6 +3080,8 @@ enum ieee80211_reconfig_type {
  *
  * @get_ringparam: Get tx and rx ring current and maximum sizes.
  *
+ * @set_features: change netdev features for the given virtual interface
+ *
  * @tx_frames_pending: Check if there is any pending frame in the hardware
  *	queues before entering power save.
  *
@@ -3384,6 +3386,10 @@ struct ieee80211_ops {
 	int (*set_ringparam)(struct ieee80211_hw *hw, u32 tx, u32 rx);
 	void (*get_ringparam)(struct ieee80211_hw *hw,
 			      u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
+	int (*set_features)(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    netdev_features_t features,
+			    netdev_features_t changed);
 	bool (*tx_frames_pending)(struct ieee80211_hw *hw);
 	int (*set_bitrate_mask)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				const struct cfg80211_bitrate_mask *mask);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 32a2e70..b955586 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -895,6 +895,28 @@ static inline void drv_get_ringparam(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_set_features(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata,
+				   netdev_features_t features,
+				   netdev_features_t changed)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_set_features(local, sdata, features, changed);
+	if (local->ops->set_features)
+		ret = local->ops->set_features(&local->hw,
+					       &sdata->vif,
+					       features, changed);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 static inline bool drv_tx_frames_pending(struct ieee80211_local *local)
 {
 	bool ret = false;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 38db179..1d165a4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -83,6 +83,12 @@ struct ieee80211_local;
 
 #define IEEE80211_DEAUTH_FRAME_LEN	(24 /* hdr */ + 2 /* reason */)
 
+/* Only these features can be passed through mac80211 */
+#define IEEE80211_SUPPORTED_NETDEV_FEATURES	\
+	(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM |	\
+	 NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_HIGHDMA |		\
+	 NETIF_F_GSO_SOFTWARE)
+
 struct ieee80211_fragment_entry {
 	struct sk_buff_head skb_list;
 	unsigned long first_frag_time;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e3bb35f..cf5405f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2006 Jiri Benc <jbenc@suse.cz>
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2015	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1131,6 +1132,43 @@ ieee80211_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	return stats;
 }
 
+static int ieee80211_netdev_set_features(struct net_device *dev,
+					 netdev_features_t features)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	netdev_features_t changed = dev->features ^ features;
+	int ret;
+
+	if (!(changed & IEEE80211_SUPPORTED_NETDEV_FEATURES))
+		return 0;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_AP_VLAN:
+		/* these aren't known to the driver */
+		return -EOPNOTSUPP;
+	default:
+		break;
+	}
+
+	ret = drv_set_features(local, sdata, features, changed);
+	if (ret)
+		return ret;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		struct ieee80211_sub_if_data *vlan;
+
+		/* propagate to VLANs as they're dependent */
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
+			vlan->dev->features = features;
+			netdev_update_features(vlan->dev);
+		}
+	}
+
+	return 0;
+}
+
 static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_open		= ieee80211_open,
 	.ndo_stop		= ieee80211_stop,
@@ -1141,6 +1179,7 @@ static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_set_mac_address 	= ieee80211_change_mac,
 	.ndo_select_queue	= ieee80211_netdev_select_queue,
 	.ndo_get_stats64	= ieee80211_get_stats64,
+	.ndo_set_features	= ieee80211_netdev_set_features,
 };
 
 static u16 ieee80211_monitor_select_queue(struct net_device *dev,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6b830c6..5b82e6c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -846,10 +846,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		}
 	}
 
-	/* Only HW csum features are currently compatible with mac80211 */
-	feature_whitelist = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			    NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_HIGHDMA |
-			    NETIF_F_GSO_SOFTWARE;
+	feature_whitelist = IEEE80211_SUPPORTED_NETDEV_FEATURES;
 	if (WARN_ON(hw->netdev_features & ~feature_whitelist ||
 		    hw->netdev_hw_features & ~feature_whitelist))
 		return -EINVAL;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 6f14591..755e9fa 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1193,6 +1193,34 @@ TRACE_EVENT(drv_get_ringparam,
 	)
 );
 
+TRACE_EVENT(drv_set_features,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 netdev_features_t features,
+		 netdev_features_t changed),
+
+	TP_ARGS(local, sdata, features, changed),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(netdev_features_t, features)
+		__field(netdev_features_t, changed)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->features = features;
+		__entry->changed = changed;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT " features=0x%llx, changed=0x%llx",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->features, __entry->changed
+	)
+);
+
 DEFINE_EVENT(local_only_evt, drv_tx_frames_pending,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
-- 
2.1.4

