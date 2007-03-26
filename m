Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXC1JLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:11:13 -0400
Subject: rx racing against removing interfaces?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FE2vOw9bps3QglgYNyG5"
Date: Tue, 27 Mar 2007 01:05:22 +0200
Message-Id: <1174950322.25887.59.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FE2vOw9bps3QglgYNyG5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Isn't there a race there when you remove interfaces and at the same time
__ieee80211_rx is running? I don't see anything that should stop that,
and if it happens we'll probably blow up pretty spectacularly with
accesses to a freed netdev, or even sending it frames...

johannes

--=-FE2vOw9bps3QglgYNyG5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCFGy/ETPhpq3jKURAnlbAJ9j0lMQ6MP84tXaukQL8+RJgqxHbACfTnRJ
aKIV9HsRVYWZYCELIM3H5DI=
=MPdl
-----END PGP SIGNATURE-----

--=-FE2vOw9bps3QglgYNyG5--

