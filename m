Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbYKEMB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 07:01:27 -0500
Subject: Re: [PATCH 5/7] cfg80211: expect different rd in cfg80211 when
	intersecting
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bX2GDWsRc4YqPbtkQy8m"
Date: Wed, 05 Nov 2008 13:01:29 +0100
Message-Id: <1225886489.3619.84.camel@johannes.berg> (sfid-20081105_130130_436247_924922F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bX2GDWsRc4YqPbtkQy8m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
> When intersecting it is possible that set_regdom() was called
> with a regulatory domain which we'll only use as an aid to
> build a final regulatory domain.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 845e2d3..f062b8b 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -880,12 +880,13 @@ int set_regdom(const struct ieee80211_regdomain *rd=
)
>  	}
> =20
>  	/* This would make this whole thing pointless */
> -	BUG_ON(rd !=3D cfg80211_regdomain);
> +	if (!last_request->intersect)
> +		BUG_ON(rd !=3D cfg80211_regdomain);
> =20
>  	/* update all wiphys now with the new established regulatory domain */
>  	update_all_wiphy_regulatory(last_request->initiator);
> =20
> -	print_regdomain(rd);
> +	print_regdomain(cfg80211_regdomain);

Maybe the printing here should be removed? It seems confusing now.

johannes

--=-bX2GDWsRc4YqPbtkQy8m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEYsVAAoJEKVg1VMiehFYFtkP/1iQYfBi2RRUJ/eJxdnucT1+
SFFWA7DhFYM5sKwwbrgE7cEjh5MAvCp58bZsDEv2QFPHUX3GTf42R4hFniNzkYUH
SSFUIw5mQGtveMHhP1X4cpx+JxNXx+qpuffyIhWNTtjqhjKIgVf/4BJz7EddS06N
rVYOMXLtj0tqWFT5TqGMsu9a9U/A69b143mth7Ilg0StZ22Oz5P5hZJSeKZEuvAI
mJEWJZ+7it6KvJZxWlT2v9sTbekeoDE/E7q8xHDGWJtaMZ1xziJS0NnanxhyxC0r
o/+J5tv7x6QcS8UcqredQa+z7uvK1aDGyr7pQApgG7Xu+fslwJ22US6/E/V+DPz6
SCs28MQGwDPF1rMH7udnJ6YLDtsCrlV1BFyTQL4hzIYHmLPGJkYcr74FM7vUiZ4I
+jT4oAzWHDN/Z3/Os71gyT8qHmO42gxVuLZ9avjIao2ojseFFMgob1mHiN/LOQS0
bzmIcg+28ZWzjH5AAf7CNe7wmvccUpASmjl/rZNoTV0n9YgKyk0RQsGBpmGgh6LU
/80huQ1TlmxcOTSYPP7UN36qpJpLrr8WfGzQ0C7chG516JceAI5tx5zXjtf/nywJ
ZFSV3HK/r9x+jF7zxGi72SylO3oyrZOEn73pOd3xxzP5JWl+QQUxh0/vq0kvrWVO
f1b/NnYrAYIPUgqbkjF3
=4ASH
-----END PGP SIGNATURE-----

--=-bX2GDWsRc4YqPbtkQy8m--

