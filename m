Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65424 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbaEKIuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:50:08 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: add TX frame consecutive loss statistics
Date: Sun, 11 May 2014 11:47:23 +0300
Message-Id: <1399798043-20891-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140511_105016_206194_AF485E5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Measure TX frames consecutive loss statistics per station/TID.
These Measurements are disabled by default and can be enabled
via debugfs.

For each TID, the code will track statistics about

1. how many consecutie frames were lost, sorted into bins as
   requested by the user
2. how many frames where sent successfully but didn't get
   delivered quickly enough and are therefore considered lost

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/debugfs.c     | 212 ++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/debugfs_sta.c | 143 +++++++++++++++++++++++++++---
 net/mac80211/ieee80211_i.h |  24 ++++-
 net/mac80211/main.c        |   1 +
 net/mac80211/sta_info.c    |  53 +++++++++++-
 net/mac80211/sta_info.h    |  28 ++++++
 net/mac80211/status.c      | 182 ++++++++++++++++++++++++++++++--------
 net/mac80211/tx.c          |   7 +-
 8 files changed, 585 insertions(+), 65 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 0e963bc..3841c58 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -17,10 +17,10 @@
 
 #define DEBUGFS_FORMAT_BUFFER_SIZE 100
 
-#define TX_LATENCY_BIN_DELIMTER_C ','
-#define TX_LATENCY_BIN_DELIMTER_S ","
-#define TX_LATENCY_BINS_DISABLED "enable(bins disabled)\n"
-#define TX_LATENCY_DISABLED "disable\n"
+#define TX_TIMING_STATS_BIN_DELIMTER_C ','
+#define TX_TIMING_STATS_BIN_DELIMTER_S ","
+#define TX_TIMING_STATS_BINS_DISABLED "enable(bins disabled)\n"
+#define TX_TIMING_STATS_DISABLED "disable\n"
 
 
 /*
@@ -51,21 +51,21 @@ static ssize_t sta_tx_latency_stat_read(struct file *file,
 					 tx_latency->ranges[i]);
 		pos += scnprintf(buf + pos, bufsz - pos, "\n");
 	} else if (tx_latency) {
-		bufsz = sizeof(TX_LATENCY_BINS_DISABLED) + 1;
+		bufsz = sizeof(TX_TIMING_STATS_BINS_DISABLED) + 1;
 		buf = kzalloc(bufsz, GFP_ATOMIC);
 		if (!buf)
 			goto err;
 
 		pos += scnprintf(buf + pos, bufsz - pos, "%s\n",
-				 TX_LATENCY_BINS_DISABLED);
+				 TX_TIMING_STATS_BINS_DISABLED);
 	} else {
-		bufsz = sizeof(TX_LATENCY_DISABLED) + 1;
+		bufsz = sizeof(TX_TIMING_STATS_DISABLED) + 1;
 		buf = kzalloc(bufsz, GFP_ATOMIC);
 		if (!buf)
 			goto err;
 
 		pos += scnprintf(buf + pos, bufsz - pos, "%s\n",
-				 TX_LATENCY_DISABLED);
+				 TX_TIMING_STATS_DISABLED);
 	}
 
 	rcu_read_unlock();
@@ -125,7 +125,7 @@ static ssize_t sta_tx_latency_stat_write(struct file *file,
 					  lockdep_is_held(&local->sta_mtx));
 
 	/* disable Tx statistics */
