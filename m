Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3BEJ4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 04:56:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: qca_vkondrat@qca.qualcomm.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: provide 64-bit traffic counters
Date: Tue,  5 Feb 2013 10:56:44 +0100
Message-Id: <1360058204-12208-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_105632_028597_BD46E2C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

"unsigned long" is already 64-bit on (most?) 64-bit
machines, use u64 and tell cfg80211 that we provide
64-bit counters now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 4 ++--
 net/mac80211/ieee80211_i.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f4f7e76..fb06d13 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -449,8 +449,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	sinfo->generation = sdata->local->sta_generation;
 
 	sinfo->filled = STATION_INFO_INACTIVE_TIME |
-			STATION_INFO_RX_BYTES |
-			STATION_INFO_TX_BYTES |
+			STATION_INFO_RX_BYTES64 |
+			STATION_INFO_TX_BYTES64 |
 			STATION_INFO_RX_PACKETS |
 			STATION_INFO_TX_PACKETS |
 			STATION_INFO_TX_RETRIES |
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2b06ff1..4631de0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -822,7 +822,7 @@ struct tpt_led_trigger {
 	unsigned int blink_table_len;
 	struct timer_list timer;
 	unsigned long prev_traffic;
-	unsigned long tx_bytes, rx_bytes;
+	u64 tx_bytes, rx_bytes;
 	unsigned int active, want;
 	bool running;
 };
-- 
1.8.0

