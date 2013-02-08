Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946810Ab3BHRZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:25:53 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 05/14] mac80211: handle VHT operating mode notification
Date: Fri,  8 Feb 2013 18:25:35 +0100
Message-Id: <1360344344-15742-6-git-send-email-johannes@sipsolutions.net> (sfid-20130208_183039_748479_D735B612)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Handle the operating mode notification action frame.
When the supported streams or the bandwidth change
let the driver and rate control algorithm know.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  3 ++
 net/mac80211/ieee80211_i.h |  3 ++
 net/mac80211/rx.c          | 30 +++++++++++++++++
 net/mac80211/sta_info.h    |  4 +++
 net/mac80211/vht.c         | 82 ++++++++++++++++++++++++++++++++++++++++------
 5 files changed, 112 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 972253a..a3a0bdf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2107,11 +2107,14 @@ enum ieee80211_frame_release_type {
  * @IEEE80211_RC_SUPP_RATES_CHANGED: The supported rate set of this peer
  *	changed (in IBSS mode) due to discovering more information about
  *	the peer.
+ * @IEEE80211_RC_NSS_CHANGED: N_SS (number of spatial streams) was changed
+ *	by the peer
  */
 enum ieee80211_rate_control_changed {
 	IEEE80211_RC_BW_CHANGED		= BIT(0),
 	IEEE80211_RC_SMPS_CHANGED	= BIT(1),
 	IEEE80211_RC_SUPP_RATES_CHANGED	= BIT(2),
+	IEEE80211_RC_NSS_CHANGED	= BIT(3),
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2a8f651..78b27e0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1429,6 +1429,9 @@ void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 					 struct sta_info *sta);
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
+void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				 struct sta_info *sta, u8 opmode,
+				 enum ieee80211_band band);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e0b0e0d..bef2a58 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2428,6 +2428,36 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		}
 
 		break;
+	case WLAN_CATEGORY_VHT:
+		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
+		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+			break;
+
+		/* verify action code is present */
+		if (len < IEEE80211_MIN_ACTION_SIZE + 1)
+			goto invalid;
+
+		switch (mgmt->u.action.u.vht_opmode_notif.action_code) {
+		case WLAN_VHT_ACTION_OPMODE_NOTIF: {
+			u8 opmode;
+
+			/* verify opmode is present */
+			if (len < IEEE80211_MIN_ACTION_SIZE + 2)
+				goto invalid;
+
+			opmode = mgmt->u.action.u.vht_opmode_notif.operating_mode;
+
+			ieee80211_vht_handle_opmode(rx->sdata, rx->sta,
+						    opmode, status->band);
+			goto handled;
+		}
+		default:
+			break;
+		}
+		break;
 	case WLAN_CATEGORY_BACK:
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 03c42f8..f6760e9 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -297,6 +297,8 @@ struct sta_ampdu_mlme {
  * @sta_state: duplicates information about station state (for debug)
  * @beacon_loss_count: number of times beacon loss has triggered
  * @rcu_head: RCU head used for freeing this station struct
+ * @vht_opmode_bandwidth: max bandwidth as advertised by the last
+ *	VHT operating mode notification
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -398,6 +400,8 @@ struct sta_info {
 	} debugfs;
 #endif
 
+	enum ieee80211_sta_rx_bandwidth vht_opmode_bandwidth;
+
 	unsigned int lost_packets;
 	unsigned int beacon_loss_count;
 
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 67436e3..a7d0d6d 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -10,6 +10,7 @@
 #include <linux/export.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "rate.h"
 
 
 void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
@@ -39,6 +40,7 @@ void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	memcpy(&vht_cap->vht_mcs, &vht_cap_ie->supp_mcs,
 	       sizeof(struct ieee80211_vht_mcs_info));
 
+	sta->vht_opmode_bandwidth = IEEE80211_STA_RX_BW_160;
 	sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
 }
 
