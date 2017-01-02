Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39902 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750815AbdABOEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 09:04:09 -0500
Message-ID: <1483365844.21014.6.camel@sipsolutions.net> (sfid-20170102_150412_692077_F40C1EA4)
Subject: Re: [PATCH V2 3/3] cfg80211: support ieee80211-freq-limit DT
 property
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Mon, 02 Jan 2017 15:04:04 +0100
In-Reply-To: <20170102132747.3491-3-zajec5@gmail.com> (sfid-20170102_142835_253965_3D582D2C)
References: <20170102132747.3491-1-zajec5@gmail.com>
         <20170102132747.3491-3-zajec5@gmail.com>
         (sfid-20170102_142835_253965_3D582D2C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	prop = of_find_property(np, "ieee80211-freq-limit", &i);
> +	if (!prop)
> +		return 0;
> +
> +	i = i / sizeof(u32);

What if it's not even a multiple of sizeof(u32)? Shouldn't you check
that, in case it's completely bogus?

> +	if (i % 2) {
> +		dev_err(dev, "ieee80211-freq-limit wrong value");

say "wrong format" perhaps? we don't care (much) above the values.

> +		return -EPROTO;
> +	}
> +	wiphy->n_freq_limits = i / 2;

I don't like this use of the 'i' variable - use something like
'len[gth]' instead?

> +	wiphy->freq_limits = kzalloc(wiphy->n_freq_limits *
> sizeof(*wiphy->freq_limits),
> +				     GFP_KERNEL);
> +	if (!wiphy->freq_limits) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	p = NULL;
> +	for (i = 0; i < wiphy->n_freq_limits; i++) {
> +		struct ieee80211_freq_range *limit = &wiphy-
> >freq_limits[i];
> +
> +		p = of_prop_next_u32(prop, p, &limit-
> >start_freq_khz);
> +		if (!p) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +
> +		p = of_prop_next_u32(prop, p, &limit->end_freq_khz);
> +		if (!p) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +	}

You should also reject nonsense like empty ranges, or ranges with a
higher beginning than end, etc. I think


put

	return 0;

here.

> +out:
> +	if (err) {

then you can make that a pure "error" label and remove the "if (err)"
check.

> +void wiphy_freq_limits_apply(struct wiphy *wiphy)

I don't see any point in having this here rather than in reg.c, which
is the only user.

> +			if (!wiphy_freq_limits_valid_chan(wiphy,
> chan)) {
> +				pr_debug("Disabling freq %d MHz as
> it's out of OF limits\n",
> +					 chan->center_freq);
> +				chan->flags |= IEEE80211_CHAN_DISABLED;

This seems wrong.

The sband and channels can be static data and be shared across
different wiphys for the same driver. If the driver has custom
regulatory etc. then this can't work, but that's up to the driver. OF
data is handled here though, so if OF data for one device disables a
channel, this would also cause the channel to be disabled for another
device, if the data is shared.

To avoid this, you'd have to have drivers that never share it - but you
can't really guarantee that at this level.

In order to fix that, you probably need to memdup the sband/channel
structs during wiphy registration. Then, if you set it up the right
way, you can actually simply edit them according to the OF data
directly there, so that *orig_flags* (rather than just flags) already
gets the DISABLED bit - and that allows you to get rid of the reg.c
hooks entirely since it'll look the same to reg.c independent of the
driver or the OF stuff doing this.


That can actually be inefficient though, since drivers may already have
copied the channel data somewhere and then you copy it again since you
can't know.

Perhaps a better approach would be to not combine this with wiphy
registration, but require drivers that may use this to call a new
helper function *before* wiphy registration (and *after* calling
set_wiphy_dev()), like e.g.

   ieee80211_read_of_data(wiphy);

You can then also make this an inline when OF is not configured in
(something which you haven't really taken into account now, you should
have used dev_of_node() too instead of dev->of_node)

Yes, this would mean that it doesn't automatically get applied to
arbitrary drivers, but it seems unlikely that arbitrary drivers like
realtek USB would suddenly get OF node entries ... so that's not
necessarily a bad thing.

In the documentation for this function you could then document that it
will modify flags, and as such must not be called when the sband and
channel data is shared, getting rid of the waste/complexity of the copy
you otherwise have to make in cfg80211.

johannes
