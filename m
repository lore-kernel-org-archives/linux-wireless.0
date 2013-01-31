Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3AaNOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:14:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: send deauth if connection was lost during suspend
Date: Thu, 31 Jan 2013 14:15:07 +0100
Message-Id: <1359638107-15306-2-git-send-email-johannes@sipsolutions.net> (sfid-20130131_141449_707736_79A42411)
In-Reply-To: <1359638107-15306-1-git-send-email-johannes@sipsolutions.net>
References: <1359638107-15306-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver determined the connection was lost or that
it couldn't securely maintain the connection when coming
out of WoWLAN, send a deauth frame to the AP to also let
it know.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 199969c..946cb67 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2867,14 +2867,14 @@ static void ieee80211_sta_timer(unsigned long data)
 }
 
 static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
-					  u8 *bssid, u8 reason)
+					  u8 *bssid, u8 reason, bool tx)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH, reason,
-			       false, frame_buf);
+			       tx, frame_buf);
 	mutex_unlock(&ifmgd->mtx);
 
 	/*
@@ -3074,7 +3074,8 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 					 "No ack for nullfunc frame to AP %pM, disconnecting.\n",
 					 bssid);
 				ieee80211_sta_connection_lost(sdata, bssid,
-					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
+					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
+					false);
 			}
 		} else if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
@@ -3083,7 +3084,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				 "Failed to send nullfunc to AP %pM after %dms, disconnecting\n",
 				 bssid, probe_wait_ms);
 			ieee80211_sta_connection_lost(sdata, bssid,
-				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
+				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY, false);
 		} else if (ifmgd->probe_send_count < max_tries) {
 			mlme_dbg(sdata,
 				 "No probe response from AP %pM after %dms, try %d/%i\n",
@@ -3102,7 +3103,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				    bssid, probe_wait_ms);
 
 			ieee80211_sta_connection_lost(sdata, bssid,
-				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
+				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY, false);
 		}
 	}
 
@@ -3209,7 +3210,8 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 		mlme_dbg(sdata, "driver requested disconnect after resume\n");
 		ieee80211_sta_connection_lost(sdata,
 					      ifmgd->associated->bssid,
-					      WLAN_REASON_UNSPECIFIED);
+					      WLAN_REASON_UNSPECIFIED,
+					      true);
 		mutex_unlock(&ifmgd->mtx);
 		return;
 	}
-- 
1.8.0

