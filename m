Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59607 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab0ISRmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 13:42:36 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat: pcmcia/cs.h is removed form new kernels
Date: Sun, 19 Sep 2010 19:42:11 +0200
Message-Id: <1284918131-32065-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284918131-32065-1-git-send-email-hauke@hauke-m.de>
References: <1284918131-32065-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On older kernel versions we have to include pcmcia/cs_types.h and
pcmcia/cs.h before pcmcia/cistpl.h.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/pcmcia/cistpl.h |   10 ++++++++++
 include/pcmcia/cs.h     |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)
 create mode 100644 include/pcmcia/cistpl.h
 delete mode 100644 include/pcmcia/cs.h

diff --git a/include/pcmcia/cistpl.h b/include/pcmcia/cistpl.h
new file mode 100644
index 0000000..789dc59
--- /dev/null
+++ b/include/pcmcia/cistpl.h
@@ -0,0 +1,10 @@
+#include <linux/version.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
+#include <pcmcia/cs_types.h>
+#endif
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)
+#include <pcmcia/cs.h>
+#endif
+
+#include_next <pcmcia/cistpl.h>
diff --git a/include/pcmcia/cs.h b/include/pcmcia/cs.h
deleted file mode 100644
index 1c5e0fa..0000000
--- a/include/pcmcia/cs.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _COMPAT_PCMCIA_CS_H
-#define _COMPAT_PCMCIA_CS_H
-#include <linux/version.h>
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
-#include <pcmcia/cs_types.h>
-#endif
-
-#include_next <pcmcia/cs.h>
-#endif
-- 
1.7.0.4

