Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZG3R2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 13:28:22 -0400
Subject: Re: [PATCH v2 1/3] cfg80211: use goto out on 11d reg hint failure
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248974386-8168-2-git-send-email-lrodriguez@atheros.com>
References: <1248974386-8168-1-git-send-email-lrodriguez@atheros.com>
	 <1248974386-8168-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-W5BMEwxjaenlYrwQKk8U"
Date: Thu, 30 Jul 2009 19:27:50 +0200
Message-Id: <1248974870.23496.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W5BMEwxjaenlYrwQKk8U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 10:19 -0700, Luis R. Rodriguez wrote:
> This does not change functionality.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index fb40428..2d1d183 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1774,10 +1774,8 @@ void regulatory_hint_11d(struct wiphy *wiphy,
> =20
>  	mutex_lock(&cfg80211_mutex);
> =20
> -	if (unlikely(!last_request)) {
> -		mutex_unlock(&cfg80211_mutex);
> -		return;
> -	}
> +	if (unlikely(!last_request))
> +		goto out;
> =20
>  	/* IE len must be evenly divisible by 2 */
>  	if (country_ie_len & 0x01)


--=-W5BMEwxjaenlYrwQKk8U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcdgSAAoJEODzc/N7+QmazHUP/2PCVmMqliy7oMNKuuZxPtqq
CCh9fdXT515D0CcjPmHOJIJUC5AyVxv2M3ptAaFZ8tRhP6QtwXEsqgzWzLL3/d/Z
uA8avbLIHN1eFl+wua5XjY8I3Ufxk6ms2zDYVEGDus4IGoAJS1AdHwkAQUhBmV0j
0dgzQ72/hFo7xJNzvcRzd86Os+UR4P4EDokEnr5rv8r/Sc50s0ZgcJ8SFBO9bDL9
bv54jUXH4LFBs5DTPNysDtXOH0RlEsJfqcuZ/em6jggTI8NC03hDo822v2pFt1Y8
lqwuS92dOT/ruju/T+KQm2g5H3YXLEODHTcFP4TTW4DpAPJV6z0WRidTttzoILcL
xfZCfYcJoPdOKFLqVBICfELgoH1EEBlllFDu56MHVvxtW/Xb3X24x7UeM7511X/w
cHcdbZBl1zgsqPsy28WqCBHn19Kd4/WYqkq6ppk7gQ0460A+ZEfHXzKXpEF9Ic2b
ze78y0tJnU07Tw+njVgRJTO9nohdF+KIBuJ1mzraPDVqXd3H7dqX4P9qCiPobTzq
rbXRFS/YANKn2k7Dx/tEJRCbxzZinHopzWphOaj41UbA38Lz6D6YGGD8PL8P2i90
E8ltpXyUOkxs8CmUz+ZtEJ0tVZG5vMjI1djx3scGmLGnjmDAz+9Ptpn5PlXZjZxP
qbGK2LLGs54ub4QN/xDa
=XnJG
-----END PGP SIGNATURE-----

--=-W5BMEwxjaenlYrwQKk8U--

