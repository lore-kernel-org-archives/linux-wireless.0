Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab1KCIz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:55:26 -0400
Subject: Re: [PATCH] cfg80211: merge in beacon ies of hidden bss.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYiV8F=MFBeUQCGSj__h=REVLMvTZCvLEvDPT7GP2KWsWw@mail.gmail.com> (sfid-20111102_191945_962100_47EF911D)
References: <CAMG6FYiV8F=MFBeUQCGSj__h=REVLMvTZCvLEvDPT7GP2KWsWw@mail.gmail.com>
	 (sfid-20111102_191945_962100_47EF911D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 09:55:24 +0100
Message-ID: <1320310524.3950.29.camel@jlt3.sipsolutions.net> (sfid-20111103_095533_987538_892243CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 19:19 +0100, Dmitry Tarnyagin wrote:

> +static int cmp_hidden_bss(struct cfg80211_bss *a,
> +		   struct cfg80211_bss *b)
> +{
> +	const u8 *ie1;
> +	const u8 *ie2;
> +	size_t ielen;
> +	int i;
> +	int r;
> +
> +	r = cmp_bss_core(a, b);
> +	if (r)
> +		return r;
> +
> +	ie1 = cfg80211_find_ie(WLAN_EID_SSID,
> +			a->information_elements,
> +			a->len_information_elements);
> +	ie2 = cfg80211_find_ie(WLAN_EID_SSID,
> +			b->information_elements,
> +			b->len_information_elements);
> +	if (!ie1 && !ie2)
> +		return 0;

I don't think it's valid to leave out the SSID IE, so I'd rather not
have that test here. It might interact badly with other uses (mesh?)

> +	if (!ie1 || !ie2)
> +		return -1;
> +
> +	ielen = min(ie1[1], ie2[1]);
> +	for (i = 0; i < ielen; ++i)

++i here is a bit atypical code style.

> +		if (ie2[i + 2])
> +			return -1;

I don't understand this loop. Why check that ie2 is zeroed, but check
only to the minlen of ie1, ie2?

> +	return ie2[1] - ie1[1];

I'd error out much earlier if the length is different instead of
comparing to the minlen first.

> +static int
> +merge_hidden_ies(struct cfg80211_internal_bss *res,
> +		 struct cfg80211_internal_bss *hidden)

There seems little use for the return value.

> +{
> +	if (unlikely(res->pub.beacon_ies))
> +		return -EALREADY;
> +	if (WARN_ON(!hidden->pub.beacon_ies))
> +		return -EINVAL;
> +
> +	res->pub.beacon_ies = kmalloc(hidden->pub.len_beacon_ies, GFP_ATOMIC);
> +	if (unlikely(!res->pub.beacon_ies))
> +		return -ENOMEM;
> +
> +	res->beacon_ies_allocated = true;
> +	res->pub.len_beacon_ies = hidden->pub.len_beacon_ies;
> +	memcpy(res->pub.beacon_ies, hidden->pub.beacon_ies,
> +			res->pub.len_beacon_ies);
> +
> +	return 0;
> +}
> +
> +static struct cfg80211_internal_bss *
>  cfg80211_bss_update(struct cfg80211_registered_device *dev,
>  		    struct cfg80211_internal_bss *res)
>  {
> @@ -494,6 +578,13 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
>  	spin_lock_bh(&dev->bss_lock);
> 
>  	found = rb_find_bss(dev, res);
> +	if (!found) {
> +		struct cfg80211_internal_bss *hidden;
> +
> +		hidden = rb_find_hidden_bss(dev, res);
> +		if (hidden)
> +			merge_hidden_ies(res, hidden);
> +	}

I was going to complain that I don't understand why this works -- but
then I think now I do. If you move the code down into the else branch
it'll be much easier to follow.

johannes

