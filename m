Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:56440 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3LBO3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 09:29:39 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so9094805ead.34
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 06:29:37 -0800 (PST)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH 2/2] mac80211: Update opmode during adding new station
Date: Mon,  2 Dec 2013 15:28:54 +0100
Message-Id: <1385994534-13383-2-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131202_152941_756322_482319BD)
In-Reply-To: <1385994534-13383-1-git-send-email-marek.kwaczynski@tieto.com>
References: <1385994534-13383-1-git-send-email-marek.kwaczynski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update Operating mode is needed when User Space received Assoc
Request contains Operating mode notification element.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 net/mac80211/cfg.c         |    8 ++++++++
 net/mac80211/ieee80211_i.h |    4 ++++
 net/mac80211/vht.c         |   29 ++++++++++++++++++++---------
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 95667b0..f8cd150 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1409,6 +1409,14 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	if (!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))) {
 		sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+		if (params->vht_opmode_used) {
+			u32 changed;
+			enum ieee80211_band band =
+					    ieee80211_get_sdata_band(sdata);
+			ieee80211_vht_handle_recalc_opmode(sdata, sta,
+							   params->vht_opmode,
+							   band, 0, &changed);
+		}
 		sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 29dc505..2231661 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1510,6 +1510,10 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta);
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
+void ieee80211_vht_recalc_opmode(struct ieee80211_sub_if_data *sdata,
+                                 struct sta_info *sta, u8 opmode,
+                                 enum ieee80211_band band, bool nss_only,
+                                 u32 *changed);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
 				 enum ieee80211_band band, bool nss_only);
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index de01127..397ae2a 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -350,14 +350,14 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta)
 	sta->sta.rx_nss = max_t(u8, 1, ht_rx_nss);
 }
 
-void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
+void ieee80211_vht_recalc_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band, bool nss_only)
+				 enum ieee80211_band band, bool nss_only,
+				 u32 *changed)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	enum ieee80211_sta_rx_bandwidth new_bw;
-	u32 changed = 0;
 	u8 nss;
 
 	sband = local->hw.wiphy->bands[band];
@@ -372,11 +372,11 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 
 	if (sta->sta.rx_nss != nss) {
 		sta->sta.rx_nss = nss;
-		changed |= IEEE80211_RC_NSS_CHANGED;
+		*changed |= IEEE80211_RC_NSS_CHANGED;
 	}
 
 	if (nss_only)
-		goto change;
+		return;
 
 	switch (opmode & IEEE80211_OPMODE_NOTIF_CHANWIDTH_MASK) {
 	case IEEE80211_OPMODE_NOTIF_CHANWIDTH_20MHZ:
@@ -396,10 +396,21 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	new_bw = ieee80211_sta_cur_vht_bw(sta);
 	if (new_bw != sta->sta.bandwidth) {
 		sta->sta.bandwidth = new_bw;
-		changed |= IEEE80211_RC_BW_CHANGED;
+		*changed |= IEEE80211_RC_BW_CHANGED;
 	}
+}
+
 
- change:
-	if (changed)
-		rate_control_rate_update(local, sband, sta, changed);
+void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
+                                 struct sta_info *sta, u8 opmode,
+                                 enum ieee80211_band band, bool nss_only)
+{
+	u32 changed = 0;
+	ieee80211_vht_handle_recalc_opmode(sdata, sta, opmode, band, nss_only,
+					   &changed);
+
+	if (changed) {
+                rate_control_rate_update(local, sband, sta, changed);
+
+	}
 }
-- 
1.7.9.5

