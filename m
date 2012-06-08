Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52815 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2FHUbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 16:31:22 -0400
Received: by pbbrp8 with SMTP id rp8so2995089pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 13:31:22 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: Use signal strength as a proxy for expected datarate.
Date: Fri,  8 Jun 2012 13:31:09 -0700
Message-Id: <1339187469-12778-3-git-send-email-jason@cozybit.com> (sfid-20120608_223125_865428_82DCAB56)
In-Reply-To: <1339187469-12778-1-git-send-email-jason@cozybit.com>
References: <1339187469-12778-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

When establishing mesh paths with new stations, there is no historic
datarate information to compute the airtime link metric.  Up until now
we were just using a poor initial metric.  A better approach is to
use the signal strength as an indicator of how good the new link will
be.  Once traffic is exchanged with the station, the average datarate is
computed and the signal strength is not used anymore.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Reviewed-by: Jason Abele <jason@cozybit.com>
---
formerly sent as:
	[PATCH v3 5/5] mac80211: Use signal strength as a proxy for expected datarate.

 net/mac80211/mesh_hwmp.c |   67 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 22b327a..306b182 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -330,6 +330,66 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	return;
 }
 
+/* estimate link rate as a function of last rssi for sta */
+static unsigned int rssi_get_rate(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	enum ieee80211_band band = sta->local->oper_channel->band;
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->sta.ht_cap;
+	struct rate_info rinfo;
+	int i, rssi, rate, rate_max, rate_min = 10, maxidx = 0;
+	const int rssi_min = -100;
+	const int rssi_max = -20;
+
+	if (sta->last_signal >= 0)
+		return rate_min;
+
+	memset(&rinfo, 0, sizeof(rinfo));
+
+	if (ht_cap->ht_supported) {
+		for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
+			if (ht_cap->mcs.rx_mask[i])
+				maxidx = i*8 + fls(ht_cap->mcs.rx_mask[i]) - 1;
+		}
+		rinfo.flags |= RATE_INFO_FLAGS_MCS;
+		rinfo.flags |= (sta->sta.ht_cap.cap &
+				IEEE80211_HT_CAP_SUP_WIDTH_20_40) ?
+					RATE_INFO_FLAGS_40_MHZ_WIDTH :
+					0;
+		rinfo.flags |= (sta->sta.ht_cap.cap &
+				(IEEE80211_HT_CAP_SGI_20 |
+				 IEEE80211_HT_CAP_SGI_40)) ?
+						RATE_INFO_FLAGS_SHORT_GI :
+						0;
+		rinfo.mcs = maxidx;
+	} else {
+		struct ieee80211_supported_band *sband;
+
+		maxidx = fls(sta->sta.supp_rates[band]) - 1;
+		if (WARN_ON(maxidx < 0))
+			return rate_min;
+		sband = sta->local->hw.wiphy->bands[band];
+		rinfo.legacy = sband->bitrates[maxidx].bitrate;
+	}
+
+	rate_max = cfg80211_calculate_bitrate(&rinfo);
+
+	rssi = max(rssi_min, sta->last_signal);
+	rssi = min(rssi_max, rssi);
+
+	rate = ((rssi - rssi_min) * rate_max +
+		(rssi_max - rssi) * rate_min) /
+		(rssi_max - rssi_min);
+
+	if (WARN_ON(!rate))
+		rate = rate_min;
+
+	mhwmp_dbg("est. %d Mbps for %pM with rssi %d",
+		  rate / 10, sta->sta.addr, sta->last_signal);
+
+	return rate;
+}
+
 static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
@@ -345,8 +405,11 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	if (sta->fail_avg >= 100)
 		return MAX_METRIC;
 
-	/* If not enough values accumulated in rate average, assume 1 Mbps */
-	rate = max(ewma_read(&sta->avg_rate), 10UL);
+	if (sta->tx_packets > 100)
+		rate = max(ewma_read(&sta->avg_rate), 10UL);
+	else
+		/* Not enough traffic sent, use rx signal strengh as proxy */
+		rate = rssi_get_rate(sta);
 
 	/* bitrate is in units of 100 Kbps, while we need rate in units of
 	 * 1Mbps. This will be corrected on tx_time computation.
-- 
1.7.9.5

