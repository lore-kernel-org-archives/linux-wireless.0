Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58401 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab0BMQ7c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 11:59:32 -0500
Message-ID: <4B76DA63.1070304@hauke-m.de>
Date: Sat, 13 Feb 2010 17:59:15 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Olivier Singla <osingla@sdicorporation.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ar9170 : firmware not loaded
References: <4B74D511.3080508@sdicorporation.com>
In-Reply-To: <4B74D511.3080508@sdicorporation.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig16233FC210AFC3953DCC702B"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig16233FC210AFC3953DCC702B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Olivier Singla wrote:
> Hi,
>=20
> I am trying to use the ar9170 driver with the netgear wn111v2, on an
> arm9 platform.
> I compiled the modules, and the driver loads fine:
>=20
> Module                  Size  Used by
> ar9170usb              51188  1
> mac80211              170216  1 ar9170usb
> ath                     7304  1 ar9170usb
> cfg80211              120852  3 ar9170usb,mac80211,ath
> rfkill_backport        15524  1 cfg80211
> compat                  2336  2 mac80211,cfg80211
> compat_firmware_class     7072  2 ar9170usb
> pegasus                18052  0
> ohci_hcd               18428  0
> g_file_storage         21212  0
> at91_udc               12696  1 g_file_storage
>=20
> My issue is about the firmware, ar9170.fw. It is not found.
> I tried w/o luck 2 options:
> 1) loaded from user space under /lib/firmware
> 2) build the kernel 2.6.29 with ar9170.fw.
>=20
> With option (1), the only thing I see under /sys/class/firmware is the
> pseudo file timeout,
> no filename for 60" (like I think it should).
>=20
> Note that I have tried also an 802.11G adapter (iogear gwus23) with the=

> very same issue.
> But in this case, the 'old' kernel I am using for arm9 (2.6.29) has
> support for this 802.11g adapter,
> and when I build it with 2.6.29 (therefore not using compat-wireless), =
I
> have no issue regarding
> loading the firmware (from user-space).
>=20
> If anybody had any idea what I am doing wrong or missing, I would reall=
y
> appreciate it!
>=20
> Regards,
> Olivier
Hi,

compat-wireless does not use /sys/class/firmware but
/sys/class/compat_firmware for firmware loading, because we had to
backport the firmware loading part. In the udev directory is a udev rule
and a script for firmware loading.

Hauke


--------------enig16233FC210AFC3953DCC702B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJLdtpnAAoJEIZ0px9YPRMyDYYP/0BG8t4AMIGZNfrolqMujFFa
3HjUmCaZSYVUHlocju1+ldXJOb13KvzKwQEyALNKPRi81+gOWeB5FFJJRIDmYYIH
AcMjje8ynb2K2R5c9giz6BnXbhim43hPjCYjPPwexqXWj8CBMKdwvyh3pwJyrQgQ
yR490tgqpqcMu37/I2IFRrTC1VEphfCJxPS5aZjldFdo8Qy0yIk6EA6EAeKIddf+
iNZZaBypiMdT8cbNJMzeteAhHnJXyyeA3sM1t5lNwgqZ7y4xVQO0YILKSUxITgIO
pSrKkgahoMJ6f7qnBj2/sEsCUCeH9wOkdxYvXlI+jHsJOoS7/5I4sPmO5tkR5/Ir
vDk2FBFE4wmbXca56e7cYZezQhTj6KtU3wBShRKPw+48Pgqn718vjKH+A1WTCS17
KJZMVubpByyxzoHrTyej9dgzPEOuSZ+k3DY9bfS2BusQ2yCaszlO9bzaVtYVLb5C
QT/uLUpExuncOBvKr2Imv3TO8IUa0WkkrLWSG/51XTgAEH1PzsNX84N59BADu4Yc
g4wXQd6+AvjYmX9GqqqdT/vTAdMm5ON4SR4+YIMFu4x1cb7BE3eBqMQdABvo0TTM
UbEm6CE6WxNuUZnYJ/Rtjktn2tVrL+w7Gz4Hn1bHrZGrkP2m7RCjfpxtOr55Q0iC
8AmNSTezEkyBmpPluUj0
=F/IN
-----END PGP SIGNATURE-----

--------------enig16233FC210AFC3953DCC702B--
