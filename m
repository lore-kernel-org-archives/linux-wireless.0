Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:45809 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932540AbbCQR2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 13:28:16 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 02/10] mac80211: enhance readability of Minstrel-HTs rc_stats output
Date: Tue, 17 Mar 2015 18:29:11 +0100
Message-Id: <1426613359-31306-2-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150317_182822_816450_1EDBB345)
In-Reply-To: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch restructures the rc_stats debugfs table of Minstrel-HT in
order to achieve better human readability. A new layout of the
statistics and a new header is added. In addition to the old layout
there are two new columns of information added:
idx	- representing the rate index of each rate in mac80211 which
	  can be used to set specific rates as fixed rate via debugfs
airtime	- the tx-time in micro seconds that a 1200 Byte packet
	  takes to be transmitted over the air at the given rate

The old layout of rc_stats:

type           rate      tpt eprob *prob ret  *ok(*cum)        ok(      cum)
HT20/LGI       MCS0      5.6 100.0 100.0   1    0(   0)         1(        1)
HT20/LGI   B   MCS1     10.5 100.0 100.0   0    0(   0)         1(        1)
HT20/LGI  A    MCS2     14.8 100.0 100.0   0    0(   0)         1(        1)
...

is changed into this new layout:

            best   ________rate______    __statistics__    ________last_______    ______sum-of________
mode guard #  rate  [name   idx airtime]  [ ø(tp) ø(prob)]  [prob.|retry|suc|att]  [#success | #attempts]
HT20  LGI  1         MCS0     0    1480      0.0      0.0      0.0   1     0 0             0   0
HT20  LGI  1     B   MCS1     1     740     10.5    100.0    100.0   0     0 0             1   1
HT20  LGI  1    A    MCS2     2     496     14.8    100.0    100.0   0     0 0             1   1
...

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Stefan Venz <ikstream86@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 49 +++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 20c676b..7fc690f 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -19,7 +19,7 @@ static char *
 minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 {
 	const struct mcs_group *mg;
-	unsigned int j, tp, prob, eprob;
+	unsigned int j, tp, prob, eprob, tx_time;
 	char htmode = '2';
 	char gimode = 'L';
 	u32 gflags;
@@ -45,12 +45,19 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		if (!(mi->groups[i].supported & BIT(j)))
 			continue;
 
-		if (gflags & IEEE80211_TX_RC_MCS)
-			p += sprintf(p, " HT%c0/%cGI ", htmode, gimode);
-		else if (gflags & IEEE80211_TX_RC_VHT_MCS)
-			p += sprintf(p, "VHT%c0/%cGI ", htmode, gimode);
-		else
-			p += sprintf(p, " CCK/%cP   ", j < 4 ? 'L' : 'S');
+		if (gflags & IEEE80211_TX_RC_MCS) {
+			p += sprintf(p, "HT%c0  ", htmode);
+			p += sprintf(p, "%cGI  ", gimode);
+			p += sprintf(p, "%d  ", mg->streams);
+		} else if (gflags & IEEE80211_TX_RC_VHT_MCS) {
+			p += sprintf(p, "VHT%c0 ", htmode);
+			p += sprintf(p, "%cGI ", gimode);
+			p += sprintf(p, "%d  ", mg->streams);
+		} else {
+			p += sprintf(p, "CCK    ");
+			p += sprintf(p, "%cP  ", j < 4 ? 'L' : 'S');
+			p += sprintf(p, "1 ");
+		}
 
 		*(p++) = (idx == mi->max_tp_rate[0]) ? 'A' : ' ';
 		*(p++) = (idx == mi->max_tp_rate[1]) ? 'B' : ' ';
@@ -59,21 +66,27 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		*(p++) = (idx == mi->max_prob_rate) ? 'P' : ' ';
 
 		if (gflags & IEEE80211_TX_RC_MCS) {
-			p += sprintf(p, " MCS%-2u ", (mg->streams - 1) * 8 + j);
+			p += sprintf(p, "  MCS%-2u", (mg->streams - 1) * 8 + j);
 		} else if (gflags & IEEE80211_TX_RC_VHT_MCS) {
-			p += sprintf(p, " MCS%-1u/%1u", j, mg->streams);
+			p += sprintf(p, "  MCS%-1u/%1u", j, mg->streams);
 		} else {
 			int r = bitrates[j % 4];
 
-			p += sprintf(p, " %2u.%1uM ", r / 10, r % 10);
+			p += sprintf(p, "   %2u.%1uM", r / 10, r % 10);
 		}
 
+		p += sprintf(p, "  %3u  ", idx);
+
+		/* tx_time[rate(i)] in usec */
+		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
+		p += sprintf(p, "%6u   ", tx_time);
+
 		tp = mr->cur_tp / 10;
 		prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mr->probability * 1000);
 
-		p += sprintf(p, " %4u.%1u %3u.%1u %3u.%1u "
-				"%3u %4u(%4u) %9llu(%9llu)\n",
+		p += sprintf(p, "%4u.%1u   %3u.%1u     %3u.%1u "
+				"%3u   %3u %-3u   %9llu   %-9llu\n",
 				tp / 10, tp % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
@@ -110,8 +123,14 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 
 	file->private_data = ms;
 	p = ms->buf;
-	p += sprintf(p, " type           rate      tpt eprob *prob "
-			"ret  *ok(*cum)        ok(      cum)\n");
+
+	p += sprintf(p, "\n");
+	p += sprintf(p, "              best   ________rate______    "
+			"__statistics__    ________last_______    "
+			"______sum-of________\n");
+	p += sprintf(p, "mode guard #  rate  [name   idx airtime]  [ ø(tp) "
+			"ø(prob)]  [prob.|retry|suc|att]  [#success | "
+			"#attempts]\n");
 
 	p = minstrel_ht_stats_dump(mi, MINSTREL_CCK_GROUP, p);
 	for (i = 0; i < MINSTREL_CCK_GROUP; i++)
@@ -123,7 +142,7 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 			"lookaround %d\n",
 			max(0, (int) mi->total_packets - (int) mi->sample_packets),
 			mi->sample_packets);
-	p += sprintf(p, "Average A-MPDU length: %d.%d\n",
+	p += sprintf(p, "Average # of aggregated frames per A-MPDU: %d.%d\n",
 		MINSTREL_TRUNC(mi->avg_ampdu_len),
 		MINSTREL_TRUNC(mi->avg_ampdu_len * 10) % 10);
 	ms->len = p - ms->buf;
-- 
2.3.0

