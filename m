Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbYLVTGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 14:06:42 -0500
Subject: Re: [PATCH v2 11/18] iwlwifi: make use of conf_is_ht*() helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <1229970039-10561-12-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-3-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-4-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-5-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-6-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-7-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-8-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-9-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-10-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-11-git-send-email-lrodriguez@atheros.com>
	 <1229970039-10561-12-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QF9NpgyVYspQClp9zCbK"
Date: Mon, 22 Dec 2008 20:06:43 +0100
Message-Id: <1229972803.4406.14.camel@johannes> (sfid-20081222_200645_325045_53763977)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QF9NpgyVYspQClp9zCbK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 10:20 -0800, Luis Rodriguez wrote:
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 +++---
>  drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wire=
less/iwlwifi/iwl-agn-rs.c
> index f032167..59d4e11 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
> @@ -1131,7 +1131,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv=
,
>         s32 rate;
>         s8 is_green =3D lq_sta->is_green;
>=20
> -       if (!conf->ht.enabled || !sta->ht_cap.ht_supported)
> +       if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
>                 return -1;
>=20
>         if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
> @@ -1198,7 +1198,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
>         u8 is_green =3D lq_sta->is_green;
>         s32 rate;
>=20
> -       if (!conf->ht.enabled || !sta->ht_cap.ht_supported)
> +       if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
>                 return -1;
>=20
>         IWL_DEBUG_RATE("LQ: try to switch to SISO\n");
> @@ -1998,7 +1998,7 @@ lq_update:
>                  * stay with best antenna legacy modulation for a while
>                  * before next round of mode comparisons. */
>                 tbl1 =3D &(lq_sta->lq_info[lq_sta->active_tbl]);
> -               if (is_legacy(tbl1->lq_type) && !conf->ht.enabled &&
> +               if (is_legacy(tbl1->lq_type) && !conf_is_ht(conf) &&
>                     lq_sta->action_counter >=3D 1) {
>                         lq_sta->action_counter =3D 0;
>                         IWL_DEBUG_RATE("LQ: STAY in legacy table\n");
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireles=
s/iwlwifi/iwl-agn.c
> index 05cd04c..99a17d8 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -523,9 +523,9 @@ static void iwl_ht_conf(struct iwl_priv *priv,
>          */
>=20
>         iwl_conf->extension_chan_offset =3D IEEE80211_HT_PARAM_CHA_SEC_NO=
NE;
> -       if (priv->hw->conf.ht.channel_type =3D=3D NL80211_CHAN_HT40MINUS)
> +       if (conf_is_ht40_minus(&priv->hw->conf))
>                 iwl_conf->extension_chan_offset =3D IEEE80211_HT_PARAM_CH=
A_SEC_BELOW;
> -       else if(priv->hw->conf.ht.channel_type =3D=3D NL80211_CHAN_HT40PL=
US)
> +       else if (conf_is_ht40_plus(&priv->hw->conf))
>                 iwl_conf->extension_chan_offset =3D IEEE80211_HT_PARAM_CH=
A_SEC_ABOVE;
>=20
>         /* If no above or below channel supplied disable FAT channel */
> @@ -2553,7 +2553,7 @@ static int iwl_mac_config(struct ieee80211_hw *hw, =
u32 changed)
>         mutex_lock(&priv->mutex);
>         IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_val=
ue);
>=20
> -       priv->current_ht_config.is_ht =3D conf->ht.enabled;
> +       priv->current_ht_config.is_ht =3D conf_is_ht(conf);
>=20
>         if (conf->radio_enabled && iwl_radio_kill_sw_enable_radio(priv)) =
{
>                 IWL_DEBUG_MAC80211("leave - RF-KILL - waiting for uCode\n=
");
> --
> 1.6.1.rc3.51.g5832d
>=20
>=20

--=-QF9NpgyVYspQClp9zCbK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJT+VAAAoJEKVg1VMiehFYVYYQAKSrs/+iC6HYWogDv7YSlOka
Hgs/IdnWTTR4ynp9Y/fr7yUj8MpoD1oKxB90tTN1obibSzsW4fYDOcmEu3bemOAG
KiRXSdVzcKjAepQR3udA2xVf+IP7jyAOye5X7ldEevvHCTp5FC+/eshvFBpymLIm
sml238WqVqso2C1A85xU/YLgJZNzydTjA0zBSBbUPBSam2rE5ECVzHBxXEo/I5D/
n5/LpyHxgmB0seIpvtzUD7ussS8096Cnk58f0VlXP5MM4y1tOaHVb/oGgAFPDxi+
mv48cdtaL3w344S0dpfMXTA24Yf1eGVboRMfPezmt+VTzCzj++8wTCLZgxnARHk5
Zt9wYpMyPm5JxGp73Ly/Lki4F/7XNF8EkJJFbDBS4fXFk8ikqInpHR5nvvpO+nGU
TUeoXfAz4LIpFkf2Ga/jUEyuVM3DRwfzRlAuKo6z30LqgSnTXSxm+NV6YRknomfz
3NCVf5eNJH5UMSS7bdo7hZXT3FqRweqMvecAVFwZ+ON8IllikyFZgheAAcFVxgKN
WeO88+joJ9ZxQOtJLPeMiAsLK3bubLP+u0tjchWGnP46rOIDwd3KX7myhcmLKnKl
3i1fbNcHsI+1/ivk9ui3hfJRYgN9/fbLdWY2OyYzoGJaWK+u0+c1pTAMy2UpFfM2
AOJseg2Z1O6rz/K27qUH
=1f4R
-----END PGP SIGNATURE-----

--=-QF9NpgyVYspQClp9zCbK--

