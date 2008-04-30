Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764745AbYD3UMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 16:12:03 -0400
Subject: Re: putting ieee80211_tx_control into skb->cb?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>, Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>,
	Andrea Merello <andreamrl@tiscali.it>
In-Reply-To: <200804301904.03670.IvDoorn@gmail.com> (sfid-20080430_190006_624445_F3839095)
References: <1209570457.18659.59.camel@johannes.berg>
	 <200804301904.03670.IvDoorn@gmail.com>
	 (sfid-20080430_190006_624445_F3839095)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-A+C2xsCbQOY/7FOUijcW"
Date: Wed, 30 Apr 2008 22:10:52 +0200
Message-Id: <1209586252.18659.98.camel@johannes.berg> (sfid-20080430_221218_130566_BB58EEC5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-A+C2xsCbQOY/7FOUijcW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Latest rt2x00.git needs _all_ space (48 bytes)
> However I can trim it down to 40 bytes quite easily,
> since mac80211 wasn't using it anyway I wasn't too conservative
> about the usage. ;)

Heh.

> I could even trim it down further if I disable the TX/RX dumping
> through debugfs as intermediate solution.

I'm working on a patch that keeps 40 bytes available for the driver.

> Very nice, removing the requirement to store the entire control data woul=
d
> save a lot of memory for rt2x00. (Currently it has a per-entry copy of th=
e
> tx control data).

Yeah, that's one thing, another is all the copying of it. Since I wrote
the mail I have extended my idea to the internal packet_data struct
which again saves a lot of code.

> > This means that the drivers are free to use everything in skb->cb for
> > their own use but should leave the 'u32 flags' intact, and need to make
> > sure to copy out all the information they need before putting in new
> > information. This fits with all the drivers, rt2x00 needs at most 32
> > bytes (40 now, but one is the txcontrol pointer) while we have 44 free.
> > Also, if the driver rejects the skb in ops->tx(), it must not have
> > modified skb->cb.
>=20
> For rt2x00 that won't be a problem, it won't touch the skb->cb anyway
> until it has performed all checks for queue entry availability.

Good :)

johannes

--=-A+C2xsCbQOY/7FOUijcW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBjSS6Vg1VMiehFYAQJ/HA/8DTPIZxGXBXtk+zZ8/P4jm/wKE0s2WJa6
nJgDDA2/3dTApJdFElaJOV3gC5TRrUXLMkzjJ8ESHOe2XOkzccNH8kLAY2sugnww
1GhYPJenNXn6153G/uBvdkJfAZKmKC3MZwQPdWgtUw7dvdBR/wXCOy39PqfdqEj+
ZmX65qC66s/XSAwSDp6SlnQ45Er5IwDUoHyWojHEug9pwCmy+hrDdYtnCNA2Vg6D
bzHEM26ml+9ocNVgmCvO24iYxGRRjfVDIQwGpyj0Sq5fHDts4udB6ywRV99ufkpA
OT7Pz8edhG+a87hclf947HL5g8+gPrvn5pz1ZFEYDkSrDGvmbAjhyCWc4sosWGuR
a+1EGh+Qh4hzq5ZbHOZ+TJYtC0uDig5O1wOEVWMslEn6/KxTeS8YckPiU7fLVctg
5QwVGDGcnlaRaKU6yupxS9qVugBqFwTzO1yJCsMAmL1VUZ6kHuOYcWA38rUpv6GX
nDjQGpNSbzM7FcJMqcHxGd8GXoFzkTO5JB3HN2fFlba2jy6a6CkNZguM0Mszm3s8
SWgPWqL9aHkx7og8ap3Pxwn0bc1wc8hv5kJOQNydZdEKsgGDM+42oN2nBmvJ4nNs
X6BqJRbmq/Yto6maf+9q2gf1N1gYHB2Yzg1ToANQ4cbAP07y5WpUv/6hT6+ZRkmX
Aw9ulsT+k7g=
=z1kE
-----END PGP SIGNATURE-----

--=-A+C2xsCbQOY/7FOUijcW--

