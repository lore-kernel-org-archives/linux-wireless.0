Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43069 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbbCHDcr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 22:32:47 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 35F2C340894
	for <linux-wireless@vger.kernel.org>; Sun,  8 Mar 2015 03:32:47 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH crda] libreg: link against crypto libs
Date: Sat,  7 Mar 2015 22:32:45 -0500
Message-Id: <1425785565-26601-1-git-send-email-vapier@gentoo.org> (sfid-20150308_043251_063289_04B360A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since libreg uses funcs from the crypto lib, make sure we link them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 8e345a1..77708e6 100644
--- a/Makefile
+++ b/Makefile
@@ -117,7 +117,7 @@ keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
 
 $(LIBREG): regdb.h reglib.h reglib.c
 	$(NQ) '  CC  ' $@
-	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -shared -Wl,-soname,$(LIBREG) $^
+	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -shared -Wl,-soname,$(LIBREG) $^ $(LDLIBS)
 
 install-libreg-headers:
 	$(NQ) '  INSTALL  libreg-headers'
-- 
2.3.1

