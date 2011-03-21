Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:50676 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab1CUViP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 17:38:15 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id p2LLcDft020836
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:14 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by wpaz1.hot.corp.google.com with ESMTP id p2LLcChA030827
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:38:13 -0700
From: Paul Stewart <pstew@google.com>
Date: Mon, 21 Mar 2011 14:17:54 -0700
Subject: [PATCH 4/4] mac80211: Add bss info to that exported to station
To: linux-wireless@vger.kernel.org
Message-Id: <20110321213812.B606D20DEE@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note the use of sdata->local->hw.conf.ps_dtim_period since
sdata->vif.bss_conf.dtim_period seems to always be 0 (why
is that?)

Signed-off-by: Paul Stewart <pstew@google.com>
---
 net/mac80211/cfg.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3342135..bf5d28d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -342,7 +342,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			STATION_INFO_TX_FAILED |
 			STATION_INFO_TX_BITRATE |
 			STATION_INFO_RX_BITRATE |
-			STATION_INFO_RX_DROP_MISC;
+			STATION_INFO_RX_DROP_MISC |
+			STATION_INFO_BSS_PARAM;
 
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes = sta->rx_bytes;
@@ -389,6 +390,16 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->plink_state = sta->plink_state;
 #endif
 	}
+
+	sinfo->bss_param.flags = 0;
+	if (sdata->vif.bss_conf.use_cts_prot)
+		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
+	if (sdata->vif.bss_conf.use_short_preamble)
+		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
+	if (sdata->vif.bss_conf.use_short_slot)
+		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
+	sinfo->bss_param.dtim_period = sdata->local->hw.conf.ps_dtim_period;
+	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
 }
 
 
-- 
1.7.3.1

