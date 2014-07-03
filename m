Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46180 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaGCWTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 18:19:06 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so900539pab.30
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2014 15:19:06 -0700 (PDT)
Date: Thu, 3 Jul 2014 15:19:01 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user
 hints
Message-ID: <20140703221901.GS1390@garbanzo.do-not-panic.com> (sfid-20140704_001911_304719_C70F3C8B)
References: <CAB=NE6XTgcMWNHppF7WgZjqGCyaZSOJLF4FUC1hwVyyaBrJ79g@mail.gmail.com>
 <CA+XVXfedV=Frh8UmAzRfgPbOw8nq1Aa-Yr7QSgZTKe8h=bh78Q@mail.gmail.com>
 <20140623182623.GC1390@garbanzo.do-not-panic.com>
 <CA+XVXffrepXAKitqhL4C87Jxy4MiF+iAO_PP6YZkMKtqeckV+Q@mail.gmail.com>
 <20140623204800.GF1390@garbanzo.do-not-panic.com>
 <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com>
 <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com>
 <20140702020442.GP1390@garbanzo.do-not-panic.com>
 <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 03, 2014 at 12:58:20PM +0300, Arik Nemtsov wrote:
> On Wed, Jul 2, 2014 at 5:04 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > On Tue, Jul 01, 2014 at 05:03:42PM +0300, Arik Nemtsov wrote:
> >> On Tue, Jul 1, 2014 at 1:21 AM, Luis R. Rodriguez
> >> <mcgrof@do-not-panic.com> wrote:
> >> >
> >> > On Tue, Jun 24, 2014 at 08:55:28AM +0300, Arik Nemtsov wrote:
> >> > > On Mon, Jun 23, 2014 at 11:48 PM, Luis R. Rodriguez
> >> > > <mcgrof@do-not-panic.com> wrote:
> >> > > > On Mon, Jun 23, 2014 at 09:34:13PM +0300, Arik Nemtsov wrote:
> >> > > >> On Mon, Jun 23, 2014 at 9:26 PM, Luis R. Rodriguez
> >> > > >> <mcgrof@do-not-panic.com> wrote:
> >> > > >> > On Mon, Jun 23, 2014 at 08:14:43PM +0300, Arik Nemtsov wrote:
> >> > > >> >> On Thu, Jun 19, 2014 at 2:34 AM, Luis R. Rodriguez
> >> > > >> >> <mcgrof@do-not-panic.com> wrote:
> >> > > >> >> > On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> >> > > >> >> >> Allow driver and user hints to set the "world" regulatory domain,
> >> > > >> >> >
> >> > > >> >> > NACK - as expressed in the other patch, letting the drivers to use the
> >> > > >> >> > new API to set the world regulatory domain doesn't make sense as we
> >> > > >> >> > have custom apply stuff, and the world regulatory domain is not
> >> > > >> >> > something dynamic.
> >> > > >> >>
> >> > > >> >> Well we want to set the world regdomain from FW. This obviously
> >> > > >> >> happens after wiphy registration, so I don't think the custom apply
> >> > > >> >> can be used here? (since we generally want cfg80211 to own the
> >> > > >> >> regdomain settings).
> >> > > >> >
> >> > > >> > Can the driver not obtain the world regulatory domain from firmware
> >> > > >> > prior to wiphy registration? Why not?
> >> > > >>
> >> > > >> Since the FW is not running yet :)
> >> > > >
> >> > > > Is that a limitation that can be corrected on the driver ? Can the wiphy
> >> > > > registration be moved to after wiphy firmware is loaded ? If this is too
> >> > > > hard I see this as a good reason to extend the API or add a new similar
> >> > > > call that would allow for this case. The reason for the restriction on wiphy
> >> > > > registration was due to the fact that we didn't want to mess with _orig
> >> > > > parameters after wiphy registration, and we didn't want drivers poking
> >> > > > with those. The _orig parameters then can be set by cfg80211 through two
> >> > > > ways, one is the driver say reads EEPROM stuff and sets the channel
> >> > > > structs with the restrictions it had prior to wiphy registration or if
> >> > > > drivers could deduce a regulatory domain structure they could use the
> >> > > > wiphy_apply_custom_regulatory() which would do the same for them.
> >> > > >
> >> > > > Note that what this does is let drivers fill a set of channel data
> >> > > > structures and then with these mechanisms set the max allowed superset.
> >> > > > Anything after this is a subset of the original set of allowed
> >> > > > parameters. Please review handle_channel().
> >> > > >
> >> > > > The difficulty in allowing changing the _orig stuff after wiphy
> >> > > > registration is we'd then have to ensure that the current state
> >> > > > of the regulatory machine is replicated on the device driver. Just
> >> > > > consider doing this properly and I think we'll be good.
> >> > >
> >> > > We can't access the FW before wiphy registration. In some scenarios
> >> > > the module is loaded during system boot, before we can really access
> >> > > the HW bus. We only start the FW on the first ifup.
> >> > > To allow ifup, we need the wiphy registered. We have no "hook" where
> >> > > we can register the wiphy after the wifi HW bus if fully available.
> >> >
> >> > What hw bus? Buses can probe, even if its a fake bus type of thing
> >> > you can use platform_device_register_simple(), look at
> >> > drivers/net/ethernet/8390/ne.c as a complex example.
> >> >
> >> > Also if a bus is not yet set up or if resouces are still being
> >> > brought up and the driver needs to be poked at a later time you can
> >> > verify what you need access for and return -EPROBE_DEFER upon probe
> >> > if things can't move forward which will force the driver to be
> >> > probed at a later time.
> >> >
> >> > > Nor do we want to find this hook, because of multiple platforms etc.
> >> >
> >> > I'm pretty sure you can find it, but I do also understand that
> >> > restructuring the driver is a bit of work so I'm fine with you saying
> >> > its a lot of work but saying its no possible seems not fully
> >> > supported yet.
> >>
> >> That would be a better choice of words - we don't want to restructure
> >> the entire driver over this.
> >
> > Its a trade off call in the end and so far I can't see a good reason to
> > enable dynamic custom world regulatory domains just because the "bus" is
> > not available, please do look into using -EPROBE_DEFER. This would
> > enable us to only consider the use case of the callback *only* to fetch
> > direct alpha2s regulatory domains from the driver/firmware dynamically
> > and that should be fairly easy to do. I rather incur a bit of penalty
> > over work on your driver than to allow an API for a corner case that has
> > not yet been quantitatively evaluated. Folks already complain about the
> > complexity on regulatory code, I need to be a hard ass and ensure more
> > simplicity one way or another. This is one way.
> >
> > So again, sorry but NACK.
> 
> I'm not sure why you're NACKing this patch for this reason - we're not
> really only using this on boot. Basically this is a valid scenario:

