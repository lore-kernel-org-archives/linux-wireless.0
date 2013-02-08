Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59056 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760074Ab3BHMiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 07:38:07 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/3] mac80211/minstrel_ht: show the number of retries for each rate in debugfs
Date: Fri,  8 Feb 2013 13:38:01 +0100
Message-Id: <1360327083-57298-1-git-send-email-nbd@openwrt.org> (sfid-20130208_133819_223545_8E7B75C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index e788f76..f2b7d26 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -38,8 +38,8 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 
 	file->private_data = ms;
 	p = ms->buf;
-	p += sprintf(p, "type      rate     throughput  ewma prob   this prob  "
-			"this succ/attempt   success    attempts\n");
+	p += sprintf(p, "type         rate     throughput  ewma prob   this prob  "
+			"retry   this succ/attempt   success    attempts\n");
 	for (i = 0; i < MINSTREL_MAX_STREAMS * MINSTREL_STREAM_GROUPS; i++) {
 		char htmode = '2';
 		char gimode = 'L';
@@ -64,18 +64,19 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 			*(p++) = (idx == mi->max_tp_rate) ? 'T' : ' ';
 			*(p++) = (idx == mi->max_tp_rate2) ? 't' : ' ';
 			*(p++) = (idx == mi->max_prob_rate) ? 'P' : ' ';
-			p += sprintf(p, "MCS%-2u", (minstrel_mcs_groups[i].streams - 1) *
+			p += sprintf(p, " MCS%-2u", (minstrel_mcs_groups[i].streams - 1) *
 					MCS_GROUP_RATES + j);
 
 			tp = mr->cur_tp / 10;
 			prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
 			eprob = MINSTREL_TRUNC(mr->probability * 1000);
 
-			p += sprintf(p, "  %6u.%1u   %6u.%1u   %6u.%1u        "
-					"%3u(%3u)   %8llu    %8llu\n",
+			p += sprintf(p, "      %6u.%1u   %6u.%1u    %6u.%1u    "
+					"%3u            %3u(%3u)  %8llu    %8llu\n",
 					tp / 10, tp % 10,
 					eprob / 10, eprob % 10,
 					prob / 10, prob % 10,
+					mr->retry_count,
 					mr->last_success,
 					mr->last_attempts,
 					(unsigned long long)mr->succ_hist,
-- 
1.8.0.2

