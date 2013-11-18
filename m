Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:47630 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3KRRG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:06:56 -0500
Received: by mail-bk0-f48.google.com with SMTP id v10so2089600bkz.7
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 09:06:54 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Matti Gottlieb <matti.gottlieb@intel.com>
Subject: [PATCH RESEND 1/5] mac80211: Tx frame latency statistics
Date: Mon, 18 Nov 2013 19:06:45 +0200
Message-Id: <1384794409-11211-1-git-send-email-egrumbach@gmail.com> (sfid-20131118_180706_626834_E899A1B1)
In-Reply-To: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Measure TX latency and jitter statistics per station per TID.
These Measurements are disabled by default and can be enabled
via debugfs.

Features included for each station's TID:

1. Keep count of the maximum and average latency of Tx frames.
2. Keep track of many frames arrived in a specific time range
   (need to enable through debugfs and configure the bins ranges)

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c     |  168 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_sta.c |  134 +++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |   24 +++++++
 net/mac80211/main.c        |    2 +
 net/mac80211/sta_info.c    |   34 +++++++++
 net/mac80211/sta_info.h    |   22 ++++++
 net/mac80211/status.c      |   78 ++++++++++++++++++++
 net/mac80211/tx.c          |   24 +++++++
 8 files changed, 486 insertions(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5c090e4..fa16e54 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -17,6 +17,172 @@
 
 #define DEBUGFS_FORMAT_BUFFER_SIZE 100
 
+#define TX_LATENCY_BIN_DELIMTER_C ','
+#define TX_LATENCY_BIN_DELIMTER_S ","
+#define TX_LATENCY_BINS_DISABLED "enable(bins disabled)\n"
+#define TX_LATENCY_DISABLED "disable\n"
+
+
+/*
+ * Display if Tx latency statistics & bins are enabled/disabled
+ */
+static ssize_t sta_tx_latency_stat_read(struct file *file,
+					char __user *userbuf,
+					size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	struct ieee80211_tx_latency_bin_ranges  *tx_latency;
+	char *buf;
+	int bufsz, i, ret;
+	int pos = 0;
+
+	rcu_read_lock();
+
+	tx_latency = rcu_dereference(local->tx_latency);
+
+	if (tx_latency && tx_latency->n_ranges) {
+		bufsz = tx_latency->n_ranges * 15;
+		buf = kzalloc(bufsz, GFP_ATOMIC);
+		if (!buf)
+			goto err;
+
+		for (i = 0; i < tx_latency->n_ranges; i++)
+			pos += scnprintf(buf + pos, bufsz - pos, "%d,",
+					 tx_latency->ranges[i]);
+		pos += scnprintf(buf + pos, bufsz - pos, "\n");
+	} else if (tx_latency) {
+		bufsz = sizeof(TX_LATENCY_BINS_DISABLED) + 1;
+		buf = kzalloc(bufsz, GFP_ATOMIC);
+		if (!buf)
+			goto err;
+
+		pos += scnprintf(buf + pos, bufsz - pos, "%s\n",
+				 TX_LATENCY_BINS_DISABLED);
+	} else {
+		bufsz = sizeof(TX_LATENCY_DISABLED) + 1;
+		buf = kzalloc(bufsz, GFP_ATOMIC);
+		if (!buf)
+			goto err;
+
+		pos += scnprintf(buf + pos, bufsz - pos, "%s\n",
+				 TX_LATENCY_DISABLED);
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
+ * Receive input from user regarding Tx latency statistics
+ * The input should indicate if Tx latency statistics and bins are
+ * enabled/disabled.
+ * If bins are enabled input should indicate the amount of different bins and
+ * their ranges. Each bin will count how many Tx frames transmitted within the
+ * appropriate latency.
+ * Legal input is:
+ * a) "enable(bins disabled)" - to enable only general statistics
+ * b) "a,b,c,d,...z" - to enable general statistics and bins, where all are
+ * numbers and a < b < c < d.. < z
+ * c) "disable" - disable all statistics
+ * NOTE: must configure Tx latency statistics bins before stations connected.
+ */
+
+static ssize_t sta_tx_latency_stat_write(struct file *file,
+					 const char __user *userbuf,
+					 size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	char buf[128] = {};
+	char *bins = buf;
+	char *token;
+	int buf_size, i, alloc_size;
+	int prev_bin = 0;
+	int n_ranges = 0;
+	int ret = count;
+	struct ieee80211_tx_latency_bin_ranges  *tx_latency;
+
+	if (sizeof(buf) <= count)
+		return -EINVAL;
+	buf_size = count;
+	if (copy_from_user(buf, userbuf, buf_size))
+		return -EFAULT;
+
+	mutex_lock(&local->sta_mtx);
+
+	/* cannot change config once we have stations */
+	if (local->num_sta)
+		goto unlock;
+
+	tx_latency =
+		rcu_dereference_protected(local->tx_latency,
+					  lockdep_is_held(&local->sta_mtx));
+
+	/* disable Tx statistics */
+	if (!strcmp(buf, TX_LATENCY_DISABLED)) {
+		if (!tx_latency)
+			goto unlock;
+		rcu_assign_pointer(local->tx_latency, NULL);
+		synchronize_rcu();
+		kfree(tx_latency);
+		goto unlock;
+	}
+
+	/* Tx latency already enabled */
+	if (tx_latency)
+		goto unlock;
+
+	if (strcmp(TX_LATENCY_BINS_DISABLED, buf)) {
+		/* check how many bins and between what ranges user requested */
+		token = buf;
+		while (*token != '\0') {
+			if (*token == TX_LATENCY_BIN_DELIMTER_C)
+				n_ranges++;
+			token++;
+		}
+		n_ranges++;
+	}
+
+	alloc_size = sizeof(struct ieee80211_tx_latency_bin_ranges) +
+		     n_ranges * sizeof(u32);
+	tx_latency = kzalloc(alloc_size, GFP_ATOMIC);
+	if (!tx_latency) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	tx_latency->n_ranges = n_ranges;
+	for (i = 0; i < n_ranges; i++) { /* setting bin ranges */
+		token = strsep(&bins, TX_LATENCY_BIN_DELIMTER_S);
+		sscanf(token, "%d", &tx_latency->ranges[i]);
+		/* bins values should be in ascending order */
+		if (prev_bin >= tx_latency->ranges[i]) {
+			ret = -EINVAL;
+			kfree(tx_latency);
+			goto unlock;
+		}
+		prev_bin = tx_latency->ranges[i];
+	}
+	rcu_assign_pointer(local->tx_latency, tx_latency);
+
+unlock:
+	mutex_unlock(&local->sta_mtx);
+
+	return ret;
+}
+
+static const struct file_operations stats_tx_latency_ops = {
+	.write = sta_tx_latency_stat_write,
+	.read = sta_tx_latency_stat_read,
+	.open = simple_open,
+	.llseek = generic_file_llseek,
+};
+
 int mac80211_format_buffer(char __user *userbuf, size_t count,
 				  loff_t *ppos, char *fmt, ...)
 {
@@ -315,4 +481,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_DEVSTATS_ADD(dot11RTSFailureCount);
 	DEBUGFS_DEVSTATS_ADD(dot11FCSErrorCount);
 	DEBUGFS_DEVSTATS_ADD(dot11RTSSuccessCount);
+
+	DEBUGFS_DEVSTATS_ADD(tx_latency);
 }
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 19c54a4..80194b5 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -38,6 +38,13 @@ static const struct file_operations sta_ ##name## _ops = {		\
 	.llseek = generic_file_llseek,					\
 }
 
