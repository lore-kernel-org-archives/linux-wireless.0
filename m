Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40974 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab2LCRmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 12:42:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/8] regulatory: code cleanup
Date: Mon,  3 Dec 2012 18:43:09 +0100
Message-Id: <1354556593-2363-5-git-send-email-johannes@sipsolutions.net> (sfid-20121203_184304_230260_0047063D)
In-Reply-To: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
References: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clean up various things like indentation, extra
parentheses, too many/few line breaks, etc.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |  15 ++-
 net/wireless/reg.c     | 268 ++++++++++++++++++-------------------------------
 net/wireless/sme.c     |   6 +-
 3 files changed, 106 insertions(+), 183 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0a8f2c6..e5c2988 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4283,7 +4283,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 		dfs_region = nla_get_u8(info->attrs[NL80211_ATTR_DFS_REGION]);
 
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
-			rem_reg_rules) {
+			    rem_reg_rules) {
 		num_rules++;
 		if (num_rules > NL80211_MAX_SUPP_REG_RULES)
 			return -EINVAL;
@@ -4297,7 +4297,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	size_of_regd = sizeof(struct ieee80211_regdomain) +
-		(num_rules * sizeof(struct ieee80211_reg_rule));
+		       num_rules * sizeof(struct ieee80211_reg_rule);
 
 	rd = kzalloc(size_of_regd, GFP_KERNEL);
 	if (!rd) {
@@ -4317,10 +4317,10 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 		rd->dfs_region = dfs_region;
 
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
-			rem_reg_rules) {
+			    rem_reg_rules) {
 		nla_parse(tb, NL80211_REG_RULE_ATTR_MAX,
-			nla_data(nl_reg_rule), nla_len(nl_reg_rule),
-			reg_rule_policy);
+			  nla_data(nl_reg_rule), nla_len(nl_reg_rule),
+			  reg_rule_policy);
 		r = parse_reg_rule(tb, &rd->reg_rules[rule_idx]);
 		if (r)
 			goto bad_reg;
@@ -4336,10 +4336,7 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	BUG_ON(rule_idx != num_rules);
 
 	r = set_regdom(rd);
-
-	mutex_unlock(&cfg80211_mutex);
-
-	return r;
+	rd = NULL;
 
  bad_reg:
 	mutex_unlock(&cfg80211_mutex);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 877ff5d..6cece2d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -48,7 +48,6 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/list.h>
-#include <linux/random.h>
 #include <linux/ctype.h>
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
@@ -220,18 +219,14 @@ bool is_world_regdom(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
-	if (alpha2[0] == '0' && alpha2[1] == '0')
-		return true;
-	return false;
+	return alpha2[0] == '0' && alpha2[1] == '0';
 }
 
 static bool is_alpha2_set(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
-	if (alpha2[0] != 0 && alpha2[1] != 0)
-		return true;
-	return false;
+	return alpha2[0] && alpha2[1];
 }
 
 static bool is_unknown_alpha2(const char *alpha2)
@@ -242,9 +237,7 @@ static bool is_unknown_alpha2(const char *alpha2)
 	 * Special case where regulatory domain was built by driver
 	 * but a specific alpha2 cannot be determined
 	 */
-	if (alpha2[0] == '9' && alpha2[1] == '9')
-		return true;
-	return false;
+	return alpha2[0] == '9' && alpha2[1] == '9';
 }
 
 static bool is_intersected_alpha2(const char *alpha2)
@@ -256,28 +249,21 @@ static bool is_intersected_alpha2(const char *alpha2)
 	 * result of an intersection between two regulatory domain
 	 * structures
 	 */
-	if (alpha2[0] == '9' && alpha2[1] == '8')
-		return true;
-	return false;
+	return alpha2[0] == '9' && alpha2[1] == '8';
 }
 
 static bool is_an_alpha2(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
-	if (isalpha(alpha2[0]) && isalpha(alpha2[1]))
-		return true;
-	return false;
+	return isalpha(alpha2[0]) && isalpha(alpha2[1]);
 }
 
 static bool alpha2_equal(const char *alpha2_x, const char *alpha2_y)
 {
 	if (!alpha2_x || !alpha2_y)
 		return false;
-	if (alpha2_x[0] == alpha2_y[0] &&
-		alpha2_x[1] == alpha2_y[1])
-		return true;
-	return false;
+	return alpha2_x[0] == alpha2_y[0] && alpha2_x[1] == alpha2_y[1];
 }
 
 static bool regdom_changes(const char *alpha2)
