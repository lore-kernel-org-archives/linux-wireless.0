Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53671 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934092AbZHHMia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 08:38:30 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/7] [compat-2.6] pcmcia_parse_tuple was redefined in pcmcia/cistpl.h
Date: Sat,  8 Aug 2009 14:38:12 +0200
Message-Id: <1249735096-27071-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix build:
undef pcmcia_parse_tuple before redefine it again.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
index fdc021a..e25259f 100644
--- a/compat/compat-2.6.28.h
+++ b/compat/compat-2.6.28.h
@@ -29,7 +29,13 @@
 })
 #endif /* From include/asm-generic/bug.h */
 
-#define pcmcia_parse_tuple(tuple, parse) pcmcia_parse_tuple(NULL, tuple, parse)
+#include <pcmcia/cs_types.h>
+#include <pcmcia/cs.h>
+#include <pcmcia/cistpl.h>
+#ifdef pcmcia_parse_tuple
+#undef pcmcia_parse_tuple
+#define pcmcia_parse_tuple(tuple, parse) pccard_parse_tuple(tuple, parse)
+#endif
 
 #if 0
 extern void usb_poison_urb(struct urb *urb);
-- 
1.6.2.1

