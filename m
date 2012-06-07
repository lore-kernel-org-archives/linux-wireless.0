Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rousseau.luceor.com ([91.121.31.107]:45485 "EHLO sro-lap"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932368Ab2FGOB0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 10:01:26 -0400
From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Subject: [PATCH] minstrel_ht: enable frame aggregation for fixed rate
Date: Thu,  7 Jun 2012 16:01:16 +0200
Message-Id: <1339077677-5836-1-git-send-email-sylvain.roger.rieunier@gmail.com> (sfid-20120607_160154_813284_E846A0A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2d1acc6..e2aa93e 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -626,8 +626,10 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* use fixed index if set */
-	if (mp->fixed_rate_idx != -1)
-		sample_idx = mp->fixed_rate_idx;
+	if (mp->fixed_rate_idx != -1) {
+		mi->max_tp_rate = mp->fixed_rate_idx;
+		sample_idx = -1;
+	}
 #endif
 
 	if (sample_idx >= 0) {
-- 
1.7.9.5

