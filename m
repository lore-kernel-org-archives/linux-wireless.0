Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58917 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462Ab1CaQWC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:22:02 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat: semaphore.h mpoved from asm/ to linux/
Date: Thu, 31 Mar 2011 18:21:35 +0200
Message-Id: <1301588495-16583-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1301588495-16583-1-git-send-email-hauke@hauke-m.de>
References: <1301588495-16583-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel <= 2.6.25 linux/semaphore.h does not exist.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/semaphore.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/semaphore.h

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
new file mode 100644
index 0000000..78af4db
--- /dev/null
+++ b/include/linux/semaphore.h
@@ -0,0 +1,12 @@
+#ifndef _COMPAT_LINUX_SEMAPHORE_H
+#define _COMPAT_LINUX_SEMAPHORE_H 1
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,25))
+#include_next <linux/semaphore.h>
+#else
+#include <asm/semaphore.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,25)) */
+
+#endif	/* _COMPAT_LINUX_SEMAPHORE_H */
-- 
1.7.1

