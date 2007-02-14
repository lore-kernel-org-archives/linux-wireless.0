Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43613 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965586AbXBOO7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 09:59:19 -0500
Subject: round_jiffies for schedule_delayed_work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arjan van de Ven <arjan@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VYMxshuHgCtPR0v1Gzsh"
Date: Wed, 14 Feb 2007 22:39:23 +0100
Message-Id: <1171489163.6093.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VYMxshuHgCtPR0v1Gzsh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I was looking through recent commits in wireless-dev and found
e226b8aa8921b6b75dcd0142a990b8c7bc1548fd which is correct, but I was
wondering if it may be possible to do it more efficiently.

We don't really need this code running every second after we init,
having it run every second on average is good enough. I don't see any
way to do this with the delayed work API though since
schedule_delayed_work simply adds the timer at jiffies+delay.

Should we be using a timer and round_jiffies() instead?

johannes

--=-VYMxshuHgCtPR0v1Gzsh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF04GL/ETPhpq3jKURAvz/AKCR213FgfngRgBiYJI1U1TTpMMFmQCgngQx
SghI9a9h9n7BbamPbjk1C6c=
=jCGJ
-----END PGP SIGNATURE-----

--=-VYMxshuHgCtPR0v1Gzsh--

