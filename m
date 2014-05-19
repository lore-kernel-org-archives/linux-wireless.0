Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62374 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaESV3E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 17:29:04 -0400
Message-ID: <537A778A.5050205@rempel-privat.de> (sfid-20140519_232908_650147_94CF4A98)
Date: Mon, 19 May 2014 23:28:42 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
CC: ath9k-devel@venema.h4ckr.net,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k_htc: use 'struct ath_htc_rx_status
 *' in call to ath9k_htc_err_stat_rx
References: <1400533670-23340-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1400533670-23340-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HckFU4CN0dFARh4fg7gDjWB1OABgrwTvR"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HckFU4CN0dFARh4fg7gDjWB1OABgrwTvR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 19.05.2014 23:07, schrieb John W. Linville:
>   CC [M]  drivers/net/wireless/ath/ath9k/htc_drv_txrx.o
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function =E2=80=98ath=
9k_rx_prepare=E2=80=99:
> drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1006:2: warning: passing =
argument 2 of =E2=80=98ath9k_htc_err_stat_rx=E2=80=99 from incompatible p=
ointer type [enabled by default]
>   ath9k_htc_err_stat_rx(priv, &rx_stats);
>   ^
> In file included from drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:17:=
0:
> drivers/net/wireless/ath/ath9k/htc.h:380:20: note: expected =E2=80=98st=
ruct ath_htc_rx_status *=E2=80=99 but argument is of type =E2=80=98struct=
 ath_rx_status *=E2=80=99
>  static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Compile-test only...seems reasonable?

Hm... that is incorrect. Some missing patch?
"[PATCH 06/10] ath9k & ath9k_htc: move ath_rx_stats to cmn" did correct
change.
your patch will brake it.




>=20
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_txrx.c
> index bb86eb2ffc95..c1490ddc2965 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -1003,7 +1003,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_pri=
v *priv,
>  	/* Copy everything from ath_htc_rx_status (HTC_RX_FRAME_HEADER).
>  	 * After this, we can drop this part of skb. */
>  	rx_status_htc_to_ath(&rx_stats, rxstatus);
> -	ath9k_htc_err_stat_rx(priv, &rx_stats);
> +	ath9k_htc_err_stat_rx(priv, rxstatus);
>  	rx_status->mactime =3D be64_to_cpu(rxstatus->rs_tstamp);
>  	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
> =20
>=20


--=20
Regards,
Oleksij


--HckFU4CN0dFARh4fg7gDjWB1OABgrwTvR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlN6d5EACgkQHwImuRkmbWkPUAD/QS00/7wNBJpDO+IH0Ia4h7Ko
5rYkhopt6N+/6Y3+q8EA+wQOZTqK94tzLmot3USbKGS3wlITMkxke+iTpTGsECHo
=RfRq
-----END PGP SIGNATURE-----

--HckFU4CN0dFARh4fg7gDjWB1OABgrwTvR--
