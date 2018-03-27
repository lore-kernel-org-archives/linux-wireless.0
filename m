Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36316 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbeC0GuW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 02:50:22 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFC 3/3] mac80211: Use proper chan_width enum in sta opmode event
Date: Tue, 27 Mar 2018 12:18:16 +0530
Message-Id: <1522133296-2583-4-git-send-email-tamizhr@codeaurora.org> (sfid-20180327_085025_924058_FCAAF1D1)
In-Reply-To: <1522133296-2583-1-git-send-email-tamizhr@codeaurora.org>
References: <1522133296-2583-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bandwidth change value reported via nl80211 contains mac80211
specific enum value(ieee80211_sta_rx_bw) and which is not
understand by userspace application. Map the mac80211 specific
value to nl80211_chan_width enum value to avoid using wrong value
in the userspace application. And used station's ht/vht capability
to map IEEE80211_STA_RX_BW_20 and IEEE80211_STA_RX_BW_160 with
proper nl80211 value.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/rx.c          |  3 ++-
 net/mac80211/vht.c         | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9237ffb..6c341d8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1816,6 +1816,8 @@ void ieee80211_apply_vhtcap_overrides(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_sta_vht_cap *vht_cap);
 void ieee80211_get_vht_mask_from_cap(__le16 vht_cap,
 				     u16 vht_mask[NL80211_VHT_NSS_MAX]);
+enum nl80211_chan_width
+ieee80211_sta_rx_bw_to_chan_width(struct sta_info *sta);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f8c69ac..3a9f0c0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2922,7 +2922,8 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 
 			rx->sta->sta.bandwidth = new_bw;
 			sband = rx->local->hw.wiphy->bands[status->band];
-			sta_opmode.bw = new_bw;
+			sta_opmode.bw =
+				ieee80211_sta_rx_bw_to_chan_width(rx->sta);
 			sta_opmode.changed = STA_OPMODE_MAX_BW_CHANGED;
 
 			rate_control_rate_update(local, sband, rx->sta,
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 5714dee..259325c 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -358,6 +358,36 @@ enum nl80211_chan_width ieee80211_sta_cap_chan_bw(struct sta_info *sta)
 	return NL80211_CHAN_WIDTH_80;
 }
 
+enum nl80211_chan_width
+ieee80211_sta_rx_bw_to_chan_width(struct sta_info *sta)
+{
+	enum ieee80211_sta_rx_bandwidth cur_bw = sta->sta.bandwidth;
+	struct ieee80211_sta_vht_cap *vht_cap = &sta->sta.vht_cap;
+	u32 cap_width;
+
+	switch (cur_bw) {
+	case IEEE80211_STA_RX_BW_20:
+		if (!sta->sta.ht_cap.ht_supported)
+			return NL80211_CHAN_WIDTH_20_NOHT;
+		else
+			return NL80211_CHAN_WIDTH_20;
+	case IEEE80211_STA_RX_BW_40:
+		return NL80211_CHAN_WIDTH_40;
+	case IEEE80211_STA_RX_BW_80:
+		return NL80211_CHAN_WIDTH_80;
+	case IEEE80211_STA_RX_BW_160:
+		cap_width =
+			vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+
+		if (cap_width == IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ)
+			return NL80211_CHAN_WIDTH_160;
+
+		return NL80211_CHAN_WIDTH_80P80;
+	default:
+		return NL80211_CHAN_WIDTH_20;
+	}
+}
+
 enum ieee80211_sta_rx_bandwidth
 ieee80211_chan_width_to_rx_bw(enum nl80211_chan_width width)
 {
@@ -484,7 +514,7 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	new_bw = ieee80211_sta_cur_vht_bw(sta);
 	if (new_bw != sta->sta.bandwidth) {
 		sta->sta.bandwidth = new_bw;
-		sta_opmode.bw = new_bw;
+		sta_opmode.bw = ieee80211_sta_rx_bw_to_chan_width(sta);
 		changed |= IEEE80211_RC_BW_CHANGED;
 		sta_opmode.changed |= STA_OPMODE_MAX_BW_CHANGED;
 	}
-- 
1.9.1
