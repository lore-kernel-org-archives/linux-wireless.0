Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41121 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab1JDLMA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 07:12:00 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: add linux/of.h just when CONFIG_OF is set.
Date: Tue,  4 Oct 2011 13:11:47 +0200
Message-Id: <1317726707-23497-3-git-send-email-hauke@hauke-m.de> (sfid-20111004_131202_277297_C2B608B7)
In-Reply-To: <1317726707-23497-1-git-send-email-hauke@hauke-m.de>
References: <1317726707-23497-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel < 2.6.34 linux/of.h unconditionally includes asm/prom.h which
is not available on all architectures. In newer kernel versions this is
just included if CONFIG_OF is set. For these old kernel just include
linux/of.h when CONFIG_OF is set. This fixes a compile problem with
ath6kl as it uses linux/of.h only when CONFIG_OF is set.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/of.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/of.h

diff --git a/include/linux/of.h b/include/linux/of.h
new file mode 100644
index 0000000..c5dc87c
--- /dev/null
+++ b/include/linux/of.h
@@ -0,0 +1,16 @@
+#ifndef _COMPAT_LINUX_OF_H
+#define _COMPAT_LINUX_OF_H 1
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+#include_next <linux/of.h>
+#else
+
+#ifdef CONFIG_OF
+#include_next <linux/of.h>
+#endif /* CONFIG_OF */
+
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+
+#endif	/* _COMPAT_LINUX_OF_H */
-- 
1.7.4.1

