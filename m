Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbXKVOlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 09:41:45 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200711221514.37906.hs4233@mail.mn-solutions.de> (sfid-20071122_141421_164627_CF0FF330)
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <1195736752.6323.97.camel@johannes.berg>
	 <200711221514.37906.hs4233@mail.mn-solutions.de>
	 (sfid-20071122_141421_164627_CF0FF330)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-azBScZ31aj3nALANN1Aj"
Date: Thu, 22 Nov 2007 15:41:23 +0100
Message-Id: <1195742483.4149.6.camel@johannes.berg> (sfid-20071122_144153_100058_3B62521E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-azBScZ31aj3nALANN1Aj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[please make sure to copy me on replies]

> On first sight, you might be right. I haven't told to associate.=20
> But at the second sight, there is no EXPLICIT iwconfig-based way=20
> to say "now associate".

Exactly. So I argue we're free to chose.

> For 6 drivers (see below) the "iwconfig=20
> XXX key YYY" command is an IMPLICIT way to say "try to associate=20
> with what you know so far. That's because those drivers have a=20
> heuristic like
>=20
>   "If I'm not successfully associated yet, then I try to
>   associate whenver I get a new bit of info".
>=20
> And this bit of info might be ESSID, wep key, wpa key, on some=20
> drivers even rate or b/g limitations.

Which is crap.

> > Can't say that matters since wext is actually sufficiently
> > undefined to allow both behaviours. :)
>=20
> Wrong.
>=20
> Of course I can say that the ESSID,KEY sequence used to work with=20
> non-mac80211 based WLAN drivers. Because it worked. I have proof=20
> that it worked.

Bzzt. You're operating on wrong premises. It doesn't matter! Nothing in
wext gives you the promise that this works!

> I might not be able to say that it worked for *ALL* non-mac80211=20
> based WLAN drivers. But I haven't said that.
>=20
> And as of now, I can say that 6 drivers didn't care if I first=20
> feed the ESSID and the the WEP KEY:

[drivers snipped]

Actually, all of these drivers misbehave because they allow you to
associate to a network that has encryption enabled even if you haven't
set a key!

> One can say that if so many drivers behave identically, then this=20
> is a behavior that many users assume. And, oh, by the way, many=20
> distros.
>=20
> It's the behavior of mac80211 with wext-compatibilty layer that=20
> behaves unusually or out-of-the-order.

Again, you're operating on the premise that what some drivers do defines
wext. That's thankfully untrue and since wext doesn't define behaviour,
the mac80211 behaviour is well in line.

johannes

--=-azBScZ31aj3nALANN1Aj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0WVEqVg1VMiehFYAQIL9Q//bFUMD/DAGkV1sKoAnN8gmAILsm4RXs5J
XJG+VRt8LBqnVwJnhBQH8/WO7dKd7YLVga2lkpzUZD01njogLbmHL2WxlDrN4Dhd
f8gF6RMjMbnv6H0RGbd+7L5ry0WwEiz8+Mqe58tqXT0geN2iZOVo2hEIjiMCL+YC
Mfacrq5dFlNcVNiS3D7IPho03QLk9ZGc8E389Q7/wBeJWANX3c7O5foHzPu1aJ7L
snqtQJwiujg31+xSQqVnrNdqF4xxNNVnS71UIa8xsj/VIwelZJQFeS3xj8AEvF4y
QS0js02FcvMQKGd3z0g+Zq9NKQVTOuu39juGotf1A63NfAtawmCvqDzB02efSPX4
itTWsJ03mdiEaIaqxrBmg3ut3XVUqOhzzk5ii/8i1YIzj+jwI7r/j6idOgBnb5J1
WiccbnZK9/xEir6O5Tydv9maQ/rAeOfC2sK7b36T1/5RbrlScyqCHUUs7vhf9HiO
yuV6sWbf4tgO/jEPeXoyX3nAs8uZE1qActCI594E7f25YN/TLsE/X8GFzPzpr+En
mEl0I9/RG6jOIXN3/1EK5FfJVW/YCNHB+PTxc0hciseIP+7DDo6Teszsy7AjEXGc
P+VgI1XXOS0prNW3GT1tBTGbDO3h436mzIneyujuiSXb8klpZhbcmV3poXN8dgfQ
p5ae6FbVbuk=
=ueBv
-----END PGP SIGNATURE-----

--=-azBScZ31aj3nALANN1Aj--

