Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55026 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaGHCqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 22:46:34 -0400
Received: by mail-pd0-f179.google.com with SMTP id w10so6383584pde.10
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 19:46:33 -0700 (PDT)
Date: Mon, 7 Jul 2014 19:46:28 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user
 hints
Message-ID: <20140708024627.GT1390@garbanzo.do-not-panic.com> (sfid-20140708_044638_629320_40F59A90)
References: <20140623182623.GC1390@garbanzo.do-not-panic.com>
 <CA+XVXffrepXAKitqhL4C87Jxy4MiF+iAO_PP6YZkMKtqeckV+Q@mail.gmail.com>
 <20140623204800.GF1390@garbanzo.do-not-panic.com>
 <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com>
 <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com>
 <20140702020442.GP1390@garbanzo.do-not-panic.com>
 <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
 <20140703221901.GS1390@garbanzo.do-not-panic.com>
 <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 06, 2014 at 10:22:00PM +0300, Arik Nemtsov wrote:
> >
> > Lets start with the 0 case with what I am recommending:
> >
> > 0. The driver calls wiphy_apply_custom_regulatory(), this applies
> > settings to the channels's data structures before wiphy registration.
> > The driver then calls wiphy_register(). The regulatory core then uses
> > the set channel data structures and caches the values upon registration
> > on the orig_* parameters, the orig_* parameters are to be used only
> > internally by the core, its used here and as explained below also can
> > be requested to be updated when REGULATORY_STRICT_REG is used.
> 
> This is not appropriate for the intel use-case. The orig_flags must be
> all 0, since the initial regulatory domain doesn't mean much.

Ok then the central cfg80211 world regulatory domain should be used
in between the time you can fetch the actual regulatory domain you need.
Right now cfg80211 does not let you ask the regulatory code to use the
world regdom to set the _orig parameters upon registration but its
not a bad idea to enable this as a feature. Quite a few drivers have
the practice now to use the apply custom with then own custom world
regdom, using the central one as an option is wise if you know later
some other third party entity will set the *real* regulatory domain.

> It can be changed at any time by usermode (= telephony indication). We
> do not wish to intersect with orig_flags, which always happens AFAICT.

No, that's my point, when you use REGULATORY_STRICT_REG and you issue
a regulatory_hint() with an alpha2 an intersection with _orig* does
not occur, we actually then trust the new regdom fully.

Have you looked into cell base station hints? That's exactly why this
code was added. The name "cell base station hints" is loose but
obviously will vary depending on the vendor / system integrator.
Have your regulatory folks read this FCC KDB 594280 [0] ? Check out
page 14.

[0] https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122

This doesn't mean that because FCC has made a clarification on MCC codes
cannot be used for host compliance that other regulatory bodes will not
allow for it, it also doesn't invalidate our code as well because other
system integrators can use other solutions. For example I'd envision a
really good solution to not only use MCC but a combination of set of
feeds that give userspace a certain amount of certainty on the alpha2
code. This is all documented here:

http://wireless.kernel.org/en/developers/Regulatory/processing_rules#Cellular_base_station_regulatory_hints

Pricicely because system integrators can vary on effort here its why we
enable the CFG80211_CERTIFICATION_ONUS Kconfig option.

> >> 1. User removes the SIM from his cellphone.
> >
> > This can implemented to trigger a reset to regulatory, for example we
> > already call a reset to regulatory when we disconnect from an AP or when
> > we suspend and resume, this is done since we cannot ensure the
> > information received earlier will be valid anymore, it also clears all
> > the heuristics on helping with world roaming like clearly NO-IR (iniatiting
> > radiation) flags for beacon hints, which would otherwise not enable a
> > device to intiate radiation if it was world roaming on some channels.
> > If done this way regulatory restore_custom_reg_settings() will update the
> > device based on on the orig_* parameters which are values used from the
> > original registration. Consider it as kind of like resetting the router when
> > you put the pin in it, things gets wiped out, we start from scratch again.
> 
> While the reset notion is fine, this fails for the normal use case. If
> we set something other then 0 for orig_flags, handle_channel() will
> always "or" with them when switching between regular alpha2 domains
> (e.g. roaming).

There's an exception to this, for example the shared ath module for
Atheros drivers lets drivers that have an alpha2 regulatory domain be
trusted fully on the _orig* parameters.

> >> 2. A user hint is sent with alpha2 "99", telling the driver this -
> >> "please reset the regdomain to whatever is default, i have no idea
> >> what this is"
> >
> > The reason I am NACK'ing is that you should know the default before
> > registration, right now you had a bus issue which you can address
> > as well with -EPROBE_DEFER. I don't want to allow a dynamic custom
> > world regulatory domain settings as it doesn't make sense yet, there's
> > no reason for it and we already have APIs to handle this provided you
> > can fetch that regulatory domain before registration.
> >
> > The callback for reg_get() to fetch regulatory domain data structures
> > from firmware is welcomed but only for real country ISO3166-alpha2 country
> > codes, and I can see that could likely be dynamic.
> 
> I'll wait for you to address the issue above.

