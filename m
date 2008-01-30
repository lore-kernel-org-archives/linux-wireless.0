Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:50207 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYA3PM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 10:12:57 -0500
Received: by wa-out-1112.google.com with SMTP id v27so427856wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2008 07:12:56 -0800 (PST)
Message-ID: <1ba2fa240801300712x1a1e10r722cf3cf237c6a99@mail.gmail.com> (sfid-20080130_151309_270617_BD57DE9B)
Date: Wed, 30 Jan 2008 17:12:56 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: RFC: unified BSS configuration approach
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"John Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, mb@bu3sch.de, dsd@gentoo.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1201696710.4014.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c85cb4470801270333r618e53a1yf1fdf118d48b93a8@mail.gmail.com>
	 <1201623943.4394.49.camel@johannes.berg>
	 <1ba2fa240801291505p19175a9fj86a50e0d0d8683b0@mail.gmail.com>
	 <1201696710.4014.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 30, 2008 2:38 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > > Hm, true, that could happen. Does it happen in practice though? I can't
> > > see why a low level driver would decide that it should have short
> > > preamble or CTS protection on by default. Maybe we should just document
> > > initial state? Or we can keep the initial call and remove that "don't
> > > call w/o BSS" restriction instead, which seems saner. We should then
> > > probably rename reset_erp_info() to reset_bss_info() though.
> >
> > Yes it happens in practices. I think with short slot.
> > reset_bss_info() sounds good.
>
> Ok so let's rename reset_erp_info() to reset_bss_info() and have it
> handle all the other stuff too.
>
> > > > 1 - change the original intention of bss_info_changed so mac80211 will
> > > > be able to set low-level driver in the "init" or "configure" flows as
> > > > well, not only as BSS is formed or changes
> > > > 2 - maintain original intention, use "bss_info_changed" only when we
> > > > want to deliver BSS configuration when we get associate or during
> > > > association state,  and deliver all initial configuration info through
> > > > different ops
> > >
> > > I prefer the first option since that's essentially just a small
> > > documentation change and it makes sense. We just should make sure that
> > > it's called only when the device is started (through ->start()).
> >
> > what about reset_bss_info() ?
>
> Well reset_bss_info() would still call ->bss_info_changed(), no?

Sounds good so far.

> johannes
>
