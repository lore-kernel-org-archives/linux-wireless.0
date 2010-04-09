Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43050 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab0DIRub (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 13:50:31 -0400
Message-ID: <4BBF68DE.3080409@openwrt.org>
Date: Fri, 09 Apr 2010 19:50:22 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] compat: add rcu_dereference_check
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -162,6 +162,8 @@ static inline void device_unlock(struct
 	.prod_id_hash = { 0, 0, (vh3), 0 }, }
 #endif

+#define rcu_dereference_check(p, c) rcu_dereference(p)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */

 #endif /* LINUX_26_34_COMPAT_H */
