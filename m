Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890AbbLHOGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:37 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/9] mac80211: handle width changes from opmode notification IE in beacon
Date: Tue,  8 Dec 2015 16:04:36 +0200
Message-Id: <1449583479-26658-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150647_243872_F86F2F70)
In-Reply-To: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

An AP can send an operating channel width change in a beacon
opmode notification IE as long as there's a change in the nss as
well (See 802.11ac-2013 section 10.41).
So don't limit updating to nss only from an opmode notification IE.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c         |  3 +--
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/mlme.c        |  2 +-
 net/mac80211/rx.c          |  3 +--
 net/mac80211/vht.c         | 10 +++-------
 5 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b9e2c2f..a90d875 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1198,8 +1198,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		 * rc isn't initialized here yet, so ignore it
 		 */
 		__ieee80211_vht_handle_opmode(sdata, sta,
-					      params->opmode_notif,
-					      band, false);
+					      params->opmode_notif, band);
 	}
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 582ea86..747402d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1718,10 +1718,10 @@ void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_mgmt *mgmt);
 u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
                                   struct sta_info *sta, u8 opmode,
-                                  enum ieee80211_band band, bool nss_only);
+				  enum ieee80211_band band);
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band, bool nss_only);
+				 enum ieee80211_band band);
 void ieee80211_apply_vhtcap_overrides(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_sta_vht_cap *vht_cap);
 void ieee80211_get_vht_mask_from_cap(__le16 vht_cap,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1e6b337..62c8e4f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3584,7 +3584,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	if (sta && elems.opmode_notif)
 		ieee80211_vht_handle_opmode(sdata, sta, *elems.opmode_notif,
-					    rx_status->band, true);
+					    rx_status->band);
 	mutex_unlock(&local->sta_mtx);
 
 	changed |= ieee80211_handle_pwr_constr(sdata, chan, mgmt,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 901c72b..fe675d7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2738,8 +2738,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			opmode = mgmt->u.action.u.vht_opmode_notif.operating_mode;
 
 			ieee80211_vht_handle_opmode(rx->sdata, rx->sta,
-						    opmode, status->band,
-						    false);
+						    opmode, status->band);
 			goto handled;
 		}
 		case WLAN_VHT_ACTION_GROUPID_MGMT: {
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index d2f2ff6..a02525a 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -399,7 +399,7 @@ void ieee80211_sta_set_rx_nss(struct sta_info *sta)
 
 u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				  struct sta_info *sta, u8 opmode,
-				  enum ieee80211_band band, bool nss_only)
+				  enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -422,9 +422,6 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 		changed |= IEEE80211_RC_NSS_CHANGED;
 	}
 
-	if (nss_only)
-		return changed;
-
 	switch (opmode & IEEE80211_OPMODE_NOTIF_CHANWIDTH_MASK) {
 	case IEEE80211_OPMODE_NOTIF_CHANWIDTH_20MHZ:
 		sta->cur_max_bandwidth = IEEE80211_STA_RX_BW_20;
@@ -473,13 +470,12 @@ void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
-				 enum ieee80211_band band, bool nss_only)
+				 enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 
-	u32 changed = __ieee80211_vht_handle_opmode(sdata, sta, opmode,
-						    band, nss_only);
+	u32 changed = __ieee80211_vht_handle_opmode(sdata, sta, opmode, band);
 
 	if (changed > 0)
 		rate_control_rate_update(local, sband, sta, changed);
-- 
2.5.0

