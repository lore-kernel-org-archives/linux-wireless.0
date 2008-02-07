Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584AbYBGKiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:38:52 -0500
Subject: Re: [PATCH 08/13] o11s: other changes in mac80211 for mesh
	interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a78286.07045a0a.0fd0.ffff8bb1@mx.google.com> (sfid-20080204_212428_285984_7DC49E60)
References: <47a78286.07045a0a.0fd0.ffff8bb1@mx.google.com>
	 (sfid-20080204_212428_285984_7DC49E60)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+miIPj4qIvTNt//ZOKcD"
Date: Thu, 07 Feb 2008 02:05:43 +0100
Message-Id: <1202346343.9965.88.camel@johannes.berg> (sfid-20080207_103914_571851_5046927D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+miIPj4qIvTNt//ZOKcD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

>  	default:
> +		printk(KERN_DEBUG "%s: received unknown action frame - "
> +		       "category=3D%d\n", dev->name, mgmt->u.action.category);

Needs to be rate limited or ignored as it was before.

> +int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
> +{
> +	int ae =3D meshhdr->flags & IEEE80211S_FLAGS_AE;
> +	/* 7.1.3.5a.2 */
> +	switch (ae) {
> +	case 0:
> +		return 5;
> +	case 1:
> +		return 11;
> +	case 2:
> +		return 17;
> +	case 3:
> +		return 23;
> +	default:
> +		return 5;
> +	}
> +}

What the hell? This is utterly horrible! Can that be changed in the spec
so the header is always a multiple of four bytes? :)

This means we need to copy each mesh frame on platforms that don't
handle unaligned loads, I don't see any DMA engine inserting 5 bytes
padding... this makes things really complicated with alignment now and
means we do have to clean up the mess in the stack, we can't require
drivers to handle this weird mesh stuff :(

johannes

--=-+miIPj4qIvTNt//ZOKcD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pZZqVg1VMiehFYAQICCQ/9E5s5RIGC+38rVWGw1xUjVp9obDQXhv/P
+Ye0EBRYxg9z/b3e6NpqAPvbSbP4Sm2QhxVMyKbaYZaxAANf8O+5zhcapx4tqrta
4FybamEaZmpjFEzqvC0lYM2EXf1xOIolDVs1xfTuc/G+lk2ODSnXtjIG7c/Zn4XC
u7GCvegRXBDf+3axl6W9vdEOrmI7A3C4UkyQM++HixxOk3DUNqtyTLdNEHJevLx3
o4LjvAum/XfCwV2aV+UdMJkT3A436H39AOrUVJN15YUH9uMpR4aNntdVuSaEYgGS
UINLLnDjGHGt2K1/yZMl6yxlvYeL+Z0rlYsD3mR6BiaLR8vz9yh7iiJi8Z6AcC2A
UWvgywAobI0pMaEahZcxVX09LF9zz7XubpM05HrXyqKtYcUwV0/7FrvoCuFoXHbI
c+9UR/x0PpMTsD+aWnEy3gryQ7auJ6Gszzs5Hd3QBdPtlLNpPREbYYDLodH0r9Ch
2vMtF0EaWKw6YY/xrZ/bpfjpB4nwoEHKFjN3OmulqX9HCbWIfgaxCiPSeByxp5Zc
l4iEjKeQZcVx7zu1ScKLhCU4Tl6oqCVg8gkUilS8UobxeUwdcMzGBlzQjecXimpK
3Agy0f2NHPVEFY4bU+kDWVGDee3xNCwkciSrDx4mCkeL2EuJTGiUvggBGVkhAHm7
DMtUaozLEGM=
=+RhR
-----END PGP SIGNATURE-----

--=-+miIPj4qIvTNt//ZOKcD--

