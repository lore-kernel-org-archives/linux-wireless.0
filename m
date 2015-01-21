Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48684 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbbAUMzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2015 07:55:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix HW registration error paths
Date: Wed, 21 Jan 2015 13:55:40 +0100
Message-Id: <1421844940-22980-1-git-send-email-johannes@sipsolutions.net> (sfid-20150121_135603_503865_C028EDF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Station info state is started in allocation, so should be
destroyed on free (it's just a timer); rate control must
be freed if anything afterwards fails to initialize.

LED exit should be later, no need for locking there, but
it needs to be done also when rate init failed.

Also clean up the code by moving a label so the locking
doesn't have to be done separately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8890438a7266..336c72137a0d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1053,10 +1053,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		ieee80211_max_network_latency;
 	result = pm_qos_add_notifier(PM_QOS_NETWORK_LATENCY,
 				     &local->network_latency_notifier);
-	if (result) {
-		rtnl_lock();
+	if (result)
 		goto fail_pm_qos;
-	}
 
 #ifdef CONFIG_INET
 	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
@@ -1084,15 +1082,15 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
  fail_ifa:
 	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
 			       &local->network_latency_notifier);
-	rtnl_lock();
 #endif
  fail_pm_qos:
-	ieee80211_led_exit(local);
+	rtnl_lock();
+	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);
  fail_rate:
 	rtnl_unlock();
+	ieee80211_led_exit(local);
 	ieee80211_wep_free(local);
-	sta_info_stop(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
@@ -1188,6 +1186,8 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 
 	kfree(rcu_access_pointer(local->tx_latency));
 
+	sta_info_stop(local);
+
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
-- 
2.1.4

