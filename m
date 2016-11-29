Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54235 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757555AbcK2PNY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 10:13:24 -0500
Subject: Re: [PATCH] ath9k_htc: don't use HZ for usb msg timeouts
To: Anthony Romano <anthony.romano@coreos.com>
References: <20161128042757.8609-1-anthony.romano@coreos.com>
 <a433d14f-d762-fc53-ba7a-da616ac670ca@gmx.net>
 <CAENtvd7sTN0HRkY4z+f8wozEk_AQDipX9nNV7r-Sbyzh4tt9pA@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <0a7eb9da-56e1-81fe-ea7c-f0e2eb4c9d00@rempel-privat.de> (sfid-20161129_161327_619296_38F05D94)
Date: Tue, 29 Nov 2016 16:12:55 +0100
MIME-Version: 1.0
In-Reply-To: <CAENtvd7sTN0HRkY4z+f8wozEk_AQDipX9nNV7r-Sbyzh4tt9pA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L6VBTU3H2Wf8BNI2wwvsunoGShrCtlr0N"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L6VBTU3H2Wf8BNI2wwvsunoGShrCtlr0N
Content-Type: multipart/mixed; boundary="In5s6upOjRfAWsh31fCancwlFUc8mTsiW";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Anthony Romano <anthony.romano@coreos.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Message-ID: <0a7eb9da-56e1-81fe-ea7c-f0e2eb4c9d00@rempel-privat.de>
Subject: Re: [PATCH] ath9k_htc: don't use HZ for usb msg timeouts
References: <20161128042757.8609-1-anthony.romano@coreos.com>
 <a433d14f-d762-fc53-ba7a-da616ac670ca@gmx.net>
 <CAENtvd7sTN0HRkY4z+f8wozEk_AQDipX9nNV7r-Sbyzh4tt9pA@mail.gmail.com>
In-Reply-To: <CAENtvd7sTN0HRkY4z+f8wozEk_AQDipX9nNV7r-Sbyzh4tt9pA@mail.gmail.com>

--In5s6upOjRfAWsh31fCancwlFUc8mTsiW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 29.11.2016 um 10:45 schrieb Anthony Romano:
> Hi Oleksij,
>=20
> I put 4 ar9271's on a 4 port hub into monitor mode for you and all
> interfaces are simultaneously collecting packets. My cheap USB power
> meter reads 4.37v@650mA between the hub and the host, so it's pushing
> the limit but appears stable.

Great work, thank you!

> On Mon, Nov 28, 2016 at 7:34 AM, Oleksij Rempel <fishor@gmx.net> wrote:=

>> Hi Anthony,
>>
>> Am 28.11.2016 um 05:27 schrieb Anthony Romano:
>>> The usb_*_msg() functions expect a timeout in msecs but are given HZ,=

>>> which is ticks per second. If HZ=3D100, firmware download often times=
 out
>>> when there is modest USB utilization and the device fails to initiali=
ze.
>>
>>> Replaces HZ in usb_*_msg timeouts with 1000 msec since HZ is one seco=
nd
>>> for timeouts in jiffies.
>>
>> wow..
>> This fix allow you use 4 adapter at same time?
>>> Signed-off-by: Anthony Romano <anthony.roman@coreos.com>

Acked-by: Oleksij Rempel <linux@rempel-privat.de>



--=20
Regards,
Oleksij


--In5s6upOjRfAWsh31fCancwlFUc8mTsiW--

--L6VBTU3H2Wf8BNI2wwvsunoGShrCtlr0N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlg9mvcACgkQHwImuRkmbWnaLgD/dHdU8/4bBzVpSOzZaeu4xYTx
u2t3cZGzqcXiwIqtk0wA/RkGVqsbWmlRsQPM3JK8Vm94/o1b/LE+0cK8+Ffn5zxL
=LbL9
-----END PGP SIGNATURE-----

--L6VBTU3H2Wf8BNI2wwvsunoGShrCtlr0N--
