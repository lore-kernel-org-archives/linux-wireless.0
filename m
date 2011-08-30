Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H3ORD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 10:17:03 -0400
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314707979-26484-1-git-send-email-coelho@ti.com>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 16:16:52 +0200
Message-ID: <1314713812.4011.33.camel@jlt3.sipsolutions.net> (sfid-20110830_161707_675949_24A611C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 15:39 +0300, Luciano Coelho wrote:

> + * @NL80211_ATTR_MAX_FILTER_SSIDS: number of SSIDs you can use as
> + *	filters in a scheduled scan request, a wiphy attribute.

When we add more filters, hopefully the number of filters will stay be
this? IOW, shouldn't this be "MAX_FILTERS"? Basically, each filter can
be thought of as a profile, and a profile can contain various attributes
that must match, I think?

> + * @NL80211_ATTR_SCHED_SCAN_FILTER: Nested attribute with various
> + *	types of filtering to be used with scheduled scans.
> + *	If @NL80211_ATTR_SCAN_SSIDS is passed with values that are not
> + *	included in the filter, the driver may return -EINVAL, since
> + *	it doesn't make sense to send probe requests with SSIDs that
> + *	will be filtered out.  This doesn't apply to the wildcard SSID.
> + *	If ommited, no filtering is done.

Maybe cfg80211 should just apply that rule anyway? But is that really
true anyway? Say "DIRECT-" as the P2P wildcard ...

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index a37f264..a3e58ff 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -882,6 +882,9 @@ struct cfg80211_scan_request {
>   * @interval: interval between each scheduled scan cycle
>   * @ie: optional information element(s) to add into Probe Request or %NULL
>   * @ie_len: length of ie in octets
> + * @filter_ssids: SSIDs to pass to the host (others are filtered out).
> + * 	If ommited, no filtering is done.
> + * @n_filter_ssids: number of filter SSIDs

Maybe we should create a filter struct right away and use that with
filters/n_filters?

> +++ b/net/wireless/nl80211.c
> @@ -189,6 +189,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
>  					 .len = IEEE80211_MAX_DATA_LEN },
>  	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
>  					 .len = IEEE80211_MAX_DATA_LEN },
> +	[NL80211_ATTR_SCHED_SCAN_FILTER] = { .type = NLA_NESTED },
>  };

Don't we need a policy for the filter attributes?

> +	if (info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER]) {
> +		attr = nla_find_nested(info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER],
> +				       NL80211_ATTR_SCHED_SCAN_FILTER_SSID);
> +		if (attr)
> +			nla_for_each_nested(attr2, attr, tmp)
> +				n_filter_ssids++;
> +	}
> +
> +	if (n_filter_ssids > wiphy->max_filter_ssids)
> +		return -EINVAL;

That looks a little odd. What does that even do? I don't understand the
find_nested at all.

johannes

