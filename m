Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47672 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0KJCV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:59 -0500
Received: by mail-qy0-f174.google.com with SMTP id 12so2500227qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:59 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 39/44] compat/2.6.29: protect headers inclusion
Date: Tue,  9 Nov 2010 21:20:21 -0500
Message-Id: <1289355626-25373-40-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.29.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index fa29806..b83aca0 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -2,7 +2,10 @@
 #define LINUX_26_29_COMPAT_H
 
 #include <linux/version.h>
+
 #include <linux/netdevice.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19))
 #include <linux/if_link.h>
 #endif
@@ -14,8 +17,6 @@
  */
 #include <linux/compat-2.6.32.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-
 #include <linux/skbuff.h>
 #include <linux/usb.h>
 
-- 
1.7.2.30.gc37d7.dirty

