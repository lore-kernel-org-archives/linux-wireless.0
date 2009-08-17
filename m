Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41185 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbZHQVhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 17:37:55 -0400
Subject: Re: [PATCH v4 32/34] wireless: make mac80211 select cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
In-Reply-To: <43e72e890908171000r52f59cb6tbfef751324bf9968@mail.gmail.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	 <1250281559-13041-33-git-send-email-lrodriguez@atheros.com>
	 <1250283993.4411.1.camel@johannes.local>
	 <43e72e890908171000r52f59cb6tbfef751324bf9968@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-awCfkZwWyS/9HJ7/UhyE"
Date: Mon, 17 Aug 2009 23:37:49 +0200
Message-Id: <1250545069.25876.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-awCfkZwWyS/9HJ7/UhyE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-17 at 10:00 -0700, Luis R. Rodriguez wrote:
> On Fri, Aug 14, 2009 at 2:06 PM, Johannes Berg<johannes@sipsolutions.net>=
 wrote:
> > On Fri, 2009-08-14 at 16:25 -0400, Luis R. Rodriguez wrote:
> >> We can now remove that comment about mac80211 requiring
> >> cfg80211 and do that for the user.
> >
> > "now"? What changed to make this possible?
> >
> > NAK this change, because with it, it's possible to select
> > mac80211 =3D Y
> > -> cfg80211 =3D Y
> > while rfkill =3D M
> >
> > which will break the kernel build.
>=20
> I'm able to do this with current kconfig, does this need to be fixed?

I don't think you can select this with the current config since cfg80211
depends on RFKILL =3D=3D CFG80211 || RFKILL =3D=3D n.

So you can do
CFG80211 =3D m
RFKILL =3D m

CFG80211 =3D *
RFKILL =3D n

CFG80211 =3D *
RFKILL =3D y

but NOT

CFG80211 =3D y
RFKILL =3D m

johannes

--=-awCfkZwWyS/9HJ7/UhyE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKic2pAAoJEODzc/N7+QmaIiYP/2Ri7mlRbKJzGI+gAVwXfGJz
8lea/6a2TF4XdEkuTEjcA+Kou+5CUqR3mPi6p1bNFcgOQi5adI82T4ve7hrULm8Z
wMlp9Dp13IHRIik6TWb20QC6+d0y95o7cwlJ/LbdU3cIkzuIQ3g5jRYHSF5ksCOH
VjfgpWw3X8cNv9BsqCsD37UJU4MJcpXjKwiHFjsO5Cby4K0HdblkdWSbT5gYjWXK
Ew3xlvbfOVi1MVd/jdu2bcxbNSOUVzQJyh3uB3mGAqvYU81t2Q2ygzUn5ML9HRJj
DXUZSCofLLdtAU13TSUJzVhOX13he/4K+cut14cHCPwFHIUnfbfp1/wen8+7H8dl
u1WG+dPWOdlQhp5RWWlM2OJZ2Z7Q+bbeQVrOLP4DvDCMebKU1xtY2lRsWfAdvM3u
CT5n4kCbi4HycVppVpI9VObjPZJTp8BRRzoF/4IFs0jSu0Q9Kkhrc26hrWRTPTGD
HKRSuhIbZx0aJNmNoX9nsmlJ1qTZytMxNRhPAkqo6avLV/CW4/KEO0/HjjbZbh9o
WYwHWASqM0Na4xvtOxJy3IzYBWATGj2hMAKKMx5ZSz2shUhHE6Zyt5mqI3XO2kNo
IcFfYCUu6qp8ST2Q8ZGYz8JrdipyApZCPDQgYCtafmLG7L0NghzTceY68JmdMole
UctamsEHKKXwRbmJ7bpe
=tyJs
-----END PGP SIGNATURE-----

--=-awCfkZwWyS/9HJ7/UhyE--

