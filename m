Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58865 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab1EVKsJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 06:48:09 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: backport rcu_dereference_raw
Date: Sun, 22 May 2011 12:47:32 +0200
Message-Id: <1306061254-4197-1-git-send-email-hauke@hauke-m.de> (sfid-20110522_124812_207837_1A99EB64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index ad06a07..663a67e 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -249,6 +249,8 @@ static inline int usb_disable_autosuspend(struct usb_device *udev)
 #define rcu_dereference_protected(p, c) (p)
 #define rcu_access_pointer(p)   ACCESS_ONCE(p)
 
+#define rcu_dereference_raw(p)	rcu_dereference(p)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.7.4.1

