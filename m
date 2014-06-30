Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54471 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaF3WDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 18:03:22 -0400
Received: by mail-pd0-f175.google.com with SMTP id v10so8918299pde.34
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 15:03:21 -0700 (PDT)
Date: Mon, 30 Jun 2014 15:03:16 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/5] cfg80211: allow drivers to provide regulatory
 settings
Message-ID: <20140630220316.GL1390@garbanzo.do-not-panic.com> (sfid-20140701_000327_373365_E62D0825)
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-2-git-send-email-arik@wizery.com>
 <CAB=NE6Wburfgomm81BL-MPsqZSSCSMNyim29OWw3Twj8q2AOUQ@mail.gmail.com>
 <CA+XVXff1SLHvP3PABdV1U2xw8CQW660xJR1QMUkW0QaaEpThYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXff1SLHvP3PABdV1U2xw8CQW660xJR1QMUkW0QaaEpThYQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2014 at 09:37:29AM +0300, Arik Nemtsov wrote:
> On Thu, Jun 19, 2014 at 2:32 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> >> Define a new wiphy callback allowing drivers to provide regulatory
> >> settings.
> >>
> >> Only The first wiphy registered with this callback will be able to provide
> >> regulatory domain info. If such a wiphy exists, it takes precedence over
> >> other data sources.
> >>
> >> Change-Id: If8f8faf1d127120ae464b45098c5edbc5aee3dc0
> >> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> >> Reviewed-on: https://gerrit.rds.intel.com/32858
> >> Tested-by: IWL Jenkins
> >> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> >> ---
> >>  include/net/cfg80211.h | 16 +++++++++++++
> >>  net/wireless/reg.c     | 65 +++++++++++++++++++++++++++++++++++++++++++++-----
> >>  2 files changed, 75 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> >> index 5c17b1f..b8f0269 100644
> >> --- a/include/net/cfg80211.h
> >> +++ b/include/net/cfg80211.h
> >> @@ -2950,6 +2950,19 @@ struct wiphy_vendor_command {
> >>   *     low rssi when a frame is heard on different channel, then it should set
> >>   *     this variable to the maximal offset for which it can compensate.
> >>   *     This value should be set in MHz.
> >> + * @get_regd: a driver callback to for publishing regulatory information.
> >> + *     By implementing this callback, a wiphy indicates it will provide
> >> + *     regulatory information. The callback must be set before the wiphy is
> >> + *     is registered. Only the first wiphy with this callback will be called
> >> + *     to provide a regdomain on country-code changes.
> >
> > The way this is implemented is a bit more exclusive than this kdoc
> > explains -- the way its implemented below allows only a single wiphy
> > *ever* to be registered with this capability. This means that external
> > attachments such as USB 802.11 devices that have this API requirement
> > cannot ensure that they will get this callback issued. What do we want
> > to do about that?
> 
> Well Intel regulatory constraints require us to be the "dictator".

That requirement is in no way in conflict with addressing support
for the get_regd() callback on multiple drivers. Let's separate
a requirement from not having done the required work for a full
patch.

> This feature is also primarily designed for systems which are not
> extensible, so you can't really add another device.
> I guess we'll have to solve this when the need arises.

The patch in question does not address denying wiphy registration
if two drivers have get_regd() implemented, that's essentially what
this *should* be trying to do but:

1) Its not documented above
2) The limitation of the patch in no way is part of matching the
   requirement you mention. That is, the requirement to have Intel's
   driver as "dictator" has nothing to do with allowing or not
   multiple similar drivers that can help with compliance by providing
   their own regulatory dynamically.
3) You are putting the requirement of implmenting support for
   multiple drivers with get_regd() on the next user of get_regd()
   which wants to integrate support for an intel card with theirs,
   that's unfair and far sighted for an implementation.

The requirement you have has nothing to do with the limitation
you have so this patch is unacceptable. I also provided recommendations
on how you can lift this limitation, so it shouldn't be hard.

