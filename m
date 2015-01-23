Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35713 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbbAWKpf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 05:45:35 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: tdls: disentangle HT supported conditions
Date: Fri, 23 Jan 2015 11:45:31 +0100
Message-Id: <1422009931-4379-1-git-send-email-johannes@sipsolutions.net> (sfid-20150123_114539_137623_E1D8ED8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These conditions are rather difficult to follow, for example
because "!sta" only exists to not crash in the case that we
don't have a station pointer (WLAN_TDLS_SETUP_REQUEST) in
which the additional condition (peer supports HT) doesn't
actually matter anyway.

Cleaning this up only duplicates two lines of code but makes
the rest far easier to read, so do that.

As a side effect, smatch stops complaining about the lack of
a sta pointer test after the !sta (since the !sta goes away)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 80b66ce9157b..c9f9752217ac 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -345,24 +345,24 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 	 */
 	sband = local->hw.wiphy->bands[band];
 	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
-	if ((action_code == WLAN_TDLS_SETUP_REQUEST ||
-	     action_code == WLAN_TDLS_SETUP_RESPONSE) &&
-	    ht_cap.ht_supported && (!sta || sta->sta.ht_cap.ht_supported)) {
-		if (action_code == WLAN_TDLS_SETUP_REQUEST) {
-			ieee80211_apply_htcap_overrides(sdata, &ht_cap);
-
-			/* disable SMPS in TDLS initiator */
-			ht_cap.cap |= (WLAN_HT_CAP_SM_PS_DISABLED
-				       << IEEE80211_HT_CAP_SM_PS_SHIFT);
-		} else {
-			/* disable SMPS in TDLS responder */
-			sta->sta.ht_cap.cap |=
-				(WLAN_HT_CAP_SM_PS_DISABLED
-				 << IEEE80211_HT_CAP_SM_PS_SHIFT);
-
-			/* the peer caps are already intersected with our own */
-			memcpy(&ht_cap, &sta->sta.ht_cap, sizeof(ht_cap));
-		}
+
+	if (action_code == WLAN_TDLS_SETUP_REQUEST && ht_cap.ht_supported) {
+		ieee80211_apply_htcap_overrides(sdata, &ht_cap);
+
+		/* disable SMPS in TDLS initiator */
+		ht_cap.cap |= WLAN_HT_CAP_SM_PS_DISABLED
+				<< IEEE80211_HT_CAP_SM_PS_SHIFT;
+
+		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
+		ieee80211_ie_build_ht_cap(pos, &ht_cap, ht_cap.cap);
+	} else if (action_code == WLAN_TDLS_SETUP_RESPONSE &&
+		   ht_cap.ht_supported && sta->sta.ht_cap.ht_supported) {
+		/* disable SMPS in TDLS responder */
+		sta->sta.ht_cap.cap |= WLAN_HT_CAP_SM_PS_DISABLED
+					<< IEEE80211_HT_CAP_SM_PS_SHIFT;
+
+		/* the peer caps are already intersected with our own */
+		memcpy(&ht_cap, &sta->sta.ht_cap, sizeof(ht_cap));
 
 		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
 		ieee80211_ie_build_ht_cap(pos, &ht_cap, ht_cap.cap);
-- 
2.1.4

