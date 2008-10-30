Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbYJ3OY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 10:24:58 -0400
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point
	operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <445f43ac0810261334y7c064785gbf83efe3ab00cdf9@mail.gmail.com> (sfid-20081026_213518_519033_70F09A6B)
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com>
	 <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com>
	 <200810251228.17562.IvDoorn@gmail.com>
	 <445f43ac0810251820p71e6e330tba6ba9475ca8aa48@mail.gmail.com>
	 <1225008571.3478.14.camel@johannes.berg>
	 <445f43ac0810261334y7c064785gbf83efe3ab00cdf9@mail.gmail.com>
	 (sfid-20081026_213518_519033_70F09A6B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lZL8Uq+ZPckkJJPOIflo"
Date: Thu, 30 Oct 2008 13:26:48 +0100
Message-Id: <1225369608.3690.43.camel@johannes.berg> (sfid-20081030_152503_051723_2131F9C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lZL8Uq+ZPckkJJPOIflo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-26 at 13:34 -0700, Javier Cardona wrote:

> >> > For rt2x00 this would turn into:
> >> >        FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS
> >>
> >> With the above configuration, will the rt2x00 device acknowledge 1)
> >> unicast frames addressed to itself? 2) unicast frames addressed to
> >> others? 3) none of the above?
> >
> > It should always only be (1), mac80211 might set OTHER_BSS if it (well,
> > the user) wants to see traffic on the same channel from other BSSes.
>=20
> Good.  My concern was that FIF_PROMISC_IN_BSS would disable all
> acknowledgments.  (I've seen some wireless hw with that behavior)

Just for the record, (1) is the behaviour mac80211 needs, and hardware
that behaves as the one you've seen wouldn't support FIF_PROMISC_IN_BSS
at all, and consequently not mesh either, I suppose. I'll add a note to
the API page.

johannes

--=-lZL8Uq+ZPckkJJPOIflo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCagEAAoJEKVg1VMiehFYvFsQAJffOctR30sf5eJ7gJGXo6kD
STXQmXy15Ne7bf68dvj5aH6GhPY4cFHPfCqCxrDtLx29U8gkv3tl5WabZAn1HNwD
OuzG2397aS729duhQoPTz8Qc89EmWGqmMmKHRYJJxAtBPIGCEYQJzDYph6usWGv1
TYDVWM4PFt2YmnNps34R7WQ/d4Ve4j7OPnP5Z0ZW5kGyhvs1y/EdF5Dln4mIZ+3m
RAQutaY5cbU1Dw7pkY+6zWkI8p5c1apjfrdLOjcvpf9rn3hXItdhyI9tAcqVayK1
r1XGJIoQTsDcHG5yj0AyYaDpeZsHEpPyoToefOJsBPr4Dni00urbu7WuZpafWigo
10vLn/J/utRLjsMic1TIS7yJDKVGMvSw0bLkef2zrTBHTCw3HUGN1/l/6gypZv52
PNbLJV4QWoACR/E0ucLEW3U6MarbuMRuMEActzqlDd8lBO4K8G9i/tWzfk2XTorW
hNikAj1nqY4t6StQ09knM2k8MRidsXZHsGsRwk0pFBmyCN44JJQMp7XgItSrXwDL
LfXChq0NDK+RW8G/q3jXz06A3foVaz5bNkUN8d5X/CtZV3J1KtXtmiMKuKe+sf+8
WKltznXT9pVEOy5ClYsJoaLOQ60dUx8LPsjXFlECMD4uqf1IDI1W2PTp5Qvmezc7
/vQ9p2hZiYlZ30WebA9m
=IhLe
-----END PGP SIGNATURE-----

--=-lZL8Uq+ZPckkJJPOIflo--

