Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61850 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbaLWHfW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:35:22 -0500
Message-ID: <54991B32.2010105@rempel-privat.de> (sfid-20141223_083527_212082_939A32CE)
Date: Tue, 23 Dec 2014 08:35:14 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Jeremy Audet <ichimonji10@gmail.com>,
	linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Subject: Re: bug report for ath9k_htc driver
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>
In-Reply-To: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1CVDHWRIejVRwpaeF1S3wgRxDpnCFAeGa"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1CVDHWRIejVRwpaeF1S3wgRxDpnCFAeGa
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

please try latest firmware,
https://github.com/olerem/ath9k-htc-firmware-blob


Am 23.12.2014 um 00:53 schrieb Jeremy Audet:
> ath9k_htc driver bug report
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>=20
> I'm writing in to report a bug (I think) with the ath9k_htc driver.
>=20
> I am using a TP-LINK TL-WN722N USB wireless adapter. According to the U=
SB
> drivers page [1], this device uses the ath9k_htc driver, and the ath9k_=
htc
> driver page [2] requests that readers "report bugs, crashes, weird beha=
vior and
> other general tantrums thrown by the driver." That's what I'm doing now=
=2E
>=20
> I am attempting to use the TL-WN722N to create a wireless access point.=
 (Yeah,
> I'm sure there's better devices out there. Spare me the sarcasm, but pl=
ease do
> give a suggestion for better-supported hardware.) I have briefly been a=
ble to
> make this work: my phone has associated with an access point advertised=
 by the
> TL-WN722N and accessed outside networks at wonderfully zippy WiFi speed=
s.
> Unfortunately, the AP functioned for a mere matter of minutes.
>=20
> This has made me wonder whether the issue lies with netctl (the high-le=
vel
> network manager I'm using) or underlying software. Unfortunately, the l=
atter
> appears to be the case. Merely bringing up the wireless interface with =
the `ip`
> utility causes gobs of nasty information to be printed to the system lo=
g.
>=20
> You ask for a bit of information on the "Reporting_bugs" web page, and =
what
> follows is my best attempt to provide that information. Please let me k=
now if
> there's anything else I can do to help diagnose or fix this issue. I'm =
modestly
> experienced with software engineering, Linux system administration and =
computer
> networking, and I am happy to learn more, but this is totally new to me=
=2E
>=20
> Please CC me when replying. I am not subscribed to this mailing list.
>=20
> device information
> ------------------
>=20
> Trimmed output from `sudo bash -c 'lsusb -v'` is available here:
> http://www.ichimonji10.name/downloads/tl-wn722n-lsusb.txt
>=20
> Device firmware is installed on the system.
>=20
>     $ find /usr/lib/firmware -name '*9271*'
>     /usr/lib/firmware/ar9271.fw
>     /usr/lib/firmware/htc_9271.fw
>=20
> software versions
> -----------------
>=20
> Here you go:
>=20
>     $ uname -a
>     Linux pine 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC
> 2014 x86_64 GNU/Linux
>     $ ip -V
>     ip utility, iproute2-ss141009
>     $ netctl --version
>     netctl version 1.9
>=20
> command invocations and log output
> ----------------------------------
>=20
> The system has three physical interfaces. enp2s0 is used as an external=

> interface, and the internal interfaces are enp3s0 and wlp0s18f0u4.
>=20
>     $ ip link show
>     1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state
> UNKNOWN mode DEFAULT group default
>         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>     2: enp3s0: <BROADCAST,MULTICAST> mtu 1500 qdisc fq_codel state
> DOWN mode DEFAULT group default qlen 1000
>         link/ether b8:97:5a:04:f4:c8 brd ff:ff:ff:ff:ff:ff
>     3: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
> fq_codel state UP mode DEFAULT group default qlen 1000
>         link/ether 68:05:ca:01:20:a0 brd ff:ff:ff:ff:ff:ff
>     6: wlp0s18f0u4: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN
> mode DEFAULT group default qlen 1000
>         link/ether e8:de:27:1a:31:a6 brd ff:ff:ff:ff:ff:ff
>=20
> The wireless interface can successfully be brought up and down.
>=20
>     $ sudo ip link set dev wlp0s18f0u4 up; echo $?
>     0
>     $ sudo ip link set dev wlp0s18f0u4 down; echo $?
>     0
>=20
> I executed `iw event -t` before executing the `ip` commands above. It h=
ad
> nothing to say. I also executed `dmesg --follow > ~/tmp/dmesg.log` whil=
e
> executing the `ip` commands above, and it had lots to say:
>=20
>     $ wc ~/tmp/dmesg.log
>     61391  385687 5337913 /home/ichimonji10/tmp/dmesg.log
>=20
> `dmesg.log` is available here:
> http://www.ichimonji10.name/downloads/tl-wn722n-dmesg.txt
>=20
> -Jeremy "Ichimonji10" Audet
>=20
> [1] http://wireless.kernel.org/en/users/Drivers
> [2] http://wireless.kernel.org/en/users/Drivers/ath9k_htc
> [3] https://wiki.archlinux.org/index.php/Netctl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Regards,
Oleksij


--1CVDHWRIejVRwpaeF1S3wgRxDpnCFAeGa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlSZGzcACgkQHwImuRkmbWn3ggEAgTHvB7pQJWBo6yzcngVzpXzn
PMwN7lLQapH4I/1c/iABAIBBQrouxJe8n9flGKcA3oI1yBjTam3K35Dyfo/Rtbc3
=slhZ
-----END PGP SIGNATURE-----

--1CVDHWRIejVRwpaeF1S3wgRxDpnCFAeGa--
