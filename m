Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2741FC4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D584220856
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:29:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BcsvEOSp";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CWNu6M7H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbfCZJ3i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 05:29:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49390 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfCZJ3i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 05:29:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5B60F60F37; Tue, 26 Mar 2019 09:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553592577;
        bh=U+xbzEcTOBWc8qPuYz3enwlh0347RDM5MYWlKxiNLnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcsvEOSp+IOGWEoxm4qUGdujuRF61uX6tvrBLWR5D+49NWe/pD40q+DggnnAQBhBd
         tT76yG762hMGdFHLL+Vnk3j8drt6FdyIwBijFbL/D1vipocdckOnhk8QDMk47y/cir
         TlJO+ggZesYlgIR5Zx0iAoy2O4KOtWe30FiQ+JMc=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 31B5C60767;
        Tue, 26 Mar 2019 09:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553592576;
        bh=U+xbzEcTOBWc8qPuYz3enwlh0347RDM5MYWlKxiNLnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWNu6M7Hyiw1l04ZbZbmGEW8evQl+mDKSTvk/cP4pM1KGP0+iU3dm5/IElOo5JrKS
         Ba0hTrXcGNtBGZSlZLlTsVRi8BVwLxxz8gWZsYI1uaxHWXhtjdrsXVwyRufx+/vgLX
         ySXcSLIGKpnVjXfVYg03leqH+aGtmsN6IZimWeLA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 31B5C60767
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv5 1/9] nl80211: New netlink command for TID specific configuration
Date:   Tue, 26 Mar 2019 14:59:02 +0530
Message-Id: <1553592550-15282-2-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
References: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add a new NL command, NL80211_CMD_SET_TID_CONFIG to support
data TID specific configuration. This per TID configurations
are passed in NL80211_ATTR_TID_CONFIG which is a nested
attribute. This patch adds support to configure per TID
noack policy through NL80211_ATTR_TID_CONFIG_NOACK attribute.
Data TID value for this configuration will be passed through
NL80211_ATTR_TID_CONFIG_TID attribute. When the user-space wants
this configuration peer specific rather than being applied for
all the connected stations, MAC address of the peer can be passed
in NL80211_ATTR_MAC attribute. This patch introduced
enum ieee80211_tid_conf_mask to notify the driver that which
configuration modified.
Driver supporting data TID specific noack policy configuration
should be advertise through NL80211_EXT_FEATURE_PER_TID_NOACK_CONFIG
and supporting per STA data TID noack policy configuration
should be advertise through NL80211_EXT_FEATURE_PER_STA_NOACK_CONFIG

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |   35 ++++++++++++++
 include/uapi/linux/nl80211.h |   51 +++++++++++++++++++++
 net/wireless/nl80211.c       |  104 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   11 +++++
 net/wireless/trace.h         |   18 ++++++++
 5 files changed, 219 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb307a1..c606e78 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -509,6 +509,35 @@ struct cfg80211_chan_def {
 	u32 center_freq2;
 };
 
