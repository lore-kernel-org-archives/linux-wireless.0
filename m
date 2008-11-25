Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYKYTNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 14:13:07 -0500
Subject: Re: [RFC] nl80211: Add frequency configuration (including HT40)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081125190533.GA27879@jm.kir.nu>
References: <20081125190533.GA27879@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fhJ5luL5ie2yP5VyS51n"
Date: Tue, 25 Nov 2008 20:13:04 +0100
Message-Id: <1227640384.4613.44.camel@johannes.berg> (sfid-20081125_201311_859346_3F8C7315)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fhJ5luL5ie2yP5VyS51n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-25 at 21:05 +0200, Jouni Malinen wrote:

> +	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
> +		int sec_chan_offset =3D 0;
> +
> +		if (!rdev->ops->set_channel) {
> +			result =3D -EOPNOTSUPP;
> +			goto bad_res;
> +		}
> +
> +		if (info->attrs[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]) {
> +			u8 val =3D nla_get_u8(
> +				info->attrs[
> +					NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]);
> +			if (val =3D=3D NL80211_SEC_CHAN_BELOW)
> +				sec_chan_offset =3D -1;
> +			else if (val =3D=3D NL80211_SEC_CHAN_ABOVE)
> +				sec_chan_offset =3D 1;
> +		}
> +		result =3D rdev->ops->set_channel(
> +			&rdev->wiphy,
> +			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
> +			sec_chan_offset);

Isn't that missing regulatory enforcement? I'd rather see that in
cfg80211 than re-implemented in all drivers.

johannes

--=-fhJ5luL5ie2yP5VyS51n
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLE47AAoJEKVg1VMiehFYi1oP/1vJn4cdhbVfRQuP3prnHKiA
QpFTB9A2s57eDsFqke6Mp1NFGYOcmy/6JIZmriBwyBlsYJPKtRqKU8e6dsix1NeI
T/RAL7ocvRkV3T4oBjlO/c/zfHL9eFY1p8+cUtlaRv+DRRN0nv+Gofv5Mi9GuuGD
f8eNtEEzKw4k+4M0ZNkjfgkLFrauDphI+y/8KkeMylQRDc0aGMxIl1892DKe3Y1V
wSrCkc8FlKqezcO8Hp+H5hw3cIdQlBvVOhpp5nIs9i8JMo1WWpsp07/9CTsPznxM
d3x9w9qz5lDRaZDrZGc/qVDymuvUCyuGaKZphTejVzhCBVAq/ZkzublkNjl5XcZM
KIqekyDmQf+MelEK/dWM9sO9vA6JIJH62rA9rMfLsKyjSHE3Eq27y2wu2Q8MVsbv
zuRf30lSc2oj4odG66FFoTp+Pkhg9ejw8wehqQ8sjppH5+Lq6SA5C8VyETftT4te
UJ13XiyKQkzFVHQOL2vKMZjBddtsazAURgdGTw5yndpMZP0UDLuMB7QVsKk8gwQu
o4x5EYJjP8P+UatcQHjGhfFtGv/MJGq7PuxtbjXqx9EGfcPONRwefNebK0bU6Z/Z
vufm52CwDJRBYvWIkxaKcXIZQJGAidMt4oJm7QaNtOVonB1djvjXx9CVMgJHE3+E
V/EQhKXqnmVRoX8ednqY
=JYxP
-----END PGP SIGNATURE-----

--=-fhJ5luL5ie2yP5VyS51n--

