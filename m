Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35647 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYDTQDL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 12:03:11 -0400
Message-ID: <480B692A.5010703@hauke-m.de> (sfid-20080420_170314_944558_4E900D2E)
Date: Sun, 20 Apr 2008 18:02:50 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: lrodriguez@atheros.com
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: compat-wireless-2008-04-20 doesn't build on kernel 2.6.23
References: <480B6117.3000201@hauke-m.de>
In-Reply-To: <480B6117.3000201@hauke-m.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0E33AF3129FE897F38133B75"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0E33AF3129FE897F38133B75
Content-Type: multipart/mixed;
 boundary="------------020101030304050505070200"

This is a multi-part message in MIME format.
--------------020101030304050505070200
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The attached patch solves the first problem in ath5k.

--
Hauke


Hauke Mehrtens schrieb:
> I have tested to build compat-wireless-2008-04-20 on kernel 2.6.23 but
> it doesn't build. I got the following error:
>=20
>   CC [M]  compat-wireless-2008-04-20/drivers/net/wireless/ath5k/hw.o
> compat-wireless-2008-04-20/drivers/net/wireless/ath5k/hw.c: In function=

> 'ath5k_hw_attach':
> compat-wireless-2008-04-20/drivers/net/wireless/ath5k/hw.c:346: error:
> 'struct pci_dev' has no member named 'is_pcie'
> make[4]: *** compat-wireless-2008-04-20/drivers/net/wireless/ath5k/hw.o=
]
> Error 1
> make[3]: *** compat-wireless-2008-04-20/drivers/net/wireless/ath5k] Err=
or 2
> make[2]: *** compat-wireless-2008-04-20/drivers/net/wireless] Error 2
> make[1]: ***
> [_module_/home/hmehr/compat-wireless/compat-wireless-2008-04-20] Error =
2
> make[1]: Leaving directory `/usr/src/kernels/2.6.23.15-80.fc7-x86_64'

--------------020101030304050505070200
Content-Type: text/x-diff;
 name="compat-wireless-2.6.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="compat-wireless-2.6.diff"

diff --git a/compat/compat.diff b/compat/compat.diff
index 38f5191..48701f1 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -349,6 +349,18 @@
  };
 --- a/drivers/net/wireless/ath5k/hw.c	2008-03-14 10:32:35.000000000 -040=
0
 +++ b/drivers/net/wireless/ath5k/hw.c	2008-03-14 10:32:36.000000000 -040=
0
+@@ -343,7 +343,11 @@
+ 	 * I guess these point to ClockReq but
+ 	 * i'm not sure.)
+ 	 */
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
++	if ((ah->ah_version =3D=3D AR5K_AR5212) && (compat_is_pcie(pdev)) {
++#else
+ 	if ((ah->ah_version =3D=3D AR5K_AR5212) && (pdev->is_pcie)) {
++#endif
+ 		ath5k_hw_reg_write(ah, 0x9248fc00, 0x4080);
+ 		ath5k_hw_reg_write(ah, 0x24924924, 0x4080);
+ 		ath5k_hw_reg_write(ah, 0x28000039, 0x4080);
 @@ -385,7 +385,11 @@
  	/* reseting PCI on PCI-E cards results card to hang
  	 * and always return 0xffff... so we ingore that flag

--------------020101030304050505070200--

--------------enig0E33AF3129FE897F38133B75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBSAtpNIZ0px9YPRMyAQKytQ/+IJ+MGAB21RBBR0sytPGzd5pNGEnrhppO
Yx1dWSPrBU2vPGyf+P78Am1Ns5N4LfWtND9GSEMHL7bdGbrLbl6rVEZS5XfwuqAl
kiFPrQRo+4WRKLUUjSWckTRpjpJELg2xRP2n2o9oiufEnhBx96wQV2e1hftVL2lE
oWQt7XnO8PQtyRNBEw6Lo6PlotM2pvFNRBI68uZtn9uG1YOStakp34ARKa5ZwY7L
Eo6EX5DJIpPnZS3Ab6xk884JTICWbn3Lir770y9/9IxOwJpH5cXXMtmAjEUGw9EH
aK8wgEJ7RekwxvUnIAof0GrcP+Z/AYLoD0aSKb3YWyEt/M+aKf1Kn8vD3cDnlCAz
9Kf1GlRx0GrHDUxo5aX9xu4STnRLhPZ1r7x4HvwJeLNw8qHWjjiv97g/rpbn8eLt
+y00M1LUhMWgg+EpiMg9u2C2MIox5R9MoV4iDIsHAjrCb0EoInf4iti5wEkEgIVK
mWEul6AQi7uN0uCPits7XG1/4YC5FEJPSfXDrFMf32/gxdFuhzDmmPyCUSOJv3w8
lxyW/GUWkG1DhvArXO47TPz78XwiEbYBBOfm2H/LuJgkBGuFBJ9Xy2Iipjnb2zNo
3zcDpm8y7mgovkruVGcwtEbCVDNFjLCVDBkABxJKFeEa9xHsDqRyqwOZOJo0X6g8
2eEommxxG1Y=
=e24U
-----END PGP SIGNATURE-----

--------------enig0E33AF3129FE897F38133B75--
