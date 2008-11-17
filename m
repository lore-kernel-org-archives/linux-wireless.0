Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYKQKAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 05:00:09 -0500
Subject: [RFC] mac80211: remove ieee80211_notify_mac
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 10:59:59 +0100
Message-Id: <1226915999.3599.33.camel@johannes.berg> (sfid-20081117_110015_263674_C03EEA82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before ieee80211_notify_mac() was added, it was presented with the
use case of using it to tell mac80211 that the association may
have been lost because the firmware crashed/reset.

Since then, it has also been used by iwlwifi to (slightly) speed
up re-association after resume, a workaround around the fact that
mac80211 has no suspend/resume handling yet. It is also not used
by any other drivers, so clearly it cannot be necessary for "good
enough" suspend/resume.

Unfortunately, the callback suffers from a severe problem: It only
works for station mode. If suspend/resume happens while in IBSS or
any other mode (but station), then the callback is pointless.

Recently, it has created a number of locking issues, first because
it required rtnl locking rather than RCU due to calling sleeping
functions within the critical section, and now because it's called
by iwlwifi from the mac80211 workqueue that may not use the rtnl
because it is flushed under rtnl.
(cf. http://bugzilla.kernel.org/show_bug.cgi?id=12046)

I think, therefore, that we should take a step back, remove it
entirely for now and add the small feature it provided properly.
For suspend and resume we will need to introduce new hooks, and for
the case where the firmware was reset the driver will probably
simply just pretend it has done a suspend/resume cycle to get
mac80211 to reprogram the hardware completely, not just try to
connect to the current AP again in station mode. When doing so, we
will need to take into account locking issues and possibly defer
to schedule_work from within mac80211 for the resume operation,
while the suspend operation must be done directly.

Proper suspend/resume should also not necessarily try to reconnect
to the current AP, the time spent in suspend may have been short
enough to not be disconnected from the AP, mac80211 will detect
that the AP went out of range quickly if it did, and if the
association is lost then the AP will disassoc as soon as a data
frame is sent. We might also take into account WWOL then, and
have mac80211 program the hardware into such a mode where it is
available and requested.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 --
 include/net/mac80211.h                      |   20 --------------------
 net/mac80211/mlme.c                         |   22 ----------------------
 4 files changed, 46 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-17 03:16:07.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-11-17 03:16:55.000000000 +0100
@@ -2192,7 +2192,6 @@ static void iwl_bg_alive_start(struct wo
 	mutex_lock(&priv->mutex);
 	iwl_alive_start(priv);
 	mutex_unlock(&priv->mutex);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl_bg_rf_kill(struct work_struct *work)
@@ -2248,7 +2247,6 @@ static void iwl_bg_set_monitor(struct wo
 	}
 
 	mutex_unlock(&priv->mutex);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl_bg_run_time_calib_work(struct work_struct *work)
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-11-17 03:16:07.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-11-17 03:16:18.000000000 +0100
@@ -5972,7 +5972,6 @@ static void iwl3945_bg_alive_start(struc
 	mutex_lock(&priv->mutex);
 	iwl3945_alive_start(priv);
 	mutex_unlock(&priv->mutex);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl3945_bg_rf_kill(struct work_struct *work)
@@ -6023,7 +6022,6 @@ static void iwl3945_bg_set_monitor(struc
 			IWL_ERROR("iwl3945_set_mode() failed\n");
 
 	mutex_unlock(&priv->mutex);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
--- everything.orig/include/net/mac80211.h	2008-11-17 03:15:20.000000000 +0100
+++ everything/include/net/mac80211.h	2008-11-17 03:15:44.000000000 +0100
@@ -74,14 +74,6 @@
  */
 
 /**
- * enum ieee80211_notification_type - Low level driver notification
- * @IEEE80211_NOTIFY_RE_ASSOC: start the re-association sequence
- */
-enum ieee80211_notification_types {
-	IEEE80211_NOTIFY_RE_ASSOC,
-};
-
-/**
  * enum ieee80211_max_queues - maximum number of queues
  *
  * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
@@ -1853,18 +1845,6 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
 				     u16 tid);
 
 /**
- * ieee80211_notify_mac - low level driver notification
- * @hw: pointer as obtained from ieee80211_alloc_hw().
- * @notif_type: enum ieee80211_notification_types
- *
- * This function must be called by low level driver to inform mac80211 of
- * low level driver status change or force mac80211 to re-assoc for low
- * level driver internal error that require re-assoc.
- */
-void ieee80211_notify_mac(struct ieee80211_hw *hw,
-			  enum ieee80211_notification_types  notif_type);
-
-/**
  * ieee80211_find_sta - find a station
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
--- everything.orig/net/mac80211/mlme.c	2008-11-17 03:15:56.000000000 +0100
+++ everything/net/mac80211/mlme.c	2008-11-17 03:16:00.000000000 +0100
@@ -2586,25 +2586,3 @@ void ieee80211_mlme_notify_scan_complete
 		ieee80211_restart_sta_timer(sdata);
 	rcu_read_unlock();
 }
-
-/* driver notification call */
-void ieee80211_notify_mac(struct ieee80211_hw *hw,
-			  enum ieee80211_notification_types  notif_type)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
-
-	switch (notif_type) {
-	case IEEE80211_NOTIFY_RE_ASSOC:
-		rtnl_lock();
-		list_for_each_entry(sdata, &local->interfaces, list) {
-			if (sdata->vif.type != NL80211_IFTYPE_STATION)
-				continue;
-
-			ieee80211_sta_req_auth(sdata, &sdata->u.sta);
-		}
-		rtnl_unlock();
-		break;
-	}
-}
-EXPORT_SYMBOL(ieee80211_notify_mac);