+enum ieee80211_tid_conf_mask {
+	IEEE80211_TID_CONF_NOACK	= BIT(0),
+};
+
+/**
+ * struct ieee80211_tid_cfg - TID specific configuration
+ * @tid: TID number
+ * @tid_conf_mask: bitmap indicating which parameter changed
+ *	see %enum ieee80211_tid_conf_mask
+ * @noack: noack configuration value for the TID
+ */
+struct ieee80211_tid_cfg {
+	u8 tid;
+	enum ieee80211_tid_conf_mask tid_conf_mask;
+	u8 noack;
+};
+
+/**
+ * struct ieee80211_tid_config - TID configuration
+ * @peer: Station's MAC address
+ * @n_tid_conf: Number of TID specific configurations to be applied
+ * @tid_conf: Configuration change info
+ */
+struct ieee80211_tid_config {
+	const u8 *peer;
+	u32 n_tid_conf;
+	struct ieee80211_tid_cfg tid_conf[];
+};
+
 /**
  * cfg80211_get_chandef_type - return old channel type from chandef
  * @chandef: the channel definition
@@ -3436,6 +3465,10 @@ struct cfg80211_pmsr_request {
  *	Statistics should be cumulative, currently no way to reset is provided.
  * @start_pmsr: start peer measurement (e.g. FTM)
  * @abort_pmsr: abort peer measurement
+ * @set_tid_config: TID specific configuration. Apply this configuration for
+ *	all the connected stations in the BSS if peer is NULL. Otherwise
+ *	apply this configuration to the specific station.
+ *	This callback may sleep.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3750,6 +3783,8 @@ struct cfg80211_ops {
 			      struct cfg80211_pmsr_request *request);
 	void	(*abort_pmsr)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      struct cfg80211_pmsr_request *request);
+	int     (*set_tid_config)(struct wiphy *wiphy, struct net_device *dev,
+				  struct ieee80211_tid_config *tid_conf);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dd4f86e..c901a48 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1065,6 +1065,10 @@
  *	indicated by %NL80211_ATTR_WIPHY_FREQ and other attributes
  *	determining the width and type.
  *
+ * @NL80211_CMD_SET_TID_CONFIG: Data frame TID specific configuration
+ *	is passed through this command using %NL80211_ATTR_TID_CONFIG
+ *	nested attributes.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1285,6 +1289,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_NOTIFY_RADAR,
 
+	NL80211_CMD_SET_TID_CONFIG,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2308,6 +2314,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_AIRTIME_WEIGHT: Station's weight when scheduled by the airtime
  *	scheduler.
  *
+ * @NL80211_ATTR_TID_CONFIG: TID specific configuration in a
+ *	nested attribute with %NL80211_ATTR_TID_* sub-attributes.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2759,6 +2768,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_AIRTIME_WEIGHT,
 
+	NL80211_ATTR_TID_CONFIG,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4543,6 +4554,39 @@ enum nl80211_tx_power_setting {
 	NL80211_TX_POWER_FIXED,
 };
 
+enum nl80211_tid_config {
+	NL80211_TID_CONFIG_DEFAULT,
+	NL80211_TID_CONFIG_ENABLE,
+	NL80211_TID_CONFIG_DISABLE,
+};
+
+/* enum nl80211_attr_tid_config - TID specific configuration.
+ * @NL80211_ATTR_TID_CONFIG_TID: a TID value (u8 attribute).
+ * @NL80211_ATTR_TID_CONFIG_NOACK: Configure ack policy for the TID.
+ *	specified in %NL80211_ATTR_TID_CONFIG_TID. see %enum nl80211_tid_config.
+ *	Its type is u8, if the peer MAC address is passed in %NL80211_ATTR_MAC,
+ *	then the noack configuration is applied to the data frame for the tid
+ *	to that connected station. This configuration is valid only for STA's
+ *      current connection. i.e. the configuration will be reset to default when
+ *      the station connects back after disconnection/roaming.
+ *      when user-space does not include %NL80211_ATTR_MAC, then this
+ *	configuration should be treated as per-netdev configuration.
+ *	This configuration will be cleared when the interface goes down and on
+ *	the disconnection from a BSS. Driver supporting this feature should
+ *	advertise NL80211_EXT_FEATURE_PER_TID_NOACK_CONFIG and
+ *	NL80211_EXT_FEATURE_PER_STA_NOACK_CONFIG for supporting  per sta
+ *	configuration.
+ */
+enum nl80211_attr_tid_config {
+	__NL80211_ATTR_TID_INVALID,
+	NL80211_ATTR_TID_CONFIG_TID,
+	NL80211_ATTR_TID_CONFIG_NOACK,
+
+	/* keep last */
+	__NL80211_ATTR_TID_CONFIG_AFTER_LAST,
+	NL80211_ATTR_TID_CONFIG_MAX = __NL80211_ATTR_TID_CONFIG_AFTER_LAST - 1
+};
+
 /**
  * enum nl80211_packet_pattern_attr - packet pattern attribute
  * @__NL80211_PKTPAT_INVALID: invalid number for nested attribute
@@ -5343,6 +5387,11 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_AP_PMKSA_CACHING: Driver/device supports PMKSA caching
  *	(set/del PMKSA operations) in AP mode.
  *
+ * @NL80211_EXT_FEATURE_PER_TID_NOACK_CONFIG: Driver supports per TID NoAck
+ *	policy functionality.
+ * @NL80211_EXT_FEATURE_PER_STA_NOACK_CONFIG: Driver supports STA specific NoAck
+ *	policy functionality.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5384,6 +5433,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
 	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
 	NL80211_EXT_FEATURE_AP_PMKSA_CACHING,
+	NL80211_EXT_FEATURE_PER_TID_NOACK_CONFIG,
+	NL80211_EXT_FEATURE_PER_STA_NOACK_CONFIG,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 25a9e3b..25e8849 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -280,6 +280,13 @@ static int validate_ie_attr(const struct nlattr *attr,
 		NLA_POLICY_NESTED_ARRAY(nl80211_psmr_peer_attr_policy),
 };
 
+static const struct nla_policy
+nl80211_attr_tid_config_policy[NL80211_ATTR_TID_CONFIG_MAX + 1] = {
+	[NL80211_ATTR_TID_CONFIG_TID] = { .type = NLA_U8 },
+	[NL80211_ATTR_TID_CONFIG_NOACK] =
+			NLA_POLICY_MAX(NLA_U8, NL80211_TID_CONFIG_DISABLE),
+};
+
 const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
@@ -541,6 +548,8 @@ static int validate_ie_attr(const struct nlattr *attr,
 	[NL80211_ATTR_PEER_MEASUREMENTS] =
 		NLA_POLICY_NESTED(nl80211_pmsr_attr_policy),
 	[NL80211_ATTR_AIRTIME_WEIGHT] = NLA_POLICY_MIN(NLA_U16, 1),
+	[NL80211_ATTR_TID_CONFIG] =
+			NLA_POLICY_NESTED(nl80211_attr_tid_config_policy),
 };
 
 /* policy for the key attributes */
