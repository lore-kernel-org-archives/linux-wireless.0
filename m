Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45179 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756490AbbIUMuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:50:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ayala Beker <ayala.beker@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 15:49:53 +0300
Message-Id: <1442839793-26164-1-git-send-email-luca@coelho.fi> (sfid-20150921_145008_211228_809256EA)
Subject: [PATCH] cfg80211: allow changing station capabilities for unassociated stations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Currently, cfg80211 rejects capability updates for existing entries
and as a result it's impossible to update entries that were added
unassociated, but that is necessary to go through the full station
states from userspace, adding a station before authentication etc.

Fix this by allowing updates to capabilities for stations that the
driver (or mac80211) assigned unassociated state. Drivers setting
the full station state support flag must use the new station type
for proper operation.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 3 +++
 net/wireless/nl80211.c | 7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bfafa7d..a5b86d0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -859,6 +859,8 @@ struct station_del_parameters {
 /**
  * enum cfg80211_station_type - the type of station being modified
  * @CFG80211_STA_AP_CLIENT: client of an AP interface
+ * @CFG80211_STA_AP_CLIENT_UNASSOC: client of an AP interface that is still
+ *	unassociated (update properties for this type of client is permitted)
  * @CFG80211_STA_AP_MLME_CLIENT: client of an AP interface that has
  *	the AP MLME in the device
  * @CFG80211_STA_AP_STA: AP station on managed interface
@@ -874,6 +876,7 @@ struct station_del_parameters {
  */
 enum cfg80211_station_type {
 	CFG80211_STA_AP_CLIENT,
+	CFG80211_STA_AP_CLIENT_UNASSOC,
 	CFG80211_STA_AP_MLME_CLIENT,
 	CFG80211_STA_AP_STA,
 	CFG80211_STA_IBSS,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5b64bba..2b007b9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4021,7 +4021,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 		params->sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
 	}
 
-	if (statype != CFG80211_STA_TDLS_PEER_SETUP) {
+	if (statype != CFG80211_STA_TDLS_PEER_SETUP &&
+	    statype != CFG80211_STA_AP_CLIENT_UNASSOC) {
 		/* reject other things that can't change */
 		if (params->sta_modify_mask & STATION_PARAM_APPLY_UAPSD)
 			return -EINVAL;
@@ -4033,7 +4034,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 			return -EINVAL;
 	}
 
-	if (statype != CFG80211_STA_AP_CLIENT) {
+	if (statype != CFG80211_STA_AP_CLIENT &&
+	    statype != CFG80211_STA_AP_CLIENT_UNASSOC) {
 		if (params->vlan)
 			return -EINVAL;
 	}
@@ -4045,6 +4047,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 			return -EOPNOTSUPP;
 		break;
 	case CFG80211_STA_AP_CLIENT:
+	case CFG80211_STA_AP_CLIENT_UNASSOC:
 		/* accept only the listed bits */
 		if (params->sta_flags_mask &
 				~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
-- 
2.5.1

