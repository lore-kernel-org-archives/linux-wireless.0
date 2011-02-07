Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42485 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1BGVoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 16:44:44 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/7] mac80211:  Make STA disconnect messages warn instead of debug.
Date: Mon,  7 Feb 2011 13:44:32 -0800
Message-Id: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This makes them more easily seen in /var/log/messages
and the console, for instance.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 f77adf1... 340bef6... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f77adf1..340bef6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2019,10 +2019,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				ieee80211_mgd_probe_ap_send(sdata);
 			} else {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-				wiphy_debug(local->hw.wiphy,
-					    "%s: No ack for nullfunc frame to"
-					    " AP %pM, disconnecting.\n",
-					    sdata->name, bssid);
+				wiphy_warn(local->hw.wiphy,
+					   "%s: No ack for nullfunc frame to"
+					   " AP %pM, disconnecting.\n",
+					   sdata->name, bssid);
 #endif
 				ieee80211_sta_connection_lost(sdata, bssid);
 			}
@@ -2030,11 +2030,11 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			run_again(ifmgd, ifmgd->probe_timeout);
 		else if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			wiphy_debug(local->hw.wiphy,
-				    "%s: Failed to send nullfunc to AP %pM"
-				    " after %dms, disconnecting.\n",
-				    sdata->name,
-				    bssid, probe_wait_ms);
+			wiphy_warn(local->hw.wiphy,
+				   "%s: Failed to send nullfunc to AP %pM"
+				   " after %dms, disconnecting.\n",
+				   sdata->name,
+				   bssid, probe_wait_ms);
 #endif
 			ieee80211_sta_connection_lost(sdata, bssid);
 		} else if (ifmgd->probe_send_count < max_tries) {
@@ -2052,11 +2052,11 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 * We actually lost the connection ... or did we?
 			 * Let's make sure!
 			 */
-			wiphy_debug(local->hw.wiphy,
-				    "%s: No probe response from AP %pM"
-				    " after %dms, disconnecting.\n",
-				    sdata->name,
-				    bssid, probe_wait_ms);
+			wiphy_warn(local->hw.wiphy,
+				   "%s: No probe response from AP %pM"
+				   " after %dms, disconnecting.\n",
+				   sdata->name,
+				   bssid, probe_wait_ms);
 
 			ieee80211_sta_connection_lost(sdata, bssid);
 		}
-- 
1.7.2.3

