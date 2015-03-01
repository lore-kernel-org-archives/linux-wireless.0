Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbbCAHKf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/16] mac80211: handle drv_add_interface failures properly during reconfig
Date: Sun,  1 Mar 2015 09:10:04 +0200
Message-Id: <1425193815-17785-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081044_766484_AD35B651)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If any interface fails to be added to the driver in during reconfig,
we should remove all the successfully added interfaces and report
reconfig failure, so things can be cleaned up properly.  Failing to do
so can lead to subsequent failures and leave the drivers in a messed
up state.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index eec9444..32788674 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1811,8 +1811,25 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-		    ieee80211_sdata_running(sdata))
+		    ieee80211_sdata_running(sdata)) {
 			res = drv_add_interface(local, sdata);
+			if (WARN_ON(res))
+				break;
+		}
+	}
+
+	/* If adding any of the interfaces failed above, roll back and
+	 * report failure.
+	 */
+	if (res) {
+		list_for_each_entry_continue_reverse(sdata, &local->interfaces,
+						     list)
+			if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+			    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
+			    ieee80211_sdata_running(sdata))
+				drv_remove_interface(local, sdata);
+		ieee80211_handle_reconfig_failure(local);
+		return res;
 	}
 
 	/* add channel contexts */
-- 
1.9.1

