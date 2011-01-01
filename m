Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39235 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1AAOYD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 09:24:03 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: add generic functions for suspend/resume
Date: Sat,  1 Jan 2011 15:23:35 +0100
Message-Id: <1293891815-22087-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1293891815-22087-1-git-send-email-hauke@hauke-m.de>
References: <1293891815-22087-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This define is used to generate a suspend and a resume function for pci
devices using the old power management interface. The new interface was
introduced in kernel 2.6.29.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.29.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index 78b2d58..b4e1236 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -278,6 +278,36 @@ static inline struct net *read_pnet(struct net * const *pnet)
 
 extern int		init_dummy_netdev(struct net_device *dev);
 
+#define compat_pci_suspend(fn)						\
+	int fn##_compat(struct pci_dev *pdev, pm_message_t state) 	\
+	{								\
+		int r;							\
+									\
+		r = fn(&pdev->dev);					\
+		if (r)							\
+			return r;					\
+									\
+		pci_save_state(pdev);					\
+		pci_disable_device(pdev);				\
+		pci_set_power_state(pdev, PCI_D3hot);			\
+									\
+		return 0;						\
+	}
+
+#define compat_pci_resume(fn)						\
+	int fn##_compat(struct pci_dev *pdev)				\
+	{								\
+		int r;							\
+									\
+		pci_set_power_state(pdev, PCI_D0);			\
+		r = pci_enable_device(pdev);				\
+		if (r)							\
+			return r;					\
+		pci_restore_state(pdev);				\
+									\
+		return fn(&pdev->dev);					\
+	}
+
 #else
 
 static inline void netdev_attach_ops(struct net_device *dev,
@@ -285,6 +315,10 @@ static inline void netdev_attach_ops(struct net_device *dev,
 {
 	dev->netdev_ops = ops;
 }
+
+#define compat_pci_suspend(fn)
+#define compat_pci_resume(fn)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
 #endif /*  LINUX_26_29_COMPAT_H */
-- 
1.7.1

