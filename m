Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2L0R7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 12:59:07 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/3] mac80211: track number of spatial streams
Date: Thu, 27 Dec 2012 18:59:25 +0100
Message-Id: <1356631167-15192-2-git-send-email-johannes@sipsolutions.net> (sfid-20121227_185918_919204_53638DAA)
In-Reply-To: <1356631167-15192-1-git-send-email-johannes@sipsolutions.net>
References: <1356631167-15192-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With VHT, a station can change the number of spatial
streams it can receive on the fly, not unlike spatial
multiplexing in HT. Prepare for that by tracking the
maximum number of spatial streams it can receive when
the connection is established.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  5 +++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/rate.h        |  2 ++
 net/mac80211/vht.c         | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0978b0f..5bc6459 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1197,6 +1197,10 @@ enum ieee80211_sta_state {
  * @uapsd_queues: bitmap of queues configured for uapsd. Only valid
  *	if wme is supported.
  * @max_sp: max Service Period. Only valid if wme is supported.
+ * @rx_nss: in HT/VHT, the maximum number of spatial streams the
+ *	station can receive at the moment, changed by operating mode
+ *	notifications and capabilities. The value is only valid after
+ *	the station moves to associated state.
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
@@ -1207,6 +1211,7 @@ struct ieee80211_sta {
 	bool wme;
 	u8 uapsd_queues;
 	u8 max_sp;
+	u8 rx_nss;
 
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5ab33c7..edc88e2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1462,6 +1462,8 @@ void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_supported_band *sband,
 					 struct ieee80211_vht_cap *vht_cap_ie,
 					 struct ieee80211_sta_vht_cap *vht_cap);
+void ieee80211_sta_set_rx_nss(struct sta_info *sta);
+
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 301386d..d35a5dd 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -68,6 +68,8 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	sband = local->hw.wiphy->bands[chanctx_conf->def.chan->band];
 	rcu_read_unlock();
 
+	ieee80211_sta_set_rx_nss(sta);
+
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
 	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
 }
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index f311388..7751867 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -33,3 +33,44 @@ void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	memcpy(&vht_cap->vht_mcs, &vht_cap_ie->supp_mcs,
 	       sizeof(struct ieee80211_vht_mcs_info));
 }
+
+void ieee80211_sta_set_rx_nss(struct sta_info *sta)
+{
+	u8 ht_rx_nss = 0, vht_rx_nss = 0;
+
+	/* if we received a notification already don't overwrite it */
+	if (sta->sta.rx_nss)
+		return;
+
+	if (sta->sta.ht_cap.ht_supported) {
+		if (sta->sta.ht_cap.mcs.rx_mask[0])
+			ht_rx_nss++;
+		if (sta->sta.ht_cap.mcs.rx_mask[1])
+			ht_rx_nss++;
+		if (sta->sta.ht_cap.mcs.rx_mask[2])
+			ht_rx_nss++;
+		if (sta->sta.ht_cap.mcs.rx_mask[3])
+			ht_rx_nss++;
+		/* FIXME: consider rx_highest? */
+	}
+
+	if (sta->sta.vht_cap.vht_supported) {
+		int i;
+		u16 rx_mcs_map;
+
+		rx_mcs_map = le16_to_cpu(sta->sta.vht_cap.vht_mcs.rx_mcs_map);
+
+		for (i = 7; i >= 0; i--) {
+			u8 mcs = (rx_mcs_map >> (2 * i)) & 3;
+
+			if (mcs != IEEE80211_VHT_MCS_NOT_SUPPORTED) {
+				vht_rx_nss = i + 1;
+				break;
+			}
+		}
+		/* FIXME: consider rx_highest? */
+	}
+
+	ht_rx_nss = max(ht_rx_nss, vht_rx_nss);
+	sta->sta.rx_nss = max_t(u8, 1, ht_rx_nss);
+}
-- 
1.8.0

