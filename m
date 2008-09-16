Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYIPUTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 16:19:34 -0400
Subject: Re: [PATCH] Use the kernel source tree for includes, not the
	kernel build tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080916200828.13928.55864.stgit@dv.roinet.com>
References: <20080916200828.13928.55864.stgit@dv.roinet.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yEQxK1vjM0EdKRG/4wdZ"
Date: Tue, 16 Sep 2008 22:18:42 +0200
Message-Id: <1221596322.9262.7.camel@johannes.berg> (sfid-20080916_221950_680627_6149FB0E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yEQxK1vjM0EdKRG/4wdZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 16:08 -0400, Pavel Roskin wrote:
> If the build is done outside the source tree, nl80211.h won't be in the
> build tree.  We only need only definitions from the sources, not the
> kernel configuration.

good catch

> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  Makefile  |    2 +-
>  defconfig |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index 74cb1e1..9e79381 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -6,7 +6,7 @@ INSTALL ?=3D install
>  PREFIX ?=3D /usr
>  CC ?=3D "gcc"
>  CFLAGS +=3D -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict=
-aliasing -fno-common -Werror-implicit-function-declaration
> -CFLAGS +=3D -I/lib/modules/`uname -r`/build/include
> +CFLAGS +=3D -I/lib/modules/`uname -r`/source/include

I'll remove that line entirely though.

johannes

--=-yEQxK1vjM0EdKRG/4wdZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0BSeAAoJEKVg1VMiehFYk8EP/idvUel1fqUvoqfv36nEPuAs
WpJwJ5bwBF6v34uFXEARFt0sWCHwD7manxWxYnO2YUpM5mMSFg9jPZPWs8BPXUYf
JGACxWzqegpbXgwXy18Fk+o2XjJ4FEZQ1gu22gel3XXf5nz2cQkdMskdBCRbdARL
sqC5qLluQU4Rhh1sHdynVX73tQREV8fEuaWms3HaJHpiyx0wGiZuXqY1gshyWh4D
KyFGo6NB4zV9YGOt7FEnSrrn9yV0eav0afSzpocBTzZrOL2hsnGHj4sVQBUqvIIX
BKHgm1U7z8hMbZWEgsyIrv4RshyNBaobsBN3f+TWiOpAGeBN+Ov8dvK5yWk0ycqk
ocNa8wBSAJaVJbTA5lh4b/qvFCYAUf5MwV+v1pc6rp26vNFZsToWSw+FWYO2Fdz5
ehlcFBBwg51CYS0spa5JZNic6nkVgb7P6dgc9awYA4vj6b/9kYmRnM98uuceXb20
7iNjsoGHo7GyTQM7espRkJuYBLKLYwFJkh531jAWptr+5lG+h9cgImTPxwexJGdb
a54JuFvBYdyvjreNx1NMfQgZJT4ztpKaiwhN8BVlS0YHJhf4IWbZqc2idKVO1iln
ucrqGdIFjqffUvfFnk1eUp31ZdK3zt0I+FEe0rmN1WFkW8WHrmocnk+za3lE+xh4
VvLxRXKnwC/4GDOZ2Ruq
=HvQm
-----END PGP SIGNATURE-----

--=-yEQxK1vjM0EdKRG/4wdZ--

