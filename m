Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650AbZJPLiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:38:06 -0400
Subject: Re: deauthentication and disassociation nl80211 commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20091012065507.GB25578@jm.kir.nu>
References: <1254708707.24430.68.camel@maxim-laptop>
	 <1255191866.4095.32.camel@johannes.local>
	 <20091012065507.GB25578@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jAHqFgu22V6oFKd7ugtH"
Date: Fri, 16 Oct 2009 18:36:42 +0900
Message-Id: <1255685802.4095.315.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jAHqFgu22V6oFKd7ugtH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-12 at 09:55 +0300, Jouni Malinen wrote:
> On Sat, Oct 10, 2009 at 06:24:26PM +0200, Johannes Berg wrote:
> > On the other hand, I think Jouni's argument is that you should be able
> > to authenticate (force an auth frame exchange) even while authenticated=
.
> > I don't really disagree with that all that much, but I'm not sure how t=
o
> > cleanly fit it in. mac80211 would have to reset the auth state without
> > sending a deauth.
>=20
> Yes, this is exactly what I would like to see happening when using
> mac80211. For now, I think we can work around the issue in
> wpa_supplicant, but eventually, this change in mac80211 would allow the
> code in wpa_supplicant to be cleaned up and the need for an extra
> deauthentication frame could be removed.

This would require a change in cfg80211 too, since that keeps the BSS
list around and refuses this, mac80211 isn't necessarily involved.

However, we need to spec it out more clearly. For instance, we'd have to
not add a new work item and try for another authentication, but rather
use the old one. Right?

I'm happy to have such a change, but it needs to be clearly documented
what is expected of drivers that get an auth() call while already
authenticated with that AP. Especially since it's not just
send_auth_frame(), as we expect the driver to handle the entire
handshake for WEP SK auth.

johannes

--=-jAHqFgu22V6oFKd7ugtH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2D6nAAoJEODzc/N7+Qmawx4QALgmuaC2x/GtmltL+yfKmTeS
w8AHuFFFSS88NwELUHYey+jYr6NPxOBfic8X4UHwZj/7voAcKNOS/3RlxPVO0rx4
F2Apef09noav8X3A5DXoqkf5slyFB9jzt/FHmM5plK+2LHvdrzq2+y0wmCCEkg4c
JEI9mVBgfjg7bp32o7c6j6rXYK5IZ7PKcIzy9UejQhboDHSjUHkNzsKRd5igmlWq
lZChAT9Qk9FFKbzuQwvQ0kTgbk1fCUa9eY91nGLvAC3/Gg9mpbwp8b8KzZwIBvmN
MEEomO7x7eRSkAKeixu/a3rIeQ2jdUVGseD52XLWg1c1NtSY6B9FPqaGF/+VbEK2
bGslv150Ls2f5qjwlAaLhi1RIRIjnXxyZxmJdQieZR21uMT3GvLA5GYT05DzFUa9
ZRuZKC8JkMehrjASyUR6EpkibyPbfoFJ1A4iMHwR0noAvol8bcMok9xzD2Nrqqtb
nji9K0aoATNecgNQSB30JfWmrTmoqvegqOnls0Jv3wuFFkMxKHn605b69nRNOdOo
mtqUgHKYCfnBDrAniD/MtpqIqN5Hk/zULVcmkwsZmwCv9vLGy101BHEiyEeaLMKZ
0HGH30PaGd41THb3UJ7v28DMS0wCpHkp3VcLBPqdKQaAUhXkApcYTuDDvvRdJBIq
7YC49YmU5tPAcpOawqod
=A7+B
-----END PGP SIGNATURE-----

--=-jAHqFgu22V6oFKd7ugtH--

