Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:35705 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbZF3VTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:19:06 -0400
Subject: [PATCH 2/5] Separate install target into exec, udev and man
 sub-parts.
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 16:19:10 -0500
Message-Id: <1246396750.13176.259.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the separate install sub-parts, the udev install can
be optional using the NO_INSTALL_UDEV option now.

Signed-off-by: Jon Loeliger <jdl@bigfootnetworks.com>
---
 Makefile |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 589c453..8dbdf14 100644
--- a/Makefile
+++ b/Makefile
@@ -72,6 +72,9 @@ Q=@
 NQ=@echo
 endif
 
+INSTALL_EXECS	:= crda
+INSTALL_MAN	:= crda.8.gz regdbdump.8.gz
+
 $(REG_BIN):
 	$(NQ) '  EXIST ' $(REG_BIN)
 	$(NQ)
@@ -113,12 +116,19 @@ verify: $(REG_BIN) regdbdump
 	@$(NQ) ' GZIP' $<
 	$(Q)gzip < $< > $@
 
-install: crda crda.8.gz regdbdump.8.gz
-	$(NQ) '  INSTALL  crda'
+
+install: install_execs install_udev install_man
+
+install_execs: $(INSTALL_EXECS)
 	$(Q)$(MKDIR) $(DESTDIR)/$(SBINDIR)
-	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) crda
-	$(NQ) '  INSTALL  regdbdump'
-	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) regdbdump
+	$(Q)for exec in $(INSTALL_EXECS) ; do \
+		echo "  INSTALL  $$exec" ; \
+		$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) $$exec ; \
+		done
+
+.PHONY: install_udev
+install_udev:
+ifndef NO_INSTALL_UDEV
 	$(NQ) '  INSTALL  $(UDEV_LEVEL)regulatory.rules'
 	$(Q)$(MKDIR) $(DESTDIR)/$(UDEV_RULE_DIR)/
 	@# This removes the old rule you may have, we were not
@@ -129,6 +139,9 @@ install: crda crda.8.gz regdbdump.8.gz
 	$(Q)$(INSTALL) -m 644 -t \
 		$(DESTDIR)/$(UDEV_RULE_DIR)/ \
 		udev/$(UDEV_LEVEL)regulatory.rules
+endif
+
+install_man: $(INSTALL_MAN)
 	$(NQ) '  INSTALL  crda.8.gz'
 	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man8/
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ crda.8.gz
-- 
1.6.3.GIT



