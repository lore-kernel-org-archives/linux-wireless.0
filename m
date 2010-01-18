Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42293 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0ARUV1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 15:21:27 -0500
Message-ID: <4B54C2BE.6040502@hauke-m.de>
Date: Mon, 18 Jan 2010 21:21:18 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>, mcgrof@infradead.org
Subject: compat-wireless: firmware loading does not work (udev rule missing)
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig287111491F59A8F5557B8CD3"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig287111491F59A8F5557B8CD3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

with recent compat-wireless (today) firmware loading does not work any
more. With compat_firmware_class.c included it does not work, but after
removing it (with the stuff in comapt-XX.h) loading worked again.

This is because my Ubuntu uses only this udev rule for fimeware loading:

SUBSYSTEM=3D=3D"firmware", ACTION=3D=3D"add", RUN+=3D"firmware.sh"

This is only executed if the subsystem is named "firmware" and not if it
is named "compat_firmware". After adding an other rule, firmware loading
with compat_firmware_class.c worked again:

SUBSYSTEM=3D=3D"compat_firmware", ACTION=3D=3D"add", RUN+=3D"firmware.sh"=


The rule is located in /lib/udev/rules.d/50-firmware.rules on my Ubuntu
9.10 system. This was tested with kernel 2.6.31 and b43 driver.

Hauke


--------------enig287111491F59A8F5557B8CD3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJLVMK+AAoJEIZ0px9YPRMyrngP/RiwcZKdeCHHqHcRpAnvmOTi
W79PLXkL6DtE81lL7Dh1NY6Gp9q8jHrQEg+O6utmlOkGaVplf6KVS2ASPECv5oAS
PqjDQ88qhA9eWikifkq76xeNVuPj1RySJ2jXtSXkDQL2htFWAc3Ii9ozf7z9pOJI
PgtI5dTYvfayTwh2aBqHUwUM9EsJvg1g87NXu17fVNvEoJC47TpyWaUGoEoR1Zfn
Pvo0GLSBh2oXM5jFX6vjHeGFGUXbeyjcTHW54lghU2WRQe+rcZwlFIeJAgeW7kI4
iQnjJPILA6Zo4836l5b9GdINkA2m7DlpEgus02qeZMNxMkr3ijqWcY6YgPPItadq
6i3egUsfHR3fEaOwX5Ec3kZGC4PKuavzxL+XV1BVz9qD1GjtQjl+pR8Xmz1XjoJU
xJsl+QTkv1QsiEvYurMF6kFfwtG2ppSB377fSV2wI8mwfFpLa2B4bFbEkVhqdWkP
QqYwuqlvsKr1YwSYHaQRPlmu2+ECclZlDSZfm2iyHtTzC7Jg+NVrqrJ0nqNi9S1R
Uf0/leyElhpFn2nFPn6l4fldLcJNOimMcE+YhYMnjsPAIehlh+40iKYVHXBpO6BI
/Q0mOUrsvri8yYgLd/It8JC/L8JPzCv58hdlp7wV6H9o8qFdy2tMPFlKo1lzYng3
BBmBmUdUc5rCKAbs4Zz0
=29kX
-----END PGP SIGNATURE-----

--------------enig287111491F59A8F5557B8CD3--
