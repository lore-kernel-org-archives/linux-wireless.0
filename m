Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49731 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbbCXUJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 16:09:55 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v4 04/10] mac80211: add new Minstrel-HT statistic output via csv
Date: Tue, 24 Mar 2015 21:09:37 +0100
Message-Id: <1427227783-4531-5-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150324_211005_590257_BE6E4BC8)
In-Reply-To: <1427227783-4531-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1427227783-4531-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a new debugfs file "rc_stats_csv" to output
Minstrel-HTs statistics in a common csv format that is easy
to parse.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Stefan Venz <ikstream86@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.h         |   1 +
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 145 ++++++++++++++++++++++++++++-
 2 files changed, 144 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index f2217d6..3cc30e8 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -112,6 +112,7 @@ struct minstrel_ht_sta_priv {
 	};
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *dbg_stats;
+	struct dentry *dbg_stats_csv;
 #endif
 	void *ratelist;
 	void *sample_table;
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 7fc690f..133d7b6 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -107,8 +107,8 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct minstrel_debugfs_info *ms;
 	unsigned int i;
-	char *p;
 	int ret;
+	char *p;
 
 	if (!msp->is_ht) {
 		inode->i_private = &msp->legacy;
@@ -146,7 +146,6 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 		MINSTREL_TRUNC(mi->avg_ampdu_len),
 		MINSTREL_TRUNC(mi->avg_ampdu_len * 10) % 10);
 	ms->len = p - ms->buf;
-
 	WARN_ON(ms->len + sizeof(*ms) > 32768);
 
 	return nonseekable_open(inode, file);
@@ -160,6 +159,145 @@ static const struct file_operations minstrel_ht_stat_fops = {
 	.llseek = no_llseek,
 };
 
