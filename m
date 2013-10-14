Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:40003 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3JNJGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 05:06:22 -0400
Received: by mail-ea0-f171.google.com with SMTP id n15so3198396ead.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 02:06:21 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 4/4] ath9k/ath: move dfs pattern detector to ath
Date: Mon, 14 Oct 2013 11:06:06 +0200
Message-Id: <1381741566-2330-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131014_110627_234223_4DFEB24A)
In-Reply-To: <1381741566-2330-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1381741566-2330-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the DFS pattern detector code to the ath module so
the other Atheros drivers can make us of it. This makes
no functional changes.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/Makefile                  |    4 +++-
 drivers/net/wireless/ath/ath9k/Makefile            |    4 +---
 drivers/net/wireless/ath/ath9k/dfs.h               |    2 +-
 drivers/net/wireless/ath/ath9k/dfs_debug.c         |    2 +-
 .../ath/{ath9k => }/dfs_pattern_detector.c         |    2 +-
 .../ath/{ath9k => }/dfs_pattern_detector.h         |    0
 .../wireless/ath/{ath9k => }/dfs_pri_detector.c    |    2 +-
 .../wireless/ath/{ath9k => }/dfs_pri_detector.h    |    0
 8 files changed, 8 insertions(+), 8 deletions(-)
 rename drivers/net/wireless/ath/{ath9k => }/dfs_pattern_detector.c (99%)
 rename drivers/net/wireless/ath/{ath9k => }/dfs_pattern_detector.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/dfs_pri_detector.c (99%)
 rename drivers/net/wireless/ath/{ath9k => }/dfs_pri_detector.h (100%)

diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index fb05cfd..90b9d75 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -11,7 +11,9 @@ obj-$(CONFIG_ATH_COMMON)	+= ath.o
 ath-objs :=	main.o \
 		regd.o \
 		hw.o \
-		key.o
+		key.o \
+		dfs_pattern_detector.o \
+		dfs_pri_detector.o
 
 ath-$(CONFIG_ATH_DEBUG) += debug.o
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 75ee9e7..6205ef5 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -14,9 +14,7 @@ ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 ath9k-$(CONFIG_ATH9K_DFS_DEBUGFS) += dfs_debug.o
 ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += \
-		dfs.o \
-		dfs_pattern_detector.o \
-		dfs_pri_detector.o
+		dfs.o
 ath9k-$(CONFIG_PM_SLEEP) += wow.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
diff --git a/drivers/net/wireless/ath/ath9k/dfs.h b/drivers/net/wireless/ath/ath9k/dfs.h
index 3c839f0..c6fa3d5 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.h
+++ b/drivers/net/wireless/ath/ath9k/dfs.h
@@ -17,7 +17,7 @@
 
 #ifndef ATH9K_DFS_H
 #define ATH9K_DFS_H
-#include "dfs_pattern_detector.h"
+#include "../dfs_pattern_detector.h"
 
 #if defined(CONFIG_ATH9K_DFS_CERTIFIED)
 /**
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
index 990c376..90b8342 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -20,7 +20,7 @@
 
 #include "ath9k.h"
 #include "dfs_debug.h"
-#include "dfs_pattern_detector.h"
+#include "../dfs_pattern_detector.h"
 
 static struct ath_dfs_pool_stats dfs_pool_stats = { 0 };
 
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
similarity index 99%
rename from drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
rename to drivers/net/wireless/ath/dfs_pattern_detector.c
index c230ffc..a1a69c5 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -19,7 +19,7 @@
 
 #include "dfs_pattern_detector.h"
 #include "dfs_pri_detector.h"
-#include "../ath.h"
+#include "ath.h"
 
 /*
  * tolerated deviation of radar time stamp in usecs on both sides
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h b/drivers/net/wireless/ath/dfs_pattern_detector.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
rename to drivers/net/wireless/ath/dfs_pattern_detector.h
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c b/drivers/net/wireless/ath/dfs_pri_detector.c
similarity index 99%
rename from drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
rename to drivers/net/wireless/ath/dfs_pri_detector.c
index 17b5bf9..43b6081 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/dfs_pri_detector.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include "../ath.h"
+#include "ath.h"
 #include "dfs_pattern_detector.h"
 #include "dfs_pri_detector.h"
 
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h b/drivers/net/wireless/ath/dfs_pri_detector.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
rename to drivers/net/wireless/ath/dfs_pri_detector.h
-- 
1.7.9.5

