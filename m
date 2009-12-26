Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34993 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbZLZVot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2009 16:44:49 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: backport kfifo for libertas
Date: Sat, 26 Dec 2009 22:44:34 +0100
Message-Id: <1261863875-2730-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Second part of the kfifo backport.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.33.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 9bb0dbb..8123914 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -9,6 +9,7 @@
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
+#include <linux/kfifo.h>
 
 #define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 /* source: include/linux/if.h */
@@ -47,6 +48,13 @@ int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
 					 cisparse_t *parse,
 					 void *priv_data));
 
+/* Backport for kfifo
+ * kfifo_alloc and kfifo_free must be backported manually 
+ */
+#define kfifo_in(a, b, c) __kfifo_put(*a, b, c)
+#define kfifo_out(a, b, c) __kfifo_get(*a, b, c)
+#define kfifo_len(a) __kfifo_len(*a)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
 
 #endif /* LINUX_26_33_COMPAT_H */
-- 
1.6.3.3

