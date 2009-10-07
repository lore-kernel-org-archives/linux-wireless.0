Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55952 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbZJGWiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 18:38:05 -0400
Subject: Re: [PATCH] b43: Fix locking problem when stopping rfkill polling
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4ACCEBE8.8010803@lwfinger.net>
References: <4accae5d.BgSJpcmlvg+W5PGM%Larry.Finger@lwfinger.net>
	 <20091007190106.GB22394@tuxdriver.com>  <4ACCEBE8.8010803@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-87cPhJtEKAm5nmUa8dGi"
Date: Thu, 08 Oct 2009 00:36:55 +0200
Message-Id: <1254955015.3713.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-87cPhJtEKAm5nmUa8dGi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-07 at 14:28 -0500, Larry Finger wrote:

> > OK, but why do we start polling under the lock but stop polling without
> > the lock?  Should we start polling without holding the lock too?
>=20
> I'll test that, but I suspect it doesn't matter. Of course, the reason
> I put the stop under the lock was for symmetry, but then I got the
> following when shutting down:
>=20
>  b43-phy0 debug: Removing Interface type 2
>=20
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>  [ INFO: possible circular locking dependency detected ]
>  2.6.32-rc3-wl #225
>  -------------------------------------------------------
>  modprobe/25391 is trying to acquire lock:
>   (&(&rfkill->poll_work)->work){+.+...}, at: [<ffffffff81054a7f>]
> __cancel_work_timer+0xd9/0x224

This is because when stopping polling we need to cancel the work and
sync on it, but when starting it's completely async so starting can be
in any context.

johannes

--=-87cPhJtEKAm5nmUa8dGi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzRgEAAoJEODzc/N7+Qma5QsQAM/VBSHyoUv4cI2OY7RspeS9
9Gfr5fjrueojUQEVBj91VcYI6vQpPheb74TiaPXT+MkGtXW7rMIToCRt4pxXYJ4I
yUrbqt6huVKvqN6ZFZLkMIw/nxgKDupvTYqWIHckCnmjx2zsuo8KGRepT85NDgEB
YEVpmwx3XyxU6ecmxESCPCZ9Z6UwGUpdIsjzlIRtXUs0UXEIH8qCGOCQB7EXsfuY
2FGS3gmemF8mVBmNFruAp7phzP8743Gebuumw3g/o5Abv+Ulvosmro70gqhKRjmS
Bk+1UXDkiiSTXl1tdktyHAjxjALEeyUj5MvXWnY7GWD26xKn4SE3NUAI9cRU47Yq
zjS5bgqSmc2YOXiNndLW/e2PxTj1AMubHIQvJp1u5FsHf3KCzbVs/oIil7GvthsI
xnQeDCVSXEOUpfQQYMYwtmbWRmgKZcOq7B8TarUEv7cA544yKXGpUk3Co0x4yQlb
QkZ6vzhLD2AJmEVLfeYbtquWlQH5F9TE1BuqRETgBWBiDCLTpgtsoPQchH7yBaC2
RB0o9NUqQaq5SqxNQ7Jwqw+df+uXbe1+UsTM9EcA0SoJE8JafeGS1psDR1jSrgRu
Zzo3fFsXNlwgyjy/MerD1zEZWVdu6DGAMRxtfY+iS3BvpLX9llxQuYMB/9n/+G+1
1Li3ExTA8OHWwuGXinSg
=WKvs
-----END PGP SIGNATURE-----

--=-87cPhJtEKAm5nmUa8dGi--

