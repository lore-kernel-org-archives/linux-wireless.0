Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbZJAUCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 16:02:15 -0400
Subject: Re: VLAN traffic appearing on the wrong iface
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Bla=C5=BE_Ba=C4=8Dnik?= <bacnik@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <57b62e7d0910011255r2ecf2bbex37422204add9a2b0@mail.gmail.com>
References: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
	 <1254341787.3959.11.camel@johannes.local>
	 <57b62e7d0910010732m38ab57k916662f9047fcc91@mail.gmail.com>
	 <57b62e7d0910010740t67a96d88h59b10161844f2836@mail.gmail.com>
	 <1254422380.3959.23.camel@johannes.local>
	 <57b62e7d0910011255r2ecf2bbex37422204add9a2b0@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vX/QAGMq8GS2YuAW4Qwg"
Date: Thu, 01 Oct 2009 22:02:19 +0200
Message-Id: <1254427339.3959.34.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vX/QAGMq8GS2YuAW4Qwg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-01 at 21:55 +0200, Bla=C5=BE Ba=C4=8Dnik wrote:
> On Thu, Oct 1, 2009 at 8:39 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > Thanks for looking into the crash -- I can't explain it.
> >
> >> -     if (ieee80211_vif_is_mesh(&sdata->vif)) {
> >> +     if (ieee80211_vif_is_mesh(&(*sta)->sdata->vif)) {
> >
> > However, that doesn't make any sense, given
> >
> >        struct ieee80211_sub_if_data *sdata =3D (*sta)->sdata;
> >
> > Could the compiler be playing tricks on us?
>=20
> There's the sdata =3D container_of(sdata->bss, struct ieee80211_sub_if_da=
ta, u.ap)
> in if-clause right in front of the ieee80211_vif_is_mesh and since
> this is a vlan interface that if-clause gets executed.

Ahh. hwsim has no sta_notify callback. I'll amend my other patch
appropriately, since your fix is, while correct, kinda hard to
understand.

johannes

--=-vX/QAGMq8GS2YuAW4Qwg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxQrGAAoJEODzc/N7+Qma2FQP/1U4hAoUZRS3vYonOMc54xSM
wMVUcBg/eilFAKCuXMEAfGPEnZu1PpsGoB8xuNCO+kYjQrt5CThTu1prqdXkKJlm
55gqQQrErZr/pDF1UspsoMSMw6BHQKlHRpo6aY0qqQdEu5Ns9Op7HDn0fgBWKaSg
89IFC7gpvqtcHHub0wbkLm4ALXZkfpOs2mLnqRgPl78M4/pj47GBQABMZyadsPcR
y0gxChjf8SO9VTfoFwFQJNCAavnrRcn2F4GTNxkc4OjtGqnwLJxGuFE+r0aYm0N2
z8Z/rZTlw4DDJYmuINlmWqAm+xp1fmy0py7teA/tyh7NA3TXh2U52wXgvrThha+P
e+QK+iKrydXNpNWJl5snQ6F8BKYUEqtGIHJQfPr0NUr07H6R59KcAN9azCDXTynI
riacaG7Wd6NqZ5/kvpK/omwie3huSx4RoWbBdcZiRoUw4eKw26b5hwP4Z5fiuONS
P66jLjtdqMnrNkybJB3u63R+tiLeq8vspw3JZqfuBmhDO0p9tlXp+9vdj2h/nFpY
vXCi0K5woES2FTfpsdtX85BziUcWFaoZ+bOZxfp2D679gCobPjBSJkgGKBEMkIK2
nVDpaztgZpBmx9jlwgv1OssaXBKJBT03R0ktzR6B5AEiDDkVbBfS511Hs+D/PdA3
ygHqONzYzFXLITE7mHdk
=7sbB
-----END PGP SIGNATURE-----

--=-vX/QAGMq8GS2YuAW4Qwg--

