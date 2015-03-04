Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:39532 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384AbbCDTv7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 14:51:59 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 855D23406CE
	for <linux-wireless@vger.kernel.org>; Wed,  4 Mar 2015 19:51:58 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH crda 1/4] do not run ldconfig
Date: Wed,  4 Mar 2015 14:51:51 -0500
Message-Id: <1425498714-8654-1-git-send-email-vapier@gentoo.org> (sfid-20150304_205203_581074_0EC9FD69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mike Frysinger <vapier@chromium.org>

Let the distro/user deal with ldconfig updating.  Running it blindly like
this breaks DESTDIR installs as `ldconfig` only operates on system paths.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Makefile b/Makefile
index a3ead30..46c683d 100644
--- a/Makefile
+++ b/Makefile
@@ -127,7 +127,6 @@ install-libreg:
 	$(NQ) '  INSTALL  libreg'
 	$(Q)mkdir -p $(DESTDIR)/$(LIBDIR)
 	$(Q)cp $(LIBREG) $(DESTDIR)/$(LIBDIR)/
-	$(Q)ldconfig
 
 %.o: %.c regdb.h $(LIBREG)
 	$(NQ) '  CC  ' $@
-- 
2.3.1

