Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60073 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab1GVQvW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 12:51:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: backport generic pr_fmt
Date: Fri, 22 Jul 2011 18:51:09 +0200
Message-Id: <1311353470-31012-1-git-send-email-hauke@hauke-m.de> (sfid-20110722_185125_248376_D1B43BB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.28.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index fdb8fb2..c92c8b4 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -238,6 +238,10 @@ int pci_wake_from_d3(struct pci_dev *dev, bool enable);
 
 #define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active)
 
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
 
 #endif /* LINUX_26_28_COMPAT_H */
-- 
1.7.4.1

