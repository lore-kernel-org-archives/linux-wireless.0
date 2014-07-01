Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65114 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaGAOD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 10:03:58 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so10581972pac.5
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2014 07:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140630222132.GN1390@garbanzo.do-not-panic.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-4-git-send-email-arik@wizery.com> <CAB=NE6XTgcMWNHppF7WgZjqGCyaZSOJLF4FUC1hwVyyaBrJ79g@mail.gmail.com>
 <CA+XVXfedV=Frh8UmAzRfgPbOw8nq1Aa-Yr7QSgZTKe8h=bh78Q@mail.gmail.com>
 <20140623182623.GC1390@garbanzo.do-not-panic.com> <CA+XVXffrepXAKitqhL4C87Jxy4MiF+iAO_PP6YZkMKtqeckV+Q@mail.gmail.com>
 <20140623204800.GF1390@garbanzo.do-not-panic.com> <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 1 Jul 2014 17:03:42 +0300
Message-ID: <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com> (sfid-20140701_160402_111693_63F981FF)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 1, 2014 at 1:21 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
>
> On Tue, Jun 24, 2014 at 08:55:28AM +0300, Arik Nemtsov wrote:
> > On Mon, Jun 23, 2014 at 11:48 PM, Luis R. Rodriguez
> > <mcgrof@do-not-panic.com> wrote:
> > > On Mon, Jun 23, 2014 at 09:34:13PM +0300, Arik Nemtsov wrote:
> > >> On Mon, Jun 23, 2014 at 9:26 PM, Luis R. Rodriguez
> > >> <mcgrof@do-not-panic.com> wrote:
> > >> > On Mon, Jun 23, 2014 at 08:14:43PM +0300, Arik Nemtsov wrote:
> > >> >> On Thu, Jun 19, 2014 at 2:34 AM, Luis R. Rodriguez
> > >> >> <mcgrof@do-not-panic.com> wrote:
> > >> >> > On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> > >> >> >> Allow driver and user hints to set the "world" regulatory domain,
> > >> >> >
> > >> >> > NACK - as expressed in the other patch, letting the drivers to use the
> > >> >> > new API to set the world regulatory domain doesn't make sense as we
> > >> >> > have custom apply stuff, and the world regulatory domain is not
> > >> >> > something dynamic.
> > >> >>
> > >> >> Well we want to set the world regdomain from FW. This obviously
> > >> >> happens after wiphy registration, so I don't think the custom apply
> > >> >> can be used here? (since we generally want cfg80211 to own the
> > >> >> regdomain settings).
> > >> >
> > >> > Can the driver not obtain the world regulatory domain from firmware
> > >> > prior to wiphy registration? Why not?
> > >>
> > >> Since the FW is not running yet :)
> > >
> > > Is that a limitation that can be corrected on the driver ? Can the wiphy
> > > registration be moved to after wiphy firmware is loaded ? If this is too
> > > hard I see this as a good reason to extend the API or add a new similar
> > > call that would allow for this case. The reason for the restriction on wiphy
> > > registration was due to the fact that we didn't want to mess with _orig
> > > parameters after wiphy registration, and we didn't want drivers poking
> > > with those. The _orig parameters then can be set by cfg80211 through two
> > > ways, one is the driver say reads EEPROM stuff and sets the channel
> > > structs with the restrictions it had prior to wiphy registration or if
> > > drivers could deduce a regulatory domain structure they could use the
> > > wiphy_apply_custom_regulatory() which would do the same for them.
> > >
> > > Note that what this does is let drivers fill a set of channel data
> > > structures and then with these mechanisms set the max allowed superset.
> > > Anything after this is a subset of the original set of allowed
> > > parameters. Please review handle_channel().
> > >
> > > The difficulty in allowing changing the _orig stuff after wiphy
> > > registration is we'd then have to ensure that the current state
> > > of the regulatory machine is replicated on the device driver. Just
> > > consider doing this properly and I think we'll be good.
> >
> > We can't access the FW before wiphy registration. In some scenarios
> > the module is loaded during system boot, before we can really access
> > the HW bus. We only start the FW on the first ifup.
> > To allow ifup, we need the wiphy registered. We have no "hook" where
> > we can register the wiphy after the wifi HW bus if fully available.
>
> What hw bus? Buses can probe, even if its a fake bus type of thing
> you can use platform_device_register_simple(), look at
> drivers/net/ethernet/8390/ne.c as a complex example.
>
> Also if a bus is not yet set up or if resouces are still being
> brought up and the driver needs to be poked at a later time you can
> verify what you need access for and return -EPROBE_DEFER upon probe
> if things can't move forward which will force the driver to be
> probed at a later time.
>
> > Nor do we want to find this hook, because of multiple platforms etc.
>
> I'm pretty sure you can find it, but I do also understand that
> restructuring the driver is a bit of work so I'm fine with you saying
> its a lot of work but saying its no possible seems not fully
> supported yet.

That would be a better choice of words - we don't want to restructure
the entire driver over this.

>
> > But I'm not sure why you're mentioning the workings of
> > handle_channel() for this patch. It doesn't allow changing the
> > original flags set at registration. It just allows drivers and the
> > user to assign the world regdomain, and also to change the native "00"
> > definitions with the FW regdomain. It shouldn't harm anything AFAICT.
>
> You're missing the point for why I bring up handle_channel().
> handle_channel() *can* update orig_* parameters for you for an alpha2
> which you *shoud* consider. Additionally handle_channel() takes into
> consideration the regulatory state machine and can apply a regulatory
> domain to different wiphys by design to help with compliance. The
> handle_channel_custom() is designed for custom regulatory domains
> and do not propagate to other wiphys.

AFAICT, orig_flags only change if:

if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
   request_wiphy && request_wiphy == wiphy &&
   request_wiphy->regulatory_flags & REGULATORY_STRICT_REG) {

We don't use REGULATORY_STRICT_REG, nor is the use-case "faking" our
alpha2. The real alpha2 is used to narrow down the channel defs via
the flags parameter. This patch just allows the FW to provide the
definitions for the "00" regdomain via the get_regd() function.


>
> > >> > One thing to be careful on all this new API design is to ensure that
> > >> > upon disconnect we want the driver to go back to the original state,
> > >> > whatever that is.
> > >>
> > >> This particular part is unrelated to connection state AFAICT. It just
> > >> allows someone (driver, user) to set the "00" regdomain.
> > >
> > > There are two things here, one is the custom world regulatory domain
> > > that firmware is setting, the other is the new API to allow an alpha2
> > > regulatory domain. The resetting of regulatory domains needs to ensure
> > > that if the first regulatory domain was a world regulatory domain, and
> > > then a driver alpha2 is set these regulatory domains will be applied in
> > > the same order when it disconnects. If the APIs are used properly this
> > > is guaranteed already for us and its one reason for seeing if we can
> > > just use existing APIs. See restore_custom_reg_settings() as an example.
> >
> > I believe there's no issue introduced by this code.
>
> You are extending usage of custom regulatory data to be hooked onto the
> orig_* parameters, which by design was made to help upkeep the minimum
> allowed set, the custom regulatory domain allows for *world roaming*
> which can mean reducing this set, but note it will never *enable* new
> channels. The alpha2 hint *can* enable new channels by design by
> updating orig_* parameters. These are two different type of regulatory
> domain hints.

See comment above.

Arik
