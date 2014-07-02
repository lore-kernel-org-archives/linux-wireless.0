Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63517 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaGBCX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 22:23:56 -0400
Received: by mail-pd0-f173.google.com with SMTP id r10so11085959pdi.4
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2014 19:23:55 -0700 (PDT)
Date: Tue, 1 Jul 2014 19:23:51 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/5] cfg80211: allow drivers to provide regulatory
 settings
Message-ID: <20140702022351.GQ1390@garbanzo.do-not-panic.com> (sfid-20140702_042401_795334_7D886F1D)
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-2-git-send-email-arik@wizery.com>
 <CAB=NE6Wburfgomm81BL-MPsqZSSCSMNyim29OWw3Twj8q2AOUQ@mail.gmail.com>
 <CA+XVXff1SLHvP3PABdV1U2xw8CQW660xJR1QMUkW0QaaEpThYQ@mail.gmail.com>
 <20140630220316.GL1390@garbanzo.do-not-panic.com>
 <CA+XVXfcteEgTJ-QQ9q4KuqbPoygKCpccjwR2EdqX-aSHScRo4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfcteEgTJ-QQ9q4KuqbPoygKCpccjwR2EdqX-aSHScRo4g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 01, 2014 at 04:07:03PM +0300, Arik Nemtsov wrote:
> On Tue, Jul 1, 2014 at 1:03 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> >> This feature is also primarily designed for systems which are not
> >> extensible, so you can't really add another device.
> >> I guess we'll have to solve this when the need arises.
> >
> > The patch in question does not address denying wiphy registration
> > if two drivers have get_regd() implemented, that's essentially what
> > this *should* be trying to do but:
> >
> > 1) Its not documented above
> > 2) The limitation of the patch in no way is part of matching the
> >    requirement you mention. That is, the requirement to have Intel's
> >    driver as "dictator" has nothing to do with allowing or not
> >    multiple similar drivers that can help with compliance by providing
> >    their own regulatory dynamically.
> > 3) You are putting the requirement of implmenting support for
> >    multiple drivers with get_regd() on the next user of get_regd()
> >    which wants to integrate support for an intel card with theirs,
> >    that's unfair and far sighted for an implementation.
> >
> > The requirement you have has nothing to do with the limitation
> > you have so this patch is unacceptable. I also provided recommendations
> > on how you can lift this limitation, so it shouldn't be hard.
> 
> I already prevent the registration of a second "get_regd" callback. I
> just re-read your previous email and I'm not sure what's the
> recommendation here. The 2-card scenario where one of the cards
> doesn't use "get_regd" should be fine - it will just use the
> regulatory settings from the "get_regd" one. Only the
> 2-cards-using-"get_regd" scenario is not supported, and AFAICT it
> doesn't exist in practice, and also requires complicated treatment
> (perhaps the two "dictators" differ in their definition of the
> regdomains?)

The recommendation is to add support for more than one driver
that has the get_regd() callback, if your driver does not want
to allow others to register more than 1 driver on a system with
the reg_regd() callback add a flag and then the blame will be
put on you to justify this. Then customers who buy your products
won't use your devices in undesired combinations and I expect
tons of bug reports might end up being filed if another vendor
ends up going down the get_regd() path.

> >> > Lets be upfront -- how many regulatory domains will you guys return
> >> > right now in which the same alpha2 will be kept? I don't like this for
> >> > one bit at all, if you are going to return a 99 for a specific alpha2
> >> > it must mean firmware / driver has the ability to search for an alpha2
> >> > for a set of custom regulatory domains, which should also mean you
> >> > should be able to return a set of alpha2s that can be used for the
> >> > custom regulatory domain, so I'd like to see that added as a possible
> >> > return set. This should set expectations for users, build a better
> >> > understanding of how all this works, and most importantly enable easy
> >> > and shorter scraping of the firmware for our own research and
> >> > development and advancement of wireless-regdb as otherwise we'd have
> >> > to loop over every alpha2 and then deduce grouping. This is the only
> >> > way I see this being reasonable to accept upstream.
> >>
> >> I think you're misunderstanding things here. We only give back real
> >> regulatory domains. The "99" is only used as a means the get the
> >> currently NVRAM flashed regdomain from FW.
> >
> > If its real regulatory domains then why is the alpha2 not set?
> 
> We call get_regd with "99", expecting the driver/FW to reply with the
> current alpha2 as burned in ROM/FW.

