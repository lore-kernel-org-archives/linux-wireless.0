Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55677 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaBNTAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 14:00:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] crda: Add DESTDIR support in install-libreg* rules in Makefile
Date: Fri, 14 Feb 2014 13:58:44 -0500
Message-Id: <1392404324-5153-1-git-send-email-linville@tuxdriver.com> (sfid-20140214_200021_222823_30F92BBF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 4a351c645bf4..807a53819453 100644
--- a/Makefile
+++ b/Makefile
@@ -119,13 +119,13 @@ $(LIBREG): regdb.h reglib.h reglib.c
 
 install-libreg-headers:
 	$(NQ) '  INSTALL  libreg-headers'
-	$(Q)mkdir -p $(INCLUDE_DIR)
-	$(Q)cp *.h $(INCLUDE_DIR)/
+	$(Q)mkdir -p $(DESTDIR)/$(INCLUDE_DIR)
+	$(Q)cp *.h $(DESTDIR)/$(INCLUDE_DIR)/
 
 install-libreg:
 	$(NQ) '  INSTALL  libreg'
-	$(Q)mkdir -p $(LIBDIR)
-	$(Q)cp $(LIBREG) $(LIBDIR)/
+	$(Q)mkdir -p $(DESTDIR)/$(LIBDIR)
+	$(Q)cp $(LIBREG) $(DESTDIR)/$(LIBDIR)/
 	$(Q)ldconfig
 
 %.o: %.c regdb.h $(LIBREG)
-- 
1.8.5.3

