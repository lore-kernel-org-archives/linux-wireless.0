Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57111 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab1HWLih (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 07:38:37 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: pm_qos_params.h was renamed to pm_qos.h
Date: Tue, 23 Aug 2011 13:38:28 +0200
Message-Id: <1314099509-6123-1-git-send-email-hauke@hauke-m.de> (sfid-20110823_133839_926948_DD778E7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pm_qos.h was renamed to pm_qos_params.h in:
commit 1eee4691c3f058d1cf9757947ad9d9e03145a12c
Author: Jean Pihet <j-pihet@ti.com>
Date:   Thu Aug 18 10:31:55 2011 +0200

    PM QoS: Move and rename the implementation files

For older kernel versions the old header file should be used instead of the new one.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/pm_qos.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pm_qos.h

diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
new file mode 100644
index 0000000..c58c1c1
--- /dev/null
+++ b/include/linux/pm_qos.h
@@ -0,0 +1,12 @@
+#ifndef _COMPAT_LINUX_PM_QOS_H
+#define _COMPAT_LINUX_PM_QOS_H 1
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0))
+#include_next <linux/pm_qos.h>
+#else
+#include <linux/pm_qos_params.h>
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,0)) */
+
+#endif	/* _COMPAT_LINUX_PM_QOS_H */
-- 
1.7.4.1

