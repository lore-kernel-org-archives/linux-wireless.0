Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22489 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbYJ3UeA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:34:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 13:34:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/5] cfg80211: Add regulatory domain intersection capability
Date: Thu, 30 Oct 2008 13:33:53 -0700
Message-ID: <1225398836-28633-3-git-send-email-lrodriguez@atheros.com> (sfid-20081030_213408_064627_70E459A7)
In-Reply-To: <1225398836-28633-2-git-send-email-lrodriguez@atheros.com>
References: <1225398836-28633-1-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are certain scenerios where we require intersecting
two regulatory domains. This adds intersection support.
When we enable 802.11d support we will use this to intersect
the regulatory domain from the AP's country IE and what our
regulatory agent believes is correct for a country.

This patch enables intersection for now in the case where
the last regdomain was set by a country IE which was parsed
and the user then wants to set the regulatory domain. Since
we don't support country IE parsing yet this code path will not
be hit, however this allows us to pave the way for 11d support.

Intersection code has been tested in userspace with CRDA.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |  166 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 158 insertions(+), 8 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a23cc82..92af64c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -50,6 +50,7 @@ struct regulatory_request {
 	struct wiphy *wiphy;
 	enum reg_set_by initiator;
 	char alpha2[2];
+	bool intersect;
 };
 
 static struct regulatory_request *last_request;
@@ -359,6 +360,143 @@ static u32 freq_max_bandwidth(const struct ieee80211_freq_range *freq_range,
 	return 0;
 }
 
+/* Helper for regdom_intersect(), this does the real
+ * mathematical intersection fun */
+static int reg_rules_intersect(
+	const struct ieee80211_reg_rule *rule1,
+	const struct ieee80211_reg_rule *rule2,
+	struct ieee80211_reg_rule *intersected_rule)
+{
+	const struct ieee80211_freq_range *freq_range1, *freq_range2;
+	struct ieee80211_freq_range *freq_range;
+	const struct ieee80211_power_rule *power_rule1, *power_rule2;
+	struct ieee80211_power_rule *power_rule;
+	u32 freq_diff;
+
+	freq_range1 = &rule1->freq_range;
+	freq_range2 = &rule2->freq_range;
+	freq_range = &intersected_rule->freq_range;
+
+	power_rule1 = &rule1->power_rule;
+	power_rule2 = &rule2->power_rule;
+	power_rule = &intersected_rule->power_rule;
+
+	freq_range->start_freq_khz = max(freq_range1->start_freq_khz,
+		freq_range2->start_freq_khz);
+	freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
+		freq_range2->end_freq_khz);
+	freq_range->max_bandwidth_khz = min(freq_range1->max_bandwidth_khz,
+		freq_range2->max_bandwidth_khz);
+
+	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
+	if (freq_range->max_bandwidth_khz > freq_diff)
+		freq_range->max_bandwidth_khz = freq_diff;
+
+	power_rule->max_eirp = min(power_rule1->max_eirp,
+		power_rule2->max_eirp);
+	power_rule->max_antenna_gain = min(power_rule1->max_antenna_gain,
+		power_rule2->max_antenna_gain);
+
+	intersected_rule->flags = (rule1->flags | rule2->flags);
+
+	if (!is_valid_reg_rule(intersected_rule))
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * regdom_intersect - do the intersection between two regulatory domains
+ * @rd1: first regulatory domain
+ * @rd2: second regulatory domain
+ *
+ * Use this function to get the intersection between two regulatory domains.
+ * Once completed we will mark the alpha2 for the rd as intersected, "98",
+ * as no one single alpha2 can represent this regulatory domain.
+ *
+ * Returns a pointer to the regulatory domain structure which will hold the
+ * resulting intersection of rules between rd1 and rd2. We will
+ * kzalloc() this structure for you.
+ */
+static struct ieee80211_regdomain *regdom_intersect(
+	const struct ieee80211_regdomain *rd1,
+	const struct ieee80211_regdomain *rd2)
+{
+	int r, size_of_regd;
+	unsigned int x, y;
+	unsigned int num_rules = 0, rule_idx = 0;
+	const struct ieee80211_reg_rule *rule1, *rule2;
+	struct ieee80211_reg_rule *intersected_rule;
+	struct ieee80211_regdomain *rd;
+	/* This is just a dummy holder to help us count */
+	struct ieee80211_reg_rule irule;
+
+	/* Uses the stack temporarily for counter arithmetic */
+	intersected_rule = &irule;
+
+	memset(intersected_rule, 0, sizeof(struct ieee80211_reg_rule));
+
+	if (!rd1 || !rd2)
+		return NULL;
+
+	/* First we get a count of the rules we'll need, then we actually
+	 * build them. This is to so we can malloc() and free() a
+	 * regdomain once. The reason we use reg_rules_intersect() here
+	 * is it will return -EINVAL if the rule computed makes no sense.
+	 * All rules that do check out OK are valid. */
+
+	for (x = 0; x < rd1->n_reg_rules; x++) {
+		rule1 = &rd1->reg_rules[x];
+		for (y = 0; y < rd2->n_reg_rules; y++) {
+			rule2 = &rd2->reg_rules[y];
+			if (!reg_rules_intersect(rule1, rule2,
+					intersected_rule))
+				num_rules++;
+			memset(intersected_rule, 0,
+					sizeof(struct ieee80211_reg_rule));
+		}
+	}
+
+	if (!num_rules)
+		return NULL;
+
+	size_of_regd = sizeof(struct ieee80211_regdomain) +
+		((num_rules + 1) * sizeof(struct ieee80211_reg_rule));
+
+	rd = kzalloc(size_of_regd, GFP_KERNEL);
+	if (!rd)
+		return NULL;
+
+	for (x = 0; x < rd1->n_reg_rules; x++) {
+		rule1 = &rd1->reg_rules[x];
+		for (y = 0; y < rd2->n_reg_rules; y++) {
+			rule2 = &rd2->reg_rules[y];
+			/* This time around instead of using the stack lets
+			 * write to the target rule directly saving ourselves
+			 * a memcpy() */
+			intersected_rule = &rd->reg_rules[rule_idx];
+			r = reg_rules_intersect(rule1, rule2,
+				intersected_rule);
+			/* No need to memset here the intersected rule here as
+			 * we're not using the stack anymore */
+			if (r)
+				continue;
+			rule_idx++;
+		}
+	}
+
+	if (rule_idx != num_rules) {
+		kfree(rd);
+		return NULL;
+	}
+
+	rd->n_reg_rules = num_rules;
+	rd->alpha2[0] = '9';
+	rd->alpha2[1] = '8';
+
+	return rd;
+}
+
 /* XXX: add support for the rest of enum nl80211_reg_rule_flags, we may
  * want to just have the channel structure use these */
 static u32 map_regdom_flags(u32 rd_flags)
