Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab2CHODR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 09:03:17 -0500
Message-Id: <20120308140226.993172880@sipsolutions.net> (sfid-20120308_150322_166795_A126C245)
Date: Thu, 08 Mar 2012 15:02:05 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] mac80211: simplify wmm check during association
References: <20120308140202.751490800@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of setting assoc_data->wmm_used solely
based on the BSS also take into account our own
capabilities and later check those.

Also rename "wmm_used" and "uapsd_used" to just
"wmm" and "uapsd".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2012-03-08 13:20:33.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2012-03-08 13:55:13.000000000 +0100
@@ -408,7 +408,7 @@ struct ieee80211_mgd_assoc_data {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;
 	u8 supp_rates_len;
-	bool wmm_used, uapsd_used;
+	bool wmm, uapsd;
 	bool have_beacon;
 	bool sent_assoc;
 	bool synced;
--- a/net/mac80211/mlme.c	2012-03-08 13:55:13.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-08 13:55:16.000000000 +0100
@@ -570,8 +570,8 @@ static void ieee80211_send_assoc(struct
 		offset = noffset;
 	}
 
-	if (assoc_data->wmm_used && local->hw.queues >= 4) {
-		if (assoc_data->uapsd_used) {
+	if (assoc_data->wmm) {
+		if (assoc_data->uapsd) {
 			qos_info = local->uapsd_queues;
 			qos_info |= (local->uapsd_max_sp_len <<
 				     IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT);
@@ -3347,7 +3347,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 		ifmgd->ap_smps = ifmgd->req_smps;
 
 	assoc_data->capability = req->bss->capability;
-	assoc_data->wmm_used = bss->wmm_used;
+	assoc_data->wmm = bss->wmm_used && (local->hw.queues >= 4);
 	assoc_data->supp_rates = bss->supp_rates;
 	assoc_data->supp_rates_len = bss->supp_rates_len;
 	assoc_data->ht_information_ie =
@@ -3355,10 +3355,10 @@ int ieee80211_mgd_assoc(struct ieee80211
 
 	if (bss->wmm_used && bss->uapsd_supported &&
 	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
-		assoc_data->uapsd_used = true;
+		assoc_data->uapsd = true;
 		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
 	} else {
-		assoc_data->uapsd_used = false;
+		assoc_data->uapsd = false;
 		ifmgd->flags &= ~IEEE80211_STA_UAPSD_ENABLED;
 	}
 


