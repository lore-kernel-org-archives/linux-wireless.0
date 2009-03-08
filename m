Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZCHMls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 08:41:48 -0400
Subject: Re: [PATCH] mac80211: Fix TKIP/WEP HT capability handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18859.37287.333376.924937@gargle.gargle.HOWL>
References: <18859.37287.333376.924937@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P2WQzywKoZv1uWrT5wML"
Date: Sun, 08 Mar 2009 13:41:41 +0100
Message-Id: <1236516101.4205.15.camel@johannes.local> (sfid-20090308_134151_601303_49A68BA6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P2WQzywKoZv1uWrT5wML
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-02 at 13:28 +0530, Sujith wrote:
> There is no need to parse the AP's HT capabilities if
> the STA uses TKIP/WEP cipher. This allows the rate control
> module to choose the correct(legacy) rate table.
>=20
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mlme.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7f23858..52d876e 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1307,7 +1307,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct iee=
e80211_sub_if_data *sdata,
>  	else
>  		sdata->flags &=3D ~IEEE80211_SDATA_OPERATING_GMODE;
> =20
> -	if (elems.ht_cap_elem)
> +	/* If TKIP/WEP is used, no need to parse AP's HT capabilities */
> +	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_TKIP_WEP_USED))
>  		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
>  				elems.ht_cap_elem, &sta->sta.ht_cap);
> =20

--=-P2WQzywKoZv1uWrT5wML
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJs70CAAoJEKVg1VMiehFYSfYQAJ1nv6M4iAe17ALZe+a34+XV
fYZce2Kt4dC5qXnwxwUcCiF9iKAftvtYekewCAdYyP0FwNHYJcoo72HPkPzh1pEi
2zeM1XWih6FlVoFS6FiPgqG5vlm/0c6UMSJ26wY1q6pBCmY6OMSjik4ZHKBf7qLT
nELRlOBvW4qQdixN1EEO6lg81qFdkPDAc8vGlQPzifo45EiH3GQcS2ZybbmWV2dz
T12OENeowcm8KLJ4AmDdw22QcAwO2vg2uo2S9jckYzu7lXyTUKYvxgYeATqat1VP
3//vIhX7te/V9CdFIQ1ZrRBbeN17bYrShrtWJ6qPDp1EVcG3NsZaYFd41z0qzZVH
P/a09OKYeM2nw0e5hGpiI1L7BbbY7lHvfy8Nu7qd7E4QI2UjHm0NarnfRoVYxqKW
ycuYg7/L/3Mw5aJzjb5ARWn6Yesfp/09m3XkGUGwmavkVZaZj73D0RwTXYHZqSxS
+/zsdD2DYKT1lJZD62oD0fW5BAgHRuzHvLSRa6YL+QJ1ksL+MfcjN7UIVaoToqjB
fEg/lOjVbPk/q/77Yt/iw0aKlCg0aqy8BBYaTWFFCfZOaLDNCF129f+vkg/esUms
N0oIp5Xdkhs+1upIBhzSnFqGW8Ulbh+ztRK6vyBzCOUhV+abGBTDN2DOzqbWTBUX
ACLII6QZKZSLEwumgQkD
=QUTJ
-----END PGP SIGNATURE-----

--=-P2WQzywKoZv1uWrT5wML--

