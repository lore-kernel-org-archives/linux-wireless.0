Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZBOK6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 05:58:54 -0500
Subject: Re: [PATCH 04/10] nl80211: disallow user requests prior to
	regulatory_init()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234589627-16977-5-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-5-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dlx1/p0IZpqf/XAZNP89"
Date: Sun, 15 Feb 2009 11:58:46 +0100
Message-Id: <1234695526.4219.46.camel@johannes.local> (sfid-20090215_115900_117287_DBD3C563)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dlx1/p0IZpqf/XAZNP89
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
> If cfg80211 is built into the kernel there is perhaps a small
> time window betwen nl80211_init() and regulatory_init() where
> cfg80211_regdomain hasn't yet been initialized to let the
> wireless core do its work. During that rare case and time
> frame (if its even possible) we don't allow user regulatory
> changes as cfg80211 is working on enabling its first regulatory
> domain.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/nl80211.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index db973f2..6f4dedb 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1876,6 +1876,15 @@ static int nl80211_req_set_reg(struct sk_buff *skb=
, struct genl_info *info)
>  	int r;
>  	char *data =3D NULL;
> =20
> +	/*
> +	 * You should only get this when cfg80211 hasn't yet initialized
> +	 * completely when built-in to the kernel right between the time
> +	 * window between nl80211_init() and regulatory_init(), if that is
> +	 * even possible.
> +	 */
> +	if (!cfg80211_regdomain)
> +		return -EINPROGRESS;
> +

But that variable access here is racy too. It might be ok anyway because
the variable can never be NULL again after the first assignment, but in
that case the assignment needs to take care to assign something fully
created ...

johannes

--=-dlx1/p0IZpqf/XAZNP89
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJl/VjAAoJEKVg1VMiehFYZ8AQAKL57SVppDTKKKhBkV4D+Kfs
kwv1S+Xcb+vRoDJ8IMPvBf92axyRySPSf2+b7lULIY6hYm0wjREYuydgVy7Vk/B2
8mw0qJwQsbgwnOktExRXr5j2pvmXdXHZVG2cpDmaJ11kUzN+gIu2iMczqckQ2dEO
PItOrI2cwlfgtPYngLikek0jHhxQGhVaYWTn5BChOZ6gwG45U90C93aLmsZA9o7k
a2148xUugRYg2+2hmfwikrrtds4Ejt78Nm9YrzEy8IvqGLPQ2ZITR9dE1nOYbaJP
wqkXzmfw4KQbLsugm63iF9x0oaELSIIR8W2iAU+fzI/YMtCWyIYS4dZHgHyGc1Nm
mJuOTZ6To3jYYMdYCZoENXjVukIiO+0q3IiNFqQ2qmdnJ9YNRSyjjCti6NmoM819
V0kczVa/pP4ozCW+68AESMAQhinO0Hqmj9/DQttsAKA9afFv/Z5MBJ3010GhHZ4O
o7F/UWi9HPFko8tleLg1SYj715tk1EzLMP1NtyuCsxealiYxfjhR8RcY8W1sLdtf
EGgUf2O53qdjPcczcFynMtnYTzWXB2QFPMXcJgBzWs24wkl31QPRJinuQ759JwQF
OoqBQZSYds/89VXGoqDrfnRwdxyaL12yRmpE3kueNqkDp9peKAAvgTuLh171H74C
My+Nk9B2DXAXtkFruMCK
=BDfM
-----END PGP SIGNATURE-----

--=-dlx1/p0IZpqf/XAZNP89--

