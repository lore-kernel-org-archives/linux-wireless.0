Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:49828 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab2DTPUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 11:20:47 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com, qca-developer-program@qualcomm.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	achadd@qca.qualcomm.com, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: extend DFS detector stats in dfs_debugfs
Date: Fri, 20 Apr 2012 17:20:34 +0200
Message-Id: <1334935234-8310-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120420_172052_510465_56317CCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend debugfs entry for dfs_stats with DFS detection events
and shared pool statistics.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c              |    4 ++
 drivers/net/wireless/ath/ath9k/dfs_debug.c        |   46 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs_debug.h        |   45 ++++++++++++++++----
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c |   20 ++++++++-
 4 files changed, 104 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 92891f5..ecc8179 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -148,11 +148,13 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	DFS_STAT_INC(sc, pulses_total);
 	if ((rs->rs_phyerr != ATH9K_PHYERR_RADAR) &&
 	    (rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT)) {
 		ath_dbg(common, DFS,
 			"Error: rs_phyer=0x%x not a radar error\n",
 			rs->rs_phyerr);
+		DFS_STAT_INC(sc, pulses_no_dfs);
 		return;
 	}
 
@@ -188,7 +190,9 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 			"width=%d, rssi=%d, delta_ts=%llu\n",
 			pe.freq, pe.ts, pe.width, pe.rssi, pe.ts-last_ts);
 		last_ts = pe.ts;
+		DFS_STAT_INC(sc, pulses_processed);
 		if (pd != NULL && pd->add_pulse(pd, &pe)) {
+			DFS_STAT_INC(sc, radar_detected);
 			/*
 			 * TODO: forward radar event to DFS management layer
 			 */
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
index 106d031..702191c 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -21,9 +21,15 @@
 #include "ath9k.h"
 #include "dfs_debug.h"
 
+
+struct ath_dfs_pool_stats global_dfs_pool_stats = { 0 };
+
 #define ATH9K_DFS_STAT(s, p) \
 	len += snprintf(buf + len, size - len, "%28s : %10u\n", s, \
 			sc->debug.stats.dfs_stats.p);
+#define ATH9K_DFS_POOL_STAT(s, p) \
+	len += snprintf(buf + len, size - len, "%28s : %10u\n", s, \
+			global_dfs_pool_stats.p);
 
 static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
@@ -43,6 +49,9 @@ static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 			hw_ver->macVersion, hw_ver->macRev,
 			(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_DFS) ?
 					"enabled" : "disabled");
+	len += snprintf(buf + len, size - len, "Pulse detector statistics:\n");
+	ATH9K_DFS_STAT("pulse events reported   ", pulses_total);
+	ATH9K_DFS_STAT("invalid pulse events    ", pulses_no_dfs);
 	ATH9K_DFS_STAT("DFS pulses detected     ", pulses_detected);
 	ATH9K_DFS_STAT("Datalen discards        ", datalen_discards);
 	ATH9K_DFS_STAT("RSSI discards           ", rssi_discards);
@@ -50,6 +59,18 @@ static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 	ATH9K_DFS_STAT("Primary channel pulses  ", pri_phy_errors);
 	ATH9K_DFS_STAT("Secondary channel pulses", ext_phy_errors);
 	ATH9K_DFS_STAT("Dual channel pulses     ", dc_phy_errors);
+	len += snprintf(buf + len, size - len, "Radar detector statistics "
+			"(current DFS region: %d)\n", sc->dfs_detector->region);
+	ATH9K_DFS_STAT("Pulse events processed  ", pulses_processed);
+	ATH9K_DFS_STAT("Radars detected         ", radar_detected);
+	len += snprintf(buf + len, size - len, "Global Pool statistics:\n");
+	ATH9K_DFS_POOL_STAT("Pool references         ", pool_reference);
+	ATH9K_DFS_POOL_STAT("Pulses allocated        ", pulse_allocated);
+	ATH9K_DFS_POOL_STAT("Pulses alloc error      ", pulse_alloc_error);
+	ATH9K_DFS_POOL_STAT("Pulses in use           ", pulse_used);
+	ATH9K_DFS_POOL_STAT("Seqs. allocated         ", pseq_allocated);
+	ATH9K_DFS_POOL_STAT("Seqs. alloc error       ", pseq_alloc_error);
+	ATH9K_DFS_POOL_STAT("Seqs. in use            ", pseq_used);
 
 	if (len > size)
 		len = size;
