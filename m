Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbZANAGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 19:06:39 -0500
Subject: Re: Warning in latest wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <496D2AE4.7000808@lwfinger.net> (sfid-20090114_005957_740853_8987481F)
References: <496D2AE4.7000808@lwfinger.net>
	 (sfid-20090114_005957_740853_8987481F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0/am2KggItvOcPKRRCdR"
Date: Wed, 14 Jan 2009 01:06:10 +0100
Message-Id: <1231891570.28311.0.camel@johannes> (sfid-20090114_010644_013014_26857313)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0/am2KggItvOcPKRRCdR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 17:59 -0600, Larry Finger wrote:
> In the latest pull from wireless testing, I get the following warning:
>=20
>   CC [M]  drivers/net/wireless/b43/main.o
> drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_set_key=E2=
=80=99:
> drivers/net/wireless/b43/main.c:3636: warning: pointer type mismatch
> in conditional expression

That looks like a merge error:

                b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
                       "mac: %pM\n",
                       cmd =3D=3D SET_KEY ? "Using" : "Disabling", key->key=
idx,
                       sta ? sta->addr : "<group key>");

It should be something like

u8 bcast[ETH_ALEN] =3D {0xff,...}

sta ? sta->addr : bcast

there.

johannes

--=-0/am2KggItvOcPKRRCdR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbSxqAAoJEKVg1VMiehFYJZMP/1GNLAujvNFKtinP7X6IN+k6
zB6Unjn9+sm2WQvbyGsnuWlbFQ6fGZyxeYgVAo1f1dhHDyT9Z6kvGE7FIHe9nklv
9tPWGFNdq96cTNeWKVauYS9M69osiCjdYtz8bkCUCNomDvJygV4IQoRF8rqB8eQP
0gqL8D2Qjr4FMFNXVUpyx44MXHpQeFBxuVn1BZDFVs3LaTo0crx/bTzKPQMuThYP
lhNknad8KzVg8eKVOJIukSEYD2XRpzyuW23TnlJ73/8DuwzUPNsYShHfLM6uA0qs
UjLEupLvBmpa5TYB7pYJAW1UcgQjaXhzBFU/YPEXXWS0Kf24w3nq0d+95NnV2lIc
SQy4Z5na0bmD2eXxuTo/ivfgP6Ujj2sT7U2s2XLvQfYG9fmhJDYAP34id/nOKhaK
718u2dGkQ9TNxYeQcWFnFZIIcQgnirpBSCnuLsLQlK9Xx2sMEOcisUh8PNbb3Ft3
teSEjyKf7TK6kGVUu3c9U1WX43K9g5/51UffCSpobhzuvsewdSm50V2X7Yl48T0G
RjMYTztCeL2yXBTpsTBBsF1sSr1WJGzaKnQoUgW9lurmqCb1bRAWs4VDDpoMWuof
9uBXgY9GLKBI4q4tqu1kfGhh2IurR0hCQ4wF7oueIcntlTnH/36qPgMZvygc+eZT
wjOsail8s2IPM4t7clMs
=6fNW
-----END PGP SIGNATURE-----

--=-0/am2KggItvOcPKRRCdR--

