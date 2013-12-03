Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:48960 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3LCJFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 04:05:35 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so1323319eei.28
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 01:05:34 -0800 (PST)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH 2/2 V3] mac80211: Update opmode during adding new station
Date: Tue,  3 Dec 2013 10:05:00 +0100
Message-Id: <1386061500-5750-2-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131203_100548_297875_08D56429)
In-Reply-To: <1386061500-5750-1-git-send-email-marek.kwaczynski@tieto.com>
References: <1386061500-5750-1-git-send-email-marek.kwaczynski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update Operating Mode Notification is needed when User Space
received Assoc Request contains Operating Mode Notification
element.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 net/mac80211/cfg.c         |    8 ++++++++
 net/mac80211/ieee80211_i.h |    4 ++++
 net/mac80211/vht.c         |   36 ++++++++++++++++++++++--------------
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 95667b0..87716f6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1409,6 +1409,14 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	if (!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))) {
 		sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+		if (params->opmode_notif_used) {
+			enum ieee80211_band band =
+					    ieee80211_get_sdata_band(sdata);
+			int changed = 0;
+			ieee80211_vht_recalc_handle_opmode(sdata, sta,
+							   params->opmode_notif,
+							   band, 0, &changed);
+		}
 		sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 29dc505..790accf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1510,6 +1510,10 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta);
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
+int ieee80211_vht_recalc_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				       struct sta_info *sta, u8 opmode,
+				       enum ieee80211_band band, bool nss_only,
+				       u32 *changed);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
 				 enum ieee80211_band band, bool nss_only);
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index de01127..fee70a9 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -350,21 +350,17 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta)
 	sta->sta.rx_nss = max_t(u8, 1, ht_rx_nss);
 }
 
-void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
-				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band, bool nss_only)
+int ieee80211_vht_recalc_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				       struct sta_info *sta, u8 opmode,
+				       enum ieee80211_band band, bool nss_only,
+				       u32 *changed)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
 	enum ieee80211_sta_rx_bandwidth new_bw;
-	u32 changed = 0;
 	u8 nss;
 
-	sband = local->hw.wiphy->bands[band];
-
 	/* ignore - no support for BF yet */
 	if (opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF)
-		return;
+		return -EOPNOTSUPP;
 
 	nss = opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_MASK;
 	nss >>= IEEE80211_OPMODE_NOTIF_RX_NSS_SHIFT;
@@ -372,11 +368,11 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 
 	if (sta->sta.rx_nss != nss) {
 		sta->sta.rx_nss = nss;
-		changed |= IEEE80211_RC_NSS_CHANGED;
+		*changed |= IEEE80211_RC_NSS_CHANGED;
 	}
 
 	if (nss_only)
-		goto change;
+		return 1;
 
 	switch (opmode & IEEE80211_OPMODE_NOTIF_CHANWIDTH_MASK) {
 	case IEEE80211_OPMODE_NOTIF_CHANWIDTH_20MHZ:
@@ -396,10 +392,22 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	new_bw = ieee80211_sta_cur_vht_bw(sta);
 	if (new_bw != sta->sta.bandwidth) {
 		sta->sta.bandwidth = new_bw;
-		changed |= IEEE80211_RC_BW_CHANGED;
+		*changed |= IEEE80211_RC_BW_CHANGED;
+		return 1;
 	}
+	return 0;
+}
+
+void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				 struct sta_info *sta, u8 opmode,
+				 enum ieee80211_band band, bool nss_only)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
+	int ret, changed = 0;
 
- change:
-	if (changed)
+	ret = ieee80211_vht_recalc_handle_opmode(sdata, sta, opmode, band,
+						 nss_only, &changed);
+	if (ret > 0)
 		rate_control_rate_update(local, sband, sta, changed);
 }
-- 
1.7.9.5

