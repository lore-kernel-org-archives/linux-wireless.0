Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:38140 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758963AbXLSAdC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 19:33:02 -0500
Date: Wed, 19 Dec 2007 01:27:51 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v3 8/8] rc80211-pid: export tuning parameters through
 debugfs
Message-ID: <20071219012751.553e34bc@morte> (sfid-20071219_003309_822271_321DE79E)
In-Reply-To: <20071219001955.055692620@polimi.it>
References: <20071219001955.055692620@polimi.it>>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

This adds all the tunable parameters used by rc80211_pid to debugfs for easy
testing and tuning.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 rc80211_pid.h      |   23 ++++++++++-
 rc80211_pid_algo.c |  106 +++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 107 insertions(+), 22 deletions(-)

Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -139,19 +139,20 @@ static void rate_control_pid_adjust_rate
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
-		if (r[i + 1].diff > r[i].diff + RC_PID_NORM_OFFSET)
-			r[i + 1].diff -= RC_PID_NORM_OFFSET;
+		if (r[i + 1].diff > r[i].diff + norm_offset)
+			r[i + 1].diff -= norm_offset;
 		else if (r[i + 1].diff <= r[i].diff)
-			r[i + 1].diff += RC_PID_NORM_OFFSET;
+			r[i + 1].diff += norm_offset;
 }

 static void rate_control_pid_sample(struct rc_pid_info *pinfo,
@@ -167,14 +168,18 @@ static void rate_control_pid_sample(stru
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
+	period = (HZ * pinfo->sampling_period + 500) / 1000;
+	if (!period)
+		period = 1;
+	if (jiffies - spinfo->last_sample > 2 * period)
+		spinfo->sharp_cnt = pinfo->sharpen_duration;

 	spinfo->last_sample = jiffies;

@@ -202,17 +207,17 @@ static void rate_control_pid_sample(stru
 		rinfo[j].diff = rinfo[i].diff + tmp;
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
@@ -241,6 +246,7 @@ static void rate_control_pid_tx_status(v
 	struct rc_pid_info *pinfo = priv;
 	struct sta_info *sta;
 	struct rc_pid_sta_info *spinfo;
+	unsigned long period;

 	sta = sta_info_get(local, hdr->addr1);

@@ -285,7 +291,10 @@ static void rate_control_pid_tx_status(v
 	sta->tx_num_mpdu_fail += status->retry_count;

 	/* Update PID controller state. */
-	if (time_after(jiffies, spinfo->last_sample + RC_PID_INTERVAL))
+	period = (HZ * pinfo->sampling_period + 500) / 1000;
+	if (!period)
+		period = 1;
+	if (time_after(jiffies, spinfo->last_sample + period))
 		rate_control_pid_sample(pinfo, local, sta);

 	sta_info_put(sta);
@@ -343,6 +352,9 @@ static void *rate_control_pid_alloc(stru
 	struct ieee80211_hw_mode *mode;
 	int i, j, tmp;
 	bool s;
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct rc_pid_debugfs_entries *de;
+#endif

 	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
 	if (!pinfo)
@@ -363,10 +375,10 @@ static void *rate_control_pid_alloc(stru
 	for (i = 0; i < mode->num_rates; i++) {
 		rinfo[i].index = i;
 		rinfo[i].rev_index = i;
-		if (RC_PID_FAST_START)
+		if (pinfo->fast_start)
 			rinfo[i].diff = 0;
 		else
-			rinfo[i].diff = i * RC_PID_NORM_OFFSET;
+			rinfo[i].diff = i * pinfo->norm_offset;
 	}
 	for (i = 1; i < mode->num_rates; i++) {
 		s = 0;
@@ -385,18 +397,72 @@ static void *rate_control_pid_alloc(stru
 	}

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
Index: wireless-2.6/net/mac80211/rc80211_pid.h
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid.h
+++ wireless-2.6/net/mac80211/rc80211_pid.h
@@ -119,6 +119,20 @@ struct rc_pid_events_file_info {
 	unsigned int next_entry;
 };

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
 void rate_control_pid_event_tx_status(struct rc_pid_event_buffer *buf,
 					     struct ieee80211_tx_status *stat);

@@ -222,8 +236,8 @@ struct rc_pid_info {
 	/* Exponential averaging shift. */
 	unsigned int smoothing_shift;

-	/* Sharpening shift and duration. */
-	unsigned int sharpen_shift;
+	/* Sharpening factor and duration. */
+	unsigned int sharpen_factor;
 	unsigned int sharpen_duration;

 	/* Normalization offset. */
@@ -237,6 +251,11 @@ struct rc_pid_info {

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
Ciao
Stefano
