Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:45808 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932684AbbCQR2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 13:28:16 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 01/10] mac80211: enhance readability of Minstrels rc_stats output
Date: Tue, 17 Mar 2015 18:29:10 +0100
Message-Id: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150317_182819_953535_ECAB3C45)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch restructures the rc_stats debugfs table of Minstrel in
order to achieve better human readability. A new layout of the
statistics and a new header is added. In addition to the old layout
there are two new columns of information added:
idx	- representing the rate index of each rate in mac80211 which
	  can be used to set specific rates as fixed rate via debugfs
airtime - the tx-time in micro seconds that a 1200 Byte packet
	  takes to be transmitted over the air at the given rate

The old layout of rc_stats:

    rate      tpt  eprob *prob ret  *ok(*cum)        ok(      cum)
 DP 1          0.9  93.5 100.0   1    0(   0)         2(        2)
    2          0.4  40.0 100.0   0    0(   0)         4(        10)
    5.5        0.0   0.0   0.0   0    0(   0)         0(        0)
...

is changed into this new layout:

best   _______rate_____    __statistics__    ________last_______    ______sum-of________
rate  [name idx tx-time]  [ ø(tp) ø(prob)]  [prob.|retry|suc|att]  [#success | #attempts]
 DP   1     0     9738      0.9    93.5     100.0   1     1 1             2   2
      2     1     4922      0.4    40.0     100.0   1     0 0             4   10
      5.5   2     1858      0.0     0.0       0.0   2     0 0             0   0
...

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Stefan Venz <ikstream86@gmail.com>
---
 net/mac80211/rc80211_minstrel_debugfs.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 2acab1b..2d70081 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -68,8 +68,12 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 
 	file->private_data = ms;
 	p = ms->buf;
-	p += sprintf(p, "rate          tpt eprob *prob"
-			"  *ok(*cum)        ok(      cum)\n");
+	p += sprintf(p, "\n");
+	p += sprintf(p, "best   _______rate_____    __statistics__    "
+			"________last_______    ______sum-of________\n");
+	p += sprintf(p, "rate  [name idx airtime]  [ ø(tp) ø(prob)]  "
+			"[prob.|retry|suc|att]  [#success | #attempts]\n");
+
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 		struct minstrel_rate_stats *mrs = &mi->r[i].stats;
@@ -79,18 +83,22 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		*(p++) = (i == mi->max_tp_rate[2]) ? 'C' : ' ';
 		*(p++) = (i == mi->max_tp_rate[3]) ? 'D' : ' ';
 		*(p++) = (i == mi->max_prob_rate) ? 'P' : ' ';
-		p += sprintf(p, "%3u%s", mr->bitrate / 2,
+
+		p += sprintf(p, " %3u%s ", mr->bitrate / 2,
 				(mr->bitrate & 1 ? ".5" : "  "));
+		p += sprintf(p, "%3u  ", i);
+		p += sprintf(p, "%6u  ", mr->perfect_tx_time);
 
 		tp = MINSTREL_TRUNC(mrs->cur_tp / 10);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->probability * 1000);
 
-		p += sprintf(p, " %4u.%1u %3u.%1u %3u.%1u"
-				" %4u(%4u) %9llu(%9llu)\n",
+		p += sprintf(p, " %4u.%1u   %3u.%1u     %3u.%1u %3u"
+				"   %3u %-3u   %9llu   %-9llu\n",
 				tp / 10, tp % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
+				mrs->retry_count,
 				mrs->last_success,
 				mrs->last_attempts,
 				(unsigned long long)mrs->succ_hist,
-- 
2.3.0

