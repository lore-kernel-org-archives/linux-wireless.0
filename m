Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DC8C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2BF20652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ktEm7IFy";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LJY/rG59"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B2BF20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbeJWCPw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 22:15:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38008 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728658AbeJWCPw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 22:15:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4B3F660F72; Mon, 22 Oct 2018 17:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230981;
        bh=oCVh2psWbI4J8C/xseDCoAkGL6ZqOS5wXcIVgUCRNtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktEm7IFyOKuwJ3qmuaze3zrdz++jq5t8+VJ9hy8q6T/wXs+qr/9KkusuKdF+0QUgI
         RmQDlx6ao0on4Odx0UxwxBTuTnN595FZwq3znLaH0iIhCnjAsXPrNMZrDlNiD5CQj6
         xWOnX8EmD+taaQYuS4gCVGiUWJJAPMGqPoNaztig=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4A2C06085C;
        Mon, 22 Oct 2018 17:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230980;
        bh=oCVh2psWbI4J8C/xseDCoAkGL6ZqOS5wXcIVgUCRNtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJY/rG59hWrDXvxtZEGoM+K+cej3qIck3XJFLyr0PprrkP9cGxSeKZvRFj1sqVO7O
         VmnQqPdWTzzoGLPgQsofdWlWtMm+LV8/iPTaKBDQPn1Lx4u6gIzEgEBHrSkFlRUNhS
         CvxN/c11Vjop0kWo1PrGKbYzJgA1pPiAdBRSJqok=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4A2C06085C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 1/4] New netlink command for TID specific configuration
Date:   Mon, 22 Oct 2018 23:25:15 +0530
Message-Id: <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>

Add a new NL command, NL80211_CMD_SET_TID_CONFIG, for TID specific
configurations such as retry count and AMPDU aggregation
control(disable/enable). These per-TID configurations are passed in
NL80211_ATTR_TID_CONFIG which is a nested attribute of TID configuration.
TID for which the retry configuration is to be applied is passed in
NL80211_ATTR_TID attribute. When the user-space wants this configuration
peer specific rather than being applied for all the connected stations,
MAC address of the peer can be passed in NL80211_ATTR_MAC attribute.
The retry count is passed in NL80211_ATTR_TID_RETRY_SHORT and/or
NL80211_ATTR_TID_RETRY_LONG attribute.
Driver should advertise WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT and
max_data_retry_count value to notify user space to avoid of passing
greater than the allowed limit.
Driver supporting TID specific configuration should advertise
NL80211_EXT_FEATURE_PER_TID_* and supporting per-STA data
retry count configuration should advertise NL80211_EXT_FEATURE_PER_STA_*.