+#define STA_OPS_W(name)							\
+static const struct file_operations sta_ ##name## _ops = {		\
+	.write = sta_##name##_write,					\
+	.open = simple_open,						\
+	.llseek = generic_file_llseek,					\
+}
+
 #define STA_OPS_RW(name)						\
 static const struct file_operations sta_ ##name## _ops = {		\
 	.read = sta_##name##_read,					\
@@ -388,6 +395,131 @@ static ssize_t sta_last_rx_rate_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(last_rx_rate);
 
+static int
+sta_tx_latency_stat_header(struct ieee80211_tx_latency_bin_ranges *tx_latency,
+			   char *buf, int pos, int bufsz)
+{
+	int i;
+	int range_count = tx_latency->n_ranges;
+	u32 *bin_ranges = tx_latency->ranges;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			  "Station\t\t\tTID\tMax\tAvg");
+	if (range_count) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+				  "\t<=%d", bin_ranges[0]);
+		for (i = 0; i < range_count - 1; i++)
+			pos += scnprintf(buf + pos, bufsz - pos, "\t%d-%d",
+					  bin_ranges[i], bin_ranges[i+1]);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				  "\t%d<", bin_ranges[range_count - 1]);
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos, "\n");
+
+	return pos;
+}
+
+static int
+sta_tx_latency_stat_table(struct ieee80211_tx_latency_bin_ranges *tx_lat_range,
+			  struct ieee80211_tx_latency_stat *tx_lat,
+			  char *buf, int pos, int bufsz, int tid)
+{
+	u32 avg = 0;
+	int j;
+	int bin_count = tx_lat->bin_count;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "\t\t\t%d", tid);
+	/* make sure you don't divide in 0 */
+	if (tx_lat->counter)
+		avg = tx_lat->sum / tx_lat->counter;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "\t%d\t%d",
+			  tx_lat->max, avg);
+
+	if (tx_lat_range->n_ranges && tx_lat->bins)
+		for (j = 0; j < bin_count; j++)
+			pos += scnprintf(buf + pos, bufsz - pos,
+					  "\t%d", tx_lat->bins[j]);
+	pos += scnprintf(buf + pos, bufsz - pos, "\n");
+
+	return pos;
+}
+
+/*
+ * Output Tx latency statistics station && restart all statistics information
+ */
+static ssize_t sta_tx_latency_stat_read(struct file *file,
+					char __user *userbuf,
+					size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_tx_latency_bin_ranges *tx_latency;
+	char *buf;
+	int bufsz, ret, i;
+	int pos = 0;
+
+	bufsz = 20 * IEEE80211_NUM_TIDS *
+		sizeof(struct ieee80211_tx_latency_stat);
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	rcu_read_lock();
+
+	tx_latency = rcu_dereference(local->tx_latency);
+
+	if (!sta->tx_lat) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+				 "Tx latency statistics are not enabled\n");
+		goto unlock;
+	}
+
+	pos = sta_tx_latency_stat_header(tx_latency, buf, pos, bufsz);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "%pM\n", sta->sta.addr);
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
+		pos = sta_tx_latency_stat_table(tx_latency, &sta->tx_lat[i],
+						buf, pos, bufsz, i);
+unlock:
+	rcu_read_unlock();
+
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	kfree(buf);
+
+	return ret;
+}
+STA_OPS(tx_latency_stat);
+
+static ssize_t sta_tx_latency_stat_reset_write(struct file *file,
+					       const char __user *userbuf,
+					       size_t count, loff_t *ppos)
+{
+	u32 *bins;
+	int bin_count;
+	struct sta_info *sta = file->private_data;
+	int i;
+
+	if (!sta->tx_lat)
+		return -EINVAL;
+
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+		bins = sta->tx_lat[i].bins;
+		bin_count = sta->tx_lat[i].bin_count;
+
+		sta->tx_lat[i].max = 0;
+		sta->tx_lat[i].sum = 0;
+		sta->tx_lat[i].counter = 0;
+
+		if (bin_count)
+			memset(bins, 0, bin_count * sizeof(u32));
+	}
+
+	return count;
+}
+STA_OPS_W(tx_latency_stat_reset);
+
 #define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, \
 		sta->debugfs.dir, sta, &sta_ ##name## _ops);
