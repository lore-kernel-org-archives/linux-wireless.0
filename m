Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbeIUGQ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 02:16:29 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        David Spinadel <david.spinadel@intel.com>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH v5 1/3] cfg80211: support FTM responder configuration/statistics
Date: Thu, 20 Sep 2018 17:30:09 -0700
Message-Id: <1537489811-5752-2-git-send-email-pradeepc@codeaurora.org> (sfid-20180921_023023_593125_64FDB31E)
In-Reply-To: <1537489811-5752-1-git-send-email-pradeepc@codeaurora.org>
References: <1537489811-5752-1-git-send-email-pradeepc@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow userspace to enable fine timing measurement responder
functionality with configurable lci/civic parameters in AP mode.
This can be done at AP start or changing beacon parameters.

A new EXT_FEATURE flag is introduced for drivers to advertise
the capability.

Also nl80211 API support for retrieving statistics is added.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
v5:
 - changed NL80211_ATTR_FTM_RESPONDER to nested attr type
 - renamed 'civic' param to 'civicloc'

v4:
 - no changes

v3:
 - fixed ftm responder disabled case to be not supported.
 - changed ftm_responder param from bool to s8.

 include/net/cfg80211.h       |  66 +++++++++++++++++++++
 include/uapi/linux/nl80211.h |  90 +++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 134 +++++++++++++++++++++++++++++++++++++++++--
 net/wireless/rdev-ops.h      |  15 +++++
 net/wireless/trace.h         |  44 ++++++++++++++
 5 files changed, 344 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9f3ed79c39d7..e1c383aafe80 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -775,6 +775,11 @@ struct cfg80211_crypto_settings {
  * @assocresp_ies_len: length of assocresp_ies in octets
  * @probe_resp_len: length of probe response template (@probe_resp)
  * @probe_resp: probe response template (AP mode only)
+ * @ftm_responder: enable FTM responder functionality
+ * @lci: LCI subelement content
+ * @civicloc: CIVIC location subelement content
+ * @lci_len: LCI data length
+ * @civicloc_len: Civic location data length
  */
 struct cfg80211_beacon_data {
 	const u8 *head, *tail;
@@ -782,12 +787,17 @@ struct cfg80211_beacon_data {
 	const u8 *proberesp_ies;
 	const u8 *assocresp_ies;
 	const u8 *probe_resp;
+	const u8 *lci;
+	const u8 *civicloc;
+	s8 ftm_responder;
 
 	size_t head_len, tail_len;
 	size_t beacon_ies_len;
 	size_t proberesp_ies_len;
 	size_t assocresp_ies_len;
 	size_t probe_resp_len;
+	size_t lci_len;
+	size_t civicloc_len;
 };
 
 struct mac_address {
@@ -2797,6 +2807,55 @@ struct cfg80211_external_auth_params {
 };
 
 /**
+ * cfg80211_ftm_responder_params - FTM responder parameters
+ *
+ * @lci: LCI subelement content
+ * @civicloc: CIVIC location subelement content
+ * @lci_len: LCI data length
+ * @civicloc_len: Civic data length
+ */
+struct cfg80211_ftm_responder_params {
+	const u8 *lci;
+	const u8 *civicloc;
+	size_t lci_len;
+	size_t civicloc_len;
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
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -3128,6 +3187,9 @@ struct cfg80211_external_auth_params {
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
  *	tells the driver that the frame should not be encrypted.
+ *
+ * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
+ *	Statistics should be cumulative, currently no way to reset is provided.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3433,6 +3495,10 @@ struct cfg80211_ops {
 				   const u8 *buf, size_t len,
 				   const u8 *dest, const __be16 proto,
 				   const bool noencrypt);
+
+	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
+				struct net_device *dev,
+				struct cfg80211_ftm_responder_stats *ftm_stats);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cfc94178d608..dc6d5a1ef470 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1033,6 +1033,9 @@
  *	%NL80211_ATTR_CHANNEL_WIDTH,%NL80211_ATTR_NSS attributes with its
  *	address(specified in %NL80211_ATTR_MAC).
  *
+ * @NL80211_CMD_GET_FTM_RESPONDER_STATS: Retrieve FTM responder statistics, in
+ *	the %NL80211_ATTR_FTM_RESPONDER_STATS attribute.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1245,6 +1248,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CONTROL_PORT_FRAME,
 
+	NL80211_CMD_GET_FTM_RESPONDER_STATS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2241,6 +2246,14 @@ enum nl80211_commands {
  *	association request when used with NL80211_CMD_NEW_STATION). Can be set
  *	only if %NL80211_STA_FLAG_WME is set.
  *
+ * @NL80211_ATTR_FTM_RESPONDER: nested attribute which user-space can include
+ *	in %NL80211_CMD_START_AP or %NL80211_CMD_SET_BEACON for fine timing
+ *	measurement (FTM) responder functionality and containing parameters as
+ *	possible, see &enum nl80211_ftm_responder_attr
+ *
+ * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
+ *	statistics, see &enum nl80211_ftm_responder_stats.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2682,6 +2695,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HE_CAPABILITY,
 
+	NL80211_ATTR_FTM_RESPONDER,
+
+	NL80211_ATTR_FTM_RESPONDER_STATS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -5225,6 +5242,8 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT: Driver/device can omit all data
  *	except for supported rates from the probe request content if requested
  *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
+ * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
+ *	timing measurement responder role.
  *
  * @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0: Driver/device confirm that they are
  *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
@@ -5269,6 +5288,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_RANDOM_SN,
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
+	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
@@ -5808,4 +5828,74 @@ enum nl80211_external_auth_action {
 	NL80211_EXTERNAL_AUTH_ABORT,
 };
 
+/**
+ * enum nl80211_ftm_responder_attributes - fine timing measurement
+ *	responder attributes
+ * @__NL80211_FTM_RESP_ATTR_INVALID: Invalid
+ * @NL80211_FTM_RESP_ATTR_ENABLED: FTM responder is enabled
+ * @NL80211_FTM_RESP_ATTR_LCI: The content of Measurement Report Element
+ *	(9.4.2.22 in 802.11-2016) with type 8 - LCI (9.4.2.22.10)
+ * @NL80211_FTM_RESP_ATTR_CIVIC: The content of Measurement Report Element
+ *	(9.4.2.22 in 802.11-2016) with type 11 - Civic (Section 9.4.2.22.13)
+ * @__NL80211_FTM_RESP_ATTR_LAST: Internal
+ * @NL80211_FTM_RESP_ATTR_MAX: highest FTM responder attribute.
+ */
+enum nl80211_ftm_responder_attributes {
+	__NL80211_FTM_RESP_ATTR_INVALID,
+
+	NL80211_FTM_RESP_ATTR_ENABLED,
+	NL80211_FTM_RESP_ATTR_LCI,
+	NL80211_FTM_RESP_ATTR_CIVICLOC,
+
+	/* keep last */
+	__NL80211_FTM_RESP_ATTR_LAST,
+	NL80211_FTM_RESP_ATTR_MAX = __NL80211_FTM_RESP_ATTR_LAST - 1,
+};
+
+/*
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
index d5f9b5235cdd..fbe2986a82b0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -430,6 +430,8 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
 	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
+
+	[NL80211_ATTR_FTM_RESPONDER] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -567,6 +569,14 @@ enum nl80211_multicast_groups {
 	[NL80211_PKTPAT_OFFSET] = { .type = NLA_U32 },
 };
 
+/* policy for FTM responder attributes */
+static const struct nla_policy
+nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
+	[NL80211_FTM_RESP_ATTR_ENABLED] = { .type = NLA_FLAG, },
+	[NL80211_FTM_RESP_ATTR_LCI] = { .type = NLA_BINARY, },
+	[NL80211_FTM_RESP_ATTR_CIVICLOC] = { .type = NLA_BINARY },
+};
+
 static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 				     struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
@@ -3997,10 +4007,13 @@ static int validate_beacon_tx_rate(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-static int nl80211_parse_beacon(struct nlattr *attrs[],
+static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
+				struct nlattr *attrs[],
 				struct cfg80211_beacon_data *bcn)
 {
 	bool haveinfo = false;
+	int err;
+	struct nlattr *tb[__NL80211_FTM_RESP_ATTR_LAST];
 
 	if (!is_valid_ie_attr(attrs[NL80211_ATTR_BEACON_TAIL]) ||
 	    !is_valid_ie_attr(attrs[NL80211_ATTR_IE]) ||
@@ -4051,6 +4064,40 @@ static int nl80211_parse_beacon(struct nlattr *attrs[],
 		bcn->probe_resp_len = nla_len(attrs[NL80211_ATTR_PROBE_RESP]);
 	}
 
+	if (attrs[NL80211_ATTR_FTM_RESPONDER]) {
+		err = nla_parse_nested(tb, NL80211_FTM_RESP_ATTR_MAX,
+				       attrs[NL80211_ATTR_FTM_RESPONDER],
+				       nl80211_ftm_responder_policy, NULL);
+
+		if (err)
+			return err;
+
+		if (tb[NL80211_FTM_RESP_ATTR_ENABLED] &&
+		    wiphy_ext_feature_isset(&rdev->wiphy,
+					    NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER))
+			bcn->ftm_responder = 1;
+		else
+			return -EOPNOTSUPP;
+
+		if (tb[NL80211_FTM_RESP_ATTR_LCI]) {
+			if (nla_len(tb[NL80211_FTM_RESP_ATTR_LCI]) > U8_MAX)
+				return -EINVAL;
+
+			bcn->lci = nla_data(tb[NL80211_FTM_RESP_ATTR_LCI]);
+			bcn->lci_len = nla_len(tb[NL80211_FTM_RESP_ATTR_LCI]);
+		}
+
+		if (tb[NL80211_FTM_RESP_ATTR_CIVICLOC]) {
+			if (nla_len(tb[NL80211_FTM_RESP_ATTR_CIVICLOC]) > U8_MAX)
+				return -EINVAL;
+
+			bcn->civicloc = nla_data(tb[NL80211_FTM_RESP_ATTR_CIVICLOC]);
+			bcn->civicloc_len = nla_len(tb[NL80211_FTM_RESP_ATTR_CIVICLOC]);
+		}
+	} else {
+		bcn->ftm_responder = -1;
+	}
+
 	return 0;
 }
 
@@ -4197,7 +4244,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	    !info->attrs[NL80211_ATTR_BEACON_HEAD])
 		return -EINVAL;
 
-	err = nl80211_parse_beacon(info->attrs, &params.beacon);
+	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon);
 	if (err)
 		return err;
 
@@ -4381,7 +4428,7 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->beacon_interval)
 		return -EINVAL;
 
-	err = nl80211_parse_beacon(info->attrs, &params);
+	err = nl80211_parse_beacon(rdev, info->attrs, &params);
 	if (err)
 		return err;
 
@@ -7943,7 +7990,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	if (!need_new_beacon)
 		goto skip_beacons;
 
-	err = nl80211_parse_beacon(info->attrs, &params.beacon_after);
+	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_after);
 	if (err)
 		return err;
 
@@ -7953,7 +8000,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	err = nl80211_parse_beacon(csa_attrs, &params.beacon_csa);
+	err = nl80211_parse_beacon(rdev, csa_attrs, &params.beacon_csa);
 	if (err)
 		return err;
 
@@ -12993,6 +13040,76 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
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
+#define SET_FTM(field, name, type)					 \
+	do { if ((ftm_stats.filled & BIT(NL80211_FTM_STATS_ ## name)) && \
+	    nla_put_ ## type(msg, NL80211_FTM_STATS_ ## name,		 \
+			     ftm_stats.field))				 \
+		goto nla_put_failure; } while (0)
+#define SET_FTM_U64(field, name)					 \
+	do { if ((ftm_stats.filled & BIT(NL80211_FTM_STATS_ ## name)) && \
+	    nla_put_u64_64bit(msg, NL80211_FTM_STATS_ ## name,		 \
+			      ftm_stats.field, NL80211_FTM_STATS_PAD))	 \
+		goto nla_put_failure; } while (0)
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
@@ -13904,6 +14021,13 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
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
index 364f5d67f05b..51380b5c32f2 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1232,4 +1232,19 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
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
index 5e7eec849200..89bd1f7aa7ed 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3259,6 +3259,50 @@
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
 );
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
1.9.1
