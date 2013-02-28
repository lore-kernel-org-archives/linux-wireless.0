Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3B1WTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:19:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: flush keys when stopping AP
Date: Thu, 28 Feb 2013 23:19:30 +0100
Message-Id: <1362089971-12182-1-git-send-email-johannes@sipsolutions.net> (sfid-20130228_231938_867224_2603DCF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since hostapd will remove keys this isn't usually
an issue, but we shouldn't leak keys to the next
BSS started on the same interface. For VLANs this
also fixes a bug, keys that aren't removed would
otherwise be leaked.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c   | 5 ++++-
 net/mac80211/iface.c | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 64da5a4..3ba614d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1035,9 +1035,12 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		sta_info_flush_defer(vlan);
 	sta_info_flush_defer(sdata);
 	rcu_barrier();
-	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
 		sta_info_flush_cleanup(vlan);
+		ieee80211_free_keys(vlan);
+	}
 	sta_info_flush_cleanup(sdata);
+	ieee80211_free_keys(sdata);
 
 	sdata->vif.bss_conf.enable_beacon = false;
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index feda9fb..74228d9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -836,7 +836,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 		/*
 		 * Free all remaining keys, there shouldn't be any,
-		 * except maybe group keys in AP more or WDS?
+		 * except maybe in WDS mode?
 		 */
 		ieee80211_free_keys(sdata);
 
-- 
1.8.0

