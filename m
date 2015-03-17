Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:45811 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932635AbbCQR2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 13:28:16 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 03/10] mac80211: add new Minstrel statistic output via csv
Date: Tue, 17 Mar 2015 18:29:12 +0100
Message-Id: <1426613359-31306-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150317_182826_105921_A6B7430A)
In-Reply-To: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a new debugfs file "rc_stats_csv" to output Minstrels
statistics in a common csv format that is easy to parse.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Stefan Venz <ikstream86@gmail.com>
---
 net/mac80211/rc80211_minstrel.h         |  6 +--
 net/mac80211/rc80211_minstrel_debugfs.c | 95 +++++++++++++++++++++++++++++----
 2 files changed, 87 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 410efe6..9613e73 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -13,7 +13,6 @@
 #define EWMA_DIV	128
 #define SAMPLE_COLUMNS	10	/* number of columns in sample table */
 
-
 /* scaled fraction values */
 #define MINSTREL_SCALE  16
 #define MINSTREL_FRAC(val, div) (((val) << MINSTREL_SCALE) / div)
@@ -24,7 +23,7 @@
 
 /*
  * Perform EWMA (Exponentially Weighted Moving Average) calculation
-  */
+ */
 static inline int
 minstrel_ewma(int old, int new, int weight)
 {
@@ -95,6 +94,7 @@ struct minstrel_sta_info {
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *dbg_stats;
+	struct dentry *dbg_stats_csv;
 #endif
 };
 
@@ -121,7 +121,6 @@ struct minstrel_priv {
 	u32 fixed_rate_idx;
 	struct dentry *dbg_fixed_rate;
 #endif
-
 };
 
 struct minstrel_debugfs_info {
@@ -135,6 +134,7 @@ void minstrel_remove_sta_debugfs(void *priv, void *priv_sta);
 
 /* debugfs */
 int minstrel_stats_open(struct inode *inode, struct file *file);
+int minstrel_stats_csv_open(struct inode *inode, struct file *file);
 ssize_t minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos);
 int minstrel_stats_release(struct inode *inode, struct file *file);
 
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 2d70081..8c35402 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -54,6 +54,22 @@
 #include <net/mac80211.h>
 #include "rc80211_minstrel.h"
 
+ssize_t
+minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos)
+{
+	struct minstrel_debugfs_info *ms;
+
+	ms = file->private_data;
+	return simple_read_from_buffer(buf, len, ppos, ms->buf, ms->len);
+}
+
+int
+minstrel_stats_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
 int
 minstrel_stats_open(struct inode *inode, struct file *file)
 {
@@ -115,25 +131,76 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-ssize_t
-minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos)
+static const struct file_operations minstrel_stat_fops = {
+	.owner = THIS_MODULE,
+	.open = minstrel_stats_open,
+	.read = minstrel_stats_read,
+	.release = minstrel_stats_release,
+	.llseek = default_llseek,
+};
+
+int
+minstrel_stats_csv_open(struct inode *inode, struct file *file)
 {
+	struct minstrel_sta_info *mi = inode->i_private;
 	struct minstrel_debugfs_info *ms;
+	struct timeval tv;
+	unsigned int i, tp, prob, eprob;
+	char *p;
 
-	ms = file->private_data;
-	return simple_read_from_buffer(buf, len, ppos, ms->buf, ms->len);
-}
+	ms = kmalloc(2048, GFP_KERNEL);
+	if (!ms)
+		return -ENOMEM;
+
+	file->private_data = ms;
+	p = ms->buf;
+
+	do_gettimeofday(&tv);
+
+	for (i = 0; i < mi->n_rates; i++) {
+		struct minstrel_rate *mr = &mi->r[i];
+		struct minstrel_rate_stats *mrs = &mi->r[i].stats;
+
+		p += sprintf(p, "%ld.%.6ld,", tv.tv_sec, tv.tv_usec);
+		p += sprintf(p, "%s" ,((i == mi->max_tp_rate[0]) ? "A" : ""));
+		p += sprintf(p, "%s" ,((i == mi->max_tp_rate[1]) ? "B" : ""));
+		p += sprintf(p, "%s" ,((i == mi->max_tp_rate[2]) ? "C" : ""));
+		p += sprintf(p, "%s" ,((i == mi->max_tp_rate[3]) ? "D" : ""));
+		p += sprintf(p, "%s" ,((i == mi->max_prob_rate) ? "P" : ""));
+
+		p += sprintf(p, ",%u%s", mr->bitrate / 2,
+				(mr->bitrate & 1 ? ".5," : ","));
+		p += sprintf(p, "%u,", i);
+		p += sprintf(p, "%u,",mr->perfect_tx_time);
+
+		tp = MINSTREL_TRUNC(mrs->cur_tp / 10);
+		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
+		eprob = MINSTREL_TRUNC(mrs->probability * 1000);
+
+		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,"
+				"%llu,%llu,%d,%d\n",
+				tp / 10, tp % 10,
+				eprob / 10, eprob % 10,
+				prob / 10, prob % 10,
+				mrs->retry_count,
+				mrs->last_success,
+				mrs->last_attempts,
+				(unsigned long long)mrs->succ_hist,
+				(unsigned long long)mrs->att_hist,
+				mi->total_packets - mi->sample_packets,
+				mi->sample_packets);
+
+	}
+	ms->len = p - ms->buf;
+
+	WARN_ON(ms->len + sizeof(*ms) > 2048);
 
-int
-minstrel_stats_release(struct inode *inode, struct file *file)
-{
-	kfree(file->private_data);
 	return 0;
 }
 
-static const struct file_operations minstrel_stat_fops = {
+static const struct file_operations minstrel_stat_csv_fops = {
 	.owner = THIS_MODULE,
-	.open = minstrel_stats_open,
+	.open = minstrel_stats_csv_open,
 	.read = minstrel_stats_read,
 	.release = minstrel_stats_release,
 	.llseek = default_llseek,
@@ -146,6 +213,9 @@ minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir)
 
 	mi->dbg_stats = debugfs_create_file("rc_stats", S_IRUGO, dir, mi,
 			&minstrel_stat_fops);
+
+	mi->dbg_stats_csv = debugfs_create_file("rc_stats_csv", S_IRUGO, dir,
+			mi, &minstrel_stat_csv_fops);
 }
 
 void
@@ -154,4 +224,7 @@ minstrel_remove_sta_debugfs(void *priv, void *priv_sta)
 	struct minstrel_sta_info *mi = priv_sta;
 
 	debugfs_remove(mi->dbg_stats);
+
+	debugfs_remove(mi->dbg_stats_csv);
 }
+
-- 
2.3.0

