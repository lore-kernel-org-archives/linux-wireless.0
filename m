Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rousseau.luceor.com ([91.121.31.107]:46261 "EHLO sro-lap"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750917Ab2GIRZT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 13:25:19 -0400
From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Subject: [PATCH v3] minstrel_ht: enable frame aggregation for fixed rate
Date: Mon,  9 Jul 2012 19:25:09 +0200
Message-Id: <1341854709-558-1-git-send-email-sylvain.roger.rieunier@gmail.com> (sfid-20120709_192523_935858_56CC8A4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sample_idx is set to a value other than -1, it activates
IEEE80211_TX_CTL_RATE_CTRL_PROBE flag. but this flag Disabled frame
aggregation. to allow frame aggregation during fixed rate it is necessary to
set max_tp_rate, max_tp_rate2, max_prob_rate instead of sample_idx.

Signed-off-by: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index f9e51ef..fb1d4aa 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -626,8 +626,12 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* use fixed index if set */
-	if (mp->fixed_rate_idx != -1)
-		sample_idx = mp->fixed_rate_idx;
+	if (mp->fixed_rate_idx != -1) {
+		mi->max_tp_rate = mp->fixed_rate_idx;
+		mi->max_tp_rate2 = mp->fixed_rate_idx;
+		mi->max_prob_rate = mp->fixed_rate_idx;
+		sample_idx = -1;
+	}
 #endif
 
 	if (sample_idx >= 0) {
-- 
1.7.9.5

