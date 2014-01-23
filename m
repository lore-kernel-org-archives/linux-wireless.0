Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaAWP5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 10:57:05 -0500
Message-ID: <1390492620.4142.33.camel@jlt4.sipsolutions.net> (sfid-20140123_165709_157828_3D5146D8)
Subject: Re: [PATCH v2 2/3] cfg80211: introduce regulatory wide bandwidth
 flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Thu, 23 Jan 2014 16:57:00 +0100
In-Reply-To: <1390394624-3927-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140122_134414_084742_E65606B6)
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1390394624-3927-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140122_134414_084742_E65606B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 13:43 +0100, Janusz Dziedzic wrote:
> Introduce regulatory flags field, NL80211_REG_WIDE_BW
> country flag and new attribute NL80211_ATTR_REG_FLAGS.
> If NL80211_REG_WIDE_BW is set, check rules and calculate
> maximum bandwidth base on all contiguous regulatory rules.
> If unset get maximum badwitdh from regulatory rule.
> This patch is backward compatible with current CRDA/db.txt
> implementation.

This seems reasonable, thanks. Maybe we should require the bandwidth to
not be set at all or something? At least maybe in the regdb parser - it
makes very little sense to have @20 and then ignore it completely?

Or maybe the userspace code could just not expose the flag, but rather
set the new "wide_bw" flag when all the rules are marked as @N/A (and
treat a combination of @number and @N/A as a bug)?

> + * @NL80211_ATTR_REG_FLAGS: Regulatory flags, see &enum nl80211_reg_flags

should probably say it's a u32 attribute

>  /**
> + * enum nl80211_reg_flags - regulatory flags
> + * @NL80211_REG_FLAG_WIDE_BW: Calculate maximum available bandwidth
> + *	base on contiguous regulatory rules instead of using
> + *	maximum bandwidth from regulatory database.

And that should probably not refer to the database but rather the
nl80211 attribute that contains the number.

> @@ -5203,6 +5208,8 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
>  	if (reg_supported_dfs_region(dfs_region))
>  		rd->dfs_region = dfs_region;
>  
> +	rd->flags = flags;

Why bother with the temporary flags variable?

>  	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
>  			    rem_reg_rules) {
>  		nla_parse(tb, NL80211_REG_RULE_ATTR_MAX,

As per above, maybe check that no bandwidth is actually in the rules?

> +static unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
> +					  const struct ieee80211_reg_rule *rule)
> +{
> +	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
> +	const struct ieee80211_freq_range *freq_range_tmp;
> +	const struct ieee80211_reg_rule *tmp;
> +	u32 start_freq, end_freq, idx, no;
> +
> +	/* First check if strict regulatory database bandwidth calculation */
> +	if (!(rd->flags & NL80211_REG_FLAG_WIDE_BW))
> +		return freq_range->end_freq_khz - freq_range->start_freq_khz;

shouldn't that check the range's @bandwidth (as well)?

or this is for sanity check only I guess.

> +	freq_diff = reg_get_max_bandwidth(rd, rule);
>  
> -	if (freq_range->end_freq_khz <= freq_range->start_freq_khz ||
> -	    freq_range->max_bandwidth_khz > freq_diff)
> +	if (freq_range->max_bandwidth_khz > freq_diff)
>  		return false;

Err, wait, this won't work as advertised, would it?
 
> @@ -645,11 +702,17 @@ reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
>  	return dfs_region1;
>  }
>  
> +static u32 reg_intersect_flags(const u32 flags1, const u32 flags2)
> +{
> +	return flags1 | flags2;
> +}

Wow, ok, this is getting tricky. But I think it should be the other way
around? I mean, it seems WIDE_BW flag should be unset if it's unset in
either of them?

But we might also have to set max_bandwidth_khz to a proper calculated
wide_bw value before intersecting...

johannes

