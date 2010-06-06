Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54572 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0FFJMm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:12:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat: use kernel pm_qos_params.h
Date: Sun,  6 Jun 2010 11:12:27 +0200
Message-Id: <1275815547-30313-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1275815547-30313-1-git-send-email-hauke@hauke-m.de>
References: <1275815547-30313-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not use pm_qos_params.h from compat-wireless if the kernel also
ships this file. In kernel 2.6.35 pm_qos_params.h changed and the in
kernel header file is needed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/pm_qos_params.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index 091c13c..e1f083c 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -1,3 +1,8 @@
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
+#include_next <linux/pm_qos_params.h>
+#else
 /* interface for the pm_qos_power infrastructure of the linux kernel.
  *
  * Mark Gross <mgross@linux.intel.com>
@@ -23,4 +28,5 @@ int pm_qos_requirement(int qos);
 
 int pm_qos_add_notifier(int qos, struct notifier_block *notifier);
 int pm_qos_remove_notifier(int qos, struct notifier_block *notifier);
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)) */
 
-- 
1.7.0.4