@@ -441,6 +573,8 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(last_ack_signal);
 	DEBUGFS_ADD(current_tx_rate);
 	DEBUGFS_ADD(last_rx_rate);
+	DEBUGFS_ADD(tx_latency_stat);
+	DEBUGFS_ADD(tx_latency_stat_reset);
 
 	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
 	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 29dc505..123beb6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -896,6 +896,24 @@ struct tpt_led_trigger {
 };
 #endif
 
+/*
+ * struct ieee80211_tx_latency_bin_ranges - Tx latency statistics bins ranges
+ *
+ * Measuring Tx latency statistics. Counts how many Tx frames transmitted in a
+ * certain latency range (in Milliseconds). Each station that uses these
+ * ranges will have bins to count the amount of frames received in that range.
+ * The user can configure the ranges via debugfs.
+ * If ranges is NULL then Tx latency statistics bins are disabled for all
+ * stations.
+ *
+ * @n_ranges: number of ranges that are taken in account
+ * @ranges: the ranges that the user requested or NULL if disabled.
+ */
+struct ieee80211_tx_latency_bin_ranges {
+	int n_ranges;
+	u32 ranges[];
+};
+
 /**
  * mac80211 scan flags - currently active scan mode
  *
@@ -1048,6 +1066,12 @@ struct ieee80211_local {
 	struct timer_list sta_cleanup;
 	int sta_generation;
 
+	/*
+	 * Tx latency statistics parameters for all stations.
+	 * Can enable via debugfs (NULL when disabled).
+	 */
+	struct ieee80211_tx_latency_bin_ranges __rcu *tx_latency;
+
 	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 21d5d44..e67dddb 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1087,6 +1087,8 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 		     ieee80211_free_ack_frame, NULL);
 	idr_destroy(&local->ack_status_frames);
 
