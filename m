Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65246 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934785Ab1KJOPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 09:15:08 -0500
Received: by wyh15 with SMTP id 15so2729239wyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2011 06:15:07 -0800 (PST)
From: Patrick Kelle <patrick.kelle81@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Patrick Kelle <patrick.kelle81@gmail.com>
Subject: [PATCH] minstrel: Remove unused function parameter in calc_rate_durations()
Date: Thu, 10 Nov 2011 15:13:11 +0100
Message-Id: <1320934391-2574-1-git-send-email-patrick.kelle81@gmail.com> (sfid-20111110_151514_464896_F3DABDC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Patrick Kelle <patrick.kelle81@gmail.com>
---
 net/mac80211/rc80211_minstrel.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 8adac67..6fb908c 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -334,8 +334,8 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 
 
 static void
-calc_rate_durations(struct minstrel_sta_info *mi, struct ieee80211_local *local,
-                    struct minstrel_rate *d, struct ieee80211_rate *rate)
+calc_rate_durations(struct ieee80211_local *local, struct minstrel_rate *d,
+		    struct ieee80211_rate *rate)
 {
 	int erp = !!(rate->flags & IEEE80211_RATE_ERP_G);
 
@@ -402,8 +402,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 		mr->rix = i;
 		mr->bitrate = sband->bitrates[i].bitrate / 5;
-		calc_rate_durations(mi, local, mr,
-				&sband->bitrates[i]);
+		calc_rate_durations(local, mr, &sband->bitrates[i]);
 
 		/* calculate maximum number of retransmissions before
 		 * fallback (based on maximum segment size) */
-- 
1.7.7.1

