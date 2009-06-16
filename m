Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbZFPLP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 07:15:26 -0400
Subject: Re: [PATCH] wireless: Compare ethernet addresses by unaligned safe
 way
From: Johannes Berg <johannes@sipsolutions.net>
To: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1245149672-18063-1-git-send-email-yauhen.kharuzhy@promwad.com>
References: <1245149672-18063-1-git-send-email-yauhen.kharuzhy@promwad.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YmH8ip3r1UezH6as3k1d"
Date: Tue, 16 Jun 2009 13:14:55 +0200
Message-Id: <1245150895.8623.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YmH8ip3r1UezH6as3k1d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-16 at 13:54 +0300, Yauhen Kharuzhy wrote:
> When we try to run RTL8187 driver on AD BlackFin platform, we got
> messages from kernel about unaligned memory access at
> compare_ether_addr() calls.
>=20
> Replacing of compare_ether_addr() by memcmp() fixes this problem.

This shouldn't be necessary. Which operand is unaligned?

> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -395,7 +395,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80=
211_sub_if_data *sdata,
>  		return NULL;
>  	}
> =20
> -	if (compare_ether_addr(bssid, sdata->u.ibss.bssid))
> +	if (memcmp(bssid, sdata->u.ibss.bssid, ETH_ALEN))
>  		return NULL;

So in this case it seems that it is possible that u.ibss.bssid is not
aligned, consider fixing by doing

--- ieee80211_i.h
+++ ieee80211_i.h
-	u8 bssid[ETH_ALEN];
+	u8 bssid[ETH_ALEN] __align(2);

or so instead.
=20
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -134,7 +134,7 @@ static bool is_bss(struct cfg80211_bss *a,
>  {
>  	const u8 *ssidie;
> =20
> -	if (bssid && compare_ether_addr(a->bssid, bssid))
> +	if (bssid && memcmp(a->bssid, bssid, ETH_ALEN))

Since a->bssid is after a pointer I can't see how it would be unaligned,
and bssid should be unaligned only if the call trace shows it's coming
from the above u.ibss.bssid.

johannes

--=-YmH8ip3r1UezH6as3k1d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKN36sAAoJEODzc/N7+QmaajAP/AuLGlHfA1jx/2ydokA4wioW
yuJpRI/6e+FpXeGZ5g9O/AX3tfwaC4VIeQBnR4RWDx0/p0wcSl4r8NqGww6LcP8S
2IXbeAunhpvgpXfno8q4DDw6wbbdJpBMTX0FfTV2G15dTN7eHdLyj7uUSXRbzdjS
oZOn8qO46v8E4+WwbZKlPRAsvu7K8GHQoQycWZFvegNDm/nE+dlfmGBC0AoSr//5
q4K6EjUHar9+bPXi88Kbgcmma9TK+zEfFLtY4TkMxaKVYrc7qOYEc0AFwAGV65DF
Lcj4gy8waPnfL0QrE/zpPg14gb8OLSt2O75mgtCHJwz53EFBsdLdad5Be++al3Rk
lc6Hxn6NTVXoxCqsbJos3meSzh+tqeAiP3Hsx6FMtCbqrKXRMMU2gj0pxwxvuok5
YJUMpLBLzv4LaG2ygXXLQxil50iV62k+nyJqdNsva6HtWkE9DGTHy4YiqT1Q4s6r
JYXKkoa3LeZ9oAp5495MMyWrcGSHNYGHmHtOeXRZyWnOq3i3bM8P80v3uhHd3I6k
B5si23zTbUU/B2YljaAT8r9GYNbusmuOpJwgdXRBqQdhyYUgYEMHivCttzqEcNC+
+Q15KeBEQUI6A1FKbD8E2SYV6ozD/OWw/4VepsAUSF8nIo/F1fe8dF0cXDD1Vfo9
SyhO5MwoiRNeGqyjUKnU
=YeH2
-----END PGP SIGNATURE-----

--=-YmH8ip3r1UezH6as3k1d--

