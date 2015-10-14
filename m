Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33058 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbbJNQhL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 12:37:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove cfg.h
Date: Wed, 14 Oct 2015 18:37:08 +0200
Message-Id: <1444840628-19054-1-git-send-email-johannes@sipsolutions.net> (sfid-20151014_183716_187050_8EAC4BC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The file contains just a single declaration that can easily
move to another file - remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 1 -
 net/mac80211/cfg.h         | 9 ---------
 net/mac80211/ieee80211_i.h | 2 ++
 net/mac80211/main.c        | 1 -
 4 files changed, 2 insertions(+), 11 deletions(-)
 delete mode 100644 net/mac80211/cfg.h

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 61c841aeff60..713cdbf6fb3c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -17,7 +17,6 @@
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
-#include "cfg.h"
 #include "rate.h"
 #include "mesh.h"
 #include "wme.h"
diff --git a/net/mac80211/cfg.h b/net/mac80211/cfg.h
deleted file mode 100644
index 2d51f62dc76c..000000000000
--- a/net/mac80211/cfg.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- * mac80211 configuration hooks for cfg80211
- */
-#ifndef __CFG_H
-#define __CFG_H
-
-extern const struct cfg80211_ops mac80211_config_ops;
-
-#endif /* __CFG_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 99735408e99d..04b62435f37e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -34,6 +34,8 @@
 #include "sta_info.h"
 #include "debug.h"
 
+extern const struct cfg80211_ops mac80211_config_ops;
+
 struct ieee80211_local;
 
 /* Maximum number of broadcast/multicast frames to buffer when some of the
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e2514fadc3d7..273c96de4910 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -31,7 +31,6 @@
 #include "mesh.h"
 #include "wep.h"
 #include "led.h"
-#include "cfg.h"
 #include "debugfs.h"
 
 void ieee80211_configure_filter(struct ieee80211_local *local)
-- 
2.5.1

