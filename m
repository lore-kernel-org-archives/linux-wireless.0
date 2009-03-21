Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZCUIEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 04:04:36 -0400
Subject: Re: [PATCH 2/4] nl80211: Add more through validation of MLME
 command parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090320192353.233644676@atheros.com>
References: <20090320192115.448175935@atheros.com>
	 <20090320192353.233644676@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-glnt+z+pDsSx0RHBpz4h"
Date: Sat, 21 Mar 2009 09:04:31 +0100
Message-Id: <1237622671.5100.165.camel@johannes.local> (sfid-20090321_090440_044620_93E437BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-glnt+z+pDsSx0RHBpz4h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 21:21 +0200, Jouni Malinen wrote:
> plain text document attachment (nl80211-validate-mlme-params.patch)
> Check that the used authentication type and reason code are valid here
> so that drivers/mac80211 do not need to care about this. In addition,
> remove the unnecessary validation of SSID attribute length which is
> taken care of by netlink policy.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/nl80211.c |   32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
>=20
> --- uml.orig/net/wireless/nl80211.c	2009-03-20 18:03:53.000000000 +0200
> +++ uml/net/wireless/nl80211.c	2009-03-20 18:03:57.000000000 +0200
> @@ -2614,6 +2614,14 @@ static int nl80211_dump_scan(struct sk_b
>  	return err;
>  }
> =20
> +static bool nl80211_valid_auth_type(enum nl80211_auth_type auth_type)
> +{
> +	return auth_type =3D=3D NL80211_AUTHTYPE_OPEN_SYSTEM ||
> +		auth_type =3D=3D NL80211_AUTHTYPE_SHARED_KEY ||
> +		auth_type =3D=3D NL80211_AUTHTYPE_FT ||
> +		auth_type =3D=3D NL80211_AUTHTYPE_NETWORK_EAP;
> +}
> +
>  static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *i=
nfo)
>  {
>  	struct cfg80211_registered_device *drv;
> @@ -2666,6 +2674,10 @@ static int nl80211_authenticate(struct s
>  	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
>  		req.auth_type =3D
>  			nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
> +		if (!nl80211_valid_auth_type(req.auth_type)) {
> +			err =3D -EINVAL;
> +			goto out;
> +		}
>  	}
> =20
>  	err =3D drv->ops->auth(&drv->wiphy, dev, &req);
> @@ -2718,10 +2730,6 @@ static int nl80211_associate(struct sk_b
>  		}
>  	}
> =20
> -	if (nla_len(info->attrs[NL80211_ATTR_SSID]) > IEEE80211_MAX_SSID_LEN) {
> -		err =3D -EINVAL;
> -		goto out;
> -	}
>  	req.ssid =3D nla_data(info->attrs[NL80211_ATTR_SSID]);
>  	req.ssid_len =3D nla_len(info->attrs[NL80211_ATTR_SSID]);
> =20
> @@ -2769,9 +2777,15 @@ static int nl80211_deauthenticate(struct
> =20
>  	req.peer_addr =3D nla_data(info->attrs[NL80211_ATTR_MAC]);
> =20
> -	if (info->attrs[NL80211_ATTR_REASON_CODE])
> +	if (info->attrs[NL80211_ATTR_REASON_CODE]) {
>  		req.reason_code =3D
>  			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
> +		if (req.reason_code =3D=3D 0) {
> +			/* Reason Code 0 is reserved */
> +			err =3D -EINVAL;
> +			goto out;
> +		}
> +	}
> =20
>  	if (info->attrs[NL80211_ATTR_IE]) {
>  		req.ie =3D nla_data(info->attrs[NL80211_ATTR_IE]);
> @@ -2817,9 +2831,15 @@ static int nl80211_disassociate(struct s
> =20
>  	req.peer_addr =3D nla_data(info->attrs[NL80211_ATTR_MAC]);
> =20
> -	if (info->attrs[NL80211_ATTR_REASON_CODE])
> +	if (info->attrs[NL80211_ATTR_REASON_CODE]) {
>  		req.reason_code =3D
>  			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
> +		if (req.reason_code =3D=3D 0) {
> +			/* Reason Code 0 is reserved */
> +			err =3D -EINVAL;
> +			goto out;
> +		}
> +	}
> =20
>  	if (info->attrs[NL80211_ATTR_IE]) {
>  		req.ie =3D nla_data(info->attrs[NL80211_ATTR_IE]);
>=20
> --=20
>=20

--=-glnt+z+pDsSx0RHBpz4h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxJ+MAAoJEKVg1VMiehFYNUgP/i4nenDYe59vZVkKBLf+w1rj
Dgvi6+GVteX9CzZUWLPJc/adKhp60ilV1ta0TXw+EbpfFUupU0JWg3H9vYEpIlss
SVAkr2CvxwMtJXjIbplMwoHHzPdeX/bnwt6yIxFNsriv3+6nATh44i3Io5GIWYS4
a+Dk6r5n6qrD0KIN4vM762b4KDnWT4Bjj0FjzEHLlaXpSB5sxI4qbwXnW6WOd9GK
bswh4WReTLkOsSoieFUPaQO6cKfmY0lLouZRwGc5lEP/l28ea1lYDZlOR/sIN1a7
7T4IsaZUNJxUu89b2uFVHFPAkUpAjpQ3ORAJuMbeI2hd8KJwYi02wUd7vBECf2Wn
9pnhuAvEQaRLR7ydXVnoqjyhCn5URh0XhIKp4RzrjMhq+dTrHMH8xb7p2NZg3kJ9
s+iuWXUB3CzvRPZgOAAEsd92mVUx/d7sXKKAg0wK33ckJ504d+Dhhcmglkr8dQNw
JxgXT9YEotTDf8gBgPq/Qio17WCYVRRZKup6JxtGqeebZmVbPIzDPadhFsX/q+gw
ny5unIwCZYMIxi995LSvNhoLcNk9eIwJAiKvJ0vCFL+0z0tymUVT8qUo95L4MSan
QdSR+leRfLdwS1Z44WkYzWLOdDFOExCuruWmlA2ooruJeofOUhYhCbooAC1wFyn8
mPDbBzNiiUuBwIowdca7
=IkTS
-----END PGP SIGNATURE-----

--=-glnt+z+pDsSx0RHBpz4h--

