Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59980 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYKXNiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 08:38:08 -0500
Subject: Re: p54: AP mode: no data frame despite traffic indication set in
	TIM
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Chr <chunkeey@web.de>
In-Reply-To: <f76a32050811210612i13ee251ewd6c1cab616a62529@mail.gmail.com> (sfid-20081121_151226_825613_6BD7F761)
References: <f76a32050811210612i13ee251ewd6c1cab616a62529@mail.gmail.com>
	 (sfid-20081121_151226_825613_6BD7F761)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ir55+/dpiGxh1LK5ImRy"
Date: Mon, 24 Nov 2008 14:37:54 +0100
Message-Id: <1227533874.2927.2.camel@johannes.berg> (sfid-20081124_143812_530218_CA2F202E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ir55+/dpiGxh1LK5ImRy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-21 at 15:12 +0100, Stefan Steuerwald wrote:

> - frame 7: http request
> - frame 13: iPod goes to sleep
> - frame 23: AP beacon indicates traffic for iPod (AID 1 in TIM)

in 24 too, the ipod probably didn't see the beacon in frame 23 even
though 23 was a dtim beacon (which is a bit odd, but maybe the ipod
doesn't care about mcast at this point)

> - frame 25: iPod wakes up

26: ack from the AP

> - in between: MISSING DATA ???
> - frame 27: AP beacon with no traffic indicated ???
> - frame 29: iPod goes to sleep again
> - subsequent frames: repetitions of this, until the TCP connection is clo=
sed
>=20
> My understanding is that the AP would not indicate any traffic without
> actually having some ready to send? Wrong assumption?

Indeed. Christian, is it possible that the p54 device is actually
filtering these frames? I'm pretty sure mac80211 behaves correctly, and
it unsetting the TIM bit means that it must no longer have traffic
buffered.

johannes

--=-ir55+/dpiGxh1LK5ImRy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKq4tAAoJEKVg1VMiehFYXycQAI0yOzAtBQ6wddQdAUwnF96F
ZESWVu20YKdNNjPUjwK+v9GyW8DWvflP96DT3KKH8LscqMQCTxkFcYkgnfL4nsAb
2qJbCw6A/01Y41RoJ+DIYsL4TKyQV+FFy4kITGPa+/Qe07QsKbuGVbCldcBiSoTI
FTQj8jK9q7KO2tC4s9rl15AJ1PZ+uWDZUficxFpSE+7DtmCYNTr7vubrDLbkP4lq
+0wNmjtA603g3XgrU42Tp8Q9tJkzo81SrDfBor4zq74ks2ENDJ0cCp2tAnhlNe5p
6X3okDGiMgv1LReqBXj/6+D/Q6VOZ1ZN83HMPqHm3gxC41RYuvlFaSzhKpwEvFU/
t8dKj6LJ2qT1GWfcLZ3roz+flIWtJ/MLQbxMOl4IIlwXuA1ySpyf7GT8o/zZIbQZ
DxFGhPhcb2z+QCX6c+lKLINu1lpYdaSbs38CtuqO32wqnpVuyBLOQ96HUS2vfp4l
TWKiE4nLJQGQYCY2SuQVKfBMWnPcDyBiRQgvxDl2KBaaOgSm6YOBHTdDq7/ts9QU
X7D4N9Cjyf4frowzmm80H7jLZcbDeFGcFCKzuyBkcybpLGLSGW6jepdG+z5ZKana
uwMmzeSXibeDPN89ye70cQn0SzbJmViyM7clqmtdM3xZq6hYWBx7KNgAoAHQX9pH
hFYpeSbKDTXUwQLanZU+
=qFIs
-----END PGP SIGNATURE-----

--=-ir55+/dpiGxh1LK5ImRy--

