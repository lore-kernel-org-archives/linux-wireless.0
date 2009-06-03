Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZFCHw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 03:52:26 -0400
Subject: Re: [RFT 3/3] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <4A2592C5.10803@lwfinger.net>
References: <20090602111027.460530075@sipsolutions.net>
	 <200906021641.11019.mb@bu3sch.de> <1243973079.6461.3.camel@johannes.local>
	 <200906022208.46288.mb@bu3sch.de> <1243973487.7176.1.camel@johannes.local>
	 <4A2592C5.10803@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JyhXbcNuJaGtsp5zv7XB"
Date: Wed, 03 Jun 2009 09:52:24 +0200
Message-Id: <1244015544.7176.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JyhXbcNuJaGtsp5zv7XB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 15:59 -0500, Larry Finger wrote:

> I'm trying to test, but I get an oops on boot. I'm still tracking it
> and I lose the reason off the top of the screen, but the trace is:
>=20
> queue_work + 0x1a
> schedule_work + 0x16
> rfkill_resume_polling + 0x23
> wiphy_rfkill_start_polling + 0x35 (Line 452 of net/wireless/core.c)
> b43_op_start + 0x172  (Line 4336 of drivers/net/wireless/b43/main.c)
>=20
> The offsets are appropriate for wireless-testing and x86_64. The line
> in b43_op_start is the one just before the mutex_unlock.

Thanks for the hint about the BUG_ON() -- that was easy, I'm kinda
abusing the rfkill API in cfg80211 but I think that ought to be
possible. I'll send a patch.

johannes

--=-JyhXbcNuJaGtsp5zv7XB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJiu1AAoJEODzc/N7+Qmat4wP+gIh3E3JkqYBgNzUW7RqmXvh
4dj/gox4dpRkSpZuXQhGfJEDOU+Fn9AqCmMCAJJ4Kx3hrl/knrKIaAzYJYYDZAIa
gtAFIFpJT/cZK7DwDmljS2pGzDxYiUbBAdNWNHxUdLKtWDQxkXpmTPDNMAzeY5NS
D75m5WgTfkcVeen4Fma7NRcziwSP4h82bkJgYvb0SZd/hEFMcxRnREXevlOidlUo
aCaem71M18rbFpHk8lgfpGGcerfRvtp7fgwtnlUbZtxIpmOwHKhxhthBU1v3B29A
Q0CRbbwYdzA1bPY8baO6w07dJE6qOH86O79cxMqyfIU/3TNPE3G21zXi6fdh41Wo
QRKXw5BWTY6mWyC3qoIo580D6eDe2pKgSoRbTpyo1WnIL6ZpmBYrdBJih45nw6f2
kVsmMiG3etulAQr9/DZ6Yx8goq6Q2iwoO5ZA2h+8s5Hn4bRiIHMswda8mK2hulfB
L+LhW0zU+6UQoHMf48uRLARr4JoGpKs2LWjgEvFDrh8ErbWUtOw/HnOwenhDCuv3
n+YXLdifuanW4vQYPRD4hjqSSD5GAQsJHSIPeO+HheA5060lpm4Pg6WaE3rcjawv
sQbrBV2BQOPNyJgHojEAt2+p40gupUuWZStwrR6fNL56CfSL5HYQvsXNv8As+NAv
TJ3ERKfcKmkwdjJif8dS
=vOtp
-----END PGP SIGNATURE-----

--=-JyhXbcNuJaGtsp5zv7XB--

