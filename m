Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbXLDQ5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:57:17 -0500
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200712041140.07516.hs4233@mail.mn-solutions.de> (sfid-20071204_104003_822443_169A4663)
References: <200712041140.07516.hs4233@mail.mn-solutions.de>
	 (sfid-20071204_104003_822443_169A4663)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S1GqGbaw6Q/dtOr08VBs"
Date: Tue, 04 Dec 2007 17:57:14 +0100
Message-Id: <1196787434.10274.22.camel@johannes.berg> (sfid-20071204_165737_858383_BF367E2C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S1GqGbaw6Q/dtOr08VBs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> 7. RADIOTAP
>=20
> Libertas contains lot's of code for it's monitoring mode, which=20
> uses radiotap. It used "struct net_device *rtap_net_dev"=20
> and "struct ieee80211_device *ieee". It contains code like
>=20
>    priv->rtap_net_dev =3D alloc_ieee80211(0);
>    priv->ieee =3D netdev_priv(priv->rtap_net_dev);
>=20
> and I don't have any knowledge about radiotap and how to=20
> substitue the alloc_ieee80211(). All I could currently to is to=20
> put those sections into #ifdef CONFIG_IEEE80211.

You don't really need a ieee80211 interface for radiotap, look how
mac80211 does it, it's a simple netdev with the right arp header. You
don't need to provide anything like wext on it if you don't wish to.

johannes

--=-S1GqGbaw6Q/dtOr08VBs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1WG6aVg1VMiehFYAQJa1BAArEbWhA07M4eNiKFcPSvs7M9xS45ASf7b
+ZfGAXwc2jL5k7wSpFTeL1je0QAeRIXWcBD4okPZoV+8dyyF6iXsQKpffk7WAJOS
72AA7ZL9W5Xy2kq3AuxDwmxjX5BkovEIBEcciXEAVXoEIFoS9aZMpYL22cR1Vr39
/7Pcw4y08vluqZsjFNszu0mu/nxApRAmJOVHYTkZS1y8+6kNyELmHeb9zmEZrClQ
I2hHTg8zSlObev0LuddZ07gBAIX+XCBqC/lGHI2Nr2ohp2QrElPyBs25PdAmUsdN
BGXdcFMPcE70UNjObmWZNB3C1J9vkirzlwyeWw1vp3/d8Gtg39G+uf7t0PjQdsrm
5y/ybZOnyX72kk00liti41iv888ijSMizj2ASohEH/JOgWiMbcQAM74Wwz7zl1nr
OJjnMRYrkglkx92+yhS/YRHIGsqwSEIYREW+LxpCziNuzekVVIyIjo3o8nTUbOOk
pOKGVZIUOSco75MS6T5Zs1zUWclJZpCuBh2xRYh7A0brLiemcsuZpe9fi4E4ZffL
SMMIXN71JDOyo7mUiz4ZPsdu/2eoqzycYuhUUy17+/q25GhIghbayvB498+Ib0U5
jGw3pUpKAUlRpHMl8NDJq00pV7elTJqXht+mfNc0gn2pNlgMBZivRRsUgrUeRwaD
5ALojWqMRHA=
=icsm
-----END PGP SIGNATURE-----

--=-S1GqGbaw6Q/dtOr08VBs--

