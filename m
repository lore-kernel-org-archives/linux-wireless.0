Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:65388 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbaKNIyg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 03:54:36 -0500
Message-ID: <5465C333.7030704@rempel-privat.de> (sfid-20141114_095440_054649_3BC2FD75)
Date: Fri, 14 Nov 2014 09:54:11 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [PATCH] ath9k_htc: turn on software mgmt crypto for secured mesh
References: <1415941631-24140-1-git-send-email-yeohchunyeow@gmail.com>
In-Reply-To: <1415941631-24140-1-git-send-email-yeohchunyeow@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KH2QEF5okBRP3avR8TDEum2Qi7h2McEFA"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KH2QEF5okBRP3avR8TDEum2Qi7h2McEFA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 14.11.2014 um 06:07 schrieb Chun-Yeow Yeoh:
> Secured mesh encrypts the unicast mgmt frame using the same
> key that used for encrypting the unicast data frame. The patch
> "ath9k_htc_firmware: fix the offset of CCMP header for mesh
> data frame" applied to open-ath9k-htc-firmware allows the
> ath9k_htc to be loaded without "nohwcrypt=3D1". Unfortunately,
> this is not working and we still need CCMP encryption of
> management frames to be done in software. Fix this.
>=20
> This patch is tested with the following hardwares:
> - TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]
> - AR9271 802.11n
>=20
> and managed to work with peer mesh STA equipped with ath9k.
>=20
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_main.c
> index 689ac99..d3f65a2 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -1447,7 +1447,8 @@ static int ath9k_htc_set_key(struct ieee80211_hw =
*hw,
>  			key->flags |=3D IEEE80211_KEY_FLAG_GENERATE_IV;
>  			if (key->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP)
>  				key->flags |=3D IEEE80211_KEY_FLAG_GENERATE_MMIC;
> -			if (priv->ah->sw_mgmt_crypto &&
> +			if ((vif->type =3D=3D NL80211_IFTYPE_MESH_POINT ||
> +			     priv->ah->sw_mgmt_crypto) &&
>  			    key->cipher =3D=3D WLAN_CIPHER_SUITE_CCMP)
>  				key->flags |=3D IEEE80211_KEY_FLAG_SW_MGMT_TX;
>  			ret =3D 0;
>=20


Hmm.. may be we should generally do it here:
        if ((vif->type =3D=3D NL80211_IFTYPE_ADHOC ||
             vif->type =3D=3D NL80211_IFTYPE_MESH_POINT) &&
            (key->cipher =3D=3D WLAN_CIPHER_SUITE_TKIP ||
             key->cipher =3D=3D WLAN_CIPHER_SUITE_CCMP) &&
            !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {

or probably set "sw_mgmt_crypto =3D true" in ath9k_hw_init_mfp() for all
usb devices?

--=20
Regards,
Oleksij


--KH2QEF5okBRP3avR8TDEum2Qi7h2McEFA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlRlwzgACgkQHwImuRkmbWlJCAD/Xy0Dr6haEiuTU429piGDtBZF
DLbDK96yTA/XcslgwbIA/1SA+RxEwYBnlpXV+7sNJywhLgpu8UWhGtjVAN62TlK4
=tQd9
-----END PGP SIGNATURE-----

--KH2QEF5okBRP3avR8TDEum2Qi7h2McEFA--
