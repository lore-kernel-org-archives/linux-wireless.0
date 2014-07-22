Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:36485
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756435AbaGVTAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:00:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix crash on getting sta info with uninitialized rate control
Date: Tue, 22 Jul 2014 21:00:26 +0200
Message-Id: <1406055626-9419-1-git-send-email-nbd@openwrt.org> (sfid-20140722_210040_664731_FAD3D15E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the expected throughput is queried before rate control has been
initialized, the minstrel op for it will crash while trying to access
the rate table.
Check for WLAN_STA_RATE_CONTROL before attempting to use the rate
control op.

Reported-by: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d7513a5..592f4b1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -472,12 +472,15 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	struct rate_control_ref *ref = local->rate_ctrl;
+	struct rate_control_ref *ref = NULL;
 	struct timespec uptime;
 	u64 packets = 0;
 	u32 thr = 0;
 	int i, ac;
 
+	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		ref = local->rate_ctrl;
+
 	sinfo->generation = sdata->local->sta_generation;
 
 	sinfo->filled = STATION_INFO_INACTIVE_TIME |
-- 
1.8.5.2 (Apple Git-48)

