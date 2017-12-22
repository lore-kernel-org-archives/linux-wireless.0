Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38688 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbdLVGDM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 01:03:12 -0500
Received: from mail-io0-f198.google.com ([209.85.223.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSGQJ-0002e2-2o
        for linux-wireless@vger.kernel.org; Fri, 22 Dec 2017 06:03:11 +0000
Received: by mail-io0-f198.google.com with SMTP id t73so18835065iof.6
        for <linux-wireless@vger.kernel.org>; Thu, 21 Dec 2017 22:03:11 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/6] wireless-regdb: Restore generation of old format database files
Date: Fri, 22 Dec 2017 00:02:59 -0600
Message-Id: <20171222060303.14478-3-seth.forshee@canonical.com> (sfid-20171222_070344_739872_69627F79)
In-Reply-To: <20171222060303.14478-1-seth.forshee@canonical.com>
References: <20171222060303.14478-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes removed generation and installation of these files when
adding support for the new database format. We need to keep
generating these files to support distros still using CRDA, so
restore support for building and installing these files in the
makefile.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index e708982a453d..9532c29a1dc2 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,7 @@
 # Install prefix
 PREFIX ?= /usr
+CRDA_PATH ?= $(PREFIX)/lib/crda
+CRDA_KEY_PATH ?= $(CRDA_PATH)/pubkeys
 
 MANDIR ?= $(PREFIX)/share/man/
 
@@ -28,26 +30,33 @@ REGDB_AUTHOR ?= $(shell if [ -f $(DISTRO_PRIVKEY) ]; then \
 		fi)
 
 REGDB_PRIVKEY ?= ~/.wireless-regdb-$(REGDB_AUTHOR).key.priv.pem
+REGDB_PUBKEY ?= $(REGDB_AUTHOR).key.pub.pem
 REGDB_PUBCERT ?= $(REGDB_AUTHOR).x509.pem
 
+REGDB_UPSTREAM_PUBKEY ?= sforshee.key.pub.pem
+
 REGDB_CHANGED = $(shell $(SHA1SUM) -c --status sha1sum.txt >/dev/null 2>&1; \
         if [ $$? -ne 0 ]; then \
-                echo maintainer-clean $(REGDB_PUBCERT); \
+                echo maintainer-clean $(REGDB_PUBKEY) $(REGDB_PUBCERT); \
         fi)
 
 .PHONY: all clean mrproper install maintainer-clean install-distro-key
 
-all: $(REGDB_CHANGED) regulatory.db.p7s sha1sum.txt
+all: $(REGDB_CHANGED) regulatory.bin sha1sum.txt regulatory.db.p7s
 
 clean:
 	@rm -f *.pyc *.gz
 
 maintainer-clean: clean
-	@rm -f regulatory.db regulatory.db.p7s
+	@rm -f regulatory.bin regulatory.db regulatory.db.p7s
 
 mrproper: clean maintainer-clean
-	@echo Removed public key, regulatory.db* and compressed man pages
-	@rm -f $(REGDB_PUBCERT) .custom
+	@echo Removed public key, regulatory.bin, regulatory.db* and compressed man pages
+	@rm -f $(REGDB_PUBKEY) $(REGDB_PUBCERT) .custom
+
+regulatory.bin: db.txt $(REGDB_PRIVKEY) $(REGDB_PUBKEY)
+	@echo Generating $@ digitally signed by $(REGDB_AUTHOR)...
+	./db2bin.py regulatory.bin db.txt $(REGDB_PRIVKEY)
 
 regulatory.db: db.txt db2fw.py
 	@echo "Generating $@"
@@ -64,6 +73,10 @@ regulatory.db.p7s: regulatory.db $(REGDB_PRIVKEY) $(REGDB_PUBCERT)
 sha1sum.txt: db.txt
 	sha1sum $< > $@
 
+$(REGDB_PUBKEY): $(REGDB_PRIVKEY)
+	@echo "Generating public key for $(REGDB_AUTHOR)..."
+	openssl rsa -in $(REGDB_PRIVKEY) -out $(REGDB_PUBKEY) -pubout -outform PEM
+
 $(REGDB_PUBCERT): $(REGDB_PRIVKEY)
 	@echo "Generating certificate for $(REGDB_AUTHOR)..."
 	@openssl req -config regulatory.openssl.conf \
@@ -103,7 +116,13 @@ install-distro-key: maintainer-clean $(DISTRO_PRIVKEY)
 #	make maintainer-clean
 #	make
 #	sudo make install
-install: regulatory.db.5.gz
-	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.db
+install: regulatory.bin.5.gz regulatory.db.5.gz
+	install -m 755 -d $(DESTDIR)/$(CRDA_PATH)
+	install -m 755 -d $(DESTDIR)/$(CRDA_KEY_PATH)
+	if [ -f .custom ]; then \
+		install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(shell cat .custom); \
+	fi
+	install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(REGDB_UPSTREAM_PUBKEY)
+	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.bin regulatory.db
 	install -m 755 -d $(DESTDIR)/$(MANDIR)/man5/
-	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.db.5.gz
+	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.bin.5.gz
-- 
2.14.1
