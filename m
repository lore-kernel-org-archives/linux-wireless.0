Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbbGHMmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/10] mac80211: shut down interfaces before destroying interface list
Date: Wed,  8 Jul 2015 15:41:50 +0300
Message-Id: <1436359312-26533-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144234_957308_D5968C26)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the hardware is unregistered while interfaces are up, mac80211 will
unregister all interfaces, which in turns causes mac80211 to be called
again to remove them all from the driver and eventually shut down the
hardware.

During this shutdown, however, it's currently already unsafe to iterate
the list of interfaces atomically, as the list is manipulated in an
unsafe manner. This puts an undue burden on the driver - it must stop
all its activities before calling ieee80211_unregister_hw(), while in
the normal stop path it can do all cleanup in the stop method. If, for
example, it's using the iteration during RX for some reason, it would
have to stop RX before unregistering to avoid crashes.

Fix this problem by closing all interfaces before unregistering them.
This will cause the driver stop to have completed before we manipulate
the interface list, and after the driver is stopped *and* has called
ieee80211_unregister_hw() it really musn't be iterating any more as
the memory will be freed as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e648ea8..0fba7f9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1861,10 +1861,6 @@ void ieee80211_sdata_stop(struct ieee80211_sub_if_data *sdata)
 	ieee80211_teardown_sdata(sdata);
 }
 
-/*
- * Remove all interfaces, may only be called at hardware unregistration
- * time because it doesn't do RCU-safe list removals.
- */
 void ieee80211_remove_interfaces(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata, *tmp;
@@ -1873,14 +1869,21 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 
 	ASSERT_RTNL();
 
-	/*
-	 * Close all AP_VLAN interfaces first, as otherwise they
-	 * might be closed while the AP interface they belong to
-	 * is closed, causing unregister_netdevice_many() to crash.
+	/* Before destroying the interfaces, make sure they're all stopped so
+	 * that the hardware is stopped. Otherwise, the driver might still be
+	 * iterating the interfaces during the shutdown, e.g. from a worker
+	 * or from RX processing or similar, and if it does so (using atomic
+	 * iteration) while we're manipulating the list, the iteration will
+	 * crash.
+	 *
+	 * After this, the hardware should be stopped and the driver should
+	 * have stopped all of its activities, so that we can do RCU-unaware
+	 * manipulations of the interface list below.
 	 */
-	list_for_each_entry(sdata, &local->interfaces, list)
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-			dev_close(sdata->dev);
+	cfg80211_shutdown_all_interfaces(local->hw.wiphy);
+
+	WARN(local->open_count, "%s: open count remains %d\n",
+	     wiphy_name(local->hw.wiphy), local->open_count);
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
-- 
2.1.4

