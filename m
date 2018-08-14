Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36442 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbeHNMxy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 08:53:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: support FTM responder setup/statistics
Date: Tue, 14 Aug 2018 12:06:22 +0200
Message-Id: <20180814100623.28976-1-johannes@sipsolutions.net> (sfid-20180814_120729_479981_427AB03B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add nl80211 API to support starting an FTM responder with
configurable LCI/Civic parameters. Also support retrieving
statistics.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  60 +++++++++++++++++++++
 include/uapi/linux/nl80211.h |  69 ++++++++++++++++++++++++
 net/wireless/nl80211.c       | 122 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  29 ++++++++++
 net/wireless/trace.h         |  71 +++++++++++++++++++++++++
 5 files changed, 351 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9ba1f289c439..bf692713c0f0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2794,6 +2794,55 @@ struct cfg80211_external_auth_params {
 	u16 status;
 };
 
+/**
+ * cfg80211_ftm_responder_params - FTM responder parameters
+ *
+ * @lci: LCI subelement content
+ * @civic: CIVIC subelement content
+ * @lci_len: LCI data length
+ * @civic_len: Civic data length
+ */
+struct cfg80211_ftm_responder_params {
+	const u8 *lci;
+	const u8 *civic;
+	size_t lci_len;
+	size_t civic_len;
+};
+
+/**
+ * cfg80211_ftm_responder_stats - FTM responder statistics
+ *
+ * @filled: bitflag of flags using the bits of &enum nl80211_ftm_stats to
+ *	indicate the relevant values in this struct for them
+ * @success_num: number of FTM sessions in which all frames were successfully
+ *	answered
+ * @partial_num: number of FTM sessions in which part of frames were
+ *	successfully answered
+ * @failed_num: number of failed FTM sessions
+ * @asap_num: number of ASAP FTM sessions
+ * @non_asap_num: number of  non-ASAP FTM sessions
+ * @total_duration_ms: total sessions durations - gives an indication
+ *	of how much time the responder was busy
+ * @unknown_triggers_num: number of unknown FTM triggers - triggers from
+ *	initiators that didn't finish successfully the negotiation phase with
+ *	the responder
+ * @reschedule_requests_num: number of FTM reschedule requests - initiator asks
+ *	for a new scheduling although it already has scheduled FTM slot
+ * @out_of_window_triggers_num: total FTM triggers out of scheduled window
+ */
+struct cfg80211_ftm_responder_stats {
+	u32 filled;
+	u32 success_num;
+	u32 partial_num;
+	u32 failed_num;
+	u32 asap_num;
+	u32 non_asap_num;
+	u64 total_duration_ms;
+	u32 unknown_triggers_num;
+	u32 reschedule_requests_num;
+	u32 out_of_window_triggers_num;
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -3126,6 +3175,10 @@ struct cfg80211_external_auth_params {
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
  *	tells the driver that the frame should not be encrypted.
+ *
+ * @start_ftm_responder: configure and start FTM responder activity on an AP
+ * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
+ *	Statistics should be cumulative, currently no way to reset is provided.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3431,6 +3484,13 @@ struct cfg80211_ops {
 				   const u8 *buf, size_t len,
 				   const u8 *dest, const __be16 proto,
 				   const bool noencrypt);
+
+	int	(*start_ftm_responder)(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       struct cfg80211_ftm_responder_params *params);
+	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   struct cfg80211_ftm_responder_stats *ftm_stats);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7acc16f34942..b9ca12748905 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1033,6 +1033,13 @@
  *	%NL80211_ATTR_CHANNEL_WIDTH,%NL80211_ATTR_NSS attributes with its
  *	address(specified in %NL80211_ATTR_MAC).
  *
+ * @NL80211_CMD_START_FTM_RESPONDER: Start FTM responder and set its parameters,
+ *	given in the %NL80211_ATTR_LCI and %NL80211_ATTR_CIVIC attributes.
+ *	This is supported only on AP interface. FTM responder cannot be stopped
+ *	without removing the interface.
+ * @NL80211_CMD_GET_FTM_RESPONDER_STATS: Retrieve FTM responder statistics, in
+ *	the %NL80211_ATTR_FTM_RESPONDER_STATS attribute.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1245,6 +1252,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_CONTROL_PORT_FRAME,
 
+	NL80211_CMD_START_FTM_RESPONDER,
+	NL80211_CMD_GET_FTM_RESPONDER_STATS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2241,6 +2251,14 @@ enum nl80211_commands {
  *	association request when used with NL80211_CMD_NEW_STATION). Can be set
  *	only if %NL80211_STA_FLAG_WME is set.
  *
+ * @NL80211_ATTR_LCI: The content of Measurement Report Element (9.4.2.22
+ *	in 802.11-2016) with type 8 - LCI (9.4.2.22.10)
+ * @NL80211_ATTR_CIVIC: The content of Measurement Report Element (9.4.2.22
+ *	in 802.11-2016) with type 11 - Civic (Section 9.4.2.22.13)
+ *
+ * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
+ *	statistics, see &enum nl80211_ftm_responder_stats.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2682,6 +2700,11 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HE_CAPABILITY,
 
+	NL80211_ATTR_LCI,
+	NL80211_ATTR_CIVIC,
+
+	NL80211_ATTR_FTM_RESPONDER_STATS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -5798,4 +5821,50 @@ enum nl80211_external_auth_action {
 	NL80211_EXTERNAL_AUTH_ABORT,
 };
 
+/**
+ * enum nl80211_ftm_responder_stats - FTM responder statistics
+ *
+ * These attribute types are used with %NL80211_ATTR_FTM_RESPONDER_STATS
+ * when getting FTM responder statistics.
+ *
+ * @__NL80211_FTM_STATS_INVALID: attribute number 0 is reserved
+ * @NL80211_FTM_STATS_SUCCESS_NUM: number of FTM sessions in which all frames
+ *	were ssfully answered (u32)
+ * @NL80211_FTM_STATS_PARTIAL_NUM: number of FTM sessions in which part of the
+ *	frames were successfully answered (u32)
+ * @NL80211_FTM_STATS_FAILED_NUM: number of failed FTM sessions (u32)
+ * @NL80211_FTM_STATS_ASAP_NUM: number of ASAP sessions (u32)
+ * @NL80211_FTM_STATS_NON_ASAP_NUM: number of non-ASAP sessions (u32)
+ * @NL80211_FTM_STATS_TOTAL_DURATION_MSEC: total sessions durations - gives an
+ *	indication of how much time the responder was busy (u64, msec)
+ * @NL80211_FTM_STATS_UNKNOWN_TRIGGERS_NUM: number of unknown FTM triggers -
+ *	triggers from initiators that didn't finish successfully the negotiation
+ *	phase with the responder (u32)
+ * @NL80211_FTM_STATS_RESCHEDULE_REQUESTS_NUM: number of FTM reschedule requests
+ *	- initiator asks for a new scheduling although it already has scheduled
+ *	FTM slot (u32)
+ * @NL80211_FTM_STATS_OUT_OF_WINDOW_TRIGGERS_NUM: number of FTM triggers out of
+ *	scheduled window (u32)
+ * @NL80211_FTM_STATS_PAD: used for padding, ignore
+ * @__NL80211_TXQ_ATTR_AFTER_LAST: Internal
+ * @NL80211_FTM_STATS_MAX: highest possible FTM responder stats attribute
+ */
+enum nl80211_ftm_responder_stats {
+	__NL80211_FTM_STATS_INVALID,
+	NL80211_FTM_STATS_SUCCESS_NUM,
+	NL80211_FTM_STATS_PARTIAL_NUM,
+	NL80211_FTM_STATS_FAILED_NUM,
+	NL80211_FTM_STATS_ASAP_NUM,
+	NL80211_FTM_STATS_NON_ASAP_NUM,
+	NL80211_FTM_STATS_TOTAL_DURATION_MSEC,
+	NL80211_FTM_STATS_UNKNOWN_TRIGGERS_NUM,
+	NL80211_FTM_STATS_RESCHEDULE_REQUESTS_NUM,
+	NL80211_FTM_STATS_OUT_OF_WINDOW_TRIGGERS_NUM,
+	NL80211_FTM_STATS_PAD,
+
+	/* keep last */
+	__NL80211_FTM_STATS_AFTER_LAST,
+	NL80211_FTM_STATS_MAX = __NL80211_FTM_STATS_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e4e5f025d16b..701d2d0e131d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -430,6 +430,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
 	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
+	[NL80211_ATTR_LCI] = { .type = NLA_BINARY },
+	[NL80211_ATTR_CIVIC] = { .type = NLA_BINARY },
 };
 
 /* policy for the key attributes */
@@ -12987,6 +12989,111 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_start_ftm_responder(struct sk_buff *skb,
+				       struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_ftm_responder_params params = {};
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP || !wdev->beacon_interval)
+		return -EOPNOTSUPP;
+
+	if (info->attrs[NL80211_ATTR_LCI]) {
+		if (nla_len(info->attrs[NL80211_ATTR_LCI]) > U8_MAX)
+			return -EINVAL;
+
+		params.lci = nla_data(info->attrs[NL80211_ATTR_LCI]);
+		params.lci_len = nla_len(info->attrs[NL80211_ATTR_LCI]);
+	}
+
+	if (info->attrs[NL80211_ATTR_CIVIC]) {
+		if (nla_len(info->attrs[NL80211_ATTR_CIVIC]) > U8_MAX)
+			return -EINVAL;
+
+		params.civic = nla_data(info->attrs[NL80211_ATTR_CIVIC]);
+		params.civic_len = nla_len(info->attrs[NL80211_ATTR_CIVIC]);
+	}
+
+	wdev_lock(wdev);
+	err = rdev_start_ftm_responder(rdev, dev, &params);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
+static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
+					   struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_ftm_responder_stats ftm_stats = {};
+	struct sk_buff *msg;
+	void *hdr;
+	struct nlattr *ftm_stats_attr;
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP || !wdev->beacon_interval)
+		return -EOPNOTSUPP;
+
+	err = rdev_get_ftm_responder_stats(rdev, dev, &ftm_stats);
+	if (err)
+		return err;
+
+	if (!ftm_stats.filled)
+		return -ENODATA;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_GET_FTM_RESPONDER_STATS);
+	if (!hdr)
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex))
+		goto nla_put_failure;
+
+	ftm_stats_attr = nla_nest_start(msg, NL80211_ATTR_FTM_RESPONDER_STATS);
+	if (!ftm_stats_attr)
+		goto nla_put_failure;
+
+#define SET_FTM(field, name, type)					\
+	if ((ftm_stats.filled & BIT(NL80211_FTM_STATS_ ## name)) &&	\
+	    nla_put_ ## type(msg, NL80211_FTM_STATS_ ## name,		\
+			     ftm_stats.field))				\
+		goto nla_put_failure
+#define SET_FTM_U64(field, name)					\
+	if ((ftm_stats.filled & BIT(NL80211_FTM_STATS_ ## name)) &&	\
+	    nla_put_u64_64bit(msg, NL80211_FTM_STATS_ ## name,		\
+			      ftm_stats.field, NL80211_FTM_STATS_PAD))	\
+		goto nla_put_failure
+
+	SET_FTM(success_num, SUCCESS_NUM, u32);
+	SET_FTM(partial_num, PARTIAL_NUM, u32);
+	SET_FTM(failed_num, FAILED_NUM, u32);
+	SET_FTM(asap_num, ASAP_NUM, u32);
+	SET_FTM(non_asap_num, NON_ASAP_NUM, u32);
+	SET_FTM_U64(total_duration_ms, TOTAL_DURATION_MSEC);
+	SET_FTM(unknown_triggers_num, UNKNOWN_TRIGGERS_NUM, u32);
+	SET_FTM(reschedule_requests_num, RESCHEDULE_REQUESTS_NUM, u32);
+	SET_FTM(out_of_window_triggers_num, OUT_OF_WINDOW_TRIGGERS_NUM, u32);
+#undef SET_FTM
+
+	nla_nest_end(msg, ftm_stats_attr);
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13898,6 +14005,21 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_START_FTM_RESPONDER,
+		.doit = nl80211_start_ftm_responder,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_GET_FTM_RESPONDER_STATS,
+		.doit = nl80211_get_ftm_responder_stats,
+		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 364f5d67f05b..6b73409848fa 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1232,4 +1232,33 @@ rdev_external_auth(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_start_ftm_responder(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 struct cfg80211_ftm_responder_params *params)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_start_ftm_responder(&rdev->wiphy, dev, params);
+	if (rdev->ops->start_ftm_responder)
+		ret = rdev->ops->start_ftm_responder(&rdev->wiphy, dev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int
+rdev_get_ftm_responder_stats(struct cfg80211_registered_device *rdev,
+			     struct net_device *dev,
+			     struct cfg80211_ftm_responder_stats *ftm_stats)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_get_ftm_responder_stats(&rdev->wiphy, dev, ftm_stats);
+	if (rdev->ops->get_ftm_responder_stats)
+		ret = rdev->ops->get_ftm_responder_stats(&rdev->wiphy, dev,
+							ftm_stats);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2b417a2fe63f..cb42b441a2d6 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3257,6 +3257,77 @@ TRACE_EVENT(rdev_get_txq_stats,
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
 );
+
+TRACE_EVENT(rdev_start_ftm_responder,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_ftm_responder_params *params),
+	TP_ARGS(wiphy, netdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		CHAN_DEF_ENTRY
+		__dynamic_array(u8, lci, params->lci_len)
+		__dynamic_array(u8, civic, params->civic_len)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		memcpy(__get_dynamic_array(lci), params->lci, params->lci_len);
+		memcpy(__get_dynamic_array(civic), params->civic,
+		       params->civic_len);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT
+		  "lci %s civic %s", WIPHY_PR_ARG,
+		  NETDEV_PR_ARG,
+		  __print_array(__get_dynamic_array(lci),
+				__get_dynamic_array_len(lci), 1),
+		  __print_array(__get_dynamic_array(civic),
+				__get_dynamic_array_len(civic), 1))
+);
+
+TRACE_EVENT(rdev_get_ftm_responder_stats,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_ftm_responder_stats *ftm_stats),
+
+	TP_ARGS(wiphy, netdev, ftm_stats),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u64, timestamp)
+		__field(u32, success_num)
+		__field(u32, partial_num)
+		__field(u32, failed_num)
+		__field(u32, asap_num)
+		__field(u32, non_asap_num)
+		__field(u64, duration)
+		__field(u32, unknown_triggers)
+		__field(u32, reschedule)
+		__field(u32, out_of_window)
+	),
+
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->success_num = ftm_stats->success_num;
+		__entry->partial_num = ftm_stats->partial_num;
+		__entry->failed_num = ftm_stats->failed_num;
+		__entry->asap_num = ftm_stats->asap_num;
+		__entry->non_asap_num = ftm_stats->non_asap_num;
+		__entry->duration = ftm_stats->total_duration_ms;
+		__entry->unknown_triggers = ftm_stats->unknown_triggers_num;
+		__entry->reschedule = ftm_stats->reschedule_requests_num;
+		__entry->out_of_window = ftm_stats->out_of_window_triggers_num;
+	),
+
+	TP_printk(WIPHY_PR_FMT "Ftm responder stats: success %u, partial %u, "
+		"failed %u, asap %u, non asap %u, total duration %llu, unknown "
+		"triggers %u, rescheduled %u, out of window %u", WIPHY_PR_ARG,
+		__entry->success_num, __entry->partial_num, __entry->failed_num,
+		__entry->asap_num, __entry->non_asap_num, __entry->duration,
+		__entry->unknown_triggers, __entry->reschedule,
+		__entry->out_of_window)
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.14.4
