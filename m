Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531AbZFDQUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 12:20:04 -0400
Subject: Re: [PATCH] rfkill: always init poll delayed work
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <4A27EF6C.8000208@lwfinger.net>
References: <1244015729.7176.28.camel@johannes.local>
	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>
	 <4A27DF95.50603@lwfinger.net> <1244128337.22576.81.camel@johannes.local>
	 <4A27EF6C.8000208@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zTNMdhjVvGwD6WbgYO6i"
Date: Thu, 04 Jun 2009 18:19:56 +0200
Message-Id: <1244132396.22576.82.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zTNMdhjVvGwD6WbgYO6i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-04 at 10:59 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> >=20
> > Could you try, without the patch in question, what happens in terms of
> > uevents
> >  * have everything on
> >  * press rfkill button (expect -> hw_blocked transition)
> >  * put interface down
> >  * press rfkill button (expect -> unblocked transition)
> >  * put interface up
>=20
> I'm running v2.6.30-rc8-25743-g3b2029b from wireless-testing.

But this is without the patch?! If yes that would confuse me.

johannes

> This is with interface UP and switch off:
>=20
> larrylap:/etc/sysconfig/network # cat /sys/class/rfkill/rfkill0/uevent
> PHYSDEVPATH=3D/devices/pci0000:00/0000:00:0d.0/0000:04:00.0/ssb0:0
> PHYSDEVBUS=3Dssb
> PHYSDEVDRIVER=3Db43
> RFKILL_NAME=3Dphy0
> RFKILL_TYPE=3Dwlan
> RFKILL_STATE=3D2
>=20
>=20
> larrylap:/etc/sysconfig/network # ifdown eth1
>     eth1      name: BCM4312 802.11a/b/g
> larrylap:/etc/sysconfig/network # cat /sys/class/rfkill/rfkill0/uevent
> PHYSDEVPATH=3D/devices/pci0000:00/0000:00:0d.0/0000:04:00.0/ssb0:0
> PHYSDEVBUS=3Dssb
> PHYSDEVDRIVER=3Db43
> RFKILL_NAME=3Dphy0
> RFKILL_TYPE=3Dwlan
> RFKILL_STATE=3D2
>=20
> At this point, radio kill switch turned on:
>=20
> larrylap:/etc/sysconfig/network # ifup eth1
>     eth1      name: BCM4312 802.11a/b/g
>     eth1      warning: WPA configured but may be unsupported
>     eth1      warning: by this device
>     eth1      starting wpa_supplicant
> SIOCSIFFLAGS: Unknown error 132
> Could not set interface 'eth1' UP
> RTNETLINK answers: Unknown error 132
> Starting DHCP4 client on eth1. . . .
>     eth1      DHCP4 client NOT running
> RTNETLINK answers: Unknown error 132
> Cannot enable interface eth1.
> interface eth1 is not up
>=20
> larrylap:/etc/sysconfig/network # cat /sys/class/rfkill/rfkill0/uevent
> PHYSDEVPATH=3D/devices/pci0000:00/0000:00:0d.0/0000:04:00.0/ssb0:0
> PHYSDEVBUS=3Dssb
> PHYSDEVDRIVER=3Db43
> RFKILL_NAME=3Dphy0
> RFKILL_TYPE=3Dwlan
> RFKILL_STATE=3D2
>=20
> The ERFKILL (132) prevents it from coming up. Again, the switch was on
> at this point.
>=20
> I could not restore service until rmmod/insmod of b43.
>=20
> Larry
>=20

--=-zTNMdhjVvGwD6WbgYO6i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJ/QoAAoJEODzc/N7+QmaMOEP/0sNmAR6O8bQWZ676c+w3vLb
euJwR2h3mL21kIZUIosCg14dkaToIJxMA9EK+mnapNfGwS+Ux42aso3Apapeq9NH
ckjkCNZtpziNpaa3A1fUZMqaYjgURqkeoq5rnt2IwYpFHaYA2jbaz9Dk4WvMZ80l
yGxWVqw8xwMTHxgwqKAUTOQVFuOUXevt50BrgTtET3vkfmreF3TuWdjC8/jyA/XM
qVrG3+IgDyzUvzcbi7lGNkitis6DwT+XDE1AZMMMj0hk/2LftF0SXlagFnhLN0yV
Mj8MXj/dRCbnmBK9hikwsOfUCvvBePFywtm63qKhcaoo9Aux9pDEQtwbEPlmOpW6
4r/+4u3hBd9Cro9H+emceIiwVboiGQLK4wI3Y6uXczFxLtUU44J2uUKr+W+7FVYk
SG/D7IEhrmj5cCs/O62cGd0vGkBOoUoyywSccwjJwTbOdEjt6z8wjePozz29vIkP
Cr8UH9WjaTbRBoh+wHwsdNcR1uwphOS6uEdYRr/+5l9LqLQDmqLYF3scwmduBoKo
WrQMnaNTB2S65DfZ+YoGaywpbkLqIX01ZePiRb1R2HBvrx/GTRuQBTqpskthMQEO
X5PAmIK/2IZXsDGktiMUmuS9bxHrXFCaRG8pyR4HPlLS2LMZ0gGg+20M6GuDjVJV
IWAodvHqRMcujd87gFAO
=SlAe
-----END PGP SIGNATURE-----

--=-zTNMdhjVvGwD6WbgYO6i--

