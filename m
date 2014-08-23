Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53086 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbaHWTZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 15:25:03 -0400
Message-ID: <1408821895.4672.110.camel@deadeye.wl.decadent.org.uk> (sfid-20140823_212507_551272_8DF313F8)
Subject: [PATCH] Do not run ldconfig if DESTDIR is set
From: Ben Hutchings <ben@decadent.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 23 Aug 2014 12:24:55 -0700
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vEE7Bzg3D0wNd+ZxTZEC"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vEE7Bzg3D0wNd+ZxTZEC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ldconfig should only be run for a local installation, and will fail when
building as an unprivileged user.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Makefile
+++ b/Makefile
@@ -132,7 +132,9 @@ install-libreg:
 	$(NQ) '  INSTALL  libreg'
 	$(Q)mkdir -p $(DESTDIR)/$(LIBDIR)
 	$(Q)cp $(LIBREG) $(DESTDIR)/$(LIBDIR)/
+ifndef DESTDIR
 	$(Q)ldconfig
+endif
=20
 %.o: %.c regdb.h $(LIBREG)
 	$(NQ) '  CC  ' $@

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-vEE7Bzg3D0wNd+ZxTZEC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU/jqh+e/yOyVhhEJAQqFyRAAnmhZ+nY+OU1jpqNucuPBKE7TXXawupBQ
bMaX8bOsMwflCCwryp2+U2rNdt7LXTtpOTFO+j4VOvDppteTsdwGC6rMA1CTjtv+
kJ1P5wMPqq5byHRBWQbV1tELTcAnUjX40zCVzXNi6yS0Empr2vq9NLXJvCuAJK44
ifczrnAl0us8nTr3TcWL1OPoFioGAWn+GpJx8kHBVRsjEsqvUtOqQHKD5kcU8mn9
gHL/QEJwdGZZ6rcrsneU/4She9H1dlUetqHHH/ngfzuq4NX9waMCfr6SBWKcrU97
pKCkiRc4JbRgmFdiYISp8GG8Vp35j7+D9O3YJAuM5AkWjhsF6Ux/U91iKWxAFPh+
e7ptNkY0KbKkLN9UexvfdDWr1KDOhqLv8FC3TTFPgoPXU3XTbJEZquHqQ/LF3KRZ
XZvtWKTMyWayJtncNE0h8PJ7LG4xQMpItDCqHcmxtwdYt10lZXGuaQB/uOUBMOPN
QxrQH2uKg6cw0YirMu0ajeLQgNYGc8rx2OpZj62UgkJpPEiFUnALey5y5y442+Sj
w9r9gnIqz3YZ5ZT0hjAkIM8fbDmjczLS4zSGx8M74IzvVwYQbYP2lhNVzv6jtJZr
j4joqM7URKEXnbytdHalhro3Br1CHjzaN8j2UNrxhjjD0e7QFBqb+5lrNbpdWB5f
eQVhRM9QULE=
=fDsP
-----END PGP SIGNATURE-----

--=-vEE7Bzg3D0wNd+ZxTZEC--