@@ -46,12 +48,13 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 cap = sta->sta.vht_cap.cap;
+	enum ieee80211_sta_rx_bandwidth bw;
 
-	if (!sta->sta.vht_cap.vht_supported)
-		return sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
+	if (!sta->sta.vht_cap.vht_supported) {
+		bw = sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
 				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
-
-	/* TODO: handle VHT opmode notification data */
+		goto check_opmode;
+	}
 
 	switch (sdata->vif.bss_conf.chandef.width) {
 	default:
@@ -60,19 +63,29 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
 	case NL80211_CHAN_WIDTH_40:
-		return sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
+		bw = sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
 				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
+		break;
 	case NL80211_CHAN_WIDTH_160:
-		if (cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ)
-			return IEEE80211_STA_RX_BW_160;
+		if (cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ) {
+			bw = IEEE80211_STA_RX_BW_160;
+			break;
+		}
 		/* fall through */
 	case NL80211_CHAN_WIDTH_80P80:
-		if (cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
-			return IEEE80211_STA_RX_BW_160;
+		if (cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ) {
+			bw = IEEE80211_STA_RX_BW_160;
+			break;
+		}
 		/* fall through */
 	case NL80211_CHAN_WIDTH_80:
-		return IEEE80211_STA_RX_BW_80;
+		bw = IEEE80211_STA_RX_BW_80;
 	}
+
+ check_opmode:
+	if (bw > sta->vht_opmode_bandwidth)
+		bw = sta->vht_opmode_bandwidth;
+	return bw;
 }
 
 void ieee80211_sta_set_rx_nss(struct sta_info *sta)
@@ -115,3 +128,52 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta)
 	ht_rx_nss = max(ht_rx_nss, vht_rx_nss);
 	sta->sta.rx_nss = max_t(u8, 1, ht_rx_nss);
 }
+
+void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				 struct sta_info *sta, u8 opmode,
+				 enum ieee80211_band band)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	enum ieee80211_sta_rx_bandwidth new_bw;
+	u32 changed = 0;
+	u8 nss;
+
+	sband = local->hw.wiphy->bands[band];
+
+	/* ignore - no support for BF yet */
+	if (opmode & IEEE80211_VHT_OPMODE_RX_NSS_TYPE_BF)
+		return;
+
+	nss = opmode & IEEE80211_VHT_OPMODE_RX_NSS_MASK;
+	nss >>= IEEE80211_VHT_OPMODE_RX_NSS_SHIFT;
+
+	if (sta->sta.rx_nss != nss) {
+		sta->sta.rx_nss = nss;
+		changed |= IEEE80211_RC_NSS_CHANGED;
+	}
+
+	switch (opmode & IEEE80211_VHT_OPMODE_CHANWIDTH_MASK) {
+	case IEEE80211_VHT_OPMODE_CHANWIDTH_20MHZ:
+		sta->vht_opmode_bandwidth = IEEE80211_STA_RX_BW_20;
+		break;
+	case IEEE80211_VHT_OPMODE_CHANWIDTH_40MHZ:
+		sta->vht_opmode_bandwidth = IEEE80211_STA_RX_BW_40;
+		break;
+	case IEEE80211_VHT_OPMODE_CHANWIDTH_80MHZ:
+		sta->vht_opmode_bandwidth = IEEE80211_STA_RX_BW_80;
+		break;
+	case IEEE80211_VHT_OPMODE_CHANWIDTH_160MHZ:
+		sta->vht_opmode_bandwidth = IEEE80211_STA_RX_BW_160;
+		break;
+	}
+
+	new_bw = ieee80211_sta_cur_vht_bw(sta);
+	if (new_bw != sta->sta.bandwidth) {
+		sta->sta.bandwidth = new_bw;
+		changed |= IEEE80211_RC_NSS_CHANGED;
+	}
+
+	if (changed)
+		rate_control_rate_update(local, sband, sta, changed);
+}
-- 
1.8.0

