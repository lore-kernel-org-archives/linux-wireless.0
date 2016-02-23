Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33076 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbcBWOUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 09:20:47 -0500
Message-ID: <1456237245.9910.16.camel@sipsolutions.net> (sfid-20160223_152101_207715_D1223397)
Subject: Re: [PATCH V7 1/2] nl80211: add feature for BSS selection support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 23 Feb 2016 15:20:45 +0100
In-Reply-To: <1455706070-11915-1-git-send-email-arend@broadcom.com>
References: <1455706070-11915-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-17 at 11:47 +0100, Arend van Spriel wrote:
> 
> + * @NL80211_ATTR_BSS_SELECT: nested attribute for driver supporting the
> + *	BSS selection feature. When used with %NL80211_CMD_GET_WIPHY it contains
> + *	NLA_FLAG type according &enum nl80211_bss_select_attr to indicate what
> + *	BSS selection behaviours are supported. When used with %NL80211_CMD_CONNECT
> + *	it contains the behaviour and parameters for BSS selection to be done by
> + *	driver and/or firmware.

Maybe we should be less specific here regarding the NLA_FLAG and say
that it will contain attributes for each, indicating which behaviours
are supported, and say there's behaviour-dependent data inside each of
those attributes?

It seems entirely plausible that future behaviours would require their
own sub-capabilities; perhaps that's even the case today for having an
adjustment range for example, not that I think it's really necessary
now.

> @@ -3617,6 +3624,7 @@ enum nl80211_band {
>  	NL80211_BAND_2GHZ,
>  	NL80211_BAND_5GHZ,
>  	NL80211_BAND_60GHZ,
> +	NUM_NL80211_BAND,

You should use IEEE80211_NUM_BANDS and remove this.

> +static bool is_band_valid(struct wiphy *wiphy, enum nl80211_band b)
> +{
> +	return b < NUM_NL80211_BAND && wiphy->bands[b];
> +}

Here.

> +static int parse_bss_select(struct nlattr *nla, struct wiphy *wiphy,
> +			    struct cfg80211_bss_selection
> *bss_select)
> +{
> +	struct nlattr *attr[NL80211_BSS_SELECT_ATTR_MAX + 1];
> +	struct nlattr *nest;
> +	int err;
> +	bool found = false;
> +	int i;
> +
> +	/* only process one nested attribute */
> +	nest = nla_data(nla);
> +	if (!nla_ok(nest, nla_len(nest)))
> +		return -EBADF;

This isn't quite clear to me. Shouldn't you do this by declaring it
NLA_TESTED in the nl80211_policy?

Actually, not really? you use nla_ok() on the inner (without having
checked at all that it's even long enough btw, since you didn't do the
policy change), but that would already be done by nla_parse() below?

What are you trying to do here?

Regardless of that, EBADF seems like a bad error number.

> +	err = nla_parse(attr, NL80211_BSS_SELECT_ATTR_MAX,
> nla_data(nest),
> +			nla_len(nest), nl80211_bss_select_policy);
> +	if (err)
> +		return err;
> +
> +	/* only one attribute may be given */
> +	for (i = 0; i <= NL80211_BSS_SELECT_ATTR_MAX; i++)
> +		if (attr[i]) {
> +			if (found)
> +				return -EINVAL;
> +			found = true;
> +		}

I'd kinda prefer braces, but maybe that's just me. Surely not a
blocking issue :)

johannes
