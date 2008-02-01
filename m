Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:34019 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYBAVpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 16:45:40 -0500
Received: by rv-out-0910.google.com with SMTP id k20so902483rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 13:45:38 -0800 (PST)
Message-ID: <43e72e890802011345l47dd4234t2515c5be4c5a8580@mail.gmail.com> (sfid-20080201_214555_185548_01740CCA)
Date: Fri, 1 Feb 2008 16:45:38 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: Cleanup after API changes patch
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	bruno@thinktube.com, "Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <40f31dec0802011047r6f90b714x8626f9158b963e6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <1201869496.4188.15.camel@johannes.berg>
	 <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com>
	 <1201869970.4188.24.camel@johannes.berg>
	 <43e72e890802010452s510628ear49136748e06fc670@mail.gmail.com>
	 <40f31dec0802011047r6f90b714x8626f9158b963e6d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 1:47 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2008/2/1, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>:
>
> > 2008/2/1 Johannes Berg <johannes@sipsolutions.net>:
> > >
> > > > > What is cap_range and why should it be in struct wiphy?
> > > >
> > > > Its the device's frequency capability range on the bands.
> > >
> > > Well since we always need channels I decided to not have such a thing
> > > but rather require registering a channels array that is also used for
> > > bookkeeping about enabled/disabled channels etc.
> > >
> > > I guess you could add a helper function that allocates a channels array
> > > based on a frequency range.
> >
> > This is true but also it would be nice as it is the end points which
> > drivers may want
> > to access every now and then. I think its worth the few bytes.
> >
> >   Luis
>
> Why mac80211/cfg80211 has to know about phy's channel range ? I mean
> driver knows it and that's all we need to create the big (unfiltered)
> channel array.

Yes, you are right, from a driver's perspective this is all we need
this for. But, for example, say user tries to change to a channel by
freq, and we want to see if we support it, wouldn't it be easier to
have mac80211 do the check for us against the wiphy's range on the
band instead of having the driver do it? mac80211 would do it a lot
quicker by just knowing the range for example.

> These caps are set for some chip revisions (eg. 5210
> supports only part of 5GHz band while 5111/5112 support much wider
> range) and only used by channel_ok during channel setup (attach), we
> don't have any other use for those inside the driver.

Sure.

> Other drivers
> don't even need such caps because channel ranges are standard for all
> their chip revisions, or they get channels from firmware, or use fixed
> range/channel table no matter what phy supports etc.

I just want to make it available for drivers in central place for
those who *could* use it and for mac80211 for a quick short cut.
Additionally it seems it would be good to export this to userspace
instead of having it iterate over the array to simply get the range.

> The only use i can imagine for frequency range information on
> mac80211/cfg80211 is that the whole channel setup is being done during
> wiphy setup (we provide frequency range and supported bands and
> mac80211/cfg80211 does the rest) but we'll have (at least for ath5k)
> to fill channel flags (hw_value) anyway.

You are right, we discussed this a while back on the list as well and
came to the same conclusion. I am curious -- are there drivers which
have the same hw_value as the freq? But disregard this -- this isn't
the reason why  I brought up the cap. I've mentioned the reasons above
and to johill in my last reply. Please let me know what you think.

> About the patch: You are right that we should use channel_ok in
> hw_channel but there is no need for that switch, channel_ok checks the
> channel flags (hw_value) and determines the band already (and channel
> flags are filled per band -CHANNEL_2GHZ/CHANNEL_5GHZ- during setup so
> checking channel->band or channel->hw_vallue is the same).

OK I think I see your point. I can send a follow up patch if you don't mind.

  Luis
