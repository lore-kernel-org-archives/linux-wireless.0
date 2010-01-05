Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0AEJgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 04:36:46 -0500
Subject: Re: [PATCH 2/3] cfg80211/mac80211: Use more generic bitrate mask
 for rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <20091229105932.GC18493@jm.kir.nu>
References: <20091229105932.GC18493@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-42xW3+xlpkzn+NN9LYxv"
Date: Tue, 05 Jan 2010 10:36:39 +0100
Message-ID: <1262684199.20098.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-42xW3+xlpkzn+NN9LYxv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 12:59 +0200, Jouni Malinen wrote:
> plain text document attachment (mac80211-rc-rate-mask.patch)
> Extend struct cfg80211_bitrate_mask to actually use a bitfield mask
> instead of just a single fixed or maximum rate index. This change
> itself does not modify the behavior (except for debugfs files), but it
> prepares cfg80211 and mac80211 for a new nl80211 command for setting
> which rates can be used in TX rate control.
>=20
> Since frames are now going through the rate control algorithm
> unconditionally, the internal IEEE80211_TX_INTFL_RCALGO flag can now
> be removed. The RC implementations can use the rate_idx_mask value top

s/top/to/ :P

> @@ -257,7 +257,8 @@ void rate_control_get_rate(struct ieee80
>  	void *priv_sta =3D NULL;
>  	struct ieee80211_sta *ista =3D NULL;
>  	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(txrc->skb);
> -	int i;
> +	int i, j;
> +	u32 mask;
> =20
>  	if (sta) {
>  		ista =3D &sta->sta;
> @@ -270,23 +271,26 @@ void rate_control_get_rate(struct ieee80
>  		info->control.rates[i].count =3D 1;
>  	}
> =20
> -	if (sta && sdata->force_unicast_rateidx > -1) {
> -		info->control.rates[0].idx =3D sdata->force_unicast_rateidx;
> -	} else {
> -		ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
> -		info->flags |=3D IEEE80211_TX_INTFL_RCALGO;
> -	}
> +	ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
> =20
>  	/*
> -	 * try to enforce the maximum rate the user wanted
> +	 * try to enforce the rateidx mask the user wanted
>  	 */
> -	if (sdata->max_ratectrl_rateidx > -1)
> +	mask =3D sdata->rc_rateidx_mask[info->band];
> +	if (mask !=3D (1 << txrc->sband->n_bitrates) - 1) {
> +		if (sta)
> +			mask &=3D sta->sta.supp_rates[info->band];
>  		for (i =3D 0; i < IEEE80211_TX_MAX_RATES; i++) {
>  			if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS)
>  				continue;
> -			info->control.rates[i].idx =3D
> -				min_t(s8, info->control.rates[i].idx,
> -				      sdata->max_ratectrl_rateidx);
> +			for (j =3D info->control.rates[i].idx;
> +			     j < txrc->sband->n_bitrates; j++) {
> +				if (mask & (1 << j)) {
> +					info->control.rates[i].idx =3D j;
> +					break;
> +				}
> +			}

This could benefit from some comments :) I'm having trouble to see that
it's correct, but the min_t probably makes it correct?

> @@ -519,7 +519,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
>  	txrc.bss_conf =3D &tx->sdata->vif.bss_conf;
>  	txrc.skb =3D tx->skb;
>  	txrc.reported_rate.idx =3D -1;
> -	txrc.max_rate_idx =3D tx->sdata->max_ratectrl_rateidx;
> +	txrc.rate_idx_mask =3D tx->sdata->rc_rateidx_mask[tx->channel->band];
> +	if (txrc.rate_idx_mask =3D=3D (1 << sband->n_bitrates) - 1)
> +		txrc.max_rate_idx =3D -1;
> +	else
> +		txrc.max_rate_idx =3D fls(txrc.rate_idx_mask) - 1;

I wonder if we should maintain the rate_idx_mask separately, so it's
outside the hotpath, or will we be removing all remaining uses of it
very soon?

johannes

--=-42xW3+xlpkzn+NN9LYxv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQwgkAAoJEODzc/N7+Qma5UEP/3yH8tk0x1IPMNr7JKrFS8zJ
+54Ykv5TKU/8lRKurcfINsQPMuS9jTSTmnSkvV/tIIgsnFdrvBOIwIZ8CqZ2nEp7
9g4GQEdH8PIY6FJHWztHLWUEaqmzWSa60QrWC7w+UpscmX9yUtCZeEq1T30BGwqy
Goc9OEpeEjUuTRShAdV3NX1QNByhz2OawADiU+1jEmMuFeQsxacleUxd9ji6jue+
jN3LJF1KVLm3zFRAYCR2aW8l2aJwh7fnAnV/7zjjGUBkbKDpt2XoIYMelB/gbSv9
1LIQUYwbxII41MqQ6BDRLEHMkxJr13Ar2DLaqOFXhqyZZqXCWGJ9snkkrxvhLZYz
cZgTZuUcPYA3Ql7f6wrjRB/NzqjP67Vt9SNuYnsJSgNiaxAxq2uGl936DEIzlktM
k04dm6o8PcirUecRVC0XAxmyFGE6aIyjnVsD/OS3CHdtcea1RmhQ9St8ew+W9p3D
f+Vfawpe1V+8z5igDg1ovUvziSfdRWcwEc5Pecz8skEI8U13xENqZnM+rs+OMeO/
+5nblYMSUKi934dQAGr+vxY5Z67cO/AfrQSvrESQhsDXLWvTCfp1dL+a9O/qrs2T
j5osXSrMYVgr1EdNcqZ37qYYsns5TZAz1xZB6y0Y4RPkAxaz05PXax16e50WLfXn
kEaN957dVuC1y63z5tHS
=W0Mh
-----END PGP SIGNATURE-----

--=-42xW3+xlpkzn+NN9LYxv--

