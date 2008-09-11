Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbYIKWjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 18:39:13 -0400
Subject: Re: [PATCH] mac80211 hwsim: make radio list dynamic
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1221172622.5956.10.camel@johannes.berg> (sfid-20080912_003741_082920_D8B45771)
References: <1221172622.5956.10.camel@johannes.berg>
	 (sfid-20080912_003741_082920_D8B45771)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f8NElbJI16Y8FopjVWTX"
Date: Fri, 12 Sep 2008 00:38:38 +0200
Message-Id: <1221172718.5956.11.camel@johannes.berg> (sfid-20080912_003916_868171_3F62FCE6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f8NElbJI16Y8FopjVWTX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  static inline void hwsim_check_magic(struct ieee80211_vif *vif)
>  {
>  	struct hwsim_vif_priv *vp =3D (void *)vif->drv_priv;
> -	WARN_ON(vp->magic !=3D HWSIM_VIF_MAGIC);
> +	if (WARN_ON(vp->magic !=3D HWSIM_VIF_MAGIC))
> +		printk(KERN_DEBUG "iface type is %d!\n", vif->type);

Oops, that hunk wasn't supposed to be there.

johannes

--=-f8NElbJI16Y8FopjVWTX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyZ3qAAoJEKVg1VMiehFYvyEP/035lyIeKjxEfNE963u+yi8p
iYm+1e2qV8OqZH//ubYoXvh1nhZpHFb/UdJ+CcWPnAdTzJZn+svZOfN+S1FeXaP0
E3taxelm3O8rJEtKYySSEd5KotKJotCyH18OIQBFTB6vfCwVIIqQpo9le4EDvwvc
JMmMujUrM+M9MVrE1V3nKmX6SR0yLxxfjHQywIxcU9M4wFhKTFja8LOzwyG8tL+B
mxGLSQxMkgfAdtEKbkYEXVezyMovb/za09vsaIjlMmG8e/rAaISdG3kZVjMeNTZq
tTMk4/CK4azIVL70LRO0qujLGVg8BsvXnCaY2eWlS3QLSVw1XN9D2wmjJWE1DSSv
v8Kcj9zyIK46LCztmeMgC/C1TIH5xZhIF3xsS2EjWvlhTFQerR/mUO/k6cTD0ees
YIvzW5F25iNY1alBXVraEo5WvhpsH83dlew5bEsV9SxYhRDlA0da32DKj2V2etyF
K4ZjGZMBg+MtYQMhrXB9QQ0MqPuTixCGsLuqcX+oEZ72iBdVNtx9nKalbyxvHuGr
j5h0uxXXrU3H9K8xPC/rUrM2fKXo7qtLreDMlCzMY0f+S8HrWpovVOiNXtL4we1O
zrzmKyvbxC+lDIkBsbRV4QeqkOayYRm938mBb/Yx6TDoA85UR5s0JpC10EoWLy/9
FbkzzwT1PFqCi31CYsL6
=9U0Z
-----END PGP SIGNATURE-----

--=-f8NElbJI16Y8FopjVWTX--

