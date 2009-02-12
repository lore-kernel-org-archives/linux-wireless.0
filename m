Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381AbZBLJSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 04:18:00 -0500
Subject: Re: [PATCH v2] mac80211: Extend the rate control API with an
	update callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18835.48357.7271.454072@gargle.gargle.HOWL>
References: <18835.48357.7271.454072@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CvmGAJ9liZyrxubMSmvu"
Date: Thu, 12 Feb 2009 10:17:28 +0100
Message-Id: <1234430248.16004.83.camel@johannes.local> (sfid-20090212_101817_031971_828CA5BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CvmGAJ9liZyrxubMSmvu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 11:38 +0530, Sujith wrote:
> The AP can switch dynamically between 20/40 Mhz channel width,
> in which case we switch the local operating channel, but the
> rate control algorithm is not notified. This patch adds a new callback
> to indicate such changes to the RC algorithm.
>=20
> Currently, HT channel width change is notified, but this callback
> can be used to indicate any new requirements that might come up later on.

Looks good to me.

> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> v2:
> --
> * Rebased over [PATCH] mac80211: split IBSS/managed code
>=20
>  include/net/mac80211.h |   13 +++++++++++++
>  net/mac80211/ht.c      |   13 +++++++++++++
>  net/mac80211/rate.h    |   12 ++++++++++++
>  3 files changed, 38 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 31fd8ba..e01c63a 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1975,6 +1975,16 @@ struct ieee80211_sta *ieee80211_find_sta(struct ie=
ee80211_hw *hw,
>  /* Rate control API */
> =20
>  /**
> + * enum rate_control_changed - flags to indicate which parameter changed
> + *
> + * @IEEE80211_RC_HT_CHANGED: The HT parameters of the operating channel =
have
> + *	changed, rate control algorithm can update its internal state if need=
ed.
> + */
> +enum rate_control_changed {
> +	IEEE80211_RC_HT_CHANGED =3D BIT(0)
> +};
> +
> +/**
>   * struct ieee80211_tx_rate_control - rate control information for/from =
RC algo
>   *
>   * @hw: The hardware the algorithm is invoked for.
> @@ -2010,6 +2020,9 @@ struct rate_control_ops {
>  	void *(*alloc_sta)(void *priv, struct ieee80211_sta *sta, gfp_t gfp);
>  	void (*rate_init)(void *priv, struct ieee80211_supported_band *sband,
>  			  struct ieee80211_sta *sta, void *priv_sta);
> +	void (*rate_update)(void *priv, struct ieee80211_supported_band *sband,
> +			    struct ieee80211_sta *sta,
> +			    void *priv_sta, u32 changed);
>  	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
>  			 void *priv_sta);
> =20
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index 69b6e9a..4e3c72f 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -17,6 +17,7 @@
>  #include <net/wireless.h>
>  #include <net/mac80211.h>
>  #include "ieee80211_i.h"
> +#include "rate.h"
> =20
>  void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *=
sband,
>  				       struct ieee80211_ht_cap *ht_cap_ie,
> @@ -93,7 +94,9 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *s=
data,
>  {
>  	struct ieee80211_local *local =3D sdata->local;
>  	struct ieee80211_supported_band *sband;
> +	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
>  	struct ieee80211_bss_ht_conf ht;
> +	struct sta_info *sta;
>  	u32 changed =3D 0;
>  	bool enable_ht =3D true, ht_changed;
>  	enum nl80211_channel_type channel_type =3D NL80211_CHAN_NO_HT;
> @@ -136,6 +139,16 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data=
 *sdata,
>  	if (ht_changed) {
>                  /* channel_type change automatically detected */
>  		ieee80211_hw_config(local, 0);
> +
> +		rcu_read_lock();
> +
> +		sta =3D sta_info_get(local, ifmgd->bssid);
> +		if (sta)
> +			rate_control_rate_update(local, sband, sta,
> +						 IEEE80211_RC_HT_CHANGED);
> +
> +		rcu_read_unlock();
> +
>          }
> =20
>  	/* disable HT */
> diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
> index 928da62..b9164c9 100644
> --- a/net/mac80211/rate.h
> +++ b/net/mac80211/rate.h
> @@ -62,6 +62,18 @@ static inline void rate_control_rate_init(struct sta_i=
nfo *sta)
>  	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
>  }
> =20
> +static inline void rate_control_rate_update(struct ieee80211_local *loca=
l,
> +				    struct ieee80211_supported_band *sband,
> +				    struct sta_info *sta, u32 changed)
> +{
> +	struct rate_control_ref *ref =3D local->rate_ctrl;
> +	struct ieee80211_sta *ista =3D &sta->sta;
> +	void *priv_sta =3D sta->rate_ctrl_priv;
> +
> +	if (ref->ops->rate_update)
> +		ref->ops->rate_update(ref->priv, sband, ista,
> +				      priv_sta, changed);
> +}
> =20
>  static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,
>  					   struct ieee80211_sta *sta,

--=-CvmGAJ9liZyrxubMSmvu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJk+kkAAoJEKVg1VMiehFYwbMQAJyfS8OaRnxjaHRO6tonfXU4
DIpghBPEhjKNGTEVE1VrSaAJVAh6h/kCZn6jW9b/4nGbiiBrueYx7BV28OrgbLKY
sPjbhKDIs5g/yTuKKL2TfIkfGD6UFUxBB8/a4mwGX8+8oqzUcIM4+YcDGnavqELw
L9503+fsr5sV/AaD/vx5fvXhbc7cXL8TPg9iN6E5q2BEvLEsCuc6Y6tPJJcDZWng
yX1RLKmeoBbOihYS57g1WjF7srd12iNmAfh/nY+WyOyLYxgOkfLsEdyx5z7mOdaQ
Mvh1lh2xy7yIa0YXO9BwKYeEiAougBJWflhGr1nyghXAQ+RuIZCtSw71dEaX/Uku
mQnTvSM7kIhYQMvVxQgkY1d1U4uslRPIHBaMYKExM1h+eOkuaP2+5fdT4g2fOyys
DI/HWzKVod8/HAIl3LWLSLoN/yEUkVXjuqlIhpI88vCdf8UYL7/Ka9cymvmBF3Es
eJxH2NbiFAbgjJpEEadVZOii3qEdox0MGsiw97cNc0DZGZxnVxEwoJXt3bsY90+k
07k1RKiSgDzjpjMz3RznlBm/ZbK6OF8lzhuUmGE3ouPbrZ3nNFOD2oDdbbe3yOhg
UaiTQo/hNKEXKa5DFwotyyJqR136lsv1jrifQHcw1fI7F+v0H9iDw/5ru9jOLWNf
Q0sNH5KVs+qj9/RrEYZe
=m22W
-----END PGP SIGNATURE-----

--=-CvmGAJ9liZyrxubMSmvu--

