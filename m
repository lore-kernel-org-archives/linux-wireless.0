Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40960 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0IJWFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 18:05:20 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [virtual-sta 1/3] mac80211:  Add more general interface iterator.
Date: Fri, 10 Sep 2010 15:04:56 -0700
Message-Id: <1284156298-15863-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows callers to specify whether they want all
or just active interfaces, and whether their iterator
is atomic or not.  A count for the number of interfaces
is returned to remove need for similar logic in the
drivers.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 f91fc33... 53e5d5b... M	include/net/mac80211.h
:100644 100644 bd40b11... ad96d5f... M	net/mac80211/util.c
 include/net/mac80211.h |   24 +++++++++++
 net/mac80211/util.c    |  102 +++++++++++++++++++++++++++---------------------
 2 files changed, 82 insertions(+), 44 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f91fc33..53e5d5b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2320,6 +2320,30 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
 						    u8 *mac,
 						    struct ieee80211_vif *vif),
 						void *data);
+/**
+ * ieee80211_iterate_interfaces_helper - iterate interfaces
+ *
+ * This function iterates over the interfaces associated with a given
+ * hardware and calls the callback for them.  If do_atomic is true,
+ * this function requires the iterator callback function to be atomic,
+ * if that is not desired, set do_atomic to false.
+ * If you want only active interfaces, set active_only to true.
+ * See also: @ieee80211_iterate_active_interfaces
+ *           @ieee80211_iterate_active_interfaces_atomic
+ *
+ * Returns number of interfaces to be filtered.
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @do_atomic:  Should iterator be treated as atomic or not.
+ * @active_only:  Should we only iterate over active interfaces.
+ * @iterator: the iterator function to call, cannot sleep
+ * @data: first argument of the iterator function
+ */
+int ieee80211_iterate_interfaces_helper(struct ieee80211_hw *hw,
+					bool do_atomic,
+					bool active_only,
+					void (*iterator)(void *data, u8 *mac,
+						struct ieee80211_vif *vif),
+					void *data);
 
 /**
  * ieee80211_queue_work - add work onto the mac80211 workqueue
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index bd40b11..ad96d5f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -461,71 +461,85 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
-void ieee80211_iterate_active_interfaces(
-	struct ieee80211_hw *hw,
+static int _iter_loop_helper(
+	struct ieee80211_sub_if_data *sdata,
+	bool active_only,
 	void (*iterator)(void *data, u8 *mac,
 			 struct ieee80211_vif *vif),
 	void *data)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
-
-	mutex_lock(&local->iflist_mtx);
-
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		switch (sdata->vif.type) {
-		case NUM_NL80211_IFTYPES:
-		case NL80211_IFTYPE_UNSPECIFIED:
-		case NL80211_IFTYPE_MONITOR:
-		case NL80211_IFTYPE_AP_VLAN:
-			continue;
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_WDS:
-		case NL80211_IFTYPE_MESH_POINT:
-			break;
-		}
-		if (ieee80211_sdata_running(sdata))
+	switch (sdata->vif.type) {
+	case NUM_NL80211_IFTYPES:
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_AP_VLAN:
+		return 0;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_MESH_POINT:
+		break;
+	}
+	if (ieee80211_sdata_running(sdata) || !active_only) {
+		if (iterator)
 			iterator(data, sdata->vif.addr,
 				 &sdata->vif);
+		return 1;
 	}
-
-	mutex_unlock(&local->iflist_mtx);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
 
-void ieee80211_iterate_active_interfaces_atomic(
+int ieee80211_iterate_interfaces_helper(
 	struct ieee80211_hw *hw,
+	bool do_atomic,
+	bool active_only,
 	void (*iterator)(void *data, u8 *mac,
 			 struct ieee80211_vif *vif),
 	void *data)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
+	int cnt = 0;
 
-	rcu_read_lock();
+	if (do_atomic) {
+		rcu_read_lock();
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		switch (sdata->vif.type) {
-		case NUM_NL80211_IFTYPES:
-		case NL80211_IFTYPE_UNSPECIFIED:
-		case NL80211_IFTYPE_MONITOR:
-		case NL80211_IFTYPE_AP_VLAN:
-			continue;
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_WDS:
-		case NL80211_IFTYPE_MESH_POINT:
-			break;
+		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+			cnt += _iter_loop_helper(sdata, active_only,
+						 iterator, data);
 		}
-		if (ieee80211_sdata_running(sdata))
-			iterator(data, sdata->vif.addr,
-				 &sdata->vif);
+		rcu_read_unlock();
+	} else {
+		mutex_lock(&local->iflist_mtx);
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			cnt += _iter_loop_helper(sdata, active_only,
+						 iterator, data);
+		}
+		mutex_unlock(&local->iflist_mtx);
 	}
+	return cnt;
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_interfaces_helper);
 
-	rcu_read_unlock();
+
+void ieee80211_iterate_active_interfaces(
+	struct ieee80211_hw *hw,
+	void (*iterator)(void *data, u8 *mac,
+			 struct ieee80211_vif *vif),
+	void *data)
+{
+	ieee80211_iterate_interfaces_helper(hw, false, false, iterator, data);
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
+
+void ieee80211_iterate_active_interfaces_atomic(
+	struct ieee80211_hw *hw,
+	void (*iterator)(void *data, u8 *mac,
+			 struct ieee80211_vif *vif),
+	void *data)
+{
+	ieee80211_iterate_interfaces_helper(hw, true, false, iterator, data);
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
 
-- 
1.7.2.2

