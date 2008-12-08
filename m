Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYLHXCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 18:02:38 -0500
Subject: Re: [RFT] mac80211: clean up set_key callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>, Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Michael Buesch <mb@bu3sch.de>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <200812082353.58453.IvDoorn@gmail.com> (sfid-20081208_235401_851509_741F75A8)
References: <1228757035.22164.94.camel@johannes.berg>
	 <200812082353.58453.IvDoorn@gmail.com>
	 (sfid-20081208_235401_851509_741F75A8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sHxiiKbe6sJwrlDaZVG5"
Date: Tue, 09 Dec 2008 00:01:57 +0100
Message-Id: <1228777317.22164.150.camel@johannes.berg> (sfid-20081209_000241_789932_2D79E7A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sHxiiKbe6sJwrlDaZVG5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 23:53 +0100, Ivo van Doorn wrote:
> On Monday 08 December 2008, Johannes Berg wrote:
> > The set_key callback now seems rather odd, passing a MAC address
> > instead of a station struct, and a local address instead of a
> > vif struct. Change that.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> ACK for the rt2x00 changes,
> I'm especially happy with the ieee80211_find_sta() removal from rt2x00. :=
)
>=20
> I'll see if I can test this in a few days,

Thanks

> One small change request though.

> Please move this bit up a bit to merge it with the address if-statement:
>=20
> 	if (sta) {
> 		crypto.address =3D sta->addr;
> 		crypto.aid =3D sta->aid
> 	} else
> 		crypto.address =3D bcast_addr;
>=20
> that would group the sta dependencies together so we only need to check
> if sta is valid once.

Sure, changed, see my patches folder, will resend after more
comments/testing.

johannes

--=-sHxiiKbe6sJwrlDaZVG5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPadiAAoJEKVg1VMiehFYiQkP/R6LuF1OGaFNlLKdHNwMkwpD
Gsf33DGJhxmDA1MrEccsvr0np1rTKRdd81BWdR+Z5L9b1pxW8pgVk9v2+aI9kfpG
KlixZn9I29MSip7XBd8aGNHhWoaZBChjrOi9QTtzIEG+FF/L/AQeRP0k9wWjGb1k
YwxcLJjR15OdmhkAO9+I+5FAk1BDI0DOd1WzR2vJcEghqGos8sg2WORYuWGhsFBs
zfuv/Un1pzVBicH+Bud9kZr2xvxxhvsqtktWeqA42a4OF7uQhmzgxaaHoOeOb3bF
by4rBRNcvw/MUANSFc8WXVq14vDLFjqSueBFPsBY1G57sIvIGIB+OgW3i+0oEcjf
VWAY7g2zcOUBLCbY/+eSrvl8ttwlM2YvF+H4Q3N4sRXiGyqU/T6uVnhnemsa6X6H
/1B3dRnhxA05yhiYeh/mFYYPMBFw5osSolr7lw6zZyXYWlJEghWLvyXHGavSJHVO
SxlgA1GwpZrVtiOlNnSa//VNpM4I5pZReOV0PaP48eb5EZfMUyJzuXo94JCC4bTC
tjI47LI5Q7ll6UAXu+AIbuajkN1t2co6XmtzMD5ozFrJcDgTIJxY65Cumi2YwLoI
BhRaULy907Fu7hHrNMDaBB7WKbUdUsqfoaARnPJfvXV6ULgBW68zJ8ByO0doGkuV
UCeeLoGO/rXCAh5tca5+
=XHWX
-----END PGP SIGNATURE-----

--=-sHxiiKbe6sJwrlDaZVG5--

