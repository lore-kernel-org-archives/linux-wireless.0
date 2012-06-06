Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2FFWtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 18:49:14 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so168376pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 15:49:13 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/6] mac80211: Use signal strength as a proxy for expected datarate.
Date: Wed,  6 Jun 2012 15:48:51 -0700
Message-Id: <1339022932-14240-6-git-send-email-jason@cozybit.com> (sfid-20120607_004920_913952_9D005E35)
In-Reply-To: <1339022932-14240-1-git-send-email-jason@cozybit.com>
References: <1339022932-14240-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Pedersen <thomas@cozybit.com>

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
 net/mac80211/mesh_hwmp.c |   72 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 22b327a..bb32203 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -330,6 +330,71 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	return;
 }
 
+/* estimate link rate as a function of last rssi for sta */
+static unsigned int rssi_get_rate(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	/* XXX: oper_channel is moving to sdata upstream */
+	enum ieee80211_band band = sta->local->oper_channel->band;
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->sta.ht_cap;
+	struct rate_info rinfo;
+	int i, ridx, ci = 0;
+	int rssi, rate;
+	u32 cidx[IEEE80211_MAX_SUPP_RATES];
+
+	if (sta->last_signal >= 0)
+		return 0;
+
+	memset(&rinfo, sizeof(rinfo), 0);
+
+	/* make rates contiguous */
+	for (i = 0; i < IEEE80211_MAX_SUPP_RATES; i++) {
+		if (ht_cap->ht_supported &&
+		    !(ht_cap->mcs.rx_mask[i / 8] & (i % 8)))
+			continue;
+
+		if (!(sta->sta.supp_rates[band] & BIT(i)))
+			continue;
+
+		cidx[ci++] = i;
+	}
+
+	/* map rssi in range 20 - 70 to rates 32 - 0 */
+#define RSSI_OFF 20
+#define RSSI_MAX 50
+	rssi = abs(sta->last_signal) - RSSI_OFF;
+	rssi = max(rssi, 0);
+	rssi = min(rssi, RSSI_MAX);
+	/* invert rssi against ci and get the supported nth rate */
+	/* TODO: make this non-linear */
+	ridx = cidx[min((int)(ci * (1 - ((float) rssi / RSSI_MAX))), ci)];
+
+	if (ht_cap->ht_supported) {
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
+		rinfo.mcs = ridx;
+	} else {
+		struct ieee80211_supported_band *sband;
+		sband = sta->local->hw.wiphy->bands[band];
+		rinfo.legacy = sband->bitrates[ridx].bitrate;
+	}
+
+	rate = cfg80211_calculate_bitrate(&rinfo);
+	if (WARN_ON(!rate))
+		rate = 10;
+	mhwmp_dbg("est. %d Mbps for %pM with rssi %d\n",
+		  rate/10, sta->sta.addr, sta->last_signal);
+	return rate;
+}
+
 static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
@@ -345,8 +410,11 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
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

