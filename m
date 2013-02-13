Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933856Ab3BML03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 06:26:29 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/2] mac80211: stop queues temporarily for flushing
Date: Wed, 13 Feb 2013 12:26:23 +0100
Message-Id: <1360754783-13549-2-git-send-email-johannes@sipsolutions.net> (sfid-20130213_122637_405273_454E1DCE)
In-Reply-To: <1360754783-13549-1-git-send-email-johannes@sipsolutions.net>
References: <1360754783-13549-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sometimes queues are flushed in the middle of
operation, which can lead to driver issues.
Stop queues temporarily, while flushing, to
avoid transmitting new packets while they are
being flushed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  2 ++
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/main.c        |  4 ++--
 net/mac80211/mlme.c        |  4 ++++
 net/mac80211/offchannel.c  |  4 ++--
 net/mac80211/pm.c          |  4 +++-
 net/mac80211/tx.c          |  1 +
 net/mac80211/util.c        | 23 ++++++++++++++++-------
 8 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7c93ee7..443f4bd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -93,9 +93,11 @@ struct device;
  * enum ieee80211_max_queues - maximum number of queues
  *
  * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
+ * @IEEE80211_MAX_QUEUE_MAP: bitmap with maximum queues set
  */
 enum ieee80211_max_queues {
 	IEEE80211_MAX_QUEUES =		16,
+	IEEE80211_MAX_QUEUE_MAP =	BIT(IEEE80211_MAX_QUEUES) - 1,
 };
 
 #define IEEE80211_INVAL_HW_QUEUE	0xff
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5f2c7c9..f49d6c2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -810,6 +810,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
+	IEEE80211_QUEUE_STOP_REASON_FLUSH,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -1523,8 +1524,10 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr, bool ack);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
+				     unsigned long queues,
 				     enum queue_stop_reason reason);
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
+				     unsigned long queues,
 				     enum queue_stop_reason reason);
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 26531a3..1fa4e79 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -295,8 +295,8 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 		   "Hardware restart was requested\n");
 
 	/* use this reason, ieee80211_reconfig will unblock it */
-	ieee80211_stop_queues_by_reason(hw,
-		IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+	ieee80211_stop_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
 	/*
 	 * Stop all Rx during the reconfig. We don't want state changes
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 98591af..d75c650 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1004,6 +1004,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 
 	/* XXX: wait for a beacon first? */
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
  out:
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
@@ -1109,6 +1110,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	if (mode)
 		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
 
 	if (sdata->local->ops->channel_switch) {
@@ -1375,6 +1377,7 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 	}
 
 	ieee80211_wake_queues_by_reason(&local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_PS);
 }
 
@@ -2097,6 +2100,7 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 			     u.mgd.csa_connection_drop_work);
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 	__ieee80211_disconnect(sdata);
 }
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index a3ed44a..4f67a30 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -118,7 +118,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 	 * Stop queues and transmit all frames queued by the driver
 	 * before sending nullfunc to enable powersave at the AP.
 	 */
-	ieee80211_stop_queues_by_reason(&local->hw,
+	ieee80211_stop_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
 	ieee80211_flush_queues(local, NULL);
 
@@ -181,7 +181,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local)
 	}
 	mutex_unlock(&local->iflist_mtx);
 
-	ieee80211_wake_queues_by_reason(&local->hw,
+	ieee80211_wake_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
 }
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index d51e1bd..012698d 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -49,7 +49,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	}
 
 	ieee80211_stop_queues_by_reason(hw,
-			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+					IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
 	/* flush out all packets */
 	synchronize_net();
@@ -87,6 +88,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 				mutex_unlock(&local->sta_mtx);
 			}
 			ieee80211_wake_queues_by_reason(hw,
+					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 			return err;
 		} else if (err > 0) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f476aa6..eef720d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -233,6 +233,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		ieee80211_stop_queues_by_reason(&local->hw,
+						IEEE80211_MAX_QUEUE_MAP,
 						IEEE80211_QUEUE_STOP_REASON_PS);
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 		ieee80211_queue_work(&local->hw,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8c7fdc9..f931a1a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -453,7 +453,8 @@ void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
 }
 
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
-				    enum queue_stop_reason reason)
+				     unsigned long queues,
+				     enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
@@ -461,7 +462,7 @@ void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
-	for (i = 0; i < hw->queues; i++)
+	for_each_set_bit(i, &queues, hw->queues)
 		__ieee80211_stop_queue(hw, i, reason);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
@@ -469,7 +470,7 @@ void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 
 void ieee80211_stop_queues(struct ieee80211_hw *hw)
 {
-	ieee80211_stop_queues_by_reason(hw,
+	ieee80211_stop_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
@@ -491,6 +492,7 @@ int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 EXPORT_SYMBOL(ieee80211_queue_stopped);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
+				     unsigned long queues,
 				     enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -499,7 +501,7 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
-	for (i = 0; i < hw->queues; i++)
+	for_each_set_bit(i, &queues, hw->queues)
 		__ieee80211_wake_queue(hw, i, reason);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
@@ -507,7 +509,8 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 
 void ieee80211_wake_queues(struct ieee80211_hw *hw)
 {
-	ieee80211_wake_queues_by_reason(hw, IEEE80211_QUEUE_STOP_REASON_DRIVER);
+	ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_DRIVER);
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
@@ -530,7 +533,13 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 		queues = BIT(local->hw.queues) - 1;
 	}
 
+	ieee80211_stop_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_FLUSH);
+
 	drv_flush(local, queues, false);
+
+	ieee80211_wake_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_FLUSH);
 }
 
 void ieee80211_iterate_active_interfaces(
@@ -1688,8 +1697,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_unlock(&local->sta_mtx);
 	}
 
-	ieee80211_wake_queues_by_reason(hw,
-			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
+	ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
+					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
 	/*
 	 * If this is for hw restart things are still running.
-- 
1.8.0

