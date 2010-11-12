Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34527 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932654Ab0KLTNC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:13:02 -0500
Message-ID: <4CDD91BA.6000003@openwrt.org>
Date: Fri, 12 Nov 2010 20:12:58 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2] compat: fix pm_qos_params compile error on 2.6.35
References: <4CDD70FA.40402@openwrt.org>
In-Reply-To: <4CDD70FA.40402@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linux 2.6.35 pm_qos_params.h is missing a #ifndef/define/endif around
its header file contents, causing a compile error when its functions
are overwritten by macros in the compat header files.
Fix this by adding these to the compat version of this header file.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -1,5 +1,8 @@
 #include <linux/version.h>

+#ifndef __COMPAT_LINUX_PM_QOS_PARAMS_H
+#define __COMPAT_LINUX_PM_QOS_PARAMS_H
+
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
 #include_next <linux/pm_qos_params.h>
 #else
@@ -30,3 +33,4 @@ int pm_qos_add_notifier(int qos, struct notifier_block *notifier);
 int pm_qos_remove_notifier(int qos, struct notifier_block *notifier);
 #endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)) */

+#endif
