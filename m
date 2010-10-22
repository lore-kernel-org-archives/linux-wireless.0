Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47465 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0JVDNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 23:13:13 -0400
Received: by ewy7 with SMTP id 7so496972ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 20:13:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 20:13:11 -0700
Message-ID: <AANLkTik83ddeZtR-joexNSq2P_QW+V+TBTUq0AHpxLoj@mail.gmail.com>
Subject: Compat wireless breaks on kernels prior to 2.6.34 with the RT PREEMPT patch
From: Blaise Gassend <blaise@willowgarage.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Compat wireless seems to not work with the RT PREEMPT patch for
kernels prior to 2.6.34 because struct device does not contain sem. I
would love to submit a patch like the one below, but I do not know how
to detect that the RT PREEMPT patch has been applied. Does anybody
happen to know?

Thanks,
Blaise

--- compat-wireless-2010-10-09/include/linux/compat-2.6.34.h
2010-10-21 19:26:34.172694358 -0700
+++ compat-wireless-2010-10-09-original/include/linux/compat-2.6.34.h
 2010-10-21 19:23:10.494696161 -0700
@@ -139,32 +139,20 @@
 #endif
 /* source: include/linux/netdevice.h */

 static inline void device_lock(struct device *dev)
 {
-#ifdef XXX
-        mutex_lock(&dev->parent->mutex);
-#else
        down(&dev->sem);
-#endif
 }

 static inline int device_trylock(struct device *dev)
 {
-#ifdef XXX
-        return mutex_trylock(&dev->mutex);
-#else
        return down_trylock(&dev->sem);
-#endif
 }

 static inline void device_unlock(struct device *dev)
 {
-#ifdef XXX
-        mutex_unlock(&dev->mutex);
-#else
        up(&dev->sem);
-#endif
 }

 #if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
