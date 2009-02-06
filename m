Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50041 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZBFUkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 15:40:32 -0500
Subject: Re: turning off IBSS (with wext)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1233938496.28437.10.camel@localhost>
References: <1233928622.4175.9.camel@johannes.local>
	 <1233938496.28437.10.camel@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wZLQVNwBiPO5Pki/g4GI"
Date: Fri, 06 Feb 2009 21:40:26 +0100
Message-Id: <1233952826.4175.21.camel@johannes.local> (sfid-20090206_214035_890181_70D289B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wZLQVNwBiPO5Pki/g4GI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-06 at 11:41 -0500, Dan Williams wrote:
> On Fri, 2009-02-06 at 14:57 +0100, Johannes Berg wrote:
> > Hi,
> >=20
> > so I was testing IBSS, and found this strange behaviour:
> >=20
> >  * wpa_supplicant (or NM?) will try to do SIWMLME(disassoc) in IBSS
> >    mode, which seems kinda wrong. Why do we accept it? We send out a
> >    frame and then do nothing else.
> >  * Then I thought "iwconfig wlan1 essid off" - but that fails with
> >    -EINVAL due to ieee80211_sta_find_ibss
> >=20
> > It seems to me that either one of those, or both, should actually turn
> > off beaconing.
>=20
> Either one; the supplicant uses SIWMLME(disassoc) at various times (like
> when leaving a BSS), and NM will sometimes set a NULL SSID when
> deactivating the device.

Fun. Neither one actually works.

johannes

--=-wZLQVNwBiPO5Pki/g4GI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjKA3AAoJEKVg1VMiehFYG3QP/REUJ/5IusLAGwG6qv7NaQgA
UBv5MXAS3uSUKOWqtwoCd/8jx/PcAspP1h+UvSVQxo3HhdZGQEmi7QRWDbRSONrH
y975CpV9hYfwbIzQYJS0VvsuRu4YhEJGP/D/cbeGSJ5ZgIFfZTa2QHJbks3I+gaW
i0jcaAOxIzKzYNKu5Vsr9LoIzU4mIaSmBW27NLrNlRiqv9WrmM8ZVTtJtv2DqA59
CBDOoWDiAfs4xqnO94QCVY0AgOYNnjQBWH34VmxHzzy/ngX9rcvl02XA9GG4Ryaz
pgEIYyJAky3mm1ORAMv11gC0x7Qk3jHKCQobwIPsybkmdPHbmvQ/wrLprTGBGK3c
Szqb9TGRBwPRpY5x58rBB55o0vsWp1mP9QJt/r6rYjBAjPOf7/UmeRh6jlV7/YWV
szSgerbFACGuNFDz3K+COxoaETPLwy+UHRrGz+hdJwnYLgnDrFL39LoI9JK0X6t0
0FhtDxrZvd2gZyZjrC+H2riETLvt7hOwnxYtZbt/5dQs6zy6vlvJznfazpBcfKlS
Vxex6eZRDH2fZbjRQchEYCRGPy9dqhucxuvpzCxs6W2rngN3I7iiNES/fXLH4CPz
1LlnoaNHPjqEvKQFiCTQR4OPAy1M1VPN/09+JaNs8eJQK5vuMhybfRzi3c8nX5CZ
2wjEw2tdD7rzz0mslDff
=/R2L
-----END PGP SIGNATURE-----

--=-wZLQVNwBiPO5Pki/g4GI--

