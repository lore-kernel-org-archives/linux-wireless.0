Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbbCAHKi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:38 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/16] mac80211: don't do driver suspend with auth/assoc in progress
Date: Sun,  1 Mar 2015 09:10:06 +0200
Message-Id: <1425193815-17785-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081047_161231_904042B0)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Drivers can't really be expected to suspend properly while auth
or assoc is in progress since then they don't have any state
they could keep with WoWLAN, nor can they actually finish the
authentication or association. In fact, keeping this can cause
subtle issues with drivers like iwlwifi that refuse WoWLAN if
not associated, but have trouble figuring out what's going on
in the middle of association.

In any case, regardless of possible driver issues in this area,
it doesn't make sense for mac80211 to try to WoWLAN-suspend in
the middle of such operations, so stop them before.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index ca405b6..bd185f3 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -61,7 +61,24 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	local->wowlan = wowlan && local->open_count;
 	if (local->wowlan) {
-		int err = drv_suspend(local, wowlan);
+		int err;
+
+		/* Drivers don't expect to suspend while some operations like
+		 * authenticating or associating are in progress. It doesn't
+		 * make sense anyway to accept that, since the authentication
+		 * or association would never finish since the driver can't do
+		 * that on its own.
+		 * Thus, clean up in-progress auth/assoc first.
+		 */
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (!ieee80211_sdata_running(sdata))
+				continue;
+			if (sdata->vif.type != NL80211_IFTYPE_STATION)
+				continue;
+			ieee80211_mgd_quiesce(sdata);
+		}
+
+		err = drv_suspend(local, wowlan);
 		if (err < 0) {
 			local->quiescing = false;
 			local->wowlan = false;
-- 
1.9.1

