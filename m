Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYIZKwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 06:52:10 -0400
Subject: Re: [PATCH] mac80211: Fix oops on wme.c where mdev is assumed to
	be a wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com>
References: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1sfCVF8nRVuozi7hGBQf"
Date: Fri, 26 Sep 2008 12:51:59 +0200
Message-Id: <1222426319.10563.91.camel@johannes.berg> (sfid-20080926_125214_316470_E94EDE4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1sfCVF8nRVuozi7hGBQf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 02:01 -0700, Luis R. Rodriguez wrote:
> After Johannes' patch which set mdev as non wiphy
> there were some remaining bits of code which required
> changing the assumption that mdev was a wiphy. We
> change two callers to get to struct ieee80211_local
> the non-wiphy and actual mdev way.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

I _really_ wonder why I haven't run into this. Odd. Thanks for fixing.

> ---
>=20
> Tested with ath5k on v2.6.27-rc7-1972-gfb8961a.
>=20
>  net/mac80211/wme.c |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
> index 6748ded..7d114bd 100644
> --- a/net/mac80211/wme.c
> +++ b/net/mac80211/wme.c
> @@ -75,8 +75,16 @@ static int wme_downgrade_ac(struct sk_buff *skb)
>  /* Indicate which queue to use.  */
>  static u16 classify80211(struct sk_buff *skb, struct net_device *dev)
>  {
> -	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_local *local;
>  	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
> +	struct ieee80211_master_priv *mpriv;
> +
> +	/* this is not for wiphys, just for mdev */
> +	BUG_ON (dev->ieee80211_ptr);
> +
> +	mpriv =3D netdev_priv(dev);
> +	local =3D mpriv->local;
> +
> =20
>  	if (!ieee80211_is_data(hdr->frame_control)) {
>  		/* management frames go on AC_VO queue, but are sent
> @@ -114,12 +122,19 @@ static u16 classify80211(struct sk_buff *skb, struc=
t net_device *dev)
>  u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
>  {
>  	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
> -	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_local *local;
>  	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> +	struct ieee80211_master_priv *mpriv;
>  	struct sta_info *sta;
>  	u16 queue;
>  	u8 tid;
> =20
> +	/* this is not for wiphys, just for mdev */
> +	BUG_ON (dev->ieee80211_ptr);
> +
> +	mpriv =3D netdev_priv(dev);
> +	local =3D mpriv->local;
> +
>  	queue =3D classify80211(skb, dev);
>  	if (unlikely(queue >=3D local->hw.queues))
>  		queue =3D local->hw.queues - 1;

--=-1sfCVF8nRVuozi7hGBQf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3L7LAAoJEKVg1VMiehFYAQIP/A69R1/2nF669acln9HhPj/g
TVY3QxYEB9QvatR7H/oNwuXpcFQh6rLoJQPMIbV1fLnzybGMS7qixftjv2+dEHMK
EpkuQv44me1Z+EfPbI5s6h/4Wx0hhJFt63wl8LMMSfdbjfrO5NYrXblwATYUlsZQ
Wcsc5yE+NH+03rGAycu0p8FPKgM26Jt/1w+JuxUq32ooP70r1IVDN6284qU/1PJ7
OibwxrR8vaIXenUP80gFRPDZPtOxLei5ZvT4o2qHd1rcwl6q6AMgAphB+8IDwo83
tYgIiSCsVnfydzEhPCE0X/B8PKudetrC2F7OyD2bM08fLZPpSAZhhRVUOOsAgAYo
oyKZiJhop//9VLfsyt4o7EvAESHS8SwAjXhV2I8Onm8ftKWQrp9GJfb3uX1rJ/L3
Z5eqNPu+y+y6xBOtSE44LN4GqSC+HKZHBdE80mcUjxdC/KLZWrniZulFptRF4YV6
Xz2lxthNkUYCIR/NdYgv/qt99WTn2SClGyDmKn2HT1rXl47QL/boHLMWocJeFEub
49qBl1nUxLETmj6mi1iL8qkdG8CZQKNtLpblWehnIh1wFhIsvJWFYQg2CxAWJsbD
JmQz0Gne8PC1jFlq38EbJ0C3JkvxTXSr8SrNiSs/+opB0GNAEn6DjUkGQofSgam0
BLuZxIxCn3ALVV7mro+B
=wInW
-----END PGP SIGNATURE-----

--=-1sfCVF8nRVuozi7hGBQf--

