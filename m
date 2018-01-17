Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57446 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbeAQHVp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 02:21:45 -0500
From: tamizhr@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 2/2] mac80211: Add support to notify ht/vht opmode modification.
Date: Wed, 17 Jan 2018 12:48:28 +0530
Message-Id: <1516173508-16528-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180117_082151_099537_B189C9EA)
In-Reply-To: <1516173508-16528-1-git-send-email-tamizhr@codeaurora.org>
References: <1516173508-16528-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

This will add support to send an event to a userspace application
whenever station advertise its ht/vht opmode modification through
an action frame.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/rx.c  | 15 +++++++++++++++
 net/mac80211/vht.c | 11 +++++++++++
 2 files changed, 26 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fd58061..60ec460 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2873,6 +2873,14 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 
 			rate_control_rate_update(local, sband, rx->sta,
 						 IEEE80211_RC_SMPS_CHANGED);
+			cfg80211_sta_opmode_change_notify(
+						sdata->dev,
+						rx->sta->addr,
+						SMPS_MODE_CHANGED,
+						smps_mode,
+						rx->sta->sta.bandwidth,
+						rx->sta->sta.rx_nss,
+						GFP_KERNEL);
 			goto handled;
 		}
 		case WLAN_HT_ACTION_NOTIFY_CHANWIDTH: {
@@ -2902,6 +2910,13 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 
 			rate_control_rate_update(local, sband, rx->sta,
 						 IEEE80211_RC_BW_CHANGED);
+			cfg80211_sta_opmode_change_notify(
+						sdata->dev,
+						rx->sta->addr,
+						MAX_BW_CHANGED,
+						rx->sta->sta.smps_mode,
+						new_bw, rx->sta->sta.rx_nss,
+						GFP_KERNEL);
 			goto handled;
 		}
 		default:
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index b9276ac..f1d7dce 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -447,6 +447,7 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				  enum nl80211_band band)
 {
 	enum ieee80211_sta_rx_bandwidth new_bw;
+	u8 opmode_changed = 0;
 	u32 changed = 0;
 	u8 nss;
 
@@ -461,6 +462,7 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	if (sta->sta.rx_nss != nss) {
 		sta->sta.rx_nss = nss;
 		changed |= IEEE80211_RC_NSS_CHANGED;
+		opmode_changed |= N_SS_CHANGED;
 	}
 
 	switch (opmode & IEEE80211_OPMODE_NOTIF_CHANWIDTH_MASK) {
@@ -482,8 +484,17 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	if (new_bw != sta->sta.bandwidth) {
 		sta->sta.bandwidth = new_bw;
 		changed |= IEEE80211_RC_BW_CHANGED;
+		opmode_changed |= MAX_BW_CHANGED;
 	}
 
+	if (opmode_changed)
+		cfg80211_sta_opmode_change_notify(sdata->dev, sta->addr,
+						  opmode_changed,
+						  sta->sta.smps_mode,
+						  sta->sta.bandwidth,
+						  sta->sta.rx_nss,
+						  GFP_KERNEL);
+
 	return changed;
 }
 
-- 
1.9.1
