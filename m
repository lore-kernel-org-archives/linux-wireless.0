Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:41445 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYLAKbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 05:31:03 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1249994nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 02:31:01 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 2/5] Fix dependencies for parallel make and others.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 11:30:58 +0100
Message-ID: <20081201103058.18024.42199.stgit@localhost> (sfid-20081201_113108_275932_59339D52)
In-Reply-To: <20081201103016.18024.80454.stgit@localhost>
References: <20081201103016.18024.80454.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>

Since the keys .c files are included by reglib.c, it's not the final
output to depend on them but rather reglib.o.

This not only fixes proper regeneration of reglib.o when the pem files
are changed, but also allows proper parallel make of the package.

Signed-off-by: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>
---

 Makefile |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 25a92fe..ec06534 100644
--- a/Makefile
+++ b/Makefile
@@ -33,15 +33,17 @@ keys-%.c: utils/key2pub.py $(PUBKEY_DIR)/$(wildcard=
 *.pem)
 	$(NQ) '  CC  ' $@
 	$(Q)$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
=20
-crda: keys-ssl.c keys-gcrypt.c reglib.o crda.o
+reglib.o: keys-ssl.c keys-gcrypt.c
+
+crda: reglib.o crda.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o crda.o `pkg-config --li=
bs libnl-1` $(LDLIBS)
=20
-regdbdump: keys-ssl.c keys-gcrypt.c reglib.o regdbdump.o
+regdbdump: reglib.o regdbdump.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o regdbdump.o $(LDLIBS)
=20
-intersect: keys-ssl.c keys-gcrypt.c reglib.o intersect.o
+intersect: reglib.o intersect.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ reglib.o intersect.o $(LDLIBS)
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
