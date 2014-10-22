Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:11906 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbaJVJfW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 05:35:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: expose API allowing station iteration
Date: Wed, 22 Oct 2014 12:30:59 +0300
Message-Id: <1413970259-5649-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141022_113531_587806_2E9F40BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Allow drivers to iterate all stations currently uploaded to them.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 16 ++++++++++++++++
 net/mac80211/util.c    | 28 ++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9dc5e76..e544bbf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4190,6 +4190,22 @@ void ieee80211_iterate_active_interfaces_rtnl(struct ieee80211_hw *hw,
 					      void *data);
 
 /**
+ * ieee80211_iterate_stations_atomic - iterate stations
+ *
+ * This function iterates over all stations associated with a given
+ * hardware that are currently uploaded to the driver and calls the callback
+ * function for them.
+ * This function requires the iterator callback function to be atomic,
+ *
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iterator: the iterator function to call, cannot sleep
+ * @data: first argument of the iterator function
+ */
+void ieee80211_iterate_stations_atomic(struct ieee80211_hw *hw,
+				       void (*iterator)(void *data,
+						struct ieee80211_sta *sta),
+				       void *data);
+/**
  * ieee80211_queue_work - add work onto the mac80211 workqueue
  *
  * Drivers and mac80211 use this to add work onto the mac80211 workqueue.
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c76c9d7..3d07d8d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -693,6 +693,34 @@ void ieee80211_iterate_active_interfaces_rtnl(
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_rtnl);
 
+static void __iterate_stations(struct ieee80211_local *local,
+			       void (*iterator)(void *data,
+						struct ieee80211_sta *sta),
+			       void *data)
+{
+	struct sta_info *sta;
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (!sta->uploaded)
+			continue;
+
+		iterator(data, &sta->sta);
+	}
+}
+
+void ieee80211_iterate_stations_atomic(struct ieee80211_hw *hw,
+			void (*iterator)(void *data,
+					 struct ieee80211_sta *sta),
+			void *data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	rcu_read_lock();
+	__iterate_stations(local, iterator, data);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_stations_atomic);
+
 struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-- 
1.9.1

