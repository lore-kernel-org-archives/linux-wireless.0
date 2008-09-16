Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYIPVLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 17:11:49 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221598208.17084.11.camel@dv>
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221598208.17084.11.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3Vt40dMn5o4LNM+Fj5fk"
Date: Tue, 16 Sep 2008 23:11:00 +0200
Message-Id: <1221599460.9262.16.camel@johannes.berg> (sfid-20080916_231152_167035_625A9793)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3Vt40dMn5o4LNM+Fj5fk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 16:50 -0400, Pavel Roskin wrote:

> Sorry for diverting the thread, but the current git head (which is
> tagged as 0.9.1) is broken.
>=20
> $ ./iw=20
> Usage:  ./iw [options] command
> Options:
>         --debug         enable netlink debugging
>         --version       show version
> Commands:
>         list
>         Segmentation fault (core dumped)
>=20
> Debugging shows:
>=20
> 82              fprintf(stderr, "Commands:\n");
> (gdb)=20
> Commands:
> 83              for (cmd =3D &__start___cmd; cmd < &__stop___cmd; cmd++) =
{
> (gdb) p __start___cmd
> $1 =3D {section =3D 0x0, name =3D 0x403d02 "info", args =3D 0x0, cmd =3D =
NL80211_CMD_GET_WIPHY,=20
>   nl_msg_flags =3D 0, idby =3D CIB_PHY, handler =3D 0x402403 <handle_info=
>}
> (gdb) p *(&__start___cmd + 1)
> $2 =3D {section =3D 0x0, name =3D 0x0, args =3D 0x0, cmd =3D 4209927, nl_=
msg_flags =3D 0, idby =3D CIB_NONE,=20
>   handler =3D 0x30000000001}
> (gdb)
>=20
> That means, __start___cmd points to "info".  The next command has no
> name (and appears to be a complete mess).  The clever section trick
> doesn't seem to work properly.

Strange. It's supposed to work, it's documented that way, and it's
working fine here... Ideas anyone?

johannes

--=-3Vt40dMn5o4LNM+Fj5fk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0CDgAAoJEKVg1VMiehFYwSQP/AlJVhS7bdX23ws0c/sW7ekA
XKZ+TA6/AkOgNagRBifI/1pG0Evw3wU7GCJzsyo0Pby8uo5DHFbf7qisfi9Ltw7p
IhywlEYTRP4hC74o9samCWNd4EV3pJmTtUOqen/hKUdHfAzUpnsiqbOPHV08b9x0
htec8OzVlV+ihXqhlrFvqg2w5vtVTWB9edAJphghjefLnXKBX3KKbFQPsYse8mLs
NUXKFxDPwGcEAcKsu3YwPc4v7EnezWwidCptLqkPoN/tLi6qbcFkwkVCqYBrGd6D
dd+H/MlusEwBD6bk0Y3s2FYgQYimprNWrcoqmQZltpPUIkOGjIAHNZsOeDgjxTEA
6oKyB2GXFrz2MBv2H+egUI19Gf7dIAqMjeHp0+RmywvgU+Hymjt/KCoK+60q16wd
gsjQ4ZkLh09uTvWRrDQTm/OlqAzby+rdETXp9PoD3hBwNJhXQvIB799iAZIYLwcV
lpHjz/aNKaG5u3ExjlucPiVT0sLdOf3oCBQLLDsRCZr5IJgDo9HVGQf15fzhw4/3
I2PXm4f7rkHkIEXVI14AZ4twqgdoy7qphzY+fUDJqJOYn0EhA+Ew+nz7VTqoo7qW
Z6bVmqYNXOTnx9KbA4t7GJoPJqngap43AtL5AwS6GrpTSXyC0C8zXg7x+dpBmX1R
oOjD5z7ooJvfsJ1oqFMb
=rFTu
-----END PGP SIGNATURE-----

--=-3Vt40dMn5o4LNM+Fj5fk--

