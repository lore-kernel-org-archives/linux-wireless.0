Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZEUKxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 06:53:02 -0400
Subject: Re: rfkill v9: fixes and thinkpad-acpi conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
References: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uiWwlwVcRDKijmW5BMmN"
Date: Thu, 21 May 2009 12:52:02 +0200
Message-Id: <1242903125.5471.56.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uiWwlwVcRDKijmW5BMmN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-21 at 00:04 -0300, Henrique de Moraes Holschuh wrote:
> John,

I think you mean me ;)

> Here are two patches for the rfkill core rewrite, plus the thinkpad-acpi
> conversion.
>=20
> Just fold them into your latest rfkill rewrite patch.

Done.

> HOWEVER, the thing doesn't work right.  Now, I am pretty sure I might hav=
e
> done something wrong somewhere in the thinkpad-acpi conversion (for
> example: the UWB switch never registers with its hw-block state right, bu=
t
> all others do), and I would appreciate if you could look it over and tell
> me what I am doing that upsets the core.

I don't see anything obviously wrong with the code. Can't say I
completely understand it though, and I don't seem to be able to decode
what it's doing with what feels like half an emulation layer for rfkill
inside the driver.

> The core might have some bugs left, too.  It seems to ignore set_sw_state
> changes, I can't see it reflected on rfkill/state, and it is _not_ becaus=
e
> it is trying to set it back to whatever it wanted properly (or I'd get
> calls to the set_block hook).  Maybe it is something in my thinkpad-acpi
> conversion, though.

But you're not in hard block are you? The sysfs file works like this:
0  !hard, !soft
1  !hard, soft
2  hard, !soft AND hard, soft

> Anyway, the core needs proper coverage testing of its full functionality
> before it can be merged in mainline.  Just like you found that the old co=
re
> never worked right for LEDs, the new rewrite was not processing any KEY_*
> input events, which is a quite important functionality...

Actually it was working for me for WLAN :) But that's because WLAN is
the first, as you found in input.c, thanks for that.

johannes

--=-uiWwlwVcRDKijmW5BMmN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFTI+AAoJEODzc/N7+QmaaOMP/1Qj/8d31c5HIzUUJvMFm9Wr
5Yh965uAlrZiJpk+vW0izmxwuMbgwmjoqnS6PFjoBnRA46cUFM1Eb+fT/8UOfhtE
JUqNgRb4tKHnghRvflXaCj6zh5v6UM/5b+5QeVMiI0uZF1xWSF3qWFa0HpaaYi4D
gUNZbsScODYSExQQb2C3CUEexwIqAP1oTBKYJLTgBq8JXrk4Kym+2O9eO/OQ/z/u
Ot5a8uigiW+nazjlLYaC0/mUmdmJaEc4AeT5TIyRbjd0LDjXck3Ps6YSc+Bihn5o
3PSi9FbWKR5IxxaY8FJ/JBIWFx/XXzvZ95yinS3EO5Zha8KHGijK0rzufIGprTTv
uNGJ64/3NQsrQOy+deenlfhs1uqruJhEvOeYRdk/Z1xmOFiCDcAzmkjxuSQq1rYn
4WHQzQ+g/r4ffTJCP1rzmyOv7ksktW3Sk+sD0ay8TaM8dC0y/SXTVa8flFyL7R8w
bbEb6D8jwc9ZkIOYSR2Ji8KCqLA9KTv+ilqcVgKf4rQwKanwDDZaKH7/X886hy7x
XxWyXSPojfKmwjksnp0RU/FjoajCmCwAfqbWumOX5ZXzpq40lHtHcFnqrl2u095f
wjoDNgRbjYIO76/QcpiZhChzYKf7MXDfNk2AIB1v20fbCkrIpKQBqHH+oIgNP2XY
gECQ+TqdS/KhpsH2J+if
=+qIU
-----END PGP SIGNATURE-----

--=-uiWwlwVcRDKijmW5BMmN--

