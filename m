Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:38160 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbZCXOSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 10:18:12 -0400
Received: by bwz17 with SMTP id 17so2240244bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 07:18:08 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: wireless powersaving (in NM?)
References: <1237891149.4320.73.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 24 Mar 2009 16:17:58 +0200
In-Reply-To: <1237891149.4320.73.camel@johannes.local> (Johannes Berg's message of "Tue\, 24 Mar 2009 11\:39\:09 +0100")
Message-ID: <87ab7bqa21.fsf@litku.valot.fi> (sfid-20090324_151823_930182_EAEFB867)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi,

Hallo Johannes,

> We're looking into turning on powersaving by default at least when
> on battery power, and I think that it needs to be done in userspace,
> simply by calling the equivalent of "iwconfig wlan0 power on".

I agree, this decision definitely needs to be done in userspace.

> iwlwifi currently supports 5 or 6 power saving levels, and some people
> think we should allow those to be exposed to "iwconfig wlan0 power
> saving <N>", but as I've said before I don't see how the user can
> possibly make an informed choice.

I also don't like this interface at all. The values have no meaning
and the interface simply doesn't make any sense to me.

> Therefore, I think the "power saving level" needs to be determined
> by pm_qos. The design of how to do that, however, is still up in the
> air.

Maybe. At least it "feels" a lot better than the five magic numbers :)

Unfortunately I haven't thought about this so I cannot comment on it.
And by the looks of it, I won't find the time for some time.

> One question, for example, is whether the driver should be adjusting
> the power savings parameters, with mac80211 only asking for it to be
> enabled or disabled. I'm thinking that the driver is in the best
> position to do so since various drivers have various parameters that
> can be tweaked. This would depend on pm_qos notifications being used
> in the driver, when power saving is enabled by mac80211.

Actually I have to disagree here....

> The alternative would be to expose all the possible parameters and/or
> levels to mac80211 and have it make choices based on pm_qos, but it
> seems that this interface would rapidly become extremely complex,
> fragile and buggy.

I think this alternative would be better in the long run. My feeling
is that the settings between different hardware don't wary that much
based on what I have seen and we would eventually find settings which
work for all, maybe small hackery needed somewhere but that's it.

But at the same time I admit that it needs a lot of work to do this
properly in mac80211. One needs to study different hardware
implementations etc. With the current pace it would take at least a
year to have something really usable.

Also remember that in !IEEE80211_HW_SUPPORTS_DYNAMIC_PS case the
dynamic timer is in mac80211. So the driver cannot make all decisions.

> Kalle, there's a related question here -- what's the value of exposing
> the sleep timeout to users? It seems to be quite unnecessary, since you
> seem to be using a fixed value of 500ms anyway. 

In Maemo products (n800, n810 etc) we use it to select the power save
aggressiveness. IIRC in diablo it was so that when the display was on
200 ms timeout value was used, and then it was off the value was set
to 100 ms. The decision was made in userspace, in wlancond (our dbus
WE wrapper). The idea here was that user won't most probably mind if
the network is slower then the display is off.

> Can we remove that, leaving wext only with turning on/off power
> saving? [2][3]

I would hate to loose it, at least in the near future. If there's a
good alternative and a proper deprecation period, I don't mind it
going away.

> Ultimately, power saving mode should always be enabled unless the user
> specifically requires it being turned off (why?), regardless of AC power
> status; there's no reason not to do that if we integrate it into the
> entire system well enough so that things "just work". But that requires
> applications to change to register their network latency/throughput
> requirements.

I fully agree here. We just have to make the power save implementation
so good that the user won't notice that it's even enabled.

And I really don't get the idea that if AC is connected we can waste
all power we want, what's the point in that? That's not good from any
perspective: device gets warmer, electricity bill gets higher and
"global worming" increases ;)

Disabling the power save should always be a visible option for the
users because of the broken APs. There are still APs which have
problems with power save enabled clients.

> However, by putting the burden onto drivers, drivers can choose a
> conservative power saving level when no application has registered its
> pm_qos requirements, and once applications start using the it deeper
> power levels can be chosen as appropriate.

It will take years for the applications to adapt this, I would not
want to depend on that. I would like to have usable already without
application support.

> This still requires some userspace to turn on power saving to start
> with, which I think would be appropriately placed in NM (or connman,
> of course).

Agree, NM and connman are the correct places in my opinion.
wpa_supplicant maybe could provide a dbus interface, but NM or connman
would make the decision.

-- 
Kalle Valo
