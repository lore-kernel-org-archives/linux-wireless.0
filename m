Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbZGPJql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:46:41 -0400
Subject: Re: Further improvements to the software scan implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@gmail.com>
In-Reply-To: <200907161138.58874.helmut.schaa@gmail.com>
References: <200907161138.58874.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0TSnYgTJ78TQ90qiQCDs"
Date: Thu, 16 Jul 2009 11:46:08 +0200
Message-Id: <1247737568.24433.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0TSnYgTJ78TQ90qiQCDs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 11:38 +0200, Helmut Schaa wrote:
> Hi,
>=20
> as already discussed with Johannes we can further optimize the scan
> implementation by allowing (on an active channel) to send probes as
> soon as any other frame is received (and updated the NAV) instead of
> ever waiting 30ms.

There's even two ways of implementing this:
 1) the easy way -- just check for received frames in mac80211
 2) the good way -- ask the driver to notify us of _any_ received frames
                    or poll the driver or something like that

1) is clearly very easy, but if it's seeing e.g. a control frame or a
frame for a different BSS then the device might not pass it up.

But to be honest, I wouldn't worry about 2) and let Jouni implement it
if he cares :) And if we want to make this improvement, 1) is good for
all hardware anyway.

johannes

--=-0TSnYgTJ78TQ90qiQCDs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXvbdAAoJEODzc/N7+QmaznAP/AmHlX/4GXXHiXaNuvxqBEOG
l3fd6aMdEWSlcteS4d7PlnIqo9MfnqlPlvQCmON32rntzNridU02Fx+mLaiVuQ2o
klwDylF7j5Rs3VWpVwAsLlay1kYNex/b98zp8vusF+Bh+r9cOPscDR/2Fz2OyqHS
ngkQ4nXCAnnwrByeabvRM/dIZZXT0VWaChBtxgXa5OybUY9WNEj4/N9C14hBX58a
QRkBIed2k64dqVzV/tWUvYPNWsHesb4ZmZg7Ji3WUCFbqtv0qfyBTO++l0XuoG/B
tIgYPxzlVlLU9BrXacFlLiucZDDaY6UjxHq9Y6EKWzxblhwZxLgN4L/U2alJtRou
KdPwhBQncm3uS0SiEP8CA6uPPUOZr6yEC8YdsfAdOevVFCrptxYqd+d2cdhaGxfp
1LPHxn+vGeUndwVwKSg9p8HnhZC0aeq3WvK8affT/9aL1M0CA+IZqIjuMUPh1TkG
95ZxG2omRW3cCTPDhhtJY1fAVHT7yd4E/Y+Cy/8uLBvmqiOlRXNnfHMrmdkNQ6En
X3gdC8hzvsa4FzPUg3yrF6k0d+RCBoj7a/amvp02bMA84P/leUBXkK/5CJL6vovN
CZ6JgoN3vPCXqpTGMm2XEWD/QrHGFeus9uqN0AZ4EJa1HMvK5tl8Tv1A9E7PLCMl
ivC/50k6vuKCcejY9rai
=zRRl
-----END PGP SIGNATURE-----

--=-0TSnYgTJ78TQ90qiQCDs--

