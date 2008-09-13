Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYINHbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2008 03:31:48 -0400
Subject: Re: [BUG] latest changes in mac80211 & b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Artem Antonov <artem.v.antonov@gmail.com>
Cc: bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <6bc534830809131008s7011fd43g7a694caec50e6b48@mail.gmail.com> (sfid-20080913_190812_156748_27DE21A9)
References: <6bc534830809131008s7011fd43g7a694caec50e6b48@mail.gmail.com>
	 (sfid-20080913_190812_156748_27DE21A9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Lin360/FRZ6wi/VxjWb5"
Date: Sat, 13 Sep 2008 19:44:46 +0200
Message-Id: <1221327886.3700.13.camel@johannes.berg> (sfid-20080914_093153_425361_0FC25BA1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Lin360/FRZ6wi/VxjWb5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Please use linux-wireless, CC added.

> b43 doesn't work in AP-mode, hostapd print such errors:
>=20
> wlan0: STA 00:1b:fc:f2:49:b2 WPA: EAPOL-Key timeout
> WPA: 00:1b:fc:f2:49:b2 WPA_PTK entering state PTKSTART
> wlan0: STA 00:1b:fc:f2:49:b2 WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=3D2 secure=3D0 mic=3D0 ack=3D1 install=3D0 pairwi=
se=3D8
> kde_len=3D0 keyidx=3D0 encr=3D0)
> WPA: 00:1b:fc:f2:49:b2 WPA_PTK entering state DISCONNECT
> hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect:
> STA 00:1b:fc:f2:49:b2 reason 2
> WPA: 00:1b:fc:f2:49:b2 WPA_PTK entering state DISCONNECTED
> WPA: 00:1b:fc:f2:49:b2 WPA_PTK entering state INITIALIZE
> wlan0: STA 00:1b:fc:f2:49:b2 IEEE 802.1X: unauthorizing port
> Could not set station 00:1b:fc:f2:49:b2 flags for kernel driver (errno=3D=
124).
> wlan0: STA 00:1b:fc:f2:49:b2 IEEE 802.11: deauthenticated due to local
> deauth request

That makes no sense at all, but that's because you snipped the log so
much that the actual problem is gone.

The actual problem seems to be that we're sending those EAPOL frames
encrypted, I'll take a look tomorrow or Monday.

johannes

--=-Lin360/FRZ6wi/VxjWb5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIy/wJAAoJEKVg1VMiehFYfIgP/3nlCIevviJ5Fu6Cfayb7Uez
DfozqiUEGN5zIq78J/6WLOyHdw1TXfwu5O/tFKCt6xcMZDGJbfOydglC5zzanP2x
jUQPZockNLTmKpuifj/CSsQhn93TN5SJQAt79DWTazq1c9LllTESIxoirlWTs4mo
mOy1Ve4msc+p4cLdIdFQQbrjSnypxNNe3FK7FoENRG92zzY5H4TniMbePbag/i7A
ox718aQduj0MLjTUW6zNNAq7fXj/9iA4a7DQu0ciqBfcrVmii8QkaGxZZ4NPqXGv
anZeCZX3lq48X0WnqR6bKwpNS5+mCr6FyrKXtiHhGxz4t+/qiDoahG3T+eDSL29R
3fMhqFHGYhHiZNQliAeL6/Rv8arlssvV/Vj7tTnOJqGNcHJOJgzQLAYwQM46ac2D
VERfoOp2WlSTYEZMfYzjS0IV5/0WWM6MMlml663jSsYp7BqGL3qE8UI1c+uxAhSM
EahSvDEyLdoIeI7G7on/SL4odOr90pCQyVkWyloCTH3FBW7p/Td1RnOpIHyEmQQI
eFNSL2uAVatysWpdkiSelLj7oeAIRfvPgCOmYAMAcwqnOIxrxKi5VjACoSzuzVtz
Ji9X60TVOgB5E7NRDK2A+Y6+XYHu2jsoBdBCUP0+RQ6bWRHzpj5qZGyY/JdtYv9/
oEVdFmAWz0ApKhn9gowf
=cSg6
-----END PGP SIGNATURE-----

--=-Lin360/FRZ6wi/VxjWb5--

