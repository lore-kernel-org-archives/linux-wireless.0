Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42062 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab2CBXqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 18:46:09 -0500
Received: by mail-pz0-f46.google.com with SMTP id r28so2528162daj.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 15:46:09 -0800 (PST)
MIME-Version: 1.0
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH v2 2/2] mac80211: fix mesh airtime link metric estimating
Date: Fri,  2 Mar 2012 15:46:03 -0800
Message-Id: <1330731963-9905-2-git-send-email-thomas@cozybit.com> (sfid-20120303_004613_947686_CA25BBF7)
In-Reply-To: <1330731963-9905-1-git-send-email-thomas@cozybit.com>
References: <1330731963-9905-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Airtime link metric estimation was broken in HT mesh, use
cfg80211_calculate_bitrate to get the right rate value.

Also factor out rate copying from sta_set_sinfo().

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
v2:
factor out rate copying (Johannes)

 net/mac80211/cfg.c       |   39 ++++++++++++++++++++++-----------------
 net/mac80211/mesh_hwmp.c |    6 ++++--
 net/mac80211/sta_info.h  |    1 +
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6a77d4c..ddef553 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -336,6 +336,27 @@ static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, in
 		rate->mcs = idx;
 }
 
+void sta_set_rate_info(struct sta_info *sta, struct station_info *sinfo)
+{
+	sinfo->txrate.flags = 0;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_SHORT_GI)
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+	rate_idx_to_bitrate(&sinfo->txrate, sta, sta->last_tx_rate.idx);
+
+	sinfo->rxrate.flags = 0;
+	if (sta->last_rx_rate_flag & RX_FLAG_HT)
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_MCS;
+	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+	rate_idx_to_bitrate(&sinfo->rxrate, sta, sta->last_rx_rate_idx);
+}
+
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -378,23 +399,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
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
-
-	sinfo->rxrate.flags = 0;
-	if (sta->last_rx_rate_flag & RX_FLAG_HT)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_MCS;
-	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
-	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
-		sinfo->rxrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	rate_idx_to_bitrate(&sinfo->rxrate, sta, sta->last_rx_rate_idx);
+	sta_set_rate_info(sta, sinfo);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 31bc762..5ea6f49 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -323,6 +323,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
 	struct ieee80211_supported_band *sband;
+	struct station_info sinfo;
 	/* This should be adjusted for each device */
 	int device_constant = 1 << ARITH_SHIFT;
 	int test_frame_len = TEST_FRAME_LEN << ARITH_SHIFT;
@@ -336,7 +337,9 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	if (sta->fail_avg >= 100)
 		return MAX_METRIC;
 
-	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
+	sta_set_rate_info(sta, &sinfo);
+	rate = cfg80211_calculate_bitrate(&sinfo.txrate);
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
index 23a97c9..a58b965 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -528,6 +528,7 @@ void sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
 int sta_info_flush(struct ieee80211_local *local,
 		   struct ieee80211_sub_if_data *sdata);
+void sta_set_rate_info(struct sta_info *sta, struct station_info *sinfo);
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 
-- 
1.7.5.4

