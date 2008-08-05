Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postfix1-g20.free.fr ([212.27.60.42]:35013 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391AbYHESHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 14:07:16 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix1-g20.free.fr (Postfix) with ESMTP id 9C44729057B6
	for <linux-wireless@vger.kernel.org>; Tue,  5 Aug 2008 20:07:14 +0200 (CEST)
From: Gabriel de Perthuis <Gabriel.de-Perthuis@laPoste.net>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linux-wireless@vger.kernel.org,
	Gabriel de Perthuis <Gabriel.de-Perthuis@laPoste.net>
Subject: [PATCH] Fix incorrect conditional nesting, that prevented inclusion of compat symbols.
Date: Tue,  5 Aug 2008 20:05:40 +0200
Message-Id: <1217959540-9612-1-git-send-email-Gabriel.de-Perthuis@laPoste.net> (sfid-20080805_200720_503672_CCF40A47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernels 2.6.23 or above didn't get these symbols:
device_create_vargs
device_create_drvdata
register_rfkill_notifier
unregister_rfkill_notifier
rfkill_force_state

Also fix a related comment typo found checking compat/compat.h .
---
 compat/compat.c |    6 +++---
 compat/compat.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/compat/compat.c b/compat/compat.c
index b1ec4d4..84e3ab3 100644
--- a/compat/compat.c
+++ b/compat/compat.c
@@ -640,6 +640,8 @@ int pci_try_set_mwi(struct pci_dev *dev)
 EXPORT_SYMBOL(pci_try_set_mwi);
 #endif
 
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)) */
+
 /* All things not in 2.6.25 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26))
 
@@ -744,7 +746,7 @@ struct device *device_create_drvdata(struct class *class,
 	return dev;
 }
 EXPORT_SYMBOL_GPL(device_create_drvdata);
-#endif
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26) */
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27))
 
@@ -839,5 +841,3 @@ EXPORT_SYMBOL(rfkill_force_state);
 
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27) */
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)) */
-
diff --git a/compat/compat.h b/compat/compat.h
index ec50750..75a498e 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -441,7 +441,7 @@ static inline void set_freezable(void) {}
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
 /* Added on 2.6.24 in include/linux/types.h by Al viro on commit 142956af */
 typedef unsigned long               uintptr_t;
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25)) */
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)) */
 
 
 
-- 
1.6.0.rc1.64.g61192

