Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2541 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYLIPnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 10:43:12 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
Subject: Re: [PATCH 1/2] mac80211: add suspend/resume callbacks
Date: Tue, 9 Dec 2008 10:40:49 -0500
Message-Id: <20081209152908.M73523@bobcopeland.com> (sfid-20081209_164316_957560_02961935)
In-Reply-To: <1227431953.3599.37.camel@johannes.berg>
References: <1227415286-30179-2-git-send-email-me@bobcopeland.com> (sfid-20081123_054218_217354_D63E2DF4) <1227431953.3599.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 23 Nov 2008 10:19:13 +0100, Johannes Berg wrote
> I think this should run through interfaces twice, in the first run to
> remove keys, then remove stas and then in the second run remove the
> interfaces, because otherwise you may be having keys left when the sta
> for which the key was has been removed.

Is this what you had in mind? (now on top of your cfg80211 patch, btw
it called ->suspend() in the resume hook)

I tested this with ath5k, it works in the sense that device suspends and
resumes without any hangs or errors.

However, netif_running(sdata->dev) seems to randomly be false for wlan0 on
the resume side so the interface doesn't always come up.  I haven't had
time to track that down but it's not consistent.

>From ec2f9fb1db1f98caf28e90f9838a42f0508a3a80 Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 27 Oct 2008 09:17:46 -0400
Subject: [PATCH] mac80211: add suspend/resume callbacks

This patch introduces suspend and resume callbacks to mac80211,
allowing mac80211 to quiesce its state (bringing down interfaces,
removing keys, etc) in preparation for suspend.  cfg80211 will call
the suspend hook before the device suspend, and resume hook after
the device resume.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/Makefile |    2 +
 net/mac80211/cfg.c    |   18 +++++++
 net/mac80211/pm.c     |  125 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/pm.h     |    9 ++++
 4 files changed, 154 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/pm.c
 create mode 100644 net/mac80211/pm.h

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
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7a7a6c1..5607045 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -16,6 +16,7 @@
 #include "cfg.h"
 #include "rate.h"
 #include "mesh.h"
+#include "pm.h"
 
 static bool nl80211_type_check(enum nl80211_iftype type)
 {
@@ -1107,6 +1108,21 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
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
@@ -1135,4 +1151,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
 	.set_channel = ieee80211_set_channel,
+	.suspend = ieee80211_suspend,
+	.resume = ieee80211_resume,
 };
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
new file mode 100644
index 0000000..2fc96f9
--- /dev/null
+++ b/net/mac80211/pm.c
@@ -0,0 +1,125 @@
+#include <net/mac80211.h>
+#include <net/rtnetlink.h>
+
+#include "ieee80211_i.h"
+#include "pm.h"
+#include "led.h"
+
+int __ieee80211_suspend(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_init_conf conf;
+	struct sta_info *sta;
+
+	printk(KERN_DEBUG "mac80211: suspending\n");
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
+		/* disable aggregation */
+		ieee80211_sta_tear_down_BA_sessions(sdata, sta->sta.addr);
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
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type == NL80211_IFTYPE_MONITOR &&
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
+	printk(KERN_DEBUG "mac80211: resuming\n");
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
+	return 0;
+}
diff --git a/net/mac80211/pm.h b/net/mac80211/pm.h
new file mode 100644
index 0000000..3d5ff02
--- /dev/null
+++ b/net/mac80211/pm.h
@@ -0,0 +1,9 @@
+#ifndef __MAC80211_PM_H
+#define __MAC80211_PM_H
+
+#ifdef CONFIG_PM
+int __ieee80211_suspend(struct ieee80211_hw *hw);
+int __ieee80211_resume(struct ieee80211_hw *hw);
+#endif
+
+#endif
-- 
1.6.0.4

-- 
Bob Copeland %% www.bobcopeland.com


