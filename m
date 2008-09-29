Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYI2Qpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 12:45:40 -0400
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20080929163147.GC4853@jm.kir.nu>
References: <48E0A65A.2060102@gmail.com>
	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu>
	 <1222683923.7064.18.camel@johannes.berg>  <20080929163147.GC4853@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4wIvLQihfGuCRWWz8rdP"
Date: Mon, 29 Sep 2008 18:45:34 +0200
Message-Id: <1222706734.7064.40.camel@johannes.berg> (sfid-20080929_184543_558849_F5CAB841)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4wIvLQihfGuCRWWz8rdP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-29 at 19:31 +0300, Jouni Malinen wrote:

> Well.. It reports channels like 2732 MHz or 6100 MHz and 5 GHz center
> frequencies for every possible multiple of 5 MHz. If someone is really
> using those properly, they are on a licensed band and this types of
> lists are not really needed for normal users. Whether the hardware
> really supports them or well, more exactly, whether all selected
> components can handle these frequencies and whether the radios have been
> calibrated for all of these areas is another question.

Good points. I hadn't looked at the list at all.

> > > > > There is also a bug in hostapd which waits for ACK forever when t=
his error occur
> > > > > in i802_get_hw_feature_data().
>=20
> For some reason, I do not seem to be able to reproduce this. Both iw and
> hostapd were able to fetch the data using the current wireless-testing
> tree..

Probably depends on something about alignment or whatever, not sure. Or
you have different hardware and the driver reports different things for
different hw? Anyway, it shouldn't wait forever, and my patch fixes
that.

> > I recently rewrote the handling in iw completely to make it easier to
> > follow, will post an equivalent patch for hostapd in a minute.
>=20
> Anyway, cleanup for nl send/recv processing is certainly welcome. I've
> never fully understood the steps that are used there and what to do if
> anything went wrong..

I see you applied that, it should be ported to the wpa_supplicant driver
too, I think.

johannes

--=-4wIvLQihfGuCRWWz8rdP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4QYqAAoJEKVg1VMiehFYgIQQALpnzDXfuZfCJbkWJr0IOP0E
v0aKNTri6rRVOft0BXsMZWQjyLL4Ahu9bOLCKdfbdDd9hKatFi50qpfvRUHR+paB
bd6u8MCj905Gi6Be0inE7nCAyqtvrtMwiZNiEsSo8GjRFtlJE+2i3kY95BwtdgnS
543jAiBBT5FhwjEwb5w1rHJ7OfO9KqlEitOnG6JHyagFc1hdFR/2bW3BkIQmdyX9
B10qtMeMrpSUFiFPOR4gr5u4f9UeC/tAM55W1zyPOgatQHbGaYAW3WNKBiYaDo6N
ryyOF2jxCAtN0rc9SdmxpRHb+DtZZC0ZCbzF4gBAwEqBG+3y1RthXTEcOuuZ0SPh
0PC+tb32kRQe0Hht09lk6WGMgm4sU2WrauhqsQUiNhpyt1kkcfD2KCy44S0yMaoo
tB4NpUC0WMe31cq/QXwnPdN6O5GXpvrqlUsclNDopdN/roD9lydTLYFnHHqMEjmR
PZEh78oYg46CKYIaTFWkpAUieWAuL8d1pD3AsF4d63oJ9IhJouxkw8GEMkCDChkf
44TXnwCUJIrvuLS9ESamjCSMRYpIwDnHHa5wm166SqYYmQTBDQxYAkzYgIe1Kao4
iehhd7OYlvEqcXVHtQRsR8te2ogbVteP9I5MaZMgWKZwLq8HFnIiUz0WVHaufRkb
ej4E+K9EK6Rvuit6ehPO
=WkU7
-----END PGP SIGNATURE-----

--=-4wIvLQihfGuCRWWz8rdP--

