Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:57536 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbeHUMmb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 08:42:31 -0400
Message-ID: <1534843384.25523.7.camel@sipsolutions.net> (sfid-20180821_112311_376258_6C8FB855)
Subject: Re: [RFC] cfg80211: let's wmm_rule be part of reg_rule structure
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Grzegorz =?UTF-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>
Date: Tue, 21 Aug 2018 11:23:04 +0200
In-Reply-To: <20180821074020.GA28952@redhat.com>
References: <20180821074020.GA28952@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Given the code simplification, and that we even allocate n_channels *
WMM rule anyway in e.g. iwlwifi, this seems like a good idea. I think I
was initially against it because of the duplication, but for the most
part we have few rules, and if we have many like in iwlwifi we already
don't take advantage of it to save memory ...

I think, however, that we should get away without doing a userspace API
modification:

> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -3598,6 +3598,7 @@ enum nl80211_reg_rule_flags {
>  	NL80211_RRF_NO_HT40PLUS		= 1<<14,
>  	NL80211_RRF_NO_80MHZ		= 1<<15,
>  	NL80211_RRF_NO_160MHZ		= 1<<16,
> +	NL80211_RRF_HAS_WMM		= 1<<17,
>  };

We can store this flag in a kernel-only boolean instead?

> -	if (IS_ERR_OR_NULL(rrule) || !rrule->wmm_rule) {
> +	if (IS_ERR_OR_NULL(rrule) || !(rrule->flags & NL80211_RRF_HAS_WMM)) {

and then just use "rrule->has_wmm" or so here (and in other places that
check).

>  	for (i = 0; i < src_regd->n_reg_rules; i++) {
>  		memcpy(&regd->reg_rules[i], &src_regd->reg_rules[i],
>  		       sizeof(struct ieee80211_reg_rule));
> -		if (!src_regd->reg_rules[i].wmm_rule)
> -			continue;
> -
> -		regd->reg_rules[i].wmm_rule = d_wmm +
> -			(src_regd->reg_rules[i].wmm_rule - s_wmm) /
> -			sizeof(struct ieee80211_wmm_rule);
>  	}

could drop the braces now

johannes
