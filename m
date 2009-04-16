Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZDPLWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 07:22:00 -0400
Message-Id: <20090416111927.736903948@sipsolutions.net> (sfid-20090416_132206_997471_6B98CDF2)
References: <20090416111723.904720021@sipsolutions.net>
Date: Thu, 16 Apr 2009 13:17:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mac80211: disable powersave if pm_qos asks for low
 latency
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an application asks for a latency lower than the beacon interval
there's nothing we can do -- we need to stay awake and not have the
AP buffer frames for us. Add code to automatically calculate this
constraint in mac80211 so drivers need not concern themselves with it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: rebased

 include/linux/ieee80211.h  |    9 +++++++++
 net/mac80211/ieee80211_i.h |    5 ++++-
 net/mac80211/iface.c       |    4 ++--
 net/mac80211/main.c        |   31 ++++++++++++++++++++++++-------
 net/mac80211/mlme.c        |   36 ++++++++++++++++++++++++++++++++----
 net/mac80211/wext.c        |    2 +-
 6 files changed, 72 insertions(+), 15 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-16 02:18:22.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-16 02:18:23.000000000 +0200
@@ -17,6 +17,7 @@
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/pm_qos_params.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
 
@@ -515,7 +516,7 @@ static void ieee80211_change_ps(struct i
 }
 
 /* need to hold RTNL or interface lock */
-void ieee80211_recalc_ps(struct ieee80211_local *local)
+void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 {
 	struct ieee80211_sub_if_data *sdata, *found = NULL;
 	int count = 0;
@@ -534,10 +535,22 @@ void ieee80211_recalc_ps(struct ieee8021
 		count++;
 	}
 
-	if (count == 1 && found->u.mgd.powersave)
-		local->ps_sdata = found;
-	else
+	if (count == 1 && found->u.mgd.powersave) {
+		s32 beaconint_us;
+
+		if (latency < 0)
+			latency = pm_qos_requirement(PM_QOS_NETWORK_LATENCY);
+
+		beaconint_us = ieee80211_tu_to_usec(
+					found->vif.bss_conf.beacon_int);
+
+		if (beaconint_us > latency)
+			local->ps_sdata = NULL;
+		else
+			local->ps_sdata = found;
+	} else {
 		local->ps_sdata = NULL;
+	}
 
 	ieee80211_change_ps(local);
 }
@@ -2313,3 +2326,18 @@ void ieee80211_mlme_notify_scan_complete
 		ieee80211_restart_sta_timer(sdata);
 	rcu_read_unlock();
 }
+
+int ieee80211_max_network_latency(struct notifier_block *nb,
+				  unsigned long data, void *dummy)
+{
+	s32 latency_usec = (s32) data;
+	struct ieee80211_local *local =
+		container_of(nb, struct ieee80211_local,
+			     network_latency_notifier);
+
+	mutex_lock(&local->iflist_mtx);
+	ieee80211_recalc_ps(local, latency_usec);
+	mutex_unlock(&local->iflist_mtx);
+
+	return 0;
+}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-16 02:18:22.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-16 02:18:23.000000000 +0200
@@ -750,6 +750,7 @@ struct ieee80211_local {
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
 	struct timer_list dynamic_ps_timer;
+	struct notifier_block network_latency_notifier;
 
 	int user_power_level; /* in dBm */
 	int power_constr_level; /* in dBm */
@@ -938,7 +939,9 @@ int ieee80211_sta_deauthenticate(struct 
 int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
-void ieee80211_recalc_ps(struct ieee80211_local *local);
+void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
+int ieee80211_max_network_latency(struct notifier_block *nb,
+				  unsigned long data, void *dummy);
 
 /* IBSS code */
 int ieee80211_ibss_commit(struct ieee80211_sub_if_data *sdata);
--- wireless-testing.orig/net/mac80211/main.c	2009-04-16 02:15:54.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-16 02:18:23.000000000 +0200
@@ -21,6 +21,7 @@
 #include <linux/wireless.h>
 #include <linux/rtnetlink.h>
 #include <linux/bitmap.h>
+#include <linux/pm_qos_params.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
 
@@ -1038,25 +1039,38 @@ int ieee80211_register_hw(struct ieee802
 		}
 	}
 
+	local->network_latency_notifier.notifier_call =
+		ieee80211_max_network_latency;
+	result = pm_qos_add_notifier(PM_QOS_NETWORK_LATENCY,
+				     &local->network_latency_notifier);
+
+	if (result) {
+		rtnl_lock();
+		goto fail_pm_qos;
+	}
+
 	return 0;
 
-fail_wep:
+ fail_pm_qos:
+	ieee80211_led_exit(local);
+	ieee80211_remove_interfaces(local);
+ fail_wep:
 	rate_control_deinitialize(local);
-fail_rate:
+ fail_rate:
 	unregister_netdevice(local->mdev);
 	local->mdev = NULL;
-fail_dev:
+ fail_dev:
 	rtnl_unlock();
 	sta_info_stop(local);
-fail_sta_info:
+ fail_sta_info:
 	debugfs_hw_del(local);
 	destroy_workqueue(local->hw.workqueue);
-fail_workqueue:
+ fail_workqueue:
 	if (local->mdev)
 		free_netdev(local->mdev);
-fail_mdev_alloc:
+ fail_mdev_alloc:
 	wiphy_unregister(local->hw.wiphy);
-fail_wiphy_register:
+ fail_wiphy_register:
 	kfree(local->int_scan_req.channels);
 	return result;
 }
@@ -1069,6 +1083,9 @@ void ieee80211_unregister_hw(struct ieee
 	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
 
+	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
+			       &local->network_latency_notifier);
+
 	rtnl_lock();
 
 	/*
--- wireless-testing.orig/net/mac80211/iface.c	2009-04-16 02:18:22.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-04-16 02:18:23.000000000 +0200
@@ -317,7 +317,7 @@ static int ieee80211_open(struct net_dev
 		ieee80211_set_wmm_default(sdata);
 	}
 
-	ieee80211_recalc_ps(local);
+	ieee80211_recalc_ps(local, -1);
 
 	/*
 	 * ieee80211_sta_work is disabled while network interface
@@ -574,7 +574,7 @@ static int ieee80211_stop(struct net_dev
 		hw_reconf_flags = 0;
 	}
 
-	ieee80211_recalc_ps(local);
+	ieee80211_recalc_ps(local, -1);
 
 	/* do after stop to avoid reconfiguring when we stop anyway */
 	if (hw_reconf_flags)
--- wireless-testing.orig/net/mac80211/wext.c	2009-04-16 02:18:22.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-04-16 02:18:23.000000000 +0200
@@ -789,7 +789,7 @@ static int ieee80211_ioctl_siwpower(stru
 		ieee80211_hw_config(local,
 				    IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT);
 
-	ieee80211_recalc_ps(local);
+	ieee80211_recalc_ps(local, -1);
 
 	return 0;
 }
--- wireless-testing.orig/include/linux/ieee80211.h	2009-04-16 02:15:54.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2009-04-16 02:18:23.000000000 +0200
@@ -1383,4 +1383,13 @@ static inline int ieee80211_freq_to_ofdm
 		return -1;
 }
 
+/**
+ * ieee80211_tu_to_usec - convert time units (TU) to microseconds
+ * @tu: the TUs
+ */
+static inline unsigned long ieee80211_tu_to_usec(unsigned long tu)
+{
+	return 1024 * tu;
+}
+
 #endif /* LINUX_IEEE80211_H */

-- 

