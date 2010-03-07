Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33535 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0CGKU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 05:20:56 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Gus Wirth <gwirth79@gmail.com>
Subject: [PATCH 2/2] compat: backport device_{lock,trylock,unlock}
Date: Sun,  7 Mar 2010 11:20:41 +0100
Message-Id: <1267957241-5578-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1267957241-5578-1-git-send-email-hauke@hauke-m.de>
References: <1267957241-5578-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes build of ar9170.

CC: Gus Wirth <gwirth79@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index b5d1903..d189bee 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -139,6 +139,22 @@ do {								\
 #endif
 /* source: include/linux/netdevice.h */
 
+
+static inline void device_lock(struct device *dev)
+{
+	down(&dev->sem);
+}
+
+static inline int device_trylock(struct device *dev)
+{
+	return down_trylock(&dev->sem);
+}
+
+static inline void device_unlock(struct device *dev)
+{
+	up(&dev->sem);
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.6.3.3

