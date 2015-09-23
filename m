Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60017 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbIWIas (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 04:30:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: minstrel[_ht]: remove non-ascii debugfs characters
Date: Wed, 23 Sep 2015 10:30:41 +0200
Message-Id: <1442997041-8916-1-git-send-email-johannes@sipsolutions.net> (sfid-20150923_103055_838355_4A2C51F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Replace the average symbol by "avg" to avoid being warned about the
non-ASCII symbol all the time, line up the columns properly.

(I changed my mind - the warnings are getting annoying)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rc80211_minstrel_debugfs.c    | 12 +++++-------
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 12 +++++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 1db5f7c3318a..820b0abc9c0d 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -85,12 +85,10 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	file->private_data = ms;
 	p = ms->buf;
 	p += sprintf(p, "\n");
-	p += sprintf(p, "best   __________rate_________    ______"
-			"statistics______    ________last_______    "
-			"______sum-of________\n");
-	p += sprintf(p, "rate  [name idx airtime max_tp]  [ ø(tp) ø(prob) "
-			"sd(prob)]  [prob.|retry|suc|att]  "
-			"[#success | #attempts]\n");
+	p += sprintf(p,
+		     "best   __________rate_________    ________statistics________    ________last_______    ______sum-of________\n");
+	p += sprintf(p,
+		     "rate  [name idx airtime max_tp]  [avg(tp) avg(prob) sd(prob)]  [prob.|retry|suc|att]  [#success | #attempts]\n");
 
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
@@ -112,7 +110,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%4u.%1u   %4u.%1u   %3u.%1u    %3u.%1u"
+		p += sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u    %3u.%1u"
 				"     %3u.%1u %3u   %3u %-3u   "
 				"%9llu   %-9llu\n",
 				tp_max / 10, tp_max % 10,
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 6822ce0f95e5..5320e35ed3d0 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -86,7 +86,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%4u.%1u   %4u.%1u   %3u.%1u    %3u.%1u"
+		p += sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u    %3u.%1u"
 				"     %3u.%1u %3u   %3u %-3u   "
 				"%9llu   %-9llu\n",
 				tp_max / 10, tp_max % 10,
@@ -129,12 +129,10 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 	p = ms->buf;
 
 	p += sprintf(p, "\n");
-	p += sprintf(p, "              best   ____________rate__________    "
-			"______statistics______    ________last_______    "
-			"______sum-of________\n");
-	p += sprintf(p, "mode guard #  rate  [name   idx airtime  max_tp]  "
-			"[ ø(tp) ø(prob) sd(prob)]  [prob.|retry|suc|att]  [#success | "
-			"#attempts]\n");
+	p += sprintf(p,
+		     "              best   ____________rate__________    ________statistics________    ________last_______    ______sum-of________\n");
+	p += sprintf(p,
+		     "mode guard #  rate  [name   idx airtime  max_tp]  [avg(tp) avg(prob) sd(prob)]  [prob.|retry|suc|att]  [#success | #attempts]\n");
 
 	p = minstrel_ht_stats_dump(mi, MINSTREL_CCK_GROUP, p);
 	for (i = 0; i < MINSTREL_CCK_GROUP; i++)
-- 
2.5.1

