Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61399 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbcAATPD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 14:15:03 -0500
Subject: Re: [PATCH 1/2] net-ath9k_htc: Delete an unnecessary variable
 initialisation in ath9k_hif_usb_rx_stream()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Kalle Valo <kvalo@codeaurora.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686C390.5060600@users.sourceforge.net>
 <5686C42A.5000405@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <5686D026.6000706@rempel-privat.de> (sfid-20160101_201540_261300_39EFFE71)
Date: Fri, 1 Jan 2016 20:14:46 +0100
MIME-Version: 1.0
In-Reply-To: <5686C42A.5000405@users.sourceforge.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8WhpjSiebErDkk2wTiJrdvjCVeaF7cdQR"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8WhpjSiebErDkk2wTiJrdvjCVeaF7cdQR
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 01.01.2016 um 19:23 schrieb SF Markus Elfring:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 1 Jan 2016 19:00:53 +0100
>=20
> Omit explicit initialisation at the beginning for one local variable
> that is redefined before its first use.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wir=
eless/ath/ath9k/hif_usb.c
> index 165dd20..51bd61b 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -525,7 +525,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_devi=
ce_usb *hif_dev,
>  				    struct sk_buff *skb)
>  {
>  	struct sk_buff *nskb, *skb_pool[MAX_PKT_NUM_IN_TRANSFER];
> -	int index =3D 0, i =3D 0, len =3D skb->len;
> +	int index =3D 0, i, len =3D skb->len;
>  	int rx_remain_len, rx_pkt_len;
>  	u16 pool_index =3D 0;
>  	u8 *ptr;
>=20


Reviewed-by: Oleksij Rempel <linux@rempel-privat.de>

--=20
Regards,
Oleksij


--8WhpjSiebErDkk2wTiJrdvjCVeaF7cdQR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlaG0CYACgkQHwImuRkmbWmDhAD+KNPibYR3y8scvydLtCLRK6Im
gug4CSunNSk9VLB7NmsA/RdOCOMFBzf9KhnRFhdFDyP7RxRTyCDmKKiyjXmhgigV
=FDRM
-----END PGP SIGNATURE-----

--8WhpjSiebErDkk2wTiJrdvjCVeaF7cdQR--
