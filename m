Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZG0Raq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 13:30:46 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248711120.6965.6.camel@mj>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
	 <1248683249.19945.29.camel@johannes.local>  <1248708886.2688.4.camel@mj>
	 <1248710387.8500.5.camel@johannes.local>
	 <1248710568.8500.7.camel@johannes.local>  <1248711120.6965.6.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-erBjICfnfhhUIG5ApKLY"
Date: Mon, 27 Jul 2009 19:30:13 +0200
Message-Id: <1248715813.11549.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-erBjICfnfhhUIG5ApKLY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 12:12 -0400, Pavel Roskin wrote:
> On Mon, 2009-07-27 at 18:02 +0200, Johannes Berg wrote:
>=20
> > Actually, you're using ath5k, right? So we can see what
> > info->control.vif points to after ath5k has used the skb, because
> > apparently it's a valid pointer at least, just not a real vif pointer
> > any more.
>=20
> I'm using ath9k.
>=20
> Here's something interesting I have found.  sdata->dev is valid if
> info->flags is 0x14091 and not valid if it's 0x12091.
>=20
> 0x4000 is IEEE80211_TX_INTFL_NEED_TXPROCESSING and 0x2000 is
> IEEE80211_TX_INTFL_RCALGO.
>=20
> This patch prevents any panics.  Moreover, I get a connection with the=20
> correct PSK.

Ok. So the question is where that skb is coming from that's causing the
issues (your patch leaks it btw)

johannes

--=-erBjICfnfhhUIG5ApKLY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbeQiAAoJEODzc/N7+QmarnkP/0CuwNIYMLp2bs6aKsw6A6Zc
EGwOc8cdPlqQfvkfy6YP3AHdLqW0gjb0+d+HTYWmghq9HKo9pli9xFhO3GmevABp
vui9ZQD36bB6jgxgzhRX7dMn1GDdKm/guu4V+cljuenKOhLjRgJDrS40+tupKrEu
Yfd4SFHScc5VLBDLBItTUAlfY9txSl5JeCOeccMJn2tR6GYdjwaYTo0yAl8qrqn0
w1wH/vdEOjwz4aX1suTD6XZ43NeoS5iVKHqXP7UEy6zh4NOULyxjVge/yWBmuSc1
wiVwMg1oYRflgpLBkQj+e/pdu70J0uAobJAHJpyjCC4HIdk3J1bEkspKiu+pIwg3
yL0AjhWBXB3ZY8qp6O9kYzxW86+KENLfgVhgU7T67fZ12w+uqDIwwiFV7ylnnxKq
h1gl+9TrDJKRvBeYWNnYaHnGpmQ0R0oZ6pOjlvFPw01gjFEqszcZGZ7IQOfRKKLc
0TxiUGS2TxOMj+HLRMI+x3JVz0urZgBPwPVjNFZVuz3gGYAoKbTXtto+hRp+xD7Y
RqqryI90TuzB/AeZQStGFCocPULjzT6MEECxzY0/eQkNhekqpMAbFNoNwTrGKTEW
NtZwm5wdMl9KzZXhD8ictBW3KQxHh74Z2fKlkazYixmbIxOH3IS6szkyrfg603vb
vq9hq8fgoIOwPL3iB1cX
=V9ty
-----END PGP SIGNATURE-----

--=-erBjICfnfhhUIG5ApKLY--

