Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:19746 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYAPVuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 16:50:39 -0500
Received: by wr-out-0506.google.com with SMTP id c49so173758wra.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2008 13:50:38 -0800 (PST)
Message-ID: <43e72e890801161350v3cb44068p15a32b71af26a8d2@mail.gmail.com> (sfid-20080116_215047_869076_382E0E44)
Date: Wed, 16 Jan 2008 16:50:37 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] nl80211: export frequencies/bitrates
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1200439921.5887.148.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1200439921.5887.148.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 15, 2008 6:32 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> This is the user-space complement of the cfg80211 frequency/bitrate
> patch and exports all the information via nl80211.
>
> It obviously depends on the cfg80211 patch I've posted previously. I've
> also committed support for printing this information to my 'iw' tool (I
> still hope somebody will rewrite it some day and I don't have to
> maintain it... the netlink code in it is really quite wrong too...).
> Yell at me if I forget to push that changeset
> (79f99b9ad89494fc81d5c966a32dcebe9742f12c "add wiphy dump capability")
> to the git tree on git.sipsolutions.net (i.e. you don't see it shortly
> after this mail.)
>
> Luis, can you work with these attributes?

I can definitely make use of band and freq. Some comments about bit
rates below though.

> I think they should be
> sufficient for SET support as well for the regulatory daemon.

If you mean by "SET support" as for SET support for the regulatory
domain struct then no, I need a few more. Here's a list of some:

* Power (EIRP, IR and for PtP or PtMP)
* Antenna gain
* Environment capabilities (Indoor/outdoor)
* Modulation capabilities

Of these we can use to export more wiphy capabilities:  power (just
IR), modulation capabilities, and antenna gain (we could assume ~dBi
for antenna gain, and let user configure this).

> @@ -280,4 +285,63 @@ enum nl80211_sta_stats {
>         NL80211_STA_STAT_MAX = __NL80211_STA_STAT_AFTER_LAST - 1
>  };
>
> +/**
> + * enum nl80211_band_attr - band attributes
> + * @__NL80211_BAND_ATTR_INVALID: attribute number 0 is reserved
> + * @NL80211_BAND_ATTR_FREQS: supported frequencies in this band,
> + *     an array of nested frequency attributes
> + * @NL80211_BAND_ATTR_RATES: supported bitrates in this band,
> + *     an array of nested bitrate attributes
> + */
> +enum nl80211_band_attr {
> +       __NL80211_BAND_ATTR_INVALID,
> +       NL80211_BAND_ATTR_FREQS,
> +       NL80211_BAND_ATTR_RATES,

Hmm -- not sure if rates should be an attribute of the band. In terms
of IEEE-802.11 I would think we could add to the band IEEE-802.11
"modes" (a, b, g or n), and each mode can have a set of modulations
and each modulation a set of rates. This is from the wiphy device
capability point of view. From the regulatory point of view I broke
things down a bit differently -- a band can have set of subbands and a
subband can have a set of possible modulations (flags). This is
because regulatory laws usually speak about frequency ranges and on
these ranges you usually have the same set of power/antenna
restrictions. One thing we'll have to think about later is channel
usage for 802.11n, haven't started toying with that yet in terms of
regulatory restrictions but I think it may just be the list of
channels (center of freqs) which can be used at the same time.

Should we have an nl80211_wiphy_band_attr and an
nl80211_reg_band_attr? Or should we try to come up with just one which
would work and make sense for both device capability and regulatory
structure definition?

Just for reference my old patch which dealt with the regulatory
structure definition can be found here:

http://kernel.org/pub/linux/kernel/people/mcgrof/v2-regdomain-patches/0003-PATCH-Wireless-add-IEEE-802.11-regualtory-domain.patch

> +
> +       /* keep last */
> +       __NL80211_BAND_ATTR_AFTER_LAST,
> +       NL80211_BAND_ATTR_MAX = __NL80211_BAND_ATTR_AFTER_LAST - 1
> +};
> +
> +/**
> + * enum nl80211_frequency_attr - frequency attributes
> + * @NL80211_FREQUENCY_ATTR_FREQ: Frequency in MHz

Is @NL80211_FREQUENCY_ATTR_CENTER_FREQ too long? If so then can we
specify that its used for the center of freq in the kdoc comment?

  Luis
