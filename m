Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:29433 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab0CQPKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 11:10:42 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: change install command to make it compatible with ancient coreutils
Date: Wed, 17 Mar 2010 17:09:20 +0200
Message-Id: <1268838560-22354-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In older versions of the install tool from the GNU coreutils package, the -t
option is not supported.  The -t option can be safely replaced by the older
"install [OPTION]... SOURCE... DIRECTORY" format.

By changing the way we call install, we can make the iw tool more friendly to
ancient distributions.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index b0a4278..c51706b 100644
--- a/Makefile
+++ b/Makefile
@@ -86,10 +86,10 @@ check:
 install: iw iw.8.gz
 	@$(NQ) ' INST iw'
 	$(Q)$(MKDIR) $(DESTDIR)$(SBINDIR)
-	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)$(SBINDIR) iw
+	$(Q)$(INSTALL) -m 755 iw $(DESTDIR)$(SBINDIR)
 	@$(NQ) ' INST iw.8'
 	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man8/
-	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)$(MANDIR)/man8/ iw.8.gz
+	$(Q)$(INSTALL) -m 644 iw.8.gz $(DESTDIR)$(MANDIR)/man8/
 
 clean:
 	$(Q)rm -f iw *.o *~ *.gz version.c *-stamp
-- 
1.5.6.5

