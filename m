Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63135 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab1LGFz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 00:55:29 -0500
Received: by ghbz2 with SMTP id z2so178359ghb.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 21:55:28 -0800 (PST)
Date: Wed, 7 Dec 2011 00:55:26 -0500
From: nick black <dankamongmen@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] don't use unsigned ints for signed data, print_mcs_index()
Message-ID: <20111207055526.GA13903@qemfd.net> (sfid-20111207_065539_628378_B4E5406B)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Johannes et al,

Trivial patch. Don't use unsigned ints for clearly signed data. Though the
code as stands works, it's brittle in the face of change, and generates
compiler warnings. Please apply. Taken against Debian's iw-3.1. Thanks!

diff -ur iw-3.1-orig/util.c iw-3.1/util.c
--- iw-3.1-orig/util.c	2011-12-07 00:43:05.495669921 -0500
+++ iw-3.1/util.c	2011-12-07 00:51:45.558545571 -0500
@@ -384,7 +384,7 @@
=20
 static void print_mcs_index(const __u8 *mcs)
 {
-	unsigned int mcs_bit, prev_bit =3D -2, prev_cont =3D 0;
+	int mcs_bit, prev_bit =3D -2, prev_cont =3D 0;
=20
 	for (mcs_bit =3D 0; mcs_bit <=3D 76; mcs_bit++) {
 		unsigned int mcs_octet =3D mcs_bit/8;
@@ -458,7 +458,7 @@
 	if (max_ampdu_length) {
 		printf("\t\tMaximum RX AMPDU length %d bytes (exponent: 0x0%02x)\n",
 		       max_ampdu_length, exponent);
-        } else {
+	} else {
 		printf("\t\tMaximum RX AMPDU length: unrecognized bytes "
 		       "(exponent: %d)\n", exponent);
 	}
@@ -466,8 +466,8 @@
=20
 void print_ampdu_spacing(__u8 spacing)
 {
-        printf("\t\tMinimum RX AMPDU time spacing: %s (0x%02x)\n",
-               print_ampdu_space(spacing), spacing);
+	printf("\t\tMinimum RX AMPDU time spacing: %s (0x%02x)\n",
+	       print_ampdu_space(spacing), spacing);
 }
=20
 void print_ht_capability(__u16 cap)

--=20
                                       nick black <nickblack@linux.com>
"A main cause of the Roman Empire's fall was that=E2=80=93lacking zero=E2=
=80=93they had
       no way to indicate successful termination of their C programs."

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7e/84ACgkQzjCRTpolKGvVrwCfeUnrndU5D9T1g1AXlgHV6V5N
/IYAoLEKSq6fyUEJYVB3d+kMEX6uPj3Z
=n6bh
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
