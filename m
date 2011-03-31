Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58875 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab1CaQVt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:21:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/4] compat: backport netdev_refcnt_read.
Date: Thu, 31 Mar 2011 18:21:32 +0200
Message-Id: <1301588495-16583-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Backport of upstream commit:
	29b4433d991c88d86ca48a4c1cc33c671475be4b
	net: percpu net_device refcount

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.37.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index e993f75..cee23a8 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -108,6 +108,8 @@ extern void compat_led_brightness_set(struct led_classdev *led_cdev,
 
 #define alloc_ordered_workqueue(name, flags) create_singlethread_workqueue(name)
 
+#define netdev_refcnt_read(a) atomic_read(&a->refcnt)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
-- 
1.7.1

