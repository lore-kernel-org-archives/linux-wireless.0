Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64793 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbaAVMoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 07:44:14 -0500
Received: by mail-ee0-f46.google.com with SMTP id c13so4764373eek.33
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 04:44:13 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/3] cfg80211: introduce regulatory wide bandwidth flag
Date: Wed, 22 Jan 2014 13:43:43 +0100
Message-Id: <1390394624-3927-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140122_134419_437681_F34570E4)
In-Reply-To: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce regulatory flags field, NL80211_REG_WIDE_BW
country flag and new attribute NL80211_ATTR_REG_FLAGS.
If NL80211_REG_WIDE_BW is set, check rules and calculate
maximum bandwidth base on all contiguous regulatory rules.
If unset get maximum badwitdh from regulatory rule.
This patch is backward compatible with current CRDA/db.txt
implementation.

Base on calculated maximum bandwidth set channels
flags (eg. IEEE80211_CHAN_NO_80MHZ).

In case we will check two regulatory rules as below:
        (5170 - 5250 @ 80), (N/A, 20)
        (5250 - 5330 @ 80), (N/A, 20), DFS

If we set WIDE_BW country flag, we will calulate
maximum available bandwidth as 160MHz, while
two reg rules are frequency contiguous and frequency
diff is 5330 - 5170 = 160.

