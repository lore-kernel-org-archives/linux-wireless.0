Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbXKIMJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 07:09:25 -0500
Subject: [PATCH] mac80211: provide interface iterator for drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 01:57:29 +0100
Message-Id: <1194569850.4793.38.camel@johannes.berg> (sfid-20071109_120928_819255_2705D7AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes drivers need to know which interfaces are associated with
their hardware. Rather than forcing those drivers to keep track of
the interfaces that were added, this adds an iteration function to
mac80211.

As it is intended to be used from the interface add/remove callbacks,
the iteration function may currently only be called under RTNL.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   16 ++++++++++++++++
 net/mac80211/util.c    |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- everything.orig/include/net/mac80211.h	2007-11-09 00:31:40.828983181 +0100
+++ everything/include/net/mac80211.h	2007-11-09 00:39:51.208974663 +0100
@@ -1403,4 +1403,20 @@ void ieee80211_wake_queues(struct ieee80
  */
 void ieee80211_scan_completed(struct ieee80211_hw *hw);
 
+/**
+ * ieee80211_iterate_active_interfaces - iterate active interfaces
+ *
+ * This function iterates over the interfaces associated with a given
+ * hardware that are currently active and calls the callback for them.
+ * Must be called under RTNL.
+ *
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iterator: the iterator function to call
+ * @data: first argument of the iterator function
+ */
+void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
+					 void (*iterator)(void *data, u8 *mac,
+					 		  int if_id),
+					 void *data);
+
 #endif /* MAC80211_H */
--- everything.orig/net/mac80211/util.c	2007-11-09 00:35:18.418983343 +0100
+++ everything/net/mac80211/util.c	2007-11-09 01:50:03.408972493 +0100
@@ -22,6 +22,7 @@
 #include <linux/bitmap.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
+#include <net/rtnetlink.h>
 
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
@@ -484,3 +485,35 @@ void ieee80211_wake_queues(struct ieee80
 		ieee80211_wake_queue(hw, i);
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
+
+void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
+					 void (*iterator)(void *data, u8 *mac,
+							  int if_id),
+					 void *data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
+	ASSERT_RTNL();
+
+	/* we hold the RTNL here so can safely walk the list */
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		switch (sdata->type) {
+		case IEEE80211_IF_TYPE_INVALID:
+		case IEEE80211_IF_TYPE_MNTR:
+		case IEEE80211_IF_TYPE_VLAN:
+			continue;
+		case IEEE80211_IF_TYPE_AP:
+		case IEEE80211_IF_TYPE_STA:
+		case IEEE80211_IF_TYPE_IBSS:
+		case IEEE80211_IF_TYPE_WDS:
+			break;
+		}
+		if (sdata->dev == local->mdev)
+			continue;
+		if (netif_running(sdata->dev))
+			iterator(data, sdata->dev->dev_addr,
+				 sdata->dev->ifindex);
+	}
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);


