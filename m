Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58004 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1EPSKV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 14:10:21 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] compat: backport rcu_access_pointer
Date: Mon, 16 May 2011 20:10:18 +0200
Message-Id: <1305569419-87899-1-git-send-email-nbd@openwrt.org> (sfid-20110516_201025_682843_FF83A15F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/compat-2.6.34.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index d1f9d80..ad06a07 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -247,6 +247,7 @@ static inline int usb_disable_autosuspend(struct usb_device *udev)
 #define sdio_set_host_pm_flags(a, b) 0
 
 #define rcu_dereference_protected(p, c) (p)
+#define rcu_access_pointer(p)   ACCESS_ONCE(p)
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
-- 
1.7.3.2

