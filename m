Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYGXOQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 10:16:23 -0400
Subject: Re: Another fragmentation multiqueue kludge
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: David Miller <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Guy Cohen <guy.cohen@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240807240601o2c083347rf5f1b6507e0abe7c@mail.gmail.com> (sfid-20080724_150110_409891_A3939369)
References: <1ba2fa240807231441u7b870a15rb525771e364f65f3@mail.gmail.com>
	 <1ba2fa240807240601o2c083347rf5f1b6507e0abe7c@mail.gmail.com>
	 (sfid-20080724_150110_409891_A3939369)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CRg4uuGbXCU/wS6GUs+B"
Date: Thu, 24 Jul 2008 16:16:13 +0200
Message-Id: <1216908973.13587.65.camel@johannes.berg> (sfid-20080724_161627_197001_3F51818E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CRg4uuGbXCU/wS6GUs+B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-24 at 16:01 +0300, Tomas Winkler wrote:

> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 2b912cf..db6540e 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1061,13 +1061,15 @@ static int ieee80211_tx_prepare(struct
> ieee80211_tx_data *tx,
>  static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff =
*skb,
>                           struct ieee80211_tx_data *tx)
>  {
> -       struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> +       struct ieee80211_tx_info *info;
>         int ret, i;
>=20
> -       if (netif_subqueue_stopped(local->mdev, skb))
> -               return IEEE80211_TX_AGAIN;
>=20
>         if (skb) {
> +               if (netif_subqueue_stopped(local->mdev, skb))
> +                       return IEEE80211_TX_AGAIN;
> +               info =3D IEEE80211_SKB_CB(skb);
> +

This isn't right. It means that if you have a stopped queue and pending
fragments, you still transmit them, which is not something the driver
should have to expect.

>         if (test_bit(queue, local->queues_pending)) {
> +               /* don't call scheduler just open the queue */
> +               if (ieee80211_is_multiqueue(local)) {
> +                       netif_start_subqueue(local->mdev, queue);
> +               } else {
> +                       WARN_ON(queue !=3D 0);
> +                       netif_start_queue(local->mdev);
> +               }
>                 tasklet_schedule(&local->tx_pending_tasklet);
>         } else {
>                 if (ieee80211_is_multiqueue(local)) {

That's not right either, if you have pending fragments/packets then you
cannot start the queue.

I think what you're trying to do here is implement, in mac80211, to not
stop queues in the middle of a fragmented MSDU, but you really should do
that in the driver and we just remove all this code.

johannes

--=-CRg4uuGbXCU/wS6GUs+B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiI6pAAoJEKVg1VMiehFY1gcP/0Bil/EXHqQn2yGkbg/idm06
nA6FAo5iCzXaK2r8cX+Y97HgcATeAZNelWErzVzShmU7uLtKXfkNiI4oQlEQO5YN
RvLN2XQunE/9oo3gOHBzTdrJD5STEWWlA1krm6QLShH/gDclA6121FHvOXuvbWpE
NggKqN8cXI5WBRc6C6lhNZvklY7sv3NRrCQZR0kBs6EgJU0Q9xWTKDVXl+Bnikmo
W+qswUnfCOv6ut8cvoUlE9FmkvtBoWnaWrQT2aEMP8WR8U6WeEVknQjEIJO+6fvD
Cp9S5zgJr3F8t00UYbJly30p2ikLbeOjkgpNI/fYLi2813hu+pQPmUhHnA/4ygXX
KPGyRggKfr+EGA4XR6KUf4PytFsN+7tNqPj3cbI/b965guO+A62hbRw/VdH//bs/
W7UVBGg8ThfNqY3vZ7iVw22hLCSkBCAd+5o7Rc7FrKSe+Yrhft8lSoWLwo2bzmOX
KvxixEEol/c+498AWF5Ic7eNjcA+fgGBNhxKVEcuv88GrhzP8HL3Cn8g28ifmvmu
r9vqB/Yv4ET9G4p+2aPCfnlz7DG3anhbS5lrNImmJRlGqqLbVx29e9NikzRMUmyK
m5C38256PEcNuH7ZRjhq16WKjsVPLkfxst4ugq7oZWfnlyKMHTiucN6ZjDok4q8x
RhSGnNYaGkhHZGRQIH3t
=2IQL
-----END PGP SIGNATURE-----

--=-CRg4uuGbXCU/wS6GUs+B--

