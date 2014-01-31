Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50565 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932748AbaAaSYR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 13:24:17 -0500
Received: from [192.168.1.221] ([93.196.93.204]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0LqW8j-1Ve6sY3mSX-00e0rv for
 <linux-wireless@vger.kernel.org>; Fri, 31 Jan 2014 19:24:16 +0100
Message-ID: <52EBEA45.5090606@rempel-privat.de> (sfid-20140131_192425_446639_7485D4F0)
Date: Fri, 31 Jan 2014 19:24:05 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	ath9k-devel@venema.h4ckr.net
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ath9k_htc: avoid scheduling while atomic on sta_rc_update
References: <20140131133707.GA7648@redhat.com>
In-Reply-To: <20140131133707.GA7648@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ojJk35XApRn0av9BBPojLOacFrvgvVdvK"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ojJk35XApRn0av9BBPojLOacFrvgvVdvK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I have different HW. How can trigger sta_rc_update?


Am 31.01.2014 14:37, schrieb Stanislaw Gruszka:
> mac80211 ->sta_rc_update() callback must be atomic. Since we have to
> take mutex and do other operations that can sleep when sending fimrware=

> commands to device, the only option to satisfy atomicity requirement of=

> ->sta_rc_update(), that I can see, is introduce work_struct and defer
> uploading new rates to that work.
>=20
> I don't have h/w to test this patch. Since sta_rc_update() calls are
> very unlikely, those who would like to test that patch should remove
> my previous patch "ath9k_htc: make ->sta_rc_update atomic for most
> calls" and possibly even modify mac80211 to call sta_rc_update(),
> without actual reason, just to test changed ath9k_htc code.
>=20
> Thanks
> Stanislaw
> ---
>  drivers/net/wireless/ath/ath9k/htc.h          |  2 +
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 60 +++++++++++++++++--=
--------
>  2 files changed, 40 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireles=
s/ath/ath9k/htc.h
> index 58da346..99a2031 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -262,6 +262,8 @@ enum tid_aggr_state {
>  struct ath9k_htc_sta {
>  	u8 index;
>  	enum tid_aggr_state tid_state[ATH9K_HTC_MAX_TID];
> +	struct work_struct rc_update_work;
> +	struct ath9k_htc_priv *htc_priv;
>  };
> =20
>  #define ATH9K_HTC_RXBUF 256
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_main.c
> index a57af9b..c9254a6 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -1270,18 +1270,50 @@ static void ath9k_htc_configure_filter(struct i=
eee80211_hw *hw,
>  	mutex_unlock(&priv->mutex);
>  }
> =20
> +static void ath9k_htc_sta_rc_update_work(struct work_struct *work)
> +{
> +	struct ath9k_htc_sta *ista =3D
> +	    container_of(work, struct ath9k_htc_sta, rc_update_work);
> +	struct ieee80211_sta *sta =3D
> +	    container_of((void *)ista, struct ieee80211_sta, drv_priv);
> +	struct ath9k_htc_priv *priv =3D ista->htc_priv;
> +	struct ath_common *common =3D ath9k_hw_common(priv->ah);
> +	struct ath9k_htc_target_rate trate;
> +
> +	mutex_lock(&priv->mutex);
> +	ath9k_htc_ps_wakeup(priv);
> +
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
> +
> +	ath9k_htc_ps_restore(priv);
> +	mutex_unlock(&priv->mutex);
> +}
> +
>  static int ath9k_htc_sta_add(struct ieee80211_hw *hw,
>  			     struct ieee80211_vif *vif,
>  			     struct ieee80211_sta *sta)
>  {
>  	struct ath9k_htc_priv *priv =3D hw->priv;
> +	struct ath9k_htc_sta *ista =3D (struct ath9k_htc_sta *) sta->drv_priv=
;
>  	int ret;
> =20
>  	mutex_lock(&priv->mutex);
>  	ath9k_htc_ps_wakeup(priv);
>  	ret =3D ath9k_htc_add_station(priv, vif, sta);
> -	if (!ret)
> +	if (!ret) {
> +		INIT_WORK(&ista->rc_update_work, ath9k_htc_sta_rc_update_work);
> +		ista->htc_priv =3D priv;
>  		ath9k_htc_init_rate(priv, sta);
> +	}
>  	ath9k_htc_ps_restore(priv);
>  	mutex_unlock(&priv->mutex);
> =20
> @@ -1293,12 +1325,13 @@ static int ath9k_htc_sta_remove(struct ieee8021=
1_hw *hw,
>  				struct ieee80211_sta *sta)
>  {
>  	struct ath9k_htc_priv *priv =3D hw->priv;
> -	struct ath9k_htc_sta *ista;
> +	struct ath9k_htc_sta *ista =3D (struct ath9k_htc_sta *) sta->drv_priv=
;
>  	int ret;
> =20
> +	cancel_work_sync(&ista->rc_update_work);
> +
>  	mutex_lock(&priv->mutex);
>  	ath9k_htc_ps_wakeup(priv);
> -	ista =3D (struct ath9k_htc_sta *) sta->drv_priv;
>  	htc_sta_drain(priv->htc, ista->index);
>  	ret =3D ath9k_htc_remove_station(priv, vif, sta);
>  	ath9k_htc_ps_restore(priv);
> @@ -1311,29 +1344,12 @@ static void ath9k_htc_sta_rc_update(struct ieee=
80211_hw *hw,
>  				    struct ieee80211_vif *vif,
>  				    struct ieee80211_sta *sta, u32 changed)
>  {
> -	struct ath9k_htc_priv *priv =3D hw->priv;
> -	struct ath_common *common =3D ath9k_hw_common(priv->ah);
> -	struct ath9k_htc_target_rate trate;
> +	struct ath9k_htc_sta *ista =3D (struct ath9k_htc_sta *) sta->drv_priv=
;
> =20
>  	if (!(changed & IEEE80211_RC_SUPP_RATES_CHANGED))
>  		return;
> =20
> -	mutex_lock(&priv->mutex);
> -	ath9k_htc_ps_wakeup(priv);
> -
> -	memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
> -	ath9k_htc_setup_rate(priv, sta, &trate);
> -	if (!ath9k_htc_send_rate_cmd(priv, &trate))
> -		ath_dbg(common, CONFIG,
> -			"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
> -			sta->addr, be32_to_cpu(trate.capflags));
> -	else
> -		ath_dbg(common, CONFIG,
> -			"Unable to update supported rates for sta: %pM\n",
> -			sta->addr);
> -
> -	ath9k_htc_ps_restore(priv);
> -	mutex_unlock(&priv->mutex);
> +	schedule_work(&ista->rc_update_work);
>  }
> =20
>  static int ath9k_htc_conf_tx(struct ieee80211_hw *hw,
>=20


--=20
Regards,
Oleksij


--ojJk35XApRn0av9BBPojLOacFrvgvVdvK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLr6k4ACgkQHwImuRkmbWma7gD/dtzPqKkLF/NE4HKdg/Wk/j6g
Tjm4EtqEfEILQE+/gRwA/19JjgsaBwrAOSrW5fxvTKMeC55iWB5TBLHbdTr3WKBo
=JeXZ
-----END PGP SIGNATURE-----

--ojJk35XApRn0av9BBPojLOacFrvgvVdvK--
