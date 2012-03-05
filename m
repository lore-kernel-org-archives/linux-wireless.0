Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65328 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2CEXb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 18:31:57 -0500
Received: by mail-pw0-f46.google.com with SMTP id un15so3341146pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 15:31:56 -0800 (PST)
MIME-Version: 1.0
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH v4 2/2] mac80211: fix mesh airtime link metric estimating
Date: Mon,  5 Mar 2012 15:31:48 -0800
Message-Id: <1330990308-15077-2-git-send-email-thomas@cozybit.com> (sfid-20120306_003201_792999_E8BB3969)
In-Reply-To: <1330990308-15077-1-git-send-email-thomas@cozybit.com>
References: <1330990308-15077-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Airtime link metric estimation was broken in HT mesh, use
cfg80211_calculate_bitrate to get the right rate value.

Also factor out tx rate copying from sta_set_sinfo().

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
v2:
factor out rate copying (Johannes)

v3:
just factor out tx rate copying (Johannes)

v4:
pass by reference and add "_tx" (Johannes)

 net/mac80211/cfg.c       |   23 +++++++++++++++--------
 net/mac80211/mesh_hwmp.c |    6 ++++--
 net/mac80211/sta_info.h  |    3 +++
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6a77d4c..f6aacd8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -336,6 +336,20 @@ static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, in
 		rate->mcs = idx;
 }
 
+void sta_set_rate_info_tx(struct sta_info *sta,
+			  const struct ieee80211_tx_rate *rate,
+			  struct rate_info *rinfo)
+{
+	rinfo->flags = 0;
+	if (rate->flags & IEEE80211_TX_RC_MCS)
+		rinfo->flags |= RATE_INFO_FLAGS_MCS;
+	if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
+	rate_idx_to_bitrate(rinfo, sta, rate->idx);
+}
+
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -378,14 +392,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
 	}
 
-	sinfo->txrate.flags = 0;
-	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
-		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
-	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-		sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
-	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_SHORT_GI)
-		sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	rate_idx_to_bitrate(&sinfo->txrate, sta, sta->last_tx_rate.idx);
+	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
 
 	sinfo->rxrate.flags = 0;
 	if (sta->last_rx_rate_flag & RX_FLAG_HT)
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 31bc762..13a4cb8 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -323,6 +323,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
 	struct ieee80211_supported_band *sband;
+	struct rate_info rinfo;
 	/* This should be adjusted for each device */
 	int device_constant = 1 << ARITH_SHIFT;
 	int test_frame_len = TEST_FRAME_LEN << ARITH_SHIFT;
@@ -336,7 +337,9 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	if (sta->fail_avg >= 100)
 		return MAX_METRIC;
 
-	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
+	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &rinfo);
+	rate = cfg80211_calculate_bitrate(&rinfo);
+	if (WARN_ON(!rate))
 		return MAX_METRIC;
 
 	err = (sta->fail_avg << ARITH_SHIFT) / 100;
@@ -344,7 +347,6 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	/* bitrate is in units of 100 Kbps, while we need rate in units of
 	 * 1Mbps. This will be corrected on tx_time computation.
 	 */
-	rate = sband->bitrates[sta->last_tx_rate.idx].bitrate;
 	tx_time = (device_constant + 10 * test_frame_len / rate);
 	estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));
 	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT) ;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 23a97c9..92715c6 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -528,6 +528,9 @@ void sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
 int sta_info_flush(struct ieee80211_local *local,
 		   struct ieee80211_sub_if_data *sdata);
+void sta_set_rate_info_tx(struct sta_info *sta,
+			  const struct ieee80211_tx_rate *rate,
+			  struct rate_info *rinfo);
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 
-- 
1.7.5.4

