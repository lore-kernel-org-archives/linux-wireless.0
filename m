Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935AbXC1JMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:12:49 -0400
Subject: WPA/RSN information in cfg80211?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y9hWdoda2W2jPJPR2ltP"
Date: Wed, 28 Mar 2007 00:34:06 +0200
Message-Id: <1175034846.5151.20.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y9hWdoda2W2jPJPR2ltP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Looking through wpa_supplicant and then through the kernel I notice that
we currently in the kernel special-case some things in SIOCSIWAUTH, for
example IW_AUTH_WPA_VERSION is ignored since we rely on the IE that wpa
supplicant gave us.

Apart from how wrong I think this is (we shouldn't be allowing a setting
we can't do, we need to return some error code and wpa_supplicant should
sort it out) I also found only one occurrence in prism54 where the
parameters are actually not ignored. Is that driver fully replaced by
p54?

Is there any point in supporting these at all? Does the Libertas 8388
requires the settings as well instead of just the IE to include?

I'm inclined to just require userspace to put both the IE and the
individual settings into the relevant nl80211 messages, but then we
might just as well piece the IE together from those settings, no?

johannes

--=-Y9hWdoda2W2jPJPR2ltP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCZvd/ETPhpq3jKURAkGIAJ9GEWJUwO8IHSpGa45JZNhAnj4hLQCeJsks
kD+JPfs1Rxq7YVV5afG1dag=
=tPrv
-----END PGP SIGNATURE-----

--=-Y9hWdoda2W2jPJPR2ltP--

