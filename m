Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3EXUWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 16:22:42 -0400
Message-ID: <1369426955.8290.34.camel@jlt4.sipsolutions.net> (sfid-20130524_222256_101529_761A4E3F)
Subject: Re: [PATCH v2 2/2] cfg80211/nl80211: Add packet coalesce support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 24 May 2013 22:22:35 +0200
In-Reply-To: <1369344908-11184-2-git-send-email-bzhao@marvell.com>
References: <1369344908-11184-1-git-send-email-bzhao@marvell.com>
	 <1369344908-11184-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some smallish things.

> In most cases, host that receives IPv4 and IPv6 multicast/broadcast
> packets does not do anything with these packets. Therefore the
> reception of these unwanted packets causes unnecessary processing
> and power consumption.

This is curious, you already discard those that you don't care about by
way of multicast filtering, no? What's the added advantage here? Would
you coalesce interrupts for those packets that pass the filter(s)? But
those packets are packets that the host cares about, no?

>  /**
> + * struct cfg80211_coalesce_rules - Coalesce rule parameters
> + *
> + * This structure defines coalesce rule for the device.
> + * @delay: maximum coalescing delay in msecs.
> + * @condition: condition for packet coalescence.
> + *	i.e. pattern 'match' or 'no match'
> + * @patterns: array of packet patterns
> + * @n_patterns: number of patterns
> + */
> +struct cfg80211_coalesce_rules {
> +	int delay;
> +	u8 condition;

seems like "condition" should be of some enum type? presumably an
nl80211 enum type that userspace can use?

> +	struct cfg80211_pkt_pattern *patterns;

const?

> +struct cfg80211_coalesce {
> +	struct cfg80211_coalesce_rules **rules;
> +	int n_rules;
> +};

I think you can pass these as two function arguments rather than a
separate struct.

> @@ -3027,7 +3063,6 @@ enum nl80211_cqm_rssi_threshold_event {
>  	NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
>  };
>  
> -
>  /**
>   * enum nl80211_tx_power_setting - TX power adjustment
>   * @NL80211_TX_POWER_AUTOMATIC: automatically determine transmit power

seems spurious :)

>   * This struct is carried in %NL80211_WOWLAN_TRIG_PKT_PATTERN when
> - * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
> - * capability information given by the kernel to userspace.
> + * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED or in
> + * %NL80211_ATTR_COALESCE_RULE_PKT_PATTERN when that is part of
> + * %NL80211_ATTR_COALESCE_RULE in the capability information given
> + * by the kernel to userspace.

Ah, I think here you're updating what I asked about before.

> + * @NL80211_ATTR_COALESCE_RULE_CONDITION: condition for packet coalescence.
> + *	i.e. pattern 'match' or 'no match'

I'm sure the condition attribute isn't a string, so this should say
which enum to take the value from?

> + * @NL80211_FEATURE_PACKET_COALESCE: This driver support packet coalescing
> + *	feature. Packets are buffered in firmware based on configured rules
> + *	to reduce unwanted packet or interrupt to host.

I don't think you need this, since you have this:

> +       struct wiphy_coalesce_support coalesce;

Actually, you should probably make that a pointer, then it can be NULL
for drivers not supporting it, and static const for those that do. Means
you should make it a const pointer, of course.

Userspace can tell by checking if the support is advertised.


> +static inline void
> +cfg80211_rdev_free_coalesce(struct cfg80211_registered_device *rdev)

That's fairly big, would prefer not to inline it.

> +static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct nlattr *tb[NUM_NL80211_ATTR_COALESCE_RULE];
> +	struct wiphy_coalesce_support *coalesce = &rdev->wiphy.coalesce;
> +	struct cfg80211_coalesce_rules new_rule = {};
> +	struct cfg80211_coalesce_rules *nrule;
> +	int err, i;
> +
> +	if (!(rdev->wiphy.features & NL80211_FEATURE_PACKET_COALESCE))
> +		return -EOPNOTSUPP;

Then this should check the coalesce pointer of course, which can then be
NULL.

> +	if (!rdev->coalesce) {
> +		rdev->coalesce = kzalloc(sizeof(*rdev->coalesce), GFP_KERNEL);
> +		rdev->coalesce->rules = kcalloc(coalesce->n_rules,
> +						sizeof(void *), GFP_KERNEL);
> +	}
> +
> +	if (rdev->coalesce->n_rules >= coalesce->n_rules)
> +		return -EOPNOTSUPP;

This is bad. You leave rdev->coalesce assigned, but it's completely
invalid data. IMHO you should use a temporary variable and only assign
it when it's fully parsed, freeing it if not. That way, you also don't
kill old values when new invalid values are parsed.

> +	new_rule.delay = nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_DELAY]);
> +	new_rule.condition =
> +		nla_get_u8(tb[NL80211_ATTR_COALESCE_RULE_CONDITION]);

Needs sanity checking, what if userspace passes the value 17? Does that
mean anything? :)

> +		nla_for_each_nested(pat,
> +				    tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN],
> +				    rem) {
> +			nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
> +				  nla_len(pat), NULL);
> +			err = -EINVAL;
> +			if (!pat_tb[NL80211_PKTPAT_MASK] ||
> +			    !pat_tb[NL80211_PKTPAT_PATTERN])
> +				goto error;
> +			pat_len = nla_len(pat_tb[NL80211_PKTPAT_PATTERN]);
> +			mask_len = DIV_ROUND_UP(pat_len, 8);
> +			if (nla_len(pat_tb[NL80211_PKTPAT_MASK]) !=
> +			    mask_len)
> +				goto error;
> +			if (pat_len > coalesce->pattern_max_len ||
> +			    pat_len < coalesce->pattern_min_len)
> +				goto error;

I wonder if any of this could be refactored with WoWLAN? Not really sure
though, maybe not.

> +	err = rdev->ops->set_coalesce(&rdev->wiphy, nrule);
> +	if (err)
> +		goto error;
> +
> +	rdev->coalesce->rules[rdev->coalesce->n_rules++] = nrule;

Wait ... you can't delete old rules, only add new ones? I think I'm
confused, I thought the SET command was going to overwrite all old
rules?

johannes

