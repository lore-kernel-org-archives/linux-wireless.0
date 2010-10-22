Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54543 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab0JVFv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 01:51:56 -0400
Received: by eye27 with SMTP id 27so506803eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 22:51:55 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 22:51:54 -0700
Message-ID: <AANLkTimqQqo2F+UD7j0OUXn_YF3EvkO5z6Njdo-=dhnY@mail.gmail.com>
Subject: [PATCH] compat: Fixes missing sem member in struct device for RT
 PREEMPT prior to 2.6.34
From: Blaise Gassend <blaise@willowgarage.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RT PREEMPT patch eliminates the sem member in struct device
breaking device_lock, device_unlock and device_trylock in kernels
prior to 2.6.34. The attached patch replaces the use of sem by a use
of mutex.

Signed-off-by: Blaise Gassend <blaise@willowgarage.com>

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 336c61b..5604c7e 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -142,17 +142,32 @@ do {

 static inline void device_lock(struct device *dev)
 {
+#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
+    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
+        mutex_lock(&dev->parent->mutex);
+#else
        down(&dev->sem);
+#endif
 }

 static inline int device_trylock(struct device *dev)
 {
+#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
+    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
+        return mutex_trylock(&dev->mutex);
+#else
        return down_trylock(&dev->sem);
+#endif
 }

 static inline void device_unlock(struct device *dev)
 {
+#if defined(CONFIG_NONE) || defined(CONFIG_PREEMPT_RT) || \
+    defined(CONFIG_PREEMPT_VOLUNTARY) || defined(CONFIG_PREEMPT_DESKTOP)
+        mutex_unlock(&dev->mutex);
+#else
        up(&dev->sem);
+#endif
 }

 #if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
