Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27676 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbbC3IQd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:16:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: send HT/VHT IEs in TDLS discovery response
Date: Mon, 30 Mar 2015 11:16:23 +0300
Message-Id: <1427703383-19212-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150330_101641_325167_700EBDBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

These are mandated by IEEE802.11-2012 section 8.5.8.6 and IEEE802.11ac-2013
section 8.5.8.16.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tdls.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 79ed59a..fff0d86 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -378,7 +378,9 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 	sband = local->hw.wiphy->bands[band];
 	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
 
-	if (action_code == WLAN_TDLS_SETUP_REQUEST && ht_cap.ht_supported) {
+	if ((action_code == WLAN_TDLS_SETUP_REQUEST ||
+	     action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) &&
+	    ht_cap.ht_supported) {
 		ieee80211_apply_htcap_overrides(sdata, &ht_cap);
 
 		/* disable SMPS in TDLS initiator */
@@ -432,11 +434,14 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 
 	/* build the VHT-cap similarly to the HT-cap */
 	memcpy(&vht_cap, &sband->vht_cap, sizeof(vht_cap));
-	if (action_code == WLAN_TDLS_SETUP_REQUEST && vht_cap.vht_supported) {
+	if ((action_code == WLAN_TDLS_SETUP_REQUEST ||
+	     action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) &&
+	    vht_cap.vht_supported) {
 		ieee80211_apply_vhtcap_overrides(sdata, &vht_cap);
 
 		/* the AID is present only when VHT is implemented */
-		ieee80211_tdls_add_aid(sdata, skb);
+		if (action_code == WLAN_TDLS_SETUP_REQUEST)
+			ieee80211_tdls_add_aid(sdata, skb);
 
 		pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
 		ieee80211_ie_build_vht_cap(pos, &vht_cap, vht_cap.cap);
-- 
1.9.1

