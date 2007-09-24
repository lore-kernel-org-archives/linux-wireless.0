Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:47960 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbXIXTzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:55:47 -0400
Received: by py-out-1112.google.com with SMTP id u77so3105008pyb
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 12:55:46 -0700 (PDT)
Message-ID: <43e72e890709241255v1f044f9dh4af1e00fcaba03b0@mail.gmail.com>
Date: Mon, 24 Sep 2007 15:55:46 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: API to regulatory control (1)
Cc: linux-wireless@vger.kernel.org, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1190624554.18521.261.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1190456574.18521.220.camel@johannes.berg>
	 <43e72e890709221416o25bf3287v5d8d7bb5c2fe15ab@mail.gmail.com>
	 <1190624554.18521.261.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Johannes Berg <johannes@sipsolutions.net> wrote:

> > > [NOTE: I think there's a restriction on OFDM somewhere so we must have a
> > > channel struct for each modulation to be able to disable OFDM/force
> > > lower power with OFDM]
> >
> > We'll need to elaborate on this later.
>
> I'm not sure. I haven't looked up those restrictions but ISTR somebody
> told me there were such restrictions. I'm happy to be proven wrong---it
> can only simplify things.
>
> > > Next, the driver needs to say which modulations/bitrates it supports:
> > > struct ieee80211_rate {
> > >         /* stuff from the driver */
> > >         enum ieee80211_modulation modulation; /* OFDM, CCK, CCK_SHORTPRE */
> > >         u32 rate; /* in units of 100 Kbps */
> > >         /* internal stuff */
> > >         TBD;
> > > };
> > >
> > > Again, it's stuffed together into an array:
> > > struct ieee80211_rates {
> > >         struct ieee80211_rate *rates;
> > >         int num_rates;
> > > };
> >
> > ACK -- however note that these are defined already by the IEEE "mode"
> > we operate in. The vendor rates and vendor modulations are the things
> > that will vary out of the norm I believe.
>
> We don't really have a plan how to support vendor modulations because it
> heavily influences calculations in the stack. Anybody have ideas? I'd
> prefer if we'd defer that until later.
>
> > > so let's say we now have a b43_supported_rates variable although we
> > > really have one for A, B, BG and ABG devices.
> > >
> > > NOTE: All this rate stuff is *NOT* interesting for regulatory. *IFF*
> > > there are regulatory restrictions on bitrates anywhere then we need to
> > > make this part of the channels array!
> >
> > I think it may have been Jouni who pointed this out for Japan at some
> > point. It was big news to me. If this is an exception we can treat it
> > as such just as with the FCC 3:1 rule between max IR and antenna_gain
> > for PtMP links, or Japan's rules for not allowing disabling active
> > scan on old 5GHz channels.
>
> Ouch. Will have to change plans then.

With what I have we can treat these things as exceptions, since I
think they are exceptions. So fortunately with what I have, I don't
have to change anything.

> Another thing I considered was to have a function to get "regulatory
> OK", i.e. the only thing we'd have in regulatory code would be a few
> functions like this:
>
> int regulatory_check(freq, modulation, ...);
> -> returns 0 or 1 (if allowed)
>
> int regulatory_get_max_power(freq, modulation, ..., pmtp_or_ptp);
>
> But I then thought we'd be calling this function a lot during scanning
> so discarded this idea. However, with all the complexity here, maybe we
> can revive it and provide some sort of "for each allowed channel" loop
> or something too.

At scan time we can just check the channel flags, those are always
supposed to be up to date if cfg80211 is in charge of updating all
wiphys with the new rules upon regulatory domain change.

> > Anyway -- I now see what you were saying on IRC and I think its a
> > pretty good idea as the path I was following for series II of patches
> > was ab it different :-)
>
> I never meant to distract you from the ideas you have, I'm open for
> other suggestions too. I didn't think long about this anyhow, just the
> stuff I came up with after looking at it for a bit.
>
> > But let me ask you this though -- is that
> > necessary? Since each mac80211 driver mode right now has a
> > ieee80211_channel array pointer can't we just have cfg80211 be aware
> > of this, at least for now?
>
> Do we actually need the modes? I'm a bit confused now.

No, you're right, It seems like we don't, yeah I don't think we do..
but I was just basing the model on the current mac80211 driver API,
which does have modes... if we are going to get rid of struct
ieee80211_hw_mode this is a pretty serious cleanup on the both
mac80211 and driver side. It'll be good, make driver code smaller but
it seems like a lot of work right now.

Hmm, it seems if we take this approach we'll need to stage this into
separate development parts to not cause too enforce too many changes
on drivers. Instead of the 2-series I suggested how about 3 series:

* I - Introduce new regdomain modules integrate with cfg80211
* II - Minimal mac80211 support with current driver infrastructure
* III - Start optimizing to remove all unnecessary materials

We may just want to go directly to series III but based on the amount
of complaints from current driver writers I think its best to use 3
stages for this... Comments?

> > > This is how both
> > > mac80211 and cfg80211 get told about it. &b43_supported_rates is put
> > > into struct ieee80211_hw, only mac80211 needs to know about it, fullmac
> > > drivers never need to show this information to anything outside except
> > > maybe for some cfg80211 *hooks*.
> >
> > Hm, as I said above rate stuff seems pretty common amongst modes.
> > Can't we just assume if your card supports a certain IEEE-802.11 mode
> > that you'll have at least certain rates?
>
> Ahh. I see what you mean. Well, what I'd do is provide an array in
> mac80211 that is EXPORT_SYMBOL'ed so you can simply refer to that if you
> don't have any special hardware-values for the stuff.

