Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:36625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757087AbYIDIXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2008 04:23:30 -0400
From: Helmut Schaa <hschaa@suse.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC] 802.11d Country IE parsing/support
Date: Thu, 4 Sep 2008 10:23:10 +0200
Cc: linux-wireless@vger.kernel.org
References: <20080904014939.GG5967@tesla>
In-Reply-To: <20080904014939.GG5967@tesla>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809041023.11169.hschaa@suse.de> (sfid-20080904_102337_096772_5B170B5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 4. September 2008 schrieb Luis R. Rodriguez:
> static int reg_rules_intersect(
> 	struct ieee80211_reg_rule *rule1,
> 	struct ieee80211_reg_rule *rule2,
> 	struct ieee80211_reg_rule **intersected_rule)
> {
> 	struct ieee80211_freq_range *freq_range1, *freq_range2, *freq_range;
> 	struct ieee80211_power_rule *power_rule1, *power_rule2, *power_rule;
> 	u32 freq_diff;
> 
> 	freq_range1 = &rule1->freq_range;
> 	freq_range2 = &rule2->freq_range;
> 	freq_range = &(*intersected_rule)->freq_range;
> 
> 	power_rule1 = &rule1->power_rule;
> 	power_rule2 = &rule2->power_rule;
> 	power_rule = &(*intersected_rule)->power_rule;
> 
> 	freq_range->start_freq = max(freq_range1->start_freq,
> 		freq_range2->start_freq);
> 	freq_range->end_freq = min(freq_range1->end_freq,
> 		freq_range2->end_freq);
> 	freq_range->max_bandwidth = min(freq_range1->max_bandwidth,
> 		freq_range2->max_bandwidth);
> 
> 	freq_diff = freq_range->end_freq - freq_range->start_freq;
> 	if (freq_range->max_bandwidth > freq_diff)
> 		freq_range->max_bandwidth = freq_diff;
> 
> 	power_rule->max_eirp = min(power_rule1->max_eirp,
> 		power_rule2->max_eirp);
> 	power_rule->max_eirp = min(power_rule1->max_eirp,
> 		power_rule2->max_eirp);

max_eirp should be max_antenna_gain in the second block, right?

> 	(*intersected_rule)->flags = (rule1->flags | rule2->flags);

Wouldn't (rule1->flags & rule2->flags) be more feasible?

> 	if (!reg_is_valid_rule(*intersected_rule))
> 		return -EINVAL;
> 
> 	return 0;
> }
> 
> static int regdom_intersect(
> 	struct ieee80211_regdomain *rd1,
> 	struct ieee80211_regdomain *rd2,
> 	struct ieee80211_regdomain **rd)
> {
> 	int r, size_of_regd;
> 	unsigned int x, y;
> 	unsigned int num_rules = 0, rule_idx = 0;
> 	struct ieee80211_reg_rule *rule1, *rule2, *intersected_rule;
> 
> 	*rd = NULL;
> 
> 	if (!rd1 || !rd2)
> 		return -EINVAL;
> 
> 	/* First we get a count of the rules we'll need, then we actually
> 	 * build them. This is to so we can kzalloc() and kfree() a
> 	 * regdomain once */
> 
> 	for (x = 0; x < rd1->n_reg_rules; x++) {
> 		rule1 = &rd1->reg_rules[x];
> 		for (y = 0; y < rd2->n_reg_rules; y++) {
> 			rule2 = &rd2->reg_rules[y];
> 			if (!reg_rules_intersect(rule1, rule2,
> 					&intersected_rule))

Hmm, &intersected_rule is uninitialized here and reg_rules_intersect does not
allocate anything.

> 				num_rules++;
> 		}
> 	}
> 
> 	if (!num_rules)
> 		return -ENODATA;
> 
> 	size_of_regd = sizeof(struct ieee80211_regdomain) +
> 		(num_rules * sizeof(struct ieee80211_reg_rule));
> 
> 	*rd = kzalloc(size_of_regd, GFP_KERNEL);
> 	if (!*rd)
> 		return -ENOMEM;
> 
> 	for (x = 0; x < rd1->n_reg_rules; x++) {
> 		rule1 = &rd1->reg_rules[x];
> 		for (y = 0; y < rd2->n_reg_rules; y++) {
> 			rule2 = &rd2->reg_rules[y];
> 			r = reg_rules_intersect(rule1, rule2,
> 				&intersected_rule);

Same here.

> 			if (r)
> 				continue;
> 			memcpy(&(*rd)->reg_rules[rule_idx],
> 				intersected_rule,
> 				sizeof(intersected_rule));

sizeof(*intersected_rule)?

Helmut
