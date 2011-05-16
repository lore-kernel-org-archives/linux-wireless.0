Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58002 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab1EPSKV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 14:10:21 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] compat: backport rtnl_dereference
Date: Mon, 16 May 2011 20:10:19 +0200
Message-Id: <1305569419-87899-2-git-send-email-nbd@openwrt.org> (sfid-20110516_201025_157701_923DF44B)
In-Reply-To: <1305569419-87899-1-git-send-email-nbd@openwrt.org>
References: <1305569419-87899-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/compat-2.6.37.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index 57868f5..a83c9c7 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -112,6 +112,9 @@ extern void compat_led_brightness_set(struct led_classdev *led_cdev,
 
 extern void *vzalloc(unsigned long size);
 
+#define rtnl_dereference(p)                                     \
+        rcu_dereference_protected(p, lockdep_rtnl_is_held())
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
-- 
1.7.3.2

