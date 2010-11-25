Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.klingt.org ([86.59.21.178]:43085 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab0KYRTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 12:19:17 -0500
From: Tim Blechmann <tim@klingt.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: rt61pci issue
Date: Thu, 25 Nov 2010 18:19:12 +0100
Cc: linux-wireless@vger.kernel.org
References: <ibgpgg$a5m$1@dough.gmane.org> <201011120747.28837.helmut.schaa@googlemail.com> <201011120803.32721.helmut.schaa@googlemail.com>
In-Reply-To: <201011120803.32721.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1319825.39h4M4g8ea";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201011251819.12913.tim@klingt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1319825.39h4M4g8ea
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> > > >> Mind to put a (maybe rate limited) printk into the interrupt thread
> > > >> that prints out "reg"
> > > >> and "reg_mcu" so that we can see which interrupts get triggered?
> > > >=20
> > > > log attached, generated with:
> > > Thanks. Unfortunately nothing special in there. Mostly RX and TX
> > > interrupts. So there must be something else ...
> >=20
> > Tim, is this on x86 hw? Or something else?
>=20
> I don't know if this will do any good or harm but it could be worth a try
> as the spec for rt61pci says something like: "Don't enable interrupt
> mitigation in the same write as releasing the other masks.". Since we
> always write a mitigation period of 0xff =3D=3D "No mitigation period" we=
 can
> simply leave interrupt mitigation disabled.
>=20
> I really don't have any clue if this will fix anything but it might be
> worth a try.

i have been running this patch for a few days and i haven't experienced the=
=20
problem again.

according to `top', the kernel thread `irq/16-0000:08:' still is the kernel=
=20
thread, that is using the most cpu time (after an uptime of 8 hours) it is =
about=20
50 seconds, while the second most expensive kernel thread (`kworker/2:1') t=
akes=20
below 5 seconds of cpu time.

cheers, tim

=2D-=20
tim@klingt.org
http://tim.klingt.org

Cheat your landlord if you can and must, but do not try to shortchange
the Muse. It cannot be done. You can't fake quality any more than you
can fake a good meal.
  William S. Burroughs

--nextPart1319825.39h4M4g8ea
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzumpAACgkQg0On+TFEWzz38QCfevBIz/V6R18kSGdrdMXDBm0v
LaYAn2sFLtMG1/JEnNX28rfb6r1uYyGb
=wtXx
-----END PGP SIGNATURE-----

--nextPart1319825.39h4M4g8ea--
