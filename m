Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbZCKMkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 08:40:23 -0400
Subject: configuring while interface is down
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Samuel Ortiz <samuel@sortiz.org>,
	Alina Friedrichsen <x-alina@gmx.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xyIX3dcjo8CHRm0LD2Hc"
Date: Wed, 11 Mar 2009 13:36:13 +0100
Message-Id: <1236774973.20266.13.camel@johannes.local> (sfid-20090311_134043_057679_9B71941D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xyIX3dcjo8CHRm0LD2Hc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Alina raised an interesting point -- wext allows you to configure an
interface while it is down, at least by convention. Some parameters for
cfg80211 we reject while an interface is down, e.g. adding new stations,
partly for technical reasons and partly because that doesn't make sense
when the mode of interface isn't fixed.

For cfg80211's assoc/ibss calls, I think we should reject them outright
when the interface is down, any objections?

johannes

--=-xyIX3dcjo8CHRm0LD2Hc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJt7A6AAoJEKVg1VMiehFYzb4P/1+lP6JQHjEc9iSZPSlWABHH
zkuGKL+e9c9Iq0NXBRBFVJ9hICHaXd2mW/Uz9H9kVXlO1DoQbb6jhPOH4baJO9Ls
nop3X+PNTEHy83oM+szHJEBQJwYW3Go14I9JqW7ATudkPlOJZF1NVrrLkvL3mkhY
rnjrUBsDqSrc9j0c8060MgQUBoXsr+xLVZBDjS2UTNvee3xyLmu9SwEPiKRS4ebS
wV1GxCJYoAARr4GGi+wX8t01WrkoIOcGt0D7ys1FfIktHfa0ZRz8qQuWngm+NofW
H19HQ/aVaxV61BiP73kZPuQKekU//2vcRuTCq0Phmn0EFNeLK4j07BlcbUXa5MVg
cHNUPUg59jDnG53xcEjYMR9c52DBfhCUvZsftbNwjSl+PX82U3uHXiUjP9okMPzR
wRwIOo3oeSKuuRDiDIsgT5P+Iyr6jlBt1jVLauTeh/LKIfUGeXDC9Ynh+fe0x6Zf
MEXZffSxDxamK7g4g84RUyua6Rd07ujNjhn+DtOZ4VwInfUhbuFwLKXUlhJT1oTY
20c+InXvj4qafKg7CA+/5q0KgWMv/yvVMcONrB8P6X9rpi0xEQNSn/Fjj9A9VZKp
EGVReNC+G3xFDdAUOeKhH1k/ZUeROQCzBNLZ/zrf3GmmNiiVDS2O99qEBLxpWR2v
38e0aaQjiBWypxqeQa/O
=SoV7
-----END PGP SIGNATURE-----

--=-xyIX3dcjo8CHRm0LD2Hc--

