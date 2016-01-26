Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39810 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964992AbcAZN4h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 08:56:37 -0500
Message-ID: <1453816594.2759.70.camel@sipsolutions.net> (sfid-20160126_145640_826432_E07278C9)
Subject: Re: [RFC V4 1/2] nl80211: add feature for BSS selection support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jan 2016 14:56:34 +0100
In-Reply-To: <1453813592-5266-2-git-send-email-arend@broadcom.com>
References: <1453813592-5266-1-git-send-email-arend@broadcom.com>
	 <1453813592-5266-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-26 at 14:06 +0100, Arend van Spriel wrote:
> 
> + * @behaviour: requested BSS selection behaviour.
> + * @param: parameters for requestion behaviour.
> + * @band_pref: preferred band for
> %NL80211_BSS_SELECT_ATTR_BAND_PREF.
> + * @adjust: parameters for %NL80211_BSS_SELECT_ATTR_RSSI_ADJUST.

Sadly, I don't think this works with kernel-doc. You'd have to split it
out into a named union to get this working properly.

> +/**
> + * enum nl80211_bss_select_attr - attributes for bss selection.
> + *
> + * @__NL80211_BSS_SELECT_ATTR_INVALID: reserved.
> + * @NL80211_BSS_SELECT_ATTR_RSSI: Flag indicating only RSSI-based BSS selection
> + * is requested.
> + * @NL80211_BSS_SELECT_ATTR_BAND_PREF: attribute indicating BSS
> + *> 	> selection should be done such that the specified band is preferred.
> + *> 	> When there are multiple BSS-es in the preferred band, the driver
> + *> 	> shall use RSSI-based BSS selection as a second step. The value of
> + *> 	> this attribute is according to &enum nl80211_band (u32).
> + * @NL80211_BSS_SELECT_ATTR_RSSI_ADJUST: When present the RSSI level for
> + *> 	> BSS-es in the specified band is to be adjusted before doing
> + *> 	> RSSI-based BSS selection. The attribute value is a packed two-byte
> + *> 	> value. The lower byte contains the adjustment value (s8) and the
> + *	high byte contains the band according &enum nl80211_band.

I think it might be nicer to define an explicit struct for this, then
you don't have to use u8 for the band in one attribute and u32 for the
band in the other attribute either.

As long as there's no u64 in the struct that's pretty much safe - if
u64 is needed use compat_u64 :)

> + * @NL80211_BSS_SELECT_ATTR_MAX: highest bss select attribute number.
> + *@__NL80211_BSS_SELECT_ATTR_AFTER_LAST: internal use.
> + *
> + * These attributes are found within %NL80211_ATTR_BSS_SELECT and
> + * indicate the required BSS selection behaviour which the driver
> + * should use.

You should probably indicate that only a single one can ever be
specified?

> +static const struct nla_policy
> +nl80211_bss_select_policy[NL80211_BSS_SELECT_ATTR_MAX + 1] = {
> +	[NL80211_BSS_SELECT_ATTR_RSSI] = { .type = NLA_FLAG },
> +	[NL80211_BSS_SELECT_ATTR_BAND_PREF] = { .type = NLA_U32 },
> +	[NL80211_BSS_SELECT_ATTR_RSSI_ADJUST] = { .type = NLA_U8 },

The RSSI_ADJUST here seems wrong in any case? Should've been NLA_U16
now?

> @@ -5753,6 +5778,42 @@ static int validate_scan_freqs(struct nlattr
> *freqs)
>  	return n_channels;
>  }
>  
> +static int parse_bss_select(struct nlattr *nla,
> +			    struct cfg80211_bss_selection
> *bss_select)
> +{
> +	struct nlattr *attr[NL80211_BSS_SELECT_ATTR_MAX + 1];
> +	u16 band_delta;
> +	int err;

This should perhaps reject specification of multiple attributes, since
otherwise the order of the code here dictates which one "wins".


But these are small things - looks good!

johannes