-	if (!strcmp(buf, TX_LATENCY_DISABLED)) {
+	if (!strcmp(buf, TX_TIMING_STATS_DISABLED)) {
 		if (!tx_latency)
 			goto unlock;
 		RCU_INIT_POINTER(local->tx_latency, NULL);
@@ -138,11 +138,11 @@ static ssize_t sta_tx_latency_stat_write(struct file *file,
 	if (tx_latency)
 		goto unlock;
 
-	if (strcmp(TX_LATENCY_BINS_DISABLED, buf)) {
+	if (strcmp(TX_TIMING_STATS_BINS_DISABLED, buf)) {
 		/* check how many bins and between what ranges user requested */
 		token = buf;
 		while (*token != '\0') {
-			if (*token == TX_LATENCY_BIN_DELIMTER_C)
+			if (*token == TX_TIMING_STATS_BIN_DELIMTER_C)
 				n_ranges++;
 			token++;
 		}
@@ -158,7 +158,7 @@ static ssize_t sta_tx_latency_stat_write(struct file *file,
 	}
 	tx_latency->n_ranges = n_ranges;
 	for (i = 0; i < n_ranges; i++) { /* setting bin ranges */
-		token = strsep(&bins, TX_LATENCY_BIN_DELIMTER_S);
+		token = strsep(&bins, TX_TIMING_STATS_BIN_DELIMTER_S);
 		sscanf(token, "%d", &tx_latency->ranges[i]);
 		/* bins values should be in ascending order */
 		if (prev_bin >= tx_latency->ranges[i]) {
@@ -183,6 +183,193 @@ static const struct file_operations stats_tx_latency_ops = {
 	.llseek = generic_file_llseek,
 };
 
+/*
+ * Display if Tx consecutive loss statistics are enabled/disabled
+ */
+static ssize_t sta_tx_consecutive_loss_read(struct file *file,
+					    char __user *userbuf,
+					    size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	struct ieee80211_tx_consec_loss_ranges  *tx_consec;
+	char *buf;
+	size_t bufsz, i;
+	int ret;
+	u32 pos = 0;
+
+	rcu_read_lock();
+
+	tx_consec = rcu_dereference(local->tx_consec);
+
+	if (tx_consec && tx_consec->n_ranges) { /* enabled */
+		bufsz = tx_consec->n_ranges * 16;
+		buf = kzalloc(bufsz, GFP_ATOMIC);
+		if (!buf)
+			goto err;
+
+		pos += scnprintf(buf, bufsz, "bins: ");
+		for (i = 0; i < tx_consec->n_ranges; i++)
+			pos += scnprintf(buf + pos, bufsz - pos, "%u,",
+					 tx_consec->ranges[i]);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "\nlate threshold: %d\n",
+				 tx_consec->late_threshold);
+	} else { /* disabled */
+		bufsz = sizeof(TX_TIMING_STATS_DISABLED) + 1;
+		buf = kzalloc(bufsz, GFP_ATOMIC);
+		if (!buf)
+			goto err;
+
+		pos += scnprintf(buf + pos, bufsz - pos, "%s\n",
+				 TX_TIMING_STATS_DISABLED);
+	}
+
+	rcu_read_unlock();
+
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	kfree(buf);
+
+	return ret;
+err:
+	rcu_read_unlock();
+	return -ENOMEM;
+}
+
+/*
+ * Receive input from user regarding Tx consecutive loss statistics
+ * The input should indicate if Tx consecutive loss statistics are
+ * enabled/disabled.
+ * This entry keep track of 2 statistics to do with Tx consecutive loss:
+ * 1) How many consecutive packets were lost within the bin ranges
+ * 2) How many consecutive packets were sent successfully but the transmit
+ * latency is greater than the late threshold, therefor considered lost.
+ *
+ * Legal input is:
+ * a) "a,b,c,d,...z,threshold" - to enable consecutive loss statistics,
+ * where all are numbers and a < b < c < d.. < z
+ * b) "disable" - disable all statistics
+ * NOTE:
+ * 1) Must supply at least 2 values.
+ * 2) Last value is always the late threshold.
+ * 3) Must configure Tx consecutive loss statistics bins before stations
+ * connected.
+ */
+
+static ssize_t sta_tx_consecutive_loss_write(struct file *file,
+					     const char __user *userbuf,
+					     size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	char buf[128] = {};
+	char *bins = buf;
+	char *token;
+	u32 i, alloc_size;
+	u32 prev_bin = 0;
+	int n_ranges = 0;
+	int n_vals = 0;
+	int ret = count;
+	struct ieee80211_tx_consec_loss_ranges *tx_consec;
+
+	if (sizeof(buf) <= count)
+		return -EINVAL;
+
+	if (copy_from_user(buf, userbuf, count))
+		return -EFAULT;
+
+	mutex_lock(&local->sta_mtx);
+
+	/* cannot change config once we have stations */
+	if (local->num_sta)
+		goto unlock;
+
+	tx_consec =
+		rcu_dereference_protected(local->tx_consec,
+					  lockdep_is_held(&local->sta_mtx));
+
+	/* disable Tx statistics */
+	if (!strcmp(buf, TX_TIMING_STATS_DISABLED)) {
+		if (!tx_consec)
+			goto unlock;
+		rcu_assign_pointer(local->tx_consec, NULL);
+		synchronize_rcu();
+		kfree(tx_consec);
+		goto unlock;
+	}
+
+	/* Tx latency already enabled */
+	if (tx_consec)
+		goto unlock;
+
+	/* check how many bins and between what ranges user requested */
+	token = buf;
+	while (*token != '\0') {
+		if (*token == TX_TIMING_STATS_BIN_DELIMTER_C)
+			n_vals++;
+		token++;
+	}
+	n_vals++;
+	/* last value is for setting the late threshold */
+	n_ranges = n_vals - 1;
+
+	/*
+	 * user needs to enter at least 2 values, one for the threshold, and
+	 * one for the range
+	 */
+	if (n_vals < 2) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	alloc_size = sizeof(struct ieee80211_tx_consec_loss_ranges) +
+		     n_ranges * sizeof(u32);
+	tx_consec = kzalloc(alloc_size, GFP_ATOMIC);
+	if (!tx_consec) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	tx_consec->n_ranges = n_ranges;
+	for (i = 0; i < n_vals; i++) { /* setting bin ranges */
+		token = strsep(&bins, TX_TIMING_STATS_BIN_DELIMTER_S);
+
+		if (i == n_vals - 1) { /* last value - late threshold */
+			ret = sscanf(token, "%d", &tx_consec->late_threshold);
+			if (ret != 1) {
+				ret = -EINVAL;
+				kfree(tx_consec);
+				goto unlock;
+			}
+			break;
+		}
+		ret = sscanf(token, "%d", &tx_consec->ranges[i]);
+		if (ret != 1) {
+			ret = -EINVAL;
+			kfree(tx_consec);
+			goto unlock;
+		}
+
+		/* bins values should be in ascending order */
+		if (prev_bin >= tx_consec->ranges[i]) {
+			ret = -EINVAL;
+			kfree(tx_consec);
+			goto unlock;
+		}
+		prev_bin = tx_consec->ranges[i];
+	}
+	rcu_assign_pointer(local->tx_consec, tx_consec);
+
+unlock:
+	mutex_unlock(&local->sta_mtx);
+
+	return ret;
+}
+
+static const struct file_operations stats_tx_consecutive_loss_ops = {
+	.write = sta_tx_consecutive_loss_write,
+	.read = sta_tx_consecutive_loss_read,
+	.open = simple_open,
+	.llseek = generic_file_llseek,
+};
+
 int mac80211_format_buffer(char __user *userbuf, size_t count,
 				  loff_t *ppos, char *fmt, ...)
 {
@@ -483,4 +670,5 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_DEVSTATS_ADD(dot11RTSSuccessCount);
 
 	DEBUGFS_DEVSTATS_ADD(tx_latency);
+	DEBUGFS_DEVSTATS_ADD(tx_consecutive_loss);
 }
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 2ecb4de..7da8ca4 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -396,6 +396,108 @@ static ssize_t sta_last_rx_rate_read(struct file *file, char __user *userbuf,
 STA_OPS(last_rx_rate);
 
 static int
+sta_tx_consec_loss_stat_header(struct ieee80211_tx_consec_loss_ranges *tx_csc,
+			       char *buf, int pos, int bufsz)
+{
+	int i;
+	u32 range_count = tx_csc->n_ranges;
+	u32 *bin_ranges = tx_csc->ranges;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			  "Station\t\t\tTID\tType");
+	if (range_count) {
+		for (i = 0; i < range_count - 1; i++)
+			pos += scnprintf(buf + pos, bufsz - pos, "\t%d-%d",
+					  bin_ranges[i], bin_ranges[i+1]);
+
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "\t%d=<", bin_ranges[range_count - 1]);
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos, "\n");
+
+	return pos;
+}
+
+static int
+tx_consec_loss_stat_table(struct ieee80211_tx_consec_loss_ranges *tx_range,
+			  u32 bin_count, char *buf, int pos, int bufsz,
+			  u32 *bins, char *type, int tid)
+{
+	int j;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "\t\t\t%d\t%s", tid, type);
+
+	if (tx_range->n_ranges && bins)
+		for (j = 0; j < bin_count; j++)
+			pos += scnprintf(buf + pos, bufsz - pos,
+					  "\t%d", bins[j]);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "\n");
+
+	return pos;
+}
+
+/*
+ * Output stations Tx consecutive loss statistics
+ */
+static ssize_t sta_tx_consecutive_loss_stat_read(struct file *file,
+						 char __user *userbuf,
+						 size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_tx_consec_loss_ranges *tx_consec;
+	struct ieee80211_tx_consec_loss_stat *tx_csc;
+	char *buf;
+	size_t bufsz, i;
+	int ret;
+	size_t pos = 0;
+
+	bufsz = 100 * IEEE80211_NUM_TIDS;
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	rcu_read_lock();
+
+	tx_consec = rcu_dereference(local->tx_consec);
+
+	if (!sta->tx_consec) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "Tx consecutive loss statistics are not enabled\n");
+		goto unlock;
+	}
+
+	pos = sta_tx_consec_loss_stat_header(tx_consec, buf, pos, bufsz);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%pM\n", sta->sta.addr);
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+		tx_csc = &sta->tx_consec[i];
+		pos = tx_consec_loss_stat_table(tx_consec, tx_csc->bin_count,
+						buf, pos, bufsz,
+						tx_csc->late_bins,
+						"late", i);
+		pos = tx_consec_loss_stat_table(tx_consec, tx_csc->bin_count,
+						buf, pos, bufsz,
+						tx_csc->loss_bins,
+						"lost", i);
+		pos = tx_consec_loss_stat_table(tx_consec, tx_csc->bin_count,
+						buf, pos, bufsz,
+						tx_csc->total_loss_bins,
+						"total", i);
+	}
+unlock:
+	rcu_read_unlock();
+
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	kfree(buf);
+
+	return ret;
+}
+STA_OPS(tx_consecutive_loss_stat);
+
+static int
 sta_tx_latency_stat_header(struct ieee80211_tx_latency_bin_ranges *tx_latency,
 			   char *buf, int pos, int bufsz)
 {
@@ -492,33 +594,49 @@ unlock:
 }
 STA_OPS(tx_latency_stat);
 
