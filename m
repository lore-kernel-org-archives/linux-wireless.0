Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33179 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591Ab1FIWFU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:05:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] compat: add bcma
Date: Fri, 10 Jun 2011 00:04:47 +0200
Message-Id: <1307657087-23900-5-git-send-email-hauke@hauke-m.de> (sfid-20110610_000525_519624_DA4579F9)
In-Reply-To: <1307657087-23900-1-git-send-email-hauke@hauke-m.de>
References: <1307657087-23900-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 include/linux/compat-3.0.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.0.h b/include/linux/compat-3.0.h
index 5d05093..667ea38 100644
--- a/include/linux/compat-3.0.h
+++ b/include/linux/compat-3.0.h
@@ -26,6 +26,26 @@ static inline int register_netdevice_name(struct net_device *dev)
 
 #define register_netdevice(dev) register_netdevice_name(dev)
 
+/* BCMA core, see drivers/bcma/ */
+#ifndef BCMA_CORE
+/* Broadcom's specific AMBA core, see drivers/bcma/ */
+struct bcma_device_id {
+	__u16	manuf;
+	__u16	id;
+	__u8	rev;
+	__u8	class;
+};
+#define BCMA_CORE(_manuf, _id, _rev, _class)  \
+	{ .manuf = _manuf, .id = _id, .rev = _rev, .class = _class, }
+#define BCMA_CORETABLE_END  \
+	{ 0, },
+
+#define BCMA_ANY_MANUF		0xFFFF
+#define BCMA_ANY_ID		0xFFFF
+#define BCMA_ANY_REV		0xFF
+#define BCMA_ANY_CLASS		0xFF
+#endif /* BCMA_CORE */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)) */
 
 #endif /* LINUX_3_0_COMPAT_H */
-- 
1.7.4.1

