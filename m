Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZCMJXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 05:23:24 -0400
Subject: Re: ath9k fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <18873.48952.353253.595670@gargle.gargle.HOWL> (sfid-20090313_030441_815758_BD575074)
References: <1236881434.25931.1.camel@johannes.local>
	 <18873.48952.353253.595670@gargle.gargle.HOWL>
	 (sfid-20090313_030441_815758_BD575074)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h5olX98KcOCZCabDnQTr"
Date: Fri, 13 Mar 2009 10:03:04 +0100
Message-Id: <1236934984.25931.48.camel@johannes.local> (sfid-20090313_102342_831503_5C1321CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h5olX98KcOCZCabDnQTr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-13 at 07:34 +0530, Sujith wrote:

> Sequence number handling is pretty much borked in ath9k.
> There is a comment in assign_aggr_tid_seqno@xmit.c - and it doesn't make =
much sense.

Indeed, that doesn't seem to reflect the code at all.

> Removing all crappy code in ath9k dealing with this and leaving everythin=
g
> to mac80211 would certainly be the better option, but we still have to fi=
gure
> out how to manage BA windows.

Can you explain a little what is required?

For ampdu_action(), I recently saw something, somewhere, saying
"mac80211 expects us to fill in the seqno variable" or so, but this is
only true if you don't use mac80211's sequence numbers, otherwise it is
fine to leave it at the pre-assigned value.

johannes

--=-h5olX98KcOCZCabDnQTr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJuiFEAAoJEKVg1VMiehFY7HAP/0RrVxKJeNLLyHkT21JABjYt
DEWMMwDSCuAzI0IifOUaoG9seS5c1ZG4m8CupharzGltrsNjQ3qLq4lRuRPN2Spu
eKk6HfXnvelLTbk2wHD0hSYwyzYYh8Mwxp5uRJ6NooC31IiKLa15ThaP6tdA+wGT
OXaCGRHpe/stofxrCWMmnimNFY/vV7fROV7+7xdD/VzEmrOGw27GkNSd5n9C5grj
z9LIPAgKu/QvWML75fXe2pUPUuFsmKyWqTSWnq/aBKCGKkEtFUXgF2Kc+eesl84h
8nGD0+Y8EKWOGtbKnHUirC9zO6NeWZxjd5l8Qc9hvpyPogoef2ur20bpQyMsJcTL
0s0OwUtZ8BhkXn/eHVpEM4Fg9mCWOQ2TCsmdOKpE0qOCgWuUK00gjolS8tMSGJ85
Imj/K+oqjKd+dbKZa5nxUJZv6KRsbB1ORj1ej8YT2RcnZG5YTD8JvkdHGcGwOVoW
HBFYL5ySXcrLcSRk4+sPosL4I9hZQjvTOkYzOyY8pCCXu8itcc31dWWlrU1AcnLg
BBPEIucJSNnZLmyS32gEzx7Ky5OUBcWy8g5ZhWQepVlH5xxEvK2uhfKaPqTjELxS
2r8ED1u9QEfnY+121Kd0T4o9M0NCA4Qeb28Lryd/h9DzF9hvU3N2DnUI89BXVGld
p4CoEJeVugfseJ5P8/W/
=Lj2P
-----END PGP SIGNATURE-----

--=-h5olX98KcOCZCabDnQTr--