@@ -60,6 +81,30 @@ static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 	return retval;
 }
 
+/* magic number to prevent accidental reset of DFS statistics */
+#define DFS_STATS_RESET_MAGIC	0x80000000
+static ssize_t write_file_dfs(struct file *file, const char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (strict_strtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val == DFS_STATS_RESET_MAGIC)
+		memset(&sc->debug.stats.dfs_stats, 0,
+		       sizeof(sc->debug.stats.dfs_stats));
+	return count;
+}
+
 static int ath9k_dfs_debugfs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -69,6 +114,7 @@ static int ath9k_dfs_debugfs_open(struct inode *inode, struct file *file)
 
 static const struct file_operations fops_dfs_stats = {
 	.read = read_file_dfs,
+	.write = write_file_dfs,
 	.open = ath9k_dfs_debugfs_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.h b/drivers/net/wireless/ath/ath9k/dfs_debug.h
index 4911724..e36810a 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.h
@@ -22,17 +22,23 @@
 #include "hw.h"
 
 /**
- * struct ath_dfs_stats - DFS Statistics
- *
- * @pulses_detected:  No. of pulses detected so far
- * @datalen_discards: No. of pulses discarded due to invalid datalen
- * @rssi_discards:    No. of pulses discarded due to invalid RSSI
- * @bwinfo_discards:  No. of pulses discarded due to invalid BW info
- * @pri_phy_errors:   No. of pulses reported for primary channel
- * @ext_phy_errors:   No. of pulses reported for extension channel
- * @dc_phy_errors:    No. of pulses reported for primary + extension channel
+ * struct ath_dfs_stats - DFS Statistics per wiphy
+ * @pulses_total:     pulses reported by HW
+ * @pulses_no_dfs:    pulses wrongly reported as DFS
+ * @pulses_detected:  pulses detected so far
+ * @datalen_discards: pulses discarded due to invalid datalen
+ * @rssi_discards:    pulses discarded due to invalid RSSI
+ * @bwinfo_discards:  pulses discarded due to invalid BW info
+ * @pri_phy_errors:   pulses reported for primary channel
+ * @ext_phy_errors:   pulses reported for extension channel
+ * @dc_phy_errors:    pulses reported for primary + extension channel
+ * @pulses_processed: pulses forwarded to detector
+ * @radar_detected:   radars detected
  */
 struct ath_dfs_stats {
+	/* pulse stats */
+	u32 pulses_total;
+	u32 pulses_no_dfs;
 	u32 pulses_detected;
 	u32 datalen_discards;
 	u32 rssi_discards;
@@ -40,18 +46,39 @@ struct ath_dfs_stats {
 	u32 pri_phy_errors;
 	u32 ext_phy_errors;
 	u32 dc_phy_errors;
+	/* pattern detection stats */
+	u32 pulses_processed;
+	u32 radar_detected;
 };
 
+/**
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
 #if defined(CONFIG_ATH9K_DFS_DEBUGFS)
 
 #define DFS_STAT_INC(sc, c) (sc->debug.stats.dfs_stats.c++)
 void ath9k_dfs_init_debug(struct ath_softc *sc);
 
+#define DFS_POOL_STAT_INC(c) (global_dfs_pool_stats.c++)
+#define DFS_POOL_STAT_DEC(c) (global_dfs_pool_stats.c--)
+extern struct ath_dfs_pool_stats global_dfs_pool_stats;
+
 #else
 
 #define DFS_STAT_INC(sc, c) do { } while (0)
 static inline void ath9k_dfs_init_debug(struct ath_softc *sc) { }
 
+#define DFS_POOL_STAT_INC(c) do { } while (0)
+#define DFS_POOL_STAT_DEC(c) do { } while (0)
 #endif /* CONFIG_ATH9K_DFS_DEBUGFS */
 
 #endif /* ATH9K_DFS_DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
index ecb6334..91b8dce 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
@@ -17,8 +17,10 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
+#include "ath9k.h"
 #include "dfs_pattern_detector.h"
 #include "dfs_pri_detector.h"
+#include "dfs_debug.h"
 
 /**
  * struct pri_sequence - sequence of pulses matching one PRI
@@ -101,6 +103,7 @@ static void pool_register_ref(void)
 {
 	spin_lock_bh(&pool_lock);
 	singleton_pool_references++;
+	DFS_POOL_STAT_INC(pool_reference);
 	spin_unlock_bh(&pool_lock);
 }
 
@@ -108,6 +111,7 @@ static void pool_deregister_ref(void)
 {
 	spin_lock_bh(&pool_lock);
 	singleton_pool_references--;
+	DFS_POOL_STAT_DEC(pool_reference);
 	if (singleton_pool_references == 0) {
 		/* free singleton pools with no references left */
 		struct pri_sequence *ps, *ps0;
@@ -115,10 +119,12 @@ static void pool_deregister_ref(void)
 
 		list_for_each_entry_safe(p, p0, &pulse_pool, head) {
 			list_del(&p->head);
+			DFS_POOL_STAT_DEC(pulse_allocated);
 			kfree(p);
 		}
 		list_for_each_entry_safe(ps, ps0, &pseq_pool, head) {
 			list_del(&ps->head);
+			DFS_POOL_STAT_DEC(pseq_allocated);
 			kfree(ps);
 		}
 	}
@@ -129,6 +135,7 @@ static void pool_put_pulse_elem(struct pulse_elem *pe)
 {
 	spin_lock_bh(&pool_lock);
 	list_add(&pe->head, &pulse_pool);
+	DFS_POOL_STAT_DEC(pulse_used);
 	spin_unlock_bh(&pool_lock);
 }
 
@@ -136,6 +143,7 @@ static void pool_put_pseq_elem(struct pri_sequence *pse)
 {
 	spin_lock_bh(&pool_lock);
 	list_add(&pse->head, &pseq_pool);
+	DFS_POOL_STAT_DEC(pseq_used);
 	spin_unlock_bh(&pool_lock);
 }
 
@@ -146,6 +154,7 @@ static struct pri_sequence *pool_get_pseq_elem(void)
 	if (!list_empty(&pseq_pool)) {
 		pse = list_first_entry(&pseq_pool, struct pri_sequence, head);
 		list_del(&pse->head);
+		DFS_POOL_STAT_INC(pseq_used);
 	}
 	spin_unlock_bh(&pool_lock);
 	return pse;
@@ -158,6 +167,7 @@ static struct pulse_elem *pool_get_pulse_elem(void)
 	if (!list_empty(&pulse_pool)) {
 		pe = list_first_entry(&pulse_pool, struct pulse_elem, head);
 		list_del(&pe->head);
+		DFS_POOL_STAT_INC(pulse_used);
 	}
 	spin_unlock_bh(&pool_lock);
 	return pe;
@@ -210,9 +220,11 @@ static bool pulse_queue_enqueue(struct pri_detector *pde, u64 ts)
 	if (p == NULL) {
 		p = kmalloc(sizeof(*p), GFP_KERNEL);
 		if (p == NULL) {
-			pr_err("failed to allocate pulse_elem\n");
+			DFS_POOL_STAT_INC(pulse_alloc_error);
 			return false;
 		}
+		DFS_POOL_STAT_INC(pulse_allocated);
+		DFS_POOL_STAT_INC(pulse_used);
 	}
 	INIT_LIST_HEAD(&p->head);
 	p->ts = ts;
@@ -288,8 +300,12 @@ static bool pseq_handler_create_sequences(struct pri_detector *pde,
 		new_ps = pool_get_pseq_elem();
 		if (new_ps == NULL) {
 			new_ps = kmalloc(sizeof(*new_ps), GFP_KERNEL);
-			if (new_ps == NULL)
+			if (new_ps == NULL) {
+				DFS_POOL_STAT_INC(pseq_alloc_error);
 				return false;
+			}
+			DFS_POOL_STAT_INC(pseq_allocated);
+			DFS_POOL_STAT_INC(pseq_used);
 		}
 		memcpy(new_ps, &ps, sizeof(ps));
 		INIT_LIST_HEAD(&new_ps->head);
-- 
1.7.4.1

