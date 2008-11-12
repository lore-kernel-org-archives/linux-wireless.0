Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40906 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444AbYKLXj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 18:39:58 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 15:39:58 -0800
Date: Wed, 12 Nov 2008 15:39:56 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Dan Williams <dcbw@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: Re: libertas_tf should replace libertas_usb on compat-wireless?
Message-ID: <20081112233956.GC15803@tesla> (sfid-20081113_004020_847768_CE5E4A66)
References: <43e72e890811111632x2c641d2cmeb69c0a0ea95382e@mail.gmail.com> <1226505205.13536.13.camel@localhost.localdomain> <1226512649.3940.0.camel@localhost.localdomain> <20081112195515.GA15803@tesla> <45e8e6c40811121307v32ca4c2cq77714ff14bec4563@mail.gmail.com> <69e28c910811121316i285ec2dbr7acf6c3fe660536a@mail.gmail.com> <20081112222758.GB15803@tesla> <69e28c910811121429y298158e0i59c39f50fb9b4bc8@mail.gmail.com> <43e72e890811121432k2ffd1902p665df2a11cf3b3d7@mail.gmail.com> <69e28c910811121523n49f79c8ye490a29ee165508b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910811121523n49f79c8ye490a29ee165508b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2008 at 03:23:05PM -0800, Stefanik G=E1bor wrote:
> On Wed, Nov 12, 2008 at 11:32 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, Nov 12, 2008 at 2:29 PM, Stefanik G=E1bor <netrolller.3d@gm=
ail.com> wrote:
> >> On Wed, Nov 12, 2008 at 11:27 PM, Luis R. Rodriguez
> >> <lrodriguez@atheros.com> wrote:
> >>> On Wed, Nov 12, 2008 at 01:16:36PM -0800, Stefanik G=E1bor wrote:
> >>>> On Wed, Nov 12, 2008 at 10:07 PM, Andrey Yurovsky <andrey@cozybi=
t.com> wrote:
> >>>> > libertas_tf is a softmac driver developed mainly so that XO's =
can run
> >>>> > hostapd and the like.  libertas is the general (fullmac) drive=
r and,
> >>>> > in my opinion, should be the one users get unless they specifi=
cally
> >>>> > wanted libertas_tf because they're experimenting with AP mode =
or other
> >>>> > mac80211 features.  So I guess I'd vote for libertas over libe=
rtas_tf
> >>>> > at this time, for what it's worth.
> >>>> >
> >>>> >  -Andrey
> >>>>
> >>>> I think libertas_usb should be a default (as it's HW accelerated=
), but
> >>>> libertas_tf should be included as an option (disabled by default=
 in
> >>>> config.mk, or auto-added to /etc/modprobe.d/blacklist upon make
> >>>> install).
> >>>
> >>> OK so I've done this on config.mk:
> >>>
> >>> ifneq ($(CONFIG_USB),)
> >>> ifneq ($(CONFIG_LIBERTAS_THINFIRM_USB),m)
> >>> CONFIG_LIBERTAS_USB=3Dm
> >>> NEED_LIBERTAS=3Dy
> >>> endif
> >>> endif
> >>>
> >>> This means you'll get CONFIG_LIBERTAS_USB unless your kernel
> >>> already was built with CONFIG_LIBERTAS_THINFIRM_USB for all those
> >>> building with it. If your kernel was built with both then its you=
r
> >>> problem.
> >>>
> >>>  Luis
> >>>
> >>
> >> If the kernel has both, compat-wireless should also build both.
> >
> > The kernel has both, compat-wireless has both but we respect your
> > kernel .config unless we know better (we picked b43 over bcm43xx
> > before). In this case we don't want to prefer one over the other so=
 we
> > simply stick to the decision of whoever built your kernel.
> >
> >  Luis
> >
>=20
> I mean if both are enabled, and both were built.

OK yeah agreed, but if the user has nothing then we should pick one
for them too, in this case it'll be LIBERTAS_USB.

 Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
