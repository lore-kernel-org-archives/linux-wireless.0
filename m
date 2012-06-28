Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:34528 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751292Ab2F1VJi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 17:09:38 -0400
Message-ID: <1340917777.4581.2.camel@joe2Laptop> (sfid-20120628_231004_005490_CBF1CF50)
Subject: Re: [PATCH option A] bcma: use custom printing functions
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Date: Thu, 28 Jun 2012 14:09:37 -0700
In-Reply-To: <CACna6rwV3Cffm0nG_kHmE8ZO9oHOqSpfSysd9H1pgAHK71iLFQ@mail.gmail.com>
References: <1340912688-3089-1-git-send-email-zajec5@gmail.com>
	 <1340912894.5257.0.camel@jlt3.sipsolutions.net>
	 <CACna6rwXrspQ_PDfwZbL7jk=hZ6EmhCnebLcp82LaC4T-Khscw@mail.gmail.com>
	 <1340913949.2602.27.camel@joe2Laptop>
	 <CACna6rwV3Cffm0nG_kHmE8ZO9oHOqSpfSysd9H1pgAHK71iLFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 22:18 +0200, Rafał Miłecki wrote:
> 2012/6/28 Joe Perches <joe@perches.com>:
> > On Thu, 2012-06-28 at 21:56 +0200, Rafał Miłecki wrote:
> >> 2012/6/28 Johannes Berg <johannes@sipsolutions.net>:
> >> > On Thu, 2012-06-28 at 21:44 +0200, Rafał Miłecki wrote:
> >> >
> >> >> +#define bcma_err(fmt, ...) \
> >> >> +     pr_err(KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)
> >> >
> >> > both of your options seem to rely on "bus" being a variable in the
> >> > context, is that really a good idea?
> >>
> >> Yeah, I made that assumption to make calls nicer & shorter. We may
> >> need to get reference to "bus" in function or two.
> >>
> >> I saw such a solution in "radeon" gpu driver, example:
> >> value = RREG32(R600_AUDIO_STATUS_BITS);
> >> (they assume "rdev" is available in every function calling RREG32).
> >
> > I think that radeon use is ugly myself.
> >
> >> If you believe it's ugly, I can change that. I also wonder what Joe
> >> will respond.
> >>
> >> P.S.
> >> Both patches are not signed yet and they are supposed to be RFC. Sorry
> >> for missing that in subject line.
> >
> > I think it'd be better to add and use:
> >
> > #define bcma_bus_err(bus, fmt, ...)                             \
> >        pr_err("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
> >
> > #define bcma_bus_info(bus, fmt, ...)                            \
> >        pr_info("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
> >
> > or some other equivalent use if you're wedded
> > to wanting "bcma-%d:" prefixed output.
> >
> > I'd rather have the prefix be something like "bcma: <bus#>: ",
> > so a dmesg grep pattern can be "^bcma:" but hey, it ain't my code.
> 
> OK, thanks for your opinion. Just to be sure, did you mean:
> bcma: bus0: FOO BAR
> or
> bcma: <bus0>: FOO BAR
> ?
> 
> Personally I don't really care, but maybe there is already similar
> case in some other driver you know about? It could be nice to be
> consistent across the kernel.

There's no real consistency in prefixes.

Most of the cases I've seen have used either something like
"prefix: (#): " or "prefix-#:"

cheers, Joe

