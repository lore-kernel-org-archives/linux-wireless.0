Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaLNJKv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 04:10:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/4] mac80211: update sta bw on ht chanwidth action frame
Date: Sun, 14 Dec 2014 11:05:51 +0200
Message-Id: <1418547953-17699-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141214_101111_169923_8C1D43F2)
In-Reply-To: <1418547953-17699-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1418547953-17699-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Commit e1a0c6b ("mac80211: stop toggling IEEE80211_HT_CAP_SUP_WIDTH_20_40")
mistakenly removed the actual update of sta->sta.bandwidth.

Refactor ieee80211_sta_cur_vht_bw() into multiple functions
(calculate caps-bw and chandef-bw separately, and min them
with cur_max_bandwidth).

On ht chanwidth action frame set only cur_max_bandwidth
(according to the sta capabilities) and recalc the sta bw.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/rx.c          | 11 +++++--
 net/mac80211/vht.c         | 73 ++++++++++++++++++++++++----------------------
 3 files changed, 47 insertions(+), 38 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cc6e964..4f45cab 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1704,6 +1704,7 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_supported_band *sband,
 				    const struct ieee80211_vht_cap *vht_cap_ie,
 				    struct sta_info *sta);
+enum ieee80211_sta_rx_bandwidth ieee80211_sta_cap_rx_bw(struct sta_info *sta);
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
 u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 49c23bd..444ebff 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2597,7 +2597,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		case WLAN_HT_ACTION_NOTIFY_CHANWIDTH: {
 			struct ieee80211_supported_band *sband;
 			u8 chanwidth = mgmt->u.action.u.ht_notify_cw.chanwidth;
-			enum ieee80211_sta_rx_bandwidth new_bw;
+			enum ieee80211_sta_rx_bandwidth max_bw, new_bw;
 
 			/* If it doesn't support 40 MHz it can't change ... */
 			if (!(rx->sta->sta.ht_cap.cap &
@@ -2605,13 +2605,18 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 				goto handled;
 
 			if (chanwidth == IEEE80211_HT_CHANWIDTH_20MHZ)
-				new_bw = IEEE80211_STA_RX_BW_20;
+				max_bw = IEEE80211_STA_RX_BW_20;
 			else
-				new_bw = ieee80211_sta_cur_vht_bw(rx->sta);
+				max_bw = ieee80211_sta_cap_rx_bw(rx->sta);
+
+			/* set cur_max_bandwidth and recalc sta bw */
+			rx->sta->cur_max_bandwidth = max_bw;
+			new_bw = ieee80211_sta_cur_vht_bw(rx->sta);
 
 			if (rx->sta->sta.bandwidth == new_bw)
 				goto handled;
 
+			rx->sta->sta.bandwidth = new_bw;
 			sband = rx->local->hw.wiphy->bands[status->band];
 
 			rate_control_rate_update(local, sband, rx->sta,
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index bc9e8fc..85f9596 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -269,51 +269,54 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
 }
 
-enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
+enum ieee80211_sta_rx_bandwidth ieee80211_sta_cap_rx_bw(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	u32 cap = sta->sta.vht_cap.cap;
-	enum ieee80211_sta_rx_bandwidth bw;
+	struct ieee80211_sta_vht_cap *vht_cap = &sta->sta.vht_cap;
+	u32 cap_width;
 
-	if (!sta->sta.vht_cap.vht_supported) {
-		bw = sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
-				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
-		goto check_max;
-	}
+	if (!vht_cap->vht_supported)
+		return sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
+				IEEE80211_STA_RX_BW_40 :
+				IEEE80211_STA_RX_BW_20;
 
-	switch (sdata->vif.bss_conf.chandef.width) {
-	default:
-		WARN_ON_ONCE(1);
-		/* fall through */
+	cap_width = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+
+	if (cap_width == IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ ||
+	    cap_width == IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
+		return IEEE80211_STA_RX_BW_160;
+
+	return IEEE80211_STA_RX_BW_80;
+}
+
+static enum ieee80211_sta_rx_bandwidth
+ieee80211_chan_width_to_rx_bw(enum nl80211_chan_width width)
+{
+	switch (width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
-		bw = IEEE80211_STA_RX_BW_20;
-		break;
+		return IEEE80211_STA_RX_BW_20;
 	case NL80211_CHAN_WIDTH_40:
-		bw = sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
-				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
-		break;
+		return IEEE80211_STA_RX_BW_40;
+	case NL80211_CHAN_WIDTH_80:
+		return IEEE80211_STA_RX_BW_80;
 	case NL80211_CHAN_WIDTH_160:
-		if ((cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) ==
-				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ) {
-			bw = IEEE80211_STA_RX_BW_160;
-			break;
-		}
-		/* fall through */
 	case NL80211_CHAN_WIDTH_80P80:
-		if ((cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) ==
-				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ) {
-			bw = IEEE80211_STA_RX_BW_160;
-			break;
-		}
-		/* fall through */
-	case NL80211_CHAN_WIDTH_80:
-		bw = IEEE80211_STA_RX_BW_80;
+		return IEEE80211_STA_RX_BW_160;
+	default:
+		WARN_ON_ONCE(1);
+		return IEEE80211_STA_RX_BW_20;
 	}
+}
+
+enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	enum ieee80211_sta_rx_bandwidth bw;
+
+	bw = ieee80211_chan_width_to_rx_bw(sdata->vif.bss_conf.chandef.width);
+	bw = min(bw, ieee80211_sta_cap_rx_bw(sta));
+	bw = min(bw, sta->cur_max_bandwidth);
 
- check_max:
-	if (bw > sta->cur_max_bandwidth)
-		bw = sta->cur_max_bandwidth;
 	return bw;
 }
 
-- 
1.9.1

