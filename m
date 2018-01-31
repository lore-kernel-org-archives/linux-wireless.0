Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbeAaK6a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 05:58:30 -0500
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv3 2/2] mac80211: Add support to notify ht/vht opmode modification.
Date: Wed, 31 Jan 2018 16:24:50 +0530
Message-Id: <1517396090-4688-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180131_115834_808318_A41865A5)
In-Reply-To: <1517396090-4688-1-git-send-email-tamizhr@codeaurora.org>
References: <1517396090-4688-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will add support to send an event to a userspace application
whenever station advertise its ht/vht opmode modification through
an action frame.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
v3:
  * Initialized the sta_opmode_info structure variable before using

 net/mac80211/rx.c  | 14 ++++++++++++++
 net/mac80211/vht.c |  9 +++++++++
 2 files changed, 23 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fd58061..e755f93 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2848,6 +2848,7 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 		case WLAN_HT_ACTION_SMPS: {
 			struct ieee80211_supported_band *sband;
 			enum ieee80211_smps_mode smps_mode;
+			struct sta_opmode_info sta_opmode = {};
 
 			/* convert to HT capability */
 			switch (mgmt->u.action.u.ht_smps.smps_control) {
@@ -2868,17 +2869,24 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 			if (rx->sta->sta.smps_mode == smps_mode)
 				goto handled;
 			rx->sta->sta.smps_mode = smps_mode;
+			sta_opmode.smps_mode = smps_mode;
+			sta_opmode.changed = STA_OPMODE_SMPS_MODE_CHANGED;
 
 			sband = rx->local->hw.wiphy->bands[status->band];
 
 			rate_control_rate_update(local, sband, rx->sta,
 						 IEEE80211_RC_SMPS_CHANGED);
+			cfg80211_sta_opmode_change_notify(sdata->dev,
+							  rx->sta->addr,
+							  &sta_opmode,
+							  GFP_KERNEL);
 			goto handled;
 		}
 		case WLAN_HT_ACTION_NOTIFY_CHANWIDTH: {
 			struct ieee80211_supported_band *sband;
 			u8 chanwidth = mgmt->u.action.u.ht_notify_cw.chanwidth;
 			enum ieee80211_sta_rx_bandwidth max_bw, new_bw;
+			struct sta_opmode_info sta_opmode = {};
 
 			/* If it doesn't support 40 MHz it can't change ... */
 			if (!(rx->sta->sta.ht_cap.cap &
@@ -2899,9 +2907,15 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 
 			rx->sta->sta.bandwidth = new_bw;
 			sband = rx->local->hw.wiphy->bands[status->band];
+			sta_opmode.bw = new_bw;
+			sta_opmode.changed = STA_OPMODE_MAX_BW_CHANGED;
 
 			rate_control_rate_update(local, sband, rx->sta,
 						 IEEE80211_RC_BW_CHANGED);
+			cfg80211_sta_opmode_change_notify(sdata->dev,
+							  rx->sta->addr,
+							  &sta_opmode,
+							  GFP_KERNEL);
 			goto handled;
 		}
 		default:
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index b9276ac..5714dee 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -447,6 +447,7 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				  enum nl80211_band band)
 {
 	enum ieee80211_sta_rx_bandwidth new_bw;
+	struct sta_opmode_info sta_opmode = {};
 	u32 changed = 0;
 	u8 nss;
 
@@ -460,7 +461,9 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 
 	if (sta->sta.rx_nss != nss) {
 		sta->sta.rx_nss = nss;
+		sta_opmode.rx_nss = nss;
 		changed |= IEEE80211_RC_NSS_CHANGED;
+		sta_opmode.changed |= STA_OPMODE_N_SS_CHANGED;
 	}
 
 	switch (opmode & IEEE80211_OPMODE_NOTIF_CHANWIDTH_MASK) {
@@ -481,9 +484,15 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	new_bw = ieee80211_sta_cur_vht_bw(sta);
 	if (new_bw != sta->sta.bandwidth) {
 		sta->sta.bandwidth = new_bw;
+		sta_opmode.bw = new_bw;
 		changed |= IEEE80211_RC_BW_CHANGED;
+		sta_opmode.changed |= STA_OPMODE_MAX_BW_CHANGED;
 	}
 
+	if (sta_opmode.changed)
+		cfg80211_sta_opmode_change_notify(sdata->dev, sta->addr,
+						  &sta_opmode, GFP_KERNEL);
+
 	return changed;
 }
 
-- 
1.9.1
