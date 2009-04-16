Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbZDPAWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 20:22:07 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <Kalle.Valo@nokia.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1239837672.11795.46.camel@violet> (sfid-20090416_012123_293746_81110E23)
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0bW7NAjCpWuoFYX0U0ub"
Date: Thu, 16 Apr 2009 02:21:30 +0200
Message-Id: <1239841291.25334.18.camel@johannes.local> (sfid-20090416_022212_435684_EEC24EF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0bW7NAjCpWuoFYX0U0ub
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

> After a long debugging session with Reinette we finally tracked down
> what is going on here. A full scan with this card takes 7-9 seconds and
> that seems to be too long and trigger IEEE80211_MONITORING_INTERVAL
> which then deauthenticates us with the AP (reason=3D6).=20

Yeah, this is a bug. We analysed this problem a couple of days ago and I
thought Kalle was going to fix it -- maybe he forgot. I forgot what
exactly it was and how to fix it, hmm. Right now I'm confused and can't
seem to reproduce my analysis. I thought it had something to do with
using a different timer but we do seem to use the regular mgd.timer, so
I'm not sure.

> Problem then is
> that the attempt authenticate/associate with the AP fails with all the
> time (reason=3D2). Bringing the interface down/up again doesn't help. It
> seems that some internal mac80211 states are messed up. Some times the
> whole process stalls completely and nothing happens anymore. Only
> unloading and reloading the driver or rebooting helps.

Hmm. Reason 2 is "Previous authentication no longer valid" which would
seem we get confused wrt. being authenticated or not (ie. we think we
are, but are not). Jouni might know? Can you try wpa_supplicant from git
with -Dnl80211?

> Increasing the IEEE80211_MONITORING_INTERVAL to 10 seconds doesn't
> trigger the deauthentication with the AP anymore (or less likely).
>=20
> During debugging I verified that only the scan actually triggers the
> deauthentication. If I don't scan (NM disabled) then everything works
> smoothly.

Right.

johannes

--=-0bW7NAjCpWuoFYX0U0ub
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5noFAAoJEKVg1VMiehFYeaoQAJCf5bmpGFiEuC5MOXxg9Q7O
XnA+R/OL9afs3SQPUj8DyHnzVgu+3VpV/o1sRXo+LUnltkXpCS3VtJt445fKuJee
YwuRP+V3n2Nw236GvR5gMFl2X96kB0jR1XaV/H7UfjLMV1EI0z9V4RXessI9n8bc
tN1PwZxXhxwoOHoaXR9xevyK+ZI5UbO/f9y6BWFdokQD546HBiAQoi3TJ046HNXA
wtKeKjXf3FSA5a5dh+y8GAKDLYA8U673IHcnXhJ8NkOiyCfKJ2GjtKJeDEkjiusa
NLKeiC7l/wuJR9D/SxUz8SO4ujOR4lYpvM/KcmRSheI77uRyU7/23EBthufwIIAH
Lh/4QwZ4kMu59QaM0FtQgbnsY7qk8KwsCQ6s+5++U6sAAMYt1ZcUJWru6jdRGOh1
kezD+xme+BBpgt7LzhldnPbmIkTLw5/kooaVf14LGAdRqrNA3i0bHF3MkBLroVWa
TzetdW2LFCmHu9pGnrw4LNrC+H2Q1zpOGUsVxVNXe6mzu3XkLHLXXFN+CInIT/6+
tu/IuY8Flu/uRYqvWyPU8awxaDTP9G8CKlyyyb66pbfY3uI/n5/phiNOUsb5TQjX
e/nuMGbdCSr0i5wz5ArFMxj3DRO7ukwWS+KeXVXLtXkMi8DaNzldL3R6Vf/BYDOn
/hRXcmjcH3752K+EmVCk
=1po8
-----END PGP SIGNATURE-----

--=-0bW7NAjCpWuoFYX0U0ub--

