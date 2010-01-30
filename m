Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab0A3Ifv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 03:35:51 -0500
Subject: Re: [PATCH 1/1 v3] cfg80211: wext: fix cfg80211's SIOCSIWAP
 function
From: Johannes Berg <johannes@sipsolutions.net>
To: shanyu.zhao@intel.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1264801649-4985-1-git-send-email-shanyu.zhao@intel.com>
References: <1264801649-4985-1-git-send-email-shanyu.zhao@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+ulKcN6AaOL68fBCznuk"
Date: Sat, 30 Jan 2010 09:35:45 +0100
Message-ID: <1264840545.3546.179.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+ulKcN6AaOL68fBCznuk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


> @@ -779,10 +779,15 @@ int __cfg80211_connect(struct cfg80211_registered_d=
evice *rdev,
>  			wdev->conn->auto_auth =3D false;
>  		}
> =20
> -		memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
> +		/* make sure it can connect if only bssid is provided */
>  		wdev->ssid_len =3D connect->ssid_len;
> -		wdev->conn->params.ssid =3D wdev->ssid;
>  		wdev->conn->params.ssid_len =3D connect->ssid_len;
> +		if (connect->ssid_len) {
> +			memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
> +			wdev->conn->params.ssid =3D wdev->ssid;
> +		}
> +		else
> +			wdev->conn->params.ssid =3D NULL;

I don't think I understand this. The wdev->conn->params are initialised
from "connect", and now you're copying the data back again? That's not
making sense to me.

Also, please say what exactly are you trying to fix.

Also, cfg80211_mgd_wext_siwap() certainly is _not_ expected to clear the
SSID, since we want to connect to the previously set SSID. Same with
cfg80211_mgd_wext_siwessid(), it should _not_ clear the BSSID.

Right now, it looks to me that your patch makes it impossible to specify
both the SSID and the BSSID to connect to, which is definitely wrong.

John, you mentioned you had applied this, can you revert this patch for
now?

johannes

--=-+ulKcN6AaOL68fBCznuk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLY+9eAAoJEODzc/N7+QmaQDEQAJxnbimW4zR1kKZj1/BSmnXC
do3A7c8RQS0+JqO6DQiv2+YS3Rwnp5o8INpdq2safxax0gYRySxWnJmabRa4Asxw
zGIGEafy9mDqaZYe9/QPcGUikzFIOmPigCd4V82VdpPTEDb64/3cdflM0N6pvdRY
yN0yjQdi+WjnzVh+Ke0xLotUW6ZDPPTKDPyEv/spM7BouCdBYkHz344cLc4iySMe
lqrvpOLbBbTQ0ArGisr/mgBAxKR7dhrK0FelJkEXN5Iull9MCBp6szmeBjCe/6XN
T9nU1QC4fDl5lVdCSERqC7UGjtK0tu14knk8ohdh6VdsV23ADaEuA6TSijCnIHn6
anNXeOxTgoV4Y3PLNVRUcFf8Ypbv/Z438CZpA7u7Yx+7VQ2HzxrF14tXiJa+6EMq
3NXGvNbS2bnWEblbmyVUeThauiQRdZ4lPu31pRpzP6xU+H2t2u+lD48fLCCQyvkf
xI69CLqcffn7PiesusSlnSMA2U1nLvOrKYyr2Ke62Ohm+MYBRIQx1zWLdvayQRHz
Hkimeo4P4cvOe9tCMgsS/6kMw8JsQ1NMhCii6VyLRNaBRNZv+mVUQlpzqg8F+D6i
HTZKmPnHUnfF3K+ndGOgevRMzr9nJ+XOzWHim6x/4vxkdKbtVdRKAgGqqoxNBNyO
F8t5jn89w2OCm0uhoAX8
=jqWK
-----END PGP SIGNATURE-----

--=-+ulKcN6AaOL68fBCznuk--

