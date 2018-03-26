Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:42323 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbeCZRxD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 13:53:03 -0400
Received: by mail-oi0-f66.google.com with SMTP id l190-v6so8598391oig.9
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 10:53:02 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v7 04/11] cfg80211: Support all iftypes in autodisconnect_wk
Date: Mon, 26 Mar 2018 12:52:44 -0500
Message-Id: <20180326175251.20666-5-denkenz@gmail.com> (sfid-20180326_195305_976243_58FC3F8D)
In-Reply-To: <20180326175251.20666-1-denkenz@gmail.com>
References: <20180326175251.20666-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently autodisconnect_wk assumes that only interface types of
P2P_CLIENT and STATION use conn_owner_nlportid.  Change this so all
interface types are supported.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/sme.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 701cfd7acc1b..5df6b33db786 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1239,17 +1239,38 @@ void cfg80211_autodisconnect_wk(struct work_struct *work)
 	wdev_lock(wdev);
 
 	if (wdev->conn_owner_nlportid) {
-		/*
-		 * Use disconnect_bssid if still connecting and ops->disconnect
-		 * not implemented.  Otherwise we can use cfg80211_disconnect.
-		 */
-		if (rdev->ops->disconnect || wdev->current_bss)
-			cfg80211_disconnect(rdev, wdev->netdev,
-					    WLAN_REASON_DEAUTH_LEAVING, true);
-		else
-			cfg80211_mlme_deauth(rdev, wdev->netdev,
-					     wdev->disconnect_bssid, NULL, 0,
-					     WLAN_REASON_DEAUTH_LEAVING, false);
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_ADHOC:
+			cfg80211_leave_ibss(rdev, wdev->netdev, false);
+			break;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
+			cfg80211_stop_ap(rdev, wdev->netdev, false);
+			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			cfg80211_leave_mesh(rdev, wdev->netdev);
+			break;
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_P2P_CLIENT:
+			/*
+			 * Use disconnect_bssid if still connecting and
+			 * ops->disconnect not implemented.  Otherwise we can
+			 * use cfg80211_disconnect.
+			 */
+			if (rdev->ops->disconnect || wdev->current_bss)
+				cfg80211_disconnect(rdev, wdev->netdev,
+						    WLAN_REASON_DEAUTH_LEAVING,
+						    true);
+			else
+				cfg80211_mlme_deauth(rdev, wdev->netdev,
+						     wdev->disconnect_bssid,
+						     NULL, 0,
+						     WLAN_REASON_DEAUTH_LEAVING,
+						     false);
+			break;
+		default:
+			break;
+		}
 	}
 
 	wdev_unlock(wdev);
-- 
2.13.5