-static ssize_t sta_tx_latency_stat_reset_write(struct file *file,
+static ssize_t sta_tx_timing_stats_reset_write(struct file *file,
 					       const char __user *userbuf,
 					       size_t count, loff_t *ppos)
 {
 	u32 *bins;
 	int bin_count;
+	u32 *loss_bins;
+	u32 *late_bins;
+	u32 *total_loss_bins;
+	u32 csc_bin_cnt;
+
 	struct sta_info *sta = file->private_data;
 	int i;
 
-	if (!sta->tx_lat)
+	if (!sta->tx_lat && !sta->tx_consec)
 		return -EINVAL;
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
-		bins = sta->tx_lat[i].bins;
-		bin_count = sta->tx_lat[i].bin_count;
-
-		sta->tx_lat[i].max = 0;
-		sta->tx_lat[i].sum = 0;
-		sta->tx_lat[i].counter = 0;
+		if (sta->tx_lat) {  /* latency stats enabled */
+			bins = sta->tx_lat[i].bins;
+			bin_count = sta->tx_lat[i].bin_count;
+			sta->tx_lat[i].max = 0;
+			sta->tx_lat[i].sum = 0;
+			sta->tx_lat[i].counter = 0;
+
+			if (bin_count)
+				memset(bins, 0, bin_count * sizeof(u32));
+		}
 
-		if (bin_count)
-			memset(bins, 0, bin_count * sizeof(u32));
+		if (sta->tx_consec) { /* consecutive loss stats enabled */
+			csc_bin_cnt = sta->tx_consec[i].bin_count;
+			late_bins = sta->tx_consec[i].late_bins;
+			loss_bins = sta->tx_consec[i].loss_bins;
+			total_loss_bins = sta->tx_consec[i].total_loss_bins;
+			memset(late_bins, 0, csc_bin_cnt * sizeof(u32));
+			memset(loss_bins, 0, csc_bin_cnt * sizeof(u32));
+			memset(total_loss_bins, 0, csc_bin_cnt * sizeof(u32));
+		}
 	}
 
 	return count;
 }
