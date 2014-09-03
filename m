Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbaICMcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/10] cfg80211: avoid duplicate entries on regdomain intersection
Date: Wed,  3 Sep 2014 15:25:03 +0300
Message-Id: <1409747106-30717-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_150113_490400_A7AE05B1)
In-Reply-To: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The regdom intersection code simply tries intersecting
each rule of the source with each rule of the target.

Since the resulting intersections are not observed
as a whole, this can result in multiple overlapping/duplicate
entries.

Make the rule addition a bit more smarter, by looking
for rules that can be contained within other rules,
and adding only extended ones.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/reg.c | 81 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 60 insertions(+), 21 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8bfc9b1..b725a31 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -799,6 +799,57 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	return 0;
 }
 
+/* check whether old rule contains new rule */
+static bool rule_contains(struct ieee80211_reg_rule *r1,
+			  struct ieee80211_reg_rule *r2)
+{
+	/* for simplicity, currently consider only same flags */
+	if (r1->flags != r2->flags)
+		return false;
+
+	/* verify r1 is more restrictive */
+	if ((r1->power_rule.max_antenna_gain >
+	     r2->power_rule.max_antenna_gain) ||
+	    r1->power_rule.max_eirp > r2->power_rule.max_eirp)
+		return false;
+
+	/* make sure r2's range is contained within r1 */
+	if (r1->freq_range.start_freq_khz > r2->freq_range.start_freq_khz ||
+	    r1->freq_range.end_freq_khz < r2->freq_range.end_freq_khz)
+		return false;
+
+	/* and finally verify that r1.max_bw >= r2.max_bw */
+	if (r1->freq_range.max_bandwidth_khz <
+	    r2->freq_range.max_bandwidth_khz)
+		return false;
+
+	return true;
+}
+
+/* add or extend current rules. do nothing if rule is already contained */
+static void add_rule(struct ieee80211_reg_rule *rule,
+		     struct ieee80211_reg_rule *reg_rules, u32 *n_rules)
+{
+	struct ieee80211_reg_rule *tmp_rule;
+	int i;
+
+	for (i = 0; i < *n_rules; i++) {
+		tmp_rule = &reg_rules[i];
+		/* rule is already contained - do nothing */
+		if (rule_contains(tmp_rule, rule))
+			return;
+
+		/* extend rule if possible */
+		if (rule_contains(rule, tmp_rule)) {
+			memcpy(tmp_rule, rule, sizeof(*rule));
+			return;
+		}
+	}
+
+	memcpy(&reg_rules[*n_rules], rule, sizeof(*rule));
+	(*n_rules)++;
+}
+
 /**
  * regdom_intersect - do the intersection between two regulatory domains
  * @rd1: first regulatory domain
@@ -818,12 +869,10 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 {
 	int r, size_of_regd;
 	unsigned int x, y;
-	unsigned int num_rules = 0, rule_idx = 0;
+	unsigned int num_rules = 0;
 	const struct ieee80211_reg_rule *rule1, *rule2;
-	struct ieee80211_reg_rule *intersected_rule;
+	struct ieee80211_reg_rule intersected_rule;
 	struct ieee80211_regdomain *rd;
-	/* This is just a dummy holder to help us count */
-	struct ieee80211_reg_rule dummy_rule;
 
 	if (!rd1 || !rd2)
 		return NULL;
@@ -841,7 +890,7 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 		for (y = 0; y < rd2->n_reg_rules; y++) {
 			rule2 = &rd2->reg_rules[y];
 			if (!reg_rules_intersect(rd1, rd2, rule1, rule2,
-						 &dummy_rule))
+						 &intersected_rule))
 				num_rules++;
 		}
 	}
@@ -856,34 +905,24 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 	if (!rd)
 		return NULL;
 
-	for (x = 0; x < rd1->n_reg_rules && rule_idx < num_rules; x++) {
+	for (x = 0; x < rd1->n_reg_rules; x++) {
 		rule1 = &rd1->reg_rules[x];
-		for (y = 0; y < rd2->n_reg_rules && rule_idx < num_rules; y++) {
+		for (y = 0; y < rd2->n_reg_rules; y++) {
 			rule2 = &rd2->reg_rules[y];
-			/*
-			 * This time around instead of using the stack lets
-			 * write to the target rule directly saving ourselves
-			 * a memcpy()
-			 */
-			intersected_rule = &rd->reg_rules[rule_idx];
 			r = reg_rules_intersect(rd1, rd2, rule1, rule2,
-						intersected_rule);
+						&intersected_rule);
 			/*
 			 * No need to memset here the intersected rule here as
 			 * we're not using the stack anymore
 			 */
 			if (r)
 				continue;
-			rule_idx++;
-		}
-	}
 
-	if (rule_idx != num_rules) {
-		kfree(rd);
-		return NULL;
+			add_rule(&intersected_rule, rd->reg_rules,
+				 &rd->n_reg_rules);
+		}
 	}
 
-	rd->n_reg_rules = num_rules;
 	rd->alpha2[0] = '9';
 	rd->alpha2[1] = '8';
 	rd->dfs_region = reg_intersect_dfs_region(rd1->dfs_region,
-- 
1.9.1

