Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbYCMVC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2008 17:02:56 -0400
Subject: Re: [PATCH 1/1] mac80211: Tkip fix sparse endianity complain in
	tkip code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1205431553-20567-1-git-send-email-tomas.winkler@intel.com>
References: <1205431553-20567-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4oIZWQi5DAO8kPIynMO8"
Date: Thu, 13 Mar 2008 22:02:10 +0100
Message-Id: <1205442130.15910.18.camel@johannes.berg> (sfid-20080313_210305_352594_25A468BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4oIZWQi5DAO8kPIynMO8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-03-13 at 20:05 +0200, Tomas Winkler wrote:
> This patch fix wrong cast in tkip code
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/tkip.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
> index f61f1dd..0ce2a84 100644
> --- a/net/mac80211/tkip.c
> +++ b/net/mac80211/tkip.c
> @@ -118,7 +118,7 @@ static u8 *set_ext_iv(u8 *pos, u16 iv16)
> =20
>  static u8 *set_tkip_iv(u8 *pos, u32 iv32)
>  {
> -	*((u32 *)pos) =3D cpu_to_le32(iv32);
> +	*((__le32 *)pos) =3D cpu_to_le32(iv32);

The patch introducing this code will be reverted because this is also
rather bad code since it's not known that "pos" is aligned to a
four-byte boundary.

johannes

--=-4oIZWQi5DAO8kPIynMO8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9mWUaVg1VMiehFYAQKjphAAtUIUgu/xa5NziRnrqM8VDpePnhJ5ww6F
eOif0dPP0LC/UN4xKpsXK8W8kgiisUWLRGJHaiCsCGipA6Y8Orm7KbSFrNzqFd/Y
wcUXEL0qRLzGyLO5+JlRmEUOUQoKNxq+8jiyhar/wNz2DfOrxH6IBqPcfLZ8P+1s
ZuYJ3/I74sBQYCTkIVgZuDsg2ox+QEYtlpPujnL8u2FrIwAEnDe0cSry5uRFzUrQ
80oZle6O0MY0J23pTht4XxKHgagx6FRNdFTLuptrKcKiQOqCW1zXUHvmJPvfUO5j
nNKcYcXzYo6Jpvn37AgNWa2ngvcLXJJhQ8Bjk96bVQ9q/4kDZPNqCy49IQQAqAUM
0zw4FNsmbIl990Qej6uZyIOMPR2s9uj2twjcQIQX3CGCtNt3ULqb0TB3gdj6M/ni
lT09vMChzmqlt7AP1F8k6OQEsoPoNpTW333QXFc9uL5AAlgZlkyk/TTe3PxkLovM
23oTL58Vd5gG7se49i/WuISKcOWetmTY9vdxB4DINB3khcun9NAQ6+q0dgeHtIJF
tyUAQE7pWKbP/adtowK3DNRwoSGWjBXFZ4NbZuqUirqbaTNhyBAuHPIJE8KxWjOR
5Qky27RzIVmpnU2lx16B6uXFMchvGBsS8iKH2xfssPenWMAz9xxElNlpBka7gG5c
WkgIYafbCVk=
=E2Yp
-----END PGP SIGNATURE-----

--=-4oIZWQi5DAO8kPIynMO8--

