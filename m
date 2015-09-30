Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53070 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029AbbI3L1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 07:27:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: netdev@vger.kernel.org
Cc: y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 06/12] mac80211: use ktime_get_seconds
Date: Wed, 30 Sep 2015 13:26:36 +0200
Message-Id: <1443612402-3000775-7-git-send-email-arnd@arndb.de> (sfid-20150930_133158_293350_9B2A1F64)
In-Reply-To: <1443612402-3000775-1-git-send-email-arnd@arndb.de>
References: <1443612402-3000775-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 code uses ktime_get_ts to measure the connected time.
As this uses monotonic time, it is y2038 safe on 32-bit systems,
but we still want to deprecate the use of 'timespec' because most
other users are broken.

This changes the code to use ktime_get_seconds() instead, which
avoids the timespec structure and is slightly more efficient.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
---
 net/mac80211/sta_info.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 64f1936350c6..c3644458e2ee 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -303,7 +303,6 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_hw *hw = &local->hw;
 	struct sta_info *sta;
-	struct timespec uptime;
 	int i;
 
 	sta = kzalloc(sizeof(*sta) + hw->sta_data_size, gfp);
@@ -339,8 +338,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	/* Mark TID as unreserved */
 	sta->reserved_tid = IEEE80211_TID_UNRESERVED;
 
-	ktime_get_ts(&uptime);
-	sta->last_connected = uptime.tv_sec;
+	sta->last_connected = ktime_get_seconds();
 	ewma_signal_init(&sta->avg_signal);
 	for (i = 0; i < ARRAY_SIZE(sta->chain_signal_avg); i++)
 		ewma_signal_init(&sta->chain_signal_avg[i]);
@@ -1813,7 +1811,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct rate_control_ref *ref = NULL;
-	struct timespec uptime;
 	u32 thr = 0;
 	int i, ac;
 
@@ -1838,8 +1835,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			 BIT(NL80211_STA_INFO_RX_DROP_MISC) |
 			 BIT(NL80211_STA_INFO_BEACON_LOSS);
 
-	ktime_get_ts(&uptime);
-	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
+	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
 
 	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES64) |
-- 
2.1.0.rc2

