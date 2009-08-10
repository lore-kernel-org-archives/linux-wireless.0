Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:33616 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZHJT1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:27:36 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1077455rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 12:27:37 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH 4/7] mac80211: Update the station failed frames average when minstrel is used.
Date: Mon, 10 Aug 2009 12:15:49 -0700
Message-Id: <1249931752-18127-5-git-send-email-javier@cozybit.com>
In-Reply-To: <1249931752-18127-4-git-send-email-javier@cozybit.com>
References: <20090810175225.GF2733@tuxdriver.com>
 <1249931752-18127-1-git-send-email-javier@cozybit.com>
 <1249931752-18127-2-git-send-email-javier@cozybit.com>
 <1249931752-18127-3-git-send-email-javier@cozybit.com>
 <1249931752-18127-4-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fail_avg value is used to compute the mesh metric, and was only being set
by the pid rate control module. This fixes the mesh path selection mechanism
for cards that use mistrel for rate control.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/rc80211_minstrel.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 7c51429..3ea9740 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -155,12 +155,16 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		   struct sk_buff *skb)
 {
 	struct minstrel_sta_info *mi = priv_sta;
+	struct minstrel_priv *mp = (struct minstrel_priv *)priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *ar = info->status.rates;
+	struct ieee80211_local *local = hw_to_local(mp->hw);
+	struct sta_info *si;
 	int i, ndx;
 	int success;
 
 	success = !!(info->flags & IEEE80211_TX_STAT_ACK);
+	si = sta_info_get(local, sta->addr);
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		if (ar[i].idx < 0)
@@ -172,8 +176,12 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 
 		mi->r[ndx].attempts += ar[i].count;
 
-		if ((i != IEEE80211_TX_MAX_RATES - 1) && (ar[i + 1].idx < 0))
+		if ((i != IEEE80211_TX_MAX_RATES - 1) && (ar[i + 1].idx < 0)) {
 			mi->r[ndx].success += success;
+			if (si)
+				si->fail_avg = (18050 - mi->r[ndx].probability)
+					/ 180;
+		}
 	}
 
 	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) && (i >= 0))
-- 
1.5.4.3

