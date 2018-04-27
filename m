Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757320AbeD0Fa0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 01:30:26 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv2 4/6] cfg80211: Add support to configure station specific txrate threshold for AP mode
Date: Fri, 27 Apr 2018 11:00:34 +0530
Message-Id: <1524807036-28056-5-git-send-email-tamizhr@codeaurora.org> (sfid-20180427_073038_118517_82372D15)
In-Reply-To: <1524807036-28056-1-git-send-email-tamizhr@codeaurora.org>
References: <1524807036-28056-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add support to configure station specific txrate threshold
to monitor change in txrate for stations. This will be useful
for the user application like steering to configure and monitor the
change event of txrate for the station.

NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD and NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD
used with NL80211_CMD_STA_MON command to configure the txrate threshold and
the configuration will be represented in 100kbps.

cfg80211_sta_mon_txrate_notify introduce to notify txrate for a station
goes out of range using NL80211_CMD_NOTIFY_STA_MON command.

NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG flag needs to be advertised by the
drvier to allow and monitor txrate threshold configuration.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       | 26 ++++++++++++++++
 include/uapi/linux/nl80211.h | 34 ++++++++++++++++++++
 net/wireless/nl80211.c       | 74 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 17 ++++++++++
 net/wireless/trace.h         | 49 +++++++++++++++++++++++++++++
 5 files changed, 200 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7e7a0bf..4456e2e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2984,6 +2984,10 @@ struct cfg80211_external_auth_params {
  *	The driver should set %NL80211_EXT_FEATURE_STA_MON_RSSI_LIST if this
  *	method is implemented. If it is provided then there's no point providing
  *	@set_sta_mon_rssi_config.
+ * @set_sta_mon_txrate_config: Configure low and high TXRATE threshold in 100kbs
+ *	for a connected station. The driver should(soon) send an event
+ *	indicating the current attempted frame txrate level is above/below the
+ *	configured threshold.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3293,6 +3297,11 @@ struct cfg80211_ops {
 						 struct net_device *dev,
 						 const u8 *addr,
 						 s32 rssi_low, s32 rssi_high);
+	int     (*set_sta_mon_txrate_config)(struct wiphy *wiphy,
+					     struct net_device *dev,
+					     const u8 *addr,
+					     u32 low_txrate_thold,
+					     u32 high_txrate_thold);
 };
 
 /*
@@ -5813,6 +5822,23 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 		     s32 rssi_level, gfp_t gfp);
 
 /**
+ * cfg80211_sta_mon_txrate_notify - txrate event for connected stations
+ * @dev: network device
+ * @peer: peer's MAC address
+ * @txrate_event: the triggered TX RATE event
+ * @txrate_level: new TX RATE level value or 0 if not available
+ * @gfp: context flags
+ *
+ * This function is called when a average of attempted frame txrate crossed
+ * above configured high txrate or below configured low txrate event
+ * occurs for a station.
+ */
+void
+cfg80211_sta_mon_txrate_notify(struct net_device *dev, const u8 *peer,
+		enum nl80211_sta_mon_txrate_threshold_event txrate_event,
+		u32 txrate_level, gfp_t gfp);
+
+/**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
  * @dev: network device
  * @peer: peer's MAC address
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fa1fed1..a8b5e3d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4266,6 +4266,15 @@ enum nl80211_attr_cqm {
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
@@ -4273,6 +4282,10 @@ enum nl80211_attr_sta_mon {
 	NL80211_ATTR_STA_MON_RSSI_HYST,
 	NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT,
 	NL80211_ATTR_STA_MON_RSSI_LEVEL,
+	NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD,
+	NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD,
+	NL80211_ATTR_STA_MON_TXRATE_THRESHOLD_EVENT,
+	NL80211_ATTR_STA_MON_TXRATE_LEVEL,
 
 	/* keep last */
 	__NL80211_ATTR_STA_MON_AFTER_LAST,
@@ -4305,6 +4318,21 @@ enum nl80211_sta_mon_rssi_threshold_event {
 	NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH,
 };
 