+	kfree(rcu_access_pointer(local->tx_latency));
+
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1eb66e2..1e17bdc 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -266,9 +266,17 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
  */
 void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 {
+	int i;
+
 	if (sta->rate_ctrl)
 		rate_control_free_sta(sta);
 
+	if (sta->tx_lat) {
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++)
+			kfree(sta->tx_lat[i].bins);
+		kfree(sta->tx_lat);
+	}
+
 	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
 
 	kfree(sta);
@@ -333,6 +341,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct timespec uptime;
+	struct ieee80211_tx_latency_bin_ranges *tx_latency;
 	int i;
 
 	sta = kzalloc(sizeof(*sta) + local->hw.sta_data_size, gfp);
@@ -410,6 +419,31 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	rcu_read_lock();
+
+	tx_latency = rcu_dereference(local->tx_latency);
+	/* init stations Tx latency statistics && TID bins */
+	if (tx_latency)
+		sta->tx_lat = kzalloc(IEEE80211_NUM_TIDS *
+				      sizeof(struct ieee80211_tx_latency_stat),
+				      GFP_ATOMIC);
+
+	/*
+	 * if Tx latency and bins are enabled and the previous allocation
+	 * succeeded
+	 */
+	if (tx_latency && tx_latency->n_ranges && sta->tx_lat)
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+			/* size of bins is size of the ranges +1 */
+			sta->tx_lat[i].bin_count =
+				tx_latency->n_ranges + 1;
+			sta->tx_lat[i].bins  = kcalloc(sta->tx_lat[i].bin_count,
+						       sizeof(u32),
+						       GFP_ATOMIC);
+		}
+
+	rcu_read_unlock();
+
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
 	return sta;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3ef06a2..0683be9 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -220,6 +220,25 @@ struct sta_ampdu_mlme {
 	u8 dialog_token_allocator;
 };
 
