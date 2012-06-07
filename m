Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rousseau.luceor.com ([91.121.31.107]:56767 "EHLO sro-lap"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751724Ab2FGPjS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 11:39:18 -0400
From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Subject: [PATCH] minstrel_ht: enable frame aggregation for fixed rate
Date: Thu,  7 Jun 2012 17:39:07 +0200
Message-Id: <1339083547-12616-1-git-send-email-sylvain.roger.rieunier@gmail.com> (sfid-20120607_173921_113770_67297369)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when i was trying fixed rate in minstrel_ht, frame aggregation
was not working. so i fix it.
note : it's only use one chain

Signed-off-by: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2d1acc6..3abcb5b 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -626,8 +626,23 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* use fixed index if set */
-	if (mp->fixed_rate_idx != -1)
-		sample_idx = mp->fixed_rate_idx;
+	if (mp->fixed_rate_idx != -1) {
+		minstrel_ht_set_rate(mp, mi, &ar[0],  mp->fixed_rate_idx,
+			false, false);
+		/* Not using MRR, only use the first rate */
+		ar[1].count = 0;
+		ar[1].idx = -1;
+		
+		mi->total_packets++;
+
+		/* wraparound */
+		if (mi->total_packets == ~0) {
+			mi->total_packets = 0;
+			mi->sample_packets = 0;
+		}
+
+		return
+	}
 #endif
 
 	if (sample_idx >= 0) {
-- 
1.7.9.5

