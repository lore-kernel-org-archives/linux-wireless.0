Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2021 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYLODun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2008 22:50:43 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mabbaswireless@gmail.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v2 2/3] mac80211: add suspend/resume callbacks
Date: Sun, 14 Dec 2008 22:50:38 -0500
Message-Id: <1229313039-5544-3-git-send-email-me@bobcopeland.com> (sfid-20081215_045052_416895_5F511632)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces suspend and resume callbacks to mac80211,
allowing mac80211 to quiesce its state (bringing down interfaces,
removing keys, etc) in preparation for suspend.  cfg80211 will call
the suspend hook before the device suspend, and resume hook after
the device resume.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/Makefile      |    2 +
 net/mac80211/cfg.c         |   17 +++++++
 net/mac80211/ieee80211_i.h |    4 ++
 net/mac80211/pm.c          |  114 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 137 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/pm.c

diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 7d4971a..720787c 100644
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
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9d4e4d8..513b033 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1141,6 +1141,21 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
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
@@ -1169,4 +1184,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
 	.set_channel = ieee80211_set_channel,
+	.suspend = ieee80211_suspend,
+	.resume = ieee80211_resume,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a7dabae..3fc12d6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -952,6 +952,10 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len);
 
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
1.6.0.4