-STA_OPS_W(tx_latency_stat_reset);
+STA_OPS_W(tx_timing_stats_reset);
 
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, \
@@ -573,8 +691,9 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(last_ack_signal);
 	DEBUGFS_ADD(current_tx_rate);
 	DEBUGFS_ADD(last_rx_rate);
+	DEBUGFS_ADD(tx_consecutive_loss_stat);
 	DEBUGFS_ADD(tx_latency_stat);
-	DEBUGFS_ADD(tx_latency_stat_reset);
+	DEBUGFS_ADD(tx_timing_stats_reset);
 
 	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
 	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b455f62..88b120d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -926,6 +926,26 @@ struct tpt_led_trigger {
 #endif
 
 /*
+ * struct ieee80211_tx_consec_loss_ranges - Tx consecutive loss statistics
+ * bins ranges
+ *
+ * Measuring Tx consecutive loss  statistics.
+ * 1) Tx frames that were transmitted unsuccessfully.
+ * 2) Tx frames that were transmitted successfully, but there latency passed
+ * the late threshold, and therefor considered as transmitted unsuccessfully.
+ * The user can configure the ranges via debugfs.
+ *
+ * @late_threshold: the late threshold for the successful packets.
+ * @n_ranges: number of ranges that are taken in account
+ * @ranges: the ranges that the user requested or NULL if disabled.
+ */
+struct ieee80211_tx_consec_loss_ranges {
+	u32 late_threshold;
+	u32 n_ranges;
+	u32 ranges[];
+};
+
+/*
  * struct ieee80211_tx_latency_bin_ranges - Tx latency statistics bins ranges
  *
  * Measuring Tx latency statistics. Counts how many Tx frames transmitted in a
@@ -1096,9 +1116,11 @@ struct ieee80211_local {
 	int sta_generation;
 
 	/*
-	 * Tx latency statistics parameters for all stations.
+	 * Tx latency & consecutive loss statistics parameters for
+	 * all stations.
 	 * Can enable via debugfs (NULL when disabled).
 	 */
+	struct ieee80211_tx_consec_loss_ranges __rcu *tx_consec;
 	struct ieee80211_tx_latency_bin_ranges __rcu *tx_latency;
 
 	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 27b9364..c899bb1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1162,6 +1162,7 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 		     ieee80211_free_ack_frame, NULL);
 	idr_destroy(&local->ack_status_frames);
 
