Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZETNyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 09:54:19 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com, David Miller <davem@davemloft.net>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <200905201543.12717.helmut.schaa@gmail.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <200905201341.47185.helmut.schaa@gmail.com>
	 <1242819888.19216.6.camel@johannes.local>
	 <200905201543.12717.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KToaM+Tb+fclZJf4/BSx"
Date: Wed, 20 May 2009 15:53:43 +0200
Message-Id: <1242827623.30497.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KToaM+Tb+fclZJf4/BSx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-20 at 15:43 +0200, Helmut Schaa wrote:

> > > Hence, would it be possible to:
> > > 1) Stop all sub_if tx queues (afterwards no new data frames should
> > >    appear in the mdev tx queue)
> > > 2) Queue the nullfunc frame
> > > 3) Flush the mdev's tx queue
> > > 4) Switch the channel
> > > ?
> >=20
> > I don't think that is sufficient,
>=20
> Maybe not sufficient, but it's at least an improvement.

True. The other thing is that it's not entirely trivial to flush the
mdev queues afaict.

> > unless the driver also flushes the=20
> > hardware queue at channel switch time.
>=20
> Yes, but that would be the drivers responsibility and could be
> fixed in a second step.
>=20
> > Which we may want to make explicit with a new callback or so?
>=20
> And make it mandatory?

Maybe not -- drivers that don't handle it wouldn't be off worse than
now, after all.

johannes

--=-KToaM+Tb+fclZJf4/BSx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFAtkAAoJEODzc/N7+QmathoP/03bUHpNTmASICAI7BgyCZEk
gKF3nKnhzPaiyzqNUyivYrZxbVvJZ2zkOTVUg3wDSKF6VFdNNn7SonzJTFavDAkb
kjvvDQNX6BSDzaHRJTsPkZAEcum/4V81tZENL/8dlKJLgVl1defzah4JAyPlQedj
9DiTK8MKTs+CIT00QiPugcrJcPa7xrL2MLMCPRcW8o7VnihkYlyOkNyDehqAI0/c
jZW1K/L0I2+axxr7Rk6g4inczSfQFIOB4tB6kHqAouotKDgoZig+pYTlNxZWeTRX
Eqz0a6+m0pKpcIdYNg9rGz6jupUZX3qafW6JG49yNEB8TdhLLrAyTONB1EYOyRll
0GJIuyahso0A2NSaBAAFCewSwbWdAYuWKF9Fi7hQteOqmeYComqHyE6Imda5amB2
vWMzWwKRPNmZ2h1cxpqYcFbadk1h9GlF5JCJHxKe6eeanqFTX6Hw3XvlRD1ZyDyI
0ApMsou7jIZPk/xAzIUcyyuSDO0/0G29Zc82H7KrnEZJkIF4UzTUEI0d49oNLcSF
4q4GO+V3rrBZK5OLSqgDlGBSBSwBB1mKP7WgeKnyqvar0pMaFEXbIZSG4Ey4ywMB
U4HDwJOB/Y/4s0og5Wv6ivr5IUwfMdLrFG9whDvcdOZ73YlSVkmXpkBiDLWYzNeA
hfZk8JUFXefEahogsyPt
=lu9o
-----END PGP SIGNATURE-----

--=-KToaM+Tb+fclZJf4/BSx--

