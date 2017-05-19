Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37902 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbdESLrj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 07:47:39 -0400
Message-ID: <1495194457.3274.10.camel@sipsolutions.net> (sfid-20170519_134742_408859_3D882175)
Subject: Re: [PATCHv4 1/2] cfg80211: Add support to enable or disable btcoex
 and set btcoex_priority
From: Johannes Berg <johannes@sipsolutions.net>
To: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, tamizhchelvam@codeaurora.org
Date: Fri, 19 May 2017 13:47:37 +0200
In-Reply-To: <1491905730-16392-2-git-send-email-c_traja@qti.qualcomm.com>
References: <1491905730-16392-1-git-send-email-c_traja@qti.qualcomm.com>
         <1491905730-16392-2-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for the long delay.

> +/**
> + * enum nl80211_btcoex_priority - btcoex priority supported frame
> types and
> + *	its bitmap values.
> + * @NL80211_BTCOEX_SUPPORTS_BE_PREF - wlan Best effort frame takes
> more

You should drop the _SUPPORTS part from these names, it's not just for
that now.

> + */
> +
> +enum nl80211_btcoex_priority {

There's an extra blank line here.

> +	NL80211_BTCOEX_SUPPORTS_BE_PREF		= 1 << 0,
> +	NL80211_BTCOEX_SUPPORTS_BK_PREF		= 1 << 1,
> +	NL80211_BTCOEX_SUPPORTS_VI_PREF		= 1 << 2,
> +	NL80211_BTCOEX_SUPPORTS_VO_PREF		= 1 << 3,
> +	NL80211_BTCOEX_SUPPORTS_BEACON_PREF	= 1 << 4,
> +	NL80211_BTCOEX_SUPPORTS_MGMT_PREF	= 1 << 5,
> +	NL80211_BTCOEX_SUPPORTS_MAX_PREF	= (1 << 6) - 1,

I'd prefer to formulate this as

 NL80211_BTCOEX_PREF_MASK = (NL80211_BTCOEX_SUPPORTS_BE_PREF |
			     ...)

and then later use

if (value & ~NL80211_BTCOEX_PREF_MASK)
	return -EINVAL;

The way it is now isn't really all that obvious IMHO.

> +	u8 val = 0;
> +	u32 btcoex_priority = 0;

No need to initialize those values.

+	if (!rdev->ops->set_btcoex)
> +		return -ENOTSUPP;
> +
> +	if (!(info->attrs[NL80211_ATTR_BTCOEX_OP]))
> +		goto set_btcoex;

Don't really need those extra parentheses.

> +	if (info->attrs[NL80211_ATTR_BTCOEX_OP])
> +		val = nla_get_u8(info-
> >attrs[NL80211_ATTR_BTCOEX_OP]);

Ok, actually, here you do need to initialize val but it makes no sense
- why is this even a U8 attribute rather than a FLAG?

So there are two ways you can play this:

1) either you make it a U8 attribute as you have, and allow *not
changing* it, by making val default to -1 and documenting in the
cfg80211 API that -1 means no changes. This would allow userspace to
set the BT coex priority parameters without changing whether or not BT
coex is turned on or off entirely, but the drivers would have to be
storing the priority values all the time etc. This seems somewhat error
prone.

- or -

2) You simply disallow changing the BT coex priority parameters by
themselves, i.e. allow only setting those if the FLAG attribute for
enabling BT coex is also present. IMHO this is less error prone.

The way it is now makes no sense - you could set the BT coex parameters
and leave out the BTCOEX_OP attribute entirely, but then if you leave
it out that would mean it actually gets disabled and the new priority
values don't take any effect.

I strongly suggest you go for option 2) unless you can provide a really
good reason for option 1). If you do go for 2) you should rename the
BTCOEX_OP to BTCOEX_ENABLE and make it a flag.

> +	if (val > 1)
> +		return -EINVAL;
> +
> +	if (info->attrs[NL80211_ATTR_BTCOEX_PRIORITY]) {
> +		if (!wiphy_ext_feature_isset(wiphy,
> +					NL80211_EXT_FEATURE_BTCOEX_P
> RIORITY))
> +			return -EOPNOTSUPP;
> +
> +		btcoex_priority =
> +		nla_get_u32(info-
> >attrs[NL80211_ATTR_BTCOEX_PRIORITY]);
> +
> +		if (btcoex_priority >
> NL80211_BTCOEX_SUPPORTS_MAX_PREF)
> +			return -E2BIG;
> +	}

-EINVAL, even if that's not nice, but E2BIG means "argument list too
long" which really isn't the right thing here.

johannes
