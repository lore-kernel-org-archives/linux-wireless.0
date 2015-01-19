Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51991 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbbASHDX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 02:03:23 -0500
Message-ID: <54BCAC37.1030807@rempel-privat.de> (sfid-20150119_080328_073726_DE3AAEBC)
Date: Mon, 19 Jan 2015 08:03:19 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Jeremy Audet <ichimonji10@gmail.com>
CC: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Subject: Re: bug report for ath9k_htc driver
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>	<54991B32.2010105@rempel-privat.de>	<CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>	<5499A391.2060705@rempel-privat.de>	<CA+A7n+iHKBxy3qfjzrnN7GdZhJ-WwoDdi6hjw8RSaDs8TBznvw@mail.gmail.com>	<549E6C1A.7010805@rempel-privat.de>	<CA+A7n+gP6h1HT5F7oDY-SDrrAAjbtTHAtY0683Fe7QdVb7byfQ@mail.gmail.com>	<CA+A7n+jQQNWk2CqoS9QQFODRsi8k4asjWE=5_q681E6PTiQM+A@mail.gmail.com>	<54B69807.9030906@rempel-privat.de> <CA+A7n+gzarweW+ENOfx+QmCGHy+0Vu6qzPM70cPMxe5FTMwCUw@mail.gmail.com>
In-Reply-To: <CA+A7n+gzarweW+ENOfx+QmCGHy+0Vu6qzPM70cPMxe5FTMwCUw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vjSsiNDBswad8ejF6jgL5242c69s8bfSP"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vjSsiNDBswad8ejF6jgL5242c69s8bfSP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 19.01.2015 um 01:35 schrieb Jeremy Audet:
> Gaaaaah! Damn it, gmail. I'm sending this email again. The first copy
> of this email was rejected by the ML's spam filter, due to the
> presence of an HTML part. I'm sorry for spamming y'all.
>=20
>> Looks like with the hub it can work at least some hours. Correct?
>=20
> There was an ~18 hour timespan between when the device was physically
> plugged in and when freaky error messages were dumped to the kernel
> log, so that's good. However, it's worth noting the device wasn't
> really "available" that entire time. The kernel log shows that the
> device appears to be physically disconnected and reconnected five or
> six times in that timespan. (The device remained physically
> untouched.) The device is set up as a high-speed USB device again
> after each disconnect, which is good, but those disconnects shouldn't
> happen in the first place.

There is one HW or FW not fixed issue which may cause FW restarts, but
proper restarting was introduced by 1.4. And, if FW triggered a restart
you will get something like this:
> [ 3501.052975] usb 1-2: ath: firmware panic! exccause: 0x0000000d; pc:
> 0x0090a641; badvaddr: 0x12345678.

> I'm doing as you've suggested:
>=20
> 1. Start collecting log messages with `journalctl -k --follow -n 0 >
> mylogfile.txt`
> 2. Plug in USB hub.
> 3. Plug in TL-WN722N.
> 4. Execute `sudo bash -c 'echo none > /sys/class/leds/ath9k_htc-phy11/t=
rigger'`
> 5. `sudo ip link set dev wlp0s19f2u4u2 up`
> 6. Wait.
>=20
> I'm currently on step six. I'll post an update when appropriate.

This means, we may have some usb protocol related issue. Without proper
investigation i can't say what is happening. Currently we can find some
more or less good workaround (or dirty hack :D).

--=20
Regards,
Oleksij


--vjSsiNDBswad8ejF6jgL5242c69s8bfSP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlS8rDcACgkQHwImuRkmbWl1uQEAhIeYvSAQ6V5KajjmibF2Lm7K
1vo9kOlfcO6Ag0oAeUgA/AiKn/f9VyuUuIs+vyX00VtLVeMT1BhpXE7IRP1ZuYOl
=rDcR
-----END PGP SIGNATURE-----

--vjSsiNDBswad8ejF6jgL5242c69s8bfSP--
