Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:51869 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaA3Iwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 03:52:38 -0500
Received: by mail-ee0-f51.google.com with SMTP id b57so1418331eek.38
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jan 2014 00:52:37 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v4] cfg80211: regulatory introduce maximum bandwidth calculation
Date: Thu, 30 Jan 2014 09:52:20 +0100
Message-Id: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140130_095243_049246_835D211C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case we will get regulatory request with rule
where max_bandwidth_khz is set to 0 handle this
case as a special one.

If max_bandwidth_khz == 0 we should calculate maximum
available bandwidth base on all frequency contiguous rules.
In case we need auto calculation we just have to set:

country PL: DFS-ETSI
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ AUTO), (N/A, 20)
        (5250 - 5330 @ AUTO), (N/A, 20), DFS
        (5490 - 5710 @ 80), (N/A, 27), DFS

This mean we will calculate maximum bw for rules where
AUTO (N/A) were set, 160MHz (5330 - 5170) in example above.
So we will get:
        (5170 - 5250 @ 160), (N/A, 20)
        (5250 - 5330 @ 160), (N/A, 20), DFS

In other case:
country FR: DFS-ETSI
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ AUTO), (N/A, 20)
        (5250 - 5330 @ 80), (N/A, 20), DFS
        (5490 - 5710 @ 80), (N/A, 27), DFS

We will get 80MHz (5250 - 5170):
        (5170 - 5250 @ 80), (N/A, 20)
        (5250 - 5330 @ 80), (N/A, 20), DFS

Base on this calculations we will set correct channel
bandwidth flags (eg. IEEE80211_CHAN_NO_80MHZ).

We don't need any changes in CRDA or internal regulatory.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
*V4 - add nl80211 description, changed rule intersection little bit

Intersection input/output:
bw1: 20   40   0(40)   0(20)   0
bw2: 40   20   20      40      0
out: 20   20   20      20      0

 include/uapi/linux/nl80211.h |    3 +-
 net/wireless/nl80211.c       |   15 +++--
 net/wireless/reg.c           |  130 ++++++++++++++++++++++++++++++++++++------
 net/wireless/reg.h           |    2 +
 4 files changed, 128 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 474ce32..d5b4f28 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2437,7 +2437,8 @@ enum nl80211_reg_type {
  * 	in KHz. This is not a center a frequency but an actual regulatory
  * 	band edge.
  * @NL80211_ATTR_FREQ_RANGE_MAX_BW: maximum allowed bandwidth for this
- * 	frequency range, in KHz.
+ *	frequency range, in KHz. If not present or 0, maximum available
+ *	bandwidth should be calculated base on contiguous rules.
  * @NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN: the maximum allowed antenna gain
  * 	for a given frequency range. The value is in mBi (100 * dBi).
  * 	If you don't have one then don't send this.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8b32a1f..e749076 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4654,8 +4654,6 @@ static int parse_reg_rule(struct nlattr *tb[],
 		return -EINVAL;
 	if (!tb[NL80211_ATTR_FREQ_RANGE_END])
 		return -EINVAL;
-	if (!tb[NL80211_ATTR_FREQ_RANGE_MAX_BW])
-		return -EINVAL;
 	if (!tb[NL80211_ATTR_POWER_RULE_MAX_EIRP])
 		return -EINVAL;
 
@@ -4665,8 +4663,9 @@ static int parse_reg_rule(struct nlattr *tb[],
 		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_START]);
 	freq_range->end_freq_khz =
 		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_END]);
-	freq_range->max_bandwidth_khz =
-		nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
+	if (tb[NL80211_ATTR_FREQ_RANGE_MAX_BW])
+		freq_range->max_bandwidth_khz =
+			nla_get_u32(tb[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
 
 	power_rule->max_eirp =
 		nla_get_u32(tb[NL80211_ATTR_POWER_RULE_MAX_EIRP]);
@@ -5136,6 +5135,7 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 		const struct ieee80211_reg_rule *reg_rule;
 		const struct ieee80211_freq_range *freq_range;
 		const struct ieee80211_power_rule *power_rule;
+		unsigned int max_bandwidth_khz;
 
 		reg_rule = &regdom->reg_rules[i];
 		freq_range = &reg_rule->freq_range;
@@ -5145,6 +5145,11 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 		if (!nl_reg_rule)
 			goto nla_put_failure_rcu;
 
+		max_bandwidth_khz = freq_range->max_bandwidth_khz;
+		if (!max_bandwidth_khz)
+			max_bandwidth_khz = reg_get_max_bandwidth(regdom,
+								  reg_rule);
+
 		if (nla_put_u32(msg, NL80211_ATTR_REG_RULE_FLAGS,
 				reg_rule->flags) ||
 		    nla_put_u32(msg, NL80211_ATTR_FREQ_RANGE_START,
@@ -5152,7 +5157,7 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
 		    nla_put_u32(msg, NL80211_ATTR_FREQ_RANGE_END,
 				freq_range->end_freq_khz) ||
 		    nla_put_u32(msg, NL80211_ATTR_FREQ_RANGE_MAX_BW,
-				freq_range->max_bandwidth_khz) ||
+				max_bandwidth_khz) ||
 		    nla_put_u32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,
 				power_rule->max_antenna_gain) ||
 		    nla_put_u32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7c71f74..246bddd 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -538,6 +538,61 @@ static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
 	return get_cfg80211_regdom();
 }
 
+unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
+				   const struct ieee80211_reg_rule *rule)
+{
+	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
+	const struct ieee80211_freq_range *freq_range_tmp;
+	const struct ieee80211_reg_rule *tmp;
+	u32 start_freq, end_freq, idx, no;
+
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
+		if (freq_range_tmp->max_bandwidth_khz)
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
+		if (freq_range_tmp->max_bandwidth_khz)
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
 static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 {
@@ -646,7 +701,9 @@ reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
  * Helper for regdom_intersect(), this does the real
  * mathematical intersection fun
  */
-static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
+static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
+			       const struct ieee80211_regdomain *rd2,
+			       const struct ieee80211_reg_rule *rule1,
 			       const struct ieee80211_reg_rule *rule2,
 			       struct ieee80211_reg_rule *intersected_rule)
 {
@@ -654,7 +711,7 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 	struct ieee80211_freq_range *freq_range;
 	const struct ieee80211_power_rule *power_rule1, *power_rule2;
 	struct ieee80211_power_rule *power_rule;
-	u32 freq_diff;
+	u32 freq_diff, max_bandwidth1, max_bandwidth2;
 
 	freq_range1 = &rule1->freq_range;
 	freq_range2 = &rule2->freq_range;
@@ -668,8 +725,24 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 					 freq_range2->start_freq_khz);
 	freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
 				       freq_range2->end_freq_khz);
