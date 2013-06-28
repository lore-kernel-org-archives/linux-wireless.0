Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:55956 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961Ab3F1SzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v5] cfg80211/nl80211: Add packet coalesce support
Date: Fri, 28 Jun 2013 11:51:26 -0700
Message-ID: <1372445486-10466-1-git-send-email-bzhao@marvell.com> (sfid-20130628_211316_893307_F99997AB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

In most cases, host that receives IPv4 and IPv6 multicast/broadcast
packets does not do anything with these packets. Therefore the
reception of these unwanted packets causes unnecessary processing
and power consumption.

Packet coalesce feature helps to reduce number of received
interrupts to host by buffering these packets in firmware/hardware
for some predefined time. Received interrupt will be generated when
one of the following events occur.
a) Expiration of hardware timer whose expiration time is set to
maximum coalescing delay of matching coalesce rule.
b) Coalescing buffer in hardware reaches it's limit.
c) Packet doesn't match any of the configured coalesce rules.

This patch adds set/get configuration support for packet coalesce.
User needs to configure following parameters for creating a coalesce
rule.
a) Maximum coalescing delay
b) List of packet patterns which needs to be matched
c) Condition for coalescence. pattern 'match' or 'no match'
Multiple such rules can be created.

This feature needs to be advertised during driver initialization.
Drivers are supposed to do required firmware/hardware settings based
on user configuration.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: add documentation in nl80211.h and elabiration of "coalesce"
    in commit log (Luis R. Rodriguez)
v3: address comments (Johannes Berg):
    use enum variable for 'condition';
    remove new feature flag;
    remove spurious;
    update documentation
v4: similar to wowlan, take coalesce support information out of
    wiphy structure so that we don't need to allocate the space for
    devices which don't advertise the feature. (Johannes Berg)
    set/clear coalesce rules through configuration file. (Johannes Berg)
