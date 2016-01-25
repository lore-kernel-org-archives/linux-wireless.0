Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244AbcAYNqp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 08:46:45 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: always print a message when disconnecting
Date: Mon, 25 Jan 2016 15:46:36 +0200
Message-Id: <1453729596-9847-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160125_144648_001099_36675E62)
In-Reply-To: <1453729596-9847-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1453729596-9847-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make sure there's at least a debug message whenever the
connection to the AP is terminated.

Also change one message from wiphy_debug() to the common
mlme_dbg().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e6d198b..857089d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3544,6 +3544,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				elems.ht_cap_elem, elems.ht_operation,
 				elems.vht_operation, bssid, &changed)) {
 		mutex_unlock(&local->sta_mtx);
+		sdata_info(sdata,
+			   "failed to follow AP %pM bandwidth change, disconnect\n",
+			   bssid);
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_DEAUTH_LEAVING,
 				       true, deauth_buf);
@@ -3919,11 +3922,9 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 * We actually lost the connection ... or did we?
 			 * Let's make sure!
 			 */
-			wiphy_debug(local->hw.wiphy,
-				    "%s: No probe response from AP %pM"
-				    " after %dms, disconnecting.\n",
-				    sdata->name,
-				    bssid, probe_wait_ms);
+			mlme_dbg(sdata,
+				 "No probe response from AP %pM after %dms, disconnecting.\n",
+				 bssid, probe_wait_ms);
 
 			ieee80211_sta_connection_lost(sdata, bssid,
 				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY, false);
@@ -4511,6 +4512,9 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->associated) {
 		u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
+		sdata_info(sdata,
+			   "disconnect from AP %pM for new auth to %pM\n",
+			   ifmgd->associated->bssid, req->bss->bssid);
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_UNSPECIFIED,
 				       false, frame_buf);
@@ -4579,6 +4583,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->associated) {
 		u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
+		sdata_info(sdata,
+			   "disconnect from AP %pM for new assoc to %pM\n",
+			   ifmgd->associated->bssid, req->bss->bssid);
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_UNSPECIFIED,
 				       false, frame_buf);
-- 
2.5.0

