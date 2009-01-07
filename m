Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZAGQhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 11:37:13 -0500
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <20090107163322.GA26418@jm.kir.nu>
References: <20090107112346.369581673@atheros.com>
	 <20090107112707.370907962@atheros.com> <1231330118.3545.28.camel@johannes>
	 <20090107122427.GA20019@jm.kir.nu> <1231332428.3545.33.camel@johannes>
	 <20090107140956.GA22424@jm.kir.nu> <1231340944.3545.38.camel@johannes>
	 <20090107153052.GA24894@jm.kir.nu> <1231342671.3545.43.camel@johannes>
	 <20090107163322.GA26418@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9P7UpBOMx2OfAQXY+qaL"
Date: Wed, 07 Jan 2009 17:37:34 +0100
Message-Id: <1231346254.3545.54.camel@johannes> (sfid-20090107_173719_168999_F3230E23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9P7UpBOMx2OfAQXY+qaL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 18:33 +0200, Jouni Malinen wrote:

> How about following on top of the MFP patch series (and a small change
> to ath9k to set this flag)?

Looks good to me.

> PS.
>=20
> Actually, NM would probably not need to care about MFP at all (unless
> user wants to require it). I think I will change wpa_supplicant default
> to MFP-optional once 802.11w gets deployed and is found not to cause
> problems.

True. Except that there probably will be problems unless everybody
implements it perfectly...

>  ---
>  include/net/mac80211.h |    4 ++++
>  net/mac80211/wext.c    |    4 ++++
>  2 files changed, 8 insertions(+)
>=20
> --- wireless-testing.orig/include/net/mac80211.h	2009-01-07 18:10:40.0000=
00000 +0200
> +++ wireless-testing/include/net/mac80211.h	2009-01-07 18:11:33.000000000=
 +0200
> @@ -866,6 +866,9 @@ enum ieee80211_tkip_key_type {
>   *	Hardware which has dynamic power save support, meaning
>   *	that power save is enabled in idle periods, and don't need support
>   *	from stack.
> + *
> + * @IEEE80211_HW_MFP_CAPABLE:
> + *	Hardware supports management frame protection (MFP, IEEE 802.11w).
>   */
>  enum ieee80211_hw_flags {
>  	IEEE80211_HW_RX_INCLUDES_FCS			=3D 1<<1,
> @@ -879,6 +882,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_SPECTRUM_MGMT			=3D 1<<9,
>  	IEEE80211_HW_AMPDU_AGGREGATION			=3D 1<<10,
>  	IEEE80211_HW_NO_STACK_DYNAMIC_PS		=3D 1<<11,
> +	IEEE80211_HW_MFP_CAPABLE			=3D 1<<12,
>  };
> =20
>  /**
> --- wireless-testing.orig/net/mac80211/wext.c	2009-01-07 18:20:30.0000000=
00 +0200
> +++ wireless-testing/net/mac80211/wext.c	2009-01-07 18:22:38.000000000 +0=
200
> @@ -961,6 +961,10 @@ static int ieee80211_ioctl_siwauth(struc
>  			ret =3D -EOPNOTSUPP;
>  		break;
>  	case IW_AUTH_MFP:
> +		if (!(sdata->local->hw.flags & IEEE80211_HW_MFP_CAPABLE)) {
> +			ret =3D -EOPNOTSUPP;
> +			break;
> +		}
>  		if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION ||
>  		    sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC)
>  			sdata->u.sta.mfp =3D data->value;
>=20
>=20

--=-9P7UpBOMx2OfAQXY+qaL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZNpLAAoJEKVg1VMiehFYUWUQAJ8GGTTqTWBpFEfSgXern4/O
CQc8eZaMdPnMUzEUHlOk7ywpkmijLKklQ/HtFSWB0oNvRIroAHgeDLzZYazSs6d/
VDC/Lrrlq+7mF8eiy+KeRv8jABK0k234QcbAaJElaOGGQlD7UjdSn58YCDkL41N/
SPjyMg7i4YUZVyufiARUAdJ3GWZh45LeY9EyoLMlwiF7wDVC5M0KmTT2XM+7laSe
h37Xr6qyIOzVdio6/RqUzhVeytRedCOgQuasx15gAYGXYEdGA8TZnugQ3vViQMo2
NiW3xn2q9527nrylUZbUwQN/sGbP2TjuXURDSMcC/YoPyuHriyQT59TMJqbOnbkQ
8YNtED8On2dWChT0wWcHeQ17h6rMm2a/MdAfYM5BeJdmlwjBRY26xcEuZrxScaii
kKkR9NMpVG6EpYWzgi7/CSwGGsMCnWckqiTBWp90uHxmCxHiSuoRrBXRQRNnsHpb
ebtY1aHC3HEjJNSuw3B+1wJQAXrfP0Ja4XWfT90LYidqXAyJ6oLNSjyyjQ508VQ2
UEVNrxNVcqIZkqbbxTQe2nKFHPnwQOEaH8rI9UnP9yYdupFdHd4VU2vB3OG7IixR
1rN3+NymnrhgN9h4IJrsTSqKKKnYZ2+rePJ7Vcw3VucpbjzsQH4j6AeuNdmNhYdY
9Im5iHhmiobhSfYay343
=wbj/
-----END PGP SIGNATURE-----

--=-9P7UpBOMx2OfAQXY+qaL--

