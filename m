Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZBEMIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 07:08:07 -0500
Subject: Re: [PATCH] mac80211: Fix the wrong WARN_ON message appearing on
	enabling power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090205110631.GA13746@myhost.users.atheros.com> (sfid-20090205_121647_697221_4D18A79B)
References: <20090205110631.GA13746@myhost.users.atheros.com>
	 (sfid-20090205_121647_697221_4D18A79B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2YUfXG26nHOTQjCFtdoZ"
Date: Thu, 05 Feb 2009 13:07:27 +0100
Message-Id: <1233835647.3931.13.camel@johannes.local> (sfid-20090205_130812_117576_6435E6D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2YUfXG26nHOTQjCFtdoZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-05 at 16:36 +0530, Vivek Natarajan wrote:
> The warning message intended to be hit on driver's rejection of a Tx fram=
e
> is also hit while the netif_subqueue is stopped. This patch fixes this er=
ror
> case.

This seems a little odd. Why would we be in that code if the queue is
stopped?

> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  net/mac80211/tx.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index f1c726d..bf73f6d 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -35,6 +35,7 @@
>  #define IEEE80211_TX_OK		0
>  #define IEEE80211_TX_AGAIN	1
>  #define IEEE80211_TX_FRAG_AGAIN	2
> +#define IEEE80211_TX_PENDING	3
> =20
>  /* misc utils */
> =20
> @@ -1085,7 +1086,7 @@ static int __ieee80211_tx(struct ieee80211_local *l=
ocal, struct sk_buff *skb,
> =20
>  	if (skb) {
>  		if (netif_subqueue_stopped(local->mdev, skb))
> -			return IEEE80211_TX_AGAIN;
> +			return IEEE80211_TX_PENDING;
> =20
>  		ret =3D local->ops->tx(local_to_hw(local), skb);
>  		if (ret)
> @@ -1211,8 +1212,9 @@ retry:
>  		 * queues, there's no reason for a driver to reject
>  		 * a frame there, warn and drop it.
>  		 */
> -		if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
> -			goto drop;
> +		if (ret !=3D IEEE80211_TX_PENDING)
> +			if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
> +				goto drop;
> =20
>  		store =3D &local->pending_packet[queue];
> =20

--=-2YUfXG26nHOTQjCFtdoZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJitZ8AAoJEKVg1VMiehFY2UAP/RCK+tZR4xEKSJMpqdQTW1Xi
ieBubjvWURGpLZZkYVXPrQDgKSM9ac38svM1X8m5zOM3nsDBXueyFxxL9ZkM9iJd
UfA2bh1sST/mOCDczw3Rt6gSwslKtk9Qmwe2YBmzab6xHQXVSCVac7kE2hCehU97
GYWFHtS9984A/Tg65ROEeDmsVmRfSVDhCW2eVA/q79osGoj8OoCV4OIbmx5FgQ8J
HoI9Uus2WUgQQi2mQ5zGOWc1gzAKEfhtLJ4Ex+rRfcuN3cARy7PCSXhmSjWxh2di
e4mUCoNfK7yndZrqg15Mg+20whua7BnFubt9nAX2SXDzsYcmay9186gAIYIVh+N3
fnrziV9bIc1U+BsIrnP15MJ4hPcQxFuFhZ43/J1Cr7NbcCoYwxo0kbajz+qzvxds
76V3kSqmc+6KBVdx6k5zsty6/rgBNB3kofDYfewnciaAElD5Am2KoifviXxP0k2D
K9p/duTYIrM3/vhgG2Om3H8hktZ8+zMQdKG1740LTe5NOBm+YOvAKJKT+nLA9E2k
WYkfDOnYAVVOK+kpGApd/XoT+merd5I0GrmNJnIJtiPNtQvN/rym7J9nUzty97mR
Vx1gaFcltA/9L4jQ/HqfFgRl2On27hcFPvXFcdAXSWucctZUPN5uXpEckZ2sQUFC
qTG17+8WOZCYYkA5LIn8
=INze
-----END PGP SIGNATURE-----

--=-2YUfXG26nHOTQjCFtdoZ--

