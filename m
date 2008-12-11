Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712AbYLKNya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 08:54:30 -0500
Subject: Re: [RFC v2] mac80211: Fix HT channel selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jouni.malinen@atheros.com, lrodriguez@atheros.com,
	tomas.winkler@intel.com
In-Reply-To: <18750.13163.213759.181839@localhost.localdomain> (sfid-20081209_100146_066280_ECCEC8C9)
References: <18750.13163.213759.181839@localhost.localdomain>
	 (sfid-20081209_100146_066280_ECCEC8C9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4lGZj2X8RGkPO3R+d8Bf"
Date: Thu, 11 Dec 2008 14:53:44 +0100
Message-Id: <1229003624.8081.3.camel@johannes.berg> (sfid-20081211_145433_297730_8B695789)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4lGZj2X8RGkPO3R+d8Bf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I was reading this patch again because I was looking for something, but
noticed something else:

> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -98,6 +98,7 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *s=
data,
>  	struct ieee80211_bss_ht_conf ht;
>  	u32 changed =3D 0;
>  	bool enable_ht =3D true, ht_changed;
> +	s8 channel_type =3D NL80211_CHAN_NO_HT;

That variable has the wrong type. Doesn't really matter much, but s8 is
a bit strange.

johannes

--=-4lGZj2X8RGkPO3R+d8Bf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQRtlAAoJEKVg1VMiehFYArUQAMEqS1WmRMZBxozWjNC2TFgd
d0iTFKUw1131CxmWHrWgbfBmOfeUHXJWtzcTXqjeD6uYs0uNsQJQmeygRz/IiMKl
s+XJeHfkANfKf8YUnEZmKsV7XEgFMRgVBwFqQ5rL6s6nRk0CfXX4H7/XpcYVaogb
hwTguUug8V9fUC3pCO2v3U7vD2/TZHRPiTfMJ1RacGqfNThx+mEKoQzkykCt5dzZ
ab41028vSu++Gr+9a+c6/jTpGNFwEJw75aGpv2GfNpZJAQZCrVhuptG4V1prfpO3
aPlXD899Yfj1WThSeEVxNli5M1C5sfE1gJ4K4EPylfc39demdD2PnvvHkeA/qO+2
/5ecPFT/5GrMmHFw0i8AC39QpYGmhQCfLBJDX4XQSMAOObXCpI6tBNMBjhrCz3Vk
9XyoIv0QNJCqsVNOz/1DirFKilkyi7GU4nhDfnX+eF2Ah5d8X5VGbtCqpyRwGlXy
qtO5JeKPh7w1stFDI3f4tQ7mVuGYQKAXsmC2h+o8hu9s1yQBfz5peKSJopc/7xc5
enQOFylN23Lbzk4xnGhru6HYI0cQ3U/gF4k6bQCzsQpGxfX/3a7ma0q0JLtGTgfy
b7rFE/D45e75jrpwAQfrc1ne2pUW9ONhAdBu2ttGINvCmL2ZI0DSM6FBq+rJP0Bq
5WqpT7JZkUJ6XdmsfTYY
=Yd7t
-----END PGP SIGNATURE-----

--=-4lGZj2X8RGkPO3R+d8Bf--

