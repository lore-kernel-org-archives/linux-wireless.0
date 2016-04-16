Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58729 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbcDPQIL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 12:08:11 -0400
Subject: Re: [PATCH] ath9k: remove repetitions of mask array size
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
References: <1460818477-22785-1-git-send-email-me@bobcopeland.com>
Cc: ath9k-devel@lists.ath9k.org, Kalle Valo <kvalo@codeaurora.org>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <57126340.1090204@rempel-privat.de> (sfid-20160416_180845_214551_B4DB5980)
Date: Sat, 16 Apr 2016 18:07:28 +0200
MIME-Version: 1.0
In-Reply-To: <1460818477-22785-1-git-send-email-me@bobcopeland.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="22XCQRPNvXPmM8VvdBEseRl5sPsfKuhgV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--22XCQRPNvXPmM8VvdBEseRl5sPsfKuhgV
Content-Type: multipart/mixed; boundary="CAE2MBjl9QhliDrDfkJMDHQmNg4qBXBPF"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, Kalle Valo <kvalo@codeaurora.org>
Message-ID: <57126340.1090204@rempel-privat.de>
Subject: Re: [PATCH] ath9k: remove repetitions of mask array size
References: <1460818477-22785-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1460818477-22785-1-git-send-email-me@bobcopeland.com>

--CAE2MBjl9QhliDrDfkJMDHQmNg4qBXBPF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thank you!

Kalle should be in CC.

Am 16.04.2016 um 16:54 schrieb Bob Copeland:
> The constant "123", which is the number of elements in
> mask_m / mask_p, is repeated several times in this function.
>=20
> Replace memsets with array initialization, and replace a loop
> conditional with ARRAY_SIZE() so that we don't repeat ourselves.
>=20
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Reviewed-by: Oleksij Rempel <linux@rempel-privat.de>

> ---
>  drivers/net/wireless/ath/ath9k/ar5008_phy.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/=
wireless/ath/ath9k/ar5008_phy.c
> index 1b271b9..8eea8d2 100644
> --- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
> @@ -260,8 +260,8 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,=

>  	int cur_bin;
>  	int upper, lower, cur_vit_mask;
>  	int i;
> -	int8_t mask_m[123];
> -	int8_t mask_p[123];
> +	int8_t mask_m[123] =3D {0};
> +	int8_t mask_p[123] =3D {0};
>  	int8_t mask_amt;
>  	int tmp_mask;
>  	static const int pilot_mask_reg[4] =3D {
> @@ -274,9 +274,6 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,=

>  	};
>  	static const int inc[4] =3D { 0, 100, 0, 0 };
> =20
> -	memset(&mask_m, 0, sizeof(int8_t) * 123);
> -	memset(&mask_p, 0, sizeof(int8_t) * 123);
> -
>  	cur_bin =3D -6000;
>  	upper =3D bin + 100;
>  	lower =3D bin - 100;
> @@ -302,7 +299,7 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,=

>  	upper =3D bin + 120;
>  	lower =3D bin - 120;
> =20
> -	for (i =3D 0; i < 123; i++) {
> +	for (i =3D 0; i < ARRAY_SIZE(mask_m); i++) {
>  		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
>  			/* workaround for gcc bug #37014 */
>  			volatile int tmp_v =3D abs(cur_vit_mask - bin);
>=20


--=20
Regards,
Oleksij


--CAE2MBjl9QhliDrDfkJMDHQmNg4qBXBPF--

--22XCQRPNvXPmM8VvdBEseRl5sPsfKuhgV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlcSY0AACgkQHwImuRkmbWlBGwEAhi1KIGktHpX1iN9TU+Pa+I6z
cjtNKnF/a5gFv4FNQlMA+wZAU9cAhtlPeNZ3M1DZkv1BYzIGULEBe4eqdaQNCvpl
=yW3s
-----END PGP SIGNATURE-----

--22XCQRPNvXPmM8VvdBEseRl5sPsfKuhgV--
