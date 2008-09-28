Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:54027 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbYI1UJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 16:09:13 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1467056muf.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 13:09:11 -0700 (PDT)
Date: Sun, 28 Sep 2008 22:09:04 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 4/4] Makefile: add support for DESTDIR.
Message-ID: <20080928200904.GA5988@PesaBook.pesa.homelinux.org> (sfid-20080928_220915_900579_39A8876D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Davide Pesavento <davidepesa@gmail.com>
---
 Makefile |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index c57e06c..de74bd5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 ifeq ($(origin $(KLIB)), undefined)
-KLIB:=          /lib/modules/$(shell uname -r)
+KLIB := /lib/modules/$(shell uname -r)
 endif
-KLIB_BUILD ?=   $(KLIB)/build
+KLIB_BUILD ?= $(KLIB)/build
 
 CFLAGS += -Wall -g3
 #CFLAGS += -DUSE_OPENSSL
@@ -12,7 +12,10 @@ endif
 CFLAGS += -I$(KLIB_BUILD)/include -DUSE_GCRYPT
 LDFLAGS += -lgcrypt
 
-CRDA_LIB="/usr/lib//crda/"
+MKDIR ?= mkdir -p
+INSTALL ?= install
+
+CRDA_LIB = "/usr/lib/crda/"
 
 all:	regulatory.bin warn crda
 	@$(MAKE) --no-print-directory -f Makefile verify
@@ -20,7 +23,7 @@ all:	regulatory.bin warn crda
 regulatory.bin:	db2bin.py key.priv.pem db.txt dbparse.py
 	@./db2bin.py regulatory.bin db.txt key.priv.pem
 
-crda: keys-gcrypt.c crda.c regdb.h
+crda: keys-gcrypt.c keys-ssl.c crda.c regdb.h
 	$(CC) $(CFLAGS) $(LDFLAGS) -lnl -o $@ crda.c
 
 clean:
@@ -53,7 +56,7 @@ verify: dump
 	@./dump regulatory.bin >/dev/null
 
 install: regulatory.bin crda
-	mkdir -p $(CRDA_LIB)
-	install regulatory.bin $(CRDA_LIB)
-	install crda /sbin/
-	install regulatory.rules /etc/udev/rules.d/
+	$(MKDIR) $(DESTDIR)$(CRDA_LIB)
+	$(INSTALL) -m 644 -t $(DESTDIR)$(CRDA_LIB) regulatory.bin
+	$(INSTALL) -m 755 -t $(DESTDIR)/sbin/ crda
+	$(INSTALL) -m 644 -t $(DESTDIR)/etc/udev/rules.d/ regulatory.rules
-- 
1.6.0.2

