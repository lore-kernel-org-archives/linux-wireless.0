Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45239 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab1HaWUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 18:20:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: add __always_unused
Date: Thu,  1 Sep 2011 00:20:10 +0200
Message-Id: <1314829212-27365-1-git-send-email-hauke@hauke-m.de> (sfid-20110901_002025_526040_7875DAD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.33.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 8aabda0..43f1989 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -138,6 +138,12 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
 #endif
 }
 
+#ifdef __GNUC__
+#define __always_unused			__attribute__((unused))
+#else
+#define __always_unused			/* unimplemented */
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
 
 #endif /* LINUX_26_33_COMPAT_H */
-- 
1.7.4.1

