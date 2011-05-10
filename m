Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53245 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab1EJLKn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 07:10:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: backport ethtool_cmd_speed
Date: Tue, 10 May 2011 13:10:16 +0200
Message-Id: <1305025816-12538-3-git-send-email-hauke@hauke-m.de> (sfid-20110510_131047_932286_C8FD891E)
In-Reply-To: <1305025816-12538-1-git-send-email-hauke@hauke-m.de>
References: <1305025816-12538-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.27.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index b9d7029..ed2035c 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -20,6 +20,7 @@
 #include <linux/wireless.h>
 #include <linux/skbuff.h>
 #include <net/sch_generic.h>
+#include <linux/ethtool.h>
 
 #define PCI_PM_CAP_PME_SHIFT	11
 
@@ -238,6 +239,17 @@ static inline void debugfs_remove_recursive(struct dentry *dentry)
 
 #define dev_name(dev) dev_name((struct device *)dev)
 
+static inline void ethtool_cmd_speed_set(struct ethtool_cmd *ep,
+					 __u32 speed)
+{
+	ep->speed = (__u16)speed;
+}
+
+static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
+{
+	return ep->speed;
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
 
 #endif /* LINUX_26_27_COMPAT_H */
-- 
1.7.4.1

