Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59395 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750760AbdH0Fiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Aug 2017 01:38:52 -0400
Subject: Re: atheros ath9k_htc - EP4 Issue / BOGUS urb xfer, pipe 1 != type 3
To: M D <dsmm4444@gmail.com>, linux-wireless@vger.kernel.org
References: <CACUY3erTyW17nwJevW+21wsQdvGcWsZR0X6zzocNbTeejb9-aA@mail.gmail.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <dcaa5816-bbcb-a0f4-3be2-5578656cae9a@rempel-privat.de> (sfid-20170827_073856_795144_35032AC3)
Date: Sun, 27 Aug 2017 07:38:49 +0200
MIME-Version: 1.0
In-Reply-To: <CACUY3erTyW17nwJevW+21wsQdvGcWsZR0X6zzocNbTeejb9-aA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aUPrb6akVbpq1wedIVUj6ndl4SO7Jords"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aUPrb6akVbpq1wedIVUj6ndl4SO7Jords
Content-Type: multipart/mixed; boundary="5OcrukADceNUQmwp94EbV43o2j8MpS8Kr";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: M D <dsmm4444@gmail.com>, linux-wireless@vger.kernel.org
Message-ID: <dcaa5816-bbcb-a0f4-3be2-5578656cae9a@rempel-privat.de>
Subject: Re: atheros ath9k_htc - EP4 Issue / BOGUS urb xfer, pipe 1 != type 3
References: <CACUY3erTyW17nwJevW+21wsQdvGcWsZR0X6zzocNbTeejb9-aA@mail.gmail.com>
In-Reply-To: <CACUY3erTyW17nwJevW+21wsQdvGcWsZR0X6zzocNbTeejb9-aA@mail.gmail.com>

--5OcrukADceNUQmwp94EbV43o2j8MpS8Kr
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Am 27.08.2017 um 01:31 schrieb M D:
> Hi,
> I am using the TPLink TL721N on an ARM MX21 platform, Linux Kernel 3.0

are there any reason to use such old kernel?

> I am facing the following issue when the adapter is connected directly
> to the USB Hub.
>=20
> 1) ifconfig -a does not show the wlan node
> 2) the adapter is detected on the USB bus
> 3) The ath9k_htc modules are loaded
>=20

=2E..

> AFTER A REBOOT
> Once the above issue occurs, a software reboot renders the adapter not
> to be enumerated/detected on the USB. That is a lsusb does not display
> the model/serial of the adapter.

If repluging help you. You can try to implement USB link reinit after FW
was uploaded. Theoretically it is a proper way to init FW.

I can imagine following scenario:
- USB adabter is starting internal bootloader and inialize some USB Caps
- FW is uploaded with different USB Cups which a re expected by host driv=
er.
- USB Host Controller has idea about changes because USB link should be
reinited to populate them.

To implement this FW should be patched to reset usb line after start and
driver should recognize some how a reseted FW (different USB id or what
ever)
However as I tried to implement it, the result was not the same on
different hosts. In some cases host turned the power off on device reset
and FW was lost, so driver tried to upload it again. May be I did some
thing wrong.


> dmesg log:
> usb 1-2: device descriptor read/64, error -110
> usb 1-2: device descriptor read/64, error -110
> usb 1-2: new full speed USB device number 5 using imx21-hcd
> usb 1-2: device descriptor read/64, error -110
> usb 1-2: device descriptor read/64, error -110
> hub 1-0:1.0: unable to enumerate USB device on port 2
>=20
>=20
> I referred to the instructions as mentioned here and ensured that
> https://github.com/qca/open-ath9k-htc-firmware/wiki/usb-related-issues#=
bogus-urb-xfer-pipe-1--type-3
>=20
> 1) the driver has the patch
> 2) the firmware being used is 1.4
>=20
> However the device is being configured in Full Speed mode.
> usb 1-2: new full speed USB device number 2 using imx21-hcd

May be you will need just backport imx21-hcd patches too ;)

> Could someone offer some suggestions if there are some workarounds in
> the software? Is there anything more that I can try out or any areas I
> can investigate to try and fix this issue? I am presently reading
> through the device driver to see if I can fix it there, but am not
> making much progress.

--=20
Regards,
Oleksij


--5OcrukADceNUQmwp94EbV43o2j8MpS8Kr--

--aUPrb6akVbpq1wedIVUj6ndl4SO7Jords
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlmiWukACgkQHwImuRkmbWnKAAD9FAdaUnOYD+wp/p/mK7mXvgT2
/Hk4pjPT1prErhKb7fsBAIU/zL35qHqxr2FJ8Ummi3F276rVc1WczRREZKFdxAis
=CeX5
-----END PGP SIGNATURE-----

--aUPrb6akVbpq1wedIVUj6ndl4SO7Jords--
