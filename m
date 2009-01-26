Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZAZSdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:33:44 -0500
Subject: Re: [PATCH] mac80211: convert to net_device_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: flamingice@sourmilk.net, linux-wireless@vger.kernel.org
In-Reply-To: <20090127052926.44d3fd5f@s6510>
References: <20090127052926.44d3fd5f@s6510>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jrPzp89Q7OMiXz9bsDXB"
Date: Mon, 26 Jan 2009 19:33:31 +0100
Message-Id: <1232994811.4533.31.camel@johannes.local> (sfid-20090126_193348_782848_4ED0B227)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jrPzp89Q7OMiXz9bsDXB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 05:29 +1100, Stephen Hemminger wrote:
> Convert to new net_device_ops in 2.6.28 and later.
>=20
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> --- a/net/mac80211/iface.c	2009-01-17 12:27:00.000000000 +1100
> +++ b/net/mac80211/iface.c	2009-01-25 21:03:03.737986092 +1100
> @@ -569,18 +569,21 @@ static void ieee80211_set_multicast_list
>  	dev_mc_sync(local->mdev, dev);
>  }
> =20
> +static const struct net_device_ops ieee80211_netdev_ops =3D {
> +	.ndo_open		=3D ieee80211_open,
> +	.ndo_stop		=3D ieee80211_stop,
> +	.ndo_start_xmit		=3D ieee80211_subif_start_xmit,
> +	.ndo_set_multicast_list =3D ieee80211_set_multicast_list,
> +	.ndo_change_mtu 	=3D ieee80211_change_mtu,
> +	.ndo_set_mac_address 	=3D eth_mac_addr,
> +};
> +
>  static void ieee80211_if_setup(struct net_device *dev)
>  {
>  	ether_setup(dev);
> -	dev->hard_start_xmit =3D ieee80211_subif_start_xmit;
> +	dev->netdev_ops =3D &ieee80211_netdev_ops;
>  	dev->wireless_handlers =3D &ieee80211_iw_handler_def;
> -	dev->set_multicast_list =3D ieee80211_set_multicast_list;
> -	dev->change_mtu =3D ieee80211_change_mtu;
> -	dev->open =3D ieee80211_open;
> -	dev->stop =3D ieee80211_stop;
>  	dev->destructor =3D free_netdev;
> -	/* we will validate the address ourselves in ->open */
> -	dev->validate_addr =3D NULL;
>  }
>  /*
>   * Called when the netdev is removed or, by the code below, before
>=20

--=-jrPzp89Q7OMiXz9bsDXB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfgH4AAoJEKVg1VMiehFYOvoP/1OEg/vJA4bULxvfCWn2FnxP
87XtVCc+1CxhPaZnADJv9MnDGoVz0TJPSmSiRU62CYkGvW1KGoo6wgraW5gMfWar
IzYBu2GalKL/0yWAdddZ1fDMU5Nez0lXIXcc+kgeNYm9lMeCWKxxrgGuzNSG+Xnl
7wZwRhgM7cBBU69cc6ZSHzFTtNazuweYTDtbzt+vwZs323sXAw9QtRPnEVd/mKy2
6A29+DbwstL4XhHOVklxK73qTBS/JXxFKI4gJaGE3GwPcHsVmg1xHzDQalGXDVPO
Lp6LBB9p6eQEjNhnYgYKBsyzpYHv3L/m41nJEoRoruekGzdXhLFfLWzT79IgaCDf
hsIZFBLLKhqLqbHQ42X26cefUxk1b94gLK8p/B9LCRHtU8iK0JgmWy5CrKnTZGNL
m0dxRl1xsIaZU4m1rWS3Dud/rimNTjyaR62QkUIOpMknL5xHboF1Y9t6hirZLaxu
zGtLw0AR94z0kWtxfIsAR5JSumEI5kFkrJE2OHDteJ8i9mDMwEnxNwMf5jDFxZo8
O7buVSVh4L9S9fh5zUabodspe8B/Nv1sjKUHWzZ7wnBw4nNeVQQhQdBQ1RO/MQGI
ZxZpGYcjkzL/sYnQHxlE1IRpRH2jPZ27JVsyiWYGJ5VA2F/FpDyfLteagmRlSkIY
4Sx1WZcvVJ+wxA9Th4ks
=ETi6
-----END PGP SIGNATURE-----

--=-jrPzp89Q7OMiXz9bsDXB--