@@ -13259,6 +13268,93 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	return -ENOBUFS;
 }
 
+static int parse_tid_conf(struct cfg80211_registered_device *rdev,
+			  struct nlattr *attrs[],
+			  struct ieee80211_tid_cfg *tid_conf,
+			  const u8 *peer)
+{
+	tid_conf->tid = nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_TID]);
+	if (attrs[NL80211_ATTR_TID_CONFIG_NOACK]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_TID_NOACK_CONFIG))
+			return -ENOTSUPP;
+
+		if (peer && !wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_STA_NOACK_CONFIG))
+			return -ENOTSUPP;
+
+		tid_conf->tid_conf_mask |= IEEE80211_TID_CONF_NOACK;
+		tid_conf->noack =
+			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_NOACK]);
+	}
+
+	return 0;
+}
+
+static int nl80211_set_tid_config(struct sk_buff *skb,
+				  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct nlattr *attrs[NL80211_ATTR_TID_CONFIG_MAX + 1];
+	struct net_device *dev = info->user_ptr[1];
+	struct ieee80211_tid_config *tid_conf;
+	struct nlattr *tid;
+	int conf_idx = 0, rem_conf;
+	u32 num_conf = 0, size_of_conf;
+	int ret = -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_TID_CONFIG])
+		return -EINVAL;
+
+	if (!rdev->ops->set_tid_config)
+		return -EOPNOTSUPP;
+
+	nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
+			    rem_conf)
+		num_conf++;
+
+	size_of_conf = sizeof(struct ieee80211_tid_config) +
+		num_conf * sizeof(struct ieee80211_tid_cfg);
+
+	tid_conf = kzalloc(size_of_conf, GFP_KERNEL);
+	if (!tid_conf)
+		return -ENOMEM;
+
+	tid_conf->n_tid_conf = num_conf;
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		tid_conf->peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	else
+		tid_conf->peer = NULL;
+
+	nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
+			    rem_conf) {
+		ret = nla_parse_nested(attrs, NL80211_ATTR_TID_CONFIG_MAX, tid,
+				       NULL, NULL);
+
+		if (ret)
+			goto bad_tid_conf;
+
+		if (!attrs[NL80211_ATTR_TID_CONFIG_TID]) {
+			ret = -EINVAL;
+			goto bad_tid_conf;
+		}
+
+		ret = parse_tid_conf(rdev, attrs, &tid_conf->tid_conf[conf_idx],
+				     tid_conf->peer);
+		if (ret)
+			goto bad_tid_conf;
+
+		conf_idx++;
+	}
+
+	ret = rdev_set_tid_config(rdev, dev, tid_conf);
+
+bad_tid_conf:
+	kfree(tid_conf);
+	return ret;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -14193,6 +14289,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
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
index 5cb48d1..59e1905 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1272,4 +1272,15 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int rdev_set_tid_config(struct cfg80211_registered_device *rdev,
+				      struct net_device *dev,
+				      struct ieee80211_tid_config *tid_conf)
+{
+	int ret;
+
+	trace_rdev_set_tid_config(&rdev->wiphy, dev, tid_conf);
+	ret = rdev->ops->set_tid_config(&rdev->wiphy, dev, tid_conf);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 44b2ce1..186de1f 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3362,6 +3362,24 @@
 		  WIPHY_PR_ARG, WDEV_PR_ARG,
 		  (unsigned long long)__entry->cookie)
 );
+
+TRACE_EVENT(rdev_set_tid_config,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct ieee80211_tid_config *tid_conf),
+	TP_ARGS(wiphy, netdev, tid_conf),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, tid_conf->peer);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", peer: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer))
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.9.5

