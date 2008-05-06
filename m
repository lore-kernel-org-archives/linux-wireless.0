Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:36990 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879AbYEFRgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 13:36:05 -0400
Received: by ug-out-1314.google.com with SMTP id h2so392109ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 10:36:03 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH] mac80211: Add RTNL version of ieee80211_iterate_active_interfaces
Date: Tue, 6 May 2008 19:43:31 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805061943.31902.IvDoorn@gmail.com> (sfid-20080506_193525_795524_984D2007)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit e38bad4766a110b61fa6038f10be16ced8c6cc38
	mac80211: make ieee80211_iterate_active_interfaces not need rtnl
rt2500usb and rt73usb broke down due to attempting register access
in atomic context.

This patch adds a ieee80211_iterate_active_interfaces_rtnl()
function that behaves exactly the same as the original
ieee80211_iterate_active_interfaces() function before the above
mentioned patch.

The add_interface, remove_interface() and config_interface()
functions are already under the RTNL lock by mac80211 so simply
calling  ieee80211_iterate_active_interfaces_rtnl() from within
a RTNL protected area would be sufficient to prevent race
conditions.

In rt2x00 only 1 callsite of ieee80211_iterate_active_interfaces()
needs to be changed, since only rt2x00lib_intf_scheduled() performs
hardware access per given interface.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John please queue for 2.6.26, this bug impacts both rt2500usb and rt73usb
and effectively shuts both interfaces down from proper functioning.. :S

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 213adbb..7fdbb84 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -25,6 +25,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/rtnetlink.h>
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
@@ -474,11 +475,15 @@ static void rt2x00lib_intf_scheduled(struct work_struct *work)
 
 	/*
 	 * Iterate over each interface and perform the
-	 * requested configurations.
-	 */
-	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
-					    rt2x00lib_intf_scheduled_iter,
-					    rt2x00dev);
+	 * requested configurations, make sure to use
+	 * the _rtnl version since the regular version
+	 * requires atomic context.
+	 */
+	rtnl_lock();
+	ieee80211_iterate_active_interfaces_rtnl(rt2x00dev->hw,
+						 rt2x00lib_intf_scheduled_iter,
+						 rt2x00dev);
+	rtnl_unlock();
 }
 
 /*
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7e75516..741a3d6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1601,6 +1601,24 @@ void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
 					 void *data);
 
 /**
+ * ieee80211_iterate_active_interfaces_rtnl - iterate active interfaces
+ *
+ * This function iterates over the interfaces associated with a given
+ * hardware that are currently active and calls the callback for them.
+ * This function allows the iterator function to sleep, the caller is
+ * responsible for proper locking mechanisms to prevent concurrency.
+ *
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iterator: the iterator function to call
+ * @data: first argument of the iterator function
+ */
+void ieee80211_iterate_active_interfaces_rtnl(struct ieee80211_hw *hw,
+					      void (*iterator)(void *data,
+						u8 *mac,
+						struct ieee80211_vif *vif),
+					      void *data);
+
+/**
  * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @ra: receiver address of the BA session recipient
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 74c48ef..6980590 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -426,3 +426,36 @@ void ieee80211_iterate_active_interfaces(
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
+
+void ieee80211_iterate_active_interfaces_rtnl(
+	struct ieee80211_hw *hw,
+	void (*iterator)(void *data, u8 *mac,
+			 struct ieee80211_vif *vif),
+	void *data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
+	ASSERT_RTNL();
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
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_rtnl);