-	freq_range->max_bandwidth_khz = min(freq_range1->max_bandwidth_khz,
-					    freq_range2->max_bandwidth_khz);
+
+	max_bandwidth1 = freq_range1->max_bandwidth_khz;
+	max_bandwidth2 = freq_range2->max_bandwidth_khz;
+
+	/*
+	 * In case max_bandwidth1 == 0 and max_bandwith2 == 0 set
+	 * output bandwidth as 0 (auto caclutation). Next we will
+	 * calculate this correctly in handle_channel function.
+	 * In other case calculate output bandwidth here.
+	 */
+	if (max_bandwidth1 || max_bandwidth2) {
+		if (!max_bandwidth1)
+			max_bandwidth1 = reg_get_max_bandwidth(rd1, rule1);
+		if (!max_bandwidth2)
+			max_bandwidth2 = reg_get_max_bandwidth(rd2, rule2);
+	}
+
+	freq_range->max_bandwidth_khz = min(max_bandwidth1, max_bandwidth2);
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 	if (freq_range->max_bandwidth_khz > freq_diff)
@@ -729,7 +802,8 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 		rule1 = &rd1->reg_rules[x];
 		for (y = 0; y < rd2->n_reg_rules; y++) {
 			rule2 = &rd2->reg_rules[y];
-			if (!reg_rules_intersect(rule1, rule2, &dummy_rule))
+			if (!reg_rules_intersect(rd1, rd2, rule1, rule2,
+						 &dummy_rule))
 				num_rules++;
 		}
 	}
@@ -754,7 +828,8 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 			 * a memcpy()
 			 */
 			intersected_rule = &rd->reg_rules[rule_idx];
-			r = reg_rules_intersect(rule1, rule2, intersected_rule);
+			r = reg_rules_intersect(rd1, rd2, rule1, rule2,
+						intersected_rule);
 			/*
 			 * No need to memset here the intersected rule here as
 			 * we're not using the stack anymore
@@ -909,6 +984,8 @@ static void handle_channel(struct wiphy *wiphy,
 	const struct ieee80211_freq_range *freq_range = NULL;
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr = get_last_request();
+	const struct ieee80211_regdomain *regd;
+	u32 max_bandwidth_khz;
 
 	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
@@ -950,11 +1027,18 @@ static void handle_channel(struct wiphy *wiphy,
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
+	max_bandwidth_khz = freq_range->max_bandwidth_khz;
+	/* Check if auto calculation requested */
+	if (!max_bandwidth_khz) {
+		regd = reg_get_regdomain(wiphy);
+		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
+	}
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
@@ -1340,6 +1424,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
+	u32 max_bandwidth_khz;
 
 	reg_rule = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
 				      regd);
@@ -1357,11 +1442,16 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
+	max_bandwidth_khz = freq_range->max_bandwidth_khz;
+	/* Check if auto calculation requested */
+	if (!max_bandwidth_khz)
+		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
+
+	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
+	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
+	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
 		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
 	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
@@ -2152,6 +2242,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
+	char bw[32];
 
 	pr_info("  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)\n");
 
@@ -2160,22 +2251,29 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		freq_range = &reg_rule->freq_range;
 		power_rule = &reg_rule->power_rule;
 
+		if (!freq_range->max_bandwidth_khz)
+			snprintf(bw, 32, "%d KHz, AUTO",
+				 reg_get_max_bandwidth(rd, reg_rule));
+		else
+			snprintf(bw, 32, "%d KHz",
+				 freq_range->max_bandwidth_khz);
+
 		/*
 		 * There may not be documentation for max antenna gain
 		 * in certain regions
 		 */
 		if (power_rule->max_antenna_gain)
-			pr_info("  (%d KHz - %d KHz @ %d KHz), (%d mBi, %d mBm)\n",
+			pr_info("  (%d KHz - %d KHz @ %s), (%d mBi, %d mBm)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
-				freq_range->max_bandwidth_khz,
+				bw,
 				power_rule->max_antenna_gain,
 				power_rule->max_eirp);
 		else
-			pr_info("  (%d KHz - %d KHz @ %d KHz), (N/A, %d mBm)\n",
+			pr_info("  (%d KHz - %d KHz @ %s), (N/A, %d mBm)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
-				freq_range->max_bandwidth_khz,
+				bw,
 				power_rule->max_eirp);
 	}
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 02bd8f4..1852461 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -34,6 +34,8 @@ int __init regulatory_init(void);
 void regulatory_exit(void);
 
 int set_regdom(const struct ieee80211_regdomain *rd);
+unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
+				   const struct ieee80211_reg_rule *rule);
 
 bool reg_last_request_cell_base(void);
 
-- 
1.7.9.5

