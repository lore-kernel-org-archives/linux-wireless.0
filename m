Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53584 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbbEURZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 13:25:11 -0400
Message-ID: <555E14D1.30008@rempel-privat.de> (sfid-20150521_192516_474950_420985AC)
Date: Thu, 21 May 2015 19:24:33 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Jason Scatena <jscatena88@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Issues with mesh networking path detection
References: <CANvVAoyhGCLL7ajGFH91xgNBMZd2kd5P-9v3_PaE+xdmEYYkpQ@mail.gmail.com>
In-Reply-To: <CANvVAoyhGCLL7ajGFH91xgNBMZd2kd5P-9v3_PaE+xdmEYYkpQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wpX3ebRTMxt6wVkQsXTCVVdRHr4cMCBSR"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wpX3ebRTMxt6wVkQsXTCVVdRHr4cMCBSR
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 21.05.2015 um 19:11 schrieb Jason Scatena:
> Hello all,
>=20
> I am attempting to set up a mesh network between 4 computers with
> Atheros 9271 based usb wifi dongles using the ath9k driver.
>=20
> I followed the guide at: https://github.com/o11s/open80211s/wiki/HOWTO
>=20
> to set up the network.
>=20
> When I get all of the computers up and configured they all see each oth=
er.
> The command "iw dev mesh station dump" shows all the nodes in the
> area. However the path selection doesn't seem to work at all. For
> instance the command "iw dev mesh mpath dump" returns nothing. However
> if I manually add arp entries using the arp command they show up in
> the mpath dump.
>=20
> I am willing to do whatever to troubleshoot however there is very
> little documentation that I have been able to find on trouble shooting
> these issues. I would also be able to provide a pcap file of the nodes
> coming online.
>=20
> I'm new to the wireless world but have C coding experience and would
> be willing to put in the time to learn.


Hi,

i don't think there are people who will know the answer without research
and reading the code.

Since you are willing to learn any way, fallow the codepath and find out
what is happening. We would be happy to have more wifi experts :)

Find out what executed in kernel if you start this command: "iw dev mesh
mpath dump". I assume it is starting somewhere in linux/net/wireless/mesh=
=2Ec

Use printk() placed in code or use gdb+openocd+jtag if you use some arm
or mips system.


> Best,
> Jason Scatena
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Regards,
Oleksij


--wpX3ebRTMxt6wVkQsXTCVVdRHr4cMCBSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlVeFNYACgkQHwImuRkmbWlN7QD/Z5v0YV/yh0lx1e2AQwVLnkOG
4DxDsnVJ9gu/SrTZuL4A/iHPjFOEAs8/mTl9fdUgWuVZD2Jl14X6CDv9V4UB1/jJ
=s9o5
-----END PGP SIGNATURE-----

--wpX3ebRTMxt6wVkQsXTCVVdRHr4cMCBSR--
