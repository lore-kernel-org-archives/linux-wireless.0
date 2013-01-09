Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36320 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757534Ab3AINSA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 08:18:00 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH] compat: fix compile errors when assembly is built into modules
Date: Wed,  9 Jan 2013 14:17:57 +0100
Message-Id: <1357737477-39830-1-git-send-email-nbd@openwrt.org> (sfid-20130109_141802_734748_DC394B9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On powerpc, modules can be compiled and linked with an assembly file, adding
missing symbols that the compiler references when using -Os.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/compat-2.6.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 00a5eda..34c49e6 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -1,6 +1,8 @@
 #ifndef LINUX_26_COMPAT_H
 #define LINUX_26_COMPAT_H
 
+#ifndef __ASSEMBLY__
+
 #include <linux/version.h>
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0))
 #include <linux/kconfig.h>
@@ -68,4 +70,6 @@ void compat_dependency_symbol(void);
 #include <linux/compat-3.7.h>
 #include <linux/compat-3.8.h>
 
+#endif /* __ASSEMBLY__ */
+
 #endif /* LINUX_26_COMPAT_H */
-- 
1.8.0.2

