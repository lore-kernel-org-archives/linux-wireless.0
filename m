Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49682 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaAYKYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jan 2014 05:24:25 -0500
Received: by mail-ee0-f51.google.com with SMTP id b57so1383403eek.38
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jan 2014 02:24:23 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3 2/2] cfg80211: regulatory introduce maximum bandwidth calculation
Date: Sat, 25 Jan 2014 11:24:12 +0100
Message-Id: <1390645452-2495-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140125_112446_144901_88A9A54C)
In-Reply-To: <1390645452-2495-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1390645452-2495-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case we will get regulatory request with rule
where max_bandwidth_khz is set to 0, handle this case
as a special one.
Generally
max_bandwidth_khz == 0 mean we should calculate maximum
available bandwidth base on all frequency contiguous rules.
We don't need any chanes in CRDA or internal regulatory.
In case we need auto calculation we just have to set:

country PL: DFS-ETSI
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ AUTO), (N/A, 20)
        (5250 - 5330 @ AUTO), (N/A, 20), DFS
        (5490 - 5710 @ 80), (N/A, 27), DFS

This mean we will calculate maximum bw for rules where
AUTO (N/A) was set, 160MHz in example above. So we will
get:

        (5170 - 5250 @ 160), (N/A, 20)
        (5250 - 5330 @ 160), (N/A, 20), DFS

In other case:
country FR: DFS-ETSI
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ AUTO), (N/A, 20)
        (5250 - 5330 @ 80), (N/A, 20), DFS
        (5490 - 5710 @ 80), (N/A, 27), DFS

We will get:
        (5170 - 5250 @ 80), (N/A, 20)
        (5250 - 5330 @ 80), (N/A, 20), DFS

Base on this calculations we will set correct channel
bandwidth flags.
I decided to don't change freq_range->max_bandwidth_khz
because they are const.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
*V3 - don't introduce any new flag, base only on freq_range->max_bandwidth_khz
      if == 0 handle as a AUTO calculation request.

 net/wireless/reg.c |  120 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 104 insertions(+), 16 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d58a09c..7fbaade 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -541,6 +541,61 @@ static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
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
@@ -649,7 +704,9 @@ reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
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
@@ -657,7 +714,7 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 	struct ieee80211_freq_range *freq_range;
 	const struct ieee80211_power_rule *power_rule1, *power_rule2;
 	struct ieee80211_power_rule *power_rule;
-	u32 freq_diff;
+	u32 freq_diff, max_bandwidth1, max_bandwidth2;
 
 	freq_range1 = &rule1->freq_range;
 	freq_range2 = &rule2->freq_range;
@@ -671,8 +728,16 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 					 freq_range2->start_freq_khz);
 	freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
 				       freq_range2->end_freq_khz);
-	freq_range->max_bandwidth_khz = min(freq_range1->max_bandwidth_khz,
-					    freq_range2->max_bandwidth_khz);
+
+	max_bandwidth1 = freq_range1->max_bandwidth_khz;
+	if (!max_bandwidth1)
+		max_bandwidth1 = reg_get_max_bandwidth(rd1, rule1);
+
+	max_bandwidth2 = freq_range1->max_bandwidth_khz;
+	if (!max_bandwidth1)
+		max_bandwidth2 = reg_get_max_bandwidth(rd2, rule2);
+
+	freq_range->max_bandwidth_khz = min(max_bandwidth1, max_bandwidth2);
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 	if (freq_range->max_bandwidth_khz > freq_diff)
@@ -732,7 +797,8 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 		rule1 = &rd1->reg_rules[x];
 		for (y = 0; y < rd2->n_reg_rules; y++) {
 			rule2 = &rd2->reg_rules[y];
-			if (!reg_rules_intersect(rule1, rule2, &dummy_rule))
+			if (!reg_rules_intersect(rd1, rd2, rule1, rule2,
+						 &dummy_rule))
 				num_rules++;
 		}
 	}
@@ -757,7 +823,8 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 			 * a memcpy()
 			 */
 			intersected_rule = &rd->reg_rules[rule_idx];
-			r = reg_rules_intersect(rule1, rule2, intersected_rule);
+			r = reg_rules_intersect(rd1, rd2, rule1, rule2,
+						intersected_rule);
 			/*
 			 * No need to memset here the intersected rule here as
 			 * we're not using the stack anymore
@@ -912,6 +979,8 @@ static void handle_channel(struct wiphy *wiphy,
 	const struct ieee80211_freq_range *freq_range = NULL;
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr = get_last_request();
+	const struct ieee80211_regdomain *regd;
+	u32 max_bandwidth_khz;
 
 	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
@@ -953,11 +1022,18 @@ static void handle_channel(struct wiphy *wiphy,
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
@@ -1343,6 +1419,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
+	u32 max_bandwidth_khz;
 
 	reg_rule = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
 				      regd);
@@ -1360,11 +1437,16 @@ static void handle_channel_custom(struct wiphy *wiphy,
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
@@ -2156,6 +2238,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
+	char bw[32];
 
 	pr_info("  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)\n");
 
@@ -2164,22 +2247,27 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		freq_range = &reg_rule->freq_range;
 		power_rule = &reg_rule->power_rule;
 
+		if (!freq_range->max_bandwidth_khz)
+			snprintf(bw, 32, "%d KHz, AUTO", reg_get_max_bandwidth(rd, reg_rule));
+		else
+			snprintf(bw, 32, "%d KHz", freq_range->max_bandwidth_khz);
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
-- 
1.7.9.5

