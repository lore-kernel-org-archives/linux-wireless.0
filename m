Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab1KDI02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 04:26:28 -0400
Subject: Re: [PATCH v2] cfg80211: merge in beacon ies of hidden bss.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYg__nsSLa93AmzcMgckg8HG3FjD3LxpyDfA77WTsVm0oA@mail.gmail.com> (sfid-20111103_225905_882457_AFB1D003)
References: <CAMG6FYg__nsSLa93AmzcMgckg8HG3FjD3LxpyDfA77WTsVm0oA@mail.gmail.com>
	 (sfid-20111103_225905_882457_AFB1D003)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 09:26:25 +0100
Message-ID: <1320395185.3969.4.camel@jlt3.sipsolutions.net> (sfid-20111104_092632_669187_56D98104)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 22:59 +0100, Dmitry Tarnyagin wrote:

> +	/* Absence of SSID or zero-sized SSID is used as
> +	 * an indication of the hidden bss. */
> +	if (!ie2 || !ie2[1])
> +		return 0;

I don't think that's right -- I never saw anything w/o an SSID IE except
for mesh networks I think. Also this has different semantics from the
regular rb-tree search which will return -1 if not present (which is
actually a bug).

> +	/* Key comparator must use same algorithm in any rb-tree
> +	 * search function (order is important), otherwise ordering
> +	 * of items in the tree is broken and search gives incorrect
> +	 * results. This code uses same order as cmp_ies() does.
> +	 *
> +	 * The only difference is that this code searchs for zeroed
> +	 * SSID ie (another indication of the hidden bss). */
> +	ielen = min(ie1[1], ie2[1]);
> +	for (i = 0; i < ielen; i++)
> +		if (ie2[i + 2])
> +			return -1;
> +	return ie2[1] - ie1[1];

Since we need to fix cmp_ie() anyway, how about we change it there as
well. I'm going to post a patch.

> @@ -587,6 +681,21 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
> 
>  		kref_put(&res->ref, bss_release);
>  	} else {
> +		struct cfg80211_internal_bss *hidden;
> +
> +		/* First check if the beacon is a probe response from
> +		 * a hidden bss. If so, copy beacon ies (with nullified
> +		 * ssid) into the probe response bss entry (with real ssid).
> +		 * It is required basically for PSM implementation
> +		 * (probe responses do not contain tim ie) */
> +
> +		/* TODO: The code is not trying to update existing probe
> +		 * response bss entries when beacon ies are
> +		 * getting changed. */
> +		hidden = rb_find_hidden_bss(dev, res);
> +		if (hidden)
> +			copy_hidden_ies(res, hidden);
> +

This is nicer, though I'd prefer the TODO was addressed as well since
now we'll forever show stale data, this seems a bit bad.

johannes

