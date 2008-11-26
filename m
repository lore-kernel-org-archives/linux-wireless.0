Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:50950 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYKZNPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 08:15:08 -0500
Date: Wed, 26 Nov 2008 15:14:49 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <m.sujith@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] nl80211: Add frequency configuration (including HT40)
Message-ID: <20081126131449.GA7452@jm.kir.nu> (sfid-20081126_141514_456616_FF2E396A)
References: <20081125190533.GA27879@jm.kir.nu> <20081126083841.GC31499@jm.kir.nu> <1227697465.4613.95.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227697465.4613.95.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2008 at 12:04:24PM +0100, Johannes Berg wrote:
> On Wed, 2008-11-26 at 10:38 +0200, Jouni Malinen wrote:

> > + * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY_FREQ
> > + *	if HT20 or HT40 are allowed (i.e., 802.11n disabled if not included):
> 
> It's also possible to explicitly give the _NO_HT value too.
> 
> > + *	NL80211_SEC_CHAN_DISABLED = HT20 only

Yes, I did not include in documentation, but I can add it here as
another option for not including the attribute.

> > +
> > +	int	(*set_channel)(struct wiphy *wiphy, int freq, bool ht_enabled,
> > +			       int sec_chan_offset);
> 
> I wonder if we shouldn't simply pass in the enum nl80211_sec_chan_offset
> value here, that seems easier to understand when you're looking at the
> whole thing from userspace down to a possible non-mac80211 driver. Not
> that I think that'll ever happen, but still? It might even make sense to
> use that value within mac80211's driver API at some point, instead of
> the enabled / +/-1 thing.

I don't care much either way. nl80211.c uses the +/-1 to get the
secondary channel frequency and the driver API does not use it yet, so
conversion is needed somewhere at this point. I can move it somewhere
else if you want to; just point me to the place where you want it ;-).
cfg.c::ieee80211_set_channel()? main.c::ieee80211_hw_config()?


> > +	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
> > +	[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET] = { .type = NLA_U8 },
> 
> I think it's more "normal" to use a u32 for an enum although I don't
> think we'll ever add anything, so I guess it doesn't actually matter.

I'm quite sure we won't need more than eight bits to store the possible
options for this attribute, but I can change this to u32 to be
consistent with existing attributes if you prefer it.

> > +		freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
> > +		chan = ieee80211_get_channel(&rdev->wiphy, freq);

> > +		result = rdev->ops->set_channel(&rdev->wiphy, freq, ht_enabled,
> > +						sec_chan_offset);
> 
> would it make sense to pass in 'chan'? mac80211 will do the lookup
> again, and if a driver doesn't it can just use chan->center_freq.

Now that chan is here in nl80211.c (was added with regulatory
enforcement), sure, it could be passed to set_channel() to remove some
code.

-- 
Jouni Malinen                                            PGP id EFC895FA
