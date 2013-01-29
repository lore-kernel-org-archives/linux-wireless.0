Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3A2Knj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 05:43:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/2] mac80211: send deauth if connection was lost during suspend
Date: Tue, 29 Jan 2013 11:43:58 +0100
Message-Id: <1359456239-28077-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_114343_426041_4BDB3022)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver determined the connection was lost or that
it couldn't securely maintain the connection when coming
out of WoWLAN, send a deauth frame to the AP to also let
it know.

Change-Id: I7bc941c3f826d437fbf2c3157f62e792a8000af9
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 344ef7d..8c10e90 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2836,14 +2836,14 @@ static void ieee80211_sta_timer(unsigned long data)
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
@@ -3042,7 +3042,8 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 					 "No ack for nullfunc frame to AP %pM, disconnecting.\n",
 					 bssid);
 				ieee80211_sta_connection_lost(sdata, bssid,
-					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
+					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
+					false);
 			}
 		} else if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
@@ -3051,7 +3052,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				 "Failed to send nullfunc to AP %pM after %dms, disconnecting\n",
 				 bssid, probe_wait_ms);
 			ieee80211_sta_connection_lost(sdata, bssid,
-				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
+				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY, false);
 		} else if (ifmgd->probe_send_count < max_tries) {
 			mlme_dbg(sdata,
 				 "No probe response from AP %pM after %dms, try %d/%i\n",
@@ -3070,7 +3071,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				    bssid, probe_wait_ms);
 
 			ieee80211_sta_connection_lost(sdata, bssid,
-				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
+				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY, false);
 		}
 	}
 
@@ -3176,7 +3177,7 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 				 "driver requested disconnect after resume\n");
 			ieee80211_sta_connection_lost(sdata,
 				ifmgd->associated->bssid,
-				WLAN_REASON_UNSPECIFIED);
+				WLAN_REASON_UNSPECIFIED, true);
 			mutex_unlock(&ifmgd->mtx);
 			return;
 		}
-- 
1.8.0

