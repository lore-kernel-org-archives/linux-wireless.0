Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:38382 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbbDTTvy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 15:51:54 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix ignored HT/VHT override configs
Date: Mon, 20 Apr 2015 22:51:46 +0300
Message-Id: <1429559506-22853-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150420_215157_667203_28E8503B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

HT and VHT override configurations were ignored during association and
applied only when first beacon recived, or not applied at all.

Fix the code to apply HT/VHT overrides during association. This is a bit
tricky since the channel was already configured during authentication
and we don't want to reconfigure it unless there's really a change.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 57 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 26053bf..3294666 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4307,15 +4307,15 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 }
 
 static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
-				     struct cfg80211_bss *cbss, bool assoc)
+				     struct cfg80211_bss *cbss, bool assoc,
+				     bool override)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct sta_info *new_sta = NULL;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_sta_ht_cap sta_ht_cap;
-	bool have_sta = false, is_override = false;
+	bool have_sta = false;
 	int err;
 
 	sband = local->hw.wiphy->bands[cbss->channel->band];
@@ -4335,14 +4335,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			return -ENOMEM;
 	}
 
-	memcpy(&sta_ht_cap, &sband->ht_cap, sizeof(sta_ht_cap));
-	ieee80211_apply_htcap_overrides(sdata, &sta_ht_cap);
-
-	is_override = (sta_ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) !=
-		      (sband->ht_cap.cap &
-		       IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-
-	if (new_sta || is_override) {
+	if (new_sta || override) {
 		err = ieee80211_prep_channel(sdata, cbss);
 		if (err) {
 			if (new_sta)
@@ -4552,7 +4545,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 
 	sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
 
-	err = ieee80211_prep_connection(sdata, req->bss, false);
+	err = ieee80211_prep_connection(sdata, req->bss, false, false);
 	if (err)
 		goto err_clear;
 
@@ -4624,6 +4617,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	const u8 *ssidie, *ht_ie, *vht_ie;
 	int i, err;
+	bool override = false;
 
 	assoc_data = kzalloc(sizeof(*assoc_data) + req->ie_len, GFP_KERNEL);
 	if (!assoc_data)
@@ -4728,14 +4722,6 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (req->flags & ASSOC_REQ_DISABLE_HT) {
-		ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
-		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
-	}
-
-	if (req->flags & ASSOC_REQ_DISABLE_VHT)
-		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
-
 	/* Also disable HT if we don't support it or the AP doesn't use WMM */
 	sband = local->hw.wiphy->bands[req->bss->channel->band];
 	if (!sband->ht_cap.ht_supported ||
@@ -4847,7 +4833,36 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	ifmgd->dtim_period = 0;
 	ifmgd->have_beacon = false;
 
-	err = ieee80211_prep_connection(sdata, req->bss, true);
+	/* override HT/VHT configuration only if the AP and we support it */
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
+		struct ieee80211_sta_ht_cap sta_ht_cap;
+
+		if (req->flags & ASSOC_REQ_DISABLE_HT)
+			override = true;
+
+		memcpy(&sta_ht_cap, &sband->ht_cap, sizeof(sta_ht_cap));
+		ieee80211_apply_htcap_overrides(sdata, &sta_ht_cap);
+
+		/* check for 40 MHz disable override */
+		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_40MHZ) &&
+		    sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
+		    !(sta_ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+			override = true;
+
+		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT) &&
+		    req->flags & ASSOC_REQ_DISABLE_VHT)
+			override = true;
+	}
+
+	if (req->flags & ASSOC_REQ_DISABLE_HT) {
+		ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
+		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
+	}
+
+	if (req->flags & ASSOC_REQ_DISABLE_VHT)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
+
+	err = ieee80211_prep_connection(sdata, req->bss, true, override);
 	if (err)
 		goto err_clear;
 
-- 
2.1.0

