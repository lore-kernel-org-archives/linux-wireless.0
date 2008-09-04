Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39659 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYIDBtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 21:49:46 -0400
Date: Wed, 3 Sep 2008 18:49:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC] 802.11d Country IE parsing/support
Message-ID: <20080904014939.GG5967@tesla> (sfid-20080904_034949_463238_32A97808)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the new regulatory infrastructure is merged here is how I had
in mind to add support for parsing of Country IEs.

We parse the Country IE, and build a generous regulatory domain
structure out of it. By generous I mean we give it less restrictions,
the reason being the Country IE is not designed in mind with a lot of
regulatory data. It only has power, channels, and inside/outside flag.
That's it.

So what I recommend we do is after we have the regulatory domain built
intersect that with one provided by CRDA. CRDA will always have more up
to date information. That way we can assume 40 MHz badwidth on Country
IE channels but CRDA's bandwidth capabilities will supercede what the
core picked out from the Country IE.

Another very important piece to this is your driver will only roam if
your struct wiphy has dot11MultiDomainCapabilityEnabled set. Otherwise
we cannot expect the driver to be able to roam. The IEEE 802.11 specs
actually indicate we should assume this is disabled unless specified
so it seems reasonable to follow that in cfg80211.

If you decide you are capable of roaming it should mean you have taken
care to review your driver's regulatory data and have a way to let the
driver work in regions outside of the one it is built for.

Below is an initial implementation of intersection for review. I'm sure
I made some mistakes, let me know if you catch them. I haven't tested any
of this.

static bool reg_is_valid_rule(struct ieee80211_reg_rule *rule)
{
	struct ieee80211_freq_range *freq_range = &rule->freq_range;
	u32 freq_diff;

	if (freq_range->start_freq > freq_range->end_freq)
		return false;

	freq_diff = freq_range->end_freq - freq_range->start_freq;

	if (freq_range->max_bandwidth > freq_diff)
		return false;

	return true;
}

static int reg_rules_intersect(
	struct ieee80211_reg_rule *rule1,
	struct ieee80211_reg_rule *rule2,
	struct ieee80211_reg_rule **intersected_rule)
{
	struct ieee80211_freq_range *freq_range1, *freq_range2, *freq_range;
	struct ieee80211_power_rule *power_rule1, *power_rule2, *power_rule;
	u32 freq_diff;

	freq_range1 = &rule1->freq_range;
	freq_range2 = &rule2->freq_range;
	freq_range = &(*intersected_rule)->freq_range;

	power_rule1 = &rule1->power_rule;
	power_rule2 = &rule2->power_rule;
	power_rule = &(*intersected_rule)->power_rule;

	freq_range->start_freq = max(freq_range1->start_freq,
		freq_range2->start_freq);
	freq_range->end_freq = min(freq_range1->end_freq,
		freq_range2->end_freq);
	freq_range->max_bandwidth = min(freq_range1->max_bandwidth,
		freq_range2->max_bandwidth);

	freq_diff = freq_range->end_freq - freq_range->start_freq;
	if (freq_range->max_bandwidth > freq_diff)
		freq_range->max_bandwidth = freq_diff;

	power_rule->max_eirp = min(power_rule1->max_eirp,
		power_rule2->max_eirp);
	power_rule->max_eirp = min(power_rule1->max_eirp,
		power_rule2->max_eirp);

	(*intersected_rule)->flags = (rule1->flags | rule2->flags);

	if (!reg_is_valid_rule(*intersected_rule))
		return -EINVAL;

	return 0;
}

static int regdom_intersect(
	struct ieee80211_regdomain *rd1,
	struct ieee80211_regdomain *rd2,
	struct ieee80211_regdomain **rd)
{
	int r, size_of_regd;
	unsigned int x, y;
	unsigned int num_rules = 0, rule_idx = 0;
	struct ieee80211_reg_rule *rule1, *rule2, *intersected_rule;

	*rd = NULL;

	if (!rd1 || !rd2)
		return -EINVAL;

	/* First we get a count of the rules we'll need, then we actually
	 * build them. This is to so we can kzalloc() and kfree() a
	 * regdomain once */

	for (x = 0; x < rd1->n_reg_rules; x++) {
		rule1 = &rd1->reg_rules[x];
		for (y = 0; y < rd2->n_reg_rules; y++) {
			rule2 = &rd2->reg_rules[y];
			if (!reg_rules_intersect(rule1, rule2,
					&intersected_rule))
				num_rules++;
		}
	}

	if (!num_rules)
		return -ENODATA;

	size_of_regd = sizeof(struct ieee80211_regdomain) +
		(num_rules * sizeof(struct ieee80211_reg_rule));

	*rd = kzalloc(size_of_regd, GFP_KERNEL);
	if (!*rd)
		return -ENOMEM;

	for (x = 0; x < rd1->n_reg_rules; x++) {
		rule1 = &rd1->reg_rules[x];
		for (y = 0; y < rd2->n_reg_rules; y++) {
			rule2 = &rd2->reg_rules[y];
			r = reg_rules_intersect(rule1, rule2,
				&intersected_rule);
			if (r)
				continue;
			memcpy(&(*rd)->reg_rules[rule_idx],
				intersected_rule,
				sizeof(intersected_rule));
			rule_idx++;
		}
	}

	BUG_ON(rule_idx != num_rules);

	/* Indicates this regdomain is the product of an intersection */
	(*rd)->alpha2[0] = '9';
	(*rd)->alpha2[1] = '9';
}

