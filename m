Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45282 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab1I1Snu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 14:43:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add IS_ERR_OR_NULL()
Date: Wed, 28 Sep 2011 20:43:44 +0200
Message-Id: <1317235424-14378-1-git-send-email-hauke@hauke-m.de> (sfid-20110928_204353_215874_59CF924F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.33.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 43f1989..386ee4c 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -144,6 +144,11 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
 #define __always_unused			/* unimplemented */
 #endif
 
+static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
+{
+	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
 
 #endif /* LINUX_26_33_COMPAT_H */
-- 
1.7.4.1

