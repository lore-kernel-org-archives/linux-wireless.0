Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45028 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbeGaWCr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 18:02:47 -0400
Date: Tue, 31 Jul 2018 21:14:04 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: b43/leds: Ensure NUL-termination of LED name string
Message-ID: <20180731211404.2eac1bb0@wiggum> (sfid-20180731_222049_365783_C9175DC4)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/EN90ciRq4eWXDUcnZABQ0Ak"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/EN90ciRq4eWXDUcnZABQ0Ak
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

strncpy might not NUL-terminate the string, if the name equals the buffer s=
ize.
Use strlcpy instead.

Signed-off-by: Michael Buesch <m@bues.ch>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/broadcom/b43/leds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/leds.c b/drivers/net/wireles=
s/broadcom/b43/leds.c
index cb987c2ecc6b..87131f663292 100644
--- a/drivers/net/wireless/broadcom/b43/leds.c
+++ b/drivers/net/wireless/broadcom/b43/leds.c
@@ -131,7 +131,7 @@ static int b43_register_led(struct b43_wldev *dev, stru=
ct b43_led *led,
 	led->wl =3D dev->wl;
 	led->index =3D led_index;
 	led->activelow =3D activelow;
-	strncpy(led->name, name, sizeof(led->name));
+	strlcpy(led->name, name, sizeof(led->name));
 	atomic_set(&led->state, 0);
=20
 	led->led_dev.name =3D led->name;

--=20
Michael

--Sig_/EN90ciRq4eWXDUcnZABQ0Ak
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAltgtPwACgkQ9TK+HZCN
iw7tBg/+LGsZjn1GzI/dqnSPndpv+nmtgj4Td83sTf3TtJehgPL9XfWShljsPL+c
MkEd2kAfeQgG//Z6eCUqJWy5Qyj28XcZwctx+VgGBnynvOC6DV14M8JaZenbFILV
8dubwqO6oLqllo4hUz+nREKesciF6089kyFjHkz89XAs7WD5UCwg3+ZLzTSpL5Ua
511UzMv0awoxnEkyWO4lKiXAjJDuewTtyK3QfMTShQpEcgUHpAc5d/gpW8XOmaD6
IGUVXBugxVwAGOd9iQkkyDSPcJLQp61EOAKxbsDAdNAPoSw/+2rWDmbpBIKcOIVv
UA/nkDqzJGMlZ5oVDvBHI/I88fRxDh+CktrLogBSkOTToidqcXcwU1u6Oz2kypne
MIj+yq2N7HZTbdMtXmy3z/Pl+kbThiuK3YLJv28KTKwO9PPLacfMVsZ9yR5G3oqN
JjuTD9MWQ1kdYhutHsZ0EMBIAw/AkDaStCSn48PNEch8+qOPnQ7rM+CcCsNFEHXS
MdlY4z7Qy0RDoAoHJc83TylWvLELGfzJ9d+YdOzP9FR45rTCFXDpPeJAlJriaNVK
Z8fBL/5OWu50diWsU35N0WWNdK9meueklQH6cfNOMQIKNxCuZ39HJNB+eu6g5ark
wze7be0lqaJJpkn8ixvw/JK98T647rThPCHt5xhLtb02P7B8J/c=
=nW4O
-----END PGP SIGNATURE-----

--Sig_/EN90ciRq4eWXDUcnZABQ0Ak--
