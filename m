Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53093 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbaHWT1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 15:27:42 -0400
Message-ID: <1408822054.4672.113.camel@deadeye.wl.decadent.org.uk> (sfid-20140823_212745_096867_C0797711)
Subject: [PATCH v2 crda] crda: Do not run ldconfig if DESTDIR is set
From: Ben Hutchings <ben@decadent.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 23 Aug 2014 12:27:34 -0700
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oIt5nDFhfgUdmlI1Mavn"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oIt5nDFhfgUdmlI1Mavn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ldconfig should only be run for a local installation, and will fail when
building as an unprivileged user.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
v2: Add 'crda:' prefix to subject

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

--=-oIt5nDFhfgUdmlI1Mavn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU/jrJ+e/yOyVhhEJAQqKjA/+MRkkfGe3wg9/wXFyHRxVT69GsyTll6mX
GnAFEV7etoVYVEbzYQ/9N8no+J8DrAuF2h+rw2XbDnlTRBD8yi3I9KgVd90FOAE2
oFeNmFfNJEpSbl19wngp6oRzQpgNTQc39I+7JK7X/SL4jDs0GexnCzosviNPzk2F
tyCcSTMv+W6qHwmNrQ7tO5ydalNxPAr8LM0nYf6oUfy8IbJm+/JnPAOqFMXu/PmC
Ov6tuOBdojWgdpDVlBKtQ2FqT/m4+mp7lP+I/PxPTZZLztdl9MBqK4f2QFjvpnAC
XNV8C0cAbVRR1GGyU1MbYiL8E6wLUjpAiCxN/8iHJ+hk2UupRB0E/kHTtqDeeMeI
Qv0agyj3U64Rs7Hvx773YPGAuN3a5MhKhX/BTq6AOAnRRAD/QAkYhurIINUjq/3t
P7J7uKqORvxqrJCKQPgVMExOMIGwV0G5+dX0i23Ii6NHRCYru/sFotopcuVpjZBC
UFAE/pwyKoKXLowjmey/kZwA5Jh3Hj2gLRQCFXmRDFlVy9NJik3ZaKXvk1ITl9qz
/DyZV/3S12ko83FCvbaFXNCnY/kgbk6r6ITJbVYm54c2Uhr5iY8bi/gPOvN/ATCv
NVCoYKRlXg7BPoJZf6yXm+W9TJt5dUy4pNMEXeYhaTJpVNZX/EZlLW+CZuw1Eeks
pZJOVBErCuQ=
=XNrv
-----END PGP SIGNATURE-----

--=-oIt5nDFhfgUdmlI1Mavn--
