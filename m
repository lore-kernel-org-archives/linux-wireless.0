Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:46971 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaETUX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 16:23:56 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH] mac80211: remove unused variables
Date: Tue, 20 May 2014 22:22:45 +0200
Message-Id: <1400617365-16573-1-git-send-email-antonio@meshcoding.com> (sfid-20140520_222359_369040_504F99E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

9dbd32e7dd9600b03c5a955980205446f3db0dfb accidentally
introduced two variables that are assigned but never used.

Remove them.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/cfg.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9e86dd5..d7513a5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -473,8 +473,6 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct rate_control_ref *ref = local->rate_ctrl;
-	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
 	struct timespec uptime;
 	u64 packets = 0;
 	u32 thr = 0;
@@ -593,14 +591,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
 
 	/* check if the driver has a SW RC implementation */
-	if (ref && ref->ops->get_expected_throughput) {
-		band = ieee80211_get_sdata_band(sta->sdata);
-		sband = sta->local->hw.wiphy->bands[band];
-
+	if (ref && ref->ops->get_expected_throughput)
 		thr = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
-	} else {
+	else
 		thr = drv_get_expected_throughput(local, &sta->sta);
-	}
 
 	if (thr != 0) {
 		sinfo->filled |= STATION_INFO_EXPECTED_THROUGHPUT;
-- 
1.8.5.5

