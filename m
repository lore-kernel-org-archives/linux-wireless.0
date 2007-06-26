Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbXFZI6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2007 04:58:34 -0400
Received: from [131.234.77.29]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1I36sb-00035s-4J
	for linux-wireless@vger.kernel.org; Tue, 26 Jun 2007 09:58:33 +0100
Subject: mac80211/bcm43xx deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lFL96FX9ey2uws9reFUy"
Date: Tue, 26 Jun 2007 10:59:41 +0200
Message-Id: <1182848382.3830.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lFL96FX9ey2uws9reFUy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

I just managed to deadlock bcm43xx when I was trying to do something
with iwconfig at the same time as telling network manager to shut off
the interface. It stayed up and things were locked up.

I haven't been able to analyse it yet, I dumped process stacks a few
times and put the resulting log at
http://johannes.sipsolutions.net/files/mac80211-bcm43xx-deadlock

Note that many processes are in rtnl_lock() but wpa_supplicant is stuck
in wait_for_completion.

johannes

--=-lFL96FX9ey2uws9reFUy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgNV8/ETPhpq3jKURAuhFAKC4KST8h8r1BpqkoO/WRp7OlJFPqQCghVl3
yt/e6GQ2d0Xsa1kxPso28FI=
=v0mS
-----END PGP SIGNATURE-----

--=-lFL96FX9ey2uws9reFUy--

