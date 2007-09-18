Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:48224 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755730AbXIRVnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 17:43:49 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/3] mac80211: rename ieee80211_cfg.h to cfg.h
Date: Tue, 18 Sep 2007 17:42:21 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Message-Id: <200709181742.21305.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

Might as well rename ieee80211_cfg.h to cfg.h to keep things consistent.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/cfg.c           |    2 +-
 net/mac80211/cfg.h           |    9 +++++++++
 net/mac80211/ieee80211.c     |    2 +-
 net/mac80211/ieee80211_cfg.h |    9 ---------
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b1c13bc..3018815 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -11,7 +11,7 @@
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
-#include "ieee80211_cfg.h"
+#include "cfg.h"
 
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 			       unsigned int type)
diff --git a/net/mac80211/cfg.h b/net/mac80211/cfg.h
new file mode 100644
index 0000000..7d7879f
--- /dev/null
+++ b/net/mac80211/cfg.h
@@ -0,0 +1,9 @@
+/*
+ * mac80211 configuration hooks for cfg80211
+ */
+#ifndef __CFG_H
+#define __CFG_H
+
+extern struct cfg80211_ops mac80211_config_ops;
+
+#endif /* __CFG_H */
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 784f03f..d287470 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -31,7 +31,7 @@
 #include "wme.h"
 #include "aes_ccm.h"
 #include "ieee80211_led.h"
-#include "ieee80211_cfg.h"
+#include "cfg.h"
 #include "debugfs.h"
 #include "debugfs_netdev.h"
 
diff --git a/net/mac80211/ieee80211_cfg.h b/net/mac80211/ieee80211_cfg.h
deleted file mode 100644
index 85ed2c9..0000000
--- a/net/mac80211/ieee80211_cfg.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- * mac80211 configuration hooks for cfg80211
- */
-#ifndef __IEEE80211_CFG_H
-#define __IEEE80211_CFG_H
-
-extern struct cfg80211_ops mac80211_config_ops;
-
-#endif /* __IEEE80211_CFG_H */

