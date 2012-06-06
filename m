Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968Ab2FFWtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 18:49:15 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so168376pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 15:49:15 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/6] mac80211: Change rssi_get_rate to interpolated data rates.
Date: Wed,  6 Jun 2012 15:48:52 -0700
Message-Id: <1339022932-14240-7-git-send-email-jason@cozybit.com> (sfid-20120607_004924_424051_C7401D4F)
In-Reply-To: <1339022932-14240-1-git-send-email-jason@cozybit.com>
References: <1339022932-14240-1-git-send-email-jason@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Jason Abele <jason@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |   58 +++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index bb32203..86fc9e5 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -338,38 +338,20 @@ static unsigned int rssi_get_rate(struct sta_info *sta)
 	enum ieee80211_band band = sta->local->oper_channel->band;
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->sta.ht_cap;
 	struct rate_info rinfo;
-	int i, ridx, ci = 0;
-	int rssi, rate;
-	u32 cidx[IEEE80211_MAX_SUPP_RATES];
+	int i, rssi, rate, rate_max, rate_min = 10, maxidx = 0;
+	const int rssi_min = -100;
+	const int rssi_max = -20;
 
 	if (sta->last_signal >= 0)
-		return 0;
+		return rate_min;
 
 	memset(&rinfo, sizeof(rinfo), 0);
 
-	/* make rates contiguous */
-	for (i = 0; i < IEEE80211_MAX_SUPP_RATES; i++) {
-		if (ht_cap->ht_supported &&
-		    !(ht_cap->mcs.rx_mask[i / 8] & (i % 8)))
-			continue;
-
-		if (!(sta->sta.supp_rates[band] & BIT(i)))
-			continue;
-
-		cidx[ci++] = i;
-	}
-
-	/* map rssi in range 20 - 70 to rates 32 - 0 */
-#define RSSI_OFF 20
-#define RSSI_MAX 50
-	rssi = abs(sta->last_signal) - RSSI_OFF;
-	rssi = max(rssi, 0);
-	rssi = min(rssi, RSSI_MAX);
-	/* invert rssi against ci and get the supported nth rate */
-	/* TODO: make this non-linear */
-	ridx = cidx[min((int)(ci * (1 - ((float) rssi / RSSI_MAX))), ci)];
-
 	if (ht_cap->ht_supported) {
+		for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
+			if (ht_cap->mcs.rx_mask[i])
+				maxidx = i*8 + fls(ht_cap->mcs.rx_mask[i]) - 1;
+		}
 		rinfo.flags |= RATE_INFO_FLAGS_MCS;
 		rinfo.flags |= (sta->sta.ht_cap.cap &
 				IEEE80211_HT_CAP_SUP_WIDTH_20_40) ?
@@ -380,18 +362,32 @@ static unsigned int rssi_get_rate(struct sta_info *sta)
 				 IEEE80211_HT_CAP_SGI_40)) ?
 						RATE_INFO_FLAGS_SHORT_GI :
 						0;
-		rinfo.mcs = ridx;
+		rinfo.mcs = maxidx;
 	} else {
 		struct ieee80211_supported_band *sband;
+
+		maxidx = fls(sta->sta.supp_rates[band]) - 1;
+		if (WARN_ON(maxidx < 0))
+			return rate_min;
 		sband = sta->local->hw.wiphy->bands[band];
-		rinfo.legacy = sband->bitrates[ridx].bitrate;
+		rinfo.legacy = sband->bitrates[maxidx].bitrate;
 	}
 
-	rate = cfg80211_calculate_bitrate(&rinfo);
+	rate_max = cfg80211_calculate_bitrate(&rinfo);
+
+	rssi = max(rssi_min, sta->last_signal);
+	rssi = min(rssi_max, rssi);
+
+	rate = ((rssi - rssi_min) * rate_max +
+		(rssi_max - rssi) * rate_min) /
+		(rssi_max - rssi_min);
+
 	if (WARN_ON(!rate))
-		rate = 10;
-	mhwmp_dbg("est. %d Mbps for %pM with rssi %d\n",
+		rate = rate_min;
+
+	mhwmp_dbg("\nest. %d Mbps for %pM with rssi %d\n",
 		  rate/10, sta->sta.addr, sta->last_signal);
+
 	return rate;
 }
 
-- 
1.7.9.5

