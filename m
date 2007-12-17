Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45232 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763987AbXLQA3f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 19:29:35 -0500
Message-Id: <20071217002056.758272296@gmx.de> (sfid-20071217_002941_805636_882A5523)
References: <20071217001956.640555983@gmx.de>
Date: Mon, 17 Dec 2007 01:20:05 +0100
From: mattias.nissler@gmx.de
To: linville@tuxdriver.com
Cc: stefano.brivio@polimi.it, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, Mattias Nissler <mattias.nissler@gmx.de>
Subject: [patch 9/9] mac80211: Publish rc80211_pid parameters in debugfs
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds all the tuneable parameters used by rc80211_pid to debugfs for easy
testing and tuning.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 net/mac80211/rc80211_pid.c |   77 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 65 insertions(+), 12 deletions(-)

Index: rt2x00/net/mac80211/rc80211_pid.c
===================================================================
--- rt2x00.orig/net/mac80211/rc80211_pid.c
+++ rt2x00/net/mac80211/rc80211_pid.c
@@ -66,16 +66,16 @@
  * RC_PID_ARITH_SHIFT.
  */
 
-/* Sampling period for measuring percentage of failed frames. */
-#define RC_PID_INTERVAL (HZ / 1)
+/* Sampling period for measuring percentage of failed frames in 0.001s. */
+#define RC_PID_INTERVAL 1000
 
 /* Exponential averaging smoothness (used for I part of PID controller) */
 #define RC_PID_SMOOTHING_SHIFT 3
 #define RC_PID_SMOOTHING (1 << RC_PID_SMOOTHING_SHIFT)
 
 /* Sharpening factor (used for D part of PID controller) */
-#define RC_PID_SHARPENING_FACTOR 2
-#define RC_PID_SHARPENING_DURATION 1
+#define RC_PID_SHARPENING_FACTOR 0
+#define RC_PID_SHARPENING_DURATION 0
 
 /* Fixed point arithmetic shifting amount. */
 #define RC_PID_ARITH_SHIFT 8
@@ -84,11 +84,11 @@
 #define RC_PID_ARITH_FACTOR (1 << RC_PID_ARITH_SHIFT)
 
 /* Proportional PID component coefficient. */
-#define RC_PID_COEFF_P 15
+#define RC_PID_COEFF_P 20
 /* Integral PID component coefficient. */
 #define RC_PID_COEFF_I 10
 /* Derivative PID component coefficient. */
-#define RC_PID_COEFF_D 15
+#define RC_PID_COEFF_D 0
 
 /* Target failed frames rate for the PID controller. NB: This effectively gives
  * maximum failed frames percentage we're willing to accept. If the wireless
@@ -185,20 +185,21 @@ static void rate_control_pid_adjust_rate
 }
 
 /* Normalize the failed frames per-rate differences. */
-static void rate_control_pid_normalize(struct rc_pid_rateinfo *r, int l)
+static void rate_control_pid_normalize(struct rc_pid_info *pinfo, int l)
 {
-	int i;
+	int i, norm_offset = pinfo->norm_offset;
+	struct rc_pid_rateinfo *r = pinfo->rinfo;
 
-	if (r[0].diff > RC_PID_NORM_OFFSET)
-		r[0].diff -= RC_PID_NORM_OFFSET;
-	else if (r[0].diff < -RC_PID_NORM_OFFSET)
-		r[0].diff += RC_PID_NORM_OFFSET;
+	if (r[0].diff > norm_offset)
+		r[0].diff -= norm_offset;
+	else if (r[0].diff < -norm_offset)
+		r[0].diff += norm_offset;
 	for (i = 0; i < l - 1; i++)
 		if (likely(r[i + 1].valid)) {
-			if (r[i + 1].diff > r[i].diff + RC_PID_NORM_OFFSET)
-				r[i + 1].diff -= RC_PID_NORM_OFFSET;
+			if (r[i + 1].diff > r[i].diff + norm_offset)
+				r[i + 1].diff -= norm_offset;
 			else if (r[i + 1].diff <= r[i].diff)
-				r[i + 1].diff += RC_PID_NORM_OFFSET;
+				r[i + 1].diff += norm_offset;
 		}
 }
 
