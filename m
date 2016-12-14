Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53614 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbcLNTas (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 14:30:48 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] mac80211:  fix legacy and invalid rx-rate rpt
Date: Wed, 14 Dec 2016 11:30:38 -0800
Message-Id: <1481743838-20323-1-git-send-email-greearb@candelatech.com> (sfid-20161214_203106_040361_5B59E911)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This fixes obtaining the rate info via sta_set_sinfo
when the rx rate is invalid (for instance, on IBSS
interface that has received no frames from one of its
peers).

This also fixes a more general issue with rinfo->flags
not being properly initialized for legacy rates.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Patch is against 4.7

 net/mac80211/sta_info.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 01868f9..6d27813e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2057,6 +2057,7 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 		u16 brate;
 		unsigned int shift;
 
+		rinfo->flags = 0;
 		sband = local->hw.wiphy->bands[(rate >> 4) & 0xf];
 		brate = sband->bitrates[rate & 0xf].bitrate;
 		if (rinfo->bw == RATE_INFO_BW_5)
@@ -2072,14 +2073,15 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 }
 
-static void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
+static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
 	u16 rate = ACCESS_ONCE(sta_get_last_rx_stats(sta)->last_rate);
-
-	if (rate == STA_STATS_RATE_INVALID)
-		rinfo->flags = 0;
-	else
+	if (rate == STA_STATS_RATE_INVALID) {
+		return -EINVAL;
+	} else {
 		sta_stats_decode_rate(sta->local, rate, rinfo);
+		return 0;
+	}
 }
 
 static void sta_set_tidstats(struct sta_info *sta,
@@ -2284,8 +2286,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	}
 
 	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_BITRATE))) {
-		sta_set_rate_info_rx(sta, &sinfo->rxrate);
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
+		if (sta_set_rate_info_rx(sta, &sinfo->rxrate) == 0)
+			sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
 	}
 
 	sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
-- 
2.4.11
