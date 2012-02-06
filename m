Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41337 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab2BFPif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 10:38:35 -0500
Received: by qcqw6 with SMTP id w6so3437181qcq.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 07:38:34 -0800 (PST)
From: Rick Farina <sidhayn@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Rick Farina <sidhayn@gmail.com>
Subject: [PATCH] Calling make directly is not permitted
Date: Mon,  6 Feb 2012 10:38:14 -0500
Message-Id: <1328542694-20777-1-git-send-email-sidhayn@gmail.com> (sfid-20120206_163839_986996_AF7A23A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

make was being called directly, fix to $(MAKE)

Signed-of-By: Rick Farina <sidhayn@gmail.com>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index d586f45..440bd91 100644
--- a/Makefile
+++ b/Makefile
@@ -115,7 +115,7 @@ btuninstall:
 	@echo
 
 btclean:
-	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) BT=TRUE clean
+	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(PWD) BT=TRUE clean
 	@rm -f $(CREL_PRE)*
 
 install: uninstall install-modules install-scripts
-- 
1.7.3.4

