Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZDTRde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 13:33:34 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1240248385.5260.15.camel@localhost.localdomain> (sfid-20090420_192718_984250_38AB6869)
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Hq8cgFaJd9heiAPo/LYW"
Date: Mon, 20 Apr 2009 19:32:53 +0200
Message-Id: <1240248773.4632.13.camel@johannes.local> (sfid-20090420_193340_676286_D83A3D7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hq8cgFaJd9heiAPo/LYW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > > wlan0: associated
> >=20
> > > wlan0: deauthenticated (Reason: 2)
> >=20
> > > wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=3D0x431 status=3D=
0 aid=3D2)
> > > wlan0: associated
> >=20
> > > wlan0: deauthenticated (Reason: 2)
> >=20
> > > wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=3D0x431 status=3D=
0 aid=3D2)
> > > wlan0: associated
> >=20
> > > wlan0: deauthenticated (Reason: 2)
> >=20
> > > Do you need anything else? I have really no idea what happens here an=
d I
> > > like to get it fixed.
> >=20
> > Can you do the kernel log with timing please? It seems strange to get
> > "previous authentication is no longer valid" from the AP as a reason
> > code while associated.
>=20
> I can try but I am not home anymore. So no promises. However it keeps
> happening in a pretty constant rate. Like every 2-5 seconds interval.

Ok. The thing I don't understand is why the AP would deauth you. And
with that reason code to boot.

> Could be the iwlagn driver for 5350 hardware doing something wrong here.
> And I also forced it to use sw_crypto.

I suppose I could try 5350. But I see no reason it would influence the
auth/assoc handshake.

> Do you have any ideas so far or want me to put some extra debug code in
> there. Not sure if I get that kernel up before tomorrow morning.

Sorry, not really. A parallel monitor capture might help:
	iw dev wlan0 interface add moni0 type monitor flags none
	ip link set moni0 up
	tcpdump -s 10000 -w /tmp/dump.pkt -i moni0 -p
	# now leave that running and do whatever as usual

johannes

--=-Hq8cgFaJd9heiAPo/LYW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7LHDAAoJEKVg1VMiehFYOsEP/3wkTav68EM8pcYQelp7Qfqx
NwyDJJ7PsFkL64f2fsW6rHFf6B+6kwuWBQPYJZf4jXTIJcEBdFzPc4Kst7kyOyG3
rGrUq/ev8G7qm6eRg7uaFiMt46y19G9TXZjnARbbHGcF8b156Rfb4CfFPFiuaOLL
QNepYw/jC0ooxKO491hI8ig3fZBt7fc1VIilutsHYwtBv5ZNqhasXsv+KkzyBnz7
6kGxpG7vVTtyErrymGz6dniB0QV7qWUlc5ZG3+IrrAVLMggVMyaJQjGHmYTYn/5d
7mLitwNChMS65LkJj8f60CWKibROzdELa7z/gNxipewpxO+8kHgNfLQBKV6i1Vil
ST1Xh342IoxUjqGXPj1W6DyWuGoa5XEuWstVJeAqO/ivNMW8nNgDnV8/tCMXr85w
NRt7Z5BU6ZsT0WCSBTgUZYGMOqA2+l/CQmZOuIVeMrIQJHD/+T3WhsRWcb0dDIQo
ZE5Co4I6HVWfawV6YbumJVuC53LN4AuH+syb+xvma20yXXvDhd2fH67EYMtvMpiz
iag4EJBqYFbpHKjjTNQwhEfX0bH8yyMuHCkgUjT2StW7e73JW4buy9RXtEYSYwC3
7H1Jy5kH2ibeGJOSLp6pmuoPLwMmn4msX4gz5GSdWtZT19imhsd/B2JHJjLUoHsC
vTF7dADXmusAbGtg8mrC
=A5Pq
-----END PGP SIGNATURE-----

--=-Hq8cgFaJd9heiAPo/LYW--

