Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41674 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbcDAE75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 00:59:57 -0400
Date: Fri, 1 Apr 2016 06:59:10 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160401065910.71e602b7@wiggum> (sfid-20160401_070001_539552_4D9A4E3D)
In-Reply-To: <20160331231346.GA7469@localhost>
References: <E1akxli-00030z-BC@bombadil.infradead.org>
 <20160331231346.GA7469@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mkdRJKaGSTy4HU1PedsCf12"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/mkdRJKaGSTy4HU1PedsCf12
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Apr 2016 00:13:46 +0100
Chris Bainbridge <chris.bainbridge@gmail.com> wrote:

> Should also fix https://bugzilla.kernel.org/show_bug.cgi?id=3D111781 ?
> Given that this is a serious bug that can corrupt filesystems it would
> be good to see the fix in stable too.

Wow, this is horrible.

This patch should help a bit. But it's probably hard to workaround that
DMA issue completely. There still is a chance of corruption, as soon as
the kernel allocates and uses some memory that the DMA controller still
uses from boot-up before the fixup is applied.

--=20
Michael

--Sig_/mkdRJKaGSTy4HU1PedsCf12
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW/gAeAAoJEPUyvh2QjYsODT4P/0UYnvp08cylQ8zT3gStd9ZN
CTWInlGKz5YFA5/2On1FX7u2yGdlZ6VtYISm7JP9CTWN+q5X78Fxg+jK3tjEzkJL
O9RJEiyKqJrbnj4NK7vEXDm2Qz0ogfuiFOOId4qWFTXgRs/exlAMxeRpQgNTwvZO
mh9JekQ3blBVV2f7oPkuDOAFZD20cZ3pLbFDr+UzciRmewI3RUqlQ0IoEn8Np+To
wG16xhUGtH3Yza35Mb3kRhJVKTDP6kOfNmQHX7qt5NJsmKiTFtLRh2xalxtGmbC3
QzSBcHA1gJDwvXT7CYbm7TcSGD/O0vG5CsUNiAJg5hLiKRjS4FsoTSHKeD6Qo5pQ
s/7dRxMGRrxN7gwqeyBxU7nZICp4CeRQkeL4TW6DL4/qgOr3n7zs2GQexw0sdmcD
erJq9mCBbSPlFZdvGqnmMe1v9dZtIp2UJ4xuuoNQsJxjf3AEU4d8gHeOsnQXjYYD
aRdqUWzaK5mVXfaDCgtS9/JIAqpu1iIm5f5heALTjoA05pv+j5XAyx90LgG6UlBY
YC6PlOk4fjZ7TKQl26pHhnTrwldYOBuVC1mQOoBdq3EFzD7gUj73CMONx7qBYtYl
g8jJmmOpvUW7/ahTL1caQ5J3HyTM2yP5J5C/sU4e2SSF1/4H2UHiTnkY9A7n+BmQ
YWdpT4zR5E/cnjyxQ6/3
=VZwy
-----END PGP SIGNATURE-----

--Sig_/mkdRJKaGSTy4HU1PedsCf12--
