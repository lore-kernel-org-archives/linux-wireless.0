Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50233 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0D1V2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 17:28:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: backport sk_sleep
Date: Wed, 28 Apr 2010 23:28:12 +0200
Message-Id: <1272490092-31341-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1272490092-31341-1-git-send-email-hauke@hauke-m.de>
References: <1272490092-31341-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.35.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 4d3483a..9132ecb 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -5,6 +5,7 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
 #include <linux/etherdevice.h>
+#include <net/sock.h>
 
 #define IW_HANDLER(id, func)			\
 	[IW_IOCTL_IDX(id)] = func
@@ -14,6 +15,11 @@
 
 #define netdev_hw_addr dev_mc_list
 
+static inline wait_queue_head_t *sk_sleep(struct sock *sk)
+{
+	return sk->sk_sleep;
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
-- 
1.6.3.3

