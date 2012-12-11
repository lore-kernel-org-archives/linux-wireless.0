Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:22534 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab2LKKK1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 05:10:27 -0500
Date: Tue, 11 Dec 2012 12:03:39 +0200
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: <users@rt2x00.serialmonkey.com>, <juhosg@openwrt.org>,
	<sgruszka@redhat.com>, <helmut.schaa@googlemail.com>,
	<gwingerde@gmail.com>, <john@phrozen.org>
Subject: [PATCH 0/3] introduce rt2x00_platform
Message-ID: <20121211100336.GA7807@earthship.arig> (sfid-20121211_111030_101309_3939BCC5)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On embedded systems built-in or PCIe connected WiFi modules usually lack th=
eir
own EEPROM and use a mtd partition instead of that. In OpenWrt, this is sol=
ved
by requesting a firmware and the handling the resulting hotplug call in
userspace which will then extract the needed file from mtd and supply it to
the driver.
In other cases, PCIe modules might come with an actual EEPROM, but yet some
board-specific hacks are required, such as disabling bands or overriding the
modules MAC address with a board-supplied one.

The original author of those patches is Gabor Juhos.
According to his remarks, 3 patches related to overriding the whole eeprom =
and
introducing rt2x00_platform.h were merged into a single patch.

Daniel Golle (3):
  rt2x00: allow overriding eeprom through platform_data
  rt2x00: allow disabling bands through platform_data
  rt2x00: add platform_data mac address

 drivers/net/wireless/rt2x00/Kconfig        |  4 ++
 drivers/net/wireless/rt2x00/Makefile       |  1 +
 drivers/net/wireless/rt2x00/rt2800pci.c    | 34 ++++++-----
 drivers/net/wireless/rt2x00/rt2x00.h       | 10 +++
 drivers/net/wireless/rt2x00/rt2x00dev.c    | 37 +++++++++++
 drivers/net/wireless/rt2x00/rt2x00eeprom.c | 98 ++++++++++++++++++++++++++=
++++
 drivers/net/wireless/rt2x00/rt2x00lib.h    | 16 +++++
 drivers/net/wireless/rt2x00/rt2x00pci.c    |  7 +++
 drivers/net/wireless/rt2x00/rt2x00soc.c    |  1 +
 drivers/net/wireless/rt2x00/rt61pci.c      |  5 ++
 include/linux/rt2x00_platform.h            | 23 +++++++
 11 files changed, 222 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00eeprom.c
 create mode 100644 include/linux/rt2x00_platform.h

--=20
1.8.0.1


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxwT4AAoJEDy9cKN/1Et05wQP/jmuU1oUnZbX1pX0Flrd8zax
CNC5zTpi6HAzIRBzUfa/YUscg7qVsdOJvZ9mcY8y9IzGNa0pjusF3VpdexJ+D9SI
ImzpUKy0S8isXYeSgKKMNOnMoYmlXbQLOgap5koiGojd0OEZsM/yn39GOlw6dPNb
ms8IAMZdtZqs/zXw10vSP0hwxTbLXiFWfxMOeE9zoo00aM/+X1PuAcwkVGTsAIlh
2cle9euCzEW0zyEGHtSDEnsofbwY1vbhrJFrg93ZLeEhFYTxH9cGwIp7ZJTxKxWR
AoOKxvBTPxgDiimho4GdXP5DaWOVghQg1C8+hV3gKI26ciObysXE+v8M/cSuNUov
cUM/vm61/i4p7UPYFxfN6CG5DU5rejRV1z+me6Ucpbjigl7WhttV1azP+5EGpeod
MGALmW8eRBipjDozTW4B++qBvi7hBTF1Y1Q9heaPI/R6rzqb+uovcj0+KyaTpKbo
XK86KiY25jF/4JUmIOt4vMybb1NPTM5Ebpv9fcQYcpw2lTIDx40MNuvafNZJImqB
FkM5eUWItSA+bDQjMk5exNm+Oeu1FAOrf8vbJTfZd8z8orrwtnBshI/3t43HKKqC
Uf1wclK2xIavKmhbyNfrPIaCL/MjBppTZUyFvI9cWrCeNCNrVH5VyIUZOBEkWin3
Q/gbUggb8VhsXhgIYdGP
=Mis+
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
