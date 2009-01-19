Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2116 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZASQXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 11:23:19 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 2/3] mac80211: add suspend/resume callbacks
Date: Mon, 19 Jan 2009 11:20:53 -0500
Message-Id: <1232382054-15931-3-git-send-email-me@bobcopeland.com> (sfid-20090119_172327_790254_81BB5C04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces suspend and resume callbacks to mac80211,
allowing mac80211 to quiesce its state (bringing down interfaces,
removing keys, etc) in preparation for suspend.  cfg80211 will call
the suspend hook before the device suspend, and resume hook after
the device resume.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Makefile      |    2 +
 net/mac80211/cfg.c         |   17 +++++++
 net/mac80211/ieee80211_i.h |    4 ++
 net/mac80211/pm.c          |  114 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 137 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/pm.c

diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 5c6fadf..58c94bb 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -38,6 +38,8 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh_plink.o \
 	mesh_hwmp.o
 
+mac80211-$(CONFIG_PM) += pm.o
+
 # objects for PID algorithm
 rc80211_pid-y := rc80211_pid_algo.o
 rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d1ac3ab..3527de2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1256,6 +1256,21 @@ static int ieee80211_set_mgmt_extra_ie(struct wiphy *wiphy,
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static int ieee80211_suspend(struct wiphy *wiphy)
+{
+	return __ieee80211_suspend(wiphy_priv(wiphy));
+}
+
+static int ieee80211_resume(struct wiphy *wiphy)
+{
+	return __ieee80211_resume(wiphy_priv(wiphy));
+}
+#else
+#define ieee80211_suspend NULL
+#define ieee80211_resume NULL
+#endif
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1286,4 +1301,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.set_txq_params = ieee80211_set_txq_params,
 	.set_channel = ieee80211_set_channel,
 	.set_mgmt_extra_ie = ieee80211_set_mgmt_extra_ie,
+	.suspend = ieee80211_suspend,
+	.resume = ieee80211_resume,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5eafd3a..faa2476 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1006,6 +1006,10 @@ void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 				 u16 capab_info, u8 *pwr_constr_elem,
 				 u8 pwr_constr_elem_len);
 
+/* Suspend/resume */
+int __ieee80211_suspend(struct ieee80211_hw *hw);
+int __ieee80211_resume(struct ieee80211_hw *hw);
+
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 extern const unsigned char rfc1042_header[6];
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
new file mode 100644
index 0000000..6d17ed7
--- /dev/null
+++ b/net/mac80211/pm.c
@@ -0,0 +1,114 @@
+#include <net/mac80211.h>
+#include <net/rtnetlink.h>
+
+#include "ieee80211_i.h"
+#include "led.h"
+
+int __ieee80211_suspend(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_init_conf conf;
+	struct sta_info *sta;
+
+	flush_workqueue(local->hw.workqueue);
+
+	/* disable keys */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		ieee80211_disable_keys(sdata);
+
+	/* remove STAs */
+	list_for_each_entry(sta, &local->sta_list, list) {
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
+
+		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
+		    netif_running(sdata->dev)) {
+			conf.vif = &sdata->vif;
+			conf.type = sdata->vif.type;
+			conf.mac_addr = sdata->dev->dev_addr;
+			local->ops->remove_interface(hw, &conf);
+		}
+	}
+
+	/* stop hardware */
+	if (local->open_count) {
+		ieee80211_led_radio(local, false);
+		local->ops->stop(hw);
+	}
+	return 0;
+}
+
+int __ieee80211_resume(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_init_conf conf;
+	struct sta_info *sta;
+	int res;
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
+		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
+		    netif_running(sdata->dev)) {
+			conf.vif = &sdata->vif;
+			conf.type = sdata->vif.type;
+			conf.mac_addr = sdata->dev->dev_addr;
+			res = local->ops->add_interface(hw, &conf);
+		}
+	}
+
+	/* add STAs back */
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
+
+	/* add back keys */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (netif_running(sdata->dev))
+			ieee80211_enable_keys(sdata);
+
+	/* setup RTS threshold */
+	if (local->ops->set_rts_threshold)
+		local->ops->set_rts_threshold(hw, local->rts_threshold);
+
+	/* reconfigure hardware */
+	ieee80211_hw_config(local, ~0);
+
+	netif_addr_lock_bh(local->mdev);
+	ieee80211_configure_filter(local);
+	netif_addr_unlock_bh(local->mdev);
+
+	return 0;
+}
-- 
1.6.0.6


