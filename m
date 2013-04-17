Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:53560 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965961Ab3DQMMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:12:40 -0400
Received: by mail-we0-f172.google.com with SMTP id r3so1137200wey.31
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 05:12:39 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: cosmetics for minstrel_debugfs
Date: Wed, 17 Apr 2013 14:08:26 +0200
Message-Id: <1366200506-23584-1-git-send-email-karl.beldan@gmail.com> (sfid-20130417_141246_177216_DA25999F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

This changes the minstrel stats ouput from:

rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
 BCD   6         0.0        0.0        0.0          0(  0)          0           0

to:

rate      throughput  ewma prob  this prob  this succ/attempt   success    attempts
 BCD   6         0.0        0.0        0.0             0(  0)         0           0

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index d104834..fd0b9ca 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -68,7 +68,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 
 	file->private_data = ms;
 	p = ms->buf;
-	p += sprintf(p, "rate     throughput  ewma prob   this prob  "
+	p += sprintf(p, "rate      throughput  ewma prob  this prob  "
 			"this succ/attempt   success    attempts\n");
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
@@ -86,7 +86,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		eprob = MINSTREL_TRUNC(mr->probability * 1000);
 
 		p += sprintf(p, "  %6u.%1u   %6u.%1u   %6u.%1u        "
-				"%3u(%3u)   %8llu    %8llu\n",
+				"   %3u(%3u)  %8llu    %8llu\n",
 				tp / 10, tp % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
-- 
1.8.2

