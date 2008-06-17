Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYFQRGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 13:06:43 -0400
Subject: Re: [RFC PATCH 4/7] 802.11w: Use BIP (AES-128-CMAC)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617155920.329586297@localhost>
References: <20080617154008.883383150@localhost>
	 <20080617155920.329586297@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X5Gtz1LbQBjVOARNDJmQ"
Date: Tue, 17 Jun 2008 19:05:47 +0200
Message-Id: <1213722347.3803.89.camel@johannes.berg> (sfid-20080617_190646_362889_A8272CC2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X5Gtz1LbQBjVOARNDJmQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> @@ -603,30 +605,38 @@ static int nl80211_set_key(struct sk_buf
>  	int err;
>  	struct net_device *dev;
>  	u8 key_idx;
> +	int (*func)(struct wiphy *wiphy, struct net_device *netdev,
> +		    u8 key_index);
> =20
>  	if (!info->attrs[NL80211_ATTR_KEY_IDX])
>  		return -EINVAL;
> =20
>  	key_idx =3D nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
> =20
> -	if (key_idx > 3)
> +	if (key_idx > 5)
>  		return -EINVAL;
> =20
>  	/* currently only support setting default key */
> -	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT])
> +	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT] &&
> +	    !info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT])
>  		return -EINVAL;

I think this should probably check the key index depending on the type,
i.e. only permit 4 and 5 for mgmt and 0-3 for data keys.

johannes

--=-X5Gtz1LbQBjVOARNDJmQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIV+7oAAoJEKVg1VMiehFY0LcP/2hL/IjrQdMIX1k8PCpoNoOQ
cfNZ2cN+Jtu0VBS1hwQVRoN11jg2VrwkEaNxGXvDH50QKMeM/zCqYcBk9lVR/dCF
smsTn7aAHqBOUIgGVUxBzo7Ap1dMUpxaPzPKPYa7Bkyz1UpF2R8ZRN6ycni4IEZW
lyHxCoIjArdAMbKbD7GDPS4zWCUC6Vp35g+WkcGX1kwebV0OM4vNUFM6VgOqhbrk
qY+HUh/DZG5NC/hMMW2uJuwLC7xEM/TZ/jlBvVIXlDG+9amSoteh/NGr1OrSYwRh
j03ehLF60R97CpOdhjkuqGAhn9zAdo1drWTzsUip1wthybIRJG5VdtBxIxVyBbd+
UH0kDwsgXRRg/zytUehR2PruCdK6wIC8sJhHlOTgQill+e9DiuUKwFlazOd2k/Zu
Ua+CLSeyX1bAgFIDV/e7DWzxKyAOZ4tYF27MnVRbIdy0S4JrzW9yPbO7kLpsz0qe
2XVOWCZvz9r+qbLHwSRYQKONk+sycX6cj/dJH1UPEY5MEC9N6u2ZXvAhqp/6w+6v
JfI2fYY9VkWqygL73ZpYNE6DeG9wXS/qZhxnD1f6xh4sGvdRw7+5ByF/JjfH1tEF
GhPVlSHBo7I7nd74eBXZkTipujWxEThaBGSKc4/P7C7CcNZ9vOUmEAshL3/VXvaI
vep+sM2XoiL6vlmGk23j
=8cVK
-----END PGP SIGNATURE-----

--=-X5Gtz1LbQBjVOARNDJmQ--