This seems like it would certainly optimize driver code. Same comment
as above applies here though.

> And maybe provide
> allocation functions for when you do need special hardware-values. Then
> only drivers that need really special stuff need to do all the array
> building themselves, but in principle can.

Hmm, yeah you know the nice thing about the current interface is that
we can support 'vendor' rates by using the current model.. Aha! How
about this...

We introduce very specific rates for each mode which drivers can use
for the minimal support from what we know IEEE-802.11 defines.. Then
we can simply use the current mode/rate work for vendor modes and
vendor rates? We have the part of the code already, we just need to
adjust it. This will make introduction a lot easier too. If the driver
doesn't use specify its using the 'stack' modes an rates, we can then
check its linked list of modes.

Comments?

> > > Internally, mac80211 or fullmac drivers of course need to check the
> > > channel structs internally when they are asked to move to a different
> > > channel or change TX power.
> >
> > Sure, cfg8021 can just do this. We just need to be sure cfg80211 won't
> > break anything.
>
> Hm. cfg80211 could do it but I think it might be wise to have it in
> drivers since scanning will require the driver to do it anyway.

Scanning won't require this update if we can assume a driver's channel
list flags are *always* up to date. Since cfg80211 is in charge of
updating the central regdomain it wil *know* when it gets updated and
as such can, for example, 'lock' the channel structs. This will assure
we don't allow channel change, scan, or any other nasty thing which
may break regulatory laws, during a regulatory change. Note that
regulatory domain change should be a rare thing though :-)

> > > At this point, however, the regulatory agent API only starts. First of
> > > all, the channel list has already been registered with cfg80211 because
> > > a pointer is part of struct wiphy
> >
> > If we take this approach, sure.
>
> No need to, of course, we could register it explicitly as well.

I think we'll need a writeup of what we want and agree on it as a path
to take so everyone is on the same page.

> > >  Then, when by any way possible, the
> > > regulatory restrictions change (user setting, ...) the fields marked
> > > "second part updated by regulatory agent" are updated for each wiphy
> >
> > As of right now I think changing channel rules and power restrictions
> > (ir, eirp, and antenna gain) is all the regulatory agent should do.
> > Beyond that its news to me that regulatory laws say we have to change
> > other aspects of wireless communication.
>
> Right. I'm not sure about modulations (see above) but I agree with this.

Jouni? Anyone?

> > If all we have to do is update the channel flags and power
> > restrictions, why should drivers be informed about regulatory change?
> > I agree, it may be good to have, but I'm just wondering why we should
> > make this a priority right now if don't have a good reason for drivers
> > be informed about this.
>
> Well, I think it's not too important when you think of channels, but say
> you have an AP open and for some reason move into a new regulatory
> domain, the TX power might need to be adjusted. This isn't important,
> but implementing the hook to allow (notifier chain) is trivial so I
> figured we might as well do it.

ACK -- but, since cfg80211 *can* be in charge of updating the, either
central channel struct, or each driver's channel struct, we can also
have it update power restrictions upon regulatory domain change. Same
as above. What do you think?

> > I was thinking one simple way of doing this was to add to the wiphy
> > struct a reg timestamp or counter, and also have one for the central
> > reg agent. If the stamps don't match, well then we know the central
> > reg agent has changed the central regdomain and the driver can do
> > whatever work it needs to. A notifier seems much better than polling
> > though. But I just am not sure if we need this right now.
>
> Yeah I agree about polling, that sucks since we're all in the kernel.
> But see above as for why I think we should do it anyway.

ACK but also see my above comments as to why I think we may not even
need notifiers, at least so far.

> > > From what I can see, this finishes the channel restrictions API. Since
> > > none of the information in the channels list is specific to some device,
> > > it may be allocated statically.
> >
> > I don't quite get by what you mean in this last part. Can you
> > elaborate a bit further?
>
> Well, I think that there's no need to allocate the channels array
> dynamically, each driver can have just a single one indicating what the
> hardware is capable of and use it multiple times if you say plug in 20
> zd1211 devices.

Oh sure. Unless we want to be freaks and support different regulatory
domains for each device... This may apply later for Software Defined
Radios.. but not for now ;)

> > OK -- so now let me address why I haven't done some changes which you
> > have addressed yet. It's because I don't want to cause a headache to
> > driver developers and for introduction of this work it would mean A
> > LOT of work and changes. I rather introduce this work gently, only
> > modifying absolutely necessary things first.
>
> I'm not sure. I think I prefer getting the API right and having some
> driver pain than trying to introduce it over a few weeks and having
> longer pain ;) But I suppose that's just me, you may well prefer to do
> it slower and I won't push it.

Well I think we can come to a compromise. If we use the strategy above
of moving modes to 'vendor_modes' and add a central mode, with the
option of letting the driver specify it it wants to use the central
modes, we can move any driver slowly at any time to the new API
without breaking a single thing.

Introducing a central reg agent *now* with the API as it is would
require some minimal changes which I can make now. That needs some
work though too (series II). But this work could proceed to at least
start removing every driver's own regulatory domain implementation
while the backend gets support for generic modes and rates. Later on,
we can use let drivers ask to parse a 'vendor' mode through the
current regulatory domain, for that we can use what we'll provide in
the meantime to support the current mode allocation on mac80211.

> > If patchset series I work is embraced
>
> I think the patches you posted are pretty much unusable as they stand,
> you should at least clean out the number of lines you have in headers
> and the ugly macros that declare arrays (why is that anyway? does
> openbsd really ship such code?)

Yeap. I agree, I also have a list of things to flip around based on
your comments. I'll send v3 soon of series I soon.

  Luis
