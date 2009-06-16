Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59852 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbZFPSj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:39:58 -0400
Message-ID: <4A37E6F1.4080003@hauke-m.de>
Date: Tue, 16 Jun 2009 20:39:45 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Warp speed building
References: <4A30CE70.4050605@web.de> <200906112305.33675.mb@bu3sch.de> 	<43e72e890906111410n3766ceb7t4b4efda05730c693@mail.gmail.com> 	<200906112314.29464.mb@bu3sch.de> <69e28c910906111439o798b3298p63bd44e88358ea8a@mail.gmail.com> <43e72e890906111443h5758b74dk6f788b327b1cfe4c@mail.gmail.com> <4A3368F9.6060509@web.de>
In-Reply-To: <4A3368F9.6060509@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3F2ECBD8DEEA777D4CAD2771"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3F2ECBD8DEEA777D4CAD2771
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Jan Kiszka wrote:
> Including config.mk again when kbuild called into the top level Makefil=
e
> slowed down the build process awfully. The reason for this were all the=

> dynamic, shell-based variable evaluations that were called over and ove=
r
> again. Fortunately, including config.mk only in the outer Makefile run
> appears to be enough. So let's remove this warp speed blocker.
>=20
> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
> ---
>  Makefile |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index 0ab7d27..49a786a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -13,8 +13,6 @@ OLD_IWL=3D$(shell $(MODPROBE) -l iwl4965)
> =20
>  ifneq ($(KERNELRELEASE),)
> =20
> -include $(M)/$(COMPAT_CONFIG)
> -
>  NOSTDINC_FLAGS :=3D -I$(M)/include/ -include $(M)/include/net/compat.h=
 $(CFLAGS)
> =20
>  obj-y :=3D net/wireless/ net/mac80211/ net/rfkill/

Hi Jan,

I have tested this patch and it reduced the build time for me from 3:30
to 2:40 minutes on a dual core system. I can not see any changes, expect
the reduced build time on my system. The resulting modules are still the
same.

Hauke


--------------enig3F2ECBD8DEEA777D4CAD2771
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJKN+b1AAoJEIZ0px9YPRMypIEP+wVNguVEookLr+bM2IYCJs+o
0rikhpL4r2H8TsCWjg5tJ30k4tsC9opRaxomMHMLms/pJ3SZ3X/gUOSv1x/WFNrV
eQIw/70xIe8K3uDnWaSw3nR4oSpHqauZyMNIhNOsrOqNjqU3BTAkRhrliP+T8hz9
Qh724HS+TNTogscu//1IwIpmsNOw7iPYdKfblYu2kT61/et0/7M384wjr+dld+bW
hTJtJSvVu+jKAURU+HqRuJ5RxpMWeHWS636ZtLHG1Jw5Su+zGZep9h91mL65BrQV
DVOaK8Js23JNPKz7r4HT73mnyVQTWOzwZfGSKzeSxIG2nQYS7lCk7KvkXan2nkcI
v/i0kJd2zTLw96Y3GLVRqDUrHayNpvQHYkyiGAkvg/vqCm8MRO0MmZ34I0d0/vW7
nWcUqZJGzBkpdThfZT/VbQ1/0RAQlvxDASWZKJGXz4xHEdBNLjQBPLjzVr5GzUuv
br5dkDScL/G7jBHi/IURW6G4y0TMehLuS5Y3ODo3uRBRiy5u944FCTdEWZj5+T5I
1PoSAmcyMqQ7KA3HcZIJa8kyHEfwTQOjJWGAJuEd9dsOA59nhdaPr8XCMRnz7VAz
q5vj6NLC2YjcEGIHX42z0J89CYxgDDUebzIJXfROd0rpQfccObJUmNo0chiEbEqC
jbkfmPkwnN+Wce6zkK9h
=+qK5
-----END PGP SIGNATURE-----

--------------enig3F2ECBD8DEEA777D4CAD2771--
