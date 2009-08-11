Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60529 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZHKL41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 07:56:27 -0400
Subject: Re: [PATCH] iw: fix typos in MCS set parsing code
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1249973250-9235-1-git-send-email-juhosg@openwrt.org>
References: <1249973250-9235-1-git-send-email-juhosg@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LSEuwHEI1esQtE84qBDs"
Date: Tue, 11 Aug 2009 08:54:04 +0200
Message-Id: <1249973644.5903.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LSEuwHEI1esQtE84qBDs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-11 at 08:47 +0200, Gabor Juhos wrote:
> The current code uses wrong binary operator for masking,
> and the shift values for the 'tx_max_num_spatial_streams' and
> 'tx_unequal_modulation' fields are off-by-one.

> -			tx_max_num_spatial_streams =3D (mcs[12] | ((1 << 3) | (1 << 4))) + 1;
> -			tx_unequal_modulation =3D !!(mcs[12] & (1 << 5));
> +			tx_max_num_spatial_streams =3D (mcs[12] & ((1 << 2) | (1 << 3))) + 1;
> +			tx_unequal_modulation =3D !!(mcs[12] & (1 << 4));

Are you sure? The "Supported MCS Set" field is defined as a series of
_bits_, and the bits are transmitted the other way around within each
byte.

johannes

--=-LSEuwHEI1esQtE84qBDs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKgRWJAAoJEODzc/N7+QmaRrQP/RG7iWa3xXK0dqpRXUWB1QSE
AKcTdSJz4K25lEnLqNGb5lb5tZtz4ZPX3p/rCftFl7tSs6eXrGrrMTePZnNP7Ct3
MJOr5rHnbagg+sMab8w22dEuqrNlab4+SoPsXeRbYki2Ei2M6Ho4VDYfaPLuk2zC
9eBDzi7p648UhTb4rAMV9Xr4WRkgyi/Rk8HW0xo8RFrC5SvGi2sDdxe1HyRZeQQb
ck0xJibQaDz8cjo40QXij8vtGZn713SYpOJSrNDzmvqg51tGJKCC+J+PsxQPN0sb
LQwsA7NBhYaLM+8aQKFiR8mK1kvEIfz6fO7gDzCEw70hlyZQ1R4F9t5BdVJoKb1s
x1l2Bh37ftwVaY5q/9QYDc1TOwxAJqBCY7+lmFkvy5xBsJNesxd7lb0bxpcZoi7r
6Ou91cuj6ElARFb3Fiq7vIXNGF/loMb1sepqSrxdsiRsH4Rt/NKP+uGcD5N8q36h
2AaK+Wwdfe9PWQpGjrPwbvq5mu219NT8ShGqsjv6Huqd/2nT4O+xTN5a+VfRuP3O
hfg6CYupbSbMNQU8GS3zm8fbwow4W4Puaba1zsjtXVzEYv2Idjgj8JmwWrIlo9Sw
d9C0zZ+1mJr79rDX/GD8xZqCnO7s6pf0ySRozhrlECqU4Yi4H7UizpwZn58NPy/3
hF/uhWgdljAOJ2+ylYum
=M4gF
-----END PGP SIGNATURE-----

--=-LSEuwHEI1esQtE84qBDs--