If we don't set WIDE_BW flag we will get maximum
bandwidth from regulatory database - 80MHz in example
above.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/regulatory.h     |    1 +
 include/uapi/linux/nl80211.h |   14 ++++++
 net/wireless/nl80211.c       |   11 ++++-
 net/wireless/reg.c           |  102 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 112 insertions(+), 16 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index b07cdc9..7b938cd 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -161,6 +161,7 @@ struct ieee80211_regdomain {
 	struct rcu_head rcu_head;
 	u32 n_reg_rules;
 	char alpha2[2];
+	u32 flags;
 	enum nl80211_dfs_regions dfs_region;
 	struct ieee80211_reg_rule reg_rules[];
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 91054fd..8546293 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1555,6 +1555,7 @@ enum nl80211_commands {
  *	data is in the format defined for the payload of the QoS Map Set element
  *	in IEEE Std 802.11-2012, 8.4.2.97.
  *
+ * @NL80211_ATTR_REG_FLAGS: Regulatory flags, see &enum nl80211_reg_flags
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1883,6 +1884,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_QOS_MAP,
 
+	NL80211_ATTR_REG_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2465,6 +2468,17 @@ enum nl80211_sched_scan_match_attr {
 #define NL80211_ATTR_SCHED_SCAN_MATCH_SSID NL80211_SCHED_SCAN_MATCH_ATTR_SSID
 
 /**
+ * enum nl80211_reg_flags - regulatory flags
+ * @NL80211_REG_FLAG_WIDE_BW: Calculate maximum available bandwidth
+ *	base on contiguous regulatory rules instead of using
+ *	maximum bandwidth from regulatory database.
+ *
+ */
+enum nl80211_reg_flags {
+	NL80211_REG_FLAG_WIDE_BW	= 1<<0,
+};
+
+/**
  * enum nl80211_reg_rule_flags - regulatory rule flags
  *
  * @NL80211_RRF_NO_OFDM: OFDM modulation not allowed
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0afd82..fbdb9bb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -384,6 +384,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 	[NL80211_ATTR_QOS_MAP] = { .type = NLA_BINARY,
 				   .len = IEEE80211_QOS_MAP_LEN_MAX },
+	[NL80211_ATTR_REG_FLAGS] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -5101,7 +5102,8 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 
 	if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2, regdom->alpha2) ||
 	    (regdom->dfs_region &&
-	     nla_put_u8(msg, NL80211_ATTR_DFS_REGION, regdom->dfs_region)))
+	     nla_put_u8(msg, NL80211_ATTR_DFS_REGION, regdom->dfs_region)) ||
+	    nla_put_u32(msg, NL80211_ATTR_REG_FLAGS, regdom->flags))
 		goto nla_put_failure_rcu;
 
 	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
@@ -5160,7 +5162,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *nl_reg_rule;
 	char *alpha2 = NULL;
 	int rem_reg_rules = 0, r = 0;
-	u32 num_rules = 0, rule_idx = 0, size_of_regd;
+	u32 num_rules = 0, rule_idx = 0, size_of_regd, flags = 0;
 	enum nl80211_dfs_regions dfs_region = NL80211_DFS_UNSET;
 	struct ieee80211_regdomain *rd = NULL;
 
@@ -5175,6 +5177,9 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_DFS_REGION])
 		dfs_region = nla_get_u8(info->attrs[NL80211_ATTR_DFS_REGION]);
 
+	if (info->attrs[NL80211_ATTR_REG_FLAGS])
+		flags = nla_get_u32(info->attrs[NL80211_ATTR_REG_FLAGS]);
+
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
 			    rem_reg_rules) {
 		num_rules++;
@@ -5203,6 +5208,8 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	if (reg_supported_dfs_region(dfs_region))
 		rd->dfs_region = dfs_region;
 
+	rd->flags = flags;
+
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
 			    rem_reg_rules) {
 		nla_parse(tb, NL80211_REG_RULE_ATTR_MAX,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d58a09c..33767db 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -541,8 +541,63 @@ static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
 	return regd;
 }
 
+static unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
+					  const struct ieee80211_reg_rule *rule)
+{
+	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
+	const struct ieee80211_freq_range *freq_range_tmp;
+	const struct ieee80211_reg_rule *tmp;
+	u32 start_freq, end_freq, idx, no;
+
+	/* First check if strict regulatory database bandwidth calculation */
+	if (!(rd->flags & NL80211_REG_FLAG_WIDE_BW))
+		return freq_range->end_freq_khz - freq_range->start_freq_khz;
+
+	/* Next check all contiguous rules */
+	for (idx = 0; idx < rd->n_reg_rules; idx++)
+		if (rule == &rd->reg_rules[idx])
+			break;
+
+	if (idx == rd->n_reg_rules)
+		return 0;
+
+	/* get start_freq */
+	no = idx;
+
+	while (no) {
+		tmp = &rd->reg_rules[--no];
+		freq_range_tmp = &tmp->freq_range;
+
+		if (freq_range_tmp->end_freq_khz < freq_range->start_freq_khz)
+			break;
+
+		freq_range = freq_range_tmp;
+	};
+
+	start_freq = freq_range->start_freq_khz;
+
+	/* get end_freq */
+	freq_range = &rule->freq_range;
+	no = idx;
+
+	while (no < rd->n_reg_rules - 1) {
+		tmp = &rd->reg_rules[++no];
+		freq_range_tmp = &tmp->freq_range;
+
+		if (freq_range_tmp->start_freq_khz > freq_range->end_freq_khz)
+			break;
+
+		freq_range = freq_range_tmp;
+	}
+
+	end_freq = freq_range->end_freq_khz;
+
+	return end_freq - start_freq;
+}
+
 /* Sanity check on a regulatory rule */
-static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
+static bool is_valid_reg_rule(const struct ieee80211_regdomain *rd,
+			      const struct ieee80211_reg_rule *rule)
 {
 	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
 	u32 freq_diff;
@@ -553,10 +608,12 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 	if (freq_range->start_freq_khz > freq_range->end_freq_khz)
 		return false;
 
-	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
+	if (freq_range->end_freq_khz <= freq_range->start_freq_khz)
+		return false;
+
+	freq_diff = reg_get_max_bandwidth(rd, rule);
 
-	if (freq_range->end_freq_khz <= freq_range->start_freq_khz ||
-	    freq_range->max_bandwidth_khz > freq_diff)
+	if (freq_range->max_bandwidth_khz > freq_diff)
 		return false;
 
 	return true;
@@ -575,7 +632,7 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
 
 	for (i = 0; i < rd->n_reg_rules; i++) {
 		reg_rule = &rd->reg_rules[i];
-		if (!is_valid_reg_rule(reg_rule))
+		if (!is_valid_reg_rule(rd, reg_rule))
 			return false;
 	}
 
@@ -645,11 +702,17 @@ reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
 	return dfs_region1;
 }
 
+static u32 reg_intersect_flags(const u32 flags1, const u32 flags2)
+{
+	return flags1 | flags2;
+}
+
 /*
  * Helper for regdom_intersect(), this does the real
  * mathematical intersection fun
  */
-static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
+static int reg_rules_intersect(const struct ieee80211_regdomain *rd,
+			       const struct ieee80211_reg_rule *rule1,
 			       const struct ieee80211_reg_rule *rule2,
 			       struct ieee80211_reg_rule *intersected_rule)
 {
@@ -674,7 +737,7 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 	freq_range->max_bandwidth_khz = min(freq_range1->max_bandwidth_khz,
 					    freq_range2->max_bandwidth_khz);
 
-	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
+	freq_diff = reg_get_max_bandwidth(rd, intersected_rule);
 	if (freq_range->max_bandwidth_khz > freq_diff)
 		freq_range->max_bandwidth_khz = freq_diff;
 
@@ -685,7 +748,7 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 
 	intersected_rule->flags = rule1->flags | rule2->flags;
 
-	if (!is_valid_reg_rule(intersected_rule))
+	if (!is_valid_reg_rule(rd, intersected_rule))
 		return -EINVAL;
 
 	return 0;
@@ -713,7 +776,7 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 	unsigned int num_rules = 0, rule_idx = 0;
 	const struct ieee80211_reg_rule *rule1, *rule2;
 	struct ieee80211_reg_rule *intersected_rule;
-	struct ieee80211_regdomain *rd;
+	struct ieee80211_regdomain *rd, dummy_rd;
 	/* This is just a dummy holder to help us count */
 	struct ieee80211_reg_rule dummy_rule;
 
@@ -728,11 +791,14 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 	 * All rules that do check out OK are valid.
 	 */
 
+	dummy_rd.flags = reg_intersect_flags(rd1->flags, rd2->flags);
+
 	for (x = 0; x < rd1->n_reg_rules; x++) {
 		rule1 = &rd1->reg_rules[x];
 		for (y = 0; y < rd2->n_reg_rules; y++) {
 			rule2 = &rd2->reg_rules[y];
-			if (!reg_rules_intersect(rule1, rule2, &dummy_rule))
+			if (!reg_rules_intersect(&dummy_rd, rule1, rule2,
+						 &dummy_rule))
 				num_rules++;
 		}
 	}
@@ -747,6 +813,8 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 	if (!rd)
 		return NULL;
 
+	rd->flags = reg_intersect_flags(rd1->flags, rd2->flags);
+
 	for (x = 0; x < rd1->n_reg_rules && rule_idx < num_rules; x++) {
 		rule1 = &rd1->reg_rules[x];
 		for (y = 0; y < rd2->n_reg_rules && rule_idx < num_rules; y++) {
@@ -757,7 +825,8 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 			 * a memcpy()
 			 */
 			intersected_rule = &rd->reg_rules[rule_idx];
-			r = reg_rules_intersect(rule1, rule2, intersected_rule);
+			r = reg_rules_intersect(rd, rule1, rule2,
+						intersected_rule);
 			/*
 			 * No need to memset here the intersected rule here as
 			 * we're not using the stack anymore
@@ -912,6 +981,8 @@ static void handle_channel(struct wiphy *wiphy,
 	const struct ieee80211_freq_range *freq_range = NULL;
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr = get_last_request();
+	const struct ieee80211_regdomain *regd;
+	u32 max_bandwidth_khz;
 
 	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
@@ -953,11 +1024,14 @@ static void handle_channel(struct wiphy *wiphy,
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
+	regd = reg_get_regdomain(wiphy);
+	max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
+
+	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
+	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
+	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
 		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
 	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
-- 
1.7.9.5

