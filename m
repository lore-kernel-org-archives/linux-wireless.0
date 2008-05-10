Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYEJMJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:09:57 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148254fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:09:56 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 05/16] mac80211: Add RTNL version of ieee80211_iterate_active_interfaces
Date: Sat, 10 May 2008 13:40:49 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101340.49356.IvDoorn@gmail.com> (sfid-20080510_141014_817107_CC11AFF9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit e38bad4766a110b61fa6038f10be16ced8c6cc38
	mac80211: make ieee80211_iterate_active_interfaces not need rtnl
rt2500usb and rt73usb broke down due to attempting register access
in atomic context (which is not possible for USB hardware).

This patch restores ieee80211_iterate_active_interfaces() to use RTNL lock,
and provides the non-RTNL version under a new name:
	ieee80211_iterate_active_interfaces_atomic()

So far only rt2x00 uses ieee80211_iterate_active_interfaces(), and those
drivers require the RTNL version of ieee80211_iterate_active_interfaces().
Since they already call that function directly, this patch will automatically
fix the USB rt2x00 drivers.

v2: Rename ieee80211_iterate_active_interfaces_rtnl

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   25 +++++++++++++++++++++++--
 net/mac80211/util.c    |   37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 75a3460..68d709b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1581,13 +1581,16 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw);
 void ieee80211_scan_completed(struct ieee80211_hw *hw);
 
 /**
- * ieee80211_iterate_active_interfaces - iterate active interfaces
+ * ieee80211_iterate_active_interfaces- iterate active interfaces
  *
  * This function iterates over the interfaces associated with a given
  * hardware that are currently active and calls the callback for them.
+ * This function allows the iterator function to sleep, when the iterator
+ * function is atomic @ieee80211_iterate_active_interfaces_atomic can
+ * be used.
  *
  * @hw: the hardware struct of which the interfaces should be iterated over
- * @iterator: the iterator function to call, cannot sleep
+ * @iterator: the iterator function to call
  * @data: first argument of the iterator function
  */
 void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
@@ -1596,6 +1599,24 @@ void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
 					 void *data);
 
 /**
+ * ieee80211_iterate_active_interfaces_atomic - iterate active interfaces
+ *
+ * This function iterates over the interfaces associated with a given
+ * hardware that are currently active and calls the callback for them.
+ * This function requires the iterator callback function to be atomic,
+ * if that is not desired, use @ieee80211_iterate_active_interfaces instead.
+ *
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iterator: the iterator function to call, cannot sleep
+ * @data: first argument of the iterator function
+ */
+void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
+						void (*iterator)(void *data,
+						    u8 *mac,
+						    struct ieee80211_vif *vif),
+						void *data);
+
+/**
  * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @ra: receiver address of the BA session recipient
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cc9f715..6039df6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -389,6 +389,41 @@ void ieee80211_iterate_active_interfaces(
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
+	rtnl_lock();
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		switch (sdata->vif.type) {
+		case IEEE80211_IF_TYPE_INVALID:
+		case IEEE80211_IF_TYPE_MNTR:
+		case IEEE80211_IF_TYPE_VLAN:
+			continue;
+		case IEEE80211_IF_TYPE_AP:
+		case IEEE80211_IF_TYPE_STA:
+		case IEEE80211_IF_TYPE_IBSS:
+		case IEEE80211_IF_TYPE_WDS:
+		case IEEE80211_IF_TYPE_MESH_POINT:
+			break;
+		}
+		if (sdata->dev == local->mdev)
+			continue;
+		if (netif_running(sdata->dev))
+			iterator(data, sdata->dev->dev_addr,
+				 &sdata->vif);
+	}
+
+	rtnl_unlock();
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
+
+void ieee80211_iterate_active_interfaces_atomic(
+	struct ieee80211_hw *hw,
+	void (*iterator)(void *data, u8 *mac,
+			 struct ieee80211_vif *vif),
+	void *data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
@@ -413,4 +448,4 @@ void ieee80211_iterate_active_interfaces(
 
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
-- 
1.5.5.1

