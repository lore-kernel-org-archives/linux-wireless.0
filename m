Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:37190 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbbKZNea (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 08:34:30 -0500
Date: Thu, 26 Nov 2015 14:34:16 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: (bug report) b43: impossible conditions in debugfs
Message-ID: <20151126143416.6104ff24@wiggum> (sfid-20151126_143432_906645_72E64090)
In-Reply-To: <20151126130033.GG7289@mwanda>
References: <20151126115924.GI10556@mwanda>
	<20151126133241.5bc5a793@wiggum>
	<20151126130033.GG7289@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/glKQgqGoGSN9PWrx0FRzTYm"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/glKQgqGoGSN9PWrx0FRzTYm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Nov 2015 16:00:34 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Thu, Nov 26, 2015 at 01:32:41PM +0100, Michael B=C3=BCsch wrote:
> > > See also:
> > > drivers/net/wireless/broadcom/b43/debugfs.c:346 mmio32write__write_fi=
le() warn: impossible condition '(mask > 4294967295) =3D> (0-u32max > u32ma=
x)'
> > > drivers/net/wireless/broadcom/b43/debugfs.c:346 mmio32write__write_fi=
le() warn: impossible condition '(set > 4294967295) =3D> (0-u32max > u32max=
)' =20
> >=20
> >=20
> >=20
> > Sure. These are intentional.
> > The compiler will optimize this out. =20
>=20
> Hm...  We try to ignore when people do intentional comparisons with zero
> like this:
>=20
> 	if (unsigned_var < 0 || unsigned_var >=3D 10)
> 		return -EINVAL;
>=20
> Because they are obviously harmless and they don't hurt readability.
> Also Linus doesn't like removing these.


It just checks whether the value will fit into a 32 bit unsigned int
variable. It doesn't make assumptions on what sizeof(unsigned int) is,
although it would be safe to assume 4 here and omit the check.

--=20
Michael

--Sig_/glKQgqGoGSN9PWrx0FRzTYm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWVwpYAAoJEPUyvh2QjYsOdzwP/j1/FXqsbLmnp03ZLv29XnNm
F5AghFPpc/4qEWpEWdxCoQ623elFqE31c8kifoXxzqml2LlIiWQTJKfPrpPbl+7d
IFRdCvq2jI54IsthwqKNBynNP6+IpYZSf+iYs1cZwi37VhmTZQcriGDlp/teQDK5
ZF4qCxJ5YizrKd22XYHLiyoHTgMlzGqeUTmkkRXzSd4xlWc/B8KL2S5Nvk/SNL2P
0Xa8WC1J430jNv1eppSeaXCBnElLg5EO4bhaezCeprl5hqunwSFMUhqA7FAkHdup
G3DclgwcNJhT818NLWZ5Oft0w4blbpn6g/5Ma2d12UhQv47iwvwD37mULZOzpok0
VFyxVB1bX3NWFN13jp4VRPbZ/bcHRnihRGFU+ezkO9BR8MsI/p9pGGQ4/+23Fic/
Asepe4wBT9eNTQpKuJ4uik0lWfVQk5s5Ehp2psfNuIsKKeHfu3CGQ74NPCo6Lg9R
AWQwBIqHTczO8NJxoeuouQ/KRnql6Rx4B7sAcIWDJCDY3Ef79wVMjT1iA6VoHJiU
I4Epax7ql/E+vrvwbDdLLIIGLR5jtzgNWVfDKq8zu59H1zVmr0exgm51sf8O588c
NzflA9qAakKiWNe/ghl0NAUAiuhg0TY/9VQ/LdDp+Y//MaAow2bawRa40FRFyRXR
2CgfXRSrxJgi68x7FfzH
=jyLE
-----END PGP SIGNATURE-----

--Sig_/glKQgqGoGSN9PWrx0FRzTYm--
