Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33427 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756887AbXKYXoB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 18:44:01 -0500
Subject: [PATCH][V2][RFC] mac80211: Exponential moving average estimate for
	rc80211_simple
From: Mattias Nissler <mattias.nissler@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 00:43:58 +0100
Message-Id: <1196034238.8223.10.camel@localhost> (sfid-20071125_234408_976621_10B59E1B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes rc80211_simple failed frame percentage estimation to use an
exponential moving average method. The old method used the plain tx
success/failure counters. This made rate control very unresponsive after a
short time of using the interface. Also tune the rc80211_simple parameters a
little, so the tx rate is adapted a little more slowly.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---

Ok, I played with the rate scaling a little more. This version of the
patch calculates per_failed averages over time instead of just averaging
as packets come in.


 net/mac80211/ieee80211_rate.h |    3 -
 net/mac80211/rc80211_simple.c |  107 +++++++++++++++++++++++++++++++++--------
 2 files changed, 86 insertions(+), 24 deletions(-)

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
index da72737..e7b9b0c 100644
--- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -25,9 +25,16 @@
 

 #define RATE_CONTROL_EMERG_DEC 2
-#define RATE_CONTROL_INTERVAL (HZ / 20)
+#define RATE_CONTROL_SAMPLE_INTERVAL (HZ / 20)
+#define RATE_CONTROL_ADJUST_INTERVAL (HZ / 4)
 #define RATE_CONTROL_MIN_TX 10
 
+#define RATE_CONTROL_SMOOTHING_SHIFT 4
+#define RATE_CONTROL_SMOOTHING (1 << RATE_CONTROL_SMOOTHING_SHIFT)
+
+#define RATE_CONTROL_DOWN_THRES 20
+#define RATE_CONTROL_UP_THRES 15
+
 static void rate_control_rate_inc(struct ieee80211_local *local,
 				  struct sta_info *sta)
 {
@@ -112,10 +119,42 @@ struct global_rate_control {
 };
 
 struct sta_rate_control {
-	unsigned long last_rate_change;
-	u32 tx_num_failures;
+	unsigned long last_change;
+	unsigned long last_sample;
+
+	u32 tx_num_failed;
 	u32 tx_num_xmit;
 
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
 	unsigned long avg_rate_update;
 	u32 tx_avg_rate_sum;
 	u32 tx_avg_rate_num;
@@ -123,6 +162,7 @@ struct sta_rate_control {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *tx_avg_rate_sum_dentry;
 	struct dentry *tx_avg_rate_num_dentry;
+	struct dentry *per_failed_avg_dentry;
 #endif
 };
 
@@ -144,7 +184,6 @@ static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 	srctrl = sta->rate_ctrl_priv;
 	srctrl->tx_num_xmit++;
 	if (status->excessive_retries) {
-		srctrl->tx_num_failures++;
 		sta->tx_retry_failed++;
 		sta->tx_num_consecutive_failures++;
 		sta->tx_num_mpdu_fail++;
@@ -155,40 +194,45 @@ static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 		sta->tx_num_consecutive_failures = 0;
 		sta->tx_num_mpdu_ok++;
 	}
+	srctrl->tx_num_failed += status->retry_count;
 	sta->tx_retry_count += status->retry_count;
 	sta->tx_num_mpdu_fail += status->retry_count;
 
 	if (time_after(jiffies,
-		       srctrl->last_rate_change + RATE_CONTROL_INTERVAL) &&
+		       srctrl->last_sample + RATE_CONTROL_SAMPLE_INTERVAL) &&
 		srctrl->tx_num_xmit > RATE_CONTROL_MIN_TX) {
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
+		srctrl->per_failed_scaled = srctrl->per_failed_scaled
+					    - avg + per_failed;
+	}
+
+	if (time_after(jiffies,
+		       srctrl->last_change + RATE_CONTROL_ADJUST_INTERVAL) &&
+		srctrl->tx_num_xmit > RATE_CONTROL_MIN_TX) {
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
+		} else if (avg < RATE_CONTROL_UP_THRES) {
 			rate_control_rate_inc(local, sta);
 		}
 		srctrl->tx_avg_rate_sum += status->control.rate->rate;
 		srctrl->tx_avg_rate_num++;
-		srctrl->tx_num_failures = 0;
 		srctrl->tx_num_xmit = 0;
+		srctrl->tx_num_failed = 0;
 	} else if (sta->tx_num_consecutive_failures >=
 		   RATE_CONTROL_EMERG_DEC) {
 		rate_control_rate_dec(local, sta);
@@ -369,6 +413,23 @@ static const struct file_operations sta_tx_avg_rate_num_ops = {
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
@@ -380,6 +441,9 @@ static void rate_control_simple_add_sta_debugfs(void *priv, void *priv_sta,
 	srctrl->tx_avg_rate_sum_dentry =
 		debugfs_create_file("rc_simple_sta_tx_avg_rate_sum", 0400,
 				    dir, srctrl, &sta_tx_avg_rate_sum_ops);
+	srctrl->per_failed_avg_dentry =
+		debugfs_create_file("rc_simple_sta_per_failed_avg", 0400,
+				    dir, srctrl, &sta_per_failed_avg_ops);
 }
 
 static void rate_control_simple_remove_sta_debugfs(void *priv, void *priv_sta)
@@ -388,6 +452,7 @@ static void rate_control_simple_remove_sta_debugfs(void *priv, void *priv_sta)
 
 	debugfs_remove(srctrl->tx_avg_rate_sum_dentry);
 	debugfs_remove(srctrl->tx_avg_rate_num_dentry);
+	debugfs_remove(srctrl->per_failed_avg_dentry);
 }
 #endif
 
-- 
1.5.3.4

