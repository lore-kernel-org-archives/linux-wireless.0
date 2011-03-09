Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51005 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab1CIJCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 04:02:47 -0500
Received: by eyx24 with SMTP id 24so77477eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 01:02:46 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2] mac80211: Shortcut minstrel_ht rate setup for non-MRR capable devices
Date: Wed,  9 Mar 2011 10:02:38 +0100
Message-Id: <1299661358-8843-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices without multi rate retry support won't be able to use all rates
as specified by mintrel_ht. Hence, we can simply skip setting up further
rates as the devices will only use the first one.

Also add a special case for devices with only two possible tx rates. We
use sample_rate -> max_prob_rate for sampling and max_tp_rate ->
max_prob_rate by default.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

v2: Add special case handling for devices with a maximum of two tx rates.

 net/mac80211/rc80211_minstrel_ht.c |   41 +++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 775cf15..0985324 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -603,19 +603,46 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		sample = true;
 		minstrel_ht_set_rate(mp, mi, &ar[0], sample_idx,
 			txrc, true, false);
-		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate,
-			txrc, false, false);
 		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	} else {
 		minstrel_ht_set_rate(mp, mi, &ar[0], mi->max_tp_rate,
 			txrc, false, false);
-		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate2,
-			txrc, false, true);
 	}
-	minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate, txrc, false, !sample);
 
-	ar[3].count = 0;
-	ar[3].idx = -1;
+	if (mp->hw->max_rates >= 3) {
+		/*
+		 * At least 3 tx rates supported, use
+		 * sample_rate -> max_tp_rate -> max_prob_rate for sampling and
+		 * max_tp_rate -> max_tp_rate2 -> max_prob_rate by default.
+		 */
+		if (sample_idx >= 0)
+			minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate,
+				txrc, false, false);
+		else
+			minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate2,
+				txrc, false, true);
+
+		minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate,
+				     txrc, false, !sample);
+
+		ar[3].count = 0;
+		ar[3].idx = -1;
+	} else if (mp->hw->max_rates == 2) {
+		/*
+		 * Only 2 tx rates supported, use
+		 * sample_rate -> max_prob_rate for sampling and
+		 * max_tp_rate -> max_prob_rate by default.
+		 */
+		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_prob_rate,
+				     txrc, false, !sample);
+
+		ar[2].count = 0;
+		ar[2].idx = -1;
+	} else {
+		/* Not using MRR, only use the first rate */
+		ar[1].count = 0;
+		ar[1].idx = -1;
+	}
 
 	mi->total_packets++;
 
-- 
1.7.1

