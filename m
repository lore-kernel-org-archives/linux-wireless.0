Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35993 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbYECWjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 18:39:09 -0400
Subject: Re: multiqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805040035.05512.IvDoorn@gmail.com> (sfid-20080504_002842_649419_AE776B2B)
References: <200805040035.05512.IvDoorn@gmail.com>
	 (sfid-20080504_002842_649419_AE776B2B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QXXkOcokSTNYmxYscaVh"
Date: Sun, 04 May 2008 00:39:00 +0200
Message-Id: <1209854340.3673.23.camel@johannes.berg> (sfid-20080504_003842_600777_B34A64BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QXXkOcokSTNYmxYscaVh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

> Below is a warning I get with your latest QOS patch series,
> rt61pci registers 4 queues, but apparently the WARN_ON()
> in ieee80211_wake_queue is being triggered.
>=20
> void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
> {
> 	struct ieee80211_local *local =3D hw_to_local(hw);
>=20
> 	if (netif_is_multiqueue(local->mdev)) {
> 		netif_wake_subqueue(local->mdev, queue);
> 	} else {
> 		WARN_ON(queue !=3D 0);
> 		netif_wake_queue(local->mdev);
> 	}
> }
>=20
> CONFIG_MAC80211_QOS is enabled in the kernel configuration,
> and debugfs shows that rt2x00 is serving frames over multiple
> TX queues, so the multiqueue is working...

Strange. Can you verify that the master device has the
NETIF_F_MULTI_QUEUE flag set? Since that config symbol got enabled you
must have multiqueue code compiled in. Or maybe I put the setting of the
MULTI_QUEUE flag into a wrong patch by accident? Check
net/mac80211/main.c please

johannes

--=-QXXkOcokSTNYmxYscaVh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBzpg6Vg1VMiehFYAQKtCRAAxUFvYy5XoqlWaDrfTunus9nWQrzNdd5P
WCTMgKfE2/geKYe1/g+mtA0Vg9llz2oBp8POcXfJUfjw2tsPIHjfvQPNLt+6mc32
iWegoq8RekXR3LLpz1OutIRrzWnOnMezV0cH4eoGh6i8hoRUvcPLw9ykGvV9FTWf
DFUGAXSetv917IBKXZgC0e+KCAAn9A2caEssONsuxQf+YC8+YT23wTLNOP4r2NN0
ynT0mfh68a/vCvskIHpSOBaqhhIcV98ulrC4fZtGbXiEvLy6pcyWSAorKrJAm7hZ
zyIua2DoDNmPEVV6DwU8hALqi5cCAxQs9KfKJn3lr2GXDpw8si142i/2AP9Sgctm
tYjbzSjIe7xF8WJI45ABb4Sr+VKjtjX3sUsn6KClhXyhF5AezoeXY0aeEspBR3WS
9CT4Isx0952/DqVDBVDifV8wp6mKNXlq9hXj6KW2zbIbn2iVx3pdyZ2+PA38rwWQ
vq7d9rf9PGtqVy6UFV9i0OCp0r26jn10j3PB6L1OqOn0+UFfgazuM36I0hZNrPeH
UI5Sd9WgSPnalFUS3hMHGrdx49R63UXA9NU0A/0c1MDu7gvsp5mksYY9yXR+mA6X
PXhdUFkehqseu9lH910xYAw7eG184D8fBhP3oocko38Fx6+M+gMQHtA+jKi+eg3d
0n6GfnCX4uY=
=b/qr
-----END PGP SIGNATURE-----

--=-QXXkOcokSTNYmxYscaVh--

