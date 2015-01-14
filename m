Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60365 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbbANQXj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 11:23:39 -0500
Message-ID: <54B69807.9030906@rempel-privat.de> (sfid-20150114_172346_808388_8AD55613)
Date: Wed, 14 Jan 2015 17:23:35 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Jeremy Audet <ichimonji10@gmail.com>
CC: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Subject: Re: bug report for ath9k_htc driver
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>	<54991B32.2010105@rempel-privat.de>	<CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>	<5499A391.2060705@rempel-privat.de>	<CA+A7n+iHKBxy3qfjzrnN7GdZhJ-WwoDdi6hjw8RSaDs8TBznvw@mail.gmail.com>	<549E6C1A.7010805@rempel-privat.de>	<CA+A7n+gP6h1HT5F7oDY-SDrrAAjbtTHAtY0683Fe7QdVb7byfQ@mail.gmail.com> <CA+A7n+jQQNWk2CqoS9QQFODRsi8k4asjWE=5_q681E6PTiQM+A@mail.gmail.com>
In-Reply-To: <CA+A7n+jQQNWk2CqoS9QQFODRsi8k4asjWE=5_q681E6PTiQM+A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JLjopwSHlOMnGrRfkbVCG1M0X6S2JPlU2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JLjopwSHlOMnGrRfkbVCG1M0X6S2JPlU2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 13.01.2015 um 23:46 schrieb Jeremy Audet:
> Grr. I'm sending this again. My first email was filtered by kernel
> mailing list due to the presence of HTML in the message.
>=20
> Hi again,
>=20
> The USB hub has arrived. [1] I ran through the same test procedure as l=
ast time:
>=20
> 1. Start collecting logging info with `journalctl -k --follow -n 0`.
> 2. Plug in the hub, if appropriate. Plug in the TL-WN722N.
> 3. Bring up the adapter with `ip link set dev $device up`.
> 4. Wait for an error.
>=20
> My test system has changed slightly since I last ran this test, so I
> made sure to run the test twice: once without a USB hub, and once with
> a USB hub. When I ran this test without the USB hub, the kernel
> immediately emitted gobs of messages and the TL-WN722N was immediately
> demoted to a full-speed device. I didn't even have a chance to bring
> up the device with `ip link set dev $device up`. [2] When I ran this
> test with a USB hub, the kernel did eventually emit gobs of messages,
> but lead-up to that failure did contain some new error messages.
>=20
> I mentioned that my test system has changed. In particular, I've added
> a new PCI wireless adapter to the system. [4] I've also installed some
> updates, but it is worth noting that the software listed in my
> original email has not changed:
>=20
>     $ uname -a
>     Linux pine 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC
> 2014 x86_64 GNU/Linux
>     $ ip -V
>     ip utility, iproute2-ss141009
>     $ netctl --version
>     netctl version 1.9
>=20
> =E2=80=94Jeremy 'Ichimonji10' Audet
>=20
> [1] http://i.imgur.com/TdlwxIC.jpg
> [2] http://www.ichimonji10.name/downloads/2015-01-13-p3-new-nohub.txt
> [3] http://www.ichimonji10.name/downloads/2015-01-13-p3-new-hub.txt
> [4] Output from lspci -v:
> 04:05.0 Network controller: Ralink corp. RT3060 Wireless 802.11n 1T/1R
>         Subsystem: Edimax Computer Co. Device 7711
>         Flags: bus master, slow devsel, latency 32, IRQ 20
>         Memory at fe900000 (32-bit, non-prefetchable) [size=3D64K]
>         Capabilities: <access denied>
>         Kernel driver in use: rt2800pci
>         Kernel modules: rt2800pci
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


Looks like with the hub it can work at least some hours. Correct?

Lets try to reduce interrupt traffic on usb by disabling led blinking
with this command:
sudo bash -c "echo none > /sys/class/leds/ath9k_htc-phy*/trigger"

--=20
Regards,
Oleksij


--JLjopwSHlOMnGrRfkbVCG1M0X6S2JPlU2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlS2mAcACgkQHwImuRkmbWkr2QEAlWPd1GRfIfoXHDrUuCHTzKJV
RfXBs973+z+/bEMtFqgA/Rl6TKQX5Xk68vN1tRmtR4hkRYuOQtzWTfK10uHRKxuS
=9+TU
-----END PGP SIGNATURE-----

--JLjopwSHlOMnGrRfkbVCG1M0X6S2JPlU2--
