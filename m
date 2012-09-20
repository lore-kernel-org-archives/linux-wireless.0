Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60896 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab2ITNel (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 09:34:41 -0400
Message-ID: <1348148385.2388.21.camel@sauron.fi.intel.com> (sfid-20120920_153446_099457_58741F5F)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 20 Sep 2012 16:39:45 +0300
In-Reply-To: <1348147322.31352.69.camel@edumazet-glaptop>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <1348142775.2388.10.camel@sauron.fi.intel.com>
	 <1348144524.4161.26.camel@jlt4.sipsolutions.net>
	 <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	 <CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	 <1348145936.2388.18.camel@sauron.fi.intel.com>
	 <CANn89i+9Th=xVgDgoy7tHwKtLNpOC8rgJkA09nQ1Yf0zvqBw6w@mail.gmail.com>
	 <1348147353.2388.19.camel@sauron.fi.intel.com>
	 <1348147322.31352.69.camel@edumazet-glaptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-mor3c7Q7tAwCs+pa4ui3"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mor3c7Q7tAwCs+pa4ui3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-20 at 15:22 +0200, Eric Dumazet wrote:
> On Thu, 2012-09-20 at 16:22 +0300, Artem Bityutskiy wrote:
>=20
> >=20
> > OK, I've tried almost this (see below) and it solves my issue:
> >=20
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index 965e6ec..7f079d0 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -1798,9 +1798,13 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *=
rx)
> > =20
> >                 if (skb) {
> >                         /* deliver to local stack */
> > -                       skb->protocol =3D eth_type_trans(skb, dev);
> > -                       memset(skb->cb, 0, sizeof(skb->cb));
> > -                       netif_receive_skb(skb);
> > +                       if (pskb_may_pull(skb, 40)) {
> > +                               skb->protocol =3D eth_type_trans(skb, d=
ev);
> > +                               memset(skb->cb, 0, sizeof(skb->cb));
> > +                               netif_receive_skb(skb);
> > +                       } else {
> > +                               kfree_skb(skb);
> > +                       }
> >                 }
> >         }
> >=20
>=20
> OK but you cant do that, or small frames will be dropped.
>=20
> Anyway its a hack, we should find the buggy layer.
>=20
> You could use dropwatch (drop_monitor) to check where frame is dropped.
>=20
> modprobe drop_monitor
> dropwatch -l kas

I do not have dropwatch in Tizen, I need to find the sources and compile
the user-space part. Any hint where to download it?

--=20
Best Regards,
Artem Bityutskiy

--=-mor3c7Q7tAwCs+pa4ui3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQWxyhAAoJECmIfjd9wqK0vx4QAKcuHMUc6feLooix0F13fX9b
m7J9Ass2qLWVT555YD33uw/gaknUvX5eD4ihe8Z8I5mtdi5W4lenC7GoB1Jhp3f3
FVEtCw2XwuPjk8Dgve3RkVLo2S2BD8Uwuj5tMuEC5LtCyWSn5U1cwyUMM+n8HS+x
FaW5nYoiUqm0P9tQUltdtEEGXszPPIZo6ke6EGeRG78szHbGGQiJMSzy0YQ9LrCr
Qp/LrB1XYxRNX58+qX5zLZI+qFP+F/GVVosC0mxjkn0KQd1+NNWu5ercgzFCMOCo
VRTG+9rEjXzT3KjXH6AUe+oQbCJKBKYqNVE3T6OZzlFLJ7ToKrC/5xwUwc7/z000
AYoTRnUhiBTjuQNh8gFyi3vZ1iSzDoO/taN1axmeWhv8wa+qRkQPPytAzfaFtxMe
XT1l78CtJulbfyCU9tml/0k0oNb3ZdHr0X35ZxY6QXVB3neihg6/fo8LI+1KJ7zv
HwtksWxZe3CKnqz4VUSY+doztRM4fjH3sHE3gVIgXqEH5gge+UDQEU5YLZnUM8Ss
Qx5CPN4qG2IeXhWV9kzUrwBIdrimYccUpEQk73peeWx5/NLkgwR7C2Pi/CXWHBoV
5Tku4TSwkf1gRZ2eqUGUwOAHt2A1mXx1l1x6JMdjOd3XUCmFVbyGMHL0psCyjeOv
hf0JZ2ETS4join8JKIeJ
=xiw3
-----END PGP SIGNATURE-----

--=-mor3c7Q7tAwCs+pa4ui3--

