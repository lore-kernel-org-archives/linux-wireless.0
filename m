Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64667 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3KTSOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 13:14:30 -0500
Received: by mail-wg0-f44.google.com with SMTP id k14so9312637wgh.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 10:14:29 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2] mac80211: use capped prob when computing throughputs
Date: Wed, 20 Nov 2013 19:13:35 +0100
Message-Id: <1384971215-16302-1-git-send-email-karl.beldan@gmail.com> (sfid-20131120_191433_549119_8D3DFF8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
it to compute the per rate throughput.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 9702d88..7817a23 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -333,7 +333,7 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
 
 	nsecs += minstrel_mcs_groups[group].duration[rate];
-	tp = 1000000 * ((mr->probability * 1000) / nsecs);
+	tp = 1000000 * ((prob * 1000) / nsecs);
 
 	mr->cur_tp = MINSTREL_TRUNC(tp);
 }
-- 
1.8.2