+/*
+ * struct ieee80211_tx_latency_stat - Tx latency statistics
+ *
+ * Measures TX latency and jitter for a station per TID.
+ *
+ * @max: worst case latency
+ * @sum: sum of all latencies
+ * @counter: amount of Tx frames sent from interface
+ * @bins: each bin counts how many frames transmitted within a certain
+ * latency range. when disabled it is NULL.
+ * @bin_count: amount of bins.
+ */
+struct ieee80211_tx_latency_stat {
+	u32 max;
+	u32 sum;
+	u32 counter;
+	u32 *bins;
+	u32 bin_count;
+};
 
 /**
  * struct sta_info - STA information
@@ -274,6 +293,7 @@ struct sta_ampdu_mlme {
  * @tid_seq: per-TID sequence numbers for sending to this STA
  * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
+ * @tx_lat: Tx latency statistics
  * @llid: Local link ID
  * @plid: Peer link ID
  * @reason: Cancel reason on PLINK_HOLDING state
@@ -380,6 +400,8 @@ struct sta_info {
 	struct sta_ampdu_mlme ampdu_mlme;
 	u8 timer_to_tid[IEEE80211_NUM_TIDS];
 
+	struct ieee80211_tx_latency_stat *tx_lat;
+
 #ifdef CONFIG_MAC80211_MESH
 	/*
 	 * Mesh peer link attributes
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 52a152b..1ee85c4 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -11,6 +11,7 @@
 
 #include <linux/export.h>
 #include <linux/etherdevice.h>
+#include <linux/time.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
 #include "ieee80211_i.h"
@@ -463,6 +464,77 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 }
 
 /*
+ * Measure Tx frame completion and removal time for Tx latency statistics
+ * calculation. A single Tx frame latency should be measured from when it
+ * is entering the Kernel until we receive Tx complete confirmation indication
+ * and remove the skb.
+ */
+static void ieee80211_tx_latency_end_msrmnt(struct ieee80211_local *local,
+					    struct sk_buff *skb,
+					    struct sta_info *sta,
+					    struct ieee80211_hdr *hdr)
+{
+	ktime_t skb_dprt;
+	struct timespec dprt_time;
+	u32 msrmnt;
+	u16 tid;
+	u8 *qc;
+	int i, bin_range_count, bin_count;
+	u32 *bin_ranges;
+	__le16 fc;
+	struct ieee80211_tx_latency_stat *tx_lat;
+	struct ieee80211_tx_latency_bin_ranges *tx_latency;
+	ktime_t skb_arv = skb->tstamp;
+
+	tx_latency = rcu_dereference(local->tx_latency);
+
+	/* assert Tx latency stats are enabled & frame arrived when enabled */
+	if (!tx_latency || !ktime_to_ns(skb_arv))
+		return;
+
+	fc = hdr->frame_control;
+
+	if (!ieee80211_is_data(fc)) /* make sure it is a data frame */
+		return;
+
+	/* get frame tid */
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		qc = ieee80211_get_qos_ctl(hdr);
+		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+	} else {
+		tid = 0;
+	}
+
+	tx_lat = &sta->tx_lat[tid];
+
+	ktime_get_ts(&dprt_time); /* time stamp completion time */
+	skb_dprt = ktime_set(dprt_time.tv_sec, dprt_time.tv_nsec);
+	msrmnt = ktime_to_ms(ktime_sub(skb_dprt, skb_arv));
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
+	bin_count = tx_lat->bin_count;
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
+
+/*
  * Use a static threshold for now, best value to be determined
  * by testing ...
  * Should it depend on:
@@ -620,6 +692,12 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 		if (acked)
 			sta->last_ack_signal = info->status.ack_signal;
+
+		/*
+		 * Measure frame removal for tx latency
+		 * statistics calculation
+		 */
+		ieee80211_tx_latency_end_msrmnt(local, skb, sta, hdr);
 	}
 
 	rcu_read_unlock();
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c558b24..a4f282b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -19,6 +19,7 @@
 #include <linux/bitmap.h>
 #include <linux/rcupdate.h>
 #include <linux/export.h>
+#include <linux/time.h>
 #include <net/net_namespace.h>
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
@@ -1740,6 +1741,26 @@ fail:
 	return NETDEV_TX_OK; /* meaning, we dealt with the skb */
 }
 
+/*
+ * Measure Tx frame arrival time for Tx latency statistics calculation
+ * A single Tx frame latency should be measured from when it is entering the
+ * Kernel until we receive Tx complete confirmation indication and the skb is
+ * freed.
+ */
+static void ieee80211_tx_latency_start_msrmnt(struct ieee80211_local *local,
+					      struct sk_buff *skb)
+{
+	struct timespec skb_arv;
+	struct ieee80211_tx_latency_bin_ranges *tx_latency;
+
+	tx_latency = rcu_dereference(local->tx_latency);
+	if (!tx_latency)
+		return;
+
+	ktime_get_ts(&skb_arv);
+	skb->tstamp = ktime_set(skb_arv.tv_sec, skb_arv.tv_nsec);
+}
+
 /**
  * ieee80211_subif_start_xmit - netif start_xmit function for Ethernet-type
  * subinterfaces (wlan#, WDS, and VLAN interfaces)
@@ -1790,6 +1811,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	rcu_read_lock();
 
+	/* Measure frame arrival for Tx latency statistics calculation */
+	ieee80211_tx_latency_start_msrmnt(local, skb);
+
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		sta = rcu_dereference(sdata->u.vlan.sta);
-- 
1.7.9.5

