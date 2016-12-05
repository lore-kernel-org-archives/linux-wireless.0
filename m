Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60154 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcLEWMS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 17:12:18 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  fix rx-rate report when rate is invalid.
Date: Mon,  5 Dec 2016 14:12:15 -0800
Message-Id: <1480975935-12760-1-git-send-email-greearb@candelatech.com> (sfid-20161205_231221_066094_0B3137AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This fixes obtaining the rate info via sta_set_sinfo
when the rx rate is invalid (for instance, on IBSS
interface that has received no frames from one of its
peers).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/sta_info.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 01868f9..868dc88 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2076,10 +2076,12 @@ static void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
 	u16 rate = ACCESS_ONCE(sta_get_last_rx_stats(sta)->last_rate);
 
-	if (rate == STA_STATS_RATE_INVALID)
-		rinfo->flags = 0;
-	else
+	if (rate == STA_STATS_RATE_INVALID) {
+		rinfo->flags = 0; /* means use legacy rates */
+		rinfo->legacy = 0; /* Initialize legacy rates to known value */
+	} else {
 		sta_stats_decode_rate(sta->local, rate, rinfo);
+	}
 }
 
 static void sta_set_tidstats(struct sta_info *sta,
-- 
2.4.11
