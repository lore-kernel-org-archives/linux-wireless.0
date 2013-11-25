Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2976 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab3KYLI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 06:08:29 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
cc: backports@vger.kernel.org, "Arend van Spriel" <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] backport: need reinit_completion() for kernel before
 v3.13
Date: Mon, 25 Nov 2013 12:07:56 +0100
Message-ID: <1385377676-5106-1-git-send-email-arend@broadcom.com> (sfid-20131125_120832_720547_1B17DF46)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The use of INIT_COMPLETION() has been replaced by reinit_completion()
in v3.13-rc1. This patch backports that inline function.

Cc: <linux-wireless@vger.kernel.org>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 backport/backport-include/linux/completion.h |   29 ++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 backport/backport-include/linux/completion.h

diff --git a/backport/backport-include/linux/completion.h b/backport/backport-include/linux/completion.h
new file mode 100644
index 0000000..ed30d8a
--- /dev/null
+++ b/backport/backport-include/linux/completion.h
@@ -0,0 +1,29 @@
+#ifndef _BACKPORTS_LINUX_COMPLETION_H
+#define _BACKPORTS_LINUX_COMPLETION_H
+#include_next <linux/completion.h>
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,13,0))
+/**
+ * backport of:
+ *
+ * commit c32f74ab2872994bc8336ed367313da3139350ca
+ * Author: Wolfram Sang <wsa@the-dreams.de>
+ * Date:   Thu Nov 14 14:32:01 2013 -0800
+ *
+ *   sched: replace INIT_COMPLETION with reinit_completion
+ */
+/**
+ * reinit_completion - reinitialize a completion structure
+ * @x:  pointer to completion structure that is to be reinitialized
+ *
+ * This inline function should be used to reinitialize a completion structure so it can
+ * be reused. This is especially important after complete_all() is used.
+ */
+static inline void reinit_completion(struct completion *x)
+{
+	x->done = 0;
+}
+#endif
+
+#endif /* _BACKPORTS_LINUX_COMPLETION_H */
-- 
1.7.10.4


