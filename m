Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:59582 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762580AbYBBWTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 17:19:51 -0500
Received: by py-out-1112.google.com with SMTP id u52so2386560pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 14:19:49 -0800 (PST)
Message-ID: <43e72e890802021419w2460ea3ay5ea74be45697d322@mail.gmail.com> (sfid-20080202_221954_921869_58799758)
Date: Sat, 2 Feb 2008 17:19:47 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: Cleanup after API changes patch
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	bruno@thinktube.com, "Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <43e72e890802011345l47dd4234t2515c5be4c5a8580@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <1201869496.4188.15.camel@johannes.berg>
	 <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com>
	 <1201869970.4188.24.camel@johannes.berg>
	 <43e72e890802010452s510628ear49136748e06fc670@mail.gmail.com>
	 <40f31dec0802011047r6f90b714x8626f9158b963e6d@mail.gmail.com>
	 <43e72e890802011345l47dd4234t2515c5be4c5a8580@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 4:45 PM, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu> wrote:
> On Feb 1, 2008 1:47 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > 2008/2/1, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>:
> >
> > > 2008/2/1 Johannes Berg <johannes@sipsolutions.net>:
> > > >
> > > > > > What is cap_range and why should it be in struct wiphy?
> > > > >
> > > > > Its the device's frequency capability range on the bands.
> > > >
> > > > Well since we always need channels I decided to not have such a thing
> > > > but rather require registering a channels array that is also used for
> > > > bookkeeping about enabled/disabled channels etc.
> > > >
> > > > I guess you could add a helper function that allocates a channels array
> > > > based on a frequency range.
> > >
> > > This is true but also it would be nice as it is the end points which
> > > drivers may want
> > > to access every now and then. I think its worth the few bytes.
> > >
> > >   Luis
> >
> > Why mac80211/cfg80211 has to know about phy's channel range ? I mean
> > driver knows it and that's all we need to create the big (unfiltered)
> > channel array.
>
> Yes, you are right, from a driver's perspective this is all we need
> this for. But, for example, say user tries to change to a channel by
> freq, and we want to see if we support it, wouldn't it be easier to
> have mac80211 do the check for us against the wiphy's range on the
> band instead of having the driver do it? mac80211 would do it a lot
> quicker by just knowing the range for example.
>
> > These caps are set for some chip revisions (eg. 5210
> > supports only part of 5GHz band while 5111/5112 support much wider
> > range) and only used by channel_ok during channel setup (attach), we
> > don't have any other use for those inside the driver.
>
> Sure.
>
> > Other drivers
> > don't even need such caps because channel ranges are standard for all
> > their chip revisions, or they get channels from firmware, or use fixed
> > range/channel table no matter what phy supports etc.
>
> I just want to make it available for drivers in central place for
> those who *could* use it and for mac80211 for a quick short cut.
> Additionally it seems it would be good to export this to userspace
> instead of having it iterate over the array to simply get the range.
>
> > The only use i can imagine for frequency range information on
> > mac80211/cfg80211 is that the whole channel setup is being done during
> > wiphy setup (we provide frequency range and supported bands and
> > mac80211/cfg80211 does the rest) but we'll have (at least for ath5k)
> > to fill channel flags (hw_value) anyway.
>
> You are right, we discussed this a while back on the list as well and
> came to the same conclusion. I am curious -- are there drivers which
> have the same hw_value as the freq? But disregard this -- this isn't
> the reason why  I brought up the cap. I've mentioned the reasons above
> and to johill in my last reply. Please let me know what you think.
>
> > About the patch: You are right that we should use channel_ok in
> > hw_channel but there is no need for that switch, channel_ok checks the
> > channel flags (hw_value) and determines the band already (and channel
> > flags are filled per band -CHANNEL_2GHZ/CHANNEL_5GHZ- during setup so
> > checking channel->band or channel->hw_vallue is the same).
>
> OK I think I see your point. I can send a follow up patch if you don't mind.

I'm just going to resend all pending patches. For this stuff I've
shifted a bit like this:

        /*
         * Check bounds supported by the PHY (we don't care about regultory
         * restrictions at this point). Note: hw_value already has the band
         * (CHANNEL_2GHZ, or CHANNEL_5GHZ) so we inform ath5k_channel_ok()
         * of the band by that */
        if (!ath5k_channel_ok(ah, channel->center_freq, channel->hw_value)) {
                char bname[5];
                switch (channel->band) {
                case IEEE80211_BAND_2GHZ:
                        strcpy(bname, "2 GHz");
                        break;
                case IEEE80211_BAND_5GHZ:
                        strcpy(bname, "5 GHz");
                        break;
                default:
                        BUG_ON(1);
                        return -EINVAL;
                }
                ATH5K_ERR(ah->ah_sc,
                        "channel frequency (%u MHz) out of supported "
                        "%s band range (%u - %u MHz)\n",
                        channel->center_freq,
                        bname,
                        ah->ah_capabilities.cap_range.range_2ghz_min,
                        ah->ah_capabilities.cap_range.range_2ghz_max);
                        return -EINVAL;
        }
