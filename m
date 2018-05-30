Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932075AbeE3TLE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 15:11:04 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv3 1/4] cfg80211: Add support to configure station specific txrate threshold
Date: Thu, 31 May 2018 00:40:47 +0530
Message-Id: <1527707450-2985-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180530_211110_950415_A25EEE11)
In-Reply-To: <1527707450-2985-1-git-send-email-tamizhr@codeaurora.org>
References: <1527707450-2985-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to configure station specific txrate threshold
to monitor variation in the txrate for a station. Configuration
is passed using NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD and
NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD in NL80211_CMD_SET_STA_MON
command and the configuration will be represented in 100kbps.
This will be useful for the application like steering which requires
station's current capability.

Driver supporting this configuration feature should advertise
NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |  9 +++++++++
 include/uapi/linux/nl80211.h | 34 ++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 40 ++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 17 +++++++++++++++++
 net/wireless/trace.h         | 25 +++++++++++++++++++++++++
 5 files changed, 125 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ffd1204..ab8a43f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3035,6 +3035,10 @@ struct cfg80211_external_auth_params {
  *	The driver should advertise %NL80211_EXT_FEATURE_STA_MON_RSSI_LIST if
  *	this method is implemented. If it is provided then there's no point
  *	providing @set_sta_mon_rssi_config
+ * @set_sta_mon_txrate_config: Configure low and high TXRATE threshold in 100kbs
+ *	for a connected station. The driver should(soon) send an event
+ *	indicating the current attempted frame txrate level is above/below the
+ *	configured threshold
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3348,6 +3352,11 @@ struct cfg80211_ops {
 						 struct net_device *dev,
 						 const u8 *addr,
 						 s32 rssi_low, s32 rssi_high);
+	int	(*set_sta_mon_txrate_config)(struct wiphy *wiphy,
+					     struct net_device *dev,
+					     const u8 *addr,
+					     u32 low_txrate_thold,
+					     u32 high_txrate_thold);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 8e2a84b..c7ce475 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4301,6 +4301,15 @@ enum nl80211_ps_state {
  * @NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT: RSSI threshold event
  * @NL80211_ATTR_STA_MON_RSSI_LEVEL: the RSSI value in dBm that triggered the
  *	RSSI threshold event.
+ * @NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD: TX_RATE threshold in 100kbps. This
+ *	u32 attribute specifies the low txrate threshold. Event will be sent
+ *	if the txrate for a station goes lesser than this threshold.
+ * @NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD: TX_RATE threshold in 100kbps. This
+ *	u32 attribute specifies the upper txrate threshold. Event will be sent
+ *	if the txrate for a station goes greater than this threshold.
+ * @NL80211_ATTR_STA_MON_TXRATE_THRESHOLD_EVENT: TX_RATE threshold cross event
+ * @NL80211_ATTR_STA_MON_TXRATE_LEVEL: TXRATE for a station in 100kbps that
+ *	triggered the TX_RATE threshold cross event.
  */
 enum nl80211_attr_sta_mon {
 	__NL80211_ATTR_STA_MON_INVALID,
@@ -4308,6 +4317,10 @@ enum nl80211_attr_sta_mon {
 	NL80211_ATTR_STA_MON_RSSI_HYST,
 	NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT,
 	NL80211_ATTR_STA_MON_RSSI_LEVEL,
+	NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD,
+	NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD,
+	NL80211_ATTR_STA_MON_TXRATE_THRESHOLD_EVENT,
+	NL80211_ATTR_STA_MON_TXRATE_LEVEL,
 
 	/* keep last */
 	__NL80211_ATTR_STA_MON_AFTER_LAST,
@@ -4327,6 +4340,21 @@ enum nl80211_sta_mon_rssi_threshold_event {
 };
 
 /**
+ * enum nl80211_sta_mon_txrate_threshold_event - TX_RATE threshold event
+ * @NL80211_STA_MON_TXRATE_THRESHOLD_IN_RANGE: The TX_RATE level is in between
+ *	low and high threshold
+ * @NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_LOW: The TX_RATE level is lower than
+ *	the configured threshold
+ * @NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_HIGH: The TX_RATE is higher than the
+ *	configured threshold
+ */
+enum nl80211_sta_mon_txrate_threshold_event {
+	NL80211_STA_MON_TXRATE_THRESHOLD_IN_RANGE,
+	NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_LOW,
+	NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_HIGH,
+};
+
+/**
  * enum nl80211_attr_cqm - connection quality monitor attributes
  * @__NL80211_ATTR_CQM_INVALID: invalid
  * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm. This value specifies
@@ -5191,6 +5219,11 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_STA_MON_RSSI_LIST: With this driver the
  *	%NL80211_ATTR_STA_MON_RSSI_THOLD attribute accepts a list of zero or
  *	more RSSI threshold values to monitor rather than exactly one threshold.
+ * @NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG: With this driver will accept
+ *	%NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD attribute as low txrate and
+ *	%NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD attribute as high txrate
+ *	for AP/AP_VLAN/P2P_GO interface to monitor txrate for the connected
+ *	stations and the drvier should advertise txrate via ieee80211_tx_status.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5227,6 +5260,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_TXQS,
 	NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG,
 	NL80211_EXT_FEATURE_STA_MON_RSSI_LIST,
+	NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c0fccb4..31680d6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10138,6 +10138,10 @@ static int nl80211_set_cqm_txe(struct genl_info *info,
 	[NL80211_ATTR_STA_MON_RSSI_HYST] = { .type = NLA_U32 },
 	[NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
 	[NL80211_ATTR_STA_MON_RSSI_LEVEL] = { .type = NLA_S32 },
+	[NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_TXRATE_THRESHOLD_EVENT] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_TXRATE_LEVEL] = { .type = NLA_U32 },
 };
 
 static int cfg80211_set_rssi_range(struct cfg80211_registered_device *rdev,
@@ -13016,6 +13020,27 @@ static int nl80211_set_sta_mon_rssi(struct genl_info *info,
 	return err;
 }
 
+static int nl80211_set_sta_mon_txrate(struct genl_info *info, const u8 *addr,
+				      u32 low_thold, u32 high_thold)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_sta_mon_txrate_config)
+		return -EOPNOTSUPP;
+
+	if ((wdev->iftype != NL80211_IFTYPE_AP &&
+	     wdev->iftype != NL80211_IFTYPE_P2P_GO &&
+	     wdev->iftype != NL80211_IFTYPE_AP_VLAN) ||
+	    (!wiphy_ext_feature_isset(&rdev->wiphy,
+			      NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG)))
+		return -EOPNOTSUPP;
+
+	return rdev_set_sta_mon_txrate_config(rdev, dev, addr, low_thold,
+					      high_thold);
+}
+
 static int nl80211_sta_mon(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attrs[NL80211_ATTR_STA_MON_MAX + 1];
@@ -13049,6 +13074,21 @@ static int nl80211_sta_mon(struct sk_buff *skb, struct genl_info *info)
 		return nl80211_set_sta_mon_rssi(info, addr, tholds, len / 4,
 						hysteresis);
 	}
+
+	if (attrs[NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD] &&
+	    attrs[NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD]) {
+		u32 low_thold =
+		    nla_get_u32(attrs[NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD]);
+		u32 high_thold =
+		    nla_get_u32(attrs[NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD]);
+
+		if (low_thold > high_thold)
+			return -EINVAL;
+
+		return nl80211_set_sta_mon_txrate(info, addr, low_thold,
+						  high_thold);
+	}
+
 	return -EINVAL;
 }
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 1184e4a..1fc5089 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1263,4 +1263,21 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_sta_mon_txrate_config(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev, const u8 *peer,
+			       u32 low_txrate_thold, u32 high_txrate_thold)
+{
+	int ret;
+
+	trace_rdev_set_sta_mon_txrate_config(&rdev->wiphy, dev, peer,
+					     low_txrate_thold,
+					     high_txrate_thold);
+	ret = rdev->ops->set_sta_mon_txrate_config(&rdev->wiphy, dev, peer,
+						   low_txrate_thold,
+						   high_txrate_thold);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 76c422c..ca985c2 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3330,6 +3330,31 @@
 		  NETDEV_PR_ARG, MAC_PR_ARG(peer),
 		  __entry->rssi_event, __entry->rssi_level)
 );
+
+TRACE_EVENT(rdev_set_sta_mon_txrate_config,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct net_device *netdev, const u8 *peer,
+		 u32 low_txrate_thold, u32 high_txrate_thold),
+	TP_ARGS(wiphy, netdev, peer, low_txrate_thold, high_txrate_thold),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(u32, low_txrate_thold)
+		__field(u32, high_txrate_thold)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->low_txrate_thold = low_txrate_thold;
+		__entry->high_txrate_thold = high_txrate_thold;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT
+		  ", low_txrate_thold: %u, high_txrate_thold: %u ",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->low_txrate_thold, __entry->high_txrate_thold)
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1
