Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:58522 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442Ab3E3XgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 19:36:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 2/2] cfg80211/nl80211: Add packet coalesce support
Date: Thu, 30 May 2013 16:36:02 -0700
Message-ID: <1369956962-23038-2-git-send-email-bzhao@marvell.com> (sfid-20130531_013626_360569_4AA995BE)
In-Reply-To: <1369956962-23038-1-git-send-email-bzhao@marvell.com>
References: <1369956962-23038-1-git-send-email-bzhao@marvell.com>
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

 include/net/cfg80211.h       |  51 ++++++++
 include/uapi/linux/nl80211.h |  89 +++++++++++++-
 net/wireless/core.c          |   2 +
 net/wireless/core.h          |   2 +
 net/wireless/nl80211.c       | 287 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h       |   2 +
 6 files changed, 431 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9d50877..758c783 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1742,6 +1742,35 @@ struct cfg80211_wowlan {
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
+	struct cfg80211_coalesce_rules **rules;
+	int n_rules;
+};
+
+/**
  * struct cfg80211_wowlan_wakeup - wakeup report
  * @disconnect: woke up by getting disconnected
  * @magic_pkt: woke up by receiving magic packet
@@ -2037,6 +2066,7 @@ struct cfg80211_update_ft_ies_params {
  *	driver can take the most appropriate actions.
  * @crit_proto_stop: Indicates critical protocol no longer needs increased link
  *	reliability. This operation can not fail.
+ * @set_coalesce: Set coalesce parameters.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2272,6 +2302,8 @@ struct cfg80211_ops {
 				    u16 duration);
 	void	(*crit_proto_stop)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+	int	(*set_coalesce)(struct wiphy *wiphy,
+				struct cfg80211_coalesce_rules *rule);
 };
 
 /*
@@ -2496,6 +2528,23 @@ struct wiphy_wowlan_support {
 };
 
 /**
+ * struct wiphy_coalesce_support - coalesce support data
+ * @n_rules: maximum number of coalesce rules
+ * @n_patterns: number of supported patterns
+ *	(see nl80211.h for the pattern definition)
+ * @pattern_max_len: maximum length of each pattern
+ * @pattern_min_len: minimum length of each pattern
+ * @max_pkt_offset: maximum Rx packet offset
+ */
+struct wiphy_coalesce_support {
+	int n_rules;
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
@@ -2605,6 +2654,7 @@ struct wiphy_wowlan_support {
  *	802.11-2012 8.4.2.29 for the defined fields.
  * @extended_capabilities_mask: mask of the valid values
  * @extended_capabilities_len: length of the extended capabilities
+ * @wiphy_coalesce_support coalesce: coalesce support information
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -2714,6 +2764,7 @@ struct wiphy {
 	const struct iw_handler_def *wext;
 #endif
 
+	struct wiphy_coalesce_support coalesce;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7afc244..f09df31 100644
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
@@ -648,6 +673,10 @@
  * @NL80211_CMD_CRIT_PROTOCOL_STOP: Indicates the connection reliability can
  *	return back to normal.
  *
+ * @NL80211_CMD_GET_COALESCE: Get currently supported coalesce rules.
+ *
+ * @NL80211_CMD_SET_COALESCE: Add new coalesce rule or clear existing rules.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -810,6 +839,9 @@ enum nl80211_commands {
 	NL80211_CMD_CRIT_PROTOCOL_START,
 	NL80211_CMD_CRIT_PROTOCOL_STOP,
 
+	NL80211_CMD_GET_COALESCE,
+	NL80211_CMD_SET_COALESCE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1436,6 +1468,8 @@ enum nl80211_commands {
  *	allowed to be used with the first @NL80211_CMD_SET_STATION command to
  *	update a TDLS peer STA entry.
  *
+ * @NL80211_ATTR_COALESCE_RULE: Coalesce rule information.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1736,6 +1770,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PEER_AID,
 
+	NL80211_ATTR_COALESCE_RULE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3089,8 +3125,10 @@ enum nl80211_packet_pattern_attr {
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
@@ -3309,6 +3347,53 @@ enum nl80211_wowlan_tcp_attrs {
 };
 
 /**
+ * struct nl80211_coalesce_rule_support - coalesce rule support information
+ * @max_rules: maximum number of rules supported
+ * @pat: packet pattern support information
+ *
+ * This struct is carried in %NL80211_ATTR_COALESCE_RULE in the
+ * capability information given by the kernel to userspace.
+ */
+struct nl80211_coalesce_rule_support {
+	__u32 max_rules;
+	struct nl80211_pattern_support pat;
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
index 41cec17..524dffc 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -668,6 +668,8 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rdev_set_wakeup(rdev, false);
 #endif
 	cfg80211_rdev_free_wowlan(rdev);
+
+	cfg80211_rdev_free_coalesce(rdev);
 }
 EXPORT_SYMBOL(wiphy_unregister);
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a65eaf8..f6b744b 100644
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
index af605fe..461f808 100644
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
@@ -998,6 +1006,27 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 }
 #endif
 
+static int nl80211_send_coalesce(struct sk_buff *msg,
+				 struct cfg80211_registered_device *dev,
+				 bool large)
+{
+	struct nl80211_coalesce_rule_support rule;
+
+	if (!dev->wiphy.coalesce.n_patterns || !dev->wiphy.coalesce.n_rules)
+		return 0;
+
+	rule.max_rules = dev->wiphy.coalesce.n_rules;
+	rule.pat.max_patterns = dev->wiphy.coalesce.n_patterns;
+	rule.pat.min_pattern_len = dev->wiphy.coalesce.pattern_min_len;
+	rule.pat.max_pattern_len = dev->wiphy.coalesce.pattern_max_len;
+	rule.pat.max_pkt_offset = dev->wiphy.coalesce.max_pkt_offset;
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
@@ -1509,6 +1538,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			    dev->wiphy.vht_capa_mod_mask))
 			goto nla_put_failure;
 
+		(*split_start)++;
+		break;
+	case 10:
+		if (nl80211_send_coalesce(msg, dev, split))
+			goto nla_put_failure;
+
 		/* done */
 		*split_start = 0;
 		break;
@@ -7956,6 +7991,243 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
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
+		rule = rdev->coalesce->rules[i];
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
+	if (!rdev->wiphy.coalesce.n_patterns || !rdev->wiphy.coalesce.n_rules)
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
+void cfg80211_rdev_free_coalesce(struct cfg80211_registered_device *rdev)
+{
+	int i, j;
+	struct cfg80211_coalesce_rules *rule;
+
+	if (!rdev->coalesce)
+		return;
+
+	for (i = 0; i < rdev->coalesce->n_rules; i++) {
+		rule = rdev->coalesce->rules[i];
+		for (j = 0; j < rule->n_patterns; j++)
+			kfree(rule->patterns[j].mask);
+		kfree(rule->patterns);
+		kfree(rule);
+	}
+	kfree(rdev->coalesce->rules);
+	kfree(rdev->coalesce);
+}
+
+static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct nlattr *tb[NUM_NL80211_ATTR_COALESCE_RULE];
+	struct wiphy_coalesce_support *coalesce = &rdev->wiphy.coalesce;
+	struct cfg80211_coalesce_rules new_rule = {};
+	struct cfg80211_coalesce_rules *nrule;
+	int err, i;
+
+	if (!rdev->wiphy.coalesce.n_patterns || !rdev->wiphy.coalesce.n_rules)
+		return -EOPNOTSUPP;
+	if (!rdev->ops->set_coalesce)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_COALESCE_RULE]) {
+		cfg80211_rdev_free_coalesce(rdev);
+		rdev->coalesce = NULL;
+		rdev->ops->set_coalesce(&rdev->wiphy, NULL);
+		return 0;
+	}
+
+	if (!rdev->coalesce) {
+		rdev->coalesce = kzalloc(sizeof(*rdev->coalesce), GFP_KERNEL);
+		rdev->coalesce->rules = kcalloc(coalesce->n_rules,
+						sizeof(void *), GFP_KERNEL);
+	}
+
+	if (rdev->coalesce->n_rules >= coalesce->n_rules)
+		return -EOPNOTSUPP;
+
+	err = nla_parse(tb, NL80211_ATTR_COALESCE_RULE_MAX,
+			nla_data(info->attrs[NL80211_ATTR_COALESCE_RULE]),
+			nla_len(info->attrs[NL80211_ATTR_COALESCE_RULE]),
+			nl80211_coalesce_policy);
+	if (err)
+		return err;
+
+	new_rule.delay = nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_DELAY]);
+	new_rule.condition =
+		nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_CONDITION]);
+	if (new_rule.condition != NL80211_COALESCE_CONDITION_MATCH &&
+	    new_rule.condition != NL80211_COALESCE_CONDITION_NO_MATCH)
+		return -EINVAL;
+
+	if (tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN]) {
+		struct nlattr *pat;
+		int n_patterns = 0;
+		int rem, pat_len, mask_len, pkt_offset;
+		struct nlattr *pat_tb[NUM_NL80211_PKTPAT];
+
+		nla_for_each_nested(pat,
+				    tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN],
+				    rem)
+			n_patterns++;
+		if (n_patterns > coalesce->n_patterns)
+			return -EINVAL;
+
+		new_rule.patterns = kcalloc(n_patterns,
+						sizeof(new_rule.patterns[0]),
+						GFP_KERNEL);
+		if (!new_rule.patterns)
+			return -ENOMEM;
+
+		new_rule.n_patterns = n_patterns;
+		i = 0;
+
+		nla_for_each_nested(pat,
+				    tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN],
+				    rem) {
+			nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
+				  nla_len(pat), NULL);
+			err = -EINVAL;
+			if (!pat_tb[NL80211_PKTPAT_MASK] ||
+			    !pat_tb[NL80211_PKTPAT_PATTERN])
+				goto error;
+			pat_len = nla_len(pat_tb[NL80211_PKTPAT_PATTERN]);
+			mask_len = DIV_ROUND_UP(pat_len, 8);
+			if (nla_len(pat_tb[NL80211_PKTPAT_MASK]) !=
+			    mask_len)
+				goto error;
+			if (pat_len > coalesce->pattern_max_len ||
+			    pat_len < coalesce->pattern_min_len)
+				goto error;
+
+			if (!pat_tb[NL80211_PKTPAT_OFFSET])
+				pkt_offset = 0;
+			else
+				pkt_offset = nla_get_u32(
+					pat_tb[NL80211_PKTPAT_OFFSET]);
+			if (pkt_offset > coalesce->max_pkt_offset)
+				goto error;
+			new_rule.patterns[i].pkt_offset = pkt_offset;
+
+			new_rule.patterns[i].mask =
+				kmalloc(mask_len + pat_len, GFP_KERNEL);
+			if (!new_rule.patterns[i].mask) {
+				err = -ENOMEM;
+				goto error;
+			}
+			new_rule.patterns[i].pattern =
+				new_rule.patterns[i].mask + mask_len;
+			memcpy(new_rule.patterns[i].mask,
+			       nla_data(pat_tb[NL80211_PKTPAT_MASK]),
+			       mask_len);
+			new_rule.patterns[i].pattern_len = pat_len;
+			memcpy(new_rule.patterns[i].pattern,
+			       nla_data(pat_tb[NL80211_PKTPAT_PATTERN]),
+			       pat_len);
+			i++;
+		}
+	}
+
+	nrule = kmemdup(&new_rule, sizeof(new_rule), GFP_KERNEL);
+	if (!nrule) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	err = rdev->ops->set_coalesce(&rdev->wiphy, nrule);
+	if (err)
+		goto error;
+
+	rdev->coalesce->rules[rdev->coalesce->n_rules++] = nrule;
+
+	return 0;
+
+error:
+	for (i = 0; i < new_rule.n_patterns; i++)
+		kfree(new_rule.patterns[i].mask);
+	kfree(new_rule.patterns);
+	return err;
+}
+
 static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -8962,6 +9234,21 @@ static struct genl_ops nl80211_ops[] = {
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
index a4073e8..44341bf 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -74,4 +74,6 @@ nl80211_radar_notify(struct cfg80211_registered_device *rdev,
 		     enum nl80211_radar_event event,
 		     struct net_device *netdev, gfp_t gfp);
 
+void cfg80211_rdev_free_coalesce(struct cfg80211_registered_device *rdev);
+
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.8.0

