Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48048 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbbCIWMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 18:12:08 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 67752340712
	for <linux-wireless@vger.kernel.org>; Mon,  9 Mar 2015 22:12:07 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH crda v2] libreg: link against crypto libs
Date: Mon,  9 Mar 2015 18:12:06 -0400
Message-Id: <1425939126-12478-1-git-send-email-vapier@gentoo.org> (sfid-20150309_231213_159027_6E34E5CB)
In-Reply-To: <1425785565-26601-1-git-send-email-vapier@gentoo.org>
References: <1425785565-26601-1-git-send-email-vapier@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since libreg uses funcs from the crypto lib, make sure we link them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- the current LDLIBS mess includes -lreg in there which we have to strip

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 8e345a1..5ba1664 100644
--- a/Makefile
+++ b/Makefile
@@ -117,7 +117,7 @@ keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
 
 $(LIBREG): regdb.h reglib.h reglib.c
 	$(NQ) '  CC  ' $@
-	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -shared -Wl,-soname,$(LIBREG) $^
+	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -shared -Wl,-soname,$(LIBREG) $^ $(filter-out -lreg,$(LDLIBS))
 
 install-libreg-headers:
 	$(NQ) '  INSTALL  libreg-headers'
-- 
2.3.1

