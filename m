Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2150 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbYKWEmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 23:42:12 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/2] mac80211: add suspend/resume callbacks
Date: Sat, 22 Nov 2008 23:41:25 -0500
Message-Id: <1227415286-30179-2-git-send-email-me@bobcopeland.com> (sfid-20081123_054218_217354_D63E2DF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces suspend and resume callbacks to mac80211, allowing
mac80211 to quiesce its state (bringing down interfaces, removing keys, etc)
in preparation for suspend.  The driver is responsible for calling
ieee80211_notify_mac with the appropriate option from its suspend/resume
hook.
---
 include/net/mac80211.h |   41 +++++++++++++++++
 net/mac80211/Makefile  |    2 +
 net/mac80211/pm.c      |  116 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/pm.c

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6a1d4ea..933f82f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1873,6 +1873,47 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
 					 const u8 *addr);
 
+#ifdef CONFIG_PM
+void __ieee80211_suspend(struct ieee80211_hw *);
+void __ieee80211_resume(struct ieee80211_hw *);
+#endif
+/**
+ * ieee80211_suspend - prepare for platform suspend
+ *
+ * Call this function from the low level driver from the bus suspend
+ * function to prepare for suspend to ram or disk.  The function will 
+ * quiesce active interfaces and save state for resume.
+ *
+ * This function must not be called with any locks held as it may 
+ * call back into the driver.
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ */
+static inline void ieee80211_suspend(struct ieee80211_hw *hw)
+{
+#ifdef CONFIG_PM
+	__ieee80211_suspend(hw);
+#endif
+}
+
+/**
+ * ieee80211_resume - resume operation from sleep
+ *
+ * Call this function from the low level driver from the bus resume
+ * function to resume from ram or disk.  This will reactivate interfaces 
+ * and reprogram the hardware to continue normal operation.
+ *
+ * This function must not be called with any locks held as it may 
+ * call back into the driver.
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ */
+static inline void ieee80211_resume(struct ieee80211_hw *hw)
+{
+#ifdef CONFIG_PM
+	__ieee80211_resume(hw);
+#endif
+}
 
 /* Rate control API */
 
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 31cfd1f..0ecbc93 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -37,6 +37,8 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh_plink.o \
 	mesh_hwmp.o
 
+mac80211-$(CONFIG_PM) += pm.o
+
 # objects for PID algorithm
 rc80211_pid-y := rc80211_pid_algo.o
 rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
new file mode 100644
index 0000000..e3e537f
--- /dev/null
+++ b/net/mac80211/pm.c
@@ -0,0 +1,116 @@
+#include <net/mac80211.h>
+#include <net/rtnetlink.h>
+
+#include "ieee80211_i.h"
+#include "led.h"
+
+void __ieee80211_suspend(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_init_conf conf;
+	struct sta_info *sta;
+
+	printk(KERN_DEBUG "mac80211: suspending\n");
+
+	rtnl_lock();
+
+	flush_workqueue(local->hw.workqueue);
+
+	/* disable aggregation and notify that STAs are going away */
+	list_for_each_entry(sta, &local->sta_list, list) {
+		sdata = sta->sdata;
+		ieee80211_sta_tear_down_BA_sessions(sta->sdata, sta->sta.addr);
+
+		if (local->ops->sta_notify) {
+			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+				sdata = container_of(sdata->bss,
+					     struct ieee80211_sub_if_data,
+					     u.ap);
+
+			local->ops->sta_notify(hw, &sdata->vif, 
+				STA_NOTIFY_REMOVE, &sta->sta);
+		}
+	}
+
+	/* remove all interfaces */
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		ieee80211_disable_keys(sdata);
+
+		conf.vif = &sdata->vif;
+		conf.type = sdata->vif.type;
+		conf.mac_addr = sdata->dev->dev_addr;
+		local->ops->remove_interface(hw, &conf);
+	}
+
+	/* stop hardware */
+	if (local->open_count) {
+		ieee80211_led_radio(local, false);
+		local->ops->stop(hw);
+	}
+
+	rtnl_unlock();
+}
+EXPORT_SYMBOL(__ieee80211_suspend);
+
+void __ieee80211_resume(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_init_conf conf;
+	struct sta_info *sta;
+	int res;
+
+	printk(KERN_DEBUG "mac80211: resuming\n");
+	rtnl_lock();
+
+	/* restart hardware */
+	if (local->open_count) {
+		res = local->ops->start(hw);
+
+		ieee80211_led_radio(local, hw->conf.radio_enabled);
+	}
+
+	/* add interfaces */
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		
+		conf.vif = &sdata->vif;
+		conf.type = sdata->vif.type;
+		conf.mac_addr = sdata->dev->dev_addr;
+		res = local->ops->add_interface(hw, &conf);
+
+		ieee80211_enable_keys(sdata);
+
+	}
+
+	/* notify STAs are back */
+	list_for_each_entry(sta, &local->sta_list, list) {
+
+		if (local->ops->sta_notify) {
+			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+				sdata = container_of(sdata->bss,
+					     struct ieee80211_sub_if_data,
+					     u.ap);
+
+			local->ops->sta_notify(hw, &sdata->vif, 
+				STA_NOTIFY_ADD, &sta->sta);
+		}
+	}
+	rtnl_unlock();
+
+	/* setup RTS and frag thresholds */
+	if (local->ops->set_rts_threshold)
+		local->ops->set_rts_threshold(hw, local->rts_threshold);
+
+	if (local->ops->set_frag_threshold)
+		local->ops->set_frag_threshold(hw, 
+			local->fragmentation_threshold);
+
+	/* reconfigure hardware */
+	ieee80211_hw_config(local, ~0);
+
+	netif_addr_lock_bh(local->mdev);
+	ieee80211_configure_filter(local);
+	netif_addr_unlock_bh(local->mdev);
+}
+EXPORT_SYMBOL(__ieee80211_resume);
-- 
1.5.4.2.182.gb3092


