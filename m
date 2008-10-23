Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:21947 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbYJWXHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 19:07:49 -0400
Received: by fg-out-1718.google.com with SMTP id 19so743566fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 16:07:47 -0700 (PDT)
Date: Fri, 24 Oct 2008 01:07:42 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 6/6] Makefile improvements.
Message-ID: <20081023230742.GA8876@PesaBook.pesa.homelinux.org> (sfid-20081024_010751_646442_FBDB957A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  * use pkg-config for libnl and openssl
  * fix dir creation in the 'install' target
  * transform all 'keys-*.c' targets into a single pattern rule
  * better output in non-verbose mode
  * general cleanup

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>
---
 Makefile |   82 ++++++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 51 insertions(+), 31 deletions(-)

diff --git a/Makefile b/Makefile
index 69a2eba..8ea132b 100644
--- a/Makefile
+++ b/Makefile
@@ -3,34 +3,47 @@ KLIB := /lib/modules/$(shell uname -r)
 endif
 KLIB_BUILD ?= $(KLIB)/build
 
-CFLAGS += -Wall -g3
-#CFLAGS += -DUSE_OPENSSL
-#LDFLAGS += -lssl
 ifneq ($(COMPAT_TREE),)
 CFLAGS += -I$(COMPAT_TREE)/include/
 endif
-CFLAGS += -I$(KLIB_BUILD)/include -DUSE_GCRYPT
+
+CRDA_LIB := "/usr/lib/crda/"
+
+CFLAGS += -Wall -g -I$(KLIB_BUILD)/include
+#CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
+#LDFLAGS += `pkg-config --libs openssl`
+CFLAGS += -DUSE_GCRYPT
 LDFLAGS += -lgcrypt
 
 MKDIR ?= mkdir -p
 INSTALL ?= install
 
-CRDA_LIB = "/usr/lib/crda/"
+ifeq ($(V),1)
+Q=
+NQ=@true
+else
+Q=@
+NQ=@echo
+endif
 
 all: regulatory.bin warn crda
-	@$(MAKE) --no-print-directory -f Makefile verify
+	$(Q)$(MAKE) --no-print-directory -f Makefile verify
 
-regulatory.bin:	db2bin.py key.priv.pem db.txt dbparse.py
-	@./db2bin.py regulatory.bin db.txt key.priv.pem
+regulatory.bin: dbparse.py db2bin.py key.priv.pem db.txt
+	$(NQ) '  GEN ' $@
+	$(Q)./db2bin.py $@ db.txt key.priv.pem
 
-crda: keys-ssl.c keys-gcrypt.c regdb.h regdb.o crda.o
-	$(CC) $(CFLAGS) $(LDFLAGS) -lnl -o $@ regdb.o crda.o
+keys-%.c: key2pub.py $(wildcard *.pem)
+	$(NQ) '  GEN ' $@
+	$(Q)./key2pub.py --$* *.pem > $@
 
-clean:
-	@rm -f regulatory.bin crda dump *.o *~ *.pyc keys-*.c
-	@if test -f key.priv.pem && diff -qNs test-key key.priv.pem >/dev/null ; then \
-	rm -f key.priv.pem;\
-	fi
+%.o: %.c regdb.h
+	$(NQ) '  CC  ' $@
+	$(Q)$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
+
+crda: keys-ssl.c keys-gcrypt.c regdb.o crda.o
+	$(NQ) '  LD  ' $@
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) `pkg-config --libs libnl-1` -o $@ regdb.o crda.o
 
 warn:
 	@if test ! -f key.priv.pem || diff -qNs test-key key.priv.pem >/dev/null ; then \
@@ -41,25 +54,32 @@ warn:
 	fi
 
 key.priv.pem:
-	cp test-key key.priv.pem
+	$(Q)cp test-key key.priv.pem
 
 generate_key:
-	openssl genrsa -out key.priv.pem 2048
+	$(Q)openssl genrsa -out key.priv.pem 2048
 
-dump: keys-ssl.c keys-gcrypt.c regdb.h regdb.o dump.o
-	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ regdb.o dump.o
+dump: keys-ssl.c keys-gcrypt.c regdb.o dump.o
+	$(NQ) '  LD  ' $@
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ regdb.o dump.o
 
-keys-ssl.c: key2pub.py $(wildcard *.pem)
-	@./key2pub.py --ssl *.pem > keys-ssl.c
-
-keys-gcrypt.c: key2pub.py $(wildcard *.pem)
-	@./key2pub.py --gcrypt *.pem > keys-gcrypt.c
-
-verify: dump
-	@./dump regulatory.bin >/dev/null
+verify: regulatory.bin dump
+	$(NQ) '  CHK  regulatory.bin'
+	$(Q)./dump regulatory.bin >/dev/null
 
 install: regulatory.bin crda
-	$(MKDIR) $(DESTDIR)$(CRDA_LIB)
-	$(INSTALL) -m 644 -t $(DESTDIR)$(CRDA_LIB) regulatory.bin
-	$(INSTALL) -m 755 -t $(DESTDIR)/sbin/ crda
-	$(INSTALL) -m 644 -t $(DESTDIR)/etc/udev/rules.d/ regulatory.rules
+	$(NQ) '  INSTALL  crda'
+	$(Q)$(MKDIR) $(DESTDIR)/sbin
+	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/sbin/ crda
+	$(NQ) '  INSTALL  regulatory.bin'
+	$(Q)$(MKDIR) $(DESTDIR)$(CRDA_LIB)
+	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)$(CRDA_LIB) regulatory.bin
+	$(NQ) '  INSTALL  regulatory.rules'
+	$(Q)$(MKDIR) $(DESTDIR)/etc/udev/rules.d
+	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/etc/udev/rules.d/ regulatory.rules
+
+clean:
+	$(Q)rm -f regulatory.bin crda dump *.o *~ *.pyc keys-*.c
+	$(Q)if test -f key.priv.pem && diff -qNs test-key key.priv.pem >/dev/null ; then \
+		rm -f key.priv.pem;\
+	fi
-- 
1.6.0.2

