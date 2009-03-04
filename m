Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eta-ori.net ([91.121.142.51]:36482 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbZCDCnN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 21:43:13 -0500
Message-ID: <49ADEB0D.6070100@impulze.org> (sfid-20090304_034316_608480_B08D4EEB)
Date: Wed, 04 Mar 2009 03:44:29 +0100
From: Daniel Mierswa <impulze@impulze.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: CRDA_PATH fixes for wireless-regdb.git
Content-Type: multipart/mixed;
 boundary="------------020808000209050509080708"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020808000209050509080708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Heya, i just found that there was a typo in your Makefile and
debian-examples dir.
I fixed those plus also give the user the chance to override CRDA_PATH
(I use /lib64 since I like the idea of having all necessary stuff to get
wireless connected in superuser reach). :)
Feedback welcomed.

-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22



--------------020808000209050509080708
Content-Type: text/plain;
 name="wireless-regdb-CRDA_PATH.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wireless-regdb-CRDA_PATH.patch"

>From 14a0da690de4e8803809f5da970b42c953990f03 Mon Sep 17 00:00:00 2001
From: Daniel Mierswa <impulze@impulze.org>
Date: Thu, 5 Feb 2009 02:11:41 +0100
Subject: [PATCH] CDRA_PATH typo, also let user override CRDA_PATH

---
 Makefile             |    6 +++---
 debian-example/rules |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index a719f59..32626a1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 # Install prefix
 PREFIX = /usr
-CDRA_PATH = $(PREFIX)/lib/crda
+CRDA_PATH ?= $(PREFIX)/lib/crda
 
 MANDIR ?= $(PREFIX)/share/man/
 
@@ -32,7 +32,7 @@ key.priv.pem:
 # Distributions wishing to just use John's database
 # can just call make install.
 install: regulatory.bin.5.gz
-	install -o 0 -g 0 -m 755 -d $(DESTDIR)/$(CDRA_PATH)
-	install -o 0 -g 0 -m 644 regulatory.bin $(DESTDIR)/$(CDRA_PATH)/regulatory.bin
+	install -o 0 -g 0 -m 755 -d $(DESTDIR)/$(CRDA_PATH)
+	install -o 0 -g 0 -m 644 regulatory.bin $(DESTDIR)/$(CRDA_PATH)/regulatory.bin
 	mkdir -p $(DESTDIR)/$(MANDIR)/man5/
 	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.bin.5.gz
diff --git a/debian-example/rules b/debian-example/rules
index dab9255..34a08a5 100755
--- a/debian-example/rules
+++ b/debian-example/rules
@@ -3,8 +3,8 @@
 include /usr/share/cdbs/1/rules/debhelper.mk
 
 PREFIX = /usr
-CDRA_LIB = $(PREFIX)/lib/crda
+CRDA_LIB ?= $(PREFIX)/lib/crda
 
 install/wireless-regdb::
-	install -o 0 -g 0 -m 755 -d debian/$(cdbs_curpkg)/$(CDRA_LIB)
-	install -o 0 -g 0 -m 644 regulatory.bin debian/$(cdbs_curpkg)/$(CDRA_LIB)/regulatory.bin
+	install -o 0 -g 0 -m 755 -d debian/$(cdbs_curpkg)/$(CRDA_LIB)
+	install -o 0 -g 0 -m 644 regulatory.bin debian/$(cdbs_curpkg)/$(CRDA_LIB)/regulatory.bin
-- 
1.6.1.2




--------------020808000209050509080708--