@@ -215,14 +216,16 @@ static void rate_control_pid_sample(stru
 	s32 err_int;
 	s32 err_der;
 	int adj, i, j, tmp;
+	unsigned long period;
 
 	mode = local->oper_hw_mode;
 	spinfo = sta->rate_ctrl_priv;
 
 	/* In case nothing happened during the previous control interval, turn
 	 * the sharpening factor on. */
-	if (jiffies - spinfo->last_sample > 2 * RC_PID_INTERVAL)
-		spinfo->sharp_cnt = RC_PID_SHARPENING_DURATION;
+	period = (HZ / 1000) * pinfo->sampling_period;
+	if (jiffies - spinfo->last_sample > 2 * period)
+		spinfo->sharp_cnt = pinfo->sharpen_duration;
 
 	spinfo->last_sample = jiffies;
 
@@ -253,17 +256,17 @@ static void rate_control_pid_sample(stru
 		rinfo[j].valid = 1;
 		pinfo->oldrate = sta->txrate;
 	}
-	rate_control_pid_normalize(rinfo, mode->num_rates);
+	rate_control_pid_normalize(pinfo, mode->num_rates);
 
 	/* Compute the proportional, integral and derivative errors. */
-	err_prop = RC_PID_TARGET_PF - pf;
+	err_prop = pinfo->target - pf;
 
-	err_avg = spinfo->err_avg_sc >> RC_PID_SMOOTHING_SHIFT;
+	err_avg = spinfo->err_avg_sc >> pinfo->smoothing_shift;
 	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;
-	err_int = spinfo->err_avg_sc >> RC_PID_SMOOTHING_SHIFT;
+	err_int = spinfo->err_avg_sc >> pinfo->smoothing_shift;
 
-	err_der = pf - spinfo->last_pf
-		  * (1 + RC_PID_SHARPENING_FACTOR * spinfo->sharp_cnt);
+	err_der = (pf - spinfo->last_pf) *
+		  (1 + pinfo->sharpen_factor * spinfo->sharp_cnt);
 	spinfo->last_pf = pf;
 	if (spinfo->sharp_cnt)
 			spinfo->sharp_cnt--;
@@ -292,6 +295,7 @@ static void rate_control_pid_tx_status(v
 	struct rc_pid_info *pinfo = priv;
 	struct sta_info *sta;
 	struct rc_pid_sta_info *spinfo;
+	unsigned long period;
 
 	sta = sta_info_get(local, hdr->addr1);
 
@@ -336,7 +340,8 @@ static void rate_control_pid_tx_status(v
 	sta->tx_num_mpdu_fail += status->retry_count;
 
 	/* Update PID controller state. */
-	if (time_after(jiffies, spinfo->last_sample + RC_PID_INTERVAL))
+	period = (HZ / 1000) * pinfo->sampling_period;
+	if (time_after(jiffies, spinfo->last_sample + period))
 		rate_control_pid_sample(pinfo, local, sta);
 
 	sta_info_put(sta);
@@ -394,6 +399,9 @@ static void *rate_control_pid_alloc(stru
 	struct ieee80211_hw_mode *mode;
 	int i, j, tmp;
 	bool s;
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct rc_pid_debugfs_entries *de;
+#endif
 
 	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
 	if (!pinfo)
@@ -414,7 +422,7 @@ static void *rate_control_pid_alloc(stru
 	for (i = 0; i < mode->num_rates; i++) {
 		rinfo[i].index = i;
 		rinfo[i].rev_index = i;
-		if (RC_PID_FAST_START) {
+		if (pinfo->fast_start) {
 			rinfo[i].valid = 1;
 			rinfo[i].diff = 0;
 		} else
@@ -440,18 +448,72 @@ static void *rate_control_pid_alloc(stru
 	rinfo[0].valid = 1;
 
 	pinfo->target = RC_PID_TARGET_PF;
+	pinfo->sampling_period = RC_PID_INTERVAL;
 	pinfo->coeff_p = RC_PID_COEFF_P;
 	pinfo->coeff_i = RC_PID_COEFF_I;
 	pinfo->coeff_d = RC_PID_COEFF_D;
+	pinfo->smoothing_shift = RC_PID_SMOOTHING_SHIFT;
+	pinfo->sharpen_factor = RC_PID_SHARPENING_FACTOR;
+	pinfo->sharpen_duration = RC_PID_SHARPENING_DURATION;
+	pinfo->norm_offset = RC_PID_NORM_OFFSET;
+	pinfo->fast_start = RC_PID_FAST_START;
 	pinfo->rinfo = rinfo;
 	pinfo->oldrate = 0;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	de = &pinfo->dentries;
+	de->dir = debugfs_create_dir("rc80211_pid",
+				     local->hw.wiphy->debugfsdir);
+	de->target = debugfs_create_u32("target_pf", S_IRUSR | S_IWUSR,
+					de->dir, &pinfo->target);
+	de->sampling_period = debugfs_create_u32("sampling_period",
+						 S_IRUSR | S_IWUSR, de->dir,
+						 &pinfo->sampling_period);
+	de->coeff_p = debugfs_create_s32("coeff_p", S_IRUSR | S_IWUSR,
+					 de->dir, &pinfo->coeff_p);
+	de->coeff_i = debugfs_create_s32("coeff_i", S_IRUSR | S_IWUSR,
+					 de->dir, &pinfo->coeff_i);
+	de->coeff_d = debugfs_create_s32("coeff_d", S_IRUSR | S_IWUSR,
+					 de->dir, &pinfo->coeff_d);
+	de->smoothing_shift = debugfs_create_u32("smoothing_shift",
+						 S_IRUSR | S_IWUSR, de->dir,
+						 &pinfo->smoothing_shift);
+	de->sharpen_factor = debugfs_create_u32("sharpen_factor",
+					       S_IRUSR | S_IWUSR, de->dir,
+					       &pinfo->sharpen_factor);
+	de->sharpen_duration = debugfs_create_u32("sharpen_duration",
+						  S_IRUSR | S_IWUSR, de->dir,
+						  &pinfo->sharpen_duration);
+	de->norm_offset = debugfs_create_u32("norm_offset",
+					     S_IRUSR | S_IWUSR, de->dir,
+					     &pinfo->norm_offset);
+	de->fast_start = debugfs_create_bool("fast_start",
+					     S_IRUSR | S_IWUSR, de->dir,
+					     &pinfo->fast_start);
+#endif
+
 	return pinfo;
 }
 
 static void rate_control_pid_free(void *priv)
 {
 	struct rc_pid_info *pinfo = priv;
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct rc_pid_debugfs_entries *de = &pinfo->dentries;
+
+	debugfs_remove(de->fast_start);
+	debugfs_remove(de->norm_offset);
+	debugfs_remove(de->sharpen_duration);
+	debugfs_remove(de->sharpen_factor);
+	debugfs_remove(de->smoothing_shift);
+	debugfs_remove(de->coeff_d);
+	debugfs_remove(de->coeff_i);
+	debugfs_remove(de->coeff_p);
+	debugfs_remove(de->sampling_period);
+	debugfs_remove(de->target);
+	debugfs_remove(de->dir);
+#endif
+
 	kfree(pinfo->rinfo);
 	kfree(pinfo);
 }
Index: rt2x00/net/mac80211/rc80211_pid_debugfs.h
===================================================================
--- rt2x00.orig/net/mac80211/rc80211_pid_debugfs.h
+++ rt2x00/net/mac80211/rc80211_pid_debugfs.h
@@ -9,6 +9,20 @@
 #ifndef RC80211_PID_DEBUGFS_H
 #define RC80211_PID_DEBUGFS_H
 
+struct rc_pid_debugfs_entries {
+	struct dentry *dir;
+	struct dentry *target;
+	struct dentry *sampling_period;
+	struct dentry *coeff_p;
+	struct dentry *coeff_i;
+	struct dentry *coeff_d;
+	struct dentry *smoothing_shift;
+	struct dentry *sharpen_factor;
+	struct dentry *sharpen_duration;
+	struct dentry *norm_offset;
+	struct dentry *fast_start;
+};
+
 enum rc_pid_event_type {
 	RC_PID_EVENT_TYPE_TX_STATUS,
 	RC_PID_EVENT_TYPE_RATE_CHANGE,
Index: rt2x00/net/mac80211/rc80211_pid.h
===================================================================
--- rt2x00.orig/net/mac80211/rc80211_pid.h
+++ rt2x00/net/mac80211/rc80211_pid.h
@@ -94,8 +94,8 @@ struct rc_pid_info {
 	/* Exponential averaging shift. */
 	unsigned int smoothing_shift;
 
-	/* Sharpening shift and duration. */
-	unsigned int sharpen_shift;
+	/* Sharpening factor and duration. */
+	unsigned int sharpen_factor;
 	unsigned int sharpen_duration;
 
 	/* Normalization offset. */
@@ -109,6 +109,11 @@ struct rc_pid_info {
 
 	/* Index of the last used rate. */
 	int oldrate;
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	/* Debugfs entries created for the parameters above. */
+	struct rc_pid_debugfs_entries dentries;
+#endif
 };
 
 #endif /* RC80211_PID_H */

-- 

