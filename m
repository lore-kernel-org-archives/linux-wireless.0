Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYECXZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 19:25:01 -0400
Subject: Re: mac80211 truesize bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1209641914.3904.0.camel@johannes.berg> (sfid-20080501_133908_152591_239C8338)
References: <20080501.024320.212547875.davem@davemloft.net>
	 <E1JrW9h-0001tI-00@gondolin.me.apana.org.au>
	 <20080501.034950.261408566.davem@davemloft.net>
	 <1209641914.3904.0.camel@johannes.berg>
	 (sfid-20080501_133908_152591_239C8338)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bhEaexMM3Dfxq7npZmEY"
Date: Sun, 04 May 2008 01:24:48 +0200
Message-Id: <1209857088.3920.4.camel@johannes.berg> (sfid-20080504_012433_262530_4A7CEFCB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bhEaexMM3Dfxq7npZmEY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > @@ -699,6 +699,12 @@ int pskb_expand_head(struct sk_buff *skb, int nhea=
d, int ntail,
> >  	if (skb_shared(skb))
> >  		BUG();
> > =20
> > +	if (unlikely((nhead || ntail) && skb->sk)) {
> > +		printk(KERN_ERR "SKB BUG: Illegal pskb expand (%d:%d) "
> > +		       "with socket attached\n",
> > +		       nhead, ntail);
> > +	}
> > +
> >  	size =3D SKB_DATA_ALIGN(size);
>=20
> Ok I think I'm starting to understand this a little better. However,
> shouldn't this function update skb->truesize so if the skb is later
> attached to a different socket again it has the right size?

Judging from some of the callers, the caller should. Why?!

johannes

--=-bhEaexMM3Dfxq7npZmEY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBz0P6Vg1VMiehFYAQK0dxAAtaG6uS5y3ioYDYJZ+zRVaKcNtJWgBz8G
+KNHKHvnQ/khkJFyGvzq5+E9d7bsiuNXmjZXKT0Sc9S9Y1ZpiBk/QGRTjWfuflOm
lAQJ/Jb/9xYS5L0AtC3lKKtV9r/piDESp+bXuy9F5aLwytHwPLx012tGmkq+/sBi
K6XYQ+xIBFpYZztYEKfLN8z6h16kSfMTw0k68jnQcgA8xgXzotsd6sziuWgBSaFv
yrlXTOZ7m/a8jBP1ev0D46xflK7DeGC8p8SqKOAOLTtvq8/PMvRt0abQaFn5Fw9K
rSwAhRASKVHtTjdd2VW1sRV2uB6h06QYd4nU+/BHtdL1s6vi2k2Ye5TnIdf9ZOVJ
544vGQBJPx3Dx0DiOsdwQ/rkFWXDDplIspEgrCdWAavU7EXW7XBwOPrGWMduz1oh
bxCtntSD28XncbIrXHlo6j7VO0Nn5kD68HNmtaM4RPaVjgwsXsXIgDsXeDxAvTXa
qEyX1MDkt08Yrir9LQ4J5bZ/+yY+bXDwHbns1LrbyBxGpSkeruWpydYbh9EEWie5
3VFMj3eFxBX5lEqXWiMlOAw0ZGGVvquXNOQ4jlQX9u9rwGt2gu1ne1zi0x+QYks9
U4BsUsT8nC/AgSR2RYqT+/Kt8N6zfcPn7965qFG7rCeAYa2UV3Uv3x26rMN6QZa4
SgOiFEVbRD4=
=EXkM
-----END PGP SIGNATURE-----

--=-bhEaexMM3Dfxq7npZmEY--

