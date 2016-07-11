Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:48790 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178AbcGKONa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 10:13:30 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Maxim Altshul <maxim.altshul@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3] mac80211: mesh: Add support for HW RC implementation
Date: Mon, 11 Jul 2016 17:15:24 +0300
Message-ID: <20160711141539.30281-1-maxim.altshul@ti.com> (sfid-20160711_161413_500429_6555C338)
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
1. Added DIV_ROUND_UP to protect from rate < 100Kbps
2. Removed redudant initialization

 net/mac80211/mesh_hwmp.c | 27 +++++++++++++++++++--------
 net/mac80211/sta_info.c  | 23 +++++++++++++++++++----
 net/mac80211/sta_info.h  |  2 ++
 3 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index c6be0b4..befb1e7 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -326,22 +326,33 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	u32 tx_time, estimated_retx;
 	u64 result;
 
-	if (sta->mesh->fail_avg >= 100)
-		return MAX_METRIC;
+	/* Try to get rate based on HW/SW RC algorithm.
+	 * Rate is returned in units of Kbps, correct this
+	 * to comply with airtime calculation units
+	 * Round up in case we get rate < 100Kbps
+	 */
+	rate = DIV_ROUND_UP(sta_get_expected_throughput(sta), 100);
+	
+	if (rate) {
+		err = 0;
+	} else {
+		if (sta->mesh->fail_avg >= 100)
+			return MAX_METRIC;
 
-	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
-	rate = cfg80211_calculate_bitrate(&rinfo);
-	if (WARN_ON(!rate))
-		return MAX_METRIC;
+		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
+		rate = cfg80211_calculate_bitrate(&rinfo);
+		if (WARN_ON(!rate))
+			return MAX_METRIC;
 
-	err = (sta->mesh->fail_avg << ARITH_SHIFT) / 100;
+		err = (sta->mesh->fail_avg << ARITH_SHIFT) / 100;
+	}
 
 	/* bitrate is in units of 100 Kbps, while we need rate in units of
 	 * 1Mbps. This will be corrected on tx_time computation.
 	 */
 	tx_time = (device_constant + 10 * test_frame_len / rate);
 	estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));
-	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT) ;
+	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT);
 	return (u32)result;
 }
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 63ea6cb..fa2c507 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2069,14 +2069,29 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
 
+	thr = sta_get_expected_throughput(sta);
+
+	if (thr != 0) {
+		sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
+		sinfo->expected_throughput = thr;
+	}
+}
+
+u32 sta_get_expected_throughput(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct rate_control_ref *ref = NULL;
+	u32 thr = 0;
+
+	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		ref = local->rate_ctrl;
+
 	/* check if the driver has a SW RC implementation */
 	if (ref && ref->ops->get_expected_throughput)
 		thr = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
 	else
 		thr = drv_get_expected_throughput(local, &sta->sta);
 
-	if (thr != 0) {
-		sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
-		sinfo->expected_throughput = thr;
-	}
+	return thr;
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 2cafb21..5c9c8be 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -661,6 +661,8 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 			  struct rate_info *rinfo);
 void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo);
 
+u32 sta_get_expected_throughput(struct sta_info *sta);
+
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 u8 sta_info_tx_streams(struct sta_info *sta);
-- 
2.9.0

