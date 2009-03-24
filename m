Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45907 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbZCXQCV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 12:02:21 -0400
Subject: Re: wireless powersaving (in NM?)
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1237891149.4320.73.camel@johannes.local>
References: <1237891149.4320.73.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 11:59:58 -0400
Message-Id: <1237910398.9082.7.camel@localhost.localdomain> (sfid-20090324_170224_412384_60636905)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-03-24 at 11:39 +0100, Johannes Berg wrote:
> Hi,
> 
> We're looking into turning on powersaving by default at least when on
> battery power, and I think that it needs to be done in userspace, simply
> by calling the equivalent of "iwconfig wlan0 power on".

or maybe gnome-power-manager (and whatever the kde equivalent is) should
be driving this based on all the other policy decisions it makes?  it's
the thing that handles whether you're on battery or on AC, what your
drive spin-down time is, it knows when your laptop lid is closed, what
your display brightness is at, etc.

it might use some information from NM as input, but the overall power
manager is probably where the actual policy decisions should be made.

Dan

> iwlwifi currently supports 5 or 6 power saving levels, and some people
> think we should allow those to be exposed to "iwconfig wlan0 power
> saving <N>", but as I've said before I don't see how the user can
> possibly make an informed choice. Essentially it seems to me that the
> best way for the user to determine the level would be to roll a dice and
> see if applications still work as expected. It is also specific to a
> single driver, and other drivers would expose similar values with
> completely different semantics -- in one word: useless. Yes, Windows
> exposes this, but that doesn't mean it's meaningful. Quite the contrary,
> in fact, many (most? all?) of the things Windows exposes related to
> power management are absolutely _not_ meaningful and hurt overall
> usability [1].
> 
> Therefore, I think the "power saving level" needs to be determined by
> pm_qos. The design of how to do that, however, is still up in the air.
> One question, for example, is whether the driver should be adjusting the
> power savings parameters, with mac80211 only asking for it to be enabled
> or disabled. I'm thinking that the driver is in the best position to do
> so since various drivers have various parameters that can be tweaked.
> This would depend on pm_qos notifications being used in the driver, when
> power saving is enabled by mac80211.
> 
> The alternative would be to expose all the possible parameters and/or
> levels to mac80211 and have it make choices based on pm_qos, but it
> seems that this interface would rapidly become extremely complex,
> fragile and buggy.
> 
> Kalle, there's a related question here -- what's the value of exposing
> the sleep timeout to users? It seems to be quite unnecessary, since you
> seem to be using a fixed value of 500ms anyway. Can we remove that,
> leaving wext only with turning on/off power saving? [2][3]
> 
> Ultimately, power saving mode should always be enabled unless the user
> specifically requires it being turned off (why?), regardless of AC power
> status; there's no reason not to do that if we integrate it into the
> entire system well enough so that things "just work". But that requires
> applications to change to register their network latency/throughput
> requirements.
> 
> However, by putting the burden onto drivers, drivers can choose a
> conservative power saving level when no application has registered its
> pm_qos requirements, and once applications start using the it deeper
> power levels can be chosen as appropriate. This still requires some
> userspace to turn on power saving to start with, which I think would be
> appropriately placed in NM (or connman, of course).
> 
> Comments?
> 
> johannes
> 
> 
> [1] I was recently bitten by that when giving a presentation, and then
> forgetting to go out of presentation mode -- this left my laptop without
> a screensaver lock for far too long
> 
> [2] which is a reasonable setting, imho, since you may well want to
> disable it under some circumstances, but I cannot see users making an
> informed choice about any of the many parameters -- of course we also
> need to start keeping track of this per virtual interface rather than
> globally so that adding a WDS interface for instance turns off power
> saving
> 
> [3] since only one out-of-tree driver is allowing it to be used, it
> wouldn't even be a "regression" right now
> 

