Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46888 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZFFRNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:13:25 -0400
Message-ID: <4A2AA3B5.5020202@web.de>
Date: Sat, 06 Jun 2009 19:13:25 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] ar9170-fw: Boostrap our own toolchain
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6531053613608FAC8C0A1482"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6531053613608FAC8C0A1482
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

To avoid semi-open binary toolchains: This patch adds a toolchain subdir
and Makefile to download, build and install our own gnu sh2 toolchain
into that directory.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---

 toolchain/Makefile |   54 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++
 1 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 toolchain/Makefile

diff --git a/.gitignore b/.gitignore
index 6dd924f..d2fa705 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,3 +5,6 @@
 fw.map
 *~
 *.dis
+toolchain/src
+toolchain/build
+toolchain/inst
diff --git a/toolchain/Makefile b/toolchain/Makefile
new file mode 100644
index 0000000..d5468eb
--- /dev/null
+++ b/toolchain/Makefile
@@ -0,0 +1,54 @@
+BINUTILS_VER=3D2.19.1
+BINUTILS_URL=3Dhttp://mirrors.kernel.org/gnu/binutils/binutils-$(BINUTIL=
S_VER).tar.bz2
+BINUTILS_TAR=3Dbinutils-$(BINUTILS_VER).tar.bz2
+
+NEWLIB_VER=3D1.17.0
+NEWLIB_URL=3Dftp://sources.redhat.com/pub/newlib/newlib-$(NEWLIB_VER).ta=
r.gz
+NEWLIB_TAR=3Dnewlib-$(NEWLIB_VER).tar.gz
+
+GCC_VER=3D4.3.3
+GCC_URL=3Dhttp://mirrors.kernel.org/gnu/gcc/gcc-$(GCC_VER)/gcc-core-$(GC=
C_VER).tar.bz2
+GCC_TAR=3Dgcc-core-$(GCC_VER).tar.bz2
+
+BASEDIR=3D$(shell pwd)
+
+all: gcc
+
+src/$(BINUTILS_TAR):
+	wget -P src $(BINUTILS_URL)
+
+src/$(NEWLIB_TAR):
+	wget -P src $(NEWLIB_URL)
+
+src/$(GCC_TAR):
+	wget -P src $(GCC_URL)
+
+src/binutils-$(BINUTILS_VER): src/$(BINUTILS_TAR)
+	tar -C src -xjf $<
+
+src/newlib-$(NEWLIB_VER): src/$(NEWLIB_TAR)
+	tar -C src -xzf $<
+
+src/gcc-$(GCC_VER): src/$(GCC_TAR) src/newlib-$(NEWLIB_VER)
+	tar -C src -xjf $<
+	ln -s $(BASEDIR)/src/newlib-$(NEWLIB_VER)/{newlib,libgloss} $@
+
+binutils: src/binutils-$(BINUTILS_VER)
+	mkdir -p build/binutils
+	cd build/binutils; \
+	$(BASEDIR)/$</configure --target=3Dsh-elf --prefix=3D$(BASEDIR)/inst; \=

+	$(MAKE); \
+	$(MAKE) install
+
+gcc: src/gcc-$(GCC_VER) binutils
+	mkdir -p build/gcc
+	cd build/gcc; \
+	$(BASEDIR)/$</configure --target=3Dsh-elf --prefix=3D$(BASEDIR)/inst -e=
nable-languages=3Dc --without-pkgversion --with-newlib; \
+	$(MAKE); \
+	$(MAKE) install
+
+clean:
+	rm -rf build inst
+
+distclean: clean
+	rm -rf src



--------------enig6531053613608FAC8C0A1482
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoqo7UACgkQniDOoMHTA+kXgwCfWiGY/hrBoRdvFhxmW3uJkFdQ
DrgAmwV9dZG2rW4V9gb9ZPleqyYYAs7b
=6tZU
-----END PGP SIGNATURE-----

--------------enig6531053613608FAC8C0A1482--
