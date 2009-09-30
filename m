Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56372 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbZI3NUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 09:20:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [iw PATCH] default install to $(PREFIX)/sbin
Date: Wed, 30 Sep 2009 09:19:46 -0400
Message-Id: <1254316786-4670-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iw utility isn't generally useful to normal users, so move it to
$(PREFIX)/sbin with other system management executables.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
As "suggested" by Johannes... :-)

 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index cb5fcc1..68bef4d 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@
 MAKEFLAGS += --no-print-directory
 
 PREFIX ?= /usr
-BINDIR ?= $(PREFIX)/bin
+SBINDIR ?= $(PREFIX)/sbin
 MANDIR ?= $(PREFIX)/share/man
 PKG_CONFIG ?= pkg-config
 
@@ -85,8 +85,8 @@ check:
 
 install: iw iw.8.gz
 	@$(NQ) ' INST iw'
-	$(Q)$(MKDIR) $(DESTDIR)$(BINDIR)
-	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)$(BINDIR) iw
+	$(Q)$(MKDIR) $(DESTDIR)$(SBINDIR)
+	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)$(SBINDIR) iw
 	@$(NQ) ' INST iw.8'
 	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man8/
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)$(MANDIR)/man8/ iw.8.gz
-- 
1.6.2.5

