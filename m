Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0BJJra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2010 04:47:30 -0500
Subject: Re: [PATCH] mac80211: Deny TX BA session requests during
 disassociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19314.31437.647232.84860@gargle.gargle.HOWL>
References: <19314.31437.647232.84860@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wMuuXXjBkq5Xx/aGt8k+"
Date: Wed, 10 Feb 2010 10:47:24 +0100
Message-ID: <1265795244.4018.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wMuuXXjBkq5Xx/aGt8k+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-02-10 at 14:52 +0530, Sujith wrote:
> In associated state, when bringing an interface down, existing
> BA sessions are torn down. When this is in progress, nothing
> prevents mac80211 from accepting another BA session start request.
>=20
> Use a new station flag to fix this.

Good catch! Thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  net/mac80211/agg-tx.c   |    8 ++++++++
>  net/mac80211/mlme.c     |    4 +++-
>  net/mac80211/sta_info.h |    4 ++++
>  3 files changed, 15 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 718fbcf..5538e1b 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -237,6 +237,14 @@ int ieee80211_start_tx_ba_session(struct ieee80211_s=
ta *pubsta, u16 tid)
>  	    sdata->vif.type !=3D NL80211_IFTYPE_AP)
>  		return -EINVAL;
> =20
> +	if (test_sta_flags(sta, WLAN_STA_DISASSOC)) {
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +		printk(KERN_DEBUG "Disassociation is in progress. "
> +		       "Denying BA session request\n");
> +#endif
> +		return -EINVAL;
> +	}
> +
>  	if (test_sta_flags(sta, WLAN_STA_SUSPEND)) {
>  #ifdef CONFIG_MAC80211_HT_DEBUG
>  		printk(KERN_DEBUG "Suspend in progress. "
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index ee9443d..bfc4a50 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -797,8 +797,10 @@ static void ieee80211_set_disassoc(struct ieee80211_=
sub_if_data *sdata)
> =20
>  	rcu_read_lock();
>  	sta =3D sta_info_get(sdata, bssid);
> -	if (sta)
> +	if (sta) {
> +		set_sta_flags(sta, WLAN_STA_DISASSOC);
>  		ieee80211_sta_tear_down_BA_sessions(sta);
> +	}
>  	rcu_read_unlock();
> =20
>  	changed |=3D ieee80211_reset_erp_info(sdata);
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 5ff611a..822d845 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -42,6 +42,9 @@
>   *	be in the queues
>   * @WLAN_STA_PSPOLL: Station sent PS-poll while driver was keeping
>   *	station in power-save mode, reply when the driver unblocks.
> + * @WLAN_STA_DISASSOC: Disassociation in progress.
> + *	This is used to reject TX BA session requests when disassociation
> + *	is in progress.
>   */
>  enum ieee80211_sta_info_flags {
>  	WLAN_STA_AUTH		=3D 1<<0,
> @@ -57,6 +60,7 @@ enum ieee80211_sta_info_flags {
>  	WLAN_STA_SUSPEND	=3D 1<<11,
>  	WLAN_STA_PS_DRIVER	=3D 1<<12,
>  	WLAN_STA_PSPOLL		=3D 1<<13,
> +	WLAN_STA_DISASSOC       =3D 1<<14,
>  };
> =20
>  #define STA_TID_NUM 16


--=-wMuuXXjBkq5Xx/aGt8k+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLcoCoAAoJEODzc/N7+Qma0mwP/07TMX3BGbYaLWHSKJxJ3qTT
uUt8yIL2mCrfCWBpN9QLM+C0M9KQoSCaZ4eWsRDft0X4z9XTB2s4SOOWMAk8I3fm
5DxE0UC1HWSLiGsTIUSfShEhE6CL6LO6VWJgPn/bPeCGY83SOxLyUEPJUNmzkTcW
cfgnRYeO/7UkeYWpqNYtYnmjOYkE6K2RBgPE0cSc+TLKGlwfm4GKOH3CR3e8jt3m
nrMTao6GPK2P+SM+J7RPivcUOeEMC7v/6h8o9c+x3k/rYLYe3Ncrad8g0Bl+yvrd
lJd4Uu/TdZ/sJnqXRYk7fpGsG5TboKgjZUV/MHnpSz9vZgxq8bWibXTpO10fFrCa
+vrYwgkdMIinENLZQ3SAydgW9gziWZjb07H9mxYG5pFq7rky61Vi95ppHGw6BGhf
qHOswaIqtKirbf3VME3hM6Aor1yexgQDs3mvWsLl8Iw1r2r0EKsnBfreaIiwnSmY
h49BB9lPmnido2prW0BcxvjkLnV6YwVap0eSqiOngxvqBmJzl254su9Ze5gOzNvm
6FiDcvhe+50EfhsiWlK5LIcQt5JThgEBVKCgS0NTm7IYLGDvocBkP048JbolGmPD
/zX4o1AfvCPGDH9GjPtxTq/fr7nXyNWcxIBtoaPkMUsfCsSsAbSadGi7EjX/YpIZ
0qnbPiEq/fxnJkU1HeY/
=cljv
-----END PGP SIGNATURE-----

--=-wMuuXXjBkq5Xx/aGt8k+--

