Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZBRO0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 09:26:18 -0500
Subject: Re: Missing link quality with wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>, Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1234961297.13950.55.camel@localhost>
References: <1234899806.29785.35.camel@johannes.local>
	 <1234902294.4678.12.camel@californication>
	 <1234904111.29785.44.camel@johannes.local>
	 <1234904978.4678.31.camel@californication>
	 <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net>
	 <1234933059.21412.28.camel@californication>
	 <20090218073104.GA23366@jm.kir.nu>
	 <1234944391.21412.47.camel@californication>
	 <20090218082520.GA26280@jm.kir.nu> <1234959523.13950.47.camel@localhost>
	 <20090218123301.GA6152@jm.kir.nu>  <1234961297.13950.55.camel@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+EEEQUc7vdtFYF1pmh+5"
Date: Wed, 18 Feb 2009 15:25:44 +0100
Message-Id: <1234967144.4023.25.camel@johannes.local> (sfid-20090218_152622_186866_AE856FFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+EEEQUc7vdtFYF1pmh+5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-18 at 07:48 -0500, Dan Williams wrote:

> > >   - max_qual.level =3D=3D 0 (ie, dBm values)
> >=20
> > That is an area where NM (=3D 0) and mac80211 (=3D -110) do not agree.
>=20
> Then mac80211 is not conforming to WEXT...  unless it's setting
> IW_QUAL_DBM in the updated field, which it probably is.

Yeah, it is.

> Before we added IW_QUAL_DBM, the switch between dBm and RSSI was
> max_qual.level; if it was 0, level was in dBm, because no cards in use
> in Linux at that time could support a signal of more 0 dBm.  Thus, if it
> was over 0, the value was in RSSI.
>=20
> Here's the relevant bit of wireless.h:
>=20
>         /* Quality range (link, level, noise)
>          * If the quality is absolute, it will be in the range [0 ; max_q=
ual],
>          * if the quality is dBm, it will be in the range [max_qual ; 0].
>=20
> That doc never got updated for IW_QUAL_DBM either.

Fun. But what did I expect. I withdraw my earlier patch then.

> NM doesn't really handle IW_QUAL_DBM (added in WE-19).  Mainly because
> stuff worked without it, and it wasn't implemented in drivers until
> quite recently.  NM should handle IW_QUAL_DBM.

Does all that mean that we cannot actually get this working right now
without adding back qual.qual? Or should we just remove IW_QUAL_DBM?

johannes

--=-+EEEQUc7vdtFYF1pmh+5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnBplAAoJEKVg1VMiehFYE5wP/2mU3X4NougqO1G23qUOe0zr
aAmy5eClJMW49ruDRFPOexRxtWPhKXokGm9czvlvcG7ivJOkgSRmR1bhgYlc4/CV
4WslpDxrbE9aVz68avq+g+rKNM7mvIAEM7DR85EGoAhMUuT926ZMUvU/yaMcKaBC
bB8BprDmbIyS2IWp7e/JHTTu54FB2yzgoOMbI+U7H8Ao/lNDMLKmeE8bxHrV9ItF
JD366CSfdlcPTuSPl37CyqryMNHEt6IslotnStT9RWBpvaD+PBvjHd5pHO4ywV4Y
F9VgnZ1x0ShKfDJA6GnnP9LNpVfZI8Q+pz7Ui5DvgelLiHgYwkQG+vgpWAukqZ3J
U22XSXpvZQPASbBat2S91g1emP4G3UHg7XwtCJ4z8+6LZX/5Xvf+ll0ZSpTfTkmH
tj5laksIc10OwUHoef86aoYKqJD0kUBENK5aS99WHURwb1nVOfaUaDiVRkY6c6sJ
7OqBn/iNofx8UWJFiaIRjxjkGdehLjPGM8ygJIpyX1/yjmQe0LWcwHNgf7yrh8wF
7W+WNsTLRJb5H+t6WNct5NJfUq1HL2crRzQ6LPWGS6uCbfTott2LBleArJkNUbxg
5iuBUKJWqEu4YqxaNV5qcNna9Ho+Xj7wmUn0pDYXysKmkb7ZDtNAcSWqjS5dU1Aw
ePOfgxuMZxdjrY3P3jsr
=bW1m
-----END PGP SIGNATURE-----

--=-+EEEQUc7vdtFYF1pmh+5--

