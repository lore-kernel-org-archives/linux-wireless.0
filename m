Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49207 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757279Ab0KJXXV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 18:23:21 -0500
Message-ID: <4CDB2967.7030805@openwrt.org>
Date: Thu, 11 Nov 2010 00:23:19 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] compat: add a wrapper for rfkill.h
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this we can get rid of some of the rfkill related patching mess.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- /dev/null
+++ b/include/linux/rfkill.h
@@ -0,0 +1,32 @@
+#ifndef __COMPAT_RFKILL_H
+#define __COMPAT_RFKILL_H
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+
+#include_next <linux/rfkill.h>
+
+#else
+
+#include <linux/compat-2.6.h>
+
+#undef CONFIG_RFKILL
+#undef CONFIG_RFKILL_INPUT
+#undef CONFIG_RFKILL_LEDS
+
+#ifdef CONFIG_RFKILL_BACKPORT
+#define CONFIG_RFKILL 1
+#endif
+
+#ifdef CONFIG_RFKILL_BACKPORT_INPUT
+#define CONFIG_RFKILL_INPUT
+#endif
+
+#ifdef CONFIG_RFKILL_BACKPORT_LEDS
+#define CONFIG_RFKILL_LEDS
+#endif
+
+#include <linux/rfkill_backport.h>
+
+#endif
+
+#endif
