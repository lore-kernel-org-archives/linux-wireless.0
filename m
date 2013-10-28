Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43296 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab3J1Qme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 12:42:34 -0400
Received: by mail-wi0-f169.google.com with SMTP id cb5so3974084wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 09:42:33 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 6/6] crda: make reglib a shared library
Date: Mon, 28 Oct 2013 17:42:06 +0100
Message-Id: <1382978526-23929-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_174238_310259_B96496C0)
In-Reply-To: <1382978526-23929-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382978526-23929-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we have quite a few helpers this puts the more
valuable helpers into a library.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 Makefile | 48 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 9e37ccd..4a351c6 100644
--- a/Makefile
+++ b/Makefile
@@ -5,6 +5,8 @@ REG_GIT?=git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.g
 
 PREFIX ?= /usr/
 MANDIR ?= $(PREFIX)/share/man/
+INCLUDE_DIR ?= $(PREFIX)/include/reglib/
+LIBDIR ?= $(PREFIX)/lib
 
 SBINDIR ?= /sbin/
 
@@ -23,24 +25,29 @@ UDEV_RULE_DIR?=/lib/udev/rules.d/
 PUBKEY_DIR?=pubkeys
 RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
 
+CFLAGS += -O2 -fpic
+CFLAGS += -std=gnu99 -Wall -Werror -pedantic
 CFLAGS += -Wall -g
 LDLIBS += -lm
+LDLIBREG += -lreg
+LIBREG += libreg.so
+LDFLAGS += -L ./ $(LDLIBREG)
 
 all: all_noverify verify
 
-all_noverify: crda intersect regdbdump db2rd optimize
+all_noverify: $(LIBREG) crda intersect regdbdump db2rd optimize
 
 ifeq ($(USE_OPENSSL),1)
 CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
 LDLIBS += `pkg-config --libs openssl`
 
-reglib.o: keys-ssl.c
+$(LIBREG): keys-ssl.c
 
 else
 CFLAGS += -DUSE_GCRYPT
 LDLIBS += -lgcrypt
 
-reglib.o: keys-gcrypt.c
+$(LIBREG): keys-gcrypt.c
 
 endif
 MKDIR ?= mkdir -p
@@ -106,39 +113,56 @@ keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
 	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
 	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
 
-%.o: %.c regdb.h reglib.h
+$(LIBREG): regdb.h reglib.h reglib.c
+	$(NQ) '  CC  ' $@
+	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -shared -Wl,-soname,$(LIBREG) $^
+
+install-libreg-headers:
+	$(NQ) '  INSTALL  libreg-headers'
+	$(Q)mkdir -p $(INCLUDE_DIR)
+	$(Q)cp *.h $(INCLUDE_DIR)/
+
+install-libreg:
+	$(NQ) '  INSTALL  libreg'
+	$(Q)mkdir -p $(LIBDIR)
+	$(Q)cp $(LIBREG) $(LIBDIR)/
+	$(Q)ldconfig
+
+%.o: %.c regdb.h $(LIBREG)
 	$(NQ) '  CC  ' $@
 	$(Q)$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
 
-crda: reglib.o crda.o
+crda: crda.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS) $(NLLIBS)
 
-regdbdump: reglib.o regdbdump.o
+regdbdump: regdbdump.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
-intersect: reglib.o intersect.o
+intersect: intersect.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
-db2rd: reglib.o db2rd.o
+db2rd: db2rd.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
-optimize: reglib.o optimize.o
+optimize: optimize.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'
-	$(Q)./regdbdump $(REG_BIN) >/dev/null
+	$(Q)\
+		LD_LIBRARY_PATH=.:$(LD_LIBRARY_PATH) \
+		./regdbdump $(REG_BIN) >/dev/null
 
 %.gz: %
 	@$(NQ) ' GZIP' $<
 	$(Q)gzip < $< > $@
 
-install: crda crda.8.gz regdbdump.8.gz
+install: install-libreg install-libreg-headers crda crda.8.gz regdbdump.8.gz
 	$(NQ) '  INSTALL  crda'
 	$(Q)$(MKDIR) $(DESTDIR)/$(SBINDIR)
 	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) crda
@@ -161,6 +185,6 @@ install: crda crda.8.gz regdbdump.8.gz
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ regdbdump.8.gz
 
 clean:
-	$(Q)rm -f crda regdbdump intersect db2rd optimize \
+	$(Q)rm -f $(LIBREG) crda regdbdump intersect db2rd optimize \
 		*.o *~ *.pyc keys-*.c *.gz \
 	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
-- 
1.8.4.rc3

