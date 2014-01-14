Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33417 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaANR3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 12:29:46 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so371222eei.7
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 09:29:44 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 1/5] cfg80211: regulatory rules, fix bw checking
Date: Tue, 14 Jan 2014 18:29:26 +0100
Message-Id: <1389720570-2430-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182949_461484_79434DD2)
In-Reply-To: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow BW cross over REG_RULES if rules continous.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
I am not sure about rule_intersect() here ...

 net/wireless/reg.c |   68 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 59 insertions(+), 9 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7d20d84..4414fa5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -522,9 +522,55 @@ bool reg_is_valid_request(const char *alpha2)
 	return alpha2_equal(lr->alpha2, alpha2);
 }
 
+static u32 get_frequency_diff(const struct ieee80211_reg_rule *rules,
+			      unsigned int rule_no,
+			      unsigned int rule_max)
+{
+	u32 start_freq, end_freq;
+	u32 no = rule_no;
+	const struct ieee80211_reg_rule *rule = &rules[rule_no];
+	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
+	const struct ieee80211_freq_range *freq_range_tmp;
+
+	/* get start_freq */
+	while (no) {
+		rule = &rules[--no];
+		freq_range_tmp = &rule->freq_range;
+
+		if (freq_range_tmp->end_freq_khz != freq_range->start_freq_khz)
+			break;
+
+		freq_range = freq_range_tmp;
+	};
+
+	start_freq = freq_range->start_freq_khz;
+
+	/* get end_freq */
+	rule = &rules[rule_no];
+	freq_range = &rule->freq_range;
+	no = rule_no;
+
+	while (no < rule_max - 1) {
+		rule = &rules[++no];
+		freq_range_tmp = &rule->freq_range;
+
+		if (freq_range_tmp->start_freq_khz != freq_range->end_freq_khz)
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
+static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rules,
+			      unsigned int rule_no,
+			      unsigned int rule_max)
 {
+	const struct ieee80211_reg_rule *rule = &rules[rule_no];
 	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
 	u32 freq_diff;
 
@@ -534,10 +580,17 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 	if (freq_range->start_freq_khz > freq_range->end_freq_khz)
 		return false;
 
+	if (freq_range->end_freq_khz <= freq_range->start_freq_khz)
+		return false;
+
+	/* First do quick check */
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
+	if (freq_range->max_bandwidth_khz <= freq_diff)
+		return true;
 
-	if (freq_range->end_freq_khz <= freq_range->start_freq_khz ||
-	    freq_range->max_bandwidth_khz > freq_diff)
+	/* Next check adjacent rules (if continous) */
+	freq_diff = get_frequency_diff(rules, rule_no, rule_max);
+	if (freq_range->max_bandwidth_khz > freq_diff)
 		return false;
 
 	return true;
@@ -545,7 +598,6 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 
 static bool is_valid_rd(const struct ieee80211_regdomain *rd)
 {
-	const struct ieee80211_reg_rule *reg_rule = NULL;
 	unsigned int i;
 
 	if (!rd->n_reg_rules)
@@ -554,11 +606,9 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
 	if (WARN_ON(rd->n_reg_rules > NL80211_MAX_SUPP_REG_RULES))
 		return false;
 
-	for (i = 0; i < rd->n_reg_rules; i++) {
-		reg_rule = &rd->reg_rules[i];
-		if (!is_valid_reg_rule(reg_rule))
+	for (i = 0; i < rd->n_reg_rules; i++)
+		if (!is_valid_reg_rule(rd->reg_rules, i, rd->n_reg_rules))
 			return false;
-	}
 
 	return true;
 }
@@ -666,7 +716,7 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 
 	intersected_rule->flags = rule1->flags | rule2->flags;
 
-	if (!is_valid_reg_rule(intersected_rule))
+	if (!is_valid_reg_rule(intersected_rule, 0, 1))
 		return -EINVAL;
 
 	return 0;
-- 
1.7.9.5

