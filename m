Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3H0MFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 08:05:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add ieee80211_iterate_active_interfaces_rtnl()
Date: Tue, 27 Aug 2013 14:05:45 +0200
Message-Id: <1377605145-21353-1-git-send-email-johannes@sipsolutions.net> (sfid-20130827_140558_058283_87FE2375)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If it is needed to disconnect multiple virtual interfaces after
(WoWLAN-) suspend, the most obvious approach would be to iterate
all interfaces by calling ieee80211_iterate_active_interfaces()
and then call ieee80211_resume_disconnect() for each one. This
is what the iwlmvm driver does.

Unfortunately, this causes a locking dependency from mac80211's
iflist_mtx to the key_mtx. This is problematic as the former is
intentionally never held while calling any driver operation to
allow drivers to iterate with their own locks held. The key_mtx
is held while installing a key into the driver though, so this
new lock dependency means drivers implementing the logic above
can no longer hold their own lock while iterating.

To fix this, add a new ieee80211_iterate_active_interfaces_rtnl()
function that iterates while the RTNL is already held. This is
true during suspend/resume, so that then the locking dependency
isn't introduced.

While at it, also refactor the various interface iterators and
keep only a single implementation called by the various cases.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 19 ++++++++++++++
 net/mac80211/util.c    | 71 ++++++++++++++++++++++++--------------------------
 2 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e3e3037..3ecf635 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3919,6 +3919,25 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
 						void *data);
 
 /**
+ * ieee80211_iterate_active_interfaces_rtnl - iterate active interfaces
+ *
+ * This function iterates over the interfaces associated with a given
+ * hardware that are currently active and calls the callback for them.
+ * This version can only be used while holding the RTNL.
+ *
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iter_flags: iteration flags, see &enum ieee80211_interface_iteration_flags
+ * @iterator: the iterator function to call, cannot sleep
+ * @data: first argument of the iterator function
+ */
+void ieee80211_iterate_active_interfaces_rtnl(struct ieee80211_hw *hw,
+					      u32 iter_flags,
+					      void (*iterator)(void *data,
+						u8 *mac,
+						struct ieee80211_vif *vif),
+					      void *data);
+
+/**
  * ieee80211_queue_work - add work onto the mac80211 workqueue
  *
  * Drivers and mac80211 use this to add work onto the mac80211 workqueue.
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e1b34a1..75a1685 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -567,18 +567,15 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH);
 }
 
-void ieee80211_iterate_active_interfaces(
-	struct ieee80211_hw *hw, u32 iter_flags,
-	void (*iterator)(void *data, u8 *mac,
-			 struct ieee80211_vif *vif),
-	void *data)
+static void __iterate_active_interfaces(struct ieee80211_local *local,
+					u32 iter_flags,
+					void (*iterator)(void *data, u8 *mac,
+						struct ieee80211_vif *vif),
+					void *data)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
-	mutex_lock(&local->iflist_mtx);
-
-	list_for_each_entry(sdata, &local->interfaces, list) {
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_MONITOR:
 			if (!(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))
@@ -597,13 +594,25 @@ void ieee80211_iterate_active_interfaces(
 				 &sdata->vif);
 	}
 
-	sdata = rcu_dereference_protected(local->monitor_sdata,
-					  lockdep_is_held(&local->iflist_mtx));
+	sdata = rcu_dereference_check(local->monitor_sdata,
+				      lockdep_is_held(&local->iflist_mtx) ||
+				      lockdep_rtnl_is_held());
 	if (sdata &&
 	    (iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL ||
 	     sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		iterator(data, sdata->vif.addr, &sdata->vif);
+}
 
+void ieee80211_iterate_active_interfaces(
+	struct ieee80211_hw *hw, u32 iter_flags,
+	void (*iterator)(void *data, u8 *mac,
+			 struct ieee80211_vif *vif),
+	void *data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	mutex_lock(&local->iflist_mtx);
+	__iterate_active_interfaces(local, iter_flags, iterator, data);
 	mutex_unlock(&local->iflist_mtx);
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
@@ -615,38 +624,26 @@ void ieee80211_iterate_active_interfaces_atomic(
 	void *data)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
 
 	rcu_read_lock();
+	__iterate_active_interfaces(local, iter_flags, iterator, data);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		switch (sdata->vif.type) {
-		case NL80211_IFTYPE_MONITOR:
-			if (!(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))
-				continue;
-			break;
-		case NL80211_IFTYPE_AP_VLAN:
-			continue;
-		default:
-			break;
-		}
-		if (!(iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL) &&
-		    !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
-			continue;
-		if (ieee80211_sdata_running(sdata))
-			iterator(data, sdata->vif.addr,
-				 &sdata->vif);
-	}
+void ieee80211_iterate_active_interfaces_rtnl(
+	struct ieee80211_hw *hw, u32 iter_flags,
+	void (*iterator)(void *data, u8 *mac,
+			 struct ieee80211_vif *vif),
+	void *data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
 
-	sdata = rcu_dereference(local->monitor_sdata);
-	if (sdata &&
-	    (iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL ||
-	     sdata->flags & IEEE80211_SDATA_IN_DRIVER))
-		iterator(data, sdata->vif.addr, &sdata->vif);
+	ASSERT_RTNL();
 
-	rcu_read_unlock();
+	__iterate_active_interfaces(local, iter_flags, iterator, data);
 }
-EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_rtnl);
 
 /*
  * Nothing should have been stuffed into the workqueue during
-- 
1.8.4.rc3

