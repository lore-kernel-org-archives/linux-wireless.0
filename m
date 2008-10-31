Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYJaVyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 17:54:31 -0400
Subject: Re: [PATCH] mac80211: disable BSSID filtering for mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <490b7d94.18038e0a.6666.ffff8d72@mx.google.com> (sfid-20081031_225017_677715_6F575E2C)
References: <490b7d94.18038e0a.6666.ffff8d72@mx.google.com>
	 (sfid-20081031_225017_677715_6F575E2C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ygGcKVmyrYPBQy9G4PQ5"
Date: Fri, 31 Oct 2008 22:54:30 +0100
Message-Id: <1225490070.3550.2.camel@johannes.berg> (sfid-20081031_225435_956380_9B679AD2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ygGcKVmyrYPBQy9G4PQ5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 14:50 -0700, Andrey Yurovsky wrote:
> Mesh interfaces are currently opened with the FIF_ALLMULTI rx filter flag=
 set,
> however there is no BSSID in mesh so BSSID filtering should be disabled b=
y
> setting the FIF_OTHER_BSS flag as well.  Also explicitly call=20
> ieee80211_configure_filter for mesh.
>=20
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozbit.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index cde1452..6c3901a 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -229,8 +229,14 @@ static int ieee80211_open(struct net_device *dev)
>  		if (res)
>  			goto err_stop;
> =20
> -		if (ieee80211_vif_is_mesh(&sdata->vif))
> +		if (ieee80211_vif_is_mesh(&sdata->vif)) {
> +			local->fif_other_bss++;
> +			netif_addr_lock_bh(local->mdev);
> +			ieee80211_configure_filter(local);
> +			netif_addr_unlock_bh(local->mdev);
> +
>  			ieee80211_start_mesh(sdata);
> +		}
>  		changed |=3D ieee80211_reset_erp_info(sdata);
>  		ieee80211_bss_info_change_notify(sdata, changed);
>  		ieee80211_enable_keys(sdata);
> @@ -456,8 +462,15 @@ static int ieee80211_stop(struct net_device *dev)
>  		/* fall through */
>  	case NL80211_IFTYPE_MESH_POINT:
>  		if (ieee80211_vif_is_mesh(&sdata->vif)) {
> -			/* allmulti is always set on mesh ifaces */
> +			/* other_bss and allmulti are always set on mesh
> +			 * ifaces */
> +			local->fif_other_bss--;
>  			atomic_dec(&local->iff_allmultis);
> +
> +			netif_addr_lock_bh(local->mdev);
> +			ieee80211_configure_filter(local);
> +			netif_addr_unlock_bh(local->mdev);
> +
>  			ieee80211_stop_mesh(sdata);
>  		}
>  		/* fall through */
>=20
>=20
>=20

--=-ygGcKVmyrYPBQy9G4PQ5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJC36SAAoJEKVg1VMiehFYOpwP/2go0dD9q91Dx3fvo47sJMpF
jB0hZyTobI70mPPAfwTNPkQm/iyFgWVIoFb5AfiAaq1HdRSnPpu6toEpFofk/0H/
WTcRWm9avKJqWBvsJgFB507pTFKYg/WkoJYAXovd6LapjEwaO73PHmqh2mpBqUq9
azVfTx63Ru8MJLRFnwrqsnh3FRuFbzqiS/ymSeojoGOuzIr1wASJO2AHPprlbhoc
kNQSRfzRRb1kO813aWX1LfWAvIUCRXEtkbhOvgB61lZ4osPdLvoaPmXQ8QmYVrOU
ztaffqqK6vGbaKMvNgcuy2MT/rKxYG/ohp5A5Md1CpjymRxg4qMk4rp9lf4OZRJq
KzPpFK+3nniS2Oz3iXvb7dK+LBUB4nOZu1x0F+2JqUeBD8h+qHv7G1A2RYDt8kOe
r2hAR/or9+J6lMk8J4JXVv/kFLesLrJ4vR+cjoAqfpXL2qeJvVNU7ppf/dSwdXFl
O+8ufm2yIwIZzhvBUbPgeeAACkOPWadnv0SxhZ8AC6f1ZR8C4/TE3gudK3m98VXn
3jkQlceCNoMNN5u8zh7ZL1M56RkOFrjQpOEKx42WU6liX6pXzVx/dw50SyLEdCnm
It5KIss1VHsXd7TyM+lsQv5COoEtgs+sAemMdixO6e+ZEgeV44CoUepa+y8DAB6z
spU0te4FAgGb16JhrYts
=ir4k
-----END PGP SIGNATURE-----

--=-ygGcKVmyrYPBQy9G4PQ5--

