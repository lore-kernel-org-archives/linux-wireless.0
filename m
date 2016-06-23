Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54180 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbcFWNvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 09:51:36 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Maxim Altshul <maxim.altshul@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: mesh: Add support for HW RC implementation
Date: Thu, 23 Jun 2016 16:53:11 +0300
Message-ID: <20160623135319.7653-1-maxim.altshul@ti.com> (sfid-20160623_155152_638548_6A1ACC25)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh HWMP module will be able to rely on the HW
RC algorithm if it exists, for path metric calculations.

This allows the metric calculation mechanism to calculate
a correct metric, based on PER and last TX rate both via
HW RC algorithm if it exists or via parameters collected
by the SW.

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
Changed previous implementation according to Johannes's
comment. Combined the RC test and throughput assignment
to a sta_get_expected_throughput function.
Using the function both from airtime_link_metric and
from sta_set_sinfo. 

 net/mac80211/mesh_hwmp.c | 22 ++++++++++++++--------
 net/mac80211/sta_info.c  | 22 +++++++++++++++++-----
 net/mac80211/sta_info.h  |  2 ++
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index c6be0b4..39f9541 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -322,19 +322,25 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	int device_constant = 1 << ARITH_SHIFT;
 	int test_frame_len = TEST_FRAME_LEN << ARITH_SHIFT;
 	int s_unit = 1 << ARITH_SHIFT;
-	int rate, err;
+	int rate = 0, err = 0;
 	u32 tx_time, estimated_retx;
 	u64 result;
 
-	if (sta->mesh->fail_avg >= 100)
-		return MAX_METRIC;
+	/* try to get rate based on HW/SW RC algorithm */
+	sta_get_expected_throughput(sta, &rate);
 
-	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
-	rate = cfg80211_calculate_bitrate(&rinfo);
-	if (WARN_ON(!rate))
-		return MAX_METRIC;
+	/* if we did not get a rate */
+	if (!rate) {
+		if (sta->mesh->fail_avg >= 100)
+			return MAX_METRIC;
 
-	err = (sta->mesh->fail_avg << ARITH_SHIFT) / 100;
+		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
+		rate = cfg80211_calculate_bitrate(&rinfo);
+		if (WARN_ON(!rate))
+			return MAX_METRIC;
+
+		err = (sta->mesh->fail_avg << ARITH_SHIFT) / 100;
+	}
 
 	/* bitrate is in units of 100 Kbps, while we need rate in units of
 	 * 1Mbps. This will be corrected on tx_time computation.
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 63ea6cb..9580946 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2069,14 +2069,26 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
 
-	/* check if the driver has a SW RC implementation */
-	if (ref && ref->ops->get_expected_throughput)
-		thr = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
-	else
-		thr = drv_get_expected_throughput(local, &sta->sta);
+	sta_get_expected_throughput(sta, &thr);
 
 	if (thr != 0) {
 		sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
 		sinfo->expected_throughput = thr;
 	}
 }
+
+void sta_get_expected_throughput(struct sta_info *sta, u32 *thr)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct rate_control_ref *ref = NULL;
+
+	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		ref = local->rate_ctrl;
+
+	/* check if the driver has a SW RC implementation */
+	if (ref && ref->ops->get_expected_throughput)
+		*thr = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
+	else
+		*thr = drv_get_expected_throughput(local, &sta->sta);
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 2cafb21..8535443 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -661,6 +661,8 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 			  struct rate_info *rinfo);
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo);
 
+void sta_get_expected_throughput(struct sta_info *sta, u32 *thr);
+
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 u8 sta_info_tx_streams(struct sta_info *sta);
-- 
2.9.0