+/**
+ * enum nl80211_sta_mon_txrate_threshold_event - TX_RATE threshold event
+ * @NL80211_STA_MON_TXRATE_THRESHOLD_IN_RANGE: The TX_RATE level is in between
+ *	low and high threshold
+ * @NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_LOW: The TX_RATE level is lower than
+ *	the configured threshold
+ * @NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_HIGH: The TX_RATE is higher than the
+ *      configured threshold
+ */
+enum nl80211_sta_mon_txrate_threshold_event {
+	NL80211_STA_MON_TXRATE_THRESHOLD_IN_RANGE,
+	NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_LOW,
+	NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_HIGH,
+};
+
 
 /**
  * enum nl80211_tx_power_setting - TX power adjustment
@@ -5100,6 +5128,11 @@ enum nl80211_feature_flags {
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
@@ -5134,6 +5167,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
 	NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG,
 	NL80211_EXT_FEATURE_STA_MON_RSSI_LIST,
+	NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 382dc63..7268371 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9872,6 +9872,10 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
 	[NL80211_ATTR_STA_MON_RSSI_HYST] = { .type = NLA_U32 },
 	[NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
 	[NL80211_ATTR_STA_MON_RSSI_LEVEL] = { .type = NLA_S32 },
+	[NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_TXRATE_THRESHOLD_EVENT] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_TXRATE_LEVEL] = { .type = NLA_U32 },
 };
 
 static int nl80211_set_cqm_txe(struct genl_info *info,
@@ -12777,6 +12781,27 @@ static int nl80211_set_sta_mon_rssi(struct genl_info *info,
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
+			NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG)))
+		return -EOPNOTSUPP;
+
+	return rdev_set_sta_mon_txrate_config(rdev, dev, addr, low_thold,
+					      high_thold);
+}
+
 static int nl80211_sta_mon(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attrs[NL80211_ATTR_STA_MON_MAX + 1];
@@ -12812,6 +12837,19 @@ static int nl80211_sta_mon(struct sk_buff *skb, struct genl_info *info)
 				hysteresis);
 	}
 
+	if (attrs[NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD] &&
+	    attrs[NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD]) {
+		u32 low_thold =
+		     nla_get_u32(attrs[NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD]);
+		u32 high_thold =
+		     nla_get_u32(attrs[NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD]);
+
+		if (low_thold > high_thold)
+			return -EINVAL;
+
+		return nl80211_set_sta_mon_txrate(info, addr, low_thold,
+						  high_thold);
+	}
 	return -EINVAL;
 }
 
@@ -15007,6 +15045,42 @@ void cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
 }
 EXPORT_SYMBOL(cfg80211_sta_mon_rssi_notify);
 
+void
+cfg80211_sta_mon_txrate_notify(struct net_device *dev, const u8 *peer,
+		enum nl80211_sta_mon_txrate_threshold_event txrate_event,
+		u32 txrate_level, gfp_t gfp)
+{
+	struct sk_buff *msg;
+
+	trace_cfg80211_sta_mon_txrate_notify(dev, peer, txrate_event,
+					     txrate_level);
+
+	if (WARN_ON(txrate_event !=
+			NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_LOW &&
+		    txrate_event !=
+			NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_HIGH))
+		return;
+
+	msg = cfg80211_prepare_sta_mon(dev, peer, gfp);
+	if (!msg)
+		return;
+
+	if (nla_put_u32(msg, NL80211_ATTR_STA_MON_TXRATE_THRESHOLD_EVENT,
+			txrate_event))
+		goto nla_put_failure;
+
+	if (txrate_level && nla_put_u32(msg, NL80211_ATTR_STA_MON_TXRATE_LEVEL,
+					txrate_level))
+		goto nla_put_failure;
+
+	cfg80211_send_sta_mon(msg, gfp);
+
+	return;
+nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_sta_mon_txrate_notify);
+
 static struct sk_buff *cfg80211_prepare_cqm(struct net_device *dev,
 					    const char *mac, gfp_t gfp)
 {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 47562b9..5c3289c 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1251,4 +1251,21 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
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
index 78ff0f2..1819411 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1390,6 +1390,55 @@
 		  __entry->rssi_low, __entry->rssi_high)
 );
 
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
+
+TRACE_EVENT(cfg80211_sta_mon_txrate_notify,
+	TP_PROTO(struct net_device *netdev, const u8 *peer,
+		 enum nl80211_sta_mon_txrate_threshold_event txrate_event,
+		 u32 txrate_level),
+	TP_ARGS(netdev, peer, txrate_event, txrate_level),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(enum nl80211_sta_mon_txrate_threshold_event,
+			txrate_event)
+		__field(u32, txrate_level)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->txrate_event = txrate_event;
+		__entry->txrate_level = txrate_level;
+	),
+	TP_printk(NETDEV_PR_FMT ", peer: " MAC_PR_FMT
+		  ", tx_rate event: %d, txrate : %u",
+		  NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->txrate_event, __entry->txrate_level)
+);
+
 TRACE_EVENT(rdev_set_cqm_txe_config,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u32 rate,
 		 u32 pkts, u32 intvl),
-- 
1.9.1
