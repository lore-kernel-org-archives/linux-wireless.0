Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12118 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbbBYWRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 17:17:45 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath: support new FCC DFS Radar Type 1
Date: Wed, 25 Feb 2015 14:17:14 -0800
Message-ID: <1424902634-18275-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150225_231750_732846_E64FF246)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for new FCC DFS rules released on August 14, 2014.
FCC has added a new radar type named Radar Type 1 and original
Radar Type 1 is renamed to Radar Type 0 in consequence.
In fact, the type ID does nothing to functionalities.
In other words, even if we re-order the IDs, DFS detection will
work as well, but we give the ID with matching to FCC doc.

By adding this support, the drivers using this DFS function are
able to support both of old and new FCC DFS rules simultaneously
without any other changes.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 23 ++++++++++----------
 drivers/net/wireless/ath/dfs_pattern_detector.h |  5 +++++
 drivers/net/wireless/ath/dfs_pri_detector.c     | 29 ++++++++++++++++++++++---
 drivers/net/wireless/ath/dfs_pri_detector.h     |  4 ++--
 4 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index b1de8c6..65958ec 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -21,12 +21,6 @@
 #include "dfs_pri_detector.h"
 #include "ath.h"
 
-/*
- * tolerated deviation of radar time stamp in usecs on both sides
- * TODO: this might need to be HW-dependent
- */
-#define PRI_TOLERANCE	16
-
 /**
  * struct radar_types - contains array of patterns defined for one DFS domain
  * @domain: DFS regulatory domain
@@ -81,13 +75,18 @@ static const struct radar_types etsi_radar_types_v15 = {
 	PPB_THRESH(PPB), PRI_TOLERANCE,	CHIRP			\
 }
 
+/* radar types released on August 14, 2014
+ * type 1 PRI values randomly selected within the range of PMIN and PMAX,
+ * hence leave its PPB as 0 to be calculated on the fly.
+ */
 static const struct radar_detector_specs fcc_radar_ref_types[] = {
 	FCC_PATTERN(0, 0, 1, 1428, 1428, 1, 18, false),
-	FCC_PATTERN(1, 0, 5, 150, 230, 1, 23, false),
-	FCC_PATTERN(2, 6, 10, 200, 500, 1, 16, false),
-	FCC_PATTERN(3, 11, 20, 200, 500, 1, 12, false),
-	FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 1, true),
-	FCC_PATTERN(5, 0, 1, 333, 333, 1, 9, false),
+	FCC_PATTERN(1, 0, 1, 518, 3066, 1, 0, false),
+	FCC_PATTERN(2, 0, 5, 150, 230, 1, 23, false),
+	FCC_PATTERN(3, 6, 10, 200, 500, 1, 16, false),
+	FCC_PATTERN(4, 11, 20, 200, 500, 1, 12, false),
+	FCC_PATTERN(5, 50, 100, 1000, 2000, 1, 1, true),
+	FCC_PATTERN(6, 0, 1, 333, 333, 1, 9, false),
 };
 
 static const struct radar_types fcc_radar_types = {
@@ -199,7 +198,7 @@ channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
 		goto fail;
 
 	for (i = 0; i < dpd->num_radar_types; i++) {
-		const struct radar_detector_specs *rs = &dpd->radar_spec[i];
+		struct radar_detector_specs *rs = &dpd->radar_spec[i];
 		struct pri_detector *de = pri_detector_init(rs);
 		if (de == NULL)
 			goto fail;
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.h b/drivers/net/wireless/ath/dfs_pattern_detector.h
index 25a43d6..92be353 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.h
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.h
@@ -21,6 +21,11 @@
 #include <linux/list.h>
 #include <linux/nl80211.h>
 
+/* tolerated deviation of radar time stamp in usecs on both sides
+ * TODO: this might need to be HW-dependent
+ */
+#define PRI_TOLERANCE	16
+
 /**
  * struct ath_dfs_pool_stats - DFS Statistics for global pools
  */
diff --git a/drivers/net/wireless/ath/dfs_pri_detector.c b/drivers/net/wireless/ath/dfs_pri_detector.c
index 1b5ad19..a234329 100644
--- a/drivers/net/wireless/ath/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/dfs_pri_detector.c
@@ -21,6 +21,13 @@
 #include "dfs_pattern_detector.h"
 #include "dfs_pri_detector.h"
 
+#define FCC_TYPE1_MIN_PRI (518)
+#define FCC_TYPE1_MAX_PRI (3066)
+#define FCC_TYPE1_MIN_PPB (18)
+#define FCC_TYPE1_MAX_PPB (106)
+/* round up of ((1 / 360) * (19 * 1M)) */
+#define FCC_TYPE1_PPB_CONSTANT (52778)
+
 struct ath_dfs_pool_stats global_dfs_pool_stats = {};
 
 #define DFS_POOL_STAT_INC(c) (global_dfs_pool_stats.c++)
@@ -244,6 +251,13 @@ static bool pseq_handler_create_sequences(struct pri_detector *pde,
 		ps.first_ts = p->ts;
 		ps.last_ts = ts;
 		ps.pri = ts - p->ts;
+		if (pde->rs->ppb == 0) {
+			/* runtime calculation of ppb and ppb threshold for
+			 * pri in variable range. ppb threshold is half of ppb.
+			 */
+			pde->rs->ppb = FCC_TYPE1_PPB_CONSTANT / ps.pri;
+			pde->rs->ppb_thresh = (pde->rs->ppb / 2) + 1;
+		}
 		ps.dur = ps.pri * (pde->rs->ppb - 1)
 				+ 2 * pde->rs->max_pri_tolerance;
 
@@ -366,6 +380,14 @@ static void pri_detector_reset(struct pri_detector *pde, u64 ts)
 	}
 	pde->count = 0;
 	pde->last_ts = ts;
+	/* reset FCC type 1 ppb and threshold to be calculated again */
+	if (pde->rs->type_id == 1) {
+		if ((pde->rs->pri_min == FCC_TYPE1_MIN_PRI - PRI_TOLERANCE) &&
+		    (pde->rs->pri_max == FCC_TYPE1_MAX_PRI + PRI_TOLERANCE)) {
+			pde->rs->ppb = 0;
+			pde->rs->ppb_thresh = 0;
+		}
+	}
 }
 
 static void pri_detector_exit(struct pri_detector *de)
@@ -411,7 +433,7 @@ static struct pri_sequence *pri_detector_add_pulse(struct pri_detector *de,
 	return ps;
 }
 
-struct pri_detector *pri_detector_init(const struct radar_detector_specs *rs)
+struct pri_detector *pri_detector_init(struct radar_detector_specs *rs)
 {
 	struct pri_detector *de;
 
@@ -424,8 +446,9 @@ struct pri_detector *pri_detector_init(const struct radar_detector_specs *rs)
 
 	INIT_LIST_HEAD(&de->sequences);
 	INIT_LIST_HEAD(&de->pulses);
-	de->window_size = rs->pri_max * rs->ppb * rs->num_pri;
-	de->max_count = rs->ppb * 2;
+	de->window_size = rs->pri_max *
+		(rs->ppb ? rs->ppb : FCC_TYPE1_MIN_PPB) * rs->num_pri;
+	de->max_count = (rs->ppb ? rs->ppb : FCC_TYPE1_MAX_PPB) * 2;
 	de->rs = rs;
 
 	pool_register_ref();
diff --git a/drivers/net/wireless/ath/dfs_pri_detector.h b/drivers/net/wireless/ath/dfs_pri_detector.h
index 79f0fff..f460b46 100644
--- a/drivers/net/wireless/ath/dfs_pri_detector.h
+++ b/drivers/net/wireless/ath/dfs_pri_detector.h
@@ -63,7 +63,7 @@ struct pri_detector {
 	void (*reset)    (struct pri_detector *de, u64 ts);
 
 /* private: internal use only */
-	const struct radar_detector_specs *rs;
+	struct radar_detector_specs *rs;
 	u64 last_ts;
 	struct list_head sequences;
 	struct list_head pulses;
@@ -72,6 +72,6 @@ struct pri_detector {
 	u32 window_size;
 };
 
-struct pri_detector *pri_detector_init(const struct radar_detector_specs *rs);
+struct pri_detector *pri_detector_init(struct radar_detector_specs *rs);
 
 #endif /* DFS_PRI_DETECTOR_H */
-- 
1.9.1

