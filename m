Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZKZSSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 13:18:10 -0500
Subject: Re: [RFC] API for setting ACK timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: 8an@praha12.net
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200911261826.08576.8an@praha12.net>
References: <200911261826.08576.8an@praha12.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cFZ9Kaw7iNgJ6OzQrTlC"
Date: Thu, 26 Nov 2009 19:18:13 +0100
Message-ID: <1259259493.24540.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cFZ9Kaw7iNgJ6OzQrTlC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-26 at 18:26 +0100, Luk=C3=A1=C5=A1 Turek wrote:

> It consists of a new nl80211 parameter:
> [NL80211_ATTR_WIPHY_DISTANCE] =3D { .type =3D NLA_U32 },
>=20
> The value of the parameter would be a link distance in meters, so after t=
he=20
> support is added to iw one could set the ACK timeout on a 3km link using:
> # iw phy0 set distance 3000
>=20
> Another required change would be extending cfg80211_ops by functions=20
> set_distance and get_distance. Calculation of appropriate ACK timeout (an=
d in=20
> the case of ath5k, also CTS timeout and slottime) for the distance would =
be=20
> left to the driver (it's a trivial formula).
>=20
> I can prepare the patches, if you think these extension would be acceptab=
le.=20
> Suggestions are welcome.

I discussed this with Alina a while back (in private, she didn't want to
discuss in English) and we came to the conclusion that set_coverage()
should be done like 802.11-2007 17.3.8.6 specifies for 5ghz, but could
be done for 2.4ghz as well. Thoughts? It would also allow us to actually
advertise that to compatible clients.

johannes

--=-cFZ9Kaw7iNgJ6OzQrTlC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDsZiAAoJEODzc/N7+QmaZp0P/A1Xa0BLGcEGl4JoCeyszuLc
1SxLl3n6bNys0/qXSZPMyvnjiUVsKCkC+w0Bgc+iFCbb9Xz+EdYt2uieji+kbo+Y
mnt5KBOYlhYowlrhGlRslpIcabXp6bkx+JLyUK4n8iEC0Lb7ux68cTqPj8IdJ/RU
Lcz2ojLLHhFOeyxGZzRBjU9m6uGhO2lUrD9rUKNidEgOOhyodisxJZjD+O0nj1kS
EInMBvSMAJeDjHX40MPTPU09VYsmacY17mm7pXwcuqkc6c4Mr9W/E/qA/ZZJz1e9
G6gnwl6SX3B6/7HAPbxP/Y81SMffhbJZygSWB4xNDoBmBF3urOVnBsZr3LSyTsv8
fqQf43gzypSJpsXVOaskf2cMhjwgGYTpJ2A2ufqZwO9FDrEESMh6Jby46j4AE+UL
CsAL9IuwnjeVg9kgx8xz9QXL82pALyWlodFj++gSuXu/7n1t7uFNREoswwLKfTGw
Fv2wO4zukSsHwSJIm1cTf+wqWF+TUg2LEzcL1IcWb+vt3ohfDcQHyfYBwXyfAdwc
e1pX1IUCeEVG1UV2x/St6y3Mg5BnZhcDWNyMDzwTS/aHpm5za4utaJQgYertUAAs
LBYSSqqZh/2AJV7fRJTcJbwitL5uUKV51CYui0fkmuKyJDPCCXyiKKDSqbqzcZR0
NrEjsf+UoeX6ycg02Rs2
=5kle
-----END PGP SIGNATURE-----

--=-cFZ9Kaw7iNgJ6OzQrTlC--

