Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60817 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaL0IWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 03:22:11 -0500
Message-ID: <549E6C1A.7010805@rempel-privat.de> (sfid-20141227_092215_125578_A2A15CB6)
Date: Sat, 27 Dec 2014 09:21:46 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Jeremy Audet <ichimonji10@gmail.com>
CC: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Subject: Re: bug report for ath9k_htc driver
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>	<54991B32.2010105@rempel-privat.de>	<CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>	<5499A391.2060705@rempel-privat.de> <CA+A7n+iHKBxy3qfjzrnN7GdZhJ-WwoDdi6hjw8RSaDs8TBznvw@mail.gmail.com>
In-Reply-To: <CA+A7n+iHKBxy3qfjzrnN7GdZhJ-WwoDdi6hjw8RSaDs8TBznvw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vOc5dloa2tV6iokpMcxc6wh15alcL3jxd"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vOc5dloa2tV6iokpMcxc6wh15alcL3jxd
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I found this note with similar kernel log like yours:
http://www.linuxforums.org/forum/hardware-peripherals/195227-tl-wn722n-ba=
cktrack-5-a.html

Can you please test this workaround?

Am 27.12.2014 um 05:05 schrieb Jeremy Audet:
> Sending this again b/c of a delivery error. [9] Sorry for the possible =
spam.
>=20
> Hi again,
>=20
> When last I wrote, I stated that the issue lay with the USB cradle I'd =
been
> using, and I'd discarded it in favor of plugging the TL-WN722N directly=
 in to
> my PC. I also mentioned that I'd gotten a wireless access point up and =
running
> for 30 minutes. Not five minutes after I sent that email, the same erro=
r I've
> described earlier occurred, and the USB wireless adapter was demoted to=

> full-speed mode.
>=20
> This is bothersome, so in an effort to rule out sources of error, I ran=
 a series
> of simple tests, all having this structure:
>=20
> 1. Start logging out kernel messages with the `journalctl -k --follow -=
n 0`
>    command.
> 2. Plug a TP-LINK TL-WN722N wireless adapter directly in to a USB port.=

> 3. Turn on the adapter with the `ip link set dev $device up` command.
> 4. Wait for an error.
> 5. Stop collecting logging output. (Send CTRL-C to `journalctl`.)
> 6. Unplug TL-WN722N.
>=20
> Here's the purpose of the above:
>=20
> * It is possible that a specific USB port or ports on my motherboard ar=
e flaky.
>   To help rule this out, run the test with three different USB ports on=
 my
>   motherboard. Two of the ports are built directly in to the back panel=
 of the
>   motherboard, and the third connects to header pins on the motherboard=
=2E
> * It is possible that the specific TL-WN722N I am using is flaky. To he=
lp rule
>   this out, run the test with a second TL-WN722N. [1, 2]
>=20
> Notably, I am also using the `htc_9271.fw` firmware file available at
> https://github.com/olerem/ath9k-htc-firmware-blob for this test. As a r=
efresher,
> here's some other info about my system:
>=20
>     $ uname -a
>     Linux pine 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC
> 2014 x86_64 GNU/Linux
>     $ ip -V
>     ip utility, iproute2-ss141009
>=20
> And here's some output from `lsusb -v` for the old and new TL-WN722N de=
vices:
>=20
> * old: http://www.ichimonji10.name/downloads/tl-wn722n-old-lsusb.txt
> * new: http://www.ichimonji10.name/downloads/tl-wn722n-lsusb.txt
>=20
> Here's the test results. Port 1, 2, and 3 are the upper back panel, low=
er back
> panel and header pins on the motherboard, respectively.
>=20
> * Port 1, old adapter: fail [3]
> * Port 1, new adapter: fail [4]
> * Port 2, old adapter: fail [5]
> * Port 2, new adapter: fail [6]
> * Port 3, old adapter: fail [7]
> * Port 3, new adapter: fail [8]
>=20
> [1] I bought a TL-WN722N several years ago, eventually stuck it in the =
bottom of
>     my tool kit and forgot about it until just now. I bought the two TL=
-WN722Ns
>     several years apart, so it is unlikely that the two adapters both s=
uffer
>     from e.g. a manufacturing defect. They were bought on 2014-11-10 an=
d
>     2012-09-25.
> [2] lsusb -v: http://www.ichimonji10.name/downloads/tl-wn722n-old-lsusb=
=2Etxt
> [3] http://www.ichimonji10.name/downloads/2014-12-26-p1-old.txt
> [4] http://www.ichimonji10.name/downloads/2014-12-26-p1-new.txt
> [5] http://www.ichimonji10.name/downloads/2014-12-26-p2-old.txt
> [6] http://www.ichimonji10.name/downloads/2014-12-26-p2-new.txt
> [7] http://www.ichimonji10.name/downloads/2014-12-26-p3-old.txt
> [8] http://www.ichimonji10.name/downloads/2014-12-26-p3-new.txt
> [9] Technical details of permanent failure:
> Google tried to deliver your message, but it was rejected by the
> server for the recipient domain vger.kernel.org by vger.kernel.org.
> [...] The error that the other server returned was: 550 5.7.1
> Content-Policy reject msg: The message contains HTML subpart,
> therefore we consider it SPAM or Outlook Virus.  TEXT/PLAIN is
> accepted.
>=20


--=20
Regards,
Oleksij


--vOc5dloa2tV6iokpMcxc6wh15alcL3jxd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlSebCIACgkQHwImuRkmbWmepgEAlAQntojAntztQ4PN+BKaWIPH
VpkiSnQYm1zv7j/1u5MBAINoJkVSMMmGOQdZdsbU1By3cVxvG3+WxcSta2R4dJ9m
=X1nx
-----END PGP SIGNATURE-----

--vOc5dloa2tV6iokpMcxc6wh15alcL3jxd--