+	kfree(rcu_access_pointer(local->tx_consec));
 	kfree(rcu_access_pointer(local->tx_latency));
 
 	wiphy_free(local->hw.wiphy);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 632d372..e1fd1ad 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -237,6 +237,14 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 			kfree(sta->tx_lat[i].bins);
 		kfree(sta->tx_lat);
 	}
+	if (sta->tx_consec) {
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+			kfree(sta->tx_consec[i].late_bins);
+			kfree(sta->tx_consec[i].loss_bins);
+			kfree(sta->tx_consec[i].total_loss_bins);
+		}
+		kfree(sta->tx_consec);
+	}
 
 	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
 
@@ -303,7 +311,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	struct timespec uptime;
 	struct ieee80211_tx_latency_bin_ranges *tx_latency;
-	int i;
+	struct ieee80211_tx_consec_loss_ranges *tx_consec;
+	size_t i, size;
 
 	sta = kzalloc(sizeof(*sta) + local->hw.sta_data_size, gfp);
 	if (!sta)
@@ -336,6 +345,39 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 	}
+	tx_consec = rcu_dereference(local->tx_consec);
+	/* init stations Tx consecutive loss statistics */
+	if (tx_consec) {
+		size = sizeof(struct ieee80211_tx_consec_loss_stat);
+		sta->tx_consec = kzalloc(IEEE80211_NUM_TIDS * size,
+					 GFP_ATOMIC);
+		if (!sta->tx_consec) {
+			rcu_read_unlock();
+			goto free;
+		}
+
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+			sta->tx_consec[i].bin_count =
+				tx_consec->n_ranges;
+			sta->tx_consec[i].loss_bins =
+				kcalloc(sta->tx_consec[i].bin_count,
+					sizeof(u32), GFP_ATOMIC);
+			sta->tx_consec[i].late_bins =
+				kcalloc(sta->tx_consec[i].bin_count,
+					sizeof(u32), GFP_ATOMIC);
+			sta->tx_consec[i].total_loss_bins =
+				kcalloc(sta->tx_consec[i].bin_count,
+					sizeof(u32), GFP_ATOMIC);
+
+			if (!sta->tx_consec[i].loss_bins ||
+			    !sta->tx_consec[i].late_bins ||
+			    !sta->tx_consec[i].total_loss_bins) {
+				rcu_read_unlock();
+				goto free;
+			}
+		}
+	}
+
 	rcu_read_unlock();
 
 	spin_lock_init(&sta->lock);
