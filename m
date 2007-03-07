Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:41700 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992431AbXCGSQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 13:16:40 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] p54 various cleanups
Date: Wed, 7 Mar 2007 13:15:47 -0500
Cc: linux-wireless@vger.kernel.org
References: <200702272219.58919.deller@gmx.de> <200703040019.00159.flamingice@sourmilk.net> <200703051706.36500.deller@gmx.de>
In-Reply-To: <200703051706.36500.deller@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1490530.W6CXflnkzH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703071315.51957.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1490530.W6CXflnkzH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 05 March 2007 11:06, Helge Deller wrote:
> > > -static const char *rfs[] =3D {
> > > +static const char * const rfs[] =3D {
> >
> > ?
>
> That's correct.
> 'rfs' is a pointer array to strings.
> The first part ("const char")  tells the compiler to put the strings into
> read-only memory. The second const after the * tells the compiler, that t=
he
> pointer array itself is read-only as well. This prevents e.g. this kind of
> runtime modifications:  rfs[2] =3D "test"; Another example:
> drivers/video/s3fb.c:static const char * const s3_names[] =3D {"S3 Unknow=
n",
> ... But if you don't like it, I'm fine wit dropping this part.
>
Nah, it's fine. It looked like it was doing that but I've never seen any co=
de=20
that actually did that so I wasn't sure.

> > BTW, you should have an updated summary for this patch.
>
> This one -> ?
>
> [PATCH] p54/rtl818x/zd1211rw  - various fixes
> - use PCI_DEVICE macro
> - add some const / __read_mostly annotations
> - mark some arrays 'static'
>
> Signed-off-by: Helge Deller <deller@gmx.de>
>
Yup. Merged in my tree and pushing to wireless-dev. Thanks!

=2DMichael Wu

--nextPart1490530.W6CXflnkzH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF7wFXT3Oqt9AH4aERAhVCAKC2hT3MhzON4e9B5j+NvLu9XMJ4tACfdEWR
y5tYf6wVRxVnTlE8mSU+uws=
=DVjQ
-----END PGP SIGNATURE-----

--nextPart1490530.W6CXflnkzH--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
