Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49831 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaA1JaR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 04:30:17 -0500
Received: from [192.168.1.100] ([93.196.93.204]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LvUwp-1V7hCP1kPb-010akv for
 <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 10:30:15 +0100
Message-ID: <52E7789D.9010001@rempel-privat.de> (sfid-20140128_103023_802542_DF47E322)
Date: Tue, 28 Jan 2014 10:30:05 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
CC: ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k_htc: make ->sta_rc_update atomic for most calls
References: <20140128081433.GA1771@redhat.com>
In-Reply-To: <20140128081433.GA1771@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lg5IAFMXPLNHeh4jg99mNTiR6XrxtSOp9"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lg5IAFMXPLNHeh4jg99mNTiR6XrxtSOp9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Looks good,
thank you!

Am 28.01.2014 09:14, schrieb Stanislaw Gruszka:
> sta_rc_update() callback must be atomic, hence we can not take mutexes
> or do other operations, which can sleep in ath9k_htc_sta_rc_update().
>=20
> I think we can just return from ath9k_htc_sta_rc_update(), if it is
> called without IEEE80211_RC_SUPP_RATES_CHANGED bit. That will help=20
> with scheduling while atomic bug for most cases (except mesh and IBSS
> modes).
>=20
> For mesh and IBSS I do not see other solution like creating additional
> workqueue, because sending firmware command require us to sleep, but
> this can be done in additional patch.
>=20
> Patch partially fixes bug:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D990955
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 25 +++++++++++++------=
------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_main.c
> index 608d739..a57af9b 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -1315,21 +1315,22 @@ static void ath9k_htc_sta_rc_update(struct ieee=
80211_hw *hw,
>  	struct ath_common *common =3D ath9k_hw_common(priv->ah);
>  	struct ath9k_htc_target_rate trate;
> =20
> +	if (!(changed & IEEE80211_RC_SUPP_RATES_CHANGED))
> +		return;
> +
>  	mutex_lock(&priv->mutex);
>  	ath9k_htc_ps_wakeup(priv);
> =20
> -	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED) {
> -		memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
> -		ath9k_htc_setup_rate(priv, sta, &trate);
> -		if (!ath9k_htc_send_rate_cmd(priv, &trate))
> -			ath_dbg(common, CONFIG,
> -				"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
> -				sta->addr, be32_to_cpu(trate.capflags));
> -		else
> -			ath_dbg(common, CONFIG,
> -				"Unable to update supported rates for sta: %pM\n",
> -				sta->addr);
> -	}
> +	memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
> +	ath9k_htc_setup_rate(priv, sta, &trate);
> +	if (!ath9k_htc_send_rate_cmd(priv, &trate))
> +		ath_dbg(common, CONFIG,
> +			"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
> +			sta->addr, be32_to_cpu(trate.capflags));
> +	else
> +		ath_dbg(common, CONFIG,
> +			"Unable to update supported rates for sta: %pM\n",
> +			sta->addr);
> =20
>  	ath9k_htc_ps_restore(priv);
>  	mutex_unlock(&priv->mutex);
>=20


--=20
Regards,
Oleksij


--lg5IAFMXPLNHeh4jg99mNTiR6XrxtSOp9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLneKUACgkQHwImuRkmbWnurAEAkZZP+T0Xycsw4PRd++7zuIwN
5ayPIYcIeLlT9jyYPicA/iJ0n/tFRN+CCo5pmokOm/nOZ+Gcz+gmWjhmhsHy9M/S
=/XYA
-----END PGP SIGNATURE-----

--lg5IAFMXPLNHeh4jg99mNTiR6XrxtSOp9--
