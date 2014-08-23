Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53090 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbaHWT0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 15:26:50 -0400
Message-ID: <1408821997.4672.112.camel@deadeye.wl.decadent.org.uk> (sfid-20140823_212653_006081_4207A355)
Subject: [PATCH crda] crda: Fix linking of libraries used by libreg
From: Ben Hutchings <ben@decadent.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 23 Aug 2014 12:26:37 -0700
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/LFS/uf6tNM/eEleMxai"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/LFS/uf6tNM/eEleMxai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The math and crypto libraries are called by and need to be linked to
libreg.so, not to the executables.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Makefile
+++ b/Makefile
@@ -30,7 +30,7 @@ CFLAGS +=3D -std=3Dgnu99 -Wall -Werror -peda
 CFLAGS +=3D -Wall -g
 LDLIBREG +=3D -lreg
 LDLIBS +=3D $(LDLIBREG)
-LDLIBS +=3D -lm
+LIBREGLDLIBS +=3D -lm
 LIBREG +=3D libreg.so
 LDFLAGS +=3D -L ./
=20
@@ -40,7 +40,7 @@ all_noverify: $(LIBREG) crda intersect r
=20
 ifeq ($(USE_OPENSSL),1)
 CFLAGS +=3D -DUSE_OPENSSL -DPUBKEY_DIR=3D\"$(RUNTIME_PUBKEY_DIR)\" `pkg-co=
nfig --cflags openssl`
-LDLIBS +=3D `pkg-config --libs openssl`
+LIBREGLDLIBS +=3D `pkg-config --libs openssl`
=20
 ifeq ($(RUNTIME_PUBKEY_ONLY),1)
 CFLAGS +=3D -DRUNTIME_PUBKEY_ONLY
@@ -51,7 +51,7 @@ endif
=20
 else
 CFLAGS +=3D -DUSE_GCRYPT
-LDLIBS +=3D -lgcrypt
+LIBREGLDLIBS +=3D -lgcrypt
=20
 $(LIBREG): keys-gcrypt.c
=20
@@ -121,7 +121,7 @@ keys-%.c: utils/key2pub.py $(wildcard $(
=20
 $(LIBREG): regdb.h reglib.h reglib.c
 	$(NQ) '  CC  ' $@
-	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -shared -Wl,-soname,$(LIBREG) $^
+	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -shared -Wl,-soname,$(LIBREG) $^ $(=
LIBREGLDLIBS)
=20
 install-libreg-headers:
 	$(NQ) '  INSTALL  libreg-headers'

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-/LFS/uf6tNM/eEleMxai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU/jq8ue/yOyVhhEJAQpnchAAyJeYN7qDsdolQC03fmgHNf6V5/6SpRjK
fEfEcwtPvxB8NSv+RG8HwyTWY54FYa4ye0JVcQ5YklyrRzsm/XVier0UEJvfUIgF
8zHW76dQnwozChNAkNiQO9tIojoDJbGMANxEkmNgeChc7xKtOrzhniU4IN3QMYMc
mTjdm97NLV5V2MrjmtYoz8Y7pWqdSZ3tmTSpGPubuo027puK1jyPcbq+h5JPi2fj
2G4PzEGgd8VZ+hCnUqW+FrnNaunt82fmd8gEGYcOT++tJS/1Myxz/zE0JVetPtyh
E+YI14Sby9sQsrq9cY6NR8tnkpYwM57GVEo6MPfhPIWvkt65vckIk2QTwE8Zh6HJ
P0+spVi9/6jnjL2wrDGwKcQXmp4nP7WXNv7mKFnQS9I+oTywZQOtv2ocBCzxItx+
5GKDs6/1aY5Dtjk3iouJOlwJwh44TbKv+a9sjWexo3s7IgAOny60LdrVV755yB/k
p9lB0Kw/VhjKBOXFGUic9J5hAfWWLzvG8mcjrylA078ZpC0RAg7N+0qUsPc+ERfB
P8nmwZ6wRtYevCmx4+dVEEgNGBOf9iIK6bXKslHDjfCjjrVQYKOlenbRbS7rciNK
X+0JWpObTKXVocO/f6VWGy6h1KlBXYOh77Nqvgy4RUdx199g6aRkn7rkR0LnzDUo
2J4curLcRGk=
=2gYW
-----END PGP SIGNATURE-----

--=-/LFS/uf6tNM/eEleMxai--
