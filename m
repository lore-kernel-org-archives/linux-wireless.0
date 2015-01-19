Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:51975 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751396AbbASU2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 15:28:32 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Jan 2015 22:28:11 +0200
Message-Id: <1421699291-16279-1-git-send-email-luca@coelho.fi> (sfid-20150119_212835_153843_7B22FDBF)
Subject: [PATCH] mac80211: only roll back station states for WDS when suspending
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In the suspend code, we shouldn't roll back the station states because
this is taken care of in other parts of the code, except for WDS
interfaces.  For AP types of interfaces, cfg80211 takes care of
disconnecting all stations before calling the driver's suspend code.
For station interfaces, this will be done in the quiesce code.

For WDS interfaces we still need to do it here, so move the code into
a new case switch for WDS.

Cc: stable@kernel.org [3.15+]
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/pm.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 8c8c678..ca405b6 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -86,20 +86,6 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		}
 	}
 
-	/* tear down aggregation sessions and remove STAs */
-	mutex_lock(&local->sta_mtx);
-	list_for_each_entry(sta, &local->sta_list, list) {
-		if (sta->uploaded) {
-			enum ieee80211_sta_state state;
-
-			state = sta->sta_state;
-			for (; state > IEEE80211_STA_NOTEXIST; state--)
-				WARN_ON(drv_sta_state(local, sta->sdata, sta,
-						      state, state - 1));
-		}
-	}
-	mutex_unlock(&local->sta_mtx);
-
 	/* remove all interfaces that were created in the driver */
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
@@ -111,6 +97,21 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		case NL80211_IFTYPE_STATION:
 			ieee80211_mgd_quiesce(sdata);
 			break;
+		case NL80211_IFTYPE_WDS:
+			/* tear down aggregation sessions and remove STAs */
+			mutex_lock(&local->sta_mtx);
+			sta = sdata->u.wds.sta;
+			if (sta && sta->uploaded) {
+				enum ieee80211_sta_state state;
+
+				state = sta->sta_state;
+				for (; state > IEEE80211_STA_NOTEXIST; state--)
+					WARN_ON(drv_sta_state(local, sta->sdata,
+							      sta, state,
+							      state - 1));
+			}
+			mutex_unlock(&local->sta_mtx);
+			break;
 		default:
 			break;
 		}
-- 
2.1.4