Ah! OK then yes I was misunderstanding the use case here. If you change
the driver to load the firmware before registration though you can
then instead use regulatory_hint() properly here.

> >> > We also should be clear now in the documentation about the differences
> >> > and purpose behind this API and the custom regulatory which tons of
> >> > folks already use. In this case the requirement was dynamic changes
> >> > and to ensure these changes get back to userspace permissively as
> >> > otherwise they could not. The way I see it the custom stuff should be
> >> > used for custom world regulatory domains -- this new API is for
> >> > specific alpha2s. This should also mean then that this API should
> >> > *not* be used to query the firmware for the world regulatory domain.
> >>
> >> Why not? What's problematic here?
> >> I would much prefer to keep a single API for everything.

You are adding new API for a driver work around. The regulatory code
is already complex as is, adding support for dynamic custom world
regulatory hints is something I'd like to avoid if we can.

> > Because APIs already exist for some of what you want already. In
> > particular it seems to me you can implement the alpha2 hint with
> > the callback by using a capability flag and having the core deal
> > the callback and then applying the regulatory domain.
> > Please check but I think you might want alpha2 cases to have handle_channel()
> > apply the rules on the orig_* parameters which which happens when
> > REGULATORY_STRICT_REG is set, ie, you may want to require having
> > set the callback to have REGULATORY_STRICT_REG set. This allows
> > drivers to enforce the orig_ values reflecting the regulatory
> > domain data structure. regulatory_hint() also propagates to other drivers
> > as well and the code also considers the regulatory state for older
> > types of requests to decide what it should do for each driver and
> > each case given that we have very different drivers with different
> > regulatory requirements.
> >
> > The wiphy_apply_custom_regulatory() is only for custom regulatory
> > domains, the difference is that wiphy_apply_custom_regulatory() doesn't
> > take into consideration the regulatory state machine and changes that
> > have happened over time, it is also specific to only one wiphy. Lastly
> > it doesn't update orig_* parameters.
> >
> > For the non alpha2 cases it seems you want a post registration
> > wiphy_apply_custom_regulatory() type of call which would only apply
> > to that wiphy, never update orig_* parameters, and consider then also
> > the regulatory state machine. If you don't care about the regulatory
> > state machine that makes you special and you must deal with both.
> >
> > We can't blend the two types of calls because they are very different
> > in terms of purpose and also the implications on other drivers.
> > Adding a new API to let custom world regulatory domains or specific
> > alpha2s would make the other two APIs kind of pointless, we want to
> > be specific.
> 
> I don't want to touch orig_flags, since the FW burned regdomain can be
> overridden. I do want to register the wiphy very early, before the FW
> is loaded. Also I want to get the default alpha2 and associated
> regdomain from the FW at runtime. Don't think any combination of the
> current APIs allows that.

You are right but you seem to be adding a lot of API / code for
something the driver can instead be changed with -EPROBE_DEFER and
then use proper APIs for. The only thing then you'd need to add is
new API to let the driver's regulatory domain be sent out from
firmware, as a source and that it seems you can easily add with
the capability flag and the get_regd() callback.

> I can prepare a separate API call just for the purpose of getting the
> initial alpha2+regdomain setting, but I have to say it seems pretty
> pointless. The current flow where we send "99" and get the real alpha2
> works well.

Working well is different then scaling for all 802.11 vendors on the
Linux kernel, part of my job is to push you to consider helping us
write APIs that help things to be cleaner. If some functionality is
missing as part of the core that doesn't let us do something we
extend it.

