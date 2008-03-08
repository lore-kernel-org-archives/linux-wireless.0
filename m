Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbYCIUZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 16:25:32 -0400
Subject: Re: [PATCH 2/2] tkip: remove inlines duplicating byteorder macros
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204946250.23455.21.camel@brick> (sfid-20080308_031745_516710_D5326048)
References: <1204946250.23455.21.camel@brick>
	 (sfid-20080308_031745_516710_D5326048)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rqYbsMUEQ7bPHkkzm0fK"
Date: Sat, 08 Mar 2008 07:57:04 +0100
Message-Id: <1204959424.6387.39.camel@johannes.berg> (sfid-20080309_202550_517371_9907C68E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rqYbsMUEQ7bPHkkzm0fK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-03-07 at 19:17 -0800, Harvey Harrison wrote:
> Also remove Hi16/Lo16 and open code them in the one place they
> are used.

>  	int i, j;
> +	__le16 *ptr =3D (__le16 *)ta; /* address is held in LE byteorder */
> +
> +	p1k[0] =3D tsc_IV32 & 0xffff;
> +	p1k[1] =3D tsc_IV32 >> 16;
> +	p1k[2] =3D __le16_to_cpup(ptr++);
> +	p1k[3] =3D __le16_to_cpup(ptr++);
> +	p1k[4] =3D __le16_to_cpup(ptr);
> =20
> -	p1k[0] =3D Lo16(tsc_IV32);
> -	p1k[1] =3D Hi16(tsc_IV32);
> -	p1k[2] =3D Mk16(ta[1], ta[0]);
> -	p1k[3] =3D Mk16(ta[3], ta[2]);
> -	p1k[4] =3D Mk16(ta[5], ta[4]);

NACK! Now the code assumes natural alignment of the u16s which is, as
far as I can tell, completely bogus. Please review
Documentation/unaligned-memory-access.txt.

Also, again, please don't use the underscored versions of functions.

johannes

--=-rqYbsMUEQ7bPHkkzm0fK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9I4v6Vg1VMiehFYAQLGhg/+P4zwhlaEo4nWpPiIkEs0lmVmbt3oWcBu
tHk76D7LPGxaYUtoI1ym5VnUZz+YIKHdD2ZoNc4/MYq2zfKIvd7RBkaV2lnIZFyN
Fo0hNdFMEiejvf29mb9l4KbD5wR7/Q3kM1oQ7p+n+Vpw5My8cNPJqOy0Zzq7pM1m
kx9S/WjaE1AshVcSQ1rCRk3qSYbSzj0/mHHPkqPeAswMqhUu0A5l9ofVyAopuhp2
qiIhUiKw4TmzOoHGCCXAEbvo3nmLMjYyA7odw0aI858WX2mtP3tl9jdpt5i/xP2i
ofFUdkhTbacAVrDLZN1BFdGTqwKUTkpMWRlYYFOVCmq8C8bdCWn/+yCl7Nth7q59
O9Kcbwww1GcTzybWck3UhyyjfW1glVLTUz0nYDRB7P6FRf+J4NKVKkocC5CigloL
7aD0PJXiv0AOcDa7w0LJPbkL08k9sst/5ukko74Zx3xK4OScR5soppifTXZhyIMO
6oJmFSuNk0t88NDxrRKhMilp/+FakAaguiufkykgUgqo7fpPguetMnplIVO/UIl3
ir7MmPwMo4/jCCL+nS1OM8xxqOJxE1r4vwZWGtXn8rEUd95k6MtcipSgmdSnvNCO
2l5XwPVQtFeOUf+GFLU84Ouvqq3ZubZqT6urrATHd5cYxI3Z8zjS1+ui17ndwdbQ
OFTXQOarYK8=
=qhfg
-----END PGP SIGNATURE-----

--=-rqYbsMUEQ7bPHkkzm0fK--

