Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYEHLhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 07:37:35 -0400
Subject: Re: [PATCH/RFC v2] mac80211: fix association with some APs
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200805081334.07599.hschaa@suse.de>
References: <200805081030.57966.hschaa@suse.de>
	 <200805081334.07599.hschaa@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nXPdwDQA5FS3DzkSXHKH"
Date: Thu, 08 May 2008 13:36:42 +0200
Message-Id: <1210246602.3547.45.camel@johannes.berg> (sfid-20080508_133634_057373_C65163C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nXPdwDQA5FS3DzkSXHKH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-08 at 13:34 +0200, Helmut Schaa wrote:
> Some APs refuse association if the supported rates contained in the
> association request do not match its own supported rates. This patch
> introduces a new function which builds the intersection between the AP's
> supported rates and the client's supported rates to work around such
> problems. The same approach is already used in ipw2200 for example.
>=20
> Signed-off-by: Helmut Schaa <hschaa@suse.de>

Thanks. Looks ok to me.

> ---
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index cb01995..91d96d9 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -650,6 +650,26 @@ static void ieee80211_authenticate(struct net_device=
 *dev,
>  	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
>  }
> =20
> +static int ieee80211_compatible_rates(struct ieee80211_sta_bss *bss,
> +				      struct ieee80211_supported_band *sband,
> +				      u64 *rates)
> +{
> +	int i, j, count;
> +	*rates =3D 0;
> +	count =3D 0;
> +	for (i =3D 0; i < bss->supp_rates_len; i++) {
> +		int rate =3D (bss->supp_rates[i] & 0x7F) * 5;
> +
> +		for (j =3D 0; j < sband->n_bitrates; j++)
> +			if (sband->bitrates[j].bitrate =3D=3D rate) {
> +				*rates |=3D BIT(j);
> +				count++;
> +				break;
> +			}
> +	}
> +
> +	return count;
> +}
> =20
>  static void ieee80211_send_assoc(struct net_device *dev,
>  				 struct ieee80211_if_sta *ifsta)
> @@ -658,11 +678,12 @@ static void ieee80211_send_assoc(struct net_device =
*dev,
>  	struct sk_buff *skb;
>  	struct ieee80211_mgmt *mgmt;
>  	u8 *pos, *ies;
> -	int i, len;
> +	int i, len, count, rates_len, supp_rates_len;
>  	u16 capab;
>  	struct ieee80211_sta_bss *bss;
>  	int wmm =3D 0;
>  	struct ieee80211_supported_band *sband;
> +	u64 rates =3D 0;
> =20
>  	skb =3D dev_alloc_skb(local->hw.extra_tx_headroom +
>  			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
> @@ -724,24 +745,39 @@ static void ieee80211_send_assoc(struct net_device =
*dev,
>  	*pos++ =3D ifsta->ssid_len;
>  	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
> =20
> +	/* all supported rates should be added here but some APs
> +	 * (e.g. D-Link DAP 1353 in b-only mode) don't like that
> +	 * Therefore only add rates the AP supports */
> +	rates_len =3D ieee80211_compatible_rates(bss, sband, &rates);
> +	supp_rates_len =3D rates_len;
> +	if (supp_rates_len > 8)
> +		supp_rates_len =3D 8;
> +
>  	len =3D sband->n_bitrates;
> -	if (len > 8)
> -		len =3D 8;
> -	pos =3D skb_put(skb, len + 2);
> +	pos =3D skb_put(skb, supp_rates_len + 2);
>  	*pos++ =3D WLAN_EID_SUPP_RATES;
> -	*pos++ =3D len;
> -	for (i =3D 0; i < len; i++) {
> -		int rate =3D sband->bitrates[i].bitrate;
> -		*pos++ =3D (u8) (rate / 5);
> -	}
> +	*pos++ =3D supp_rates_len;
> =20
> -	if (sband->n_bitrates > len) {
> -		pos =3D skb_put(skb, sband->n_bitrates - len + 2);
> -		*pos++ =3D WLAN_EID_EXT_SUPP_RATES;
> -		*pos++ =3D sband->n_bitrates - len;
> -		for (i =3D len; i < sband->n_bitrates; i++) {
> +	count =3D 0;
> +	for (i =3D 0; i < sband->n_bitrates; i++) {
> +		if (BIT(i) & rates) {
>  			int rate =3D sband->bitrates[i].bitrate;
>  			*pos++ =3D (u8) (rate / 5);
> +			if (++count =3D=3D 8)
> +				break;
> +		}
> +	}
> +
> +	if (count =3D=3D 8) {
> +		pos =3D skb_put(skb, rates_len - count + 2);
> +		*pos++ =3D WLAN_EID_EXT_SUPP_RATES;
> +		*pos++ =3D rates_len - count;
> +
> +		for (i++; i < sband->n_bitrates; i++) {
> +			if (BIT(i) & rates) {
> +				int rate =3D sband->bitrates[i].bitrate;
> +				*pos++ =3D (u8) (rate / 5);
> +			}
>  		}
>  	}
> =20
>=20

--=-nXPdwDQA5FS3DzkSXHKH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCLlyaVg1VMiehFYAQIJWg//Vr4zFoiDw0uUItEm7LSqHtzCrRVaU5yt
6/z5myws2ObZ7NOwn37dYF45dtmzZ+r6jZ+pHyXECTGoqJ9bgt1XUUxGTp8/w3O6
S8leX5KkOqyc38ZULQzXt+Q8eqSq9zEyNOQZcAQBsUUgKyj0nKd9hGskKg4nNUkD
DCHZYgRq175sQy6GBlY64QZNC+iLTO7fVWFz86onG05dyM3vOg7p47dALY/gZsiv
IBdJzL6gEPOIWGm+jHe9Z9MaGhYCmRpkfK9tbqpgfNd4m0TR3fqRqAuDPICPMdqi
1g8ICCFOuMe0uNFLlFaJsgpGVpeJ1dGIGhZCAJBFbI3uzXvp4yqxvZJkeN4YmXC5
MDctr6Ezp+SYg0MMJuoucZQ1eVGAlxih+KVW5pMB8+4IL4HTehVDTY0MSBsKXreT
3v6mf0vJ0bbc5u971Maw42nQaG3wIB0SqOcQdFpO3wqVnEvRBaezfctX0A5Ncnu/
lcoyRofFxidu0S2/GPt6pTAqK07YEOTXYglPABTheYeM5qrKBuzwP5L6iAQBvn5s
NmXX/xJPdS93Tp/C7QsFComB7UHjzwz6/vuVWUakWqlbvt1Vz+HbkpKSEICjf+mE
LMNr6qTlsGgyh5f1um5ih7MbKROYiQ0k502I62Yatti9iMZa/4AUcz505YPnJHL/
W73g82+EHLU=
=SkaA
-----END PGP SIGNATURE-----

--=-nXPdwDQA5FS3DzkSXHKH--

