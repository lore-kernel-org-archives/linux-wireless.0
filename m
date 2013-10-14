Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:33561 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3JNJGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 05:06:20 -0400
Received: by mail-ea0-f176.google.com with SMTP id q16so3219229ead.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 02:06:19 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/4] ath9k: dfs move ath_dfs_pool_stats
Date: Mon, 14 Oct 2013 11:06:04 +0200
Message-Id: <1381741566-2330-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131014_110624_805238_6FDB6A64)
In-Reply-To: <1381741566-2330-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1381741566-2330-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move ath_dfs_pool_stats to dfs_pattern_detector
code to be not specyfic only for ath9k.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/ath9k/dfs_debug.c         |    9 ++++++---
 drivers/net/wireless/ath/ath9k/dfs_debug.h         |   16 ----------------
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    7 +++++++
 .../net/wireless/ath/ath9k/dfs_pattern_detector.h  |   14 ++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c  |    8 ++++++--
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h  |    2 ++
 6 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
index 8215991..990c376 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -20,16 +20,16 @@
 
 #include "ath9k.h"
 #include "dfs_debug.h"
+#include "dfs_pattern_detector.h"
 
-
-struct ath_dfs_pool_stats global_dfs_pool_stats = { 0 };
+static struct ath_dfs_pool_stats dfs_pool_stats = { 0 };
 
 #define ATH9K_DFS_STAT(s, p) \
 	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
 			 sc->debug.stats.dfs_stats.p);
 #define ATH9K_DFS_POOL_STAT(s, p) \
 	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
-			 global_dfs_pool_stats.p);
+			 dfs_pool_stats.p);
 
 static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
@@ -44,6 +44,9 @@ static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
+	if (sc->dfs_detector)
+		dfs_pool_stats = sc->dfs_detector->get_stats(sc->dfs_detector);
+
 	len += scnprintf(buf + len, size - len, "DFS support for "
 			 "macVersion = 0x%x, macRev = 0x%x: %s\n",
 			 hw_ver->macVersion, hw_ver->macRev,
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.h b/drivers/net/wireless/ath/ath9k/dfs_debug.h
index e36810a..0a7ddf4 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.h
@@ -51,25 +51,11 @@ struct ath_dfs_stats {
 	u32 radar_detected;
 };
 
-/**
- * struct ath_dfs_pool_stats - DFS Statistics for global pools
- */
-struct ath_dfs_pool_stats {
-	u32 pool_reference;
-	u32 pulse_allocated;
-	u32 pulse_alloc_error;
-	u32 pulse_used;
-	u32 pseq_allocated;
-	u32 pseq_alloc_error;
-	u32 pseq_used;
-};
 #if defined(CONFIG_ATH9K_DFS_DEBUGFS)
 
 #define DFS_STAT_INC(sc, c) (sc->debug.stats.dfs_stats.c++)
 void ath9k_dfs_init_debug(struct ath_softc *sc);
 
-#define DFS_POOL_STAT_INC(c) (global_dfs_pool_stats.c++)
-#define DFS_POOL_STAT_DEC(c) (global_dfs_pool_stats.c--)
 extern struct ath_dfs_pool_stats global_dfs_pool_stats;
 
 #else
@@ -77,8 +63,6 @@ extern struct ath_dfs_pool_stats global_dfs_pool_stats;
 #define DFS_STAT_INC(sc, c) do { } while (0)
 static inline void ath9k_dfs_init_debug(struct ath_softc *sc) { }
 
-#define DFS_POOL_STAT_INC(c) do { } while (0)
-#define DFS_POOL_STAT_DEC(c) do { } while (0)
 #endif /* CONFIG_ATH9K_DFS_DEBUGFS */
 
 #endif /* ATH9K_DFS_DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
index c839a78..b0dcd1b 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
@@ -253,6 +253,12 @@ dpd_add_pulse(struct dfs_pattern_detector *dpd, struct pulse_event *event)
 	return false;
 }
 
+static struct ath_dfs_pool_stats
+dpd_get_stats(struct dfs_pattern_detector *dpd)
+{
+	return global_dfs_pool_stats;
+}
+
 static bool dpd_set_domain(struct dfs_pattern_detector *dpd,
 			   enum nl80211_dfs_regions region)
 {
@@ -283,6 +289,7 @@ static struct dfs_pattern_detector default_dpd = {
 	.exit		= dpd_exit,
 	.set_dfs_domain	= dpd_set_domain,
 	.add_pulse	= dpd_add_pulse,
+	.get_stats	= dpd_get_stats,
 	.region		= NL80211_DFS_UNSET,
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
index b09946f..9c75297 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
@@ -22,6 +22,19 @@
 #include <linux/nl80211.h>
 
 /**
+ * struct ath_dfs_pool_stats - DFS Statistics for global pools
+ */
+struct ath_dfs_pool_stats {
+	u32 pool_reference;
+	u32 pulse_allocated;
+	u32 pulse_alloc_error;
+	u32 pulse_used;
+	u32 pseq_allocated;
+	u32 pseq_alloc_error;
+	u32 pseq_used;
+};
+
+/**
  * struct pulse_event - describing pulses reported by PHY
  * @ts: pulse time stamp in us
  * @freq: channel frequency in MHz
@@ -77,6 +90,7 @@ struct dfs_pattern_detector {
 	bool (*add_pulse)(struct dfs_pattern_detector *dpd,
 			  struct pulse_event *pe);
 
+	struct ath_dfs_pool_stats (*get_stats)(struct dfs_pattern_detector *dpd);
 	enum nl80211_dfs_regions region;
 	u8 num_radar_types;
 	u64 last_pulse_ts;
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
index c718fc3..17b5bf9 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
@@ -17,10 +17,14 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include "ath9k.h"
+#include "../ath.h"
 #include "dfs_pattern_detector.h"
 #include "dfs_pri_detector.h"
-#include "dfs_debug.h"
+
+struct ath_dfs_pool_stats global_dfs_pool_stats = {};
+
+#define DFS_POOL_STAT_INC(c) (global_dfs_pool_stats.c++)
+#define DFS_POOL_STAT_DEC(c) (global_dfs_pool_stats.c--)
 
 /**
  * struct pulse_elem - elements in pulse queue
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
index 723962d..79f0fff 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
@@ -19,6 +19,8 @@
 
 #include <linux/list.h>
 
+extern struct ath_dfs_pool_stats global_dfs_pool_stats;
+
 /**
  * struct pri_sequence - sequence of pulses matching one PRI
  * @head: list_head
-- 
1.7.9.5