@@ -468,6 +606,10 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
 	}
 }
 
+/* Return value which can be used by ignore_request() to indicate
+ * it has been determined we should intersect two regulatory domains */
+#define REG_INTERSECT	1
+
 /* This has the logic which determines when a new request
  * should be ignored. */
 static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
@@ -517,14 +659,8 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 			return -EALREADY;
 		return 0;
 	case REGDOM_SET_BY_USER:
-		/*
-		 * If the user wants to override the AP's hint, we may
-		 * need to follow both and use the intersection. For now,
-		 * reject any such attempt (but we don't support country
-		 * IEs right now anyway.)
-		 */
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
-			return -EOPNOTSUPP;
+			return REG_INTERSECT;
 		return 0;
 	}
 
@@ -536,10 +672,14 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 		      const char *alpha2)
 {
 	struct regulatory_request *request;
+	bool intersect = false;
 	int r = 0;
 
 	r = ignore_request(wiphy, set_by, alpha2);
-	if (r)
+
+	if (r == REG_INTERSECT)
+		intersect = true;
+	else if (r)
 		return r;
 
 	switch (set_by) {
@@ -556,6 +696,7 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 		request->alpha2[1] = alpha2[1];
 		request->initiator = set_by;
 		request->wiphy = wiphy;
+		request->intersect = intersect;
 
 		kfree(last_request);
 		last_request = request;
@@ -648,6 +789,7 @@ void print_regdomain_info(const struct ieee80211_regdomain *rd)
 /* Takes ownership of rd only if it doesn't fail */
 static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
+	const struct ieee80211_regdomain *intersected_rd = NULL;
 	/* Some basic sanity checks first */
 
 	if (is_world_regdom(rd->alpha2)) {
@@ -697,6 +839,14 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return -EOPNOTSUPP;
 	}
 
+	if (unlikely(last_request->intersect)) {
+		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
+		if (!intersected_rd)
+			return -EINVAL;
+		kfree(rd);
+		rd = intersected_rd;
+	}
+
 	/* Tada! */
 	cfg80211_regdomain = rd;
 
-- 
1.5.6.3

