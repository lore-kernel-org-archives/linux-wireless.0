Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbXKGPfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 10:35:30 -0500
Subject: Re: Regression in latest wireless-2.6: commit 43c8321e breaks rate
	control
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4731D9CC.3090809@lwfinger.net>
References: <4731D9CC.3090809@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mAZ/nlc7GYfCp7h0FWns"
Date: Wed, 07 Nov 2007 16:36:45 +0100
Message-Id: <1194449805.4470.43.camel@johannes.berg> (sfid-20071107_153535_660731_CAFCB23C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mAZ/nlc7GYfCp7h0FWns
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-11-07 at 09:29 -0600, Larry Finger wrote:
> Commit 43c8321e breaks rate control, and my b43 device, on wireless-2.6/e=
verything. The hack below
> fixes it:
>=20
> Index: wireless-2.6/net/mac80211/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-2.6.orig/net/mac80211/Kconfig
> +++ wireless-2.6/net/mac80211/Kconfig
> @@ -16,7 +16,7 @@ config MAC80211
>  config MAC80211_RCSIMPLE
>         bool "'simple' rate control algorithm"
>         default y
> -       depends on MAC80211 && EMBEDDED
> +       depends on MAC80211
>         help
>           This option allows you to turn off the 'simple' rate
>           control algorithm in mac80211. If you do turn it off,
>=20
> On my system, the symbol EMBEDDED is not defined, thus rcsimple, the only=
 rate-control mechanism I
> need to use, is not built.

Ahrg. I'm stupid. I meant for this to be only selectable on EMBEDDED.
How do I do that?

johannes

--=-mAZ/nlc7GYfCp7h0FWns
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzHbjKVg1VMiehFYAQKfKQ//Xko/hZn3e6+pz6iWRDkgTWHkpNvvo5Kl
/BiOuiLqtP+vPh2/Lw+uebkDYXbYM0+P/KzWMjadMYMyaIlb+FtQtTpSvYnpB3/K
2JdQjOFSigM1DUVNwkHCZbx7suQmen42EyRfZhA95V5VLKO19OweFmQnY1PkIYdP
nRu4YqFbjywdwBGGXw8s3bzYBBOsoybajQT4Njp/fzzyk/1VNmIQ9i1ZqT5z9Awj
IDX/fVhoeE8IA1Aqf/Bfbmt0t7jrlUBBGvTZl5jqnFmskjqGPHuJwHOdhcg5H5gF
ELjWX+UKY8vsUjj99fH/bTubc14lfjQrMKGKK6JBhXmr7EPmaBQzWQbOh7zfUH/V
W7vFzFe2Qd/8+sSLQ/hNxhorXW8dNySuKZ9+CIa+zAvhOT4XsoraUjK+oK1P3C66
eigZ9M5Bxb3bzWeBcRFiTIH2ujMlBgEbMQEtRr9ksBCr/SDowZO3ajIz1Q7muAlQ
1ylNqoMyPPC7zj5AHr/BXC+cmispyg91nsYo2ZihWogHJ9lbIISvzxAO/cDbgKf0
ZsPvXc2PO8R4s3tZqF/SYaPgpeVGSHlYnpat23JKOMKhtJmgfVzZU1YqKYaA4xro
7WbTreLmfm7SE9gEbangr1S6j8pNKMEs5dl7yYnB69cklbnvol35X1SxmLPC/WsP
8zkhbvAIP14=
=4bk0
-----END PGP SIGNATURE-----

--=-mAZ/nlc7GYfCp7h0FWns--

