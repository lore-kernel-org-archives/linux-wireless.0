Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39224 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab1AAOYA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 09:24:00 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: backport alloc_workqueue
Date: Sat,  1 Jan 2011 15:23:34 +0100
Message-Id: <1293891815-22087-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1293891815-22087-1-git-send-email-hauke@hauke-m.de>
References: <1293891815-22087-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by rtlwifi.

The function signature of __create_workqueue changed in kernel 2.6.28,
so two different defines are needed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.28.h |    2 ++
 include/linux/compat-2.6.36.h |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index b9024d6..fdb8fb2 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -236,6 +236,8 @@ extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 
 int pci_wake_from_d3(struct pci_dev *dev, bool enable);
 
+#define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
 
 #endif /* LINUX_26_28_COMPAT_H */
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 1f2f507..74d2309 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -97,6 +97,10 @@ struct pm_qos_request_list {
 static inline __attribute__ ((format (printf, 1, 2)))
 int no_printk(const char *s, ...) { return 0; }
 
+#ifndef alloc_workqueue
+#define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active, 0)
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.1

