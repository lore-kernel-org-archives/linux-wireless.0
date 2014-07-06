Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45130 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaGFTWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 15:22:16 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so4255754pab.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 12:22:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140703221901.GS1390@garbanzo.do-not-panic.com>
References: <CAB=NE6XTgcMWNHppF7WgZjqGCyaZSOJLF4FUC1hwVyyaBrJ79g@mail.gmail.com>
 <CA+XVXfedV=Frh8UmAzRfgPbOw8nq1Aa-Yr7QSgZTKe8h=bh78Q@mail.gmail.com>
 <20140623182623.GC1390@garbanzo.do-not-panic.com> <CA+XVXffrepXAKitqhL4C87Jxy4MiF+iAO_PP6YZkMKtqeckV+Q@mail.gmail.com>
 <20140623204800.GF1390@garbanzo.do-not-panic.com> <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com> <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com>
 <20140702020442.GP1390@garbanzo.do-not-panic.com> <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
 <20140703221901.GS1390@garbanzo.do-not-panic.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 6 Jul 2014 22:22:00 +0300
Message-ID: <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com> (sfid-20140706_212339_894322_FC867F8F)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Lets start with the 0 case with what I am recommending:
>
> 0. The driver calls wiphy_apply_custom_regulatory(), this applies
> settings to the channels's data structures before wiphy registration.
> The driver then calls wiphy_register(). The regulatory core then uses
> the set channel data structures and caches the values upon registration
> on the orig_* parameters, the orig_* parameters are to be used only
> internally by the core, its used here and as explained below also can
> be requested to be updated when REGULATORY_STRICT_REG is used.

This is not appropriate for the intel use-case. The orig_flags must be
all 0, since the initial regulatory domain doesn't mean much.
It can be changed at any time by usermode (= telephony indication). We
do not wish to intersect with orig_flags, which always happens AFAICT.

>
>> 1. User removes the SIM from his cellphone.
>
> This can implemented to trigger a reset to regulatory, for example we
> already call a reset to regulatory when we disconnect from an AP or when
> we suspend and resume, this is done since we cannot ensure the
> information received earlier will be valid anymore, it also clears all
> the heuristics on helping with world roaming like clearly NO-IR (iniatiting
> radiation) flags for beacon hints, which would otherwise not enable a
> device to intiate radiation if it was world roaming on some channels.
> If done this way regulatory restore_custom_reg_settings() will update the
> device based on on the orig_* parameters which are values used from the
> original registration. Consider it as kind of like resetting the router when
> you put the pin in it, things gets wiped out, we start from scratch again.

While the reset notion is fine, this fails for the normal use case. If
we set something other then 0 for orig_flags, handle_channel() will
always "or" with them when switching between regular alpha2 domains
(e.g. roaming).

>
>> 2. A user hint is sent with alpha2 "99", telling the driver this -
>> "please reset the regdomain to whatever is default, i have no idea
>> what this is"
>
> The reason I am NACK'ing is that you should know the default before
> registration, right now you had a bus issue which you can address
> as well with -EPROBE_DEFER. I don't want to allow a dynamic custom
> world regulatory domain settings as it doesn't make sense yet, there's
> no reason for it and we already have APIs to handle this provided you
> can fetch that regulatory domain before registration.
>
> The callback for reg_get() to fetch regulatory domain data structures
> from firmware is welcomed but only for real country ISO3166-alpha2 country
> codes, and I can see that could likely be dynamic.

I'll wait for you to address the issue above.

>
>> 3. The driver/FW replies with a valid alpha2 + regdom settings, where
>> alpha2 can also be "00".
>
> Again this would not be needed. Now, if the driver / phone decides it
> *does* want to use a new alpha2 (say from cell phone base station a cell
> phone is connected to) the proper APIs can be used and passed, and in
> fact if the device had used REGULATORY_STRICT_REG a regulatory_hint()
> would override the *_orig parameters to ensure that upon reset that
> default would be used as well. This would even allow you to use dynamic
> override on the orig_* parameters, provided of course you trust the
> source, and also that the regulatory hint is for a specific
> ISO3166-alpha2.

REGULATORY_STRICT_REG only sets orig_flags for driver hints, not user
hints. We'll have to identify the wiphy for user-hints etc. I'm also
very much reluctant to use the STRICT flag. Seems they were engineered
for specific scenarios/cards, and will generally work well for
world-roaming cards that want country IE updates. The CUSTOM
regulatory flag also has a specific use-case, which doesn't fit intel.

The simpler use-case of a "regular" card would work well here,
provided the regulatory settings come from FW.

>
> The devices that would use the REGULATORY_STRICT_REG and
> regulatory_hint() today after registration are for example APs. Most 802.11
> devices on laptops however use a custom world regulatory domain, and then
> techniques are used to help with world roaming such as becon hints, etc. For
> some mobile devices however a wiphy_apply_custom_regulatory() can be used
> which would set REGULATORY_CUSTOM_REG, and then if they wanted suppport
> for cellular base station hints regulatory_hint() from userspace can be
> used that will remove REGULATORY_CUSTOM_REG, and the new alpha2 is
> trusted.

But then the ability to restore the orig flag is lost.. since we can't
restore the CUSTOM flag. And again, removing the flag requires a
driver hint, not a user one.
Like I said, the scenarios are pretty specific.

>
>> It just so happens that the above scenario also happens on boot (we
>> have no idea what's the right alpha2).
>
> Upon boot you can should be able to do what you need to do to defer
> probing until ready. Let me know if the core does not provide the means
> to do this properly, I'd be interested to learn more about that as I'm
> sure Greg might be too.

I haven't explored the technical aspects here, but I'll give you the
gist of it. Right now we register the wiphy on boot, but load the fw
on the first "ifup". This ifup can come from some external component
(maybe Android framework?) that knows the entire system state (i.e.
FS, bus, rfkill, etc), and can ensure everything will work out OK. Now
there different HW platforms here, different software framework
(Android, ChromeOS, etc) and different bus types we support.

You're basically asking for us to find a "hook" in each configuration
in which we can load the FW during the wiphy registration, just before
ifup arrives (but not after - since ifup will fail without a wiphy).
The "hook" depends on the entire system state, not only kernel. It
will likely be hard or impossible to do right is some situations. It's
akin to shooting ourselves in the foot. :)

Therefore I would be glad if you reconsider a dynamic initial regulatory domain.

Regards,
Arik