> > Lets be upfront -- how many regulatory domains will you guys return
> > right now in which the same alpha2 will be kept? I don't like this for
> > one bit at all, if you are going to return a 99 for a specific alpha2
> > it must mean firmware / driver has the ability to search for an alpha2
> > for a set of custom regulatory domains, which should also mean you
> > should be able to return a set of alpha2s that can be used for the
> > custom regulatory domain, so I'd like to see that added as a possible
> > return set. This should set expectations for users, build a better
> > understanding of how all this works, and most importantly enable easy
> > and shorter scraping of the firmware for our own research and
> > development and advancement of wireless-regdb as otherwise we'd have
> > to loop over every alpha2 and then deduce grouping. This is the only
> > way I see this being reasonable to accept upstream.
> 
> I think you're misunderstanding things here. We only give back real
> regulatory domains. The "99" is only used as a means the get the
> currently NVRAM flashed regdomain from FW.

If its real regulatory domains then why is the alpha2 not set?

> We discussed this on the other patch.. Perhaps I should tweak the
> explanation a bit here.

Yes please.

> > We also should be clear now in the documentation about the differences
> > and purpose behind this API and the custom regulatory which tons of
> > folks already use. In this case the requirement was dynamic changes
> > and to ensure these changes get back to userspace permissively as
> > otherwise they could not. The way I see it the custom stuff should be
> > used for custom world regulatory domains -- this new API is for
> > specific alpha2s. This should also mean then that this API should
> > *not* be used to query the firmware for the world regulatory domain.
> 
> Why not? What's problematic here?
> I would much prefer to keep a single API for everything.

Because APIs already exist for some of what you want already. In
particular it seems to me you can implement the alpha2 hint with
the callback by using a capability flag and having the core deal
the callback and then applying the regulatory domain.
Please check but I think you might want alpha2 cases to have handle_channel()
apply the rules on the orig_* parameters which which happens when
REGULATORY_STRICT_REG is set, ie, you may want to require having
set the callback to have REGULATORY_STRICT_REG set. This allows
drivers to enforce the orig_ values reflecting the regulatory
domain data structure. regulatory_hint() also propagates to other drivers
as well and the code also considers the regulatory state for older
types of requests to decide what it should do for each driver and
each case given that we have very different drivers with different
regulatory requirements.

The wiphy_apply_custom_regulatory() is only for custom regulatory
domains, the difference is that wiphy_apply_custom_regulatory() doesn't
take into consideration the regulatory state machine and changes that
have happened over time, it is also specific to only one wiphy. Lastly
it doesn't update orig_* parameters.

For the non alpha2 cases it seems you want a post registration
wiphy_apply_custom_regulatory() type of call which would only apply
to that wiphy, never update orig_* parameters, and consider then also
the regulatory state machine. If you don't care about the regulatory
state machine that makes you special and you must deal with both.

We can't blend the two types of calls because they are very different
in terms of purpose and also the implications on other drivers.
Adding a new API to let custom world regulatory domains or specific
alpha2s would make the other two APIs kind of pointless, we want to
be specific.

> > It also means that the custom flag has to be looked at carefully as
> > well now since the custom flag may need to be lifted dynamically. You
> > may want to look at the Atheros ath module for the different use cases
> > as they ship tons of different types of devices: world roaming, and
> > also cards with a specific alpha2 set. There's a bit of boiler place
> > code there that I saw tons of drivers share / copy so perhaps some
> > boiler plate code might be in order to help here.
> 
> It is already lifted dynamically if a driver regulatory hint arrives.

That indeed that was my point and it seems this was reviewed and considered.
Great.

> > This new API makes only sense for dynamic changes and as such I do
> > expect this to be used for direct alpha2 mappings, not some region
> > stuff. Grouping regulatory domains to groups makes sense to save size
> > -- we've seen this before by other vendors but we should be easily
> > able to get the group alpha2 mapping as well. If Intel is *not* going
> > to contribute to wireless-regdb this at the very least should help us
> > move forward with the public regdb by providing back mapping of all
> > the alpha2s that a regulatory domain passed also applies to.
> 
> The API currently doesn't work this way. I'll ask the regulatory folks
> for a table, but I can't promise anything.

