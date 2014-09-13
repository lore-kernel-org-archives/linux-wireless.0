Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57385 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbaIMGEY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2014 02:04:24 -0400
Message-ID: <5413DE51.3080200@rempel-privat.de> (sfid-20140913_080436_070573_A2A57066)
Date: Sat, 13 Sep 2014 08:04:01 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_common: fix random decryption failure
References: <20140912203651.GA10815@sig21.net>
In-Reply-To: <20140912203651.GA10815@sig21.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NUwuiTHK6hGJ58PgxsCdGMOc8OmPTk7Xu"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NUwuiTHK6hGJ58PgxsCdGMOc8OmPTk7Xu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 12.09.2014 um 22:36 schrieb Johannes Stezenbach:
> In v3.15 the driver stopped to accept network packets after successful
> authentification, which could be worked around by passing the
> nohwcrypt=3D1 module parameter.  This was not reproducible by
> everyone, and showed random behaviour in some tests.
> It was caused by an uninitialized variable introduced
> in 4ed1a8d4a257 ("ath9k_htc: use ath9k_cmn_rx_accept") and
> used in 341b29b9cd2f ("ath9k_htc: use ath9k_cmn_rx_skb_postprocess").
>=20
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D78581
> Fixes: 341b29b9cd2f ("ath9k_htc: use ath9k_cmn_rx_skb_postprocess")
> Signed-off-by: Johannes Stezenbach <js@sig21.net>
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_txrx.c
> index bb86eb2..f0484b1 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -978,7 +978,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv =
*priv,
>  	struct ath_hw *ah =3D common->ah;
>  	struct ath_htc_rx_status *rxstatus;
>  	struct ath_rx_status rx_stats;
> -	bool decrypt_error;
> +	bool decrypt_error =3D false;
> =20
>  	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
>  		ath_err(common, "Corrupted RX frame, dropping (len: %d)\n",
>=20

ACK.

--=20
Regards,
Oleksij


--NUwuiTHK6hGJ58PgxsCdGMOc8OmPTk7Xu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlQT3lcACgkQHwImuRkmbWm0MQD/RmA2aRPvaGmcjT8jmrWmw1ka
uy2K/X+224RRrRmt4ZoA/RDfS0+oNKbCj9uju4dzFNwFruxS3hUqTi6tLIWkHiVY
=XNCH
-----END PGP SIGNATURE-----

--NUwuiTHK6hGJ58PgxsCdGMOc8OmPTk7Xu--
