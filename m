Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46466 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab1CAUmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:42:20 -0500
Received: by wyg36 with SMTP id 36so5094388wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:42:19 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 2/9] mac80211: add WoW param to suspend/resume functions
Date: Tue,  1 Mar 2011 22:36:37 +0200
Message-Id: <1299011804-13899-3-git-send-email-eliad@wizery.com>
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon suspend/resume cfg80211 passes additional WoW param,
which contains the enabled Wake-On-Wireless triggers.

Add this param to the related functions (ieee80211_suspend,
ieee80211_resume, ieee80211_reconfig, ieee80211_stop_driver),
and pass NULL when calling these functions by ourselves
(e.g. on restart work)

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/cfg.c         |    8 ++++----
 net/mac80211/debugfs.c     |    4 ++--
 net/mac80211/ieee80211_i.h |   20 +++++++++++++-------
 net/mac80211/iface.c       |    2 +-
 net/mac80211/main.c        |    2 +-
 net/mac80211/pm.c          |    5 +++--
 net/mac80211/util.c        |    6 ++++--
 7 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 140503d..d3476ad 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1258,14 +1258,14 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 }
 
 #ifdef CONFIG_PM
-static int ieee80211_suspend(struct wiphy *wiphy)
+static int ieee80211_suspend(struct wiphy *wiphy, struct cfg80211_wow *wow)
 {
-	return __ieee80211_suspend(wiphy_priv(wiphy));
+	return __ieee80211_suspend(wiphy_priv(wiphy), wow);
 }
 
-static int ieee80211_resume(struct wiphy *wiphy)
+static int ieee80211_resume(struct wiphy *wiphy, struct cfg80211_wow *wow)
 {
-	return __ieee80211_resume(wiphy_priv(wiphy));
+	return __ieee80211_resume(wiphy_priv(wiphy), wow);
 }
 #else
 #define ieee80211_suspend NULL
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 51f0d78..bf0dd8c 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -130,8 +130,8 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 	struct ieee80211_local *local = file->private_data;
 
 	rtnl_lock();
-	__ieee80211_suspend(&local->hw);
-	__ieee80211_resume(&local->hw);
+	__ieee80211_suspend(&local->hw, NULL);
+	__ieee80211_resume(&local->hw, NULL);
 	rtnl_unlock();
 
 	return count;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0a570a1..aeced4a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1241,13 +1241,17 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       size_t len);
 
 /* Suspend/resume and hw reconfiguration */
-int ieee80211_reconfig(struct ieee80211_local *local);
-void ieee80211_stop_device(struct ieee80211_local *local);
+int ieee80211_reconfig(struct ieee80211_local *local,
+		       struct cfg80211_wow *wow);
+void ieee80211_stop_device(struct ieee80211_local *local,
+			   struct cfg80211_wow *wow);
 
 #ifdef CONFIG_PM
-int __ieee80211_suspend(struct ieee80211_hw *hw);
+int __ieee80211_suspend(struct ieee80211_hw *hw,
+			struct cfg80211_wow *wow);
 
-static inline int __ieee80211_resume(struct ieee80211_hw *hw)
+static inline int __ieee80211_resume(struct ieee80211_hw *hw,
+				     struct cfg80211_wow *wow)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
@@ -1255,15 +1259,17 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 		"%s: resume with hardware scan still in progress\n",
 		wiphy_name(hw->wiphy));
 
-	return ieee80211_reconfig(hw_to_local(hw));
+	return ieee80211_reconfig(hw_to_local(hw), wow);
 }
 #else
-static inline int __ieee80211_suspend(struct ieee80211_hw *hw)
+static inline int __ieee80211_suspend(struct ieee80211_hw *hw,
+				      struct cfg80211_wow *wow)
 {
 	return 0;
 }
 
-static inline int __ieee80211_resume(struct ieee80211_hw *hw)
+static inline int __ieee80211_resume(struct ieee80211_hw *hw,
+				     struct cfg80211_wow *wow)
 {
 	return 0;
 }
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5a4e19b..a0e3779 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -537,7 +537,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		if (local->ops->napi_poll)
 			napi_disable(&local->napi);
 		ieee80211_clear_tx_pending(local);
-		ieee80211_stop_device(local);
+		ieee80211_stop_device(local, NULL);
 
 		/* no reconfiguring after stop! */
 		hw_reconf_flags = 0;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2543e48..7c597bb 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -370,7 +370,7 @@ static void ieee80211_restart_work(struct work_struct *work)
 
 	rtnl_lock();
 	ieee80211_scan_cancel(local);
-	ieee80211_reconfig(local);
+	ieee80211_reconfig(local, NULL);
 	rtnl_unlock();
 }
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index e373551..6d135ea 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -6,7 +6,8 @@
 #include "driver-ops.h"
 #include "led.h"
 
-int __ieee80211_suspend(struct ieee80211_hw *hw)
+int __ieee80211_suspend(struct ieee80211_hw *hw,
+			struct cfg80211_wow *wow)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -96,7 +97,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 
 	/* stop hardware - this must stop RX */
 	if (local->open_count)
-		ieee80211_stop_device(local);
+		ieee80211_stop_device(local, wow);
 
 	local->suspended = true;
 	/* need suspended to be visible before quiescing is false */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 556647a..2058965 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1107,7 +1107,8 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 	return supp_rates;
 }
 
-void ieee80211_stop_device(struct ieee80211_local *local)
+void ieee80211_stop_device(struct ieee80211_local *local,
+			   struct cfg80211_wow *wow)
 {
 	ieee80211_led_radio(local, false);
 	ieee80211_mod_tpt_led_trig(local, 0, IEEE80211_TPT_LEDTRIG_FL_RADIO);
@@ -1118,7 +1119,8 @@ void ieee80211_stop_device(struct ieee80211_local *local)
 	drv_stop(local);
 }
 
-int ieee80211_reconfig(struct ieee80211_local *local)
+int ieee80211_reconfig(struct ieee80211_local *local,
+		       struct cfg80211_wow *wow)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sub_if_data *sdata;
-- 
1.7.0.4

