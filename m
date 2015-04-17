Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47626 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbbDQPQG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 11:16:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>
Subject: [PATCH 09/11] mac80211: enable changing netdev features with ethtool
Date: Fri, 17 Apr 2015 17:15:49 +0200
Message-Id: <1429283751-5104-9-git-send-email-johannes@sipsolutions.net> (sfid-20150417_171614_135235_4C4440A4)
In-Reply-To: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

For drivers that have offloading features, these are currently
forced and cannot be modified in any way. Enable that so users
can change the features if needed, but of course this requires
driver interaction.

For AP_VLAN don't allow direct changes but propagate them from
the AP interface.

To make this even possible, set dev->hw_features initially so
that there's something that can be modified.

Additionally, add NETIF_F_RXCSUM to the whitelist, if a driver
has this capability it doesn't have to advertise this but can
just set the skb->checksum field accordingly, but advertising
it will allow it to be changed with ethtool.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  6 ++++++
 net/mac80211/driver-ops.h  | 22 ++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  5 +++++
 net/mac80211/iface.c       | 39 +++++++++++++++++++++++++++++++++++++++
 net/mac80211/main.c        |  6 +-----
 net/mac80211/trace.h       | 28 ++++++++++++++++++++++++++++
 6 files changed, 101 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9001bd685b1e..0f7fbdb31318 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2998,6 +2998,8 @@ enum ieee80211_reconfig_type {
  *
  * @get_ringparam: Get tx and rx ring current and maximum sizes.
  *
+ * @set_features: change netdev features for the given virtual interface
+ *
  * @tx_frames_pending: Check if there is any pending frame in the hardware
  *	queues before entering power save.
  *
@@ -3301,6 +3303,10 @@ struct ieee80211_ops {
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
index 26e1ca8a474a..a0cd94a9a0b1 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -894,6 +894,28 @@ static inline void drv_get_ringparam(struct ieee80211_local *local,
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
index 09a15a855c5a..3f837fea05ae 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -83,6 +83,11 @@ struct ieee80211_local;
 
 #define IEEE80211_DEAUTH_FRAME_LEN	(24 /* hdr */ + 2 /* reason */)
 
+/* Only these features can be passed through mac80211 */
+#define IEEE80211_SUPPORTED_NETDEV_FEATURES	\
+	(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |	\
+	 NETIF_F_HW_CSUM | NETIF_F_RXCSUM)
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b4ac596a7cb7..5cdac668d532 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1101,6 +1101,43 @@ static void ieee80211_uninit(struct net_device *dev)
 	ieee80211_teardown_sdata(IEEE80211_DEV_TO_SUB_IF(dev));
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
+			netdev_features_change(vlan->dev);
+		}
+	}
+
+	return 0;
+}
+
 static u16 ieee80211_netdev_select_queue(struct net_device *dev,
 					 struct sk_buff *skb,
 					 void *accel_priv,
@@ -1118,6 +1155,7 @@ static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_change_mtu 	= ieee80211_change_mtu,
 	.ndo_set_mac_address 	= ieee80211_change_mac,
 	.ndo_select_queue	= ieee80211_netdev_select_queue,
+	.ndo_set_features	= ieee80211_netdev_set_features,
 };
 
 static u16 ieee80211_monitor_select_queue(struct net_device *dev,
@@ -1781,6 +1819,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		}
 
 		ndev->features |= local->hw.netdev_features;
+		ndev->hw_features |= local->hw.netdev_features;
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index df3051d96aff..3ffae3714f36 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -789,7 +789,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	enum ieee80211_band band;
 	int channels, max_bitrates;
 	bool supp_ht, supp_vht;
-	netdev_features_t feature_whitelist;
 	struct cfg80211_chan_def dflt_chandef = {};
 
 	if (hw->flags & IEEE80211_HW_QUEUE_CONTROL &&
@@ -838,10 +837,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		}
 	}
 
-	/* Only HW csum features are currently compatible with mac80211 */
-	feature_whitelist = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			    NETIF_F_HW_CSUM;
-	if (WARN_ON(hw->netdev_features & ~feature_whitelist))
+	if (WARN_ON(hw->netdev_features & ~IEEE80211_SUPPORTED_NETDEV_FEATURES))
 		return -EINVAL;
 
 	if (hw->max_report_rates == 0)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 790bd45081c4..4439a0ddabba 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1191,6 +1191,34 @@ TRACE_EVENT(drv_get_ringparam,
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

