Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbZCVIEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 04:04:15 -0400
Subject: Re: [PATCH] Marvell CF8381
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	hs4233@mail.mn-solutions.de
In-Reply-To: <200903220511.50229.marek.vasut@gmail.com> (sfid-20090322_051148_655459_21864B2F)
References: <200903220127.21836.marek.vasut@gmail.com>
	 <200903220511.50229.marek.vasut@gmail.com>
	 (sfid-20090322_051148_655459_21864B2F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kKH/KxigDEv5JJhDVs1X"
Date: Sun, 22 Mar 2009 09:04:08 +0100
Message-Id: <1237709048.5100.682.camel@johannes.local> (sfid-20090322_090422_204815_6DB953F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kKH/KxigDEv5JJhDVs1X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 05:11 +0100, Marek Vasut wrote:

> One more thing - I also had to apply the following patch in order to get=20
> region code detected properly.
>=20
> le16_to_cpu(cmd.regioncode) =3D 0x3031 for me and Im definitelly not in s=
pain,=20
> but 0x30 (eu) looks reasonable.
>=20
> diff --git a/drivers/net/wireless/libertas/cmd.c=20
> b/drivers/net/wireless/libertas/cmd.c
> index 639dd02..ce32bc9 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -123,7 +123,7 @@ int lbs_update_hw_spec(struct lbs_private *priv)
>          * only ever be 8-bit, even though the field size is 16-bit.  Som=
e=20
> firmware
>          * returns non-zero high 8 bits here.
>          */
> -       priv->regioncode =3D le16_to_cpu(cmd.regioncode) & 0xFF;
> +       priv->regioncode =3D (le16_to_cpu(cmd.regioncode) & 0xFF00) >> 8;

I'd be more inclined to think that this was an endian bug? Does your
machine happen to be big endian?

johannes

--=-kKH/KxigDEv5JJhDVs1X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxfD1AAoJEKVg1VMiehFYYroP/Azfch7XPOTYSx2ONoryY1hu
/WXfh9unY2UreaNta/k0reapOFDJNOadgK4R3qPqymaZDBQ5vDa6T4aqUER3Jgxx
OdBSs3EI6OlyDzMJ5GTDSSQqu+894Ik6/nGNY1vd+C3froY8JQh7DmcmCTYYNjOe
HOGoOOpNijhRR+d6PrmLz01cF6af0p/r45h/ey+WqCBJ1SNrbTJHRBmMYb0wRXpH
i8OwAu7kfzToA2jvxaiKk0Iec0GJ3FAK36eRKgJNDd2plisya4yKggGTyDIFiHor
qkBXZnRjugbUj731YgLKS3DKOzWVErj2kILwuvhLUIhEhVcvt2Cqg4V4xJzTgUza
A+CJsMaT1JuoXYs58nbxSmOYE95yaw/edlaZpntOBjrExLViNrvoOEatb2Bd5ewE
tCbV3B+rKeWXmybOlC+oZj0DsiE5J5BRncGAiB59Oq2Lj1Tf/GKUB3EGIs1d9BnX
4wwO5wmDqWWJoUU7LsLU60VXpRg4RbpGEJ4MeiRYFPsCqaASGHtLue8GXci8vjg7
bf1eaUc6b5iNBGETyhY/LV6G3l8LlvDTv+GxlxMFWeNTlf7hYdvx7txSP34Sfvmy
NJ+/Q6eQvxR69XuTSy8+QAFeiSQQzL1BqVaAZMTzJm5+QaGPZRKnAPTFoJwBc4FG
8dudGy3M0Nfm/uUr09kF
=ICCk
-----END PGP SIGNATURE-----

--=-kKH/KxigDEv5JJhDVs1X--

