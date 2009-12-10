Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx30.mail.ru ([94.100.176.44]:64908 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761206AbZLJS4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 13:56:40 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [PATCH] orinoco: fix GFP_KERNEL in orinoco_set_key with interrupts disabled
Date: Thu, 10 Dec 2009 21:55:55 +0300
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200912101955.01325.arvidjaar@mail.ru> <4B213F4D.2000707@gmail.com>
In-Reply-To: <4B213F4D.2000707@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1442864.1yZQ6tc2nb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912102156.32029.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1442864.1yZQ6tc2nb
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Thursday 10 of December 2009 21:34:53 Dave wrote:
> Andrey Borzenkov wrote:
> > I had to resurrect old notebook and immediately hit this under
> > 2.6.32:
> >
> > [   77.254109] WARNING: at
> > /home/bor/src/linux-git/kernel/lockdep.c:2465 lockdep
> > _trace_alloc+0x9a/0xa0()
> >
> > Until orinoco_lock can be converted from spinlock into mutex, this
> > patch is the most simple solution.
>=20
> Thank you Andrey. The patch is correct (though it could clean up the
> misdirected comment 4 or 5 lines above).
>=20

Do you want me to resubmit with this cleanup?

> Is it worth pushing this to stable?
>=20

I think yes. Sleeping under spinlock with interrupts disabled is not fun=20
even if it is very unlikely.

--nextPart1442864.1yZQ6tc2nb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkshRD8ACgkQR6LMutpd94y2ngCaA6qN7nMQzDNt6r0mWxCv7HTd
0AAAniK7T87x74Us6uSOrL3Fsv/H2TVj
=o+/T
-----END PGP SIGNATURE-----

--nextPart1442864.1yZQ6tc2nb--
