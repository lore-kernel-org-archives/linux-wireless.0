Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab0AUSiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 13:38:17 -0500
Subject: Re: RFC/RFT: compat-wireless for 2.6.32.4 - MQ backport support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e891001211016i617de5c6o24fdfd1aa6f54eeb@mail.gmail.com>
References: <20100121025546.GB8069@bombadil.infradead.org>
	 <1264067069.11396.33.camel@johannes.local>
	 <43e72e891001211016i617de5c6o24fdfd1aa6f54eeb@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-njPxZfVdlYVICE2Lex0e"
Date: Thu, 21 Jan 2010 19:38:13 +0100
Message-ID: <1264099093.11396.62.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-njPxZfVdlYVICE2Lex0e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-01-21 at 10:16 -0800, Luis R. Rodriguez wrote:
> On Thu, Jan 21, 2010 at 1:44 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2010-01-20 at 21:55 -0500, Luis R. Rodriguez wrote:
> >
> >> @@ -287,7 +287,13 @@
> >>
> >>       rcu_read_lock();
> >>       list_for_each_entry_rcu(sdata, &local->interfaces, list)
> >> +#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27))
> >>               netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queu=
e));
> >> +#elif (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,23))
> >> +             netif_start_subqueue(sdata->dev, queue);
> >> +#else
> >> +             netif_wake_queue(sdata->dev);
> >> +#endif
> >
> > That's incorrect, you need to check for all hardware queues being awake=
.
>=20
> Can you elaborate? I'm not following.

Well something like

stopped =3D 0;
for (i =3D 0; i < hw_queues; i++)
	if (queue_stop_reason[i])
		stopped++;

if (stopped =3D=3D 0)
	netif_wake_queue()

johannes

--=-njPxZfVdlYVICE2Lex0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWJ8RAAoJEODzc/N7+QmaEM4QAKQlNc8MFkLH8ZIIRC38hNMq
o2y3R0l5aqZ7mE0DlVoe39QAj3KWY5jGUOtkEFgENPuPZWg0393GkLxRiNPz9LER
wR5seTcZAwhPlKPlMWyISfTGq+eaM49iUEHBdkHGJjSL5Y0cAfliSPvYYaR9o2Gq
gOMQ/AW8zYuBKNmA1Fk995aWzFnFqNjuc1wTwWiymUpHjsRc5mCqJFBu74ssOMK2
uW4wO0st5Jyw+4bhVCID2M2cEmQMhj78qF9Jz4gvsd6rfe9muxXiXH8SUxxslCnY
66aBdPoQc6yN3oEBLuqXCPJHEQOGcNfAi6wPv5rqPLCqXP2dhvEJ/xHF83nUrvo4
0wuE2J8lFO1vMmN3+ISaWBrGLkjnqveAERg3Pmbfl8CcNAmxIG4w3C2ZSt/8IaB8
57T08TauFbjOb/cPOSQcxpMUrBZUxMImqhh1jzjSXvSSX41JmHc6sqXuOhMKw3DA
5UrXVpg3mirwM5Ia8s1cri3CsjljYwc5n169sDtQpOJaZGeGSmT8BUyCFsjVA3qR
wzrGqvoSbS8UNnywBP884YfnWJsPBgeZxHH2bHvqCs8dYjGB8ExZPiSe8batyesB
dM5r1c/QlxHlXWsAmphzpMlRY2f9fOAjDWdC03wrdAySMbycBz2fOkxNNipTnIpa
FPmGZLEv/nPX3QYzqnm4
=qDuG
-----END PGP SIGNATURE-----

--=-njPxZfVdlYVICE2Lex0e--

