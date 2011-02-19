Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37955 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab1BSJWZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 04:22:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 01:22:04 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <mcgrof@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
Subject: [PATCH] compat: Define usleep_range(min, max) as msleep(max/1000) for <2.6.36
Date: Sat, 19 Feb 2011 01:22:21 -0800
Message-ID: <1298107341-9894-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ops_flush() of ath9k uses usleep_range().

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 include/linux/compat-2.6.36.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 74d2309..8d8b636 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -101,6 +101,7 @@ int no_printk(const char *s, ...) { return 0; }
 #define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active, 0)
 #endif
 
+#define usleep_range(_min, _max)	msleep((_max) / 1000)
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.0.4