Lets start with the 0 case with what I am recommending:

0. The driver calls wiphy_apply_custom_regulatory(), this applies
settings to the channels's data structures before wiphy registration.
The driver then calls wiphy_register(). The regulatory core then uses
the set channel data structures and caches the values upon registration
on the orig_* parameters, the orig_* parameters are to be used only
internally by the core, its used here and as explained below also can
be requested to be updated when REGULATORY_STRICT_REG is used.

> 1. User removes the SIM from his cellphone.

This can implemented to trigger a reset to regulatory, for example we
already call a reset to regulatory when we disconnect from an AP or when
we suspend and resume, this is done since we cannot ensure the
information received earlier will be valid anymore, it also clears all
the heuristics on helping with world roaming like clearly NO-IR (iniatiting
radiation) flags for beacon hints, which would otherwise not enable a
device to intiate radiation if it was world roaming on some channels.
If done this way regulatory restore_custom_reg_settings() will update the
device based on on the orig_* parameters which are values used from the
original registration. Consider it as kind of like resetting the router when
you put the pin in it, things gets wiped out, we start from scratch again.

> 2. A user hint is sent with alpha2 "99", telling the driver this -
> "please reset the regdomain to whatever is default, i have no idea
> what this is"

The reason I am NACK'ing is that you should know the default before
registration, right now you had a bus issue which you can address
as well with -EPROBE_DEFER. I don't want to allow a dynamic custom
world regulatory domain settings as it doesn't make sense yet, there's
no reason for it and we already have APIs to handle this provided you
can fetch that regulatory domain before registration.

The callback for reg_get() to fetch regulatory domain data structures
from firmware is welcomed but only for real country ISO3166-alpha2 country
codes, and I can see that could likely be dynamic.

> 3. The driver/FW replies with a valid alpha2 + regdom settings, where
> alpha2 can also be "00".

Again this would not be needed. Now, if the driver / phone decides it
*does* want to use a new alpha2 (say from cell phone base station a cell
phone is connected to) the proper APIs can be used and passed, and in
fact if the device had used REGULATORY_STRICT_REG a regulatory_hint()
would override the *_orig parameters to ensure that upon reset that
default would be used as well. This would even allow you to use dynamic
override on the orig_* parameters, provided of course you trust the
source, and also that the regulatory hint is for a specific
ISO3166-alpha2.

The devices that would use the REGULATORY_STRICT_REG and
regulatory_hint() today after registration are for example APs. Most 802.11
devices on laptops however use a custom world regulatory domain, and then
techniques are used to help with world roaming such as becon hints, etc. For
some mobile devices however a wiphy_apply_custom_regulatory() can be used
which would set REGULATORY_CUSTOM_REG, and then if they wanted suppport
for cellular base station hints regulatory_hint() from userspace can be
used that will remove REGULATORY_CUSTOM_REG, and the new alpha2 is
trusted.

> It just so happens that the above scenario also happens on boot (we
> have no idea what's the right alpha2).

Upon boot you can should be able to do what you need to do to defer
probing until ready. Let me know if the core does not provide the means
to do this properly, I'd be interested to learn more about that as I'm
sure Greg might be too.

  Luis
