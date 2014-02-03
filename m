Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:34617 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaBCNS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 08:18:26 -0500
Received: by mail-ee0-f42.google.com with SMTP id b15so1820788eek.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 05:18:25 -0800 (PST)
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH V7] mac80211: Update opmode during adding new station
Date: Mon,  3 Feb 2014 14:17:51 +0100
Message-Id: <1391433471-13308-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140203_141829_891591_792FC800)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update Operating mode is needed when User Space received Assoc
Request contains Operating mode notification element.
---
 net/mac80211/cfg.c         |   10 ++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/vht.c         |   27 ++++++++++++++++++++-------
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f9ae9b8..767185a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1341,6 +1341,16 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 						    params->vht_capa, sta);
 
+	if (params->opmode_notif_used) {
+		enum ieee80211_band band =
+			ieee80211_get_sdata_band(sdata);
+
+		/* ignore returned value is not needed */
+		__ieee80211_vht_handle_opmode(sdata, sta,
+					      params->opmode_notif,
+					      band, false);
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		u32 changed = 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3701930..b1f04a8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1553,6 +1553,9 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta);
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
+u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
+                                  struct sta_info *sta, u8 opmode,
+                                  enum ieee80211_band band, bool nss_only);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
 				 enum ieee80211_band band, bool nss_only);
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index d75f35c..04f906c 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -349,9 +349,9 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta)
 	sta->sta.rx_nss = max_t(u8, 1, ht_rx_nss);
 }
 
-void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
-				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band, bool nss_only)
+u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				  struct sta_info *sta, u8 opmode,
+				  enum ieee80211_band band, bool nss_only)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -363,7 +363,7 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 
 	/* ignore - no support for BF yet */
 	if (opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF)
-		return;
+		return 0;
 
 	nss = opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_MASK;
 	nss >>= IEEE80211_OPMODE_NOTIF_RX_NSS_SHIFT;
@@ -375,7 +375,7 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (nss_only)
-		goto change;
+		return changed;
 
 	switch (opmode & IEEE80211_OPMODE_NOTIF_CHANWIDTH_MASK) {
 	case IEEE80211_OPMODE_NOTIF_CHANWIDTH_20MHZ:
@@ -398,7 +398,20 @@ void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 		changed |= IEEE80211_RC_BW_CHANGED;
 	}
 
- change:
-	if (changed)
+	return changed;
+}
+
+void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
+				 struct sta_info *sta, u8 opmode,
+				 enum ieee80211_band band, bool nss_only)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
+
+	u32 changed = __ieee80211_vht_handle_opmode(sdata, sta, opmode,
+						    band, nss_only);
+
+	if (changed > 0)
 		rate_control_rate_update(local, sband, sta, changed);
 }
+
-- 
1.7.9.5

