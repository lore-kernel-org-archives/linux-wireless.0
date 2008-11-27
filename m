Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYK0XTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 18:19:46 -0500
Subject: Re: wireless-regdb: Update regulatory rules for Czech Republic
	(CZ) on 5GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Carlos =?ISO-8859-1?Q?Lau=E9?= <CarlosL@seznam.cz>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <610.1477-13200-1232669665-1227820994@seznam.cz> (sfid-20081128_001318_245944_E312D496)
References: <610.1477-13200-1232669665-1227820994@seznam.cz>
	 (sfid-20081128_001318_245944_E312D496)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hr9gmR7S6sks1xlwv6Xr"
Date: Fri, 28 Nov 2008 00:19:07 +0100
Message-Id: <1227827947.7559.38.camel@johannes.berg> (sfid-20081128_002002_071829_800216D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hr9gmR7S6sks1xlwv6Xr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> There seems to be outdated information in the regulatory database for
> CZ. According to the new regulatory laws, which can be found at
> http://www.ctu.cz/1/download/Opatreni obecne
> povahy/VO_R_12_08_2005_34.pdf (page 2) and
> http://www.ctu.cz/1/download/OOP/Rok_2007/VO_R_10_03_2007_4.pdf (page
> 3), for 5GHz the table should look like this:
>=20
> 5150.000 - 5250.000 ; 40.000 ; NO-OUTDOOR ; N/A ; 23.00 (200.00 mW)
> 5250.000 - 5350.000 ; 40.000 ; NO-OUTDOOR,DFS ; N/A ; 23.00 (200.00 mW)
> 5470.000 - 5725.000 ; 40.000 ; DFS ; N/A ; 30.00 (1000.00 mW)
> 5725.000 - 5875.000 ; 40.000 ;  ; N/A ; 14.00(25.00 mW)

Care to send a patch? Download
http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-regdb.git;a=
=3Dblob_plain;f=3Ddb.txt;hb=3DHEAD and edit as appropriate.

> if there are any difference between values in dBm and in mW, please
> consider the value in mW as the right value.=20

As you can see in the rules for DE, you can give the values in mW too:

        (2400 - 2483.5 @ 40), (N/A, 100 mW)

I encourage you to add a comment, so that the CZ entry looks like this:

# Data from
# http://www.ctu.cz/1/download/Opatreni%20obecne%20povahy/VO_R_12_08_2005_3=
4.pdf
# and http://www.ctu.cz/1/download/OOP/Rok_2007/VO_R_10_03_2007_4.pdf
country CZ:
	(2402 - 2482 @ 40), (N/A, 20)
...
	(5250 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
etc.

> * The values for 5250-5350MHz and 5470-5875MHz are valid only if the
> device is capable of automatic output power regulation (ie.iwconfig
> wlan0 power auto). If there isn't a way to assure this, then the
> maximum power output limit must be set to a value 3dB lower for ranges
> 5250-5350MHz (20dBm) and 5470-5875MHz.(27dBm).

Hmm. I don't think we have a way to capture this right now, should
probably use the lower values then.

johannes

--=-Hr9gmR7S6sks1xlwv6Xr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLyroAAoJEKVg1VMiehFYSBoP+wc06swiecEuhaF0j8YDc2bf
QNjdpR4I05y1RWxQl2DXnvJkdjACTtXR8iiDL0tRbLiKnX1TwzB0frXR5ofJ7IDS
2Idr9fL38nhIdRZZvU/+QFGtIf8nmRvxIf52axWBggb4k3Hq2TSQMYN9v4v2TCDy
l/mGwwuiVjMsZJWO5AKjp6ULjno+YTv+qqLc1WTB3EpIF9RskPlkCumZp/iapRXd
qImz4tgJzhxiNl2zXG5Rze2JxUMudngehBjozS1VPA9pdNGitapFcpgakJ69Xo4V
pWVG3M/PDDokygkrviDg8kzYTh8JXZNNQDTVZUml2THDo/822VIbUzArcnBSjXxF
XklQwQpEk4/n9cCPEqLJ5GMpNDOan9gRlhdSoy8f6LUfwkwwkgISqnY/IOljhvOb
1381EpNlEEVvTrOkTujt3ooL2ptrH/7j/Tq0bGlzqhD1rNAqhfGG1DxPiV/Y6tpw
TxFAzQvMPNsxvXbRzShojJMu7wCczClIMZxspUBcHopXN9ux1wfRHPqAN7Z6ayK8
5C5IjHhYukg6jt1/D4hd471lBL7NlJPWKRzZmg79+9quS2tSNIylCqhDKT+fsQNA
199AOelaqTMq7ziaQe8zvPjSuwDRvOrwL4gz4SGTcBT97zWK3XAZaovPnm1NfZ+g
fPa712H32wybmYHjl2tH
=sGDm
-----END PGP SIGNATURE-----

--=-Hr9gmR7S6sks1xlwv6Xr--

