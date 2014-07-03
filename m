Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47049 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964924AbaGCJ6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 05:58:35 -0400
Received: by mail-pd0-f173.google.com with SMTP id r10so13553013pdi.32
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2014 02:58:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140702020442.GP1390@garbanzo.do-not-panic.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-4-git-send-email-arik@wizery.com> <CAB=NE6XTgcMWNHppF7WgZjqGCyaZSOJLF4FUC1hwVyyaBrJ79g@mail.gmail.com>
 <CA+XVXfedV=Frh8UmAzRfgPbOw8nq1Aa-Yr7QSgZTKe8h=bh78Q@mail.gmail.com>
 <20140623182623.GC1390@garbanzo.do-not-panic.com> <CA+XVXffrepXAKitqhL4C87Jxy4MiF+iAO_PP6YZkMKtqeckV+Q@mail.gmail.com>
 <20140623204800.GF1390@garbanzo.do-not-panic.com> <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com> <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com>
 <20140702020442.GP1390@garbanzo.do-not-panic.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 3 Jul 2014 12:58:20 +0300
Message-ID: <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com> (sfid-20140703_115841_844177_24996C4B)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 2, 2014 at 5:04 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Tue, Jul 01, 2014 at 05:03:42PM +0300, Arik Nemtsov wrote:
>> On Tue, Jul 1, 2014 at 1:21 AM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>> >
>> > On Tue, Jun 24, 2014 at 08:55:28AM +0300, Arik Nemtsov wrote:
>> > > On Mon, Jun 23, 2014 at 11:48 PM, Luis R. Rodriguez
>> > > <mcgrof@do-not-panic.com> wrote:
>> > > > On Mon, Jun 23, 2014 at 09:34:13PM +0300, Arik Nemtsov wrote:
>> > > >> On Mon, Jun 23, 2014 at 9:26 PM, Luis R. Rodriguez
>> > > >> <mcgrof@do-not-panic.com> wrote:
>> > > >> > On Mon, Jun 23, 2014 at 08:14:43PM +0300, Arik Nemtsov wrote:
>> > > >> >> On Thu, Jun 19, 2014 at 2:34 AM, Luis R. Rodriguez
>> > > >> >> <mcgrof@do-not-panic.com> wrote:
>> > > >> >> > On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> > > >> >> >> Allow driver and user hints to set the "world" regulatory domain,
>> > > >> >> >
>> > > >> >> > NACK - as expressed in the other patch, letting the drivers to use the
>> > > >> >> > new API to set the world regulatory domain doesn't make sense as we
>> > > >> >> > have custom apply stuff, and the world regulatory domain is not
>> > > >> >> > something dynamic.
>> > > >> >>
>> > > >> >> Well we want to set the world regdomain from FW. This obviously
>> > > >> >> happens after wiphy registration, so I don't think the custom apply
>> > > >> >> can be used here? (since we generally want cfg80211 to own the
>> > > >> >> regdomain settings).
>> > > >> >
>> > > >> > Can the driver not obtain the world regulatory domain from firmware
>> > > >> > prior to wiphy registration? Why not?
>> > > >>
>> > > >> Since the FW is not running yet :)
>> > > >
>> > > > Is that a limitation that can be corrected on the driver ? Can the wiphy
>> > > > registration be moved to after wiphy firmware is loaded ? If this is too
>> > > > hard I see this as a good reason to extend the API or add a new similar
>> > > > call that would allow for this case. The reason for the restriction on wiphy
>> > > > registration was due to the fact that we didn't want to mess with _orig
>> > > > parameters after wiphy registration, and we didn't want drivers poking
>> > > > with those. The _orig parameters then can be set by cfg80211 through two
>> > > > ways, one is the driver say reads EEPROM stuff and sets the channel
>> > > > structs with the restrictions it had prior to wiphy registration or if
>> > > > drivers could deduce a regulatory domain structure they could use the
>> > > > wiphy_apply_custom_regulatory() which would do the same for them.
>> > > >
>> > > > Note that what this does is let drivers fill a set of channel data
>> > > > structures and then with these mechanisms set the max allowed superset.
>> > > > Anything after this is a subset of the original set of allowed
>> > > > parameters. Please review handle_channel().
>> > > >
>> > > > The difficulty in allowing changing the _orig stuff after wiphy
>> > > > registration is we'd then have to ensure that the current state
>> > > > of the regulatory machine is replicated on the device driver. Just
>> > > > consider doing this properly and I think we'll be good.
>> > >
>> > > We can't access the FW before wiphy registration. In some scenarios
>> > > the module is loaded during system boot, before we can really access
>> > > the HW bus. We only start the FW on the first ifup.
>> > > To allow ifup, we need the wiphy registered. We have no "hook" where
>> > > we can register the wiphy after the wifi HW bus if fully available.
>> >
>> > What hw bus? Buses can probe, even if its a fake bus type of thing
>> > you can use platform_device_register_simple(), look at
>> > drivers/net/ethernet/8390/ne.c as a complex example.
>> >
>> > Also if a bus is not yet set up or if resouces are still being
>> > brought up and the driver needs to be poked at a later time you can
>> > verify what you need access for and return -EPROBE_DEFER upon probe
>> > if things can't move forward which will force the driver to be
>> > probed at a later time.
>> >
>> > > Nor do we want to find this hook, because of multiple platforms etc.
>> >
>> > I'm pretty sure you can find it, but I do also understand that
>> > restructuring the driver is a bit of work so I'm fine with you saying
>> > its a lot of work but saying its no possible seems not fully
>> > supported yet.
>>
>> That would be a better choice of words - we don't want to restructure
>> the entire driver over this.
>
> Its a trade off call in the end and so far I can't see a good reason to
> enable dynamic custom world regulatory domains just because the "bus" is
> not available, please do look into using -EPROBE_DEFER. This would
> enable us to only consider the use case of the callback *only* to fetch
> direct alpha2s regulatory domains from the driver/firmware dynamically
> and that should be fairly easy to do. I rather incur a bit of penalty
> over work on your driver than to allow an API for a corner case that has
> not yet been quantitatively evaluated. Folks already complain about the
> complexity on regulatory code, I need to be a hard ass and ensure more
> simplicity one way or another. This is one way.
>
> So again, sorry but NACK.

I'm not sure why you're NACKing this patch for this reason - we're not
really only using this on boot. Basically this is a valid scenario:

1. User removes the SIM from his cellphone.
2. A user hint is sent with alpha2 "99", telling the driver this -
"please reset the regdomain to whatever is default, i have no idea
what this is"
3. The driver/FW replies with a valid alpha2 + regdom settings, where
alpha2 can also be "00".

It just so happens that the above scenario also happens on boot (we
have no idea what's the right alpha2).

Arik
