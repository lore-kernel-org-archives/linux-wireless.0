Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52497 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaJQSeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2014 14:34:25 -0400
Received: by mail-wi0-f174.google.com with SMTP id h11so3097748wiw.7
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2014 11:34:24 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	karl.beldan@gmail.com, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats
Date: Fri, 17 Oct 2014 20:34:00 +0200
Message-Id: <1413570840-27679-1-git-send-email-karl.beldan@gmail.com> (sfid-20141017_203429_102902_BD3A7D9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

ATM an HT rc_stats line is 106 chars.
Times 8(MCS_GROUP_RATES)*3(SS)*2(GI)*2(BW) + CCK(4), i.e. x100, this is
well above the current 8192 - sizeof(*ms) currently allocated.

Fix this by squeezing the output as follows (not that we're short on
memory but this also improves readability and range, the new format adds
one more digit to *ok/*cum and ok/cum):

- Before (HT) (106 ch):
type           rate     throughput  ewma prob   this prob  retry   this succ/attempt   success    attempts
CCK/LP          5.5M           0.0        0.0         0.0      0              0(  0)         0           0
HT20/LGI ABCDP MCS0            0.0        0.0         0.0      1              0(  0)         0           0
- After (75 ch):
type           rate     tpt eprob *prob ret  *ok(*cum)        ok(      cum)
CCK/LP          5.5M    0.0   0.0   0.0   0    0(   0)         0(        0)
HT20/LGI ABCDP MCS0     0.0   0.0   0.0   1    0(   0)         0(        0)

- Align non-HT format Before (non-HT) (83 ch):
rate      throughput  ewma prob  this prob  this succ/attempt   success    attempts
ABCDP  6         0.0        0.0        0.0             0(  0)         0           0
      54         0.0        0.0        0.0             0(  0)         0           0
- After (61 ch):
rate          tpt eprob *prob  *ok(*cum)        ok(      cum)
ABCDP  1      0.0   0.0   0.0    0(   0)         0(        0)
      54      0.0   0.0   0.0    0(   0)         0(        0)

*This also adds dynamic checks for overflow, lowers the size of the
non-HT request (allowing > 30 entries) and replaces the buddy-rounded
allocations (s/sizeof(*ms) + 8192/8192).

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---


Send this one-line patch to stable ?
-	ms = kmalloc(sizeof(*ms) + 8192, GFP_KERNEL);
+	ms = kmalloc(16384, GFP_KERNEL);


 net/mac80211/rc80211_minstrel_debugfs.c    | 12 +++++++-----
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 13 ++++++++-----
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index edde723..b33be0f 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -62,14 +62,14 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	unsigned int i, tp, prob, eprob;
 	char *p;
 
-	ms = kmalloc(sizeof(*ms) + 4096, GFP_KERNEL);
+	ms = kmalloc(2048, GFP_KERNEL);
 	if (!ms)
 		return -ENOMEM;
 
 	file->private_data = ms;
 	p = ms->buf;
-	p += sprintf(p, "rate      throughput  ewma prob  this prob  "
-			"this succ/attempt   success    attempts\n");
+	p += sprintf(p, "rate          tpt eprob *prob"
+			"  *ok(*cum)        ok(      cum)\n");
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 		struct minstrel_rate_stats *mrs = &mi->r[i].stats;
@@ -86,8 +86,8 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->probability * 1000);
 
-		p += sprintf(p, "  %6u.%1u   %6u.%1u   %6u.%1u        "
-				"   %3u(%3u)  %8llu    %8llu\n",
+		p += sprintf(p, " %4u.%1u %3u.%1u %3u.%1u"
+				" %4u(%4u) %9llu(%9llu)\n",
 				tp / 10, tp % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
@@ -102,6 +102,8 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 			mi->sample_packets);
 	ms->len = p - ms->buf;
 
+	WARN_ON(ms->len > 2048 - sizeof(*ms));
+
 	return 0;
 }
 
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index a72ad46..b51b4ec 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -63,8 +63,8 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mr->probability * 1000);
 
-		p += sprintf(p, "      %6u.%1u   %6u.%1u    %6u.%1u    "
-				"%3u            %3u(%3u)  %8llu    %8llu\n",
+		p += sprintf(p, " %4u.%1u %3u.%1u %3u.%1u "
+				"%3u %4u(%4u) %9llu(%9llu)\n",
 				tp / 10, tp % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
@@ -96,14 +96,15 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 		return ret;
 	}
 
-	ms = kmalloc(sizeof(*ms) + 8192, GFP_KERNEL);
+	ms = kmalloc(8192, GFP_KERNEL);
 	if (!ms)
 		return -ENOMEM;
 
 	file->private_data = ms;
 	p = ms->buf;
-	p += sprintf(p, "type           rate     throughput  ewma prob   "
-		     "this prob  retry   this succ/attempt   success    attempts\n");
+	p += sprintf(p, "type           rate     tpt eprob *prob "
+			"ret  *ok(*cum)        ok(      cum)\n");
+
 
 	p = minstrel_ht_stats_dump(mi, max_mcs, p);
 	for (i = 0; i < max_mcs; i++)
@@ -118,6 +119,8 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 		MINSTREL_TRUNC(mi->avg_ampdu_len * 10) % 10);
 	ms->len = p - ms->buf;
 
+	WARN_ON(ms->len > 8192 - sizeof(*ms));
+
 	return nonseekable_open(inode, file);
 }
 
-- 
2.0.1

