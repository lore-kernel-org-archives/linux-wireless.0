Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZG3R3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 13:29:36 -0400
Subject: Re: [PATCH v2 3/3] cfg80211: enable country IE support to all
 cfg80211 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248974386-8168-4-git-send-email-lrodriguez@atheros.com>
References: <1248974386-8168-1-git-send-email-lrodriguez@atheros.com>
	 <1248974386-8168-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sLbPpWpNdcCpNWF3gsHz"
Date: Thu, 30 Jul 2009 19:28:25 +0200
Message-Id: <1248974905.23496.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sLbPpWpNdcCpNWF3gsHz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 10:19 -0700, Luis R. Rodriguez wrote:
> Since the bss is always set now once we are connected, if the
> bss has its own information element we refer to it and pass that
> instead of relying on mac80211's parsing.
>=20
> Now all cfg80211 drivers get country IE support, automatically.

Cool, thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  include/net/cfg80211.h |   14 --------------
>  net/mac80211/mlme.c    |    6 +-----
>  net/wireless/reg.c     |    1 -
>  net/wireless/reg.h     |   15 +++++++++++++++
>  net/wireless/sme.c     |   16 ++++++++++++++++
>  5 files changed, 32 insertions(+), 20 deletions(-)
>=20
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index e1b9235..fa72997 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1514,20 +1514,6 @@ unsigned int cfg80211_classify8021d(struct sk_buff=
 *skb);
>  extern int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
> =20
>  /**
> - * regulatory_hint_11d - hints a country IE as a regulatory domain
> - * @wiphy: the wireless device giving the hint (used only for reporting
> - *	conflicts)
> - * @country_ie: pointer to the country IE
> - * @country_ie_len: length of the country IE
> - *
> - * We will intersect the rd with the what CRDA tells us should apply
> - * for the alpha2 this country IE belongs to, this prevents APs from
> - * sending us incorrect or outdated information against a country.
> - */
> -extern void regulatory_hint_11d(struct wiphy *wiphy,
> -				u8 *country_ie,
> -				u8 country_ie_len);
> -/**
>   * wiphy_apply_custom_regulatory - apply a custom driver regulatory doma=
in
>   * @wiphy: the wireless device we want to process the regulatory domain =
on
>   * @regd: the custom regulatory domain to use for this wiphy
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 0779ba1..5ff1496 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1846,12 +1846,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80=
211_sub_if_data *sdata,
>  					       bssid, ap_ht_cap_flags);
>  	}
> =20
> +	/* Note: country IE parsing is done for us by cfg80211 */
>  	if (elems.country_elem) {
> -		/* Note we are only reviewing this on beacons
> -		 * for the BSSID we are associated to */
> -		regulatory_hint_11d(local->hw.wiphy,
> -			elems.country_elem, elems.country_elem_len);
> -
>  		/* TODO: IBSS also needs this */
>  		if (elems.pwr_constr_elem)
>  			ieee80211_handle_pwr_constr(sdata,
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 14e0c87..06abd7a 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1911,7 +1911,6 @@ free_rd_out:
>  out:
>  	mutex_unlock(&reg_mutex);
>  }
> -EXPORT_SYMBOL(regulatory_hint_11d);
> =20
>  static bool freq_is_chan_12_13_14(u16 freq)
>  {
> diff --git a/net/wireless/reg.h b/net/wireless/reg.h
> index e37829a..662a9da 100644
> --- a/net/wireless/reg.h
> +++ b/net/wireless/reg.h
> @@ -36,4 +36,19 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
>  					struct ieee80211_channel *beacon_chan,
>  					gfp_t gfp);
> =20
> +/**
> + * regulatory_hint_11d - hints a country IE as a regulatory domain
> + * @wiphy: the wireless device giving the hint (used only for reporting
> + *	conflicts)
> + * @country_ie: pointer to the country IE
> + * @country_ie_len: length of the country IE
> + *
> + * We will intersect the rd with the what CRDA tells us should apply
> + * for the alpha2 this country IE belongs to, this prevents APs from
> + * sending us incorrect or outdated information against a country.
> + */
> +void regulatory_hint_11d(struct wiphy *wiphy,
> +			 u8 *country_ie,
> +			 u8 country_ie_len);
> +
>  #endif  /* __NET_WIRELESS_REG_H */
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 3728d2b..bc0fb7d 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -13,6 +13,7 @@
>  #include <net/cfg80211.h>
>  #include <net/rtnetlink.h>
>  #include "nl80211.h"
> +#include "reg.h"
> =20
>  struct cfg80211_conn {
>  	struct cfg80211_connect_params params;
> @@ -320,6 +321,7 @@ void __cfg80211_connect_result(struct net_device *dev=
, const u8 *bssid,
>  			       struct cfg80211_bss *bss)
>  {
>  	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
> +	u8 *country_ie;
>  #ifdef CONFIG_WIRELESS_EXT
>  	union iwreq_data wrqu;
>  #endif
> @@ -401,6 +403,20 @@ void __cfg80211_connect_result(struct net_device *de=
v, const u8 *bssid,
> =20
>  	wdev->sme_state =3D CFG80211_SME_CONNECTED;
>  	cfg80211_upload_connect_keys(wdev);
> +
> +	country_ie =3D (u8 *) ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
> +
> +	if (!country_ie)
> +		return;
> +
> +	/*
> +	 * ieee80211_bss_get()_ie ensures we can access:
> +	 * - country_ie + 2, the start of the country ie data, and
> +	 * - and country_ie[1] which is the IE length
> +	 */
> +	regulatory_hint_11d(wdev->wiphy,
> +			    country_ie + 2,
> +			    country_ie[1]);
>  }
> =20
>  void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,


--=-sLbPpWpNdcCpNWF3gsHz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcdg2AAoJEODzc/N7+QmaFd8QAJOGZWov3TDz1oJq/4nkgxkg
2o402OdpaOCw/uEKG1/DIM1/f9E1TjRZBoQuYO1Adbzj3xFD0gIcOiJh5ILOAtOa
Elchj6pP+HkBqOsnVXd8NXU/02i4P/mc3qIdfzCM79MAYdNmZUW/mKAaaTK6LuFk
hOkQOI7wyr2SmovVy+bn+zPYvOl1SQb8tAa/U7b7hIfGNU8wl3NCowgdw/u42Bd8
JNeEzBbmjSKAmMrJ4TUlzgZJoXfXarE1wpRj2AGGjJTAlDs3KhZGJMaedyhtd1nv
FVRx7Tn6E5YsrzbVCkoCpDMYVo7GgT+zl19imZl0tNPM4c5TotaD1JA6CNRPYZzi
gkgyAJ6WM2mAmvVG1Zn7K8tj6L5RoWv1sUcjJhi9ATxgyytSet0Z0Jpvo74u0Lvg
6cq7EWegu6/79wjGjaCn7oOkhqXRmU5AEW5j+F1Ba+SmKWwJii35/eTiSpnEX6fh
8Q5MB6nhV9E8q9nUyvdQfFPdoOhO59in5+ft5qOgeWqlm2y/vKAsvC//2ZAd2TCR
3nsOl+x4SugrTV5v8kX9shT+8Y0jtiYJ9efaVX9bR87kf5JuzGK7CBZXfjYDvm5L
iiZcaPiDX1lWtNSGYgctXi3aLyhy88iSHzo2/g1s7saX9iogtcgdXy2bzVqzc2v1
abJHo6X/kSShF/aIsTPB
=2cX6
-----END PGP SIGNATURE-----

--=-sLbPpWpNdcCpNWF3gsHz--

