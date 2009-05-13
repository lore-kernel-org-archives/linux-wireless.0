Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZEMXjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 19:39:25 -0400
Subject: Re: [PATCH 4/4] nl80211: Add RSC configuration for new keys
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090511185854.338687878@atheros.com>
References: <20090511185754.653711567@atheros.com>
	 <20090511185854.338687878@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2FeeW/Jgc4DX41foyHpn"
Date: Thu, 14 May 2009 01:38:53 +0200
Message-Id: <1242257933.10076.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2FeeW/Jgc4DX41foyHpn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Oops. Now that the patch is in the tree I took another, closer, look...

I think you should add an item to the nl80211 policy for
NL80211_ATTR_KEY_SEQ now, and restrict it to be exactly 6 bytes there
rather than silently ignoring it if it was a different length.

> --- uml.orig/net/wireless/nl80211.c	2009-05-11 21:39:26.000000000 +0300
> +++ uml/net/wireless/nl80211.c	2009-05-11 21:39:27.000000000 +0300
> @@ -1115,6 +1115,11 @@ static int nl80211_new_key(struct sk_buf
>  		params.key_len =3D nla_len(info->attrs[NL80211_ATTR_KEY_DATA]);
>  	}
> =20
> +	if (info->attrs[NL80211_ATTR_KEY_SEQ]) {
> +		params.seq =3D nla_data(info->attrs[NL80211_ATTR_KEY_SEQ]);
> +		params.seq_len =3D nla_len(info->attrs[NL80211_ATTR_KEY_SEQ]);
> +	}

Maybe it should also check the key type? At least you haven't
implemented using it with WEP.

> +		if (seq && seq_len =3D=3D 6) {

> +		if (seq && seq_len =3D=3D CCMP_PN_LEN) {

> +		if (seq && seq_len =3D=3D 6)

In any case then you could get rid of those =3D=3D 6 checks.

johannes

--=-2FeeW/Jgc4DX41foyHpn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC1oKAAoJEODzc/N7+Qma8uwP/3/s4LuwBiL4BvsaucsSMKKg
5OZWp6ZbV3JBhYT3B36Lwjfcyay74zDDvvdv5icZzW6SiFZiKL0i1SAHxuG2lvXl
mXIGy1wOJL58cCkjhG6CgSn3/uMbU0Bda6jaq830wn9z/FN1Xsp9qajeWCLqZGRw
sdAUAdnNwAgLeaT1PGtEBPtVU9W8uWXGZban5SmMmI667fzRmEwYR1vxDhyX+PZ2
EWSj0CxVc1Qfo6PQRMyReXGc/QIO7ZH4+zIdzZ423+vuBb33LQSb6dX2Fbvqh82r
EYnRpezB01LICyUaDdSMqrJTYyroQG9MmqtFUoSKHF1Wnqj29CSKUsV6Yc0hLXM+
8cVHPnY4gH8p3CDKN9MwBgAIlzKwhMLWFiEmVXY5LIZOBbumlJjPrdlueoWqGhhM
RUIvZNmSr8U9j4t/GWEcMm8xSstn0bL5QLeXC9bloLGWcsTbgaGssKXQhGn6zM7N
GG6izmaWT+M/vaP+LSBGCDe9xMCXePQeuTmdrLgQLdgD5WJ/SqPqDKArVd6bd3iG
hkrQCQ0EmSCJevkRxb/BuMyoGJpR/Wxy83PFaJDOkAokAQhUq9LVaZ3pGITg5quP
LXKCgzUFs1rVtdmHrPRiy6mBfc9CH0xCGL7ByW7+GIPpR7OqXLseHsA7UiS3cWrU
NObZlgSMI6sFmQFxFP0Y
=c92U
-----END PGP SIGNATURE-----

--=-2FeeW/Jgc4DX41foyHpn--