@@ -417,6 +459,15 @@ free:
 			kfree(sta->tx_lat[i].bins);
 		kfree(sta->tx_lat);
 	}
+	if (sta->tx_consec) {
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+			kfree(sta->tx_consec[i].late_bins);
+			kfree(sta->tx_consec[i].loss_bins);
+			kfree(sta->tx_consec[i].total_loss_bins);
+		}
+		kfree(sta->tx_consec);
+	}
+
 	kfree(sta);
 	return NULL;
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4acc5fc..584b2b9 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -221,6 +221,32 @@ struct sta_ampdu_mlme {
 };
 
 /*
+ * struct ieee80211_tx_consec_loss_stat - Tx consecutive loss statistics
+ *
+ * Measures TX consecutive loss for a station per TID.
+ *
+ * @consec_late_loss: number of consecutive frames that passed the late
+ *	threshold and are considered  lost
+ * @consec_total_loss: number of consecutive frames that passed the late
+ *	threshold and are considered lost or were actually lost.
+ * @late_bins: each bin counts how many consecutive frames latency is
+ *	greater than the threshold in a certain range, and considered lost.
+ * @loss_bins: each bin counts how many consecutive frames were lost in a
+ *	certain range.
+ * @total_loss_bins: counts how mant consecutive packets were lost & late
+ *	within a certain range.
+ * @bin_count: amount of bins.
+ */
+struct ieee80211_tx_consec_loss_stat {
+	u32 consec_late_loss;
+	u32 consec_total_loss;
+	u32 *late_bins;
+	u32 *loss_bins;
+	u32 *total_loss_bins;
+	u32 bin_count;
+};
+
+/*
  * struct ieee80211_tx_latency_stat - Tx latency statistics
  *
  * Measures TX latency and jitter for a station per TID.
@@ -298,6 +324,7 @@ struct ieee80211_tx_latency_stat {
  * @tid_seq: per-TID sequence numbers for sending to this STA
  * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
+ * @tx_consec: Tx consecutive loss statistics
  * @tx_lat: Tx latency statistics
  * @llid: Local link ID
  * @plid: Peer link ID
@@ -407,6 +434,7 @@ struct sta_info {
 	struct sta_ampdu_mlme ampdu_mlme;
 	u8 timer_to_tid[IEEE80211_NUM_TIDS];
 
+	struct ieee80211_tx_consec_loss_stat *tx_consec;
 	struct ieee80211_tx_latency_stat *tx_lat;
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 60cb7a6..559005a 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -462,33 +462,148 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 	}
 }
 
+static void update_consec_bins(u32 *bins, u32 *bin_ranges, int bin_range_count,
+			       int msrmnt)
+{
+	int i;
+
+	for (i = bin_range_count - 1; 0 <= i; i--) {
+		if (bin_ranges[i] <= msrmnt) {
+			bins[i]++;
+			break;
+		}
+	}
+}
+
+/*
+ * Measure how many tx frames that were consecutively lost
+ * or that were sent successfully but  there latency passed
+ * a certain thershold and therefor considered lost.
+ */
+static void
+tx_consec_loss_msrmnt(struct ieee80211_tx_consec_loss_ranges *tx_consec,
+		      struct sta_info *sta, int tid, u32 msrmnt,
+		      int pkt_loss, bool send_failed)
+{
+	u32 bin_range_count;
+	u32 *bin_ranges;
+	struct ieee80211_tx_consec_loss_stat *tx_csc;
+
+	/* assert Tx consecutive packet loss stats are enabled */
+	if (!tx_consec)
+		return;
+
+	tx_csc = &sta->tx_consec[tid];
+
+	bin_range_count = tx_consec->n_ranges;
+	bin_ranges = tx_consec->ranges;
+
+	/*
+	 * count how many Tx frames were consecutively lost within the
+	 * appropriate range
+	 */
+
+	if (send_failed ||
+	    (!send_failed && tx_consec->late_threshold < msrmnt)) {
+		tx_csc->consec_total_loss++;
+	} else {
+		update_consec_bins(tx_csc->total_loss_bins, bin_ranges,
+				   bin_range_count, tx_csc->consec_total_loss);
+		tx_csc->consec_total_loss = 0;
+	}
+
+	/* count sent successfully && before packets were lost */
+	if (!send_failed && pkt_loss)
+		update_consec_bins(tx_csc->loss_bins, bin_ranges,
+				   bin_range_count, pkt_loss);
+
+	/*
+	 * count how many consecutive Tx packet latencies were greater than
+	 * late threshold within the appropriate range
+	 * (and are considered lost even though they were sent successfully)
+	 */
+	if (send_failed) /* only count packets sent successfully */
+		return;
+
+	if (tx_consec->late_threshold < msrmnt) {
+		tx_csc->consec_late_loss++;
+	} else {
+		update_consec_bins(tx_csc->late_bins, bin_ranges,
+				   bin_range_count,
+				   tx_csc->consec_late_loss);
+		tx_csc->consec_late_loss = 0;
+	}
+}
+
+/*
+ * Measure Tx frames latency.
+ */
+static void
+tx_latency_msrmnt(struct ieee80211_tx_latency_bin_ranges *tx_latency,
+		  struct sta_info *sta, int tid, u32 msrmnt)
+{
+	int bin_range_count, i;
+	u32 *bin_ranges;
+	struct ieee80211_tx_latency_stat *tx_lat;
+
+	if (!tx_latency)
+		return;
+
+	tx_lat = &sta->tx_lat[tid];
+
+	if (tx_lat->max < msrmnt) /* update stats */
+		tx_lat->max = msrmnt;
+	tx_lat->counter++;
+	tx_lat->sum += msrmnt;
+
+	if (!tx_lat->bins) /* bins not activated */
+		return;
+
+	/* count how many Tx frames transmitted with the appropriate latency */
+	bin_range_count = tx_latency->n_ranges;
+	bin_ranges = tx_latency->ranges;
+
+	for (i = 0; i < bin_range_count; i++) {
+		if (msrmnt <= bin_ranges[i]) {
+			tx_lat->bins[i]++;
+			break;
+		}
+	}
+	if (i == bin_range_count) /* msrmnt is bigger than the biggest range */
+		tx_lat->bins[i]++;
+}
 /*
- * Measure Tx frame completion and removal time for Tx latency statistics
+ * 1) Measure Tx frame completion and removal time for Tx latency statistics
  * calculation. A single Tx frame latency should be measured from when it
  * is entering the Kernel until we receive Tx complete confirmation indication
  * and remove the skb.
+ * 2) Measure consecutive Tx frames that were lost or that there latency passed
+ * a certain thershold and therefor considered lost.
  */
