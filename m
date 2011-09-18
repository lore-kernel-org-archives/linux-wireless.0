Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f170.google.com ([74.125.82.170]:43412 "EHLO
	mail-wy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1IRMKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 08:10:55 -0400
Received: by wyg8 with SMTP id 8so7912352wyg.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 05:10:53 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
Date: Sun, 18 Sep 2011 15:03:14 +0300
Message-Id: <1316347394-21276-1-git-send-email-eliad@wizery.com> (sfid-20110918_141058_424519_6F7A0693)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases the driver might want to change the
default dynamic ps timeout (e.g. coex activity adds
latency to the rx/tx path, which might result in
redundant psm entrance).

Introduce a new ieee80211_set_dyn_ps_timeout() function
to let low-level drivers change the default timeout.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/mac80211.h     |   14 ++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/iface.c       |    1 +
 net/mac80211/main.c        |    3 +++
 net/mac80211/mlme.c        |   31 +++++++++++++++++++++++++++++++
 net/mac80211/pm.c          |    1 +
 6 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5e5029b..0db4ba8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3133,6 +3133,20 @@ void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif);
 void ieee80211_enable_dyn_ps(struct ieee80211_vif *vif);
 
 /**
+ * ieee80211_set_dyn_ps_timeout - set the default dynamic ps timeout
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @timeout: timeout in ms, -1 for default value.
+ *
+ * This function lets the driver set its default dynamic ps timeout.
+ * This timeout will be evaluated only if the user didn't set his own
+ * timeout (explicitly or implicitly, by setting network_latency).
+ * Setting timeout to -1 will cause this timeout to be ignored, and the
+ * default timeout (100ms) will be used.
+ */
+void ieee80211_set_dyn_ps_timeout(struct ieee80211_vif *vif, int timeout);
+
+/**
  * ieee80211_cqm_rssi_notify - inform a configured connection quality monitoring
  *	rssi threshold triggered
  *
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c204cee..d960a16 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -969,6 +969,7 @@ struct ieee80211_local {
 	struct ieee80211_sub_if_data *ps_sdata;
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
+	struct work_struct dynamic_ps_reconfig_work;
 	struct timer_list dynamic_ps_timer;
 	struct notifier_block network_latency_notifier;
 	struct notifier_block ifa_notifier;
@@ -978,6 +979,7 @@ struct ieee80211_local {
 	 * this will override whatever chosen by mac80211 internally.
 	 */
 	int dynamic_ps_forced_timeout;
+	int dynamic_ps_driver_timeout;
 	int dynamic_ps_user_timeout;
 	bool disable_dynamic_ps;
 
@@ -1281,6 +1283,7 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
+void ieee80211_dynamic_ps_reconfig_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
 void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index eaa80a3..cf1ecd6 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -442,6 +442,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_configure_filter(local);
 
+	cancel_work_sync(&local->dynamic_ps_reconfig_work);
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a5809a1..7f9cc77 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -650,6 +650,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 		  ieee80211_dynamic_ps_enable_work);
 	INIT_WORK(&local->dynamic_ps_disable_work,
 		  ieee80211_dynamic_ps_disable_work);
+	INIT_WORK(&local->dynamic_ps_reconfig_work,
+		  ieee80211_dynamic_ps_reconfig_work);
 	setup_timer(&local->dynamic_ps_timer,
 		    ieee80211_dynamic_ps_timer, (unsigned long) local);
 
@@ -905,6 +907,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	local->hw.conf.listen_interval = local->hw.max_listen_interval;
 
 	local->dynamic_ps_forced_timeout = -1;
+	local->dynamic_ps_driver_timeout = -1;
 
 	result = ieee80211_wep_init(local);
 	if (result < 0)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fb2f0f9..4274e94 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -556,6 +556,21 @@ void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(ieee80211_disable_dyn_ps);
 
+void ieee80211_set_dyn_ps_timeout(struct ieee80211_vif *vif, int timeout)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+
+	WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION ||
+		!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS) ||
+		(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS));
+
+	local->dynamic_ps_driver_timeout = timeout;
+	ieee80211_queue_work(&local->hw,
+			     &local->dynamic_ps_reconfig_work);
+}
+EXPORT_SYMBOL(ieee80211_set_dyn_ps_timeout);
+
 /* powersave */
 static void ieee80211_enable_ps(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
@@ -687,6 +702,8 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 			if (latency > (1900 * USEC_PER_MSEC) &&
 			    latency != (2000 * USEC_PER_SEC))
 				timeout = 0;
+			else if (local->dynamic_ps_driver_timeout >= 0)
+				timeout = local->dynamic_ps_driver_timeout;
 			else
 				timeout = 100;
 		}
@@ -814,6 +831,20 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		netif_tx_wake_all_queues(sdata->dev);
 }
 
+void ieee80211_dynamic_ps_reconfig_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local,
+			     dynamic_ps_reconfig_work);
+
+	WARN_ON(!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS) ||
+		(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS));
+
+	mutex_lock(&local->iflist_mtx);
+	ieee80211_recalc_ps(local, -1);
+	mutex_unlock(&local->iflist_mtx);
+}
+
 void ieee80211_dynamic_ps_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 6326d34..afb52a5 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -69,6 +69,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	 * Note that this particular timer doesn't need to be
 	 * restarted at resume.
 	 */
+	cancel_work_sync(&local->dynamic_ps_reconfig_work);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 	del_timer_sync(&local->dynamic_ps_timer);
 
-- 
1.7.6.401.g6a319

