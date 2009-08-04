Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbZHDUdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 16:33:10 -0400
Subject: Re: [PATCH] remove wrong probe_resp_plcp write
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	gregor kowski <gregor.kowski@gmail.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200908042227.46237.mb@bu3sch.de>
References: <83a869cd0907311335h3065547aqc736573a663b6d42@mail.gmail.com>
	 <200907312238.15705.mb@bu3sch.de> <20090804160558.GC4995@tuxdriver.com>
	 <200908042227.46237.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PoJ4muxHm00NIzE8D4M/"
Date: Tue, 04 Aug 2009 22:33:03 +0200
Message-Id: <1249417983.24787.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PoJ4muxHm00NIzE8D4M/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-04 at 22:27 +0200, Michael Buesch wrote:
> On Tuesday 04 August 2009 18:05:58 John W. Linville wrote:
> > On Fri, Jul 31, 2009 at 10:38:14PM +0200, Michael Buesch wrote:
> > > On Friday 31 July 2009 22:35:49 gregor kowski wrote:
> > > > The tkip hw support uncovered a bug in b43_write_probe_resp_templat=
e : it is
> > > > writing at the wrong shm offset, it is in the B43_SHM_SH_TKIPTSCTTA=
K zone. This
> > > > patch comments these writes.
> > > >=20
> > > > Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>
> > >=20
> > > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> >=20
> >   CC [M]  drivers/net/wireless/b43/main.o
> > drivers/net/wireless/b43/main.c:1432: warning: =E2=80=98b43_write_probe=
_resp_plcp=E2=80=99 defined but not used
> >=20
> > Comment it out too?  Or are you going to fix the block that has been
> > commented-out here?
>=20
> No, please add
> #if 0
> void b43_write_probe_resp_plcp(...)
> {
> ...
> }
> #endif /* 0 */
>=20
> to comment out the function, too.
> The probe response offload is currently not supported by mac80211.

Just remove it -- if we need it back we can find it in the git archives,
and it's rather unlikely that we're going to add that functionality to
mac80211 and hostapd unless you'll push it.

johannes

--=-PoJ4muxHm00NIzE8D4M/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeJr7AAoJEODzc/N7+QmaixgP/ioopp7i7K/D0iWFN8nIbzLr
96pFlhbHgNoZ/7NiMP58GLcbbA7i6qIuCq70t3cfhbtBHnOiIqU1TVFCijx6XG+T
f1SWqk0fLrpBpqVk6Kj3ZhKy9nB/zzEqf4+Kp7O1/8wHWMxGU1HNEIWQYfCScb85
PjrXifhdHtvOPu+x7xz6sLpC+sJSd6Ggsd6xckwlOi+1PUcqnL+y6HLccz9Tl8Ib
pO5JfroiIKLsXTyHyAQJiQyGvFT5ykCoARsk5myvbSNshCefqklBadZ6xDDGuhP0
GsQEGGQRlhZSz8iPeFcayFT4f80wxFri1VLC09xRpDekm079+Tnow+32euiEYVJx
lrPPBWlnN15K5//sAHpqtqjr06ydp8rJ53BiAT0oEdh/hsCZtzCGZ46IG8TmknIA
d1lFyZIlWNwW+3c5lqfUm/F2+AhvxmNd0AWfHWIE0ZkRKISvxqzkE76kzcQtXbuJ
DnP30cG5zFYiGLDUVXuql6ZGcn2EPixSPWzEApZHeiWEX2Oz3gmspd1Ba0hE41W4
lynQeCgeStGtPXCqcbZvc/IXDXE1qs8ym3se7jmLt2+7acrWQcvguGRjDR9R6tKg
RH2h6RjQD5mSZgNaConShZdSg0Su+aHLDSoTJJwugjZLW1Fouj4dmXhWjHr1cwq/
scv8dbcHse0XNQdQaZ91
=OsDc
-----END PGP SIGNATURE-----

--=-PoJ4muxHm00NIzE8D4M/--