@@ -286,9 +272,7 @@ static bool regdom_changes(const char *alpha2)
 
 	if (!cfg80211_regdomain)
 		return true;
-	if (alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
-		return false;
-	return true;
+	return alpha2_equal(cfg80211_regdomain->alpha2, alpha2);
 }
 
 /*
@@ -302,11 +286,9 @@ static bool is_user_regdom_saved(void)
 		return false;
 
 	/* This would indicate a mistake on the design */
-	if (WARN((!is_world_regdom(user_alpha2) &&
-		  !is_an_alpha2(user_alpha2)),
+	if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2),
 		 "Unexpected user alpha2: %c%c\n",
-		 user_alpha2[0],
-	         user_alpha2[1]))
+		 user_alpha2[0], user_alpha2[1]))
 		return false;
 
 	return true;
@@ -360,10 +342,10 @@ static void reg_regdb_search(struct work_struct *work)
 					   list);
 		list_del(&request->list);
 
-		for (i=0; i<reg_regdb_size; i++) {
+		for (i = 0; i < reg_regdb_size; i++) {
 			curdom = reg_regdb[i];
 
-			if (!memcmp(request->alpha2, curdom->alpha2, 2)) {
+			if (!alpha2_equal(request->alpha2, curdom->alpha2)) {
 				regdom = reg_copy_regd(curdom);
 				break;
 			}
@@ -457,7 +439,7 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 
 	if (freq_range->end_freq_khz <= freq_range->start_freq_khz ||
-			freq_range->max_bandwidth_khz > freq_diff)
+	    freq_range->max_bandwidth_khz > freq_diff)
 		return false;
 
 	return true;
@@ -515,7 +497,7 @@ static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
  * regulatory rule support for other "bands".
  **/
 static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
-	u32 freq_khz)
+			      u32 freq_khz)
 {
 #define ONE_GHZ_IN_KHZ	1000000
 	/*
@@ -537,10 +519,9 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
  * Helper for regdom_intersect(), this does the real
  * mathematical intersection fun
  */
-static int reg_rules_intersect(
-	const struct ieee80211_reg_rule *rule1,
-	const struct ieee80211_reg_rule *rule2,
-	struct ieee80211_reg_rule *intersected_rule)
+static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
+			       const struct ieee80211_reg_rule *rule2,
+			       struct ieee80211_reg_rule *intersected_rule)
 {
 	const struct ieee80211_freq_range *freq_range1, *freq_range2;
 	struct ieee80211_freq_range *freq_range;
@@ -572,7 +553,7 @@ static int reg_rules_intersect(
 	power_rule->max_antenna_gain = min(power_rule1->max_antenna_gain,
 		power_rule2->max_antenna_gain);
 
-	intersected_rule->flags = (rule1->flags | rule2->flags);
+	intersected_rule->flags = rule1->flags | rule2->flags;
 
 	if (!is_valid_reg_rule(intersected_rule))
 		return -EINVAL;
@@ -593,9 +574,9 @@ static int reg_rules_intersect(
  * resulting intersection of rules between rd1 and rd2. We will
  * kzalloc() this structure for you.
  */
-static struct ieee80211_regdomain *regdom_intersect(
-	const struct ieee80211_regdomain *rd1,
-	const struct ieee80211_regdomain *rd2)
+static struct ieee80211_regdomain *
+regdom_intersect(const struct ieee80211_regdomain *rd1,
+		 const struct ieee80211_regdomain *rd2)
 {
 	int r, size_of_regd;
 	unsigned int x, y;
@@ -627,10 +608,10 @@ static struct ieee80211_regdomain *regdom_intersect(
 		for (y = 0; y < rd2->n_reg_rules; y++) {
 			rule2 = &rd2->reg_rules[y];
 			if (!reg_rules_intersect(rule1, rule2,
-					intersected_rule))
+						 intersected_rule))
 				num_rules++;
 			memset(intersected_rule, 0,
-					sizeof(struct ieee80211_reg_rule));
+			       sizeof(struct ieee80211_reg_rule));
 		}
 	}
 
@@ -654,8 +635,7 @@ static struct ieee80211_regdomain *regdom_intersect(
 			 * a memcpy()
 			 */
 			intersected_rule = &rd->reg_rules[rule_idx];
-			r = reg_rules_intersect(rule1, rule2,
-				intersected_rule);
+			r = reg_rules_intersect(rule1, rule2, intersected_rule);
 			/*
 			 * No need to memset here the intersected rule here as
 			 * we're not using the stack anymore
@@ -740,9 +720,7 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		bw_fits = reg_does_bw_fit(fr,
-					  center_freq,
-					  desired_bw_khz);
+		bw_fits = reg_does_bw_fit(fr, center_freq, desired_bw_khz);
 
 		if (band_rule_found && bw_fits) {
 			*reg_rule = rr;
@@ -756,17 +734,13 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 	return -EINVAL;
 }
 
-int freq_reg_info(struct wiphy *wiphy,
-		  u32 center_freq,
-		  u32 desired_bw_khz,
+int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 desired_bw_khz,
 		  const struct ieee80211_reg_rule **reg_rule)
 {
 	assert_cfg80211_lock();
-	return freq_reg_info_regd(wiphy,
-				  center_freq,
-				  desired_bw_khz,
-				  reg_rule,
-				  NULL);
+
+	return freq_reg_info_regd(wiphy, center_freq, desired_bw_khz,
+				  reg_rule, NULL);
 }
 EXPORT_SYMBOL(freq_reg_info);
 
@@ -804,16 +778,12 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 	else
 		snprintf(max_antenna_gain, 32, "%d", power_rule->max_antenna_gain);
 
-	REG_DBG_PRINT("Updating information on frequency %d MHz "
-		      "for a %d MHz width channel with regulatory rule:\n",
-		      chan->center_freq,
-		      KHZ_TO_MHZ(desired_bw_khz));
+	REG_DBG_PRINT("Updating information on frequency %d MHz for a %d MHz width channel with regulatory rule:\n",
+		      chan->center_freq, KHZ_TO_MHZ(desired_bw_khz));
 
 	REG_DBG_PRINT("%d KHz - %d KHz @ %d KHz), (%s mBi, %d mBm)\n",
-		      freq_range->start_freq_khz,
-		      freq_range->end_freq_khz,
-		      freq_range->max_bandwidth_khz,
-		      max_antenna_gain,
+		      freq_range->start_freq_khz, freq_range->end_freq_khz,
+		      freq_range->max_bandwidth_khz, max_antenna_gain,
 		      power_rule->max_eirp);
 }
 #else
@@ -859,11 +829,8 @@ static void handle_channel(struct wiphy *wiphy,
 
 	flags = chan->orig_flags;
 
-	r = freq_reg_info(wiphy,
-			  MHZ_TO_KHZ(chan->center_freq),
-			  desired_bw_khz,
-			  &reg_rule);
-
+	r = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq),
+			  desired_bw_khz, &reg_rule);
 	if (r) {
 		/*
 		 * We will disable all channels that do not match our
@@ -911,8 +878,9 @@ static void handle_channel(struct wiphy *wiphy,
 
 	chan->beacon_found = false;
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
-	chan->max_antenna_gain = min(chan->orig_mag,
-		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
+	chan->max_antenna_gain =
+		min_t(int, chan->orig_mag,
+		      MBI_TO_DBI(power_rule->max_antenna_gain));
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 	if (chan->orig_mpwr) {
 		/*
@@ -931,8 +899,7 @@ static void handle_channel(struct wiphy *wiphy,
 		chan->max_power = chan->max_reg_power;
 }
 
-static void handle_band(struct wiphy *wiphy,
-			enum ieee80211_band band,
+static void handle_band(struct wiphy *wiphy, enum ieee80211_band band,
 			enum nl80211_reg_initiator initiator)
 {
 	unsigned int i;
@@ -949,51 +916,48 @@ static bool reg_request_cell_base(struct regulatory_request *request)
 {
 	if (request->initiator != NL80211_REGDOM_SET_BY_USER)
 		return false;
-	if (request->user_reg_hint_type != NL80211_USER_REG_HINT_CELL_BASE)
-		return false;
-	return true;
+	return request->user_reg_hint_type == NL80211_USER_REG_HINT_CELL_BASE;
 }
 
 bool reg_last_request_cell_base(void)
 {
 	bool val;
+
 	assert_cfg80211_lock();
 
 	mutex_lock(&reg_mutex);
 	val = reg_request_cell_base(last_request);
 	mutex_unlock(&reg_mutex);
+
 	return val;
 }
 
 #ifdef CONFIG_CFG80211_CERTIFICATION_ONUS
-
 /* Core specific check */
 static int reg_ignore_cell_hint(struct regulatory_request *pending_request)
 {
 	if (!reg_num_devs_support_basehint)
 		return -EOPNOTSUPP;
 
-	if (reg_request_cell_base(last_request)) {
-		if (!regdom_changes(pending_request->alpha2))
-			return -EALREADY;
-		return 0;
-	}
+	if (reg_request_cell_base(last_request) &&
+	    !regdom_changes(pending_request->alpha2))
+		return -EALREADY;
+
 	return 0;
 }
 
 /* Device specific check */
 static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 {
-	if (!(wiphy->features & NL80211_FEATURE_CELL_BASE_REG_HINTS))
-		return true;
-	return false;
+	return !(wiphy->features & NL80211_FEATURE_CELL_BASE_REG_HINTS);
 }
 #else
 static int reg_ignore_cell_hint(struct regulatory_request *pending_request)
 {
 	return -EOPNOTSUPP;
 }
-static int reg_dev_ignore_cell_hint(struct wiphy *wiphy)
+
+static bool reg_dev_ignore_cell_hint(struct wiphy *wiphy)
 {
 	return true;
 }
@@ -1004,17 +968,14 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 			      enum nl80211_reg_initiator initiator)
 {
 	if (!last_request) {
-		REG_DBG_PRINT("Ignoring regulatory request %s since "
-			      "last_request is not set\n",
+		REG_DBG_PRINT("Ignoring regulatory request %s since last_request is not set\n",
 			      reg_initiator_name(initiator));
 		return true;
 	}
 
 	if (initiator == NL80211_REGDOM_SET_BY_CORE &&
 	    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY) {
-		REG_DBG_PRINT("Ignoring regulatory request %s "
-			      "since the driver uses its own custom "
-			      "regulatory domain\n",
+		REG_DBG_PRINT("Ignoring regulatory request %s since the driver uses its own custom regulatory domain\n",
 			      reg_initiator_name(initiator));
 		return true;
 	}
@@ -1026,9 +987,7 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
 	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    !is_world_regdom(last_request->alpha2)) {
-		REG_DBG_PRINT("Ignoring regulatory request %s "
-			      "since the driver requires its own regulatory "
-			      "domain to be set first\n",
+		REG_DBG_PRINT("Ignoring regulatory request %s since the driver requires its own regulatory domain to be set first\n",
 			      reg_initiator_name(initiator));
 		return true;
 	}
@@ -1039,8 +998,7 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	return false;
 }
 
-static void handle_reg_beacon(struct wiphy *wiphy,
-			      unsigned int chan_idx,
+static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 			      struct reg_beacon *reg_beacon)
 {
 	struct ieee80211_supported_band *sband;
@@ -1151,16 +1109,14 @@ static void reg_process_beacons(struct wiphy *wiphy)
 	wiphy_update_beacon_reg(wiphy);
 }
 
-static bool is_ht40_not_allowed(struct ieee80211_channel *chan)
+static bool is_ht40_allowed(struct ieee80211_channel *chan)
 {
 	if (!chan)
-		return true;
+		return false;
 	if (chan->flags & IEEE80211_CHAN_DISABLED)
-		return true;
+		return false;
 	/* This would happen when regulatory rules disallow HT40 completely */
-	if (IEEE80211_CHAN_NO_HT40 == (chan->flags & (IEEE80211_CHAN_NO_HT40)))
-		return true;
-	return false;
+	return !(chan->flags & IEEE80211_CHAN_NO_HT40);
 }
 
 static void reg_process_ht_flags_channel(struct wiphy *wiphy,
@@ -1178,7 +1134,7 @@ static void reg_process_ht_flags_channel(struct wiphy *wiphy,
 	BUG_ON(chan_idx >= sband->n_channels);
 	channel = &sband->channels[chan_idx];
 
-	if (is_ht40_not_allowed(channel)) {
+	if (!is_ht40_allowed(channel)) {
 		channel->flags |= IEEE80211_CHAN_NO_HT40;
 		return;
 	}
@@ -1189,6 +1145,7 @@ static void reg_process_ht_flags_channel(struct wiphy *wiphy,
 	 */
 	for (i = 0; i < sband->n_channels; i++) {
 		struct ieee80211_channel *c = &sband->channels[i];
+
 		if (c->center_freq == (channel->center_freq - 20))
 			channel_before = c;
 		if (c->center_freq == (channel->center_freq + 20))
@@ -1200,12 +1157,12 @@ static void reg_process_ht_flags_channel(struct wiphy *wiphy,
 	 * if that ever changes we also need to change the below logic
 	 * to include that as well.
 	 */
-	if (is_ht40_not_allowed(channel_before))
+	if (!is_ht40_allowed(channel_before))
 		channel->flags |= IEEE80211_CHAN_NO_HT40MINUS;
 	else
 		channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
 
-	if (is_ht40_not_allowed(channel_after))
+	if (!is_ht40_allowed(channel_after))
 		channel->flags |= IEEE80211_CHAN_NO_HT40PLUS;
 	else
 		channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
@@ -1257,6 +1214,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
+
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, last_request);
 }
@@ -1301,18 +1259,12 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	BUG_ON(chan_idx >= sband->n_channels);
 	chan = &sband->channels[chan_idx];
 
-	r = freq_reg_info_regd(wiphy,
-			       MHZ_TO_KHZ(chan->center_freq),
-			       desired_bw_khz,
-			       &reg_rule,
-			       regd);
+	r = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
+			       desired_bw_khz, &reg_rule, regd);
 
 	if (r) {
-		REG_DBG_PRINT("Disabling freq %d MHz as custom "
-			      "regd has no rule that fits a %d MHz "
-			      "wide channel\n",
-			      chan->center_freq,
-			      KHZ_TO_MHZ(desired_bw_khz));
+		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits a %d MHz wide channel\n",
+			      chan->center_freq, KHZ_TO_MHZ(desired_bw_khz));
 		chan->flags = IEEE80211_CHAN_DISABLED;
 		return;
 	}
@@ -1362,7 +1314,7 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 
 	/*
 	 * no point in calling this if it won't have any effect
-	 * on your device's supportd bands.
+	 * on your device's supported bands.
 	 */
 	WARN_ON(!bands_set);
 }
@@ -1391,7 +1343,6 @@ static int ignore_request(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_CORE:
 		return 0;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-
 		if (reg_request_cell_base(last_request)) {
 			/* Trust a Cell base station over the AP's country IE */
 			if (regdom_changes(pending_request->alpha2))
@@ -1456,18 +1407,17 @@ static int ignore_request(struct wiphy *wiphy,
 		 * to their country before the IE is picked up
 		 */
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_USER &&
-			  last_request->intersect)
+		    last_request->intersect)
 			return -EOPNOTSUPP;
 		/*
 		 * Process user requests only after previous user/driver/core
 		 * requests have been processed
 		 */
-		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE ||
-		    last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
-		    last_request->initiator == NL80211_REGDOM_SET_BY_USER) {
-			if (regdom_changes(last_request->alpha2))
-				return -EAGAIN;
-		}
+		if ((last_request->initiator == NL80211_REGDOM_SET_BY_CORE ||
+		     last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
+		     last_request->initiator == NL80211_REGDOM_SET_BY_USER) &&
+		    regdom_changes(last_request->alpha2))
+			return -EAGAIN;
 
 		if (!regdom_changes(pending_request->alpha2))
 			return -EALREADY;
@@ -1597,8 +1547,7 @@ static void reg_process_hint(struct regulatory_request *reg_request,
 	if (wiphy_idx_valid(reg_request->wiphy_idx))
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
-	if (reg_initiator == NL80211_REGDOM_SET_BY_DRIVER &&
-	    !wiphy) {
+	if (reg_initiator == NL80211_REGDOM_SET_BY_DRIVER && !wiphy) {
 		kfree(reg_request);
 		return;
 	}
@@ -1615,8 +1564,7 @@ static void reg_process_hint(struct regulatory_request *reg_request,
 	 * We only time out user hints, given that they should be the only
 	 * source of bogus requests.
 	 */
-	if (r != -EALREADY &&
-	    reg_initiator == NL80211_REGDOM_SET_BY_USER)
+	if (r != -EALREADY && reg_initiator == NL80211_REGDOM_SET_BY_USER)
 		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 }
 
@@ -1634,8 +1582,7 @@ static void reg_process_pending_hints(void)
 
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (last_request && !last_request->processed) {
-		REG_DBG_PRINT("Pending regulatory request, waiting "
-			      "for it to be processed...\n");
+		REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
 		goto out;
 	}
 
@@ -1726,8 +1673,7 @@ static int regulatory_hint_core(const char *alpha2)
 {
 	struct regulatory_request *request;
 
-	request = kzalloc(sizeof(struct regulatory_request),
-			  GFP_KERNEL);
+	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
 	if (!request)
 		return -ENOMEM;
 
@@ -1794,10 +1740,8 @@ EXPORT_SYMBOL(regulatory_hint);
  * We hold wdev_lock() here so we cannot hold cfg80211_mutex() and
  * therefore cannot iterate over the rdev list here.
  */
-void regulatory_hint_11d(struct wiphy *wiphy,
-			 enum ieee80211_band band,
-			 const u8 *country_ie,
-			 u8 country_ie_len)
+void regulatory_hint_11d(struct wiphy *wiphy, enum ieee80211_band band,
+			 const u8 *country_ie, u8 country_ie_len)
 {
 	char alpha2[2];
 	enum environment_cap env = ENVIRON_ANY;
@@ -1829,8 +1773,8 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	 * cfg80211_mutex.
 	 */
 	if (likely(last_request->initiator ==
-	    NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    wiphy_idx_valid(last_request->wiphy_idx)))
+		   NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+		   wiphy_idx_valid(last_request->wiphy_idx)))
 		goto out;
 
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
@@ -1858,8 +1802,7 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 	if (is_user_regdom_saved()) {
 		/* Unless we're asked to ignore it and reset it */
 		if (reset_user) {
-			REG_DBG_PRINT("Restoring regulatory settings "
-			       "including user preference\n");
+			REG_DBG_PRINT("Restoring regulatory settings including user preference\n");
 			user_alpha2[0] = '9';
 			user_alpha2[1] = '7';
 
@@ -1869,26 +1812,20 @@ static void restore_alpha2(char *alpha2, bool reset_user)
 			 * back as they were for a full restore.
 			 */
 			if (!is_world_regdom(ieee80211_regdom)) {
-				REG_DBG_PRINT("Keeping preference on "
-				       "module parameter ieee80211_regdom: %c%c\n",
-				       ieee80211_regdom[0],
-				       ieee80211_regdom[1]);
+				REG_DBG_PRINT("Keeping preference on module parameter ieee80211_regdom: %c%c\n",
+					      ieee80211_regdom[0], ieee80211_regdom[1]);
 				alpha2[0] = ieee80211_regdom[0];
 				alpha2[1] = ieee80211_regdom[1];
 			}
 		} else {
-			REG_DBG_PRINT("Restoring regulatory settings "
-			       "while preserving user preference for: %c%c\n",
-			       user_alpha2[0],
-			       user_alpha2[1]);
+			REG_DBG_PRINT("Restoring regulatory settings while preserving user preference for: %c%c\n",
+				      user_alpha2[0], user_alpha2[1]);
 			alpha2[0] = user_alpha2[0];
 			alpha2[1] = user_alpha2[1];
 		}
 	} else if (!is_world_regdom(ieee80211_regdom)) {
-		REG_DBG_PRINT("Keeping preference on "
-		       "module parameter ieee80211_regdom: %c%c\n",
-		       ieee80211_regdom[0],
-		       ieee80211_regdom[1]);
+		REG_DBG_PRINT("Keeping preference on module parameter ieee80211_regdom: %c%c\n",
+			      ieee80211_regdom[0], ieee80211_regdom[1]);
 		alpha2[0] = ieee80211_regdom[0];
 		alpha2[1] = ieee80211_regdom[1];
 	} else
@@ -2008,10 +1945,8 @@ static void restore_regulatory_settings(bool reset_user)
 
 	spin_lock(&reg_requests_lock);
 	list_for_each_entry_safe(reg_request, tmp, &tmp_reg_req_list, list) {
-		REG_DBG_PRINT("Adding request for country %c%c back "
-			      "into the queue\n",
-			      reg_request->alpha2[0],
-			      reg_request->alpha2[1]);
+		REG_DBG_PRINT("Adding request for country %c%c back into the queue\n",
+			      reg_request->alpha2[0], reg_request->alpha2[1]);
 		list_move_tail(&reg_request->list, &reg_requests_list);
 	}
 	spin_unlock(&reg_requests_lock);
@@ -2026,8 +1961,7 @@ static void restore_regulatory_settings(bool reset_user)
 
 void regulatory_hint_disconnect(void)
 {
-	REG_DBG_PRINT("All devices are disconnected, going to "
-		      "restore regulatory settings\n");
+	REG_DBG_PRINT("All devices are disconnected, going to restore regulatory settings\n");
 	restore_regulatory_settings(false);
 }
 
@@ -2056,8 +1990,7 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 	if (!reg_beacon)
 		return -ENOMEM;
 
-	REG_DBG_PRINT("Found new beacon on "
-		      "frequency: %d MHz (Ch %d) on %s\n",
+	REG_DBG_PRINT("Found new beacon on frequency: %d MHz (Ch %d) on %s\n",
 		      beacon_chan->center_freq,
 		      ieee80211_frequency_to_channel(beacon_chan->center_freq),
 		      wiphy_name(wiphy));
@@ -2144,7 +2077,7 @@ static void print_dfs_region(u8 dfs_region)
 		pr_info(" DFS Master region JP");
 		break;
 	default:
-		pr_info(" DFS Master region Uknown");
+		pr_info(" DFS Master region Unknown");
 		break;
 	}
 }
@@ -2174,12 +2107,10 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 			pr_info("Regulatory domain changed to driver built-in settings (unknown country)\n");
 		else {
 			if (reg_request_cell_base(last_request))
-				pr_info("Regulatory domain changed "
-					"to country: %c%c by Cell Station\n",
+				pr_info("Regulatory domain changed to country: %c%c by Cell Station\n",
 					rd->alpha2[0], rd->alpha2[1]);
 			else
-				pr_info("Regulatory domain changed "
-					"to country: %c%c\n",
+				pr_info("Regulatory domain changed to country: %c%c\n",
 					rd->alpha2[0], rd->alpha2[1]);
 		}
 	}
@@ -2209,7 +2140,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	if (!is_alpha2_set(rd->alpha2) && !is_an_alpha2(rd->alpha2) &&
-			!is_unknown_alpha2(rd->alpha2))
+	    !is_unknown_alpha2(rd->alpha2))
 		return -EINVAL;
 
 	if (!last_request)
@@ -2285,7 +2216,6 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	/* Intersection requires a bit more work */
 
 	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-
 		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
 		if (!intersected_rd)
 			return -EINVAL;
@@ -2337,8 +2267,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	/* This would make this whole thing pointless */
-	if (!last_request->intersect)
-		BUG_ON(rd != cfg80211_regdomain);
+	BUG_ON(!last_request->intersect && rd != cfg80211_regdomain);
 
 	/* update all wiphys now with the new established regulatory domain */
 	update_all_wiphy_regulatory(last_request->initiator);
@@ -2415,8 +2344,7 @@ out:
 
 static void reg_timeout_work(struct work_struct *work)
 {
-	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, "
-		      "restoring regulatory settings\n");
+	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
 	restore_regulatory_settings(true);
 }
 
@@ -2470,7 +2398,7 @@ int __init regulatory_init(void)
 	return 0;
 }
 
-void /* __init_or_exit */ regulatory_exit(void)
+void regulatory_exit(void)
 {
 	struct regulatory_request *reg_request, *tmp;
 	struct reg_beacon *reg_beacon, *btmp;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f2431e4..d2d2651 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -519,10 +519,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	 * - country_ie + 2, the start of the country ie data, and
 	 * - and country_ie[1] which is the IE length
 	 */
-	regulatory_hint_11d(wdev->wiphy,
-			    bss->channel->band,
-			    country_ie + 2,
-			    country_ie[1]);
+	regulatory_hint_11d(wdev->wiphy, bss->channel->band,
+			    country_ie + 2, country_ie[1]);
 	kfree(country_ie);
 }
 
-- 
1.8.0

