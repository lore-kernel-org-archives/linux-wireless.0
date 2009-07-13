Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbZGMTuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 15:50:23 -0400
Subject: Re: [RFC/RFT] rtl8187: Fix for kernel oops when unloading with
 LEDs enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A5B8F57.5020601@lwfinger.net>
References: <4a5b563e.AuhPXmHA0dUFYtzx%Larry.Finger@lwfinger.net>
	 <1247501812.4166.24.camel@johannes.local>  <4A5B8F57.5020601@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LRYCkUAlasmGOOMozaoD"
Date: Mon, 13 Jul 2009 21:49:49 +0200
Message-Id: <1247514589.4071.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LRYCkUAlasmGOOMozaoD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 14:47 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> > On Mon, 2009-07-13 at 10:43 -0500, Larry Finger wrote:
> >> When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
> >> may oops when the module is unloaded as the workqueue for led_on was
> >> not being cancelled. To prevent interference between cfg80211 and rtl8=
187,
> >> a separate workqueue has also been established.
> >=20
> > It doesn't seem like a separate workqueue should be necessary -- why is
> > it? Might make more sense to fix cfg80211 or mac80211 instead.
>=20
> Probably.
>=20
> Attached is the dump for the locking error when b43 is unloaded.
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> [ INFO: possible circular locking dependency detected ]
> 2.6.31-rc2-wl #178
> -------------------------------------------------------
> modprobe/14721 is trying to acquire lock:
>  (&rdev->conn_work){+.+.+.}, at: [<ffffffff810510c0>]
> __cancel_work_timer+0xd9/0x222
>=20
> but task is already holding lock:
>  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa0220524>]
> wiphy_unregister+0x3a/0xf8 [cfg80211]

That's purely a problem within cfg80211, and I don't think it could be
solved by your patch at all. I did send a patch earlier today though to
solve this.

(maybe you didn't reboot, and then lockdep was disabled after the first
warning?)

johannes

--=-LRYCkUAlasmGOOMozaoD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKW4/aAAoJEODzc/N7+Qma/4gP/R70jozkpEoAcW5vsPcjPqym
nPiYm3daiitv8TJQkkGyXDeARLnfmuDT7G449RFAc5VtVfoWE4dfz6f7/Ilo3n/4
2DQUgpi1lDG72ZbPRW255jbTJ3j/LfQ+/03LQrZ6D9srluS9yTQ6oVG98AG5UzbU
/+V5bsXzQMD8T1Yr2Sc0v0C0+G96XWDsSdzNymQQKuglAprUSQCM1HCss/9zF1ue
MvTXZc7qj4LiDYrfehBOKPsAhhJo4vFp3Q7LsoLhEmiL96kE8Pa3NvhdizbrONQi
chtWaW7Y6JOB9k4uOYoUZy0EAV/r7XOEeGXjIlSAPsU0rPJQb6u1heHQrNUskvyI
m9qhtGzDvNUVjKDNfrSjgz2hGzCmVGQuu6h1fHHXX9lY9e+Y0OlvpyTOEGv8lPJX
BqOGkwu1cV46k7mN0Xqyfo4xeIL9kh/Q+4U7Zuq2a+3+MZ1WNDJ2eqot18F071Rg
bkLNeXLIhqgtcN9/VjKLDkdRrJ+2cQ19LSyqZXbzPdI+TXWtybPML/7Aux3iwDQS
i9P0L0BJBYVZ7rU91snCM2cE4OIZPsiOpZxSI+oslNrdKittZ9oQMjCNYtyHVZ3t
ItJulQoqkyaCKXUCbp/nL1LIhTQsz4YAyFK4jML/anF8zf7H5LeNEYaDGoTaXpDe
zmOd07Stp/jYFkMyB/du
=9f9F
-----END PGP SIGNATURE-----

--=-LRYCkUAlasmGOOMozaoD--

