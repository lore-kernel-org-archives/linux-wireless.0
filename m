Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZIWHBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 03:01:30 -0400
Subject: Re: Comparison of wpa_supplicant with -Dnl80211 and -Dwext, WEP
 and WPA
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
In-Reply-To: <200909221258.44921.hs4233@mail.mn-solutions.de>
References: <200909221118.04569.hs4233@mail.mn-solutions.de>
	 <200909221258.44921.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7VSuPHq/N8pKQW4Zx3dI"
Date: Wed, 23 Sep 2009 09:01:31 +0200
Message-Id: <1253689291.4458.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7VSuPHq/N8pKQW4Zx3dI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-22 at 12:58 +0200, Holger Schurig wrote:

> >  0.00000  0.00000: Initializing interface ...
> >  0.08801  0.08801: Setting scan request: 0 sec 100000 usec
> >  0.25167  0.16365: ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
>=20
> This is because wpa_supplicant very early - in
> wpa_driver_wext_finish_drv_init() - calls
> wpa_driver_wext_disconnect(). This in turn sets a random 32
> character long ESSID, as a desparate means to disconnect.
>=20
> Now that an essid is set, the calling chain in the kernel
>=20
>    cfg80211_netdev_notifier_call(), case NETDEV_UP
>    cfg80211_mgd_wext_connect()
>    __cfg80211_connect()
>   cfg80211_conn_scan(
>=20
> get's executed. This starts a scan.
>=20
> Later, when wpa_supplicant tries to get a scan result, it will
> only get an -EBUSY because of net/wireless/scan.c, function
> cfg80211_wext_siwscan():
>=20
>         if (rdev->scan_req) {
>                 err =3D -EBUSY;
>                 goto out;
>         }
>=20
>=20
>=20
> However, I'm wondering: if several scan commands are
> supposed to add up into the BSS list anyway (and each BSS list
> entry by default pruned after 15 seconds), why is it an error
> to access the current state of the BSS list while a scan is
> in progress?

Because the scan request contains info on how to do the scan.

johannes

--=-7VSuPHq/N8pKQW4Zx3dI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKucfHAAoJEODzc/N7+QmalXEQAI+9pvN7US0YemTX04JhCbYr
FwkYCR0cv+ijQvGk5HRW7XWEwgBpK4LQ/y9dpyDc5fONC8FyJjmyChO5g1ybqRZ3
GDDe0DyU79D2Ttpq53uU4gmXlYJp4AEeE6+9zmTZsTZgVSoDi7iEo2hUIGx7CKTE
D5WuNmjoiUaaLC3AyFXIbvVm9at/BpV8BIUI2cRlrNfYRnocDVDHmW8ABRfv6cDY
n7OwuuNdrKg7betjeGBy9bpziN9uV3Phs3mgyghD8gWtwBQ4ZG+B5r1dK6PviKED
XLvoeOjR/xmtCm0NLfK/k/Iim4pNx/vyAzvLVhoyC2g589cTXWPjzf4XezoK65Lc
kM2d9x5kqN1byxhZtRjj0vvPUkU6pAv4ajiny4d0DlrehdRNVwFUM8+yeUTioft7
SszJksPgFicMDgoTG8xU5D+qz8NyPlzXCwjxj/oSvCe9UBHyK+KvxAf1fFZVOWrU
gcKVyvvD0VnvAyI6XOaDsA9fV/q9hbGuLaMWk0RQmWPU0j6LVi0CZ3W5l4u8dV4+
G5BzfBz2WfFb3zezl1RuIqDgbo91fSoTxhVeIs4XaPVN048eIZmJ0pDHESv6Tdcm
VbAeV+yTVOnK7TFZX2Nu6+dUZdPiaYxjonlURbThRdO0EESHR4V+l6PLzw+W+yWB
8uwvz7FL9VWo57UMv6D2
=2+nI
-----END PGP SIGNATURE-----

--=-7VSuPHq/N8pKQW4Zx3dI--

