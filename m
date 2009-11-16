Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZKPKWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 05:22:16 -0500
Subject: Re: [PATCH] rndis_wlan: handle NL80211_AUTHTYPE_AUTOMATIC
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20091116095653.17419.49151.stgit@fate.lan>
References: <20091116095653.17419.49151.stgit@fate.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zxcV5ORAxcVaZHbWCBR7"
Date: Mon, 16 Nov 2009 11:22:04 +0100
Message-ID: <1258366924.32159.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zxcV5ORAxcVaZHbWCBR7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-16 at 11:56 +0200, Jussi Kivilinna wrote:
> rndis_wlan didn't know about NL80211_AUTHTYPE_AUTOMATIC and simple
> setup with 'iwconfig wlan essid no-encrypt' would fail (ENOSUPP).
>=20
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> ---
>=20
>  drivers/net/wireless/rndis_wlan.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rnd=
is_wlan.c
> index 54175b6..dfc61fd 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -1070,7 +1070,8 @@ static int set_auth_mode(struct usbnet *usbdev, u32=
 wpa_version,
>  			auth_mode =3D NDIS_80211_AUTH_WPA_NONE;
>  	} else if (auth_type =3D=3D NL80211_AUTHTYPE_SHARED_KEY)
>  		auth_mode =3D NDIS_80211_AUTH_SHARED;
> -	else if (auth_type =3D=3D NL80211_AUTHTYPE_OPEN_SYSTEM)
> +	else if (auth_type =3D=3D NL80211_AUTHTYPE_OPEN_SYSTEM ||
> +			auth_type =3D=3D NL80211_AUTHTYPE_AUTOMATIC)
>  		auth_mode =3D NDIS_80211_AUTH_OPEN;

Will that try open and shared though?

johannes

--=-zxcV5ORAxcVaZHbWCBR7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLASfIAAoJEODzc/N7+QmaXwEP/Rhp2gw5pNPflP4fN8JOGcHc
E6BIv2TUx1I9fbpd65JxRSFtyk7SCM5sEnZ0kamtl/OjfULd1SP5Q9N6iZpLRBT4
Z3O2htdjzED9PRhz1xqsRvSPQ7oC1zcMQP64dnyG/a/MLJmmOCbs9dXRM/NcRhOH
f1X52G5BT/iVp7HE/7INgZ/01Cqgrg9yeEr/eDhOimWX2ML0pmQenX3sz6Svc9W2
yzE3UUOK9zpr5K2njOHvBIP1fJ1VhdTc+AovtlDVSCIFWJnD1foUh9J/6domicRh
FeuPgl/QbXxPXslLbmTpehMqJG1hZ0//y9Ok9Vg5UY9NEOBvU+GKlXil1oMYYJ92
N2sBy2e5ItXROxUsaQggOYW8xR1b2wQYmYr2ppNbXSfDiXTxQ9W4f4yzp9JpdKKd
iMvVAyHc9E4Eb2zVMKPBmkoiW7q2FxrWukra8zQ8t1/sYq/hmgc+sDbFVtOwh8/t
jiEUtHlI/WQA2JmUJjlNWqChaaKitDbuDoR9DeQw8oTETUaPrrJX0HNk74e/2XnD
iab7zsWHicrWbNTM0mfltirZn+qkJFSHEJd0r3GxY2+rx6cJZICIHoyPZNXmx3qK
jiXdZadMoONl5jBZ/FKw5toESHoRFkAiWpGZECLfe1MYrP1Zf5/r0xzKsWys/40C
b2qZ7IMMkiockIv0r5rx
=Wppc
-----END PGP SIGNATURE-----

--=-zxcV5ORAxcVaZHbWCBR7--

