Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:27867 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYLAKbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 05:31:12 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1007903eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 02:31:10 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 3/5] Make it possible to switch gcrypt/openssl via knob.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 11:31:07 +0100
Message-ID: <20081201103107.18024.38565.stgit@localhost> (sfid-20081201_113115_282127_AF786A7B)
In-Reply-To: <20081201103016.18024.80454.stgit@localhost>
References: <20081201103016.18024.80454.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>

By building with "make USE_OPENSSL=3D1", OpenSSL will be used in
libcrypt's stead. This also allows for properly depend just on the
keys-*.c source file that is actually going to be used.

Note that the all target is moved up so that it still hits as default
target.

Signed-off-by: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>
---

 Makefile |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index ec06534..4ac8495 100644
--- a/Makefile
+++ b/Makefile
@@ -6,11 +6,24 @@ REG_BIN?=3D/usr/lib/crda/regulatory.bin
 PUBKEY_DIR=3Dpubkeys
=20
 CFLAGS +=3D -Wall -g
-#CFLAGS +=3D -DUSE_OPENSSL `pkg-config --cflags openssl`
-#LDLIBS +=3D `pkg-config --libs openssl`
+
+all: crda intersect
+	$(Q)$(MAKE) --no-print-directory -f Makefile verify
+
+ifeq ($(USE_OPENSSL),1)
+CFLAGS +=3D -DUSE_OPENSSL `pkg-config --cflags openssl`
+LDLIBS +=3D `pkg-config --libs openssl`
+
+reglib.o: keys-ssl.c
+
+else
 CFLAGS +=3D -DUSE_GCRYPT
 LDLIBS +=3D -lgcrypt
=20
+reglib.o: keys-gcrypt.c
+
+endif
+
 MKDIR ?=3D mkdir -p
 INSTALL ?=3D install
=20
@@ -22,9 +35,6 @@ Q=3D@
 NQ=3D@echo
 endif
=20
-all: crda intersect
-	$(Q)$(MAKE) --no-print-directory -f Makefile verify
-
 keys-%.c: utils/key2pub.py $(PUBKEY_DIR)/$(wildcard *.pem)
 	$(NQ) '  GEN ' $@
 	$(Q)./utils/key2pub.py --$* $(PUBKEY_DIR)/*.pem > $@
@@ -33,8 +43,6 @@ keys-%.c: utils/key2pub.py $(PUBKEY_DIR)/$(wildcard *=
=2Epem)
 	$(NQ) '  CC  ' $@
 	$(Q)$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
=20
-reglib.o: keys-ssl.c keys-gcrypt.c
-
 crda: reglib.o crda.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o crda.o `pkg-config --li=
bs libnl-1` $(LDLIBS)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
