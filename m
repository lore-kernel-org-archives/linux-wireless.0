Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab2LNNqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 08:46:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: reconfig bss_info_changed only if beaconing
Date: Fri, 14 Dec 2012 14:46:44 +0100
Message-Id: <1355492806-31673-3-git-send-email-johannes@sipsolutions.net> (sfid-20121214_144632_656177_199BB8CF)
In-Reply-To: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net>
References: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For AP/IBSS/mesh interfaces, call the driver to reconfigure
bss_info_changed only if the interface was beaconing before
suspend, otherwise we call the driver and it might interpret
the change as going from enabled to disabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c170b9d..9954927 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1562,9 +1562,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 
 			/* fall through */
 		case NL80211_IFTYPE_MESH_POINT:
-			changed |= BSS_CHANGED_BEACON |
-				   BSS_CHANGED_BEACON_ENABLED;
-			ieee80211_bss_info_change_notify(sdata, changed);
+			if (sdata->vif.bss_conf.enable_beacon) {
+				changed |= BSS_CHANGED_BEACON |
+					   BSS_CHANGED_BEACON_ENABLED;
+				ieee80211_bss_info_change_notify(sdata, changed);
+			}
 			break;
 		case NL80211_IFTYPE_WDS:
 			break;
-- 
1.8.0