Co-Developed-by: Tamizh Chelvam <tamizhr@codeaurora.org>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |   14 +++++++
 include/uapi/linux/nl80211.h |   69 +++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |   86 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   15 ++++++++
 net/wireless/trace.h         |   27 +++++++++++++
 5 files changed, 211 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5801d76..dd024da 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3191,6 +3191,9 @@ struct cfg80211_ftm_responder_stats {
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
+ * @set_data_retry_count: configure the number of retries for the data frames
+ *	for the given TID. If the retry configuration needs to be peer specific,
+ *	peer MAC address can be passed.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3500,6 +3503,10 @@ struct cfg80211_ops {
 	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct cfg80211_ftm_responder_stats *ftm_stats);
+	int     (*set_data_retry_count)(struct wiphy *wiphy,
+					struct net_device *dev,
+					const u8 *peer, u8 tid,
+					int retry_short, int retry_long);
 };
 
 /*
@@ -3547,6 +3554,7 @@ struct cfg80211_ops {
  *	beaconing mode (AP, IBSS, Mesh, ...).
  * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key installation
  *	before connection.
+ * @WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT: Device supports data retry count call.
  */
 enum wiphy_flags {
 	/* use hole at 0 */
@@ -3573,6 +3581,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
 	WIPHY_FLAG_HAS_STATIC_WEP		= BIT(24),
+	WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT	= BIT(25),
 };
 
 /**
@@ -4035,6 +4044,9 @@ struct wiphy_iftype_ext_capab {
  * @txq_limit: configuration of internal TX queue frame limit
  * @txq_memory_limit: configuration internal TX queue memory limit
  * @txq_quantum: configuration of internal TX queue scheduler quantum
+ *
+ * @max_data_retry_count: Maximum limit can be configured as retry count
+ *	for a TID.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -4171,6 +4183,8 @@ struct wiphy {
 	u32 txq_memory_limit;
 	u32 txq_quantum;
 
+	u8 max_data_retry_count;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 31b7a4b..9dfcf0a6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1047,6 +1047,10 @@
  * @NL80211_CMD_GET_FTM_RESPONDER_STATS: Retrieve FTM responder statistics, in
  *	the %NL80211_ATTR_FTM_RESPONDER_STATS attribute.
  *
+ * @NL80211_CMD_SET_TID_CONFIG: Data frame TID specific configuration
+ *	is passed through this command using %NL80211_ATTR_TID_CONFIG
+ *	nested attributes.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1261,6 +1265,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_FTM_RESPONDER_STATS,
 
+	NL80211_CMD_SET_TID_CONFIG,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2264,6 +2270,10 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
  *	statistics, see &enum nl80211_ftm_responder_stats.
+ * @NL80211_ATTR_TID_CONFIG: TID specific configuration in a
+ *	nested attribute with %NL80211_ATTR_TID_* sub-attributes.
+ * @NL80211_ATTR_MAX_RETRY_COUNT: The upper limit for the retry count
+ *	configuration that the driver can accept.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2710,6 +2720,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FTM_RESPONDER_STATS,
 
+	NL80211_ATTR_TID_CONFIG,
+	NL80211_ATTR_MAX_RETRY_COUNT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4399,6 +4412,56 @@ enum nl80211_ps_state {
 	NL80211_PS_ENABLED,
 };
 
+/*
+ * @NL80211_ATTR_TID: a TID value (u8 attribute)
+ * @NL80211_ATTR_TID_RETRY_CONFIG: Data frame retry count should be
+ *	applied with the value passed through %NL80211_ATTR_RETRY_LONG
+ *	and/or %NL80211_ATTR_RETRY_SHORT. This configuration is  per-TID,
+ *	TID is specified with %NL80211_ATTR_TID. If the peer MAC address
+ *	is passed in %NL80211_ATTR_MAC, the retry configuration is applied
+ *	to the data frame for the tid to that connected station.
+ *	This attribute will be useful to notfiy the driver to apply default
+ *	retry values for the connected station (%NL80211_ATTR_MAC), when the
+ *	command received without %NL80211_ATTR_RETRY_LONG and/or
+ *	%NL80211_ATTR_RETRY_SHORT.
+ *	Station specific retry configuration is valid only for STA's
+ *	current connection. i.e. the configuration will be reset to default when
+ *	the station connects back after disconnection/roaming.
+ *	when user-space does not include %NL80211_ATTR_MAC, this configuration
+ *	should be treated as per-netdev configuration. This configuration will
+ *	be cleared when the interface goes down and on the disconnection from a
+ *	BSS. When retry count has never been configured using this command, the
+ *	other available radio level retry configuration
+ *	(%NL80211_ATTR_WIPHY_RETRY_SHORT and %NL80211_ATTR_WIPHY_RETRY_LONG)
+ *	should be used. Driver supporting this feature should advertise
+ *	NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG and supporting per station
+ *	retry count configuration should advertise
+ *	NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG.
+ * @NL80211_ATTR_TID_RETRY_SHORT: Number of retries used with data frame
+ *	transmission, user-space sets this configuration in
+ *	&NL80211_CMD_SET_TID_CONFIG. Its type is u8, min value is 1 and
+ *	the max value should be advertised by the driver through
+ *	max_data_retry_count. when this attribute is not present, the driver
+ *	would use the default configuration.
+ * @NL80211_ATTR_TID_RETRY_LONG: Number of retries used with data frame
+ *	transmission, user-space sets this configuration in
+ *	&NL80211_CMD_SET_TID_CONFIG. Its type is u8, min value is 1 and
+ *	the max value should be advertised by the driver through
+ *	max_data_retry_count. when this attribute is not present, the driver
+ *	would use the default configuration.
+ */
+enum nl80211_attr_tid_config {
+	__NL80211_ATTR_TID_INVALID,
+	NL80211_ATTR_TID,
+	NL80211_ATTR_TID_RETRY_CONFIG,
+	NL80211_ATTR_TID_RETRY_SHORT,
+	NL80211_ATTR_TID_RETRY_LONG,
+
+	/* keep last */
+	__NL80211_ATTR_TID_AFTER_LAST,
+	NL80211_ATTR_TID_MAX = __NL80211_ATTR_TID_AFTER_LAST - 1
+};
+
 /**
  * enum nl80211_attr_cqm - connection quality monitor attributes
  * @__NL80211_ATTR_CQM_INVALID: invalid
@@ -5270,6 +5333,10 @@ enum nl80211_feature_flags {
  *      freeze the connection.
  * @NL80211_EXT_FEATURE_PER_STA_NOACK_MAP: Driver supports STA specific NoAck
  *	policy functionality.
+ * @NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG: Driver supports per TID data retry
+ *	count funcationality.
+ * @NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG: Driver supports STA specific
+ *	data retry count functionality.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5311,6 +5378,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
 	NL80211_EXT_FEATURE_PER_STA_NOACK_MAP,
+	NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG,
+	NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d744388..d386ad7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1703,6 +1703,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		if ((rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 			goto nla_put_failure;
+		if ((rdev->wiphy.flags & WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT) &&
+		    nla_put_u8(msg, NL80211_ATTR_MAX_RETRY_COUNT,
+			       rdev->wiphy.max_data_retry_count))
+			goto nla_put_failure;
 		state->split_start++;
 		if (state->split)
 			break;
@@ -12992,6 +12996,80 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	return -ENOBUFS;
 }
 
+static const struct nla_policy
+nl80211_attr_tid_policy[NL80211_ATTR_TID_MAX + 1] = {
+	[NL80211_ATTR_TID] = { .type = NLA_U8 },
+	[NL80211_ATTR_TID_RETRY_CONFIG] = { .type = NLA_FLAG },
+	[NL80211_ATTR_TID_RETRY_SHORT] = { .type = NLA_U8 },
+	[NL80211_ATTR_TID_RETRY_LONG] = { .type = NLA_U8 },
+};
+
+static int nl80211_set_tid_config(struct sk_buff *skb,
+				  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct nlattr *attrs[NL80211_ATTR_TID_MAX + 1];
+	struct nlattr *tid;
+	struct net_device *dev = info->user_ptr[1];
+	const char *peer = NULL;
+	u8 tid_no;
+	int ret = -EINVAL, retry_short = -1, retry_long = -1;
+
+	tid = info->attrs[NL80211_ATTR_TID_CONFIG];
+	if (!tid)
+		return -EINVAL;
+
+	ret = nla_parse_nested(attrs, NL80211_ATTR_TID_MAX, tid,
+			       nl80211_attr_tid_policy, info->extack);
+	if (ret)
+		return ret;
+
+	if (!attrs[NL80211_ATTR_TID])
+		return -EINVAL;
+
+	if (attrs[NL80211_ATTR_TID_RETRY_SHORT]) {
+		retry_short = nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_SHORT]);
+		if (!retry_short ||
+		    retry_short > rdev->wiphy.max_data_retry_count)
+			return -EINVAL;
+	}
+
+	if (attrs[NL80211_ATTR_TID_RETRY_LONG]) {
+		retry_long = nla_get_u8(attrs[NL80211_ATTR_TID_RETRY_LONG]);
+		if (!retry_long ||
+		    retry_long > rdev->wiphy.max_data_retry_count)
+			return -EINVAL;
+	}
+
+	tid_no = nla_get_u8(attrs[NL80211_ATTR_TID]);
+	if (tid_no >= IEEE80211_FIRST_TSPEC_TSID)
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (nla_get_flag(attrs[NL80211_ATTR_TID_RETRY_CONFIG])) {
+		if (!wiphy_ext_feature_isset(
+				&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG))
+			return -EOPNOTSUPP;
+
+		if (peer && !wiphy_ext_feature_isset(
+				&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG))
+			return -EOPNOTSUPP;
+
+		if (!rdev->ops->set_data_retry_count ||
+		    !rdev->wiphy.max_data_retry_count)
+			return -EOPNOTSUPP;
+
+		ret = rdev_set_data_retry_count(rdev, dev, peer, tid_no,
+						retry_short, retry_long);
+	}
+
+	return ret;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13910,6 +13988,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_TID_CONFIG,
+		.doit = nl80211_set_tid_config,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 8426eb1..b61e476 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1248,4 +1248,19 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_data_retry_count(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev, const u8 *peer,
+			  u8 tid, int retry_short, int retry_long)
+{
+	int ret;
+
+	trace_rdev_set_data_retry_count(&rdev->wiphy, dev, peer, tid,
+					retry_short, retry_long);
+	ret = rdev->ops->set_data_retry_count(&rdev->wiphy, dev, peer,
+					      tid, retry_short, retry_long);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2ff78dd..7b55da9 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3297,6 +3297,33 @@
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT,
 		  WIPHY_PR_ARG, WDEV_PR_ARG)
 );
+
+TRACE_EVENT(rdev_set_data_retry_count,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *peer, u8 tid, int retry_short, int retry_long),
+	TP_ARGS(wiphy, netdev, peer, tid, retry_short, retry_long),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(u8, tid)
+		__field(int, retry_short)
+		__field(int, retry_long)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->tid = tid;
+		__entry->retry_short = retry_short;
+		__entry->retry_long = retry_long;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", peer: " MAC_PR_FMT
+		  ", tid: %u, retry_short: %d, retry_long: %d", WIPHY_PR_ARG,
+		  NETDEV_PR_ARG, MAC_PR_ARG(peer), __entry->tid,
+		  __entry->retry_short, __entry->retry_long)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.9.5

