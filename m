Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZCHMwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 08:52:55 -0400
Subject: Re: [PATCH] mac80211: Update IBSS beacon timestamp properly
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18860.46550.551064.448896@gargle.gargle.HOWL>
References: <18860.46550.551064.448896@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UFO2/F6kuwI5ZaK3a+Xk"
Date: Sun, 08 Mar 2009 13:52:50 +0100
Message-Id: <1236516770.4205.17.camel@johannes.local> (sfid-20090308_135403_905459_EA79BC75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UFO2/F6kuwI5ZaK3a+Xk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-03 at 10:15 +0530, Sujith wrote:
> In IBSS mode, the beacon timestamp has to be filled with the
> BSS's timestamp when joining, and set to zero when creating
> a new BSS.

I don't quite understand why, do we read it out again at any point?

johannes

> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  net/mac80211/ibss.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index a96ce9d..f4becc1 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -64,7 +64,7 @@ static int __ieee80211_sta_join_ibss(struct ieee80211_s=
ub_if_data *sdata,
>  				     const int freq,
>  				     const size_t supp_rates_len,
>  				     const u8 *supp_rates,
> -				     const u16 capability)
> +				     const u16 capability, u64 tsf)
>  {
>  	struct ieee80211_if_ibss *ifibss =3D &sdata->u.ibss;
>  	struct ieee80211_local *local =3D sdata->local;
> @@ -127,6 +127,7 @@ static int __ieee80211_sta_join_ibss(struct ieee80211=
_sub_if_data *sdata,
>  	memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
>  	mgmt->u.beacon.beacon_int =3D
>  		cpu_to_le16(local->hw.conf.beacon_int);
> +	mgmt->u.beacon.timestamp =3D cpu_to_le64(tsf);
>  	mgmt->u.beacon.capab_info =3D cpu_to_le16(capability);
> =20
>  	pos =3D skb_put(skb, 2 + ifibss->ssid_len);
> @@ -199,7 +200,8 @@ static int ieee80211_sta_join_ibss(struct ieee80211_s=
ub_if_data *sdata,
>  					 bss->cbss.beacon_interval,
>  					 bss->cbss.channel->center_freq,
>  					 bss->supp_rates_len, bss->supp_rates,
> -					 bss->cbss.capability);
> +					 bss->cbss.capability,
> +					 bss->cbss.tsf);
>  }
> =20
>  static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
> @@ -502,7 +504,7 @@ static int ieee80211_sta_create_ibss(struct ieee80211=
_sub_if_data *sdata)
>  					 bssid, local->hw.conf.beacon_int,
>  					 local->hw.conf.channel->center_freq,
>  					 sband->n_bitrates, supp_rates,
> -					 capability);
> +					 capability, 0);
>  }
> =20
>  static int ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)

--=-UFO2/F6kuwI5ZaK3a+Xk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJs7+fAAoJEKVg1VMiehFYj7MP/A3mGrzGJgkmY4Om5uKiIgu0
dt/BSKHvGznwy6n7hHeP6YKEf9OifHS52NX38ms9YgsM40K51Ep8tgJTqnm2SNOh
UPAhX1/uQR97I/non/fGJoNWogrB6x4nt4MO1UYXMl7sQJTlaVGXadxoJPI/IZyQ
n/RHuxdxCHhhm62nRW7Pjzm3z4xHzRCcoycNRM6H0cR5G38Cwn7AXL66Dt87K6rB
xzzVxO5mbLcjH3I5oxGa202MwuATeHcUXitcRi2BSYUH0PCWIwT3dwJA8CFkKdjQ
t3+wzsvrpjo0FtNp4b4QLd3dgzw4AwRAP3OgYmcGbi4uVkoJIf9v+tnpsm4521qp
eKtvyWOD3QToHEDvJemRJytT64FzoX4/sv8jGLXsZ25Frk9qZU6U5/SkcmMoFX+M
aHMBAgt53uhM3KNzDSxp+Vfxp+ou8JBeYnDAtMil24QjyiZjg6TMNqPt326nG8sY
ChYNYCB1OYYwQewKpSxbGll/hdm54VoLnF8xJoS24fW7jVIjo4EqXGJfXG7wDZOE
csuktV2Zpc6wgJyKX0U2J3r5f9zTU9yaF6UsdsOYTpQuPgXenj9bWBbSb4CUB6jj
5qli13lsoqwj0mJ52K0CRR0du51FECFqdhMoLJLjJezKfvRdlsZHoCBxz7iqh13a
x9HrBFRD4QQj6VAdViwE
=bAKN
-----END PGP SIGNATURE-----

--=-UFO2/F6kuwI5ZaK3a+Xk--