+static char *
+minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p,
+			    struct timeval tv)
+{
+	const struct mcs_group *mg;
+	unsigned int j, tp, prob, eprob, tx_time;
+	char htmode = '2';
+	char gimode = 'L';
+	u32 gflags;
+
+	if (!mi->groups[i].supported)
+		return p;
+
+	mg = &minstrel_mcs_groups[i];
+	gflags = mg->flags;
+
+	if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		htmode = '4';
+	else if (gflags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+		htmode = '8';
+	if (gflags & IEEE80211_TX_RC_SHORT_GI)
+		gimode = 'S';
+
+	for (j = 0; j < MCS_GROUP_RATES; j++) {
+		struct minstrel_rate_stats *mr = &mi->groups[i].rates[j];
+		static const int bitrates[4] = { 10, 20, 55, 110 };
+		int idx = i * MCS_GROUP_RATES + j;
+
+		if (!(mi->groups[i].supported & BIT(j)))
+			continue;
+
+		p += sprintf(p, "%ld.%.6ld,", tv.tv_sec, tv.tv_usec);
+
+		if (gflags & IEEE80211_TX_RC_MCS) {
+			p += sprintf(p, "HT%c0,", htmode);
+			p += sprintf(p, "%cGI,", gimode);
+			p += sprintf(p, "%d,", mg->streams);
+		} else if (gflags & IEEE80211_TX_RC_VHT_MCS) {
+			p += sprintf(p, "VHT%c0,", htmode);
+			p += sprintf(p, "%cGI,", gimode);
+			p += sprintf(p, "%d,", mg->streams);
+		} else {
+			p += sprintf(p, "CCK,");
+			p += sprintf(p, "%cP,", j < 4 ? 'L' : 'S');
+			p += sprintf(p, "1,");
+		}
+
+		p += sprintf(p, "%s" ,((idx == mi->max_tp_rate[0]) ? "A" : ""));
+		p += sprintf(p, "%s" ,((idx == mi->max_tp_rate[1]) ? "B" : ""));
+		p += sprintf(p, "%s" ,((idx == mi->max_tp_rate[2]) ? "C" : ""));
+		p += sprintf(p, "%s" ,((idx == mi->max_tp_rate[3]) ? "D" : ""));
+		p += sprintf(p, "%s" ,((idx == mi->max_prob_rate) ? "P" : ""));
+
+		if (gflags & IEEE80211_TX_RC_MCS) {
+			p += sprintf(p, ",MCS%-2u,", (mg->streams - 1) * 8 + j);
+		} else if (gflags & IEEE80211_TX_RC_VHT_MCS) {
+			p += sprintf(p, ",MCS%-1u/%1u,", j, mg->streams);
+		} else {
+			int r = bitrates[j % 4];
+			p += sprintf(p, ",%2u.%1uM,", r / 10, r % 10);
+		}
+
+		p += sprintf(p, "%u,", idx);
+		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
+		p += sprintf(p, "%u,", tx_time);
+
+		tp = mr->cur_tp / 10;
+		prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
+		eprob = MINSTREL_TRUNC(mr->probability * 1000);
+
+		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,%llu,%llu,",
+				tp / 10, tp % 10,
+				eprob / 10, eprob % 10,
+				prob / 10, prob % 10,
+				mr->retry_count,
+				mr->last_success,
+				mr->last_attempts,
+				(unsigned long long)mr->succ_hist,
+				(unsigned long long)mr->att_hist);
+		p += sprintf(p, "%d,%d,%d.%d\n",
+				max(0, (int) mi->total_packets -
+				(int) mi->sample_packets),
+				mi->sample_packets,
+				MINSTREL_TRUNC(mi->avg_ampdu_len),
+				MINSTREL_TRUNC(mi->avg_ampdu_len * 10) % 10);
+	}
+
+	return p;
+}
+
+static int
+minstrel_ht_stats_csv_open(struct inode *inode, struct file *file)
+{
+	struct minstrel_ht_sta_priv *msp = inode->i_private;
+	struct minstrel_ht_sta *mi = &msp->ht;
+	struct minstrel_debugfs_info *ms;
+	struct timeval tv;
+	unsigned int i;
+	int ret;
+	char *p;
+
+	do_gettimeofday(&tv);
+
+	if (!msp->is_ht) {
+		inode->i_private = &msp->legacy;
+		ret = minstrel_stats_csv_open(inode, file);
+		inode->i_private = msp;
+		return ret;
+	}
+
+	ms = kmalloc(32768, GFP_KERNEL);
+
+	if (!ms)
+		return -ENOMEM;
+
+	file->private_data = ms;
+
+	p = ms->buf;
+
+	p = minstrel_ht_stats_csv_dump(mi, MINSTREL_CCK_GROUP, p, tv);
+	for (i = 0; i < MINSTREL_CCK_GROUP; i++)
+		p = minstrel_ht_stats_csv_dump(mi, i, p, tv);
+	for (i++; i < ARRAY_SIZE(mi->groups); i++)
+		p = minstrel_ht_stats_csv_dump(mi, i, p, tv);
+
+	ms->len = p - ms->buf;
+	WARN_ON(ms->len + sizeof(*ms) > 32768);
+
+	return nonseekable_open(inode, file);
+}
+
+static const struct file_operations minstrel_ht_stat_csv_fops = {
+	.owner = THIS_MODULE,
+	.open = minstrel_ht_stats_csv_open,
+	.read = minstrel_stats_read,
+	.release = minstrel_stats_release,
+	.llseek = no_llseek,
+};
+
 void
 minstrel_ht_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir)
 {
@@ -167,6 +305,8 @@ minstrel_ht_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir)
 
 	msp->dbg_stats = debugfs_create_file("rc_stats", S_IRUGO, dir, msp,
 			&minstrel_ht_stat_fops);
+	msp->dbg_stats_csv = debugfs_create_file("rc_stats_csv", S_IRUGO,
+			     dir, msp, &minstrel_ht_stat_csv_fops);
 }
 
 void
@@ -175,4 +315,5 @@ minstrel_ht_remove_sta_debugfs(void *priv, void *priv_sta)
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 
 	debugfs_remove(msp->dbg_stats);
+	debugfs_remove(msp->dbg_stats_csv);
 }
-- 
2.3.0

