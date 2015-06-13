Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51139 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbbFMJNr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 05:13:47 -0400
Message-ID: <557BF43F.3050402@rempel-privat.de> (sfid-20150613_111352_647767_CE3F286A)
Date: Sat, 13 Jun 2015 11:13:35 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org
CC: kvalo@codeaurora.org
Subject: Re: [PATCH] ath9k_htc: add support of channel switch
References: <1433836789-5505-1-git-send-email-yeohchunyeow@gmail.com>
In-Reply-To: <1433836789-5505-1-git-send-email-yeohchunyeow@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T2DUFjISjtbJLC6UfnXROqQQ5kOdfTDQV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T2DUFjISjtbJLC6UfnXROqQQ5kOdfTDQV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Thank you for your work.
How can i test this patch?

Am 09.06.2015 um 09:59 schrieb Chun-Yeow Yeoh:
> Add the support of channel switching functionality, similar
> to ath9k support.
>=20
> Tested with TP-Link TL-WN722N and TL-WN821N.
>=20
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc.h            |  2 ++
>  drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 19 +++++++++++++++++=
++
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  3 ++-
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c   | 17 +++++++++++++++++=

>  4 files changed, 40 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireles=
s/ath/ath9k/htc.h
> index 5dbc617..16dff4b 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -531,6 +531,7 @@ struct ath9k_htc_priv {
>  	struct ath9k_debug debug;
>  #endif
>  	struct mutex mutex;
> +	struct ieee80211_vif *csa_vif;
>  };
> =20
>  static inline void ath_read_cachesize(struct ath_common *common, int *=
csz)
> @@ -584,6 +585,7 @@ void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv=
);
>  void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event);=

>  void ath9k_tx_failed_tasklet(unsigned long data);
>  void ath9k_htc_tx_cleanup_timer(unsigned long data);
> +bool ath9k_htc_csa_is_finished(struct ath9k_htc_priv *priv);
> =20
>  int ath9k_rx_init(struct ath9k_htc_priv *priv);
>  void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/=
net/wireless/ath/ath9k/htc_drv_beacon.c
> index e8b6ec3..e6bcb4c 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> @@ -257,6 +257,8 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_=
priv *priv,
>  	}
> =20
>  	spin_unlock_bh(&priv->beacon_lock);
> +
> +	ath9k_htc_csa_is_finished(priv);
>  }
> =20
>  static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv,
> @@ -503,3 +505,20 @@ void ath9k_htc_beacon_reconfig(struct ath9k_htc_pr=
iv *priv)
>  		return;
>  	}
>  }
> +
> +bool ath9k_htc_csa_is_finished(struct ath9k_htc_priv *priv)
> +{
> +	struct ieee80211_vif *vif;
> +
> +	vif =3D priv->csa_vif;
> +	if (!vif || !vif->csa_active)
> +		return false;
> +
> +	if (!ieee80211_csa_is_complete(vif))
> +		return false;
> +
> +	ieee80211_csa_finish(vif);
> +
> +	priv->csa_vif =3D NULL;
> +	return true;
> +}
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_init.c
> index 7468562..9569010 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -744,7 +744,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_pri=
v *priv,
>  	hw->wiphy->flags &=3D ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> =20
>  	hw->wiphy->flags |=3D WIPHY_FLAG_IBSS_RSN |
> -			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
> +			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
> +			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
> =20
>  	hw->wiphy->flags |=3D WIPHY_FLAG_SUPPORTS_TDLS;
> =20
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/ne=
t/wireless/ath/ath9k/htc_drv_main.c
> index b71f307..dab1323 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -1134,6 +1134,9 @@ static void ath9k_htc_remove_interface(struct iee=
e80211_hw *hw,
>  	priv->nvifs--;
>  	priv->vif_slot &=3D ~(1 << avp->index);
> =20
> +	if (priv->csa_vif =3D=3D vif)
> +		priv->csa_vif =3D NULL;
> +
>  	ath9k_htc_remove_station(priv, vif, NULL);
> =20
>  	DEC_VIF(priv, vif->type);
> @@ -1841,6 +1844,19 @@ static int ath9k_htc_get_antenna(struct ieee8021=
1_hw *hw, u32 *tx_ant,
>  	return 0;
>  }
> =20
> +static void ath9k_htc_channel_switch_beacon(struct ieee80211_hw *hw,
> +					    struct ieee80211_vif *vif,
> +					    struct cfg80211_chan_def *chandef)
> +{
> +	struct ath9k_htc_priv *priv =3D hw->priv;
> +
> +	/* mac80211 does not support CSA in multi-if cases (yet) */
> +	if (WARN_ON(priv->csa_vif))
> +		return;
> +
> +	priv->csa_vif =3D vif;
> +}
> +
>  struct ieee80211_ops ath9k_htc_ops =3D {
>  	.tx                 =3D ath9k_htc_tx,
>  	.start              =3D ath9k_htc_start,
> @@ -1867,6 +1883,7 @@ struct ieee80211_ops ath9k_htc_ops =3D {
>  	.set_bitrate_mask   =3D ath9k_htc_set_bitrate_mask,
>  	.get_stats	    =3D ath9k_htc_get_stats,
>  	.get_antenna	    =3D ath9k_htc_get_antenna,
> +	.channel_switch_beacon	=3D ath9k_htc_channel_switch_beacon,
> =20
>  #ifdef CONFIG_ATH9K_HTC_DEBUGFS
>  	.get_et_sset_count  =3D ath9k_htc_get_et_sset_count,
>=20


--=20
Regards,
Oleksij


--T2DUFjISjtbJLC6UfnXROqQQ5kOdfTDQV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlV79EQACgkQHwImuRkmbWlHVAD/Yb7ylvwOCnx8q6Nc97e7AM0+
JDLr2p+4DAujwcxqlEoA+wVd87P2+VLag5JlIRpxtbhRCJbwBV07uoGn+tSERhS7
=8evZ
-----END PGP SIGNATURE-----

--T2DUFjISjtbJLC6UfnXROqQQ5kOdfTDQV--
