Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38223 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab3HWIn5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 04:43:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: add ieee80211_iterate_active_interfaces_rtnl()
Date: Fri, 23 Aug 2013 10:43:52 +0200
Message-Id: <1377247432-22145-1-git-send-email-johannes@sipsolutions.net> (sfid-20130823_104406_776950_214C4DE3)
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
isn't introduced. Use this in the iwlmvm driver to get rid of the
potential deadlock.

While at it, also refactor the various interface iterators and
keep only a single implementation called by the various cases.

Change-Id: I9b578c7dacefbb818b4113da12770aec9d0b06c4
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c |  7 ++--
 include/net/mac80211.h                | 19 ++++++++++
 net/mac80211/util.c                   | 71 +++++++++++++++++------------------
 3 files changed, 56 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 5585538..4b0d033 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1411,10 +1411,9 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 
  out:
 	if (!test)
-		ieee80211_iterate_active_interfaces(mvm->hw,
-						    IEEE80211_IFACE_ITER_NORMAL,
-						    iwl_mvm_d3_disconnect_iter,
-						    NULL);
+		ieee80211_iterate_active_interfaces_rtnl(mvm->hw,
+			IEEE80211_IFACE_ITER_NORMAL,
+			iwl_mvm_d3_disconnect_iter, NULL);
 
 	/* return 1 to reconfigure the device */
 	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cb5eba8..96dba53 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3833,6 +3833,25 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
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
index d23c5a7..f2c0e6b 100644
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
+void __iterate_active_interfaces(struct ieee80211_local *local,
+				 u32 iter_flags,
+				 void (*iterator)(void *data, u8 *mac,
+						  struct ieee80211_vif *vif),
+				 void *data)
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
1.8.4.rc2

