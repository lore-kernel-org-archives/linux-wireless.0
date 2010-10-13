Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coloquinte.cristau.org ([91.121.16.100]:49091 "EHLO
	coloquinte.cristau.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0JMPZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 11:25:22 -0400
Date: Wed, 13 Oct 2010 17:17:16 +0200
From: Julien Cristau <jcristau@debian.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>, 599345@bugs.debian.org,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Re: Bug#599345: linux-image-2.6.32-5-amd64: iwlagn allocation
 failure
Message-ID: <20101013151716.GA3167@radis.liafa.jussieu.fr>
References: <20101006191947.GA3036@radis.liafa.jussieu.fr>
 <1286402043.2955.81.camel@localhost>
 <1286437870.3657.16.camel@jlt3.sipsolutions.net>
 <1286737393.2955.225.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
In-Reply-To: <1286737393.2955.225.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 10, 2010 at 20:03:13 +0100, Ben Hutchings wrote:

> On Thu, 2010-10-07 at 09:51 +0200, Johannes Berg wrote:
> > On Wed, 2010-10-06 at 22:54 +0100, Ben Hutchings wrote:
> > > On Wed, 2010-10-06 at 21:19 +0200, Julien Cristau wrote:
> > > > Package: linux-2.6
> > > > Version: 2.6.32-23
> >=20
> > > > Oct  6 21:05:02 radis kernel: [378665.326381] NetworkManager: page =
allocation failure. order:4, mode:0x40d0
> > > > Oct  6 21:05:02 radis kernel: [378665.326393] Pid: 25555, comm: Net=
workManager Not tainted 2.6.32-5-amd64 #1
> > > [...]
> > > > Oct  6 21:05:02 radis kernel: [378665.363630] iwlagn 0000:0c:00.0: =
kmalloc for auxiliary BD structures failed
> > > [...]
> > >=20
> > > This particular allocation is for an array which is not used for DMA =
and
> > > therefore could be stored in non-contiguous pages allocated with
> > > vmalloc().  But there may be some good reason not to do this.
> >=20
> > I have, however much more recently than that kernel, cleaned this up in
> > commit ff0d91c3eea6e25b47258349b455671f98f1b0cd -- this particular
> > allocation is now 2048 or 4096 bytes depending on the architecture (32
> > vs 64 bit pointers). If you want to backport this, there are two or
> > three more commits right before it that would probably be required.
>=20
> It seems like we can get away with a much smaller change though.
> Julien, could you test this patch?
>=20
Getting lots of those in dmesg:
iwlagn 0000:0c:00.0: Too many chunks: 2

Doesn't seem to prevent the network from working though.

Cheers,
Julien

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJMtc14AAoJEDEBgAUJBeQMa6YQAJ1GXDFZLx67AsfJtxzaQlnH
HksEJywXeTmLTvhZ2NMDoyK1wj5uyeoX/1lbjM475g9JKEYXSOV2mgPzC74YJBzc
6vtTZ1S54SUqFXkJioT0zywKju61RQ965xcWhslLlpQUKZ9EuY7freDIrdy2FlOS
Dt/SQVrwojtlPdvabDwQOMNo3vkdTLZY22W5twlVNMuH7gy3qOfs7KwzQhHzRBgm
cpqZNGeAvl2jOE3Y2OB6p6uj5Jddii0nY0Niq1ik7yFY2RcnQ9dnzgErx/4gL27m
sJUw8hzz/5drYoExQNLI1OYaAcrBu4ATWm2t8ZYXVzMbphqbD/n+qxSKlSFX0dZ7
zoTvbK1wiqt2pxW2jrQ18T0/X3iWygbDz2XjJoge9S6iv2tx1kV8/aL3ikg+maye
zH2Vg+xDnoKGCBB760AfheaGkGhgKxLmb6vuT0O933jtO4tP0ZnhlQ+M0XGBoJes
4iVeSCF/JutrjDTRL6qUBNGA/Iq9/puLhTZqND+99Ez4Oiw8ygFaMobPGG88OEIz
yR+MU3YvsmpdSix+OtGyqlPH7qaxV9bCoji2kFgAV2V/fUdi+JBJzDUXoRytSJSi
a7woTW11oMHSpycsh+VcxR5ZFrddo0dpOKQvHilvbvRPOLwy+btcEffGjYx+lQC9
0HefbVrQ5sdAiWCHaMut
=whp/
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
