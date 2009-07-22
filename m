Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZGVUUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 16:20:47 -0400
Subject: Re: [PATCH] mac80211: fix autoloading of crypto modules for WEP
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: linux-wireless@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <4A677126.3040907@linuxtv.org>
References: <4A677126.3040907@linuxtv.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Sc9p44LFpVevrbvRH1Yz"
Date: Wed, 22 Jul 2009 22:20:07 +0200
Message-Id: <1248294007.19121.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Sc9p44LFpVevrbvRH1Yz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-22 at 22:05 +0200, Andreas Oberritter wrote:
> If at least one of arc4 and ecb is built as a module, then autoloading
> of the algorithm fails, because crypto_alloc_blkcipher tries to
> request the module "ecb(arc4)", which does not exist.
>=20
> This patch was made against 2.6.30, but should apply cleanly on top of
> the wireless-2.6 git tree.

> +       /*
> +        * crypto_alloc_blkcipher() will request the
> +        * module "ecb(arc4)", which does not exist.
> +        */
> +#ifdef CONFIG_CRYPTO_ARC4_MODULE
> +       request_module("arc4");
> +#endif
> +#ifdef CONFIG_CRYPTO_ECB_MODULE
> +       request_module("ecb");
> +#endif
> +
>         local->wep_tx_tfm =3D crypto_alloc_blkcipher("ecb(arc4)", 0,
>                                                 CRYPTO_ALG_ASYNC);

But it will absolutely not _be_ applied. Fix the crypto layer instead if
it has a problem loading modules.

johannes

--=-Sc9p44LFpVevrbvRH1Yz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZ3RxAAoJEODzc/N7+QmaZdAP/2kQhfY8l0UIrcP6FeecRmOd
MxNwHHVI0dm8EHcf9qZlLHNHpy6yvhO0nUMe8fbG8PkVfrceV9VD0wsO2UNhxnZz
eF+aX2g4s+BvQTC+IdmkMWkPeY1KXFCZ9LKLPto4rWmqjg67QMTKwFD5ATi+vfFr
DZSVjbnzn/9RpIrs4zdUPyeAVX7I+0jMZb3PbWWFwEyCKf04SO0qcOsL1dcfvJAo
f+LSHABGDFtRdwCa27mJhLYK3jl2lNp5bU7F1s0MrtFNb3C/dW/3vsh/XcZtf4EC
2/AKNp7et0dlLkFTooaIYKObSvo7yQAUMyHw5xC7Tz/VQ1pQkGtxNBRYxp5S3+H6
juL47P0qFhELfyNA3W/3C1aY6lrDfJm9BkJK75oTCR7moKHxFYqakagIW+fuGXPw
MX1olvD8zoMLCt5c1J7a+EXYIDKOXZ38FGbXLXVbcST1sPZHeUzAvhYLuWyNZ3YA
DR2P889ZMo/xhx1C+i+3daLU/jznQHhWkIwi3tcJWdC7RzbQzfM/nvXYte5EidOP
Q0Ku7e6uQkZxqPmGV/o836yxUE5a3tFcc6wO/LghL+Jb2onNOWyTMQDn1Uml36HD
alyH7MrmFgT7FFWigG/V7uLuNdOibvSBk/9rq1Tut8BxqUvnmZKPBwOtOYCdbfgE
ZhrhHbYJZJ6sx+7dKybT
=zfu3
-----END PGP SIGNATURE-----

--=-Sc9p44LFpVevrbvRH1Yz--

