Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55172 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXLXV5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 16:57:10 -0500
Subject: Re: Strange mac80211 oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1198532736.4103.44.camel@johannes.berg> (sfid-20071224_214550_097878_F699D24B)
References: <200712242237.28913.mb@bu3sch.de>
	 <1198532736.4103.44.camel@johannes.berg>
	 (sfid-20071224_214550_097878_F699D24B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zCWsqE1ra63Jig6yHSfy"
Date: Mon, 24 Dec 2007 22:57:03 +0100
Message-Id: <1198533423.4103.46.camel@johannes.berg> (sfid-20071224_215715_804934_D07F8E7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zCWsqE1ra63Jig6yHSfy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-12-24 at 22:45 +0100, Johannes Berg wrote:
> > [   98.415423] ------------[ cut here ]------------
> > [   98.415627] Badness at e221c924 [verbose debug info unavailable]
>=20
> > [   98.416905] NIP [e221c924] __ieee80211_rx+0x48c/0xd44 [mac80211]
>=20
> ieee80211_rx_monitor() is inlined into __ieee80211_rx() and that +0x48c
> is quite a high number, so I'm guessing it's this:
>=20
>         /*
>          * Drivers are required to align the payload data to a four-byte
>          * boundary, so the last two bits of the address where it starts
>          * may not be set. The header is required to be directly before
>          * the payload data, padding like atheros hardware adds which is
>          * inbetween the 802.11 header and the payload is not supported,
>          * the driver is required to move the 802.11 header further back
>          * in that case.
>          */
>         hdrlen =3D ieee80211_get_hdrlen(rx.fc);
>         WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);

Yup, that's what it is, Michael sent me the assembly, __ieee80211_rx
starts at 0x1990 and we find at 0x1990+0x48c =3D=3D 0x1e1c


    1df8:       48 00 00 01     bl      1df8 <__ieee80211_rx+0x468>
                        1df8: R_PPC_REL24       ieee80211_get_hdrlen
    1dfc:       80 18 00 a0     lwz     r0,160(r24)
    1e00:       7c 00 1a 14     add     r0,r0,r3
    1e04:       70 09 00 03     andi.   r9,r0,3
    1e08:       41 a2 00 2c     beq+    1e34 <__ieee80211_rx+0x4a4>
    1e0c:       3d 20 00 00     lis     r9,0
                        1e0e: R_PPC_ADDR16_HA   .sbss
    1e10:       80 09 00 00     lwz     r0,0(r9)
                        1e12: R_PPC_ADDR16_LO   .sbss
    1e14:       7c 00 00 34     cntlzw  r0,r0
    1e18:       54 00 d9 7e     rlwinm  r0,r0,27,5,31
    1e1c:       0f 00 00 00     twnei   r0,0

which is exactly the WARN_ON_ONCE above.

johannes

--=-zCWsqE1ra63Jig6yHSfy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3ArLaVg1VMiehFYAQKS4Q/9FlU/hfbZvO8xoKe6z5uealRmixqxQG8h
8Vt47ee3f5GN+hHu7O5gE2CnH/qV2t8ynhuRoSLetVlUsnSLEzEgfLwlf+tQdvJh
KiQEJ3oAWVviVHX50XiEpMXKv6r4vthLBasD5I+bxJ0uWhsJJb5rv+qan8SP8BUX
lL7UOYsfCI7sJyr8aUImL+TYfXuUHXpc63t+I1X8q3effSqS9F34xFxRHpYloFHI
lKQZzXfIs+X+3VWqKrHo6PdlCJs4U6XQJcRwb1CNHo0FA/SGKBfhsSDGvqinKpzD
B24DTt0Qa23FPjK0r7LJq+235nz7wi2x8mBlGyVb3/phLEwu0R3goi74L7C5KkTt
U5FYdxQj0xbHqOb5K/+m/x+3lH9hKQdMpWTb1TtzJAvfKUK8ZoTTKzx0lGxNOpKi
9NHg5HwtP967SQeN+k0cQdI0EmyEnpZVHjbTON4YxxI2wVOHrO4RExd9+sYpxsMe
n28U6f0Saz5p78RzJ5BdGRNluGA5o7i3rtWHeXdZMg8ghMz527CA1ud1Taz77cQR
Ie8/xTQ1OvIaASFtipA6zylBmvoTFCMLLlA3Wb/9O6txPRRHJxcF9bRAx3FohcNI
mau0Dd8ueKwRmtODqqLhheUxRdOKyZIuePfgsp/BOc5faBZMgdtUQ2/FcFCTwjT5
bzFOsiwVnkw=
=LsLl
-----END PGP SIGNATURE-----

--=-zCWsqE1ra63Jig6yHSfy--

