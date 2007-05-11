Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbXEKC7h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:59:37 -0400
Subject: [PATCH 12/19] libertas: Get rid of version.h
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:03:07 -0400
Message-Id: <1178852587.8607.38.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/main.c    |    7 +++++++
 drivers/net/wireless/libertas/version.h |    7 -------
 drivers/net/wireless/libertas/wext.c    |    2 --
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas/version.h b/drivers/net/wireless/libertas/version.h
index e86f65a..8b13789 100644
--- a/drivers/net/wireless/libertas/version.h
+++ b/drivers/net/wireless/libertas/version.h
@@ -1,8 +1 @@
-#define DRIVER_RELEASE_VERSION "320.p0"
-const char libertas_driver_version[] = "COMM-USB8388-" DRIVER_RELEASE_VERSION
-#ifdef  DEBUG
-    "-dbg"
-#endif
-    "";
-
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index dcbf102..b9b25ce 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -21,6 +21,13 @@
 #include "debugfs.h"
 #include "assoc.h"
 
+#define DRIVER_RELEASE_VERSION "320.p0"
+const char libertas_driver_version[] = "COMM-USB8388-" DRIVER_RELEASE_VERSION
+#ifdef  DEBUG
+    "-dbg"
+#endif
+    "";
+
 #ifdef ENABLE_PM
 static struct pm_dev *wlan_pm_dev = NULL;
 #endif
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 18629af..c62ffcd 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -17,7 +17,6 @@
 #include "defs.h"
 #include "dev.h"
 #include "join.h"
-#include "version.h"
 #include "wext.h"
 #include "assoc.h"
 
-- 
1.5.0.6



