Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:57499 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaEJQhI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2014 12:37:08 -0400
Date: Sat, 10 May 2014 18:36:45 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [RFC][PATCH] b43: drop SSB dependency
Message-ID: <20140510183645.04c801f2@wiggum> (sfid-20140510_183737_933696_950D4DC3)
In-Reply-To: <CACna6rwdXiGwLW=vuo2MMaQHYAWjDwc_W2zufmVbkmpBsMMp-Q@mail.gmail.com>
References: <1399733088-26607-1-git-send-email-zajec5@gmail.com>
	<20140510171721.54b21a63@wiggum>
	<CACna6rwdXiGwLW=vuo2MMaQHYAWjDwc_W2zufmVbkmpBsMMp-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/1LMQIbuTvzg/33d_3GqDhGz"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/1LMQIbuTvzg/33d_3GqDhGz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 10 May 2014 18:12:15 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> On 10 May 2014 17:17, Michael B=C3=BCsch <m@bues.ch> wrote:
> > On Sat, 10 May 2014 16:44:48 +0200
> > Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> >> +config B43_BUSES_BCMA_AND_SSB
> >> +     bool "BCMA and SSB"
> >> +     depends on BCMA_POSSIBLE && SSB_POSSIBLE
> >
> > I think this needs to be:
> >
> >         depends on (BCMA_POSSIBLE && (BCMA =3D y || BCMA =3D B43)) && (=
SSB_POSSIBLE && (SSB =3D y || SSB =3D B43))
> >
> > to avoid the case where b43 is y and ssb or bcma is m.
> > Or did I miss something and this is caught elsewhere?
>=20
> Oh, wait, I think I meant B43_BUSES_BCMA_AND_SSB to select BCMA and
> SSB (so user doesn't have to enable BCMA and SSB on his own). It it
> the way it's handled without my patch (B43 select-s SSB).
>=20
> I'd like to add
> select BCMA
> select SSB
> , but this won't guarantee BCMA (or SSB) being "y" after choosing B43
> to "y". Or will it?

I'm currently unsure.
You probably want to add select SSB to config B43_SSB and the same for B43_=
BCMA.

> Any idea how to handle that?

The (SSB =3D y || SSB =3D B43) dependency is supposed to handle that.
And it was required in the past. But maybe it's not required anymore
due to other changes. I'm not sure.


--=20
Michael.

----
Please use PGP/GPG encryption.
Key-ID: F532BE1D908D8B0E
--------

--Sig_/1LMQIbuTvzg/33d_3GqDhGz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTblWgAAoJEPUyvh2QjYsOeiUQAOHhhgETo2n/mV1DU8YJx95+
pCQx41Bz9uFMXScFga5fovSW0JYl+lZgiloEGTsQyE4NK11quNUp6g+C1PZ73+/2
s8Zg/0Ss0nbyPTjHEDpIvsJ/ODWxIBqy1swXBzDGzaGGb8W0LvzFmI8pST4s8Y0v
89DLtxte5+94Ky9r1hqkIxba3R3x/V3AOgmC/UD73XONpkx0RKQhrrPs2MeJcn++
hzenWF6vwqVboYdKu8VRGkmO6MgE9Oza+AHdKuyfbJ+rTVUxhM/hI6egW6vxtAKq
dTz82qObrwlYXU+wnpxD50NeVzcprxzYvXHh11db6nSijIiok3gdVqVSuIZcopeu
lzIzZMQSIy0Xu62S465aR1vDYqnsH9nztD3YvVxA2uTfuXqrbIzvhr7fMiPq9fc7
pYojAfEuvGSezlN/oq7Zu06Y1GgzN7LiHibPGyWAf9SLwhljXiCfspAhVUQCiEsA
uXZOlan4HrfWuT7HdsukQ5aI4gGEWUgnhI62z1BK29+eRl1CPlkdwYfrQhONDjBO
DOWnQhzU2mGe0I2qM1vM7i2cFdnX8J6Goc2BSM5XOrvcxl8rBRBftfnKs18P5XXF
CQg1kF8W/c/kxkRFA5qneIN5oHwPPDyir9AIYXOauOBrKx540NJ6pXNEYKBjcue3
/OjJD5UdGBwN2WUDUL66
=XsyQ
-----END PGP SIGNATURE-----

--Sig_/1LMQIbuTvzg/33d_3GqDhGz--
