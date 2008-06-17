Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbYFQRKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 13:10:24 -0400
Subject: Re: [RFC PATCH 7/7] 802.11w: Configuration of MFP
	disabled/optional/required
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617160027.897662688@localhost>
References: <20080617154008.883383150@localhost>
	 <20080617160027.897662688@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xOFNyaSzN7OiMRgBB129"
Date: Tue, 17 Jun 2008 19:09:30 +0200
Message-Id: <1213722570.3803.92.camel@johannes.berg> (sfid-20080617_191027_230594_C1F02CCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xOFNyaSzN7OiMRgBB129
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +#define IEEE80211_MFP_DISABLED 0
> +#define IEEE80211_MFP_OPTIONAL 1
> +#define IEEE80211_MFP_REQUIRED 2
> +	int mfp; /* management frame protection */

Maybe an enum would be good?

> --- wireless-testing.orig/net/mac80211/wext.c
> +++ wireless-testing/net/mac80211/wext.c
> @@ -1003,6 +1003,13 @@ static int ieee80211_ioctl_siwauth(struc
>  		else
>  			ret =3D -EOPNOTSUPP;
>  		break;
> +	case IW_AUTH_MFP:
> +		if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA ||
> +		    sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS)
> +			sdata->u.sta.mfp =3D data->value;

and shouldn't that be used somewhere?

johannes

--=-xOFNyaSzN7OiMRgBB129
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIV+/GAAoJEKVg1VMiehFYsY8QAKDpf5yOpVwpKHGF/b5jlYWb
uk4fN2iu6hGfeEfQQ9VjtoCyXXv+F0G1+wklKrsAa3NtE7RGowjqthOwQRzHpeQq
Tqif36PlJuE30ll2srv/imamxlGcZs1X9aW4Zy1aAs6Jxk/VtEkXlBy84FzbSymV
bGFtca33jiwplhu0j7TaWH41wXxtYabmUL4mEU+GnxAIM25ba0GDbQyxFGCk9BAS
lVGpepo5uTIreLHyZYkA183X7CkkEQRhIcBt0CKG3bGuGKWtWZmVPu1ge1FJiGaH
8PV4R3kIwa6CfsKZH0lmrCdZM1wBKSFNGokW2Gp6RwSyUQNE+RdQ5kADjmxGpQeB
UGlOM4YvGFBV1Caqe92LjecBeRf4UIxbGb/TNoVxtBD2BRPL/mzdXL98Cvm03v/B
cUmwySeGwJZCQGqjgT2VxpKmYE8FlZ4GX85pmkyWA7qoTeQ1NDhKzypHEv/9cmNv
0a4AUYbLStQoCGQM/tLPfgKwxxmtLizTMe37jSoq94Hguj3Z/1FMIt+7cwL8grZW
HWBGoT9nFxcM4OL4f9uhneHjk92yVQQykN35bu8xJI7VjdTiUJ/CJMSIs0LnXtr1
VLjPQkqAprEAj7NThvCOGyL2OT2G/HTFeMZmJsKUR0Jm5o0i33mX7QadrIk4raUf
4AH/JtmRQneozFkAaAux
=UHuR
-----END PGP SIGNATURE-----

--=-xOFNyaSzN7OiMRgBB129--

