Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZGCIBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 04:01:40 -0400
Subject: Re: [PATCH] cfg80211: check for current_bss from giwrate
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090703000044.GB4143@sortiz.org>
References: <20090701192641.072258140@sipsolutions.net>
	 <20090701193421.155074452@sipsolutions.net>
	 <20090703000044.GB4143@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7RgT68tYVsRAQVtKT05R"
Date: Fri, 03 Jul 2009 10:01:36 +0200
Message-Id: <1246608096.16770.52.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7RgT68tYVsRAQVtKT05R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-03 at 02:00 +0200, Samuel Ortiz wrote:
> When connecting to an ESSID manually, we may not set the BSSID, and thus
> wdev->wext.connect.bssid will be NULL.
> wdev->current_bss is always updated when a connection is established so w=
e
> should check it first.

Indeed, good catch

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> ---
>  net/wireless/wext-compat.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> Index: iwm-2.6/net/wireless/wext-compat.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- iwm-2.6.orig/net/wireless/wext-compat.c	2009-07-03 01:40:09.000000000=
 +0200
> +++ iwm-2.6/net/wireless/wext-compat.c	2009-07-03 01:40:18.000000000 +020=
0
> @@ -1137,8 +1137,11 @@ int cfg80211_wext_giwrate(struct net_dev
>  	if (!rdev->ops->get_station)
>  		return -EOPNOTSUPP;
> =20
> -	addr =3D wdev->wext.connect.bssid;
> -	if (!addr)
> +	if (wdev->current_bss)
> +		addr =3D wdev->current_bss->bssid;
> +	else if (wdev->wext.connect.bssid)
> +		addr =3D wdev->wext.connect.bssid;
> +	else
>  		return -ENOTSUPP;
> =20
>  	err =3D rdev->ops->get_station(&rdev->wiphy, dev, addr, &sinfo);

--=-7RgT68tYVsRAQVtKT05R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKTbrdAAoJEODzc/N7+QmaRt4QAIN1TdjfLuJLUwMgDUXXP0Lb
CfmaG7aH1Hff2FXwH3gKjykyftzgPMM7nx5I7Wa0kvmQCrlzFKjYys3SsbZo/78N
LoUELNXR6aVUIbyzuceiWtFmhu2xjcVDSGCK4qgbJdpY1mgEsO9VkdU8DNrucEBH
phmYCvdMmHNJ+Wsq8O58eB5hMEes3Gy6mgRgbwJl8D7I3NLAo17w1coofi+wHdCs
bS8Jm17yj73RsHvB7NaGehTPsQF1eVyDqZE1Z+dfMD5+qmi5VkMxKFfiF3fNtspI
e9u3L2gTBPej0Ae6NGXHk3xmoQ+Kjq9IJ8CHr2jzeBYj0tqiiynzZojLEFNxFA5t
X3KaNKxZfbGmaUehZoFdl4PDgXZ8gB+yBjvWXBEKtPBeOnlD9LdYVWXP/3McNsNm
UEBa7YdoglfKdobS+Q/MTRLgVVFL+NDKHAl2BBFl1nH1vpA5Y77RXtruzBbp702u
QXUdvk+eInST2Rr9TNtF2NYvDx1DiPvfPZsP5tLfm1myeVHFOM3SYM+zbWx5bbGt
/ORrdaux+F4dhPp911Gu6/BvVAwMp8JuK8YmSsF22JxLr0g+De09WNi38MzaXQho
CBE8PZVIw6Xasw5nxOy/9XRr1loYa0liX8NnEMTK5XBVC35KrB99jRaruisRY0Ek
/KJTPA+H/kfnIfewgOwr
=BHk6
-----END PGP SIGNATURE-----

--=-7RgT68tYVsRAQVtKT05R--

