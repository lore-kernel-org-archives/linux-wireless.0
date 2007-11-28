Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353AbXK1Nbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 08:31:49 -0500
Subject: Re: [PATCH] mac80211: Fix behavior of ieee80211_open and
	ieee80211_close
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071128065708.9961.15992.stgit@tetra.sourmilk.net> (sfid-20071128_065705_054871_55A99BBC)
References: <20071128065708.9961.15992.stgit@tetra.sourmilk.net>
	 (sfid-20071128_065705_054871_55A99BBC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UAh7z6ZKxb61ndHTnBi/"
Date: Wed, 28 Nov 2007 14:31:30 +0100
Message-Id: <1196256690.6058.133.camel@johannes.berg> (sfid-20071128_133155_384376_E46A41B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UAh7z6ZKxb61ndHTnBi/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-11-28 at 01:57 -0500, Michael Wu wrote:
> This patch fixes:
> - Incorrect calls to ieee80211_hw_config when the radiotap flag is set.
> - Failure to actually unset the radiotap flag when all monitors are down.
> - Failure to call ieee80211_hw_config after successful interface start.
>=20
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>

Thanks. I knew about the second one and just ran into the third one
yesterday after fixing up iwlwifi's radiotap support.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/ieee80211.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 59350b8..fc8b29c 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -216,6 +216,7 @@ static int ieee80211_open(struct net_device *dev)
>  			res =3D local->ops->start(local_to_hw(local));
>  		if (res)
>  			return res;
> +		ieee80211_hw_config(local);
>  	}
> =20
>  	switch (sdata->type) {
> @@ -232,7 +233,6 @@ static int ieee80211_open(struct net_device *dev)
>  			netif_tx_unlock_bh(local->mdev);
> =20
>  			local->hw.conf.flags |=3D IEEE80211_CONF_RADIOTAP;
> -			ieee80211_hw_config(local);
>  		}
>  		break;
>  	case IEEE80211_IF_TYPE_STA:
> @@ -334,8 +334,7 @@ static int ieee80211_stop(struct net_device *dev)
>  			ieee80211_configure_filter(local);
>  			netif_tx_unlock_bh(local->mdev);
> =20
> -			local->hw.conf.flags |=3D IEEE80211_CONF_RADIOTAP;
> -			ieee80211_hw_config(local);
> +			local->hw.conf.flags &=3D ~IEEE80211_CONF_RADIOTAP;
>  		}
>  		break;
>  	case IEEE80211_IF_TYPE_STA:
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-UAh7z6ZKxb61ndHTnBi/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR01tsaVg1VMiehFYAQLLPQ//bRmIJ9Qh03Vd530veVZuq80H1sP9qefB
jgN4qgITY2+ii+Y8J6OBPN7pqeFnM9s0Y4WJDHHG64Bix/fcv2XkY39hvP0gf2+y
eqXUFYuncV+wtI17TIBiObPK3PWGjvk5xJKgT0Xec1ikD+E9Ry4aBbl8InuJOybT
SYVtRoXu10TA0h59QCPvyUt0Cs+dsvaRIeAEgNyUrKnC7A+TZri1vW+m9fzIkAPT
swSAvr0RxDCinTz/5lY3qIhziFSX2xUKoRXDM4Z9KblvkRmasZWyB4KRaYqys5U+
cOb2P5/2ARfW9O2gerpVd9UaC6bEha3XqmbiQX16lz9GHYWvpPHjvekXiciw7tbs
3N1RvGwQPxgz7LCn9sb+RQEOPzKYZZyeDznlpq3h9VjJ/5n757zETdd/R96OXFTH
9wgZAYh82hya0VMMGZQnKKpcBIXzs0eiDFkw8p2BOY5hBF9gQ+eHAxFMKqipOOyF
duA+QayDyt+iVV0ScxRb8+npHNZXxhGNMsscOa5EtWeh3mhhafLP4BkGtytFXLYm
8y2eyWtxWRUQuP+Q9V6iCTJ8ycirODrRdD6qBu2mEJqeflMDSdYpZf4R3JaNxmz/
54EXFuLXxRpXEinaiUXoE2vQnRywDJDaxm8Cl6nsR4gpDy9+RkXpqpfY4NjFGj/w
dJ51cl5l21Q=
=B5QY
-----END PGP SIGNATURE-----

--=-UAh7z6ZKxb61ndHTnBi/--