-static void ieee80211_tx_latency_end_msrmnt(struct ieee80211_local *local,
-					    struct sk_buff *skb,
-					    struct sta_info *sta,
-					    struct ieee80211_hdr *hdr)
+static void ieee80211_collect_tx_timing_stats(struct ieee80211_local *local,
+					      struct sk_buff *skb,
+					      struct sta_info *sta,
+					      struct ieee80211_hdr *hdr,
+					      int pkt_loss, bool send_fail)
 {
 	ktime_t skb_dprt;
 	struct timespec dprt_time;
 	u32 msrmnt;
 	u16 tid;
 	u8 *qc;
-	int i, bin_range_count;
-	u32 *bin_ranges;
 	__le16 fc;
-	struct ieee80211_tx_latency_stat *tx_lat;
 	struct ieee80211_tx_latency_bin_ranges *tx_latency;
+	struct ieee80211_tx_consec_loss_ranges *tx_consec;
 	ktime_t skb_arv = skb->tstamp;
 
 	tx_latency = rcu_dereference(local->tx_latency);
+	tx_consec = rcu_dereference(local->tx_consec);
 
-	/* assert Tx latency stats are enabled & frame arrived when enabled */
-	if (!tx_latency || !ktime_to_ns(skb_arv))
+	/*
+	 * assert Tx latency or Tx consecutive packets loss stats are enabled
+	 * & frame arrived when enabled
+	 */
+	if ((!tx_latency && !tx_consec) || !ktime_to_ns(skb_arv))
 		return;
 
 	fc = hdr->frame_control;
@@ -504,32 +619,16 @@ static void ieee80211_tx_latency_end_msrmnt(struct ieee80211_local *local,
 		tid = 0;
 	}
 
-	tx_lat = &sta->tx_lat[tid];
-
 	ktime_get_ts(&dprt_time); /* time stamp completion time */
 	skb_dprt = ktime_set(dprt_time.tv_sec, dprt_time.tv_nsec);
 	msrmnt = ktime_to_ms(ktime_sub(skb_dprt, skb_arv));
 
-	if (tx_lat->max < msrmnt) /* update stats */
-		tx_lat->max = msrmnt;
-	tx_lat->counter++;
-	tx_lat->sum += msrmnt;
-
-	if (!tx_lat->bins) /* bins not activated */
-		return;
-
-	/* count how many Tx frames transmitted with the appropriate latency */
-	bin_range_count = tx_latency->n_ranges;
-	bin_ranges = tx_latency->ranges;
+	/* update statistic regarding consecutive lost packets */
+	tx_consec_loss_msrmnt(tx_consec, sta, tid, msrmnt, pkt_loss,
+			      send_fail);
 
-	for (i = 0; i < bin_range_count; i++) {
-		if (msrmnt <= bin_ranges[i]) {
-			tx_lat->bins[i]++;
-			break;
-		}
-	}
-	if (i == bin_range_count) /* msrmnt is bigger than the biggest range */
-		tx_lat->bins[i]++;
+	/* update statistic regarding latency */
+	tx_latency_msrmnt(tx_latency, sta, tid, msrmnt);
 }
 
 /*
@@ -558,6 +657,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	bool acked;
 	struct ieee80211_bar *bar;
 	int rtap_len;
+	int prev_loss_pkt;
+	bool send_fail = true;
 	int shift = 0;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
@@ -676,10 +777,19 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
 			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data, acked);
 
+		prev_loss_pkt = 0;
+
 		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
 			if (info->flags & IEEE80211_TX_STAT_ACK) {
-				if (sta->lost_packets)
+				send_fail = false;
+				if (sta->lost_packets) {
+					/*
+					 * need to keep track of the amount for
+					 * timing statistics later on
+					 */
+					prev_loss_pkt = sta->lost_packets;
 					sta->lost_packets = 0;
