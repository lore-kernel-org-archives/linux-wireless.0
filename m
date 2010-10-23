Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55801 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab0JWSOP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 14:14:15 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Blaise Gassend <blaise@willowgarage.com>
Subject: [PATCH 1/3] compat: fix device_lock functions on non rt kernel
Date: Sat, 23 Oct 2010 20:13:59 +0200
Message-Id: <1287857641-7882-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_NONE and CONFIG_PREEMPT_VOLUNTARY are not added by the last RT
patch. I have not found any references to CONFIG_NONE, probably
CONFIG_PREEMPT_NONE was meant, but that is also wrong like
CONFIG_PREEMPT_VOLUNTARY. These two options are also in the normal kernel
config system without the rt patch.

This patch only checks for KConfig options added by the rt patch, but a
rt-patch user could also select PREEMPT_NONE or PREEMPT_VOLUNTARY, and
compat-wireless will not build. I do not think this will hapen often, so leave
it like this.

This patch fixes build with all non rt-kernels.

CC: Blaise Gassend <blaise@willowgarage.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 1cfd6e5..f710d08 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -142,8 +142,7 @@ do {								\
 
 static inline void device_lock(struct device *dev)
 {
-#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
-    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
+#if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
         mutex_lock(&dev->parent->mutex);
 #else
 	down(&dev->sem);
@@ -152,8 +151,7 @@ static inline void device_lock(struct device *dev)
 
 static inline int device_trylock(struct device *dev)
 {
-#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
-    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
+#if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
 	return mutex_trylock(&dev->mutex);
 #else
 	return down_trylock(&dev->sem);
@@ -162,8 +160,7 @@ static inline int device_trylock(struct device *dev)
 
 static inline void device_unlock(struct device *dev)
 {
-#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
-    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
+#if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT_DESKTOP)
         mutex_unlock(&dev->mutex);
 #else
 	up(&dev->sem);
-- 
1.7.0.4

