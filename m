Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:34247 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbYA2XFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 18:05:25 -0500
Received: by wa-out-1112.google.com with SMTP id v27so4632wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2008 15:05:24 -0800 (PST)
Message-ID: <1ba2fa240801291505p19175a9fj86a50e0d0d8683b0@mail.gmail.com> (sfid-20080129_230532_634508_4EC8B19B)
Date: Wed, 30 Jan 2008 01:05:24 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: RFC: unified BSS configuration approach
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"John Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, mb@bu3sch.de, dsd@gentoo.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1201623943.4394.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c85cb4470801270333r618e53a1yf1fdf118d48b93a8@mail.gmail.com>
	 <1201623943.4394.49.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > B) If we decide to skip this initial sync problems may occur, as
> > initial status of mac80211 and low-level driver may be different.
>
> Hm, true, that could happen. Does it happen in practice though? I can't
> see why a low level driver would decide that it should have short
> preamble or CTS protection on by default. Maybe we should just document
> initial state? Or we can keep the initial call and remove that "don't
> call w/o BSS" restriction instead, which seems saner. We should then
> probably rename reset_erp_info() to reset_bss_info() though.

Yes it happens in practices. I think with short slot.
reset_bss_info() sounds good.

> > C) yet, there is no need to make changes from beacons when we are not
> > associated, as our association may influence the beacons.
>
> Huh, yes, do we do that though? I didn't think we did. Well, we do in
> one way, we set our initial status to whatever we "predict" the settings
> will be when we join the BSS, if that changes we follow all changes. Are
> there any problems with that?
>

We better don't predict, you get beacon or probe response and initiate
association with what is there.

Whit assoc==true all the parameters should be sent to driver at once.

> > D) also, configuration should not be applied to low-level driver while
> > scanning as well, even though beacons/probe responses are inspected.
>
> Hm, good point. But we don't really react to things in other BSSes so
> does it really matter whether we're scanning or not while receiving a
> beacon from our own BSS?
>

Either mac80211 or driver have to be aware that there is scanning and
not changing parameters. during that stage. I will get your own BSS
beacons with the relevant information after scanning so no caching is
needed. Need to be careful though about 11h quite period and channel
switch.

> > E) support to user space configuration is needed, e.g. AP mode
> > (although here we may use the fact that AP mode is always in a kind of
> > "associated" mode)
>
> Yup, so far it's required only in AP mode, is there anything that will
> need this when not in AP mode?

Preamble is usually user configurable feature..

> > 1 - change the original intention of bss_info_changed so mac80211 will
> > be able to set low-level driver in the "init" or "configure" flows as
> > well, not only as BSS is formed or changes
> > 2 - maintain original intention, use "bss_info_changed" only when we
> > want to deliver BSS configuration when we get associate or during
> > association state,  and deliver all initial configuration info through
> > different ops
>
> I prefer the first option since that's essentially just a small
> documentation change and it makes sense. We just should make sure that
> it's called only when the device is started (through ->start()).

what about reset_bss_info() ?

Thanks
Tomas

> johannes
>
