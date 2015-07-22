Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36644 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999AbbGVAiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 20:38:16 -0400
Received: by oibn4 with SMTP id n4so134475600oib.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 17:38:15 -0700 (PDT)
From: ahmed.taahir@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Taahir Ahmed <ahmed.taahir@gmail.com>
Subject: [PATCH 2/2] Small build system improvements.
Date: Tue, 21 Jul 2015 19:37:46 -0500
Message-Id: <1437525466-27512-3-git-send-email-ahmed.taahir@gmail.com> (sfid-20150722_023820_390319_DC7A97EA)
In-Reply-To: <1437525466-27512-1-git-send-email-ahmed.taahir@gmail.com>
References: <1437525466-27512-1-git-send-email-ahmed.taahir@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Taahir Ahmed <ahmed.taahir@gmail.com>

Phony targets are properly declared.

User's CFLAGS are not clobbered with '-O2 -g' unless the user has set no
cflags.

Rename the generated file 'keys-*.c' to 'keys-*.h', so the general
object compilation pattern rule doesn't try to build it.
---
 Makefile | 16 ++++++++++------
 reglib.c |  4 ++--
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 65fc780..0b71916 100644
--- a/Makefile
+++ b/Makefile
@@ -25,30 +25,32 @@ UDEV_RULE_DIR?=/lib/udev/rules.d/
 PUBKEY_DIR?=pubkeys
 RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
 
-CFLAGS += -O2 -fpic
+CFLAGS ?= -O2 -g
+CFLAGS += -fPIC
 CFLAGS += -std=gnu99 -Wall -Werror -pedantic
-CFLAGS += -Wall -g
 LDLIBREG += -lreg
 LDLIBS += $(LDLIBREG)
 LDLIBS += -lm
 LIBREG += libreg.so
 LDFLAGS += -L ./
 
+.PHONY: all
 all: all_noverify verify
 
+.PHONY: all_noverify
 all_noverify: $(LIBREG) crda intersect regdbdump db2rd optimize
 
 ifeq ($(USE_OPENSSL),1)
 CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
 LDLIBS += `pkg-config --libs openssl`
 
-$(LIBREG): keys-ssl.c
+$(LIBREG): keys-ssl.h
 
 else
 CFLAGS += -DUSE_GCRYPT
 LDLIBS += -lgcrypt
 
-$(LIBREG): keys-gcrypt.c
+$(LIBREG): keys-gcrypt.h
 
 endif
 MKDIR ?= mkdir -p
@@ -109,7 +111,7 @@ $(REG_BIN):
 	$(NQ)
 	$(Q) exit 1
 
-keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
+keys-%.h: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
 	$(NQ) '  GEN ' $@
 	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
 	$(Q) python /utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
@@ -163,6 +165,7 @@ verify: $(REG_BIN) regdbdump
 	@$(NQ) ' GZIP' $<
 	$(Q)gzip < $< > $@
 
+.PHONY: install
 install: install-libreg install-libreg-headers crda crda.8.gz regdbdump.8.gz
 	$(NQ) '  INSTALL  crda'
 	$(Q)$(MKDIR) $(DESTDIR)/$(SBINDIR)
@@ -185,7 +188,8 @@ install: install-libreg install-libreg-headers crda crda.8.gz regdbdump.8.gz
 	$(NQ) '  INSTALL  regdbdump.8.gz'
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ regdbdump.8.gz
 
+.PHONY: clean
 clean:
 	$(Q)rm -f $(LIBREG) crda regdbdump intersect db2rd optimize \
-		*.o *~ *.pyc keys-*.c *.gz \
+		*.o *~ *.pyc keys-*.h *.gz \
 	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
diff --git a/reglib.c b/reglib.c
index e00e9b8..aecff96 100644
--- a/reglib.c
+++ b/reglib.c
@@ -31,11 +31,11 @@
 #include "reglib.h"
 
 #ifdef USE_OPENSSL
-#include "keys-ssl.c"
+#include "keys-ssl.h"
 #endif
 
 #ifdef USE_GCRYPT
-#include "keys-gcrypt.c"
+#include "keys-gcrypt.h"
 #endif
 
 int debug = 0;
-- 
2.3.6

