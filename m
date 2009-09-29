Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40749 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZI2Rpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 13:45:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [rfkill PATCH] default install to $(PREFIX)/sbin
Date: Tue, 29 Sep 2009 13:41:37 -0400
Message-Id: <1254246097-4490-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rfkill utility isn't generally useful to normal users, so move it to
/sbin with other system management executables.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index cda48c4..71a6082 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 MAKEFLAGS += --no-print-directory
 
 PREFIX ?= /usr
-BINDIR ?= $(PREFIX)/bin
+SBINDIR ?= $(PREFIX)/sbin
 MANDIR ?= $(PREFIX)/share/man
 
 MKDIR ?= mkdir -p
@@ -48,8 +48,8 @@ check:
 
 install: rfkill rfkill.1.gz
 	@$(NQ) ' INST rfkill'
-	$(Q)$(MKDIR) $(DESTDIR)$(BINDIR)
-	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)$(BINDIR) rfkill
+	$(Q)$(MKDIR) $(DESTDIR)$(SBINDIR)
+	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)$(SBINDIR) rfkill
 	@$(NQ) ' INST rfkill.1'
 	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man1/
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)$(MANDIR)/man1/ rfkill.1.gz
-- 
1.6.2.5

