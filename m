Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZGTKee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 06:34:34 -0400
Subject: Re: [PATCH] cfg80211: avoid setting default_key if add_key fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1248077577-7295-1-git-send-email-yi.zhu@intel.com>
References: <1248077577-7295-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DtHfcEOblUZ4bRds/sk1"
Date: Mon, 20 Jul 2009 12:34:26 +0200
Message-Id: <1248086067.4204.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DtHfcEOblUZ4bRds/sk1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-20 at 16:12 +0800, Zhu Yi wrote:
> In cfg80211_upload_connect_keys(), we call add_key, set_default_key
> and set_default_mgmt_key (if applicable) one by one. If one of these
> operations fails, we should stop calling the following functions.
> Because if the key is not added successfully, we should not set it as
> default key anyway.

Should we even disconnect again in that case?

johannes

> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  net/wireless/util.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 4bab380..ba387d8 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -546,13 +546,17 @@ void cfg80211_upload_connect_keys(struct wireless_d=
ev *wdev)
>  		if (!wdev->connect_keys->params[i].cipher)
>  			continue;
>  		if (rdev->ops->add_key(wdev->wiphy, dev, i, NULL,
> -					&wdev->connect_keys->params[i]))
> +					&wdev->connect_keys->params[i])) {
>  			printk(KERN_ERR "%s: failed to set key %d\n",
>  				dev->name, i);
> +			continue;
> +		}
>  		if (wdev->connect_keys->def =3D=3D i)
> -			if (rdev->ops->set_default_key(wdev->wiphy, dev, i))
> +			if (rdev->ops->set_default_key(wdev->wiphy, dev, i)) {
>  				printk(KERN_ERR "%s: failed to set defkey %d\n",
>  					dev->name, i);
> +				continue;
> +			}
>  		if (wdev->connect_keys->defmgmt =3D=3D i)
>  			if (rdev->ops->set_default_mgmt_key(wdev->wiphy, dev, i))
>  				printk(KERN_ERR "%s: failed to set mgtdef %d\n",

--=-DtHfcEOblUZ4bRds/sk1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZEgvAAoJEODzc/N7+QmatsEP/1mOAjHGmnVIQ56SEdHNxt8g
jxMGeVOL5uWz7uV033C2faM4Ytm63rUohCV2pbZ2tIlIrKe1iuuDVO5D05bnPrk7
gCYjoJQd9EGg64KpMRahaf2arN2prX8JbKdoTG99RPky4/nCoDQzIqXKkVoB4mLf
QaXL92mwDurMffxx7I4LKu6Lal9yYuunmm1xRcmuZVtqR/J/DnsZ+6CTVbW1gHPt
0KGl635hX0eSpCB7lMDl05HWHaR2dUXo+N3J86AUcGQrOhlQiBTo5TbpdKCoVFwd
hLB8kRVBwLBuUm8vbPgKeuQrg/sKIlzwqDdVDTCUeWp2AaRRkKJ3+uJxT+ZLArlo
v+Ny1RmOZh39hlB6/hbEuoa3LDr129KYkxrkPuvDv8k7A2x/hVMtnpHVBVc0/36B
3sKozw+eQiu8ZgF9IxDIwu1LBWpsY93wrhxn1sv6ueMLmA/Tck1DVVmH3E/nVGeX
k8HBraH9+Q+tVL0700oxTaiQ0l6m3mAsyewQoAceBc8AvxjDfQW5gh9tSlGWLdMe
HF9/3jV2LhmL/6c895VSMzDWziAPdzWkyfUXFc4z8jVD1FyxSbIaNVLwyhTq+g5E
az8ex39HlroyHi0tLsNj8ngC1rztXPbiFG3BDySx7Klid1Dho59dNRPR9hLsc+T/
ZOKwX7s1qogDSzPDlK9y
=xPPh
-----END PGP SIGNATURE-----

--=-DtHfcEOblUZ4bRds/sk1--

