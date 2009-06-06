Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39536 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZFFRNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:13:11 -0400
Message-ID: <4A2AA395.3060406@web.de>
Date: Sat, 06 Jun 2009 19:12:53 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] ar9170-fw: Roll-your-own toolchain
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFCCF9C13039894E0F073A01D"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFCCF9C13039894E0F073A01D
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

excited about the announcement of a free ar9170 firmware and
specifically the chance to get AP mode working with my DWA-160a, I
wanted to give this a try ASAP. As I'm somehow allergic when I have to
register for downloading Open Source, I hacked up a Makefile that
retrieves and builds a home-brewed m2-capable toolchain (the advertised
rpms only support m3 or even just m4).

The toolchain consists of latest binutils (2.19.1) and newlib (1.17.0),
but "only" gcc 4.3.3 as 4.4.0 drove the AP build into troubles: the
=2Edata segment was reported to exceed the available space by a hundred
bytes. So I switched one version back for now.

On the other hand, the AP firmware doesn't work on my DWA-160a anyway
("device is in a bad state"), only the STA version (but that one
dislikes my access point, just like the original firmware, though).
Guess there is still enough room for improvements...

Jan



--------------enigFCCF9C13039894E0F073A01D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoqo6cACgkQniDOoMHTA+nzQACdGn0He11PuW7KooGYYmFOqKhH
pasAnRb+6qtaDslOE+orIVCdbhlgR3b7
=Dqkz
-----END PGP SIGNATURE-----

--------------enigFCCF9C13039894E0F073A01D--
