Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:51462 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953AbbENVLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 17:11:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: kvalo@codeaurora.org
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: add module_bcma_driver()
Date: Thu, 14 May 2015 23:05:49 +0200
Message-Id: <1431637549-18611-1-git-send-email-hauke@hauke-m.de> (sfid-20150514_231123_647646_B12F19A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible to save some lines of code in drivers with an
simple bcma driver registration.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/bcma/bcma.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index e34f906..2ff4a99 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -305,6 +305,15 @@ int __bcma_driver_register(struct bcma_driver *drv, struct module *owner);
 
 extern void bcma_driver_unregister(struct bcma_driver *drv);
 
+/* module_bcma_driver() - Helper macro for drivers that don't do
+ * anything special in module init/exit.  This eliminates a lot of
+ * boilerplate.  Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit()
+ */
+#define module_bcma_driver(__bcma_driver) \
+	module_driver(__bcma_driver, bcma_driver_register, \
+			bcma_driver_unregister)
+
 /* Set a fallback SPROM.
  * See kdoc at the function definition for complete documentation. */
 extern int bcma_arch_register_fallback_sprom(
-- 
2.1.4