OK.

> >> 3. The driver/FW replies with a valid alpha2 + regdom settings, where
> >> alpha2 can also be "00".
> >
> > Again this would not be needed. Now, if the driver / phone decides it
> > *does* want to use a new alpha2 (say from cell phone base station a cell
> > phone is connected to) the proper APIs can be used and passed, and in
> > fact if the device had used REGULATORY_STRICT_REG a regulatory_hint()
> > would override the *_orig parameters to ensure that upon reset that
> > default would be used as well. This would even allow you to use dynamic
> > override on the orig_* parameters, provided of course you trust the
> > source, and also that the regulatory hint is for a specific
> > ISO3166-alpha2.
> 
> REGULATORY_STRICT_REG only sets orig_flags for driver hints, not user
> hints.

Good point, I welcome this as a change, this can for example be a flag
passed as part of the wiphy's regulatory preferences. If the option
CFG80211_REG_CELLULAR_HINTS is enabled then the flag can be looked for
and if present your the core then use the user cell base station hint
to override the _orig* parameters.

> We'll have to identify the wiphy for user-hints etc. I'm also
> very much reluctant to use the STRICT flag. Seems they were engineered
> for specific scenarios/cards, and will generally work well for
> world-roaming cards  that want country IE updates. The CUSTOM
> regulatory flag also has a specific use-case, which doesn't fit intel.
> 
> The simpler use-case of a "regular" card would work well here,
> provided the regulatory settings come from FW.

Let's separate the use cases you wanted to add. One was a fw API which
I'm fine with, the other one was a custom world regdom after wiphy
registration which I am not comfortable with. The fw API is fine but
you seem now to also be explaining some uses cases on regulatory
feeds come from cellular data somehow. Is that the fw use case?
If so the API for CFG80211_REG_CELLULAR_HINTS can be used and extended
very easily for your use case. You can still have a fw API for
regulatory data being provided, but lets be clear that it is different
from the use case of letting the same API add a custom world regulatory
domain.

> > The devices that would use the REGULATORY_STRICT_REG and
> > regulatory_hint() today after registration are for example APs. Most 802.11
> > devices on laptops however use a custom world regulatory domain, and then
> > techniques are used to help with world roaming such as becon hints, etc. For
> > some mobile devices however a wiphy_apply_custom_regulatory() can be used
> > which would set REGULATORY_CUSTOM_REG, and then if they wanted suppport
> > for cellular base station hints regulatory_hint() from userspace can be
> > used that will remove REGULATORY_CUSTOM_REG, and the new alpha2 is
> > trusted.
> 
> But then the ability to restore the orig flag is lost.. since we can't
> restore the CUSTOM flag. And again, removing the flag requires a
> driver hint, not a user one.
> Like I said, the scenarios are pretty specific.

Evolutions are welcomed to the CFG80211_REG_CELLULAR_HINTS use case for
drivers that want to trust them.

> >> It just so happens that the above scenario also happens on boot (we
> >> have no idea what's the right alpha2).
> >
> > Upon boot you can should be able to do what you need to do to defer
> > probing until ready. Let me know if the core does not provide the means
> > to do this properly, I'd be interested to learn more about that as I'm
> > sure Greg might be too.
> 
> I haven't explored the technical aspects here, but I'll give you the
> gist of it. Right now we register the wiphy on boot, but load the fw
> on the first "ifup".

Why?

> This ifup can come from some external component
> (maybe Android framework?) that knows the entire system state (i.e.
> FS, bus, rfkill, etc), and can ensure everything will work out OK. Now
> there different HW platforms here, different software framework
> (Android, ChromeOS, etc) and different bus types we support.

OK, it still doesn't explain why you would load the firmware on the
first ifup rather than bootup.

> You're basically asking for us to find a "hook" in each configuration
> in which we can load the FW during the wiphy registration, just before
> ifup arrives (but not after - since ifup will fail without a wiphy).

No I'm asking you for clarification on why you can't load fw early
and why deferred probe does not suffice. You *found* your hook on
ifup, why can you do it on ifup and not a deffered probe? Seems a
bit odd.

The goal here is to see if there is something that we need more general
for not only you but for others on the driver core.

> The "hook" depends on the entire system state, not only kernel. It
> will likely be hard or impossible to do right is some situations. It's
> akin to shooting ourselves in the foot. :)

But "ifup" was the magic bullet for some reason, seems odd how that
worked out well but we can't generalize something here.

> Therefore I would be glad if you reconsider a dynamic initial
> regulatory domain.

The excercise of line of questioning has revealed already quite a bit of
details on existing APIs which you can or cannot use, and will help
simplify code. If APIs already exist for things I rather avoid them, the
goal here is to ensure that some other solution does not exist before
allowing something new in blindly.

  Luis
