Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51250 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538Ab2AVESR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 23:18:17 -0500
Message-ID: <1327205891.8004.105.camel@deadeye> (sfid-20120122_051838_686322_343EE9FB)
Subject: Re: [PATCH 1/2] ipw2200: Fix order of device registration
From: Ben Hutchings <ben@decadent.org.uk>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	656813@bugs.debian.org
Date: Sun, 22 Jan 2012 04:18:11 +0000
In-Reply-To: <201201220432.34482.s.L-H@gmx.de>
References: <1327201775.8004.83.camel@deadeye>
	 <201201220432.34482.s.L-H@gmx.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WLXoTTCOfHbQ650GbcSj"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WLXoTTCOfHbQ650GbcSj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-01-22 at 04:32 +0100, Stefan Lippers-Hollmann wrote:
> Hi
>=20
> On Sunday 22 January 2012, Ben Hutchings wrote:
> > Currently cfg80211 fails to create a "phy80211" symlink in sysfs from
> > the net device to the wiphy device.  The latter needs to be registered
> > first.
> >=20
> > Compile-tested only.
> >=20
> > Reported-by: Cesare Leonardi <celeonar@gmail.com>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/net/wireless/ipw2x00/ipw2200.c |   23 ++++++++++++-----------
> >  1 files changed, 12 insertions(+), 11 deletions(-)
>=20
> I've tested this patch on my ipw2200 (inside an Acer TravelMate 292LMi).
> While the original
[...]
> is almost cosmetic, without any apparent ill-effects, applying that=20
> patch to kernel 3.2.1 (not exactly Debian's - e.g. I need acerhk/=20
> dritek to disable rfkill for that card, but it should be close enough)=
=20
> results in this trace:
>=20
> [    5.708938] libipw: 802.11 data/management/control stack, git-1.1.13
> [    5.708942] libipw: Copyright (C) 2004-2005 Intel Corporation <jketren=
o@linux.intel.com>
> [=E2=80=A6]
> [    5.785178] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1=
.2.2kmprq
> [    5.785184] ipw2200: Copyright(c) 2003-2006 Intel Corporation
> [    5.785323] ipw2200 0000:02:02.0: power state changed by ACPI to D0
> [    5.785330] ipw2200 0000:02:02.0: power state changed by ACPI to D0
> [    5.785344] ipw2200 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 10 (l=
evel, low) -> IRQ 10
> [    5.785370] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connec=
tion
> [    5.785416] ------------[ cut here ]------------
> [    5.785435] WARNING: at /tmp/buildd/linux-aptosid-3.2/debian/build/sou=
rce_i386_none/net/wireless/core.c:562 wiphy_register+0x45/0x38d [cfg80211](=
)
[...]

Which is:

        if (!have_band) {
                WARN_ON(1);
                return -EINVAL;
        }

and have_band is set if any element of wiphy->bands[] is non-NULL.

ipw_wdev_init() clearly does initialise wiphy->bands... except that it
seems to depend on the regulatory area having been determined already,
which I suppose must be done during the callback from netdev
registration (ipw_net_init()).  Judging by the comment about this in
ipw2100.c, it's probably important that initialisation is done in this
order.

So maybe cfg80211 should instead tolerate registration in this order?

Ben.

--=20
Ben Hutchings
Knowledge is power.  France is bacon.

--=-WLXoTTCOfHbQ650GbcSj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATxuOA+e/yOyVhhEJAQqjpxAAk+qmOjI5V0/HxnU9Z0cv8VdYrz+pNmmN
Nw3i1cg0M0bMQnWHQKMRK+sz56rG8bqupFU9VOP8j545gg95GVMSBUoVXfSu39WL
Q73nZ0Fy7/XI65E9neLLPgEChC4tNKEzlVIZu2DoTsRR9BY139yNPk+iy5EdPofK
z+Ar9C4e3CfxpvU1NKx9Bk5mYAzQGpWj2Krec37xhGzpTlhyKHFvmGlhxYrZS/NS
vQDKb+xb2BR32tj9oI+VKcQbf8jNszjcrrs/BQ+h+W0p0P8ul0dzE/PgSHgcdi7s
s8xfwwbhJMYvvSP4CNKVpSIh+Uo2L1ZqJ4Y3NkZRjHrqIkMV6EofB3MK20tXsSyJ
UnlNXQW9lZirzDA0VkGT6fUlqAhUnsFicrlnf+rIFOo1q/ZrpaNWzHrQnZXQsYBw
w2xtzBJOJgQwrdn5zbrYCpllRD921I177eqWdf1RpwAMyVEx7q5zzQKRDJYetAj8
4AsPrIt81zb8fNbRG7EAQaNNQlCPfH5dbxu3spAa7Bnk3IKJuv7JpxeuDVcKf+2l
IIC8iRm+kquSgQp6qIgfB3Qh7hpIQPGK9+G5IXYrCOBohwodq14cxzLIe+jQBQcb
vtd9O3t7Myz3Bvk08hp82YoJs/BML3CB3WkFgh4oCaN0vxG5zeHWLXuc/0oTHP8o
FkiWYiKJuCI=
=jst8
-----END PGP SIGNATURE-----

--=-WLXoTTCOfHbQ650GbcSj--