+				}
 			} else if (++sta->lost_packets >= STA_LOST_PKT_THRESHOLD) {
 				cfg80211_cqm_pktloss_notify(sta->sdata->dev,
 							    sta->sta.addr,
@@ -692,11 +802,9 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (acked)
 			sta->last_ack_signal = info->status.ack_signal;
 
-		/*
-		 * Measure frame removal for tx latency
-		 * statistics calculation
-		 */
-		ieee80211_tx_latency_end_msrmnt(local, skb, sta, hdr);
+		/* Measure Tx latency & Tx consecutive loss statistics */
+		ieee80211_collect_tx_timing_stats(local, skb, sta, hdr,
+						  prev_loss_pkt, send_fail);
 	}
 
 	rcu_read_unlock();
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 19d36d4..2fb5c39 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1759,7 +1759,8 @@ fail:
 }
 
 /*
- * Measure Tx frame arrival time for Tx latency statistics calculation
+ * Measure Tx frame arrival time for Tx latency & Tx consecutive packet loss
+ * statistics calculation.
  * A single Tx frame latency should be measured from when it is entering the
  * Kernel until we receive Tx complete confirmation indication and the skb is
  * freed.
@@ -1769,9 +1770,11 @@ static void ieee80211_tx_latency_start_msrmnt(struct ieee80211_local *local,
 {
 	struct timespec skb_arv;
 	struct ieee80211_tx_latency_bin_ranges *tx_latency;
+	struct ieee80211_tx_consec_loss_ranges *tx_consec;
 
 	tx_latency = rcu_dereference(local->tx_latency);
-	if (!tx_latency)
+	tx_consec = rcu_dereference(local->tx_consec);
+	if (!tx_latency && !tx_consec)
 		return;
 
 	ktime_get_ts(&skb_arv);
-- 
1.8.3.2

