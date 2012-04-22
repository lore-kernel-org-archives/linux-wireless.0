Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51574 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab2DVV7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 17:59:34 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: add dummy file kmemleak.h
Date: Sun, 22 Apr 2012 23:59:25 +0200
Message-Id: <1335131965-20280-2-git-send-email-hauke@hauke-m.de> (sfid-20120422_235938_250767_7345DCF8)
In-Reply-To: <1335131965-20280-1-git-send-email-hauke@hauke-m.de>
References: <1335131965-20280-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers are including kmemleak.h directly and this causes a build
problem on old kernel versions as it is not available on all.
---
 include/linux/kmemleak.h |    5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 include/linux/kmemleak.h

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
new file mode 100644
index 0000000..83bd199
--- /dev/null
+++ b/include/linux/kmemleak.h
@@ -0,0 +1,5 @@
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
+#include_next <linux/kmemleak.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,25)) */
-- 
1.7.9.5

