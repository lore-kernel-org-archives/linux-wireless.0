Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:57733 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3LEOGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 09:06:33 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so11500477eaj.12
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 06:06:30 -0800 (PST)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH V6] mac80211: Update opmode during adding new station
Date: Thu,  5 Dec 2013 15:05:34 +0100
Message-Id: <1386252334-26696-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131205_150636_491020_E1688B4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update Operating Mode Notification is needed when User Space
received Assoc Request contains Operating Mode Notification
element.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---

V6: Moved ieee80211_vht_recalc_handle_opmode calling to
sta_apply_parameters function, it works fine
V5: Moved ieee80211_vht_recalc_handle_opmode calling to other place
in ieee80211_add_station function. Tested and worked fine.
V4: It didn't work. Function sta_apply_parameters overwrote bandwidth
and nss parameters from ht and vht capabilities.

 net/mac80211/cfg.c         |    8 ++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/vht.c         |   29 +++++++++++++++++------------
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 95667b0..4e45992 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1315,6 +1315,14 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 						    params->vht_capa, sta);
 
+	if (params->opmode_notif_used) {
+		enum ieee80211_band band =
+				ieee80211_get_sdata_band(sdata);
+		ieee80211_vht_recalc_handle_opmode(sdata, sta,
+						   params->opmode_notif,
+						   band, 0);
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		u32 changed = 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 29dc505..13965e1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1510,6 +1510,9 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta);
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
+u32 ieee80211_vht_recalc_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				       struct sta_info *sta, u8 opmode,
+				       enum ieee80211_band band, bool nss_only);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
 				 enum ieee80211_band band, bool nss_only);
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index de01127..61d788c 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -350,21 +350,17 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta)
 	sta->sta.rx_nss = max_t(u8, 1, ht_rx_nss);
 }
 
-void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
-				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band, bool nss_only)
+u32 ieee80211_vht_recalc_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				       struct sta_info *sta, u8 opmode,
+				       enum ieee80211_band band, bool nss_only)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
 	enum ieee80211_sta_rx_bandwidth new_bw;
-	u32 changed = 0;
 	u8 nss;
-
-	sband = local->hw.wiphy->bands[band];
+	u32 changed = 0;
 
 	/* ignore - no support for BF yet */
 	if (opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF)
-		return;
+		return 0;
 
 	nss = opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_MASK;
 	nss >>= IEEE80211_OPMODE_NOTIF_RX_NSS_SHIFT;
@@ -376,7 +372,7 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (nss_only)
-		goto change;
+		return changed;
 
 	switch (opmode & IEEE80211_OPMODE_NOTIF_CHANWIDTH_MASK) {
 	case IEEE80211_OPMODE_NOTIF_CHANWIDTH_20MHZ:
@@ -398,8 +394,17 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 		sta->sta.bandwidth = new_bw;
 		changed |= IEEE80211_RC_BW_CHANGED;
 	}
+	return changed;
+}
 
- change:
-	if (changed)
+void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				 struct sta_info *sta, u8 opmode,
+				 enum ieee80211_band band, bool nss_only)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
+	u32 changed = ieee80211_vht_recalc_handle_opmode(sdata, sta, opmode,
+							 band, nss_only);
+	if (changed > 0)
 		rate_control_rate_update(local, sband, sta, changed);
 }
-- 
1.7.9.5

