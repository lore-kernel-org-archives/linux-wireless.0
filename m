Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55811 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002Ab0JWSOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 14:14:17 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Blaise Gassend <blaise@willowgarage.com>
Subject: [PATCH 2/3] compat: lock correct mutex in device_lock
Date: Sat, 23 Oct 2010 20:14:00 +0200
Message-Id: <1287857641-7882-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1287857641-7882-1-git-send-email-hauke@hauke-m.de>
References: <1287857641-7882-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seams to be an error as all the other functions are working on the
other struct.

CC: Blaise Gassend <blaise@willowgarage.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index f710d08..763abca 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -143,7 +143,7 @@ do {								\
 static inline void device_lock(struct device *dev)
 {
 #if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
-        mutex_lock(&dev->parent->mutex);
+        mutex_lock(&dev->mutex);
 #else
 	down(&dev->sem);
 #endif
-- 
1.7.0.4

