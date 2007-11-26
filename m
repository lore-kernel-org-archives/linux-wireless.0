Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36748 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753173AbXKZVaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 16:30:10 -0500
Subject: [RFC/T][PATCH][V3] mac80211: Exponential moving average estimate
	for rc80211_simple
From: Mattias Nissler <mattias.nissler@gmx.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 22:30:05 +0100
Message-Id: <1196112605.8318.6.camel@localhost> (sfid-20071126_213020_436941_46862EBC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes rc80211_simple failed frame percentage estimation to use an
exponential moving average method. Failed frames percentage is sampled over
time and a smoothed average is computed. This average is examined periodically
and the rate adjusted eventually.

Compared to the old method this new approach is much more responsive. The old
method used plain tx success/failure counters. This made rate control very
unresponsive after a short time of using the interface, since old data wouldn't
age properly.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 net/mac80211/ieee80211_rate.h |    3 -
 net/mac80211/rc80211_simple.c |  155 ++++++++++++++++++++++++++++++----------
 2 files changed, 116 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/ieee80211_rate.h b/net/mac80211/ieee80211_rate.h
index 2368813..9948d0f 100644
--- a/net/mac80211/ieee80211_rate.h
+++ b/net/mac80211/ieee80211_rate.h
@@ -18,9 +18,6 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 
-#define RATE_CONTROL_NUM_DOWN 20
-#define RATE_CONTROL_NUM_UP   15
-
 
 struct rate_control_extra {
 	/* values from rate_control_get_rate() to the caller: */
diff --git a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simple.c
index da72737..60de964 100644
--- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -25,8 +25,67 @@
 

 #define RATE_CONTROL_EMERG_DEC 2
-#define RATE_CONTROL_INTERVAL (HZ / 20)
-#define RATE_CONTROL_MIN_TX 10
+#define RATE_CONTROL_SAMPLE_INTERVAL (HZ / 10)
+#define RATE_CONTROL_ADJUST_INTERVAL (HZ)
+#define RATE_CONTROL_MIN_TX 4
+#define RATE_CONTROL_MIN_SAMPLES 4
+
+#define RATE_CONTROL_SMOOTHING_SHIFT 4
+#define RATE_CONTROL_SMOOTHING (1 << RATE_CONTROL_SMOOTHING_SHIFT)
+
+#define RATE_CONTROL_DOWN_THRES 20
+#define RATE_CONTROL_UP_THRES 15
+
+struct sta_rate_control {
+	unsigned long last_change;
+	unsigned long last_sample;
+
+	u32 tx_num_failed;
+	u32 tx_num_xmit;
+
+	u32 num_samples;
+
+	/*
+	 * Average number of failed frames, scaled by RATE_CONTROL_SMOOTHING.
+	 * This value is a smoothed by using a exponentail weighted average
+	 * technique:
+	 *
+	 *              (SMOOTHING - 1) * per_failed_old + failed
+	 * per_failed = -----------------------------------------
+	 *                                 SMOOTHING
+	 *
+	 * where the per_failed is the new approximation, per_failed_old the
+	 * previous one and failed is the percentage of failed transmissions in
+	 * the last interval. Note that the bigger SMOOTHING the more weight is
+	 * given to the previous estimate, resulting in more smoothing but less
+	 * responsiveness.
+	 *
+	 * For computation, we actually don't use the above formula, but this
+	 * one:
+	 *
+	 * per_failed_scaled = per_failed_old_scaled - per_failed_old + failed
+	 *
+	 * where:
+	 * 	per_failed_scaled = per_failed * SMOOTHING
+	 * 	per_failed_old_scaled = per_faield_old * SMOOTHING
+	 *
+	 * This avoids floating point numbers and the per_failed_old value can
+	 * easily be obtained by shifting per_failed_old_scaled right by
+	 * RATE_CONTROL_SMOOTHING_SHIFT.
+	 */
+	u32 per_failed_scaled;
+
+	unsigned long avg_rate_update;
+	u32 tx_avg_rate_sum;
+	u32 tx_avg_rate_num;
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct dentry *tx_avg_rate_sum_dentry;
+	struct dentry *tx_avg_rate_num_dentry;
+	struct dentry *per_failed_avg_dentry;
+#endif
+};
+
 
 static void rate_control_rate_inc(struct ieee80211_local *local,
 				  struct sta_info *sta)
@@ -111,22 +170,6 @@ struct global_rate_control {
 	int dummy;
 };
 
-struct sta_rate_control {
-	unsigned long last_rate_change;
-	u32 tx_num_failures;
-	u32 tx_num_xmit;
-
-	unsigned long avg_rate_update;
-	u32 tx_avg_rate_sum;
-	u32 tx_avg_rate_num;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *tx_avg_rate_sum_dentry;
-	struct dentry *tx_avg_rate_num_dentry;
-#endif
-};
-
-
 static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 					  struct sk_buff *skb,
 					  struct ieee80211_tx_status *status)
@@ -142,9 +185,13 @@ static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 	    return;
 
 	srctrl = sta->rate_ctrl_priv;
-	srctrl->tx_num_xmit++;
+	if (status->retry_count) {
+		srctrl->tx_num_xmit += status->retry_count;
+		srctrl->tx_num_failed += status->retry_count;
+	} else
+		srctrl->tx_num_xmit++;
+
 	if (status->excessive_retries) {
-		srctrl->tx_num_failures++;
 		sta->tx_retry_failed++;
 		sta->tx_num_consecutive_failures++;
 		sta->tx_num_mpdu_fail++;
@@ -159,36 +206,45 @@ static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 	sta->tx_num_mpdu_fail += status->retry_count;
 
 	if (time_after(jiffies,
-		       srctrl->last_rate_change + RATE_CONTROL_INTERVAL) &&
-		srctrl->tx_num_xmit > RATE_CONTROL_MIN_TX) {
+		       srctrl->last_sample + RATE_CONTROL_SAMPLE_INTERVAL) &&
+	    srctrl->tx_num_xmit > RATE_CONTROL_MIN_TX) {
+		u32 avg;
 		u32 per_failed;
-		srctrl->last_rate_change = jiffies;
-
-		per_failed = (100 * sta->tx_num_mpdu_fail) /
-			(sta->tx_num_mpdu_fail + sta->tx_num_mpdu_ok);
-		/* TODO: calculate average per_failed to make adjusting
-		 * parameters easier */
-#if 0
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "MPDU fail=%d ok=%d per_failed=%d\n",
-			       sta->tx_num_mpdu_fail, sta->tx_num_mpdu_ok,
-			       per_failed);
-		}
-#endif
+
+		srctrl->last_sample = jiffies;
+
+		per_failed = srctrl->tx_num_failed * 100 / srctrl->tx_num_xmit;
+		avg = srctrl->per_failed_scaled >> RATE_CONTROL_SMOOTHING_SHIFT;
+		srctrl->per_failed_scaled =
+				srctrl->per_failed_scaled - avg + per_failed;
+
+		srctrl->tx_num_xmit = 0;
+		srctrl->tx_num_failed = 0;
+		srctrl->num_samples++;
+	}
+
+	if (time_after(jiffies,
+		       srctrl->last_change + RATE_CONTROL_ADJUST_INTERVAL) &&
+	    srctrl->num_samples > RATE_CONTROL_MIN_SAMPLES) {
+		u32 avg;
+
+		srctrl->last_change = jiffies;
 
 		/*
 		 * XXX: Make these configurable once we have an
 		 * interface to the rate control algorithms
 		 */
-		if (per_failed > RATE_CONTROL_NUM_DOWN) {
+		avg = srctrl->per_failed_scaled >> RATE_CONTROL_SMOOTHING_SHIFT;
+		if (avg > RATE_CONTROL_DOWN_THRES) {
 			rate_control_rate_dec(local, sta);
-		} else if (per_failed < RATE_CONTROL_NUM_UP) {
+			srctrl->num_samples = 0;
+		} else if (avg < RATE_CONTROL_UP_THRES) {
 			rate_control_rate_inc(local, sta);
+			srctrl->num_samples = 0;
 		}
+
 		srctrl->tx_avg_rate_sum += status->control.rate->rate;
 		srctrl->tx_avg_rate_num++;
-		srctrl->tx_num_failures = 0;
-		srctrl->tx_num_xmit = 0;
 	} else if (sta->tx_num_consecutive_failures >=
 		   RATE_CONTROL_EMERG_DEC) {
 		rate_control_rate_dec(local, sta);
@@ -369,6 +425,23 @@ static const struct file_operations sta_tx_avg_rate_num_ops = {
 	.open = open_file_generic,
 };
 
+static ssize_t sta_per_failed_avg(struct file *file,
+				  char __user *userbuf,
+				  size_t count, loff_t *ppos)
+{
+	struct sta_rate_control *srctrl = file->private_data;
+	char buf[20];
+
+	sprintf(buf, "%d\n",
+		srctrl->per_failed_scaled >> RATE_CONTROL_SMOOTHING_SHIFT);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, strlen(buf));
+}
+
+static const struct file_operations sta_per_failed_avg_ops = {
+	.read = sta_per_failed_avg,
+	.open = open_file_generic,
+};
+
 static void rate_control_simple_add_sta_debugfs(void *priv, void *priv_sta,
 						struct dentry *dir)
 {
@@ -380,6 +453,9 @@ static void rate_control_simple_add_sta_debugfs(void *priv, void *priv_sta,
 	srctrl->tx_avg_rate_sum_dentry =
 		debugfs_create_file("rc_simple_sta_tx_avg_rate_sum", 0400,
 				    dir, srctrl, &sta_tx_avg_rate_sum_ops);
+	srctrl->per_failed_avg_dentry =
+		debugfs_create_file("rc_simple_sta_per_failed_avg", 0400,
+				    dir, srctrl, &sta_per_failed_avg_ops);
 }
 
 static void rate_control_simple_remove_sta_debugfs(void *priv, void *priv_sta)
@@ -388,6 +464,7 @@ static void rate_control_simple_remove_sta_debugfs(void *priv, void *priv_sta)
 
 	debugfs_remove(srctrl->tx_avg_rate_sum_dentry);
 	debugfs_remove(srctrl->tx_avg_rate_num_dentry);
+	debugfs_remove(srctrl->per_failed_avg_dentry);
 }
 #endif
 
-- 
1.5.3.4

