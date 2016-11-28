Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43524 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932283AbcK1OiJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 09:38:09 -0500
Message-ID: <1480343886.8107.55.camel@sipsolutions.net> (sfid-20161128_153812_802423_4ED38138)
Subject: Re: [RFC V2 4/5] nl80211: add support for gscan
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 28 Nov 2016 15:38:06 +0100
In-Reply-To: <1479388726-3288-5-git-send-email-arend.vanspriel@broadcom.com>
References: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
         <1479388726-3288-5-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>   *	the nl80211 feature flags for the device.
> + * @NL80211_SCAN_FLAGS_IE_DATA: request the device to supply IE data
> in the
> + *	request.

What does that mean?

> + * @NL80211_GSCAN_CHAN_ATTR_NO_IR: scanning should be done passive.

why not call that passive? No-IR is something we use in regulatory code
to be more generic than "passive" (since it's also about beaconing
etc.) but here?

> + * @NL80211_GSCAN_CHAN_ATTR_MAX: highest GScan channel attribute.

Generally, you should also document the attribute types here (and
everywhere else really)

> +	NL80211_BUCKET_BAND_2GHZ	= (1 << 0),

no need for parentheses with enums :)

> +	if (tb[NL80211_GSCAN_CHAN_ATTR_DWELL_TIME])
> +		chan->dwell_time =
> nla_get_u32(tb[NL80211_GSCAN_CHAN_ATTR_DWELL_TIME]);

Maybe that should have some kind of "reasonable range" limit?


So I mostly looked at this from a pure code POV - need to compare with
our implementation, but I guess the basis is the same ...

johannes