> >> >> +                                                                                           Returning
> >> >> + *     NULL will cause the regdomain to remain the same.
> >> >
> >> >
> >> > What do you mean by this? Can you please elaborate exactly what this means?
> >>
> >> It means we will ignore the request. Not sure what's to elaborate.
> >
> > Why would you do that? Explain why a regulatory hint would be issued
> > and then the driver could decide to ignore it. Seems kind of pointless
> > if the driver was the one originally issuing the request!
> 
> The driver isn't the only one that can issue requests. Userspace can
> issue them too (and in fact does). Basically the driver/FW can say
> "leave the same regdomain, don't touch it".
> It's a policy decision.

Sure, but why would the driver send a request to the core only to then
say things are OK and don't do anything. Seems rather pointless.

> >> >>  static struct regulatory_request core_request_world = {
> >> >> @@ -129,6 +132,15 @@ static int reg_num_devs_support_basehint;
> >> >>   */
> >> >>  static bool reg_is_indoor;
> >> >>
> >> >> +/*
> >> >> + * Wiphy with a get_regd() callback that can provide regulatory information
> >> >> + * when the country code changes. Only the first wiphy registered with the
> >> >> + * get_regd callback will be called to provide a regdomain on country-code
> >> >> + * changes.
> >> >> + * (protected by RTNL)
> >> >> + */
> >> >> +static struct wiphy *regd_info_wiphy;
> >> >
> >> > Note all my feedback on the kdoc comment about this. This obviously
> >> > doesn't scale well but more importantly given that devices bus
> >> > configuration can change (regardless of what systemd folks think) it
> >> > means that we can get different results on a system with 2 internal
> >> > cards. Systems with multiple built in 802.11 cards were something of a
> >> > theoretical myth back in the day when we started with 802.11 but not
> >> > anymore. For example I'm very aware of some Freebox 802.11 APs with
> >> > multiple built in 802.11 cards and from different vendors!  No only
> >> > can this lead to issues with cards on different buses and races
> >> > therein, but it could also produce different results on different
> >> > architectures.
> >>
> >> Agree it's a hairy issue, but I think we should get to this in a later
> >> patch. It's not a simple issue or "fix".
> >> Might need different policies, intersections, etc.
> >
> > Exactly, no address this, otheriwse having an intel driver present would
> > mean not being able to register other similar type of drivers loaded
> > on a system. This is unacceptable.
> 
> I agree it will prevent other "get_regd" cards from registering on the
> same system, but I don't think the limitation really exists in
> practice.

It does't matter, you can't assume your restrictions are universal.

> These are not Intel cards one can buy off the shelf. They are soldered
> to platforms that are non-extensible. It also means I have no ability
> to test this code.

Make a capability thing or requirement flag somewhere and have it be
stuck to your driver, don't make it universal.

> >> >> +
> >> >> +       regd = regd_info_wiphy->get_regd(regd_info_wiphy, alpha2);
> >> >> +       if (IS_ERR(regd))
> >> >> +               return -EIO;
> >> >> +
> >> >
> >> > You're not feeding the firmware information on availability of the
> >> > userspace regulatory domain, in the case of it was allowed, it seems
> >> > to me that firmware might make a better decision in the case that
> >> > userspace lacks information. Userspace can also be upgraded at runtime
> >> > dynamically so whether or not userspace has a regulatory domain can
> >> > change at run time. Please consider this.
> >>
> >> The Intel use case doesn't use userspace regulatory information at
> >> all. This can be extended later I guess.
> >
> > The "Intel use case" is different than "I'm adding a general API" case.
> > You can easily extend the API to pass the regulatory domain for
> > inspection even if you don't use it on the driver.
> 
> Perhaps this shouldn't be part of this feature? It's of no use to the
> driver or to the user of the system. If someone wants to use userspace
> information, they should extend the APIs IMHO.

Sure.. I can just ensure this likely will get extended soon.

  Luis
