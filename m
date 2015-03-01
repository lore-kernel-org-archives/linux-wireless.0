Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbbCAHK4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:56 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/16] mac80211: allow iterating inactive interfaces
Date: Sun,  1 Mar 2015 09:10:15 +0200
Message-Id: <1425193815-17785-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_083417_526530_309F649B)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Sometimes the driver might want to modify private data in interfaces
that are down. One possible use-case is cleaning up interface state
after HW recovery. Some interfaces that were up before the recovery took
place might be down now, but they might still be "dirty".

Introduce a new iterate_interfaces() API and a new ACTIVE iterator flag.
This way the internal implementation of the both active and inactive
APIs remains the same.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 35 ++++++++++++++++++++++++++++++-----
 net/mac80211/util.c    | 29 ++++++++++++++++-------------
 2 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dcd309b..4a4619d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4353,13 +4353,33 @@ void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw);
  *	haven't been re-added to the driver yet.
  * @IEEE80211_IFACE_ITER_RESUME_ALL: During resume, iterate over all
  *	interfaces, even if they haven't been re-added to the driver yet.
+ * @IEEE80211_IFACE_ITER_ACTIVE: Iterate only active interfaces (netdev is up).
  */
 enum ieee80211_interface_iteration_flags {
 	IEEE80211_IFACE_ITER_NORMAL	= 0,
 	IEEE80211_IFACE_ITER_RESUME_ALL	= BIT(0),
+	IEEE80211_IFACE_ITER_ACTIVE	= BIT(1),
 };
 
 /**
+ * ieee80211_iterate_interfaces - iterate interfaces
+ *
+ * This function iterates over the interfaces associated with a given
+ * hardware and calls the callback for them. This includes active as well as
+ * inactive interfaces. This function allows the iterator function to sleep.
+ * Will iterate over a new interface during add_interface().
+ *
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iter_flags: iteration flags, see &enum ieee80211_interface_iteration_flags
+ * @iterator: the iterator function to call
+ * @data: first argument of the iterator function
+ */
+void ieee80211_iterate_interfaces(struct ieee80211_hw *hw, u32 iter_flags,
+				  void (*iterator)(void *data, u8 *mac,
+						   struct ieee80211_vif *vif),
+				  void *data);
+
+/**
  * ieee80211_iterate_active_interfaces - iterate active interfaces
  *
  * This function iterates over the interfaces associated with a given
@@ -4374,11 +4394,16 @@ enum ieee80211_interface_iteration_flags {
  * @iterator: the iterator function to call
  * @data: first argument of the iterator function
  */
-void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
-					 u32 iter_flags,
-					 void (*iterator)(void *data, u8 *mac,
-						struct ieee80211_vif *vif),
-					 void *data);
+static inline void
+ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw, u32 iter_flags,
+				    void (*iterator)(void *data, u8 *mac,
+						     struct ieee80211_vif *vif),
+				    void *data)
+{
+	ieee80211_iterate_interfaces(hw,
+				     iter_flags | IEEE80211_IFACE_ITER_ACTIVE,
+				     iterator, data);
+}
 
 /**
  * ieee80211_iterate_active_interfaces_atomic - iterate active interfaces
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 32788674..37d85d3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -625,13 +625,14 @@ void ieee80211_wake_vif_queues(struct ieee80211_local *local,
 					reason, true);
 }
 
-static void __iterate_active_interfaces(struct ieee80211_local *local,
-					u32 iter_flags,
-					void (*iterator)(void *data, u8 *mac,
-						struct ieee80211_vif *vif),
-					void *data)
+static void __iterate_interfaces(struct ieee80211_local *local,
+				 u32 iter_flags,
+				 void (*iterator)(void *data, u8 *mac,
+						  struct ieee80211_vif *vif),
+				 void *data)
 {
 	struct ieee80211_sub_if_data *sdata;
+	bool active_only = iter_flags & IEEE80211_IFACE_ITER_ACTIVE;
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
@@ -645,9 +646,9 @@ static void __iterate_active_interfaces(struct ieee80211_local *local,
 			break;
 		}
 		if (!(iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL) &&
-		    !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
+		    active_only && !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 			continue;
-		if (ieee80211_sdata_running(sdata))
+		if (ieee80211_sdata_running(sdata) || !active_only)
 			iterator(data, sdata->vif.addr,
 				 &sdata->vif);
 	}
@@ -656,12 +657,12 @@ static void __iterate_active_interfaces(struct ieee80211_local *local,
 				      lockdep_is_held(&local->iflist_mtx) ||
 				      lockdep_rtnl_is_held());
 	if (sdata &&
-	    (iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL ||
+	    (iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL || !active_only ||
 	     sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		iterator(data, sdata->vif.addr, &sdata->vif);
 }
 
-void ieee80211_iterate_active_interfaces(
+void ieee80211_iterate_interfaces(
 	struct ieee80211_hw *hw, u32 iter_flags,
 	void (*iterator)(void *data, u8 *mac,
 			 struct ieee80211_vif *vif),
@@ -670,10 +671,10 @@ void ieee80211_iterate_active_interfaces(
 	struct ieee80211_local *local = hw_to_local(hw);
 
 	mutex_lock(&local->iflist_mtx);
-	__iterate_active_interfaces(local, iter_flags, iterator, data);
+	__iterate_interfaces(local, iter_flags, iterator, data);
 	mutex_unlock(&local->iflist_mtx);
 }
-EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
+EXPORT_SYMBOL_GPL(ieee80211_iterate_interfaces);
 
 void ieee80211_iterate_active_interfaces_atomic(
 	struct ieee80211_hw *hw, u32 iter_flags,
@@ -684,7 +685,8 @@ void ieee80211_iterate_active_interfaces_atomic(
 	struct ieee80211_local *local = hw_to_local(hw);
 
 	rcu_read_lock();
-	__iterate_active_interfaces(local, iter_flags, iterator, data);
+	__iterate_interfaces(local, iter_flags | IEEE80211_IFACE_ITER_ACTIVE,
+			     iterator, data);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
@@ -699,7 +701,8 @@ void ieee80211_iterate_active_interfaces_rtnl(
 
 	ASSERT_RTNL();
 
-	__iterate_active_interfaces(local, iter_flags, iterator, data);
+	__iterate_interfaces(local, iter_flags | IEEE80211_IFACE_ITER_ACTIVE,
+			     iterator, data);
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_rtnl);
 
-- 
1.9.1

