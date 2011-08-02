Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41234 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab1HBVPa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 17:15:30 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] compat: add linux/export.h
Date: Tue,  2 Aug 2011 23:14:22 +0200
Message-Id: <1312319663-21654-4-git-send-email-hauke@hauke-m.de> (sfid-20110802_231534_911872_6DAA3AD8)
In-Reply-To: <1312319663-21654-1-git-send-email-hauke@hauke-m.de>
References: <1312319663-21654-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export will be added in linux-3.2, for older kernel versions the stuff
is in linux/module.h.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/export.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/export.h

diff --git a/include/linux/export.h b/include/linux/export.h
new file mode 100644
index 0000000..f7842b7
--- /dev/null
+++ b/include/linux/export.h
@@ -0,0 +1,12 @@
+#ifndef _COMPAT_LINUX_EXPORT_H
+#define _COMPAT_LINUX_EXPORT_H 1
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0))
+#include_next <linux/export.h>
+#else
+#include <linux/module.h>
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)) */
+
+#endif	/* _COMPAT_LINUX_EXPORT_H */
-- 
1.7.4.1

