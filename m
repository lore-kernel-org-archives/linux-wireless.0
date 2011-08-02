Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41237 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab1HBVPc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 17:15:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] compat: add linux/atmoic.h
Date: Tue,  2 Aug 2011 23:14:23 +0200
Message-Id: <1312319663-21654-5-git-send-email-hauke@hauke-m.de> (sfid-20110802_231539_577966_6B9581BD)
In-Reply-To: <1312319663-21654-1-git-send-email-hauke@hauke-m.de>
References: <1312319663-21654-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This include is needed by some drivers.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/atomic.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/atomic.h

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
new file mode 100644
index 0000000..378b748
--- /dev/null
+++ b/include/linux/atomic.h
@@ -0,0 +1,46 @@
+#ifndef _COMPAT_LINUX_ATOMIC_H
+#define _COMPAT_LINUX_ATOMIC_H 1
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,36))
+#include_next <linux/atomic.h>
+#else
+
+#include <asm/atomic.h>
+
+/**
+ * atomic_inc_not_zero_hint - increment if not null
+ * @v: pointer of type atomic_t
+ * @hint: probable value of the atomic before the increment
+ *
+ * This version of atomic_inc_not_zero() gives a hint of probable
+ * value of the atomic. This helps processor to not read the memory
+ * before doing the atomic read/modify/write cycle, lowering
+ * number of bus transactions on some arches.
+ *
+ * Returns: 0 if increment was not done, 1 otherwise.
+ */
+#ifndef atomic_inc_not_zero_hint
+static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
+{
+	int val, c = hint;
+
+	/* sanity test, should be removed by compiler if hint is a constant */
+	if (!hint)
+		return atomic_inc_not_zero(v);
+
+	do {
+		val = atomic_cmpxchg(v, c, c + 1);
+		if (val == c)
+			return 1;
+		c = val;
+	} while (c);
+
+	return 0;
+}
+#endif
+
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,36)) */
+
+#endif	/* _COMPAT_LINUX_ATOMIC_H */
-- 
1.7.4.1

