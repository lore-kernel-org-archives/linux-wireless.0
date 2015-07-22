Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:32872 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbbGVFVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 01:21:39 -0400
Received: by obdeg2 with SMTP id eg2so32207867obd.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 22:21:38 -0700 (PDT)
From: ahmed.taahir@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Taahir Ahmed <ahmed.taahir@gmail.com>
Subject: [PATCH 2/2] Small build system improvements.
Date: Wed, 22 Jul 2015 00:21:24 -0500
Message-Id: <1437542484-23409-3-git-send-email-ahmed.taahir@gmail.com> (sfid-20150722_072143_983442_A9F64C45)
In-Reply-To: <1437542484-23409-1-git-send-email-ahmed.taahir@gmail.com>
References: <1437542484-23409-1-git-send-email-ahmed.taahir@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Taahir Ahmed <ahmed.taahir@gmail.com>

Phony targets are properly declared.

User's CFLAGS are not clobbered with '-O2 -g' unless the user has set no
cflags.
---
 Makefile | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 4ce900c..b5aa8e3 100644
--- a/Makefile
+++ b/Makefile
@@ -29,17 +29,19 @@ RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
 # utils/key2pub.py.  Python 2.7 and 3.x are supported.
 BUILDTIME_PYTHON ?= python
 
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
@@ -122,11 +124,13 @@ $(LIBREG): regdb.h reglib.h reglib.c
 	$(NQ) '  CC  ' $@
 	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -shared -Wl,-soname,$(LIBREG) $^
 
+.PHONY: install-libreg-headers
 install-libreg-headers:
 	$(NQ) '  INSTALL  libreg-headers'
 	$(Q)mkdir -p $(DESTDIR)/$(INCLUDE_DIR)
 	$(Q)cp *.h $(DESTDIR)/$(INCLUDE_DIR)/
 
+.PHONY: install-libreg
 install-libreg:
 	$(NQ) '  INSTALL  libreg'
 	$(Q)mkdir -p $(DESTDIR)/$(LIBDIR)
@@ -167,6 +171,7 @@ verify: $(REG_BIN) regdbdump
 	@$(NQ) ' GZIP' $<
 	$(Q)gzip < $< > $@
 
+.PHONY: install
 install: install-libreg install-libreg-headers crda crda.8.gz regdbdump.8.gz
 	$(NQ) '  INSTALL  crda'
 	$(Q)$(MKDIR) $(DESTDIR)/$(SBINDIR)
@@ -189,6 +194,7 @@ install: install-libreg install-libreg-headers crda crda.8.gz regdbdump.8.gz
 	$(NQ) '  INSTALL  regdbdump.8.gz'
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ regdbdump.8.gz
 
+.PHONY: clean
 clean:
 	$(Q)rm -f $(LIBREG) crda regdbdump intersect db2rd optimize \
 		*.o *~ *.pyc keys-*.h *.gz \
-- 
2.3.6

