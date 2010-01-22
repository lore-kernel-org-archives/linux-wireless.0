Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab0AVJ1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 04:27:47 -0500
Subject: Re: [PATCH] mac80211: fix rx data handling for non-data frames on
 multiple vifs
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4B58E507.9000101@openwrt.org>
References: <4B58E507.9000101@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cEKtj54NCSq5/tu66s+e"
Date: Fri, 22 Jan 2010 10:27:41 +0100
Message-ID: <1264152461.11396.81.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cEKtj54NCSq5/tu66s+e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-22 at 00:36 +0100, Felix Fietkau wrote:

> Fix this by restructuring the loop so that it prepares the rx data just
> before making the skb copy and calling the rx handlers.
>=20
> Cc: stable@kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2348,22 +2348,6 @@ static void __ieee80211_rx_handle_packet
>  			    sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
>  				continue;
> =20
> -			rx.sta =3D sta_info_get(sdata, hdr->addr2);
> -
> -			rx.flags |=3D IEEE80211_RX_RA_MATCH;
> -			prepares =3D prepare_for_handlers(sdata, &rx, hdr);
> -
> -			if (!prepares)
> -				continue;
> -
> -			if (status->flag & RX_FLAG_MMIC_ERROR) {
> -				rx.sdata =3D sdata;
> -				if (rx.flags & IEEE80211_RX_RA_MATCH)
> -					ieee80211_rx_michael_mic_report(hdr,
> -									&rx);
> -				continue;
> -			}
> -
>  			/*
>  			 * frame is destined for this interface, but if it's
>  			 * not also for the previous one we handle that after
> @@ -2375,6 +2359,22 @@ static void __ieee80211_rx_handle_packet
>  				continue;
>  			}
> =20
> +			rx.sta =3D sta_info_get(prev, hdr->addr2);
> +
> +			rx.flags |=3D IEEE80211_RX_RA_MATCH;
> +			prepares =3D prepare_for_handlers(prev, &rx, hdr);
> +
> +			if (!prepares)
> +				goto next;
> +
> +			if (status->flag & RX_FLAG_MMIC_ERROR) {
> +				rx.sdata =3D prev;
> +				if (rx.flags & IEEE80211_RX_RA_MATCH)
> +					ieee80211_rx_michael_mic_report(hdr,
> +									&rx);
> +				goto next;
> +			}
> +
>  			/*
>  			 * frame was destined for the previous interface
>  			 * so invoke RX handlers for it
> @@ -2387,11 +2387,22 @@ static void __ieee80211_rx_handle_packet
>  					       "multicast frame for %s\n",
>  					       wiphy_name(local->hw.wiphy),
>  					       prev->name);
> -				continue;
> +				goto next;
>  			}
>  			ieee80211_invoke_rx_handlers(prev, &rx, skb_new, rate);
> +next:
>  			prev =3D sdata;
>  		}
> +
> +		if (prev) {
> +			rx.sta =3D sta_info_get(prev, hdr->addr2);
> +
> +			rx.flags |=3D IEEE80211_RX_RA_MATCH;
> +			prepares =3D prepare_for_handlers(prev, &rx, hdr);
> +
> +			if (!prepares)
> +				prev =3D NULL;
> +		}
>  	}
>  	if (prev)
>  		ieee80211_invoke_rx_handlers(prev, &rx, skb, rate);

That's kinda subtle, but looks correct at first and second glance,
thanks.

johannes

--=-cEKtj54NCSq5/tu66s+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWW+JAAoJEODzc/N7+QmaYTwQAJsHrwWJl2mP9Lcwo+4KY9z4
ScgYbxF4zu9x3Cvgb4ew6TmJqVkE/bT0AaDrXfeaQiEDAB42675jd06zyzLrbFzk
3VryeMTYnJc1guGOvamj/NGZt1kCTKkDkGXIPfVm2WUMJ8rBarVCGixkFcOaBsPL
gpztdoJowz5bG1+VQrcVM3TaqptWp78lgkTkYQwZzlZoIvu2yrYo9/iCbPiuE9Ih
Dhsdkle9PaKHQMiw8QYyyuWjxSswnplC4nVz3X4xLDULiwwczwrclOd9br0fh3kF
iHDuHr3zZiiVOryTfSx3Dfzs7yK3Ul6ZIhxjbusaUxZE20YD/4v1jalWIsydbbQb
GF1LmFK7iQdFrzk1gsmgKyzyZxxN22HMbedBX6Bc6Huzj7/Gz86wNTtIMzDKXOUM
RNPjMELDM+hOaI3jeLovBMZbNlgF0ou2eTFtkk9a5UKQR21enH3/Q/sd+Akjkc+Z
NIttoyYhF3TnrwoNaSpTgbFItcLOLeDDPnAcf/V3M6E9dBsPqIT98uGwNb678Kfd
4EEzrOmJowoShtgXcbdQjlEnMxTKCu00OplM9dW1Z9ZgJ9ObZ7anqMygFH+TtEWi
Jdodg+MXI94ZEa7kdBt1SwihG6SsCcoqrD/ZahmwojvuhCelMUdIkrAawLvyVNZv
gXj51nsLVrtAjgjjpMI9
=NWbM
-----END PGP SIGNATURE-----

--=-cEKtj54NCSq5/tu66s+e--

