Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZINRor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 13:44:47 -0400
Subject: Re: [PATCH] cfg80211: don't report SME connection errs at
 SIOCSIW{FREQ/AP/ESSID}
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200909141323.44245.hs4233@mail.mn-solutions.de>
References: <200909141254.14988.hs4233@mail.mn-solutions.de>
	 <200909141323.44245.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xPTt5VINoC/UjxTYboIB"
Date: Mon, 14 Sep 2009 10:43:54 -0700
Message-Id: <1252950234.23427.51.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xPTt5VINoC/UjxTYboIB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-14 at 13:23 +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>=20
> ---
>=20
> This fixes
>=20
> 1252921276.182218: Trying to associate with 00:1b:53:11:dc:40 (SSID=3D'TE=
ST' freq=3D2412 MHz)
> ioctl[SIOCSIWFREQ]: No such file or directory
> ioctl[SIOCSIWESSID]: No such file or directory
> 1252921276.268451: Association request to the driver failed
> 1252921276.355482: Associated with 00:1b:53:11:dc:40
>=20
> and makes it
>=20
> 1252921276.182218: Trying to associate with 00:1b:53:11:dc:40 (SSID=3D'TE=
ST' freq=3D2412 MHz)
> 1252921276.355482: Associated with 00:1b:53:11:dc:40
>=20
> However, otherwise this hasn't been greatly tested and I
> don't have a great understanding of cfg80211, SME, etc ...

And doesn't look correct to me at all. probably something missing wrt.
disconnect() while connecting.

johannes

> Index: linux-wl/net/wireless/wext-sme.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-wl.orig/net/wireless/wext-sme.c	2009-09-14 12:05:54.000000000 +=
0200
> +++ linux-wl/net/wireless/wext-sme.c	2009-09-14 12:06:09.000000000 +0200
> @@ -110,7 +110,7 @@ int cfg80211_mgd_wext_siwfreq(struct net
>  		goto out;
>  	}
> =20
> -	err =3D cfg80211_mgd_wext_connect(rdev, wdev);
> +	cfg80211_mgd_wext_connect(rdev, wdev);
>   out:
>  	wdev_unlock(wdev);
>  	mutex_unlock(&rdev->devlist_mtx);
> @@ -196,7 +196,7 @@ int cfg80211_mgd_wext_siwessid(struct ne
> =20
>  	wdev->wext.connect.crypto.control_port =3D false;
> =20
> -	err =3D cfg80211_mgd_wext_connect(rdev, wdev);
> +	cfg80211_mgd_wext_connect(rdev, wdev);
>   out:
>  	wdev_unlock(wdev);
>  	mutex_unlock(&rdev->devlist_mtx);
> @@ -283,7 +283,7 @@ int cfg80211_mgd_wext_siwap(struct net_d
>  	} else
>  		wdev->wext.connect.bssid =3D NULL;
> =20
> -	err =3D cfg80211_mgd_wext_connect(rdev, wdev);
> +	cfg80211_mgd_wext_connect(rdev, wdev);
>   out:
>  	wdev_unlock(wdev);
>  	mutex_unlock(&rdev->devlist_mtx);
>=20


--=-xPTt5VINoC/UjxTYboIB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKroDXAAoJEODzc/N7+QmaHCwP/09QGyM9v8qxwTKhWnrB47bG
BiOcm5jzGd8aOdYbwN1wB408a9/ar+L5wcbh4B2W+dOH3vQ+IDWELATa7tSpp4n2
EZt5nzL7I6Z8sZR9GGZNu2GPnlC881QxdbR1mgDuvxwh8C5+VkY7s/behvClvafq
ejR+k/OJltIX3wDIQTPwDkcLkY2MMO8y+CvXCweyGbHSHL3sXmbBgviD0nUJGJ+k
9yx3MOw39c5YVBPie/HyZYfDbRdje/8AXd2kLlJVutaN/spqQjDHOaW5AYz0Jalf
5BopXr1mqhps8PQzy3zHuMfdKmdMqylgjHCDKzQ4/TY5dMpkh01ksYlksd2nc2yj
4T5W0T/rbyYEvbTIWQViA2/6k5AzxRevj2vEdeQsraH42mZWEMqgD7pFuUs+exgL
Z3kYT/uBSmaQ1MR/0zkDsvx45VmCvRY7PoNt2j3JbmTH7bHtfWCPBqa0evtmOjbc
Yscn0PYFXjvHcuNiPZ53AGaHjQA5x2BCq3Xe2BJqQrF9WGSfcTFXRguLT7KUuS7d
1OHMc822/Vyp+0EEoEuMfdSTEyWRvQRvSWCr2U4BmEZF9NlH7CpPWBovHeVY344z
3bBD/5iNXSj3Hj4s/aPJRi70AMcF2IEyESDgUlppDwfOe4Wpj/piIERhS3AFEb6w
gAzOOLZhcL0HP/bNsYla
=jv7F
-----END PGP SIGNATURE-----

--=-xPTt5VINoC/UjxTYboIB--

