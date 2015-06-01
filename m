Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58007 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbbFAMKo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 08:10:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: act upon and report deauth while associating
Date: Mon,  1 Jun 2015 14:10:40 +0200
Message-Id: <1433160640-2192-1-git-send-email-johannes@sipsolutions.net> (sfid-20150601_141047_689412_C9CE8956)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When trying to associate, the AP could send a deauth frame instead.
Currently mac80211 drops that frame and doesn't report it to the
supplicant, which, in some versions and/or in certain circumstances
will simply keep trying to associate over and over again instead of
trying authentication again.

Fix this by reacting to deauth frames while associating, reporting
them to the supplicant and dropping the association attempt (which
is bound to fail.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 92 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 387fe70ab126..853cfa71b96a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2521,6 +2521,34 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 	sdata->u.mgd.auth_data = NULL;
 }
 
+static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
+					 bool assoc)
+{
+	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
+
+	sdata_assert_lock(sdata);
+
+	if (!assoc) {
+		/*
+		 * we are not associated yet, the only timer that could be
+		 * running is the timeout for the association response which
+		 * which is not relevant anymore.
+		 */
+		del_timer_sync(&sdata->u.mgd.timer);
+		sta_info_destroy_addr(sdata, assoc_data->bss->bssid);
+
+		eth_zero_addr(sdata->u.mgd.bssid);
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+		sdata->u.mgd.flags = 0;
+		mutex_lock(&sdata->local->mtx);
+		ieee80211_vif_release_channel(sdata);
+		mutex_unlock(&sdata->local->mtx);
+	}
+
+	kfree(assoc_data);
+	sdata->u.mgd.assoc_data = NULL;
+}
+
 static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
 {
@@ -2713,28 +2741,42 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	const u8 *bssid = NULL;
-	u16 reason_code;
+	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
 	sdata_assert_lock(sdata);
 
 	if (len < 24 + 2)
 		return;
 
-	if (!ifmgd->associated ||
-	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
-		return;
+	if (ifmgd->associated &&
+	    ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid)) {
+		const u8 *bssid = ifmgd->associated->bssid;
 
-	bssid = ifmgd->associated->bssid;
+		sdata_info(sdata, "deauthenticated from %pM (Reason: %u=%s)\n",
+			   bssid, reason_code,
+			   ieee80211_get_reason_code_string(reason_code));
 
-	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-	sdata_info(sdata, "deauthenticated from %pM (Reason: %u=%s)\n",
-		   bssid, reason_code, ieee80211_get_reason_code_string(reason_code));
+		ieee80211_report_disconnect(sdata, (u8 *)mgmt, len, false,
+					    reason_code);
+		return;
+	}
 
-	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	if (ifmgd->assoc_data &&
+	    ether_addr_equal(mgmt->bssid, ifmgd->assoc_data->bss->bssid)) {
+		const u8 *bssid = ifmgd->assoc_data->bss->bssid;
 
-	ieee80211_report_disconnect(sdata, (u8 *)mgmt, len, false, reason_code);
+		sdata_info(sdata,
+			   "deauthenticated from %pM while associating (Reason: %u=%s)\n",
+			   bssid, reason_code,
+			   ieee80211_get_reason_code_string(reason_code));
+
+		ieee80211_destroy_assoc_data(sdata, false);
+
+		cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
+		return;
+	}
 }
 
 
@@ -2814,34 +2856,6 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 	}
 }
 
-static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
-					 bool assoc)
-{
-	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
-
-	sdata_assert_lock(sdata);
-
-	if (!assoc) {
-		/*
-		 * we are not associated yet, the only timer that could be
-		 * running is the timeout for the association response which
-		 * which is not relevant anymore.
-		 */
-		del_timer_sync(&sdata->u.mgd.timer);
-		sta_info_destroy_addr(sdata, assoc_data->bss->bssid);
-
-		eth_zero_addr(sdata->u.mgd.bssid);
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
-		sdata->u.mgd.flags = 0;
-		mutex_lock(&sdata->local->mtx);
-		ieee80211_vif_release_channel(sdata);
-		mutex_unlock(&sdata->local->mtx);
-	}
-
-	kfree(assoc_data);
-	sdata->u.mgd.assoc_data = NULL;
-}
-
 static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 				    struct cfg80211_bss *cbss,
 				    struct ieee80211_mgmt *mgmt, size_t len)
-- 
2.1.4

