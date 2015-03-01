Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbbCAHKm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:42 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/16] mac80211: start queues if driver rejected wowlan
Date: Sun,  1 Mar 2015 09:10:08 +0200
Message-Id: <1425193815-17785-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081049_232092_080C1434)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver rejects WoWLAN, restart the queues before returning
to cfg80211. cfg80211 will return to mac80211, but not before it
disconnects all interfaces. If we don't start the queues, any of
the packets needed for disconnecting won't be transmitted, which
is strange. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 46ffe3a..ac6ad62 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -97,6 +97,13 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			return err;
 		} else if (err > 0) {
 			WARN_ON(err != 1);
+			/* cfg80211 will call back into mac80211 to disconnect
+			 * all interfaces, allow that to proceed properly
+			 */
+			ieee80211_wake_queues_by_reason(hw,
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
+					false);
 			return err;
 		} else {
 			goto suspend;
-- 
1.9.1

