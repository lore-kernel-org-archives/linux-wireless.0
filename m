Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48456 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753627AbeE3TJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 15:09:00 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv3 2/7] cfg80211: Add new NL command to configure peer specific rssi threshold
Date: Thu, 31 May 2018 00:38:41 +0530
Message-Id: <1527707326-2822-3-git-send-email-tamizhr@codeaurora.org> (sfid-20180530_210908_567165_E65C9B50)
In-Reply-To: <1527707326-2822-1-git-send-email-tamizhr@codeaurora.org>
References: <1527707326-2822-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add support to configure peer specific rssi configuration
to monitor station's signal strength variation.
New NL80211_CMD_SET_STA_MON introduced to configure rssi threshold
and hysteresis info using NL80211_ATTR_STA_MON_RSSI_THOLD and
NL80211_ATTR_STA_MON_RSSI_HYST along with NL80211_ATTR_MAC.
Driver supporting this configuration should advertise
NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG.
Monitoring station's signal strength variation will be useful
for the application like steering.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |  9 ++++++
 include/uapi/linux/nl80211.h | 55 +++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 77 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 16 +++++++++
 net/wireless/trace.h         | 25 ++++++++++++++
 5 files changed, 182 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 656031e..8e4c7db 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3024,6 +3024,11 @@ struct cfg80211_external_auth_params {
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
  *	tells the driver that the frame should not be encrypted.
+ * @set_sta_mon_rssi_config: Configure  RSSI threshold for a station.
+ *	After configuration, the driver should (soon) send an event indicating
+ *	the current level of a station is above/below the configured threshold;
+ *	this may need some care when the configuration is changed
+ *	(without first being disabled.)
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3329,6 +3334,10 @@ struct cfg80211_ops {
 				   const u8 *buf, size_t len,
 				   const u8 *dest, const __be16 proto,
 				   const bool noencrypt);
+	int	(*set_sta_mon_rssi_config)(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   const u8 *addr,
+					   s32 rssi_thold, u32 rssi_hyst);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 28b3654..f13ad07 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1033,6 +1033,9 @@
  *	&NL80211_ATTR_CHANNEL_WIDTH,&NL80211_ATTR_NSS attributes with its
  *	address(specified in &NL80211_ATTR_MAC).
  *
+ * @NL80211_CMD_SET_STA_MON: This command is used to configure station's
+ *	connection monitoring notification trigger levels.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1245,6 +1248,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CONTROL_PORT_FRAME,
 
+	NL80211_CMD_SET_STA_MON,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2238,6 +2243,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_TXQ_QUANTUM: TXQ scheduler quantum (bytes). Number of bytes
  *      a flow is assigned on each round of the DRR scheduler.
  *
+ * @NL80211_ATTR_STA_MON: Station's connection monitor configuration in a
+ *	nested attribute with %NL80211_ATTR_STA_MON_* sub-attributes.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2677,6 +2685,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TXQ_MEMORY_LIMIT,
 	NL80211_ATTR_TXQ_QUANTUM,
 
+	NL80211_ATTR_STA_MON,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4276,6 +4286,46 @@ enum nl80211_ps_state {
 };
 
 /**
+ * enum nl80211_attr_sta_mon - Attributes to monitor station's connection
+ * @NL80211_ATTR_STA_MON_RSSI_THOLD: RSSI threshold in dBm. This value specifies
+ *	the threshold for the RSSI level at which an event will be sent. Zero
+ *	to disable.  Alternatively, if %NL80211_EXT_FEATURE_STA_MON_RSSI_LIST is
+ *	set, multiple values can be supplied as a low-to-high sorted array of\
+ *	threshold values in dBm.  Events will be sent when the RSSI value
+ *	crosses any of the thresholds. This threshold values are station
+ *	specific.
+ * @NL80211_ATTR_STA_MON_RSSI_HYST: RSSI hysteresis in dBm. This value specifies
+ *	the minimum amount the RSSI level must change after an event before a
+ *	new event may be issued (to reduce effects of RSSI oscillation).
+ * @NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT: RSSI threshold event
+ * @NL80211_ATTR_STA_MON_RSSI_LEVEL: the RSSI value in dBm that triggered the
+ *	RSSI threshold event.
+ */
+enum nl80211_attr_sta_mon {
+	__NL80211_ATTR_STA_MON_INVALID,
+	NL80211_ATTR_STA_MON_RSSI_THOLD,
+	NL80211_ATTR_STA_MON_RSSI_HYST,
+	NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT,
+	NL80211_ATTR_STA_MON_RSSI_LEVEL,
+
+	/* keep last */
+	__NL80211_ATTR_STA_MON_AFTER_LAST,
+	NL80211_ATTR_STA_MON_MAX = __NL80211_ATTR_STA_MON_AFTER_LAST - 1,
+};
+
+/**
+ * enum nl80211_sta_mon_rssi_threshold_event - RSSI threshold event
+ * @NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW: The RSSI level is lower than the
+ *	configured threshold
+ * @NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH: The RSSI is higher than the
+ *	configured threshold
+ */
+enum nl80211_sta_mon_rssi_threshold_event {
+	NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW,
+	NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH,
+};
+
+/**
  * enum nl80211_attr_cqm - connection quality monitor attributes
  * @__NL80211_ATTR_CQM_INVALID: invalid
  * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm. This value specifies
@@ -5134,6 +5184,10 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_TXQS: Driver supports FQ-CoDel-enabled intermediate
  *      TXQs.
  *
+ * @NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG: With this driver can set
+ *	rssi threshold using %NL80211_ATTR_STA_MON_RSSI_THOLD attribute
+ *	for a connected station.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5167,6 +5221,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
 	NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT,
 	NL80211_EXT_FEATURE_TXQS,
+	NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2fb2e97..587a5cb1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -428,6 +428,7 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_TXQ_LIMIT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TXQ_MEMORY_LIMIT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -10131,6 +10132,14 @@ static int nl80211_set_cqm_txe(struct genl_info *info,
 	return rdev_set_cqm_txe_config(rdev, dev, rate, pkts, intvl);
 }
 
+static const struct nla_policy
+nl80211_attr_sta_mon_policy[NL80211_ATTR_STA_MON_MAX + 1] = {
+	[NL80211_ATTR_STA_MON_RSSI_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_RSSI_HYST] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
+	[NL80211_ATTR_STA_MON_RSSI_LEVEL] = { .type = NLA_S32 },
+};
+
 static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 				    struct net_device *dev)
 {
@@ -12912,6 +12921,66 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_set_sta_mon_rssi(struct genl_info *info,
+				    const u8 *peer, s32 threshold,
+				    u32 hysteresis)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (threshold > 0)
+		return -EINVAL;
+
+	if (threshold == 0)
+		hysteresis = 0;
+
+	if (!rdev->ops->set_sta_mon_rssi_config)
+		return -EOPNOTSUPP;
+
+	if ((wdev->iftype != NL80211_IFTYPE_AP &&
+	     wdev->iftype != NL80211_IFTYPE_P2P_GO &&
+	     wdev->iftype != NL80211_IFTYPE_AP_VLAN) ||
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG))
+		return -EOPNOTSUPP;
+
+	return rdev_set_sta_mon_rssi_config(rdev, dev, peer,
+					    threshold, hysteresis);
+}
+
+static int nl80211_sta_mon(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[NL80211_ATTR_STA_MON_MAX + 1];
+	struct nlattr *sta_mon;
+	u8 *addr = NULL;
+	int err;
+
+	sta_mon = info->attrs[NL80211_ATTR_STA_MON];
+	if (!sta_mon || !(info->attrs[NL80211_ATTR_MAC]))
+		return -EINVAL;
+
+	err = nla_parse_nested(attrs, NL80211_ATTR_STA_MON_MAX,
+			       sta_mon, nl80211_attr_sta_mon_policy,
+			       info->extack);
+
+	if (err)
+		return err;
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	if (attrs[NL80211_ATTR_STA_MON_RSSI_THOLD] &&
+	    attrs[NL80211_ATTR_STA_MON_RSSI_HYST]) {
+		s32 threshold =
+			nla_get_s32(attrs[NL80211_ATTR_STA_MON_RSSI_THOLD]);
+		u32 hysteresis =
+			nla_get_u32(attrs[NL80211_ATTR_STA_MON_RSSI_HYST]);
+
+		return nl80211_set_sta_mon_rssi(info, addr, threshold,
+						hysteresis);
+	}
+	return -EINVAL;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13823,6 +13892,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_STA_MON,
+		.doit = nl80211_sta_mon,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 364f5d6..faccfae 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1232,4 +1232,20 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_sta_mon_rssi_config(struct cfg80211_registered_device *rdev,
+			     struct net_device *dev, const u8 *peer,
+			     s32 rssi_thold, u32 rssi_hyst)
+
+{
+	int ret;
+
+	trace_rdev_set_sta_mon_rssi_config(&rdev->wiphy, dev, peer,
+					   rssi_thold, rssi_hyst);
+	ret = rdev->ops->set_sta_mon_rssi_config(&rdev->wiphy, dev, peer,
+						 rssi_thold, rssi_hyst);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2b417a2..361ec08 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3257,6 +3257,31 @@
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
 );
+
+TRACE_EVENT(rdev_set_sta_mon_rssi_config,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct net_device *netdev, const u8 *peer,
+		 s32 rssi_thold, u32 rssi_hyst),
+	TP_ARGS(wiphy, netdev, peer, rssi_thold, rssi_hyst),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(s32, rssi_thold)
+		__field(u32, rssi_hyst)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->rssi_thold = rssi_thold;
+		__entry->rssi_hyst = rssi_hyst;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT
+		  ", rssi_thold: %d, rssi_hyst: %u ",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->rssi_thold, __entry->rssi_hyst)
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1
