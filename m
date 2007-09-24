Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:58359 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbXIXWSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 18:18:12 -0400
Received: by py-out-1112.google.com with SMTP id u77so3169391pyb
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 15:18:11 -0700 (PDT)
Message-ID: <43e72e890709241518h1cc694d9of8f8a8d216a7906b@mail.gmail.com>
Date: Mon, 24 Sep 2007 18:18:11 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: API to regulatory control (1)
Cc: linux-wireless@vger.kernel.org, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1190669783.18521.301.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1190456574.18521.220.camel@johannes.berg>
	 <43e72e890709221416o25bf3287v5d8d7bb5c2fe15ab@mail.gmail.com>
	 <1190624554.18521.261.camel@johannes.berg>
	 <43e72e890709241255v1f044f9dh4af1e00fcaba03b0@mail.gmail.com>
	 <1190669783.18521.301.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-09-24 at 15:55 -0400, Luis R. Rodriguez wrote:
>
> > > But I then thought we'd be calling this function a lot during scanning
> > > so discarded this idea. However, with all the complexity here, maybe we
> > > can revive it and provide some sort of "for each allowed channel" loop
> > > or something too.
> >
> > At scan time we can just check the channel flags, those are always
> > supposed to be up to date if cfg80211 is in charge of updating all
> > wiphys with the new rules upon regulatory domain change.
>
> Right, that's why I figured we should have them, I was considering
> discarding them to make the structure smaller.

Yeah no it helps a lot to have them.

> > No, you're right, It seems like we don't, yeah I don't think we do..
> > but I was just basing the model on the current mac80211 driver API,
> > which does have modes... if we are going to get rid of struct
> > ieee80211_hw_mode this is a pretty serious cleanup on the both
> > mac80211 and driver side. It'll be good, make driver code smaller but
> > it seems like a lot of work right now.
> >
> > Hmm, it seems if we take this approach we'll need to stage this into
> > separate development parts to not cause too enforce too many changes
> > on drivers. Instead of the 2-series I suggested how about 3 series:
> >
> > * I - Introduce new regdomain modules integrate with cfg80211
> > * II - Minimal mac80211 support with current driver infrastructure
> > * III - Start optimizing to remove all unnecessary materials
> >
> > We may just want to go directly to series III but based on the amount
> > of complaints from current driver writers I think its best to use 3
> > stages for this... Comments?
>
> I dunno. Did we get that many complaints? I think the filter flags
> change went rather well. In any case, I don't really have a plan and I
> don't see how we can change any of this without breaking drivers at
> least once.

I saw complaints on the z1211 move thread to upstream about large
patches and driver developers not being able to keep up as mac80211 is
a 'moving target'.

> > We introduce very specific rates for each mode which drivers can use
> > for the minimal support from what we know IEEE-802.11 defines.. Then
> > we can simply use the current mode/rate work for vendor modes and
> > vendor rates? We have the part of the code already, we just need to
> > adjust it. This will make introduction a lot easier too. If the driver
> > doesn't use specify its using the 'stack' modes an rates, we can then
> > check its linked list of modes.
>
> Not sure. Some drivers actually do need the hardware-specific value in
> the struct there that was pass around when setting channel/rate.

Well channel mapping to hardware values requires less info than what
we currently use. But after a quick review of this you're right...
after we nuke min_rssi_ack and min_rssi_ack_delta (which I do in my
patches) from ieee80211_rate those structs are pretty optimized
already if all we want to provide is hw mapping values.

Another option here is just speak to the driver in a hardware-agnostic
sense and just let drivers map this out however they want. I guess it
provides for a cleaner API if we keep this in our own structs though.

> > ACK -- but, since cfg80211 *can* be in charge of updating the, either
> > central channel struct, or each driver's channel struct, we can also
> > have it update power restrictions upon regulatory domain change. Same
> > as above. What do you think?
>
> Well, but the driver must actually change the power level and hence it
> must be notified of the change after it has occurred so it is able to
> adjust.

Only if the new power restrictions makes he current one invalid.

> I don't think I want to call into some cfg80211 call for this, a
> specific notifier seems more appropriate.

Well what if cfg80211  generates a notification if a possible conflict
has been found? Is there a need to generate a notification on power
reg changes to the driver besides this?

> > Oh sure. Unless we want to be freaks and support different regulatory
> > domains for each device... This may apply later for Software Defined
> > Radios.. but not for now ;)
>
> Why would that be a different domain? It'd be a different set of
> restrictions but I don't think you can really manage to have a machine
> in two countries at the same time, physically :) [corner cases with
> directional antennas excluded]

ACK -- two different type of restrictions, I'm thinking ahead of myself :-P

> > Well I think we can come to a compromise. If we use the strategy above
> > of moving modes to 'vendor_modes' and add a central mode, with the
> > option of letting the driver specify it it wants to use the central
> > modes, we can move any driver slowly at any time to the new API
> > without breaking a single thing.
>
> Aha, but I don't think that strategy can work since there's this
> hw-specific value in the structs. But I already said that above.

Yeap... you're right.

  Luis
