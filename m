Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55523 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3KTAvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 19:51:50 -0500
Received: by mail-wi0-f170.google.com with SMTP id f4so7413726wiw.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 16:51:49 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: use capped prob when computing throughputs
Date: Wed, 20 Nov 2013 01:51:08 +0100
Message-Id: <1384908668-27869-1-git-send-email-karl.beldan@gmail.com> (sfid-20131120_015154_118817_DC97EE72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
it to compute the rate throughput.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
CC: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 9702d88..341e6f7 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -333,7 +333,7 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
 
 	nsecs += minstrel_mcs_groups[group].duration[rate];
-	tp = 1000000 * ((mr->probability * 1000) / nsecs);
+	tp = 1000000 * (prob * 1000) / nsecs;
 
 	mr->cur_tp = MINSTREL_TRUNC(tp);
 }
-- 
1.8.2

