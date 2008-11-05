Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54400 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbYKEL6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 06:58:04 -0500
Subject: Re: [PATCH 3/7] cfg80211: remove switch from __set_regdom()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S4MYnvJkD2bT76HkqHxQ"
Date: Wed, 05 Nov 2008 12:58:06 +0100
Message-Id: <1225886286.3619.80.camel@johannes.berg> (sfid-20081105_125807_808649_0E5A90A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S4MYnvJkD2bT76HkqHxQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
> We have control over the REGDOM_SET_BY_* macros passed
> so remove the switch.
>=20
> This patch has no functional changes.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |   21 ++++++---------------
>  1 files changed, 6 insertions(+), 15 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index e44f005..290ecec 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -829,21 +829,12 @@ static int __set_regdom(const struct ieee80211_regd=
omain *rd)
>  	reset_regdomains();
> =20
>  	/* Country IE parsing coming soon */
> -	switch (last_request->initiator) {
> -	case REGDOM_SET_BY_CORE:
> -	case REGDOM_SET_BY_DRIVER:
> -	case REGDOM_SET_BY_USER:
> -		if (!is_valid_rd(rd)) {
> -			printk(KERN_ERR "cfg80211: Invalid "
> -				"regulatory domain detected:\n");
> -			print_regdomain_info(rd);
> -			return -EINVAL;
> -		}
> -		break;
> -	case REGDOM_SET_BY_COUNTRY_IE: /* Not yet */
> -		WARN_ON(1);
> -	default:
> -		return -EOPNOTSUPP;
> +
> +	if (!is_valid_rd(rd)) {
> +		printk(KERN_ERR "cfg80211: Invalid "
> +			"regulatory domain detected:\n");
> +		print_regdomain_info(rd);
> +		return -EINVAL;
>  	}
> =20
>  	if (unlikely(last_request->intersect)) {

--=-S4MYnvJkD2bT76HkqHxQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEYpJAAoJEKVg1VMiehFYlh8P/3UvLqUVtBoNmySb7NqpLtet
WefGIzGgc5P/nNute5pLZn2OS2Z/ixDBiZbfOsx0ptL1uVE9eou9sagTk1aLLBcu
FgfkiUl26Wf49ozCSsjO/tqnf053KdaqehA1FTnVT/zwRmsVYJPHr3uYMJ5R8dsm
3NHlsKyAvLenAoTePzBeEhddH2S80iHBcyoxDPYYDp/V1EPRi2IwGivbtZUTzMBX
wqymwd40VCMd8/+52gfzr7cyqSK+cUYpdAUvs63op1Eecuzo8HQIfkgdGw04FwgH
h+YJMKr41GGh4pkb93lzJC7vuhj8tFcirR+iDxoapY1B1KCzQvaO147jPqrwNMug
PghrxBFrgM1dwQlyRFgDk5OZBsO/ntwFrfCe7M06Q7iSpemWwSHvcYatnzAe50zt
wLZfjXGVlrdqi/X4WbI2B1iEQexN5r6yfbh9u5E5ACXvLmz+MQ/iqeSwploh0slT
ChbEmRVkUXj1ucGDYnVdBPiWVe2xp+BEO2lnDIbNXylBPpLxTuZ3SK6tweZ+uyoV
Io4DXZ0lan23BFF/aZDXXRoV+OAhMh7APzPwwP1wLdf+pwInFhsuC1SkoteOWcM6
U+eQD+nbwLcSF/RFYZXGXqdis8KOizFEqRSYMd4B3aZthLc2Ti4CdyoksyIlouKA
4O4ROLqIMX2gHrGyPo+A
=wxIX
-----END PGP SIGNATURE-----

--=-S4MYnvJkD2bT76HkqHxQ--

