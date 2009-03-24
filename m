Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42089 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbZCXQDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 12:03:01 -0400
Subject: Re: wireless powersaving (in NM?)
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1237891149.4320.73.camel@johannes.local>
References: <1237891149.4320.73.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 11:32:14 +0100
Message-Id: <1237890734.4740.7.camel@localhost.localdomain> (sfid-20090324_170304_872737_856A292C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> We're looking into turning on powersaving by default at least when on
> battery power, and I think that it needs to be done in userspace, simply
> by calling the equivalent of "iwconfig wlan0 power on".
> 
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

I agree that we should always enable power saving by default. Maybe in
the beginning have a kernel option that selects the default value (like
USB does at the moment).

> However, by putting the burden onto drivers, drivers can choose a
> conservative power saving level when no application has registered its
> pm_qos requirements, and once applications start using the it deeper
> power levels can be chosen as appropriate. This still requires some
> userspace to turn on power saving to start with, which I think would be
> appropriately placed in NM (or connman, of course).

I prefer that we not export this over WEXT at all and only via nl80211
so we get async notification if some one changes it. We should extend
wpa_supplicant with an option to set power saving on/off/default and
then make sure it gets exported via its CLI or D-Bus. So if Network
Manger or ConnMan cares to change these values they can.

However personally I think the need for enabling or disabling power
savings is not really useful except for testing purposes. In a real life
deployed system it should be enabled all the time. Broken drivers or
hardware that is limited can disable it on kernel level, but for
userspace we only need this for debugging.

Regards

Marcel