OK.

> >> + *     If an ERR_PTR is returned the regulatory core will consult other
> >> + *     sources for the regdomain info (internal regdb and CRDA).
> >
> > That's nice.
> >
> >> +                                                                                           Returning
> >> + *     NULL will cause the regdomain to remain the same.
> >
> >
> > What do you mean by this? Can you please elaborate exactly what this means?
> 
> It means we will ignore the request. Not sure what's to elaborate.

Why would you do that? Explain why a regulatory hint would be issued
and then the driver could decide to ignore it. Seems kind of pointless
if the driver was the one originally issuing the request!

> >>  static struct regulatory_request core_request_world = {
> >> @@ -129,6 +132,15 @@ static int reg_num_devs_support_basehint;
> >>   */
> >>  static bool reg_is_indoor;
> >>
> >> +/*
> >> + * Wiphy with a get_regd() callback that can provide regulatory information
> >> + * when the country code changes. Only the first wiphy registered with the
> >> + * get_regd callback will be called to provide a regdomain on country-code
> >> + * changes.
> >> + * (protected by RTNL)
> >> + */
> >> +static struct wiphy *regd_info_wiphy;
> >
> > Note all my feedback on the kdoc comment about this. This obviously
> > doesn't scale well but more importantly given that devices bus
> > configuration can change (regardless of what systemd folks think) it
> > means that we can get different results on a system with 2 internal
> > cards. Systems with multiple built in 802.11 cards were something of a
> > theoretical myth back in the day when we started with 802.11 but not
> > anymore. For example I'm very aware of some Freebox 802.11 APs with
> > multiple built in 802.11 cards and from different vendors!  No only
> > can this lead to issues with cards on different buses and races
> > therein, but it could also produce different results on different
> > architectures.
> 
> Agree it's a hairy issue, but I think we should get to this in a later
> patch. It's not a simple issue or "fix".
> Might need different policies, intersections, etc.

Exactly, no address this, otheriwse having an intel driver present would
mean not being able to register other similar type of drivers loaded
on a system. This is unacceptable.

> >>  static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
> >>  {
> >>         return rtnl_dereference(cfg80211_regdomain);
> >> @@ -538,9 +550,39 @@ static int call_crda(const char *alpha2)
> >>         return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, env);
> >>  }
> >>
> >> +static int call_wiphy_regd_info(const char *alpha2)
> >> +{
> >> +       struct ieee80211_regdomain *regd;
> >> +
> >> +       if (!regd_info_wiphy)
> >> +               return -ENOENT;
> >> +
> >> +       /* can happen if the driver removes the callback at runtime */
> >> +       if (WARN_ON(!regd_info_wiphy->get_regd))
> >> +               return -EINVAL;
> >
> > I'd rather see a capability flag for this, that way we can also tell
> > userspace of this ridiculous incarnation of crap on firmware, and when
> > set we'd expect this to be set. If we want to address the dynamic
> > removal / addition of the callback that can be dealt with when the
> > time comes, but that doesn't seem to be required givenou'refe that you
> > added API to let the firmware let cfg80211 pass through and use the
> > wireless-regdb data.
> 
> Sure I'll add a capability flag.

OK.

> >> +
> >> +       regd = regd_info_wiphy->get_regd(regd_info_wiphy, alpha2);
> >> +       if (IS_ERR(regd))
> >> +               return -EIO;
> >> +
> >
> > You're not feeding the firmware information on availability of the
> > userspace regulatory domain, in the case of it was allowed, it seems
> > to me that firmware might make a better decision in the case that
> > userspace lacks information. Userspace can also be upgraded at runtime
> > dynamically so whether or not userspace has a regulatory domain can
> > change at run time. Please consider this.
> 
> The Intel use case doesn't use userspace regulatory information at
> all. This can be extended later I guess.

The "Intel use case" is different than "I'm adding a general API" case.
You can easily extend the API to pass the regulatory domain for
inspection even if you don't use it on the driver.

  Luis
