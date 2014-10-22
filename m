Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177AbaJVJhg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 05:37:36 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: expose TDLS-initiator value to low level driver
Date: Wed, 22 Oct 2014 12:32:48 +0300
Message-Id: <1413970368-5777-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141022_113739_487676_8886B2C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Some drivers need to know which station is the TDLS link initiator.
Expose this value via the mac80211 ieee80211_sta structure.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 3 +++
 net/mac80211/tdls.c    | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e544bbf..3a8cb99 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1427,6 +1427,8 @@ struct ieee80211_sta_rates {
  * @smps_mode: current SMPS mode (off, static or dynamic)
  * @rates: rate control selection table
  * @tdls: indicates whether the STA is a TDLS peer
+ * @tdls_initiator: indicates the STA is an initiator of the TDLS link. Only
+ *	valid if the STA is a TDLS peer in the first place.
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
@@ -1442,6 +1444,7 @@ struct ieee80211_sta {
 	enum ieee80211_smps_mode smps_mode;
 	struct ieee80211_sta_rates __rcu *rates;
 	bool tdls;
+	bool tdls_initiator;
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 4ea25de..b4f368e 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -562,8 +562,10 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	/* infer the initiator if we can, to support old userspace */
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
-		if (sta)
+		if (sta) {
 			set_sta_flag(sta, WLAN_STA_TDLS_INITIATOR);
+			sta->sta.tdls_initiator = false;
+		}
 		/* fall-through */
 	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
@@ -575,8 +577,10 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 		 * Make the last packet sent take effect for the initiator
 		 * value.
 		 */
-		if (sta)
+		if (sta) {
 			clear_sta_flag(sta, WLAN_STA_TDLS_INITIATOR);
+			sta->sta.tdls_initiator = true;
+		}
 		/* fall-through */
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
 		initiator = false;
-- 
1.9.1

