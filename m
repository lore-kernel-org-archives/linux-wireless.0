Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50194 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935443Ab0HQScn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 14:32:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: backport init_dummy_netdev
Date: Tue, 17 Aug 2010 20:32:31 +0200
Message-Id: <1282069953-22360-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282069953-22360-1-git-send-email-hauke@hauke-m.de>
References: <1282069953-22360-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NETREG_DUMMY is not available for older kernels, it should be set to
something not normal. NETREG_DUMMY is set to 5 in new kernel versions.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.29.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.29.h |    2 ++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
index 2e7e623..a2354f9 100644
--- a/compat/compat-2.6.29.c
+++ b/compat/compat-2.6.29.c
@@ -124,6 +124,46 @@ int eth_validate_addr(struct net_device *dev)
 EXPORT_SYMBOL(eth_validate_addr);
 /* Source: net/ethernet/eth.c */
 
+#define NETREG_DUMMY 5
+/**
+ *	init_dummy_netdev	- init a dummy network device for NAPI
+ *	@dev: device to init
+ *
+ *	This takes a network device structure and initialize the minimum
+ *	amount of fields so it can be used to schedule NAPI polls without
+ *	registering a full blown interface. This is to be used by drivers
+ *	that need to tie several hardware interfaces to a single NAPI
+ *	poll scheduler due to HW limitations.
+ */
+int init_dummy_netdev(struct net_device *dev)
+{
+	/* Clear everything. Note we don't initialize spinlocks
+	 * are they aren't supposed to be taken by any of the
+	 * NAPI code and this dummy netdev is supposed to be
+	 * only ever used for NAPI polls
+	 */
+	memset(dev, 0, sizeof(struct net_device));
+
+	/* make sure we BUG if trying to hit standard
+	 * register/unregister code path
+	 */
+	dev->reg_state = NETREG_DUMMY;
+
+	/* initialize the ref count */
+	atomic_set(&dev->refcnt, 1);
+
+	/* NAPI wants this */
+	INIT_LIST_HEAD(&dev->napi_list);
+
+	/* a dummy interface is started by default */
+	set_bit(__LINK_STATE_PRESENT, &dev->state);
+	set_bit(__LINK_STATE_START, &dev->state);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(init_dummy_netdev);
+/* Source: net/core/dev.c */
+
 
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29) */
 
diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index a1a989c..cce678f 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -274,6 +274,8 @@ static inline struct net *read_pnet(struct net * const *pnet)
 
 #endif
 
+extern int		init_dummy_netdev(struct net_device *dev);
+
 #else
 
 static inline void netdev_attach_ops(struct net_device *dev,
-- 
1.7.0.4

