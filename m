Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab3A2MkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 07:40:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/2] mac80211: send deauth when connection is lost
Date: Tue, 29 Jan 2013 13:40:35 +0100
Message-Id: <1359463236-14809-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_134021_233814_48E771F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver determines the connection is lost,
send a deauth frame to the AP anyway just in case
it still considers the connection alive. The frame
might not go through, but at least we've tried.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5913fb9..e3f90af 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1821,8 +1821,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 
-static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata,
-				   bool transmit_frame)
+static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
@@ -1836,7 +1835,7 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-			       transmit_frame, frame_buf);
+			       true, frame_buf);
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	mutex_unlock(&ifmgd->mtx);
 
@@ -1870,7 +1869,7 @@ static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR) {
 		sdata_info(sdata, "Connection to AP %pM lost\n",
 			   ifmgd->bssid);
-		__ieee80211_disconnect(sdata, false);
+		__ieee80211_disconnect(sdata);
 	} else {
 		ieee80211_mgd_probe_ap(sdata, true);
 	}
@@ -1884,7 +1883,7 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
-	__ieee80211_disconnect(sdata, true);
+	__ieee80211_disconnect(sdata);
 }
 
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
-- 
1.8.0

