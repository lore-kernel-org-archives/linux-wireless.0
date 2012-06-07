Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rousseau.luceor.com ([91.121.31.107]:45165 "EHLO sro-lap"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760696Ab2FGKzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 06:55:41 -0400
From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Subject: [PATCH] minstrel_ht: enable frame aggregation for fixed rate
Date: Thu,  7 Jun 2012 12:44:30 +0200
Message-Id: <1339065870-11507-1-git-send-email-sylvain.roger.rieunier@gmail.com> (sfid-20120607_125551_739578_C8D8EB17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when i was trying fixed rate in minstrel_ht, frame aggregation
was not working. so i fix it

Signed-off-by: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2d1acc6..0e502d7 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -626,8 +626,13 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* use fixed index if set */
-	if (mp->fixed_rate_idx != -1)
-		sample_idx = mp->fixed_rate_idx;
+	if (mp->fixed_rate_idx != -1) {
+		if(sample_idx >= 0) {
+			sample_idx = mp->fixed_rate_idx;
+		} else {
+			mi->max_tp_rate =  mp->fixed_rate_idx;	
+		}
+	}
 #endif
 
 	if (sample_idx >= 0) {
-- 
1.7.9.5