v5: Add new variable 'max_delay' to advertise max coalescing delay
    supported by a driver. (Johannes Berg)
    Use array of 'struct coalesce_rules' instead of array of coalesce_rules
    pointers ("**rules" -> "*rule"). (Johannes Berg)
    Add NULL checks while doing nla_get_*(). (Johannes Berg)
    Add one missing memory allocation error check. (Johannes Berg)


 include/net/cfg80211.h       |  53 ++++++++
 include/uapi/linux/nl80211.h |  90 ++++++++++++-
 net/wireless/core.c          |  11 ++
 net/wireless/core.h          |   2 +
 net/wireless/nl80211.c       | 307 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h       |   2 +
 6 files changed, 463 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 207b079..099c8d7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1776,6 +1776,35 @@ struct cfg80211_wowlan {
 };
 
 /**
+ * struct cfg80211_coalesce_rules - Coalesce rule parameters
+ *
+ * This structure defines coalesce rule for the device.
+ * @delay: maximum coalescing delay in msecs.
+ * @condition: condition for packet coalescence.
+ *	see &enum nl80211_coalesce_condition.
+ * @patterns: array of packet patterns
+ * @n_patterns: number of patterns
+ */
+struct cfg80211_coalesce_rules {
+	int delay;
+	enum nl80211_coalesce_condition condition;
+	struct cfg80211_pkt_pattern *patterns;
+	int n_patterns;
+};
+
+/**
+ * struct cfg80211_coalesce - Packet coalescing settings
+ *
+ * This structure defines coalescing settings.
+ * @rules: array of coalesce rules
+ * @n_rules: number of rules
+ */
+struct cfg80211_coalesce {
+	struct cfg80211_coalesce_rules *rules;
+	int n_rules;
+};
+
+/**
  * struct cfg80211_wowlan_wakeup - wakeup report
  * @disconnect: woke up by getting disconnected
  * @magic_pkt: woke up by receiving magic packet
@@ -2071,6 +2100,7 @@ struct cfg80211_update_ft_ies_params {
  *	driver can take the most appropriate actions.
  * @crit_proto_stop: Indicates critical protocol no longer needs increased link
  *	reliability. This operation can not fail.
+ * @set_coalesce: Set coalesce parameters.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2306,6 +2336,8 @@ struct cfg80211_ops {
 				    u16 duration);
 	void	(*crit_proto_stop)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+	int	(*set_coalesce)(struct wiphy *wiphy,
+				struct cfg80211_coalesce *coalesce);
 };
 
 /*
@@ -2532,6 +2564,25 @@ struct wiphy_wowlan_support {
 };
 
 /**
+ * struct wiphy_coalesce_support - coalesce support data
+ * @n_rules: maximum number of coalesce rules
+ * @max_delay: maximum supported coalescing delay in msecs
+ * @n_patterns: number of supported patterns in a rule
+ *	(see nl80211.h for the pattern definition)
+ * @pattern_max_len: maximum length of each pattern
+ * @pattern_min_len: minimum length of each pattern
+ * @max_pkt_offset: maximum Rx packet offset
+ */
+struct wiphy_coalesce_support {
+	int n_rules;
+	int max_delay;
+	int n_patterns;
+	int pattern_max_len;
+	int pattern_min_len;
+	int max_pkt_offset;
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
@@ -2641,6 +2692,7 @@ struct wiphy_wowlan_support {
  *	802.11-2012 8.4.2.29 for the defined fields.
  * @extended_capabilities_mask: mask of the valid values
  * @extended_capabilities_len: length of the extended capabilities
+ * @wiphy_coalesce_support coalesce: coalesce support information
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -2750,6 +2802,7 @@ struct wiphy {
 	const struct iw_handler_def *wext;
 #endif
 
+	const struct wiphy_coalesce_support *coalesce;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index de0ce80..5abc54d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -126,6 +126,31 @@
  */
 
 /**
+ * DOC: packet coalesce support
+ *
+ * In most cases, host that receives IPv4 and IPv6 multicast/broadcast
+ * packets does not do anything with these packets. Therefore the
+ * reception of these unwanted packets causes unnecessary processing
+ * and power consumption.
+ *
+ * Packet coalesce feature helps to reduce number of received interrupts
+ * to host by buffering these packets in firmware/hardware for some
+ * predefined time. Received interrupt will be generated when one of the
+ * following events occur.
+ * a) Expiration of hardware timer whose expiration time is set to maximum
+ * coalescing delay of matching coalesce rule.
+ * b) Coalescing buffer in hardware reaches it's limit.
+ * c) Packet doesn't match any of the configured coalesce rules.
+ *
+ * User needs to configure following parameters for creating a coalesce
+ * rule.
+ * a) Maximum coalescing delay
+ * b) List of packet patterns which needs to be matched
+ * c) Condition for coalescence. pattern 'match' or 'no match'
+ * Multiple such rules can be created.
+ */
+
+/**
  * enum nl80211_commands - supported nl80211 commands
  *
  * @NL80211_CMD_UNSPEC: unspecified command to catch errors
@@ -648,6 +673,9 @@
  * @NL80211_CMD_CRIT_PROTOCOL_STOP: Indicates the connection reliability can
  *	return back to normal.
  *
+ * @NL80211_CMD_GET_COALESCE: Get currently supported coalesce rules.
+ * @NL80211_CMD_SET_COALESCE: Configure coalesce rules or clear existing rules.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -810,6 +838,9 @@ enum nl80211_commands {
 	NL80211_CMD_CRIT_PROTOCOL_START,
 	NL80211_CMD_CRIT_PROTOCOL_STOP,
 
+	NL80211_CMD_GET_COALESCE,
+	NL80211_CMD_SET_COALESCE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1436,6 +1467,8 @@ enum nl80211_commands {
  *	allowed to be used with the first @NL80211_CMD_SET_STATION command to
  *	update a TDLS peer STA entry.
  *
+ * @NL80211_ATTR_COALESCE_RULE: Coalesce rule information.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1736,6 +1769,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PEER_AID,
 
+	NL80211_ATTR_COALESCE_RULE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3098,8 +3133,10 @@ enum nl80211_packet_pattern_attr {
  * @max_pkt_offset: maximum Rx packet offset
  *
  * This struct is carried in %NL80211_WOWLAN_TRIG_PKT_PATTERN when
- * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
- * capability information given by the kernel to userspace.
+ * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED or in
+ * %NL80211_ATTR_COALESCE_RULE_PKT_PATTERN when that is part of
+ * %NL80211_ATTR_COALESCE_RULE in the capability information given
+ * by the kernel to userspace.
  */
 struct nl80211_pattern_support {
 	__u32 max_patterns;
@@ -3318,6 +3355,55 @@ enum nl80211_wowlan_tcp_attrs {
 };
 
 /**
+ * struct nl80211_coalesce_rule_support - coalesce rule support information
+ * @max_rules: maximum number of rules supported
+ * @pat: packet pattern support information
+ * @max_delay: maximum supported coalescing delay in msecs
+ *
+ * This struct is carried in %NL80211_ATTR_COALESCE_RULE in the
+ * capability information given by the kernel to userspace.
+ */
+struct nl80211_coalesce_rule_support {
+	__u32 max_rules;
+	struct nl80211_pattern_support pat;
+	__u32 max_delay;
+} __attribute__((packed));
+
+/**
+ * enum nl80211_attr_coalesce_rule - coalesce rule attribute
+ * @__NL80211_COALESCE_RULE_INVALID: invalid number for nested attribute
+ * @NL80211_ATTR_COALESCE_RULE_DELAY: delay in msecs used for packet coalescing
+ * @NL80211_ATTR_COALESCE_RULE_CONDITION: condition for packet coalescence,
+ *	see &enum nl80211_coalesce_condition.
+ * @NL80211_ATTR_COALESCE_RULE_PKT_PATTERN: packet offset, pattern is matched
+ *	after these fixed number of bytes of received packet
+ * @NUM_NL80211_ATTR_COALESCE_RULE: number of attributes
+ * @NL80211_ATTR_COALESCE_RULE_MAX: max attribute number
+ */
+enum nl80211_attr_coalesce_rule {
+	__NL80211_COALESCE_RULE_INVALID,
+	NL80211_ATTR_COALESCE_RULE_DELAY,
+	NL80211_ATTR_COALESCE_RULE_CONDITION,
+	NL80211_ATTR_COALESCE_RULE_PKT_PATTERN,
+
+	/* keep last */
+	NUM_NL80211_ATTR_COALESCE_RULE,
+	NL80211_ATTR_COALESCE_RULE_MAX = NUM_NL80211_ATTR_COALESCE_RULE - 1
+};
+
+/**
+ * enum nl80211_coalesce_condition - coalesce rule conditions
+ * @NL80211_COALESCE_CONDITION_MATCH: coalaesce Rx packets when patterns
+ *	in a rule are matched.
+ * @NL80211_COALESCE_CONDITION_NO_MATCH: coalesce Rx packets when patterns
+ *	in a rule are not matched.
+ */
+enum nl80211_coalesce_condition {
+	NL80211_COALESCE_CONDITION_MATCH,
+	NL80211_COALESCE_CONDITION_NO_MATCH
+};
+
+/**
  * enum nl80211_iface_limit_attrs - limit attributes
  * @NL80211_IFACE_LIMIT_UNSPEC: (reserved)
  * @NL80211_IFACE_LIMIT_MAX: maximum number of interfaces that
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 672459b..853f754 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -462,6 +462,14 @@ int wiphy_register(struct wiphy *wiphy)
 		return -EINVAL;
 #endif
 
+	if (WARN_ON(wiphy->coalesce &&
+		    (!wiphy->coalesce->n_rules ||
+		     !wiphy->wowlan->n_patterns) &&
+		    (!wiphy->coalesce->pattern_min_len ||
+		     wiphy->coalesce->pattern_min_len >
+			wiphy->coalesce->pattern_max_len)))
+		return -EINVAL;
+
 	if (WARN_ON(wiphy->ap_sme_capa &&
 		    !(wiphy->flags & WIPHY_FLAG_HAVE_AP_SME)))
 		return -EINVAL;
@@ -668,6 +676,9 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rdev_set_wakeup(rdev, false);
 #endif
 	cfg80211_rdev_free_wowlan(rdev);
+
+	cfg80211_rdev_free_coalesce(rdev->coalesce);
+	rdev->coalesce = NULL;
 }
 EXPORT_SYMBOL(wiphy_unregister);
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a6b45bf..9ad43c6 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -79,6 +79,8 @@ struct cfg80211_registered_device {
 	/* netlink port which started critical protocol (0 means not started) */
 	u32 crit_proto_nlportid;
 
+	struct cfg80211_coalesce *coalesce;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __aligned(NETDEV_ALIGN);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 66382b1..d82cdf4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -403,6 +403,14 @@ nl80211_wowlan_tcp_policy[NUM_NL80211_WOWLAN_TCP] = {
 	[NL80211_WOWLAN_TCP_WAKE_MASK] = { .len = 1 },
 };
 
+/* policy for coalesce rule attributes */
+static const struct nla_policy
+nl80211_coalesce_policy[NUM_NL80211_ATTR_COALESCE_RULE] = {
+	[NL80211_ATTR_COALESCE_RULE_DELAY] = { .type = NLA_U32 },
+	[NL80211_ATTR_COALESCE_RULE_CONDITION] = { .type = NLA_U32 },
+	[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN] = { .type = NLA_NESTED },
+};
+
 /* policy for GTK rekey offload attributes */
 static const struct nla_policy
 nl80211_rekey_policy[NUM_NL80211_REKEY_DATA] = {
@@ -995,6 +1003,27 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 }
 #endif
 
+static int nl80211_send_coalesce(struct sk_buff *msg,
+				 struct cfg80211_registered_device *dev)
+{
+	struct nl80211_coalesce_rule_support rule;
+
+	if (!dev->wiphy.coalesce)
+		return 0;
+
+	rule.max_rules = dev->wiphy.coalesce->n_rules;
+	rule.max_delay = dev->wiphy.coalesce->max_delay;
+	rule.pat.max_patterns = dev->wiphy.coalesce->n_patterns;
+	rule.pat.min_pattern_len = dev->wiphy.coalesce->pattern_min_len;
+	rule.pat.max_pattern_len = dev->wiphy.coalesce->pattern_max_len;
+	rule.pat.max_pkt_offset = dev->wiphy.coalesce->max_pkt_offset;
+
+	if (nla_put(msg, NL80211_ATTR_COALESCE_RULE, sizeof(rule), &rule))
+		return -ENOBUFS;
+
+	return 0;
+}
+
 static int nl80211_send_band_rateinfo(struct sk_buff *msg,
 				      struct ieee80211_supported_band *sband)
 {
@@ -1513,6 +1542,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			    dev->wiphy.vht_capa_mod_mask))
 			goto nla_put_failure;
 
+		state->split_start++;
+		break;
+	case 10:
+		if (nl80211_send_coalesce(msg, dev))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start = 0;
 		break;
@@ -8032,6 +8067,263 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 }
 #endif
 
+static int nl80211_send_coalesce_rules(struct sk_buff *msg,
+				       struct cfg80211_registered_device *rdev)
+{
+	struct nlattr *nl_pats, *nl_pat, *nl_rule, *nl_rules;
+	int i, j, pat_len;
+	struct cfg80211_coalesce_rules *rule;
+
+	if (!rdev->coalesce->n_rules)
+		return 0;
+
+	nl_rules = nla_nest_start(msg, NL80211_ATTR_COALESCE_RULE);
+	if (!nl_rules)
+		return -ENOBUFS;
+
+	for (i = 0; i < rdev->coalesce->n_rules; i++) {
+		nl_rule = nla_nest_start(msg, i + 1);
+		if (!nl_rule)
+			return -ENOBUFS;
+
+		rule = &rdev->coalesce->rules[i];
+		if (nla_put_u32(msg, NL80211_ATTR_COALESCE_RULE_DELAY,
+				rule->delay))
+			return -ENOBUFS;
+
+		if (nla_put_u32(msg, NL80211_ATTR_COALESCE_RULE_CONDITION,
+				rule->condition))
+			return -ENOBUFS;
+
+		nl_pats = nla_nest_start(msg,
+				NL80211_ATTR_COALESCE_RULE_PKT_PATTERN);
+		if (!nl_pats)
+			return -ENOBUFS;
+
+		for (j = 0; j < rule->n_patterns; j++) {
+			nl_pat = nla_nest_start(msg, j + 1);
+			if (!nl_pat)
+				return -ENOBUFS;
+			pat_len = rule->patterns[j].pattern_len;
+			if (nla_put(msg, NL80211_PKTPAT_MASK,
+				    DIV_ROUND_UP(pat_len, 8),
+				    rule->patterns[j].mask) ||
+			    nla_put(msg, NL80211_PKTPAT_PATTERN, pat_len,
+				    rule->patterns[j].pattern) ||
+			    nla_put_u32(msg, NL80211_PKTPAT_OFFSET,
+					rule->patterns[j].pkt_offset))
+				return -ENOBUFS;
+			nla_nest_end(msg, nl_pat);
+		}
+		nla_nest_end(msg, nl_pats);
+		nla_nest_end(msg, nl_rule);
+	}
+	nla_nest_end(msg, nl_rules);
+
+	return 0;
+}
+
+static int nl80211_get_coalesce(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (!rdev->wiphy.coalesce)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_GET_COALESCE);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (rdev->coalesce && nl80211_send_coalesce_rules(msg, rdev))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+void cfg80211_rdev_free_coalesce(struct cfg80211_coalesce *coalesce)
+{
+	int i, j;
+	struct cfg80211_coalesce_rules *rule;
+
+	if (!coalesce)
+		return;
+
+	for (i = 0; i < coalesce->n_rules; i++) {
+		rule = &coalesce->rules[i];
+		for (j = 0; j < rule->n_patterns; j++)
+			kfree(rule->patterns[j].mask);
+		kfree(rule->patterns);
+	}
+	kfree(coalesce->rules);
+	kfree(coalesce);
+}
+
+static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
+				       struct nlattr *rule,
+				       struct cfg80211_coalesce_rules *new_rule)
+{
+	int err, i;
+	const struct wiphy_coalesce_support *coalesce = rdev->wiphy.coalesce;
+	struct nlattr *tb[NUM_NL80211_ATTR_COALESCE_RULE], *pat;
+	int rem, pat_len, mask_len, pkt_offset, n_patterns = 0;
+	struct nlattr *pat_tb[NUM_NL80211_PKTPAT];
+
+	err = nla_parse(tb, NL80211_ATTR_COALESCE_RULE_MAX, nla_data(rule),
+			nla_len(rule), nl80211_coalesce_policy);
+	if (err)
+		return err;
+
+	if (tb[NL80211_ATTR_COALESCE_RULE_DELAY])
+		new_rule->delay =
+			nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_DELAY]);
+	if (new_rule->delay > coalesce->max_delay)
+		return -EINVAL;
+
+	if (tb[NL80211_ATTR_COALESCE_RULE_CONDITION])
+		new_rule->condition =
+			nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_CONDITION]);
+	if (new_rule->condition != NL80211_COALESCE_CONDITION_MATCH &&
+	    new_rule->condition != NL80211_COALESCE_CONDITION_NO_MATCH)
+		return -EINVAL;
+
+	if (!tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN])
+		return -EINVAL;
+
+	nla_for_each_nested(pat, tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN],
+			    rem)
+		n_patterns++;
+	if (n_patterns > coalesce->n_patterns)
+		return -EINVAL;
+
+	new_rule->patterns = kcalloc(n_patterns, sizeof(new_rule->patterns[0]),
+				     GFP_KERNEL);
+	if (!new_rule->patterns)
+		return -ENOMEM;
+
+	new_rule->n_patterns = n_patterns;
+	i = 0;
+
+	nla_for_each_nested(pat, tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN],
+			    rem) {
+		nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
+			  nla_len(pat), NULL);
+		if (!pat_tb[NL80211_PKTPAT_MASK] ||
+		    !pat_tb[NL80211_PKTPAT_PATTERN])
+			return -EINVAL;
+		pat_len = nla_len(pat_tb[NL80211_PKTPAT_PATTERN]);
+		mask_len = DIV_ROUND_UP(pat_len, 8);
+		if (nla_len(pat_tb[NL80211_PKTPAT_MASK]) != mask_len)
+			return -EINVAL;
+		if (pat_len > coalesce->pattern_max_len ||
+		    pat_len < coalesce->pattern_min_len)
+			return -EINVAL;
+
+		if (!pat_tb[NL80211_PKTPAT_OFFSET])
+			pkt_offset = 0;
+		else
+			pkt_offset = nla_get_u32(pat_tb[NL80211_PKTPAT_OFFSET]);
+		if (pkt_offset > coalesce->max_pkt_offset)
+			return -EINVAL;
+		new_rule->patterns[i].pkt_offset = pkt_offset;
+
+		new_rule->patterns[i].mask =
+			kmalloc(mask_len + pat_len, GFP_KERNEL);
+		if (!new_rule->patterns[i].mask)
+			return -ENOMEM;
+		new_rule->patterns[i].pattern =
+			new_rule->patterns[i].mask + mask_len;
+		memcpy(new_rule->patterns[i].mask,
+		       nla_data(pat_tb[NL80211_PKTPAT_MASK]), mask_len);
+		new_rule->patterns[i].pattern_len = pat_len;
+		memcpy(new_rule->patterns[i].pattern,
+		       nla_data(pat_tb[NL80211_PKTPAT_PATTERN]), pat_len);
+		i++;
+	}
+
+	return 0;
+}
+
+static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	const struct wiphy_coalesce_support *coalesce = rdev->wiphy.coalesce;
+	struct cfg80211_coalesce new_coalesce = {};
+	struct cfg80211_coalesce *n_coalesce;
+	int err, rem_rule, n_rules = 0, i, j;
+	struct nlattr *rule;
+	struct cfg80211_coalesce_rules *tmp_rule;
+
+	if (!rdev->wiphy.coalesce || !rdev->ops->set_coalesce)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_COALESCE_RULE]) {
+		cfg80211_rdev_free_coalesce(rdev->coalesce);
+		rdev->coalesce = NULL;
+		rdev->ops->set_coalesce(&rdev->wiphy, NULL);
+		return 0;
+	}
+
+	nla_for_each_nested(rule, info->attrs[NL80211_ATTR_COALESCE_RULE],
+			    rem_rule)
+		n_rules++;
+	if (n_rules > coalesce->n_rules)
+		return -EINVAL;
+
+	new_coalesce.rules = kcalloc(n_rules, sizeof(new_coalesce.rules[0]),
+				     GFP_KERNEL);
+	if (!new_coalesce.rules)
+		return -ENOMEM;
+
+	new_coalesce.n_rules = n_rules;
+	i = 0;
+
+	nla_for_each_nested(rule, info->attrs[NL80211_ATTR_COALESCE_RULE],
+			    rem_rule) {
+		err = nl80211_parse_coalesce_rule(rdev, rule,
+						  &new_coalesce.rules[i]);
+		if (err)
+			goto error;
+
+		i++;
+	}
+
+	err = rdev->ops->set_coalesce(&rdev->wiphy, &new_coalesce);
+	if (err)
+		goto error;
+
+	n_coalesce = kmemdup(&new_coalesce, sizeof(new_coalesce), GFP_KERNEL);
+	if (!n_coalesce) {
+		err = -ENOMEM;
+		goto error;
+	}
+	cfg80211_rdev_free_coalesce(rdev->coalesce);
+	rdev->coalesce = n_coalesce;
+
+	return 0;
+error:
+	for (i = 0; i < new_coalesce.n_rules; i++) {
+		tmp_rule = &new_coalesce.rules[i];
+		for (j = 0; j < tmp_rule->n_patterns; j++)
+			kfree(tmp_rule->patterns[j].mask);
+		kfree(tmp_rule->patterns);
+	}
+	kfree(new_coalesce.rules);
+
+	return err;
+}
+
 static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -9039,6 +9331,21 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_GET_COALESCE,
+		.doit = nl80211_get_coalesce,
+		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_SET_COALESCE,
+		.doit = nl80211_set_coalesce,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
 	}
 };
 
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index a4073e8..d5ef819 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -74,4 +74,6 @@ nl80211_radar_notify(struct cfg80211_registered_device *rdev,
 		     enum nl80211_radar_event event,
 		     struct net_device *netdev, gfp_t gfp);
 
+void cfg80211_rdev_free_coalesce(struct cfg80211_coalesce *coalesce);
+
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.8.0

