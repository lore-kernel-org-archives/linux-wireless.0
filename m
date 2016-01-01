Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55637 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbcAATO4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 14:14:56 -0500
Subject: Re: [PATCH 2/2] net-ath9k_htc: Replace a variable initialisation by
 an assignment in ath9k_htc_set_channel()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Kalle Valo <kvalo@codeaurora.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686C390.5060600@users.sourceforge.net>
 <5686C47E.1040906@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <5686D010.1060401@rempel-privat.de> (sfid-20160101_201549_304538_A7E63D74)
Date: Fri, 1 Jan 2016 20:14:24 +0100
MIME-Version: 1.0
In-Reply-To: <5686C47E.1040906@users.sourceforge.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iIDs71WpC9nd6brTonQTiKvAI0rg09UA7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iIDs71WpC9nd6brTonQTiKvAI0rg09UA7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 01.01.2016 um 19:25 schrieb SF Markus Elfring:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 1 Jan 2016 19:09:32 +0100
>=20
> Replace an explicit initialisation for one local variable at the beginn=
ing
> by a conditional assignment.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_main.c
> index a680a97..30bd59e 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -246,7 +246,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_p=
riv *priv,
>  	struct ieee80211_conf *conf =3D &common->hw->conf;
>  	bool fastcc;
>  	struct ieee80211_channel *channel =3D hw->conf.chandef.chan;
> -	struct ath9k_hw_cal_data *caldata =3D NULL;
> +	struct ath9k_hw_cal_data *caldata;
>  	enum htc_phymode mode;
>  	__be16 htc_mode;
>  	u8 cmd_rsp;
> @@ -274,10 +274,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_=
priv *priv,
>  		priv->ah->curchan->channel,
>  		channel->center_freq, conf_is_ht(conf), conf_is_ht40(conf),
>  		fastcc);
> -
> -	if (!fastcc)
> -		caldata =3D &priv->caldata;
> -
> +	caldata =3D fastcc ? NULL : &priv->caldata;
>  	ret =3D ath9k_hw_reset(ah, hchan, caldata, fastcc);
>  	if (ret) {
>  		ath_err(common,
>=20

Reviewed-by: Oleksij Rempel <linux@rempel-privat.de>

--=20
Regards,
Oleksij


--iIDs71WpC9nd6brTonQTiKvAI0rg09UA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlaG0BUACgkQHwImuRkmbWmbIAD/atiZa0Xy3ThlaQHLJVSFBLkS
ypnkjeykyF5QClTNPRsA/R2K1RddEZFk+dMfjZdq5iuOaz6oUaz5qvPS2G55rsE2
=KzYR
-----END PGP SIGNATURE-----

--iIDs71WpC9nd6brTonQTiKvAI0rg09UA7--
