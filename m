Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:32106 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYLAKaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 05:30:55 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2608758ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 02:30:53 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 1/5] Fix building with --as-needed LD flag.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 11:30:51 +0100
Message-ID: <20081201103051.18024.82321.stgit@localhost> (sfid-20081201_113104_071150_C6368F00)
In-Reply-To: <20081201103016.18024.80454.stgit@localhost>
References: <20081201103016.18024.80454.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>

When using GNU ld --as-needed option, you need to ensure that the
order of parameters to the linker is formally correct, with libraries
coming after the object files. For this reason, don't use LDFLAGS for
passing the libraries, and make sure that LDLIBS goes at the end of
the line.

Signed-off-by: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>
---

 Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 91c4329..25a92fe 100644
--- a/Makefile
+++ b/Makefile
@@ -7,9 +7,9 @@ PUBKEY_DIR=3Dpubkeys
=20
 CFLAGS +=3D -Wall -g
 #CFLAGS +=3D -DUSE_OPENSSL `pkg-config --cflags openssl`
-#LDFLAGS +=3D `pkg-config --libs openssl`
+#LDLIBS +=3D `pkg-config --libs openssl`
 CFLAGS +=3D -DUSE_GCRYPT
-LDFLAGS +=3D -lgcrypt
+LDLIBS +=3D -lgcrypt
=20
 MKDIR ?=3D mkdir -p
 INSTALL ?=3D install
@@ -35,15 +35,15 @@ keys-%.c: utils/key2pub.py $(PUBKEY_DIR)/$(wildcard=
 *.pem)
=20
 crda: keys-ssl.c keys-gcrypt.c reglib.o crda.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) `pkg-config --libs libnl-1` -o $@ regl=
ib.o crda.o
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o crda.o `pkg-config --li=
bs libnl-1` $(LDLIBS)
=20
 regdbdump: keys-ssl.c keys-gcrypt.c reglib.o regdbdump.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o regdbdump.o
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o regdbdump.o $(LDLIBS)
=20
 intersect: keys-ssl.c keys-gcrypt.c reglib.o intersect.o
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o intersect.o
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o intersect.o $(LDLIBS)
=20
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
