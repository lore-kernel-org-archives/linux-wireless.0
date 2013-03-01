Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3CAKo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 05:44:56 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't apply HT overrides to TDLS peers
Date: Fri,  1 Mar 2013 11:44:49 +0100
Message-Id: <1362134689-3483-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_114459_830753_BB7E25BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The HT overrides are intended only for the connection
to the AP, not for any other purpose. Therefore, don't
apply them to TDLS peers that are also stations added
to a managed station interface.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ht.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 0db25d4..4515fc3 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -40,13 +40,6 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	if (!ht_cap->ht_supported)
 		return;
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION) {
-		/* AP interfaces call this code when adding new stations,
-		 * so just silently ignore non station interfaces.
-		 */
-		return;
-	}
-
 	/* NOTE:  If you add more over-rides here, update register_hw
 	 * ht_capa_mod_msk logic in main.c as well.
 	 * And, if this method can ever change ht_cap.ht_supported, fix
@@ -184,9 +177,12 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
  apply:
 	/*
 	 * If user has specified capability over-rides, take care
-	 * of that here.
+	 * of that if the station we're setting up is the AP that
+	 * we advertised a restricted capability set to.
 	 */
-	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+		ieee80211_apply_htcap_overrides(sdata, &ht_cap);
 
 	changed = memcmp(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
 
-- 
1.8.0

