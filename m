Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYGWOxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 10:53:53 -0400
Subject: Re: q == &noop_qdisc warning from 802.11 code
From: Johannes Berg <johannes@sipsolutions.net>
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	netdev <netdev@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48873502.1030106@linux.vnet.ibm.com>
References: <488723FF.8070707@gmail.com>
	 <48873502.1030106@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kZWZg+XRbptxpsYasww1"
Date: Wed, 23 Jul 2008 16:53:05 +0200
Message-Id: <1216824786.13587.6.camel@johannes.berg> (sfid-20080723_165357_798339_A33454F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kZWZg+XRbptxpsYasww1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I also hit a bug related to noop_qdisc running the net-next kernel.=20
> I hit this bug every time I run "ifconfig eth0 mtu 9000; ifconfg eth0 150=
0" for any
> interface (tested against s2io and e1000) that is up, otherwise the bug i=
sn't
> reproducible.
>=20
> The bug dumps the following calltrace:=20
>=20
> [root@io-dolphins net-next-2.6]# ifconfig eth0  mtu 9000; ifconfig eth0 m=
tu 1500
> ------------[ cut here ]------------
> kernel BUG at net/core/dev.c:1328!

> void __netif_schedule(struct Qdisc *q)
> {
>         BUG_ON(q =3D=3D &noop_qdisc);
>=20
> So, somehow we're reaching __netif_schedule() using a noop_qdisc.=20

Yeah, I'm looking into it. Just removing the netif_wake calls in mlme.c
might work.

johannes

--=-kZWZg+XRbptxpsYasww1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIh0XOAAoJEKVg1VMiehFYcN8QAL54wgOVKSi9Cc0Ud2DT43Hb
uk4aPPnbJd5YoQWRxD5HswVG616SDd6Bfd8jmbljgBoT/QUvOabaKTrUKN5dHICZ
HG5CmqArK290WX0Fewj6bwBm2ctGeItRx4Baj7AUE1x2q+dHtYOT1R0gTZWg5p7P
myrw15Ch4joAxj5JUIbbHnQFs34YSLNRj3TTJ0/BgT14rbQzrVLhjrvNNO2iDwKY
1pFgcvKrZrEq1DcjOA4No3rp4DoocH3mZUjQJFFjPP/zsBlcu3g/HngnLr8pox47
JPx+wVqY9GBXPqhpZ28YRglWaYdW9SA7Cc0d8jKxx06IvcVyJ+z/9WQ9+Yex6QlY
7Il/962BI7gbvg7MQh1GHAzHNvqFsmMms+tMTFk1M3IY2yxtH3YwR7K+JQynFA/+
7taeoKlJ4GQA2sgtup91yrPmbkEXhoDzIXVgPYh2FrQluMxuvtxztIdSY7TZ5ZW3
mpWdhQ3B7EViclV9RclCa4AteEN7awgtM6xnQhRaNRyjXE4X3o6al7OLkvDG+zhR
gReIQWQ1pyP8xsaolGTyL3dOz3Mpfn/4oFdYjFPgZdyR+aGvrPcNUR+Wr5sCajbD
zdwdJ4fg/37kR+7sE686zfVE9O49s1lpR1NcWDGJqkX1MCK3/gLdqFSV0mzvTTgL
gIkqp3/78OyJ93zXF3iv
=s/3a
-----END PGP SIGNATURE-----

--=-kZWZg+XRbptxpsYasww1--

