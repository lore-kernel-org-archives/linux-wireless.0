Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51974 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZETLp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 07:45:28 -0400
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
In-Reply-To: <200905201341.47185.helmut.schaa@gmail.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <200905181543.15266.helmut.schaa@gmail.com>
	 <1242724000.17164.10.camel@johannes.local>
	 <200905201341.47185.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pO4Vq64KpYke9ehWL9dE"
Date: Wed, 20 May 2009 13:44:48 +0200
Message-Id: <1242819888.19216.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pO4Vq64KpYke9ehWL9dE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-20 at 13:41 +0200, Helmut Schaa wrote:
> Am Dienstag, 19. Mai 2009 schrieb Johannes Berg:
> > On Mon, 2009-05-18 at 15:43 +0200, Helmut Schaa wrote:
>=20
> > > One solution would be to force all drivers to report the tx status. A=
nother
> > > one would be to just wait until the device's queue is empty. At that =
point
> > > we know that all pending data frames were sent out and additionally t=
he
> > > nullfunc frame was also sent out, so we can safely switch to the next
> > > to-be-scanned channel.
> >=20
> > Some drivers now flush queues at channel switch time, but there's no wa=
y
> > to guarantee that the software queues are actually empty and the
> > nullfunc frame isn't queued up behind other traffic. Also, waiting for
> > any driver to report a status will lead to problems because the driver
> > might just have dropped the frame for various reasons like being out of
> > memory.
>=20
> Hmm, the problem is basically (from a mac80211 perspective) that the
> mdev tx queue could still contain data frames when the nullfunc frame
> gets queued, right? And we do not assure that these frames are sent
> out before the channel switch.
>=20
> Hence, would it be possible to:
> 1) Stop all sub_if tx queues (afterwards no new data frames should
>    appear in the mdev tx queue)
> 2) Queue the nullfunc frame
> 3) Flush the mdev's tx queue
> 4) Switch the channel
> ?

I don't think that is sufficient, unless the driver also flushes the
hardware queue at channel switch time. Which we may want to make
explicit with a new callback or so?

johannes

--=-pO4Vq64KpYke9ehWL9dE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKE+0kAAoJEODzc/N7+Qma4DkQAKErAanuI7f5BlrdmUcWKAOm
VHJCplUCM1NOEW3N9t+x7Vf0YFZvQ9gVOtTkH7U6I7twducrQVbLYl+IZ/5exTaD
cBwYmwChVkn9E++eYw/29SqEdvrN5drELY6rfEprtnqFiA6KrSk95OG18wA1T9qe
6MPy7IOR9b9+sQqKILmY2TnefAh4MHOtXOTAEwmeAPYaqwwlhhLLjnuBZEI7H1Vr
J7vWG6otPZLTH0nGboBK7bz7i3W0vpdG5P1TN0mmlsmFlavvUxnYRoAqOEYGcMQR
yot/xF+uzXg7y6jmOXatVycpmOHABDTAb7i02sckUS7J+tzE1Zyn4wXvM6/cSyDn
IdQHIqtW+BLy9r2O38arfj7Uh8pSQP0IRtKPrMUOM/PoND63mUohmAn5H514NdL/
mztDzixh2IzLSTZ6CEeQRHcyEDLSVyPZsmWc3F6n1BWQoN4fSNzU/YbqJoWoqqcp
edKEevl9lczL2DA1DVsRssAzv7VzcdnHxAROcUWj2QdoXkUM3BxWMMI1yGp6SwDA
K1ac9AMNf65nVNgh+qk15SLlLjT0cMFQAGm/E6xrV5m2xJbTyf5idKahciqX5ZBQ
Ag1/B6kKSV7dXbzFi1cEm6/rH/ITJwQGO2mRWLWru1/5gc1nUjCjYO8g2W3kxExl
juSv9yXQ5cl0vxqAqdpY
=P30f
-----END PGP SIGNATURE-----

--=-pO4Vq64KpYke9ehWL9dE--

