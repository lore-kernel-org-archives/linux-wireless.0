Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61675 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab1FZJHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 05:07:01 -0400
Received: by wyg8 with SMTP id 8so563347wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jun 2011 02:07:00 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Vivek Natarajan <vivek.natraj@gmail.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: dynamic PS - don't enter PS when TX frames are pending
Date: Sun, 26 Jun 2011 12:06:54 +0300
Message-Id: <1309079214-30919-1-git-send-email-arik@wizery.com> (sfid-20110626_110957_125928_F6301E9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the tx_frames_pending() driver callback to determine if Tx frames are
pending for its internal queues. If so postpone the dynamic PS timeout
to avoid interrupting Tx traffic.

The commit e8306f989483e4b97a8b37dd268de6c8c6f35e75 enabled this
behavior for drivers with IEEE80211_HW_PS_NULLFUNC_STACK. We enable this
for all drivers supporting dynamic PS.

This patch helps improve performance in noisy environments.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->2: Reverted Vivek's code for the HW_PS_NULLFUNC case to its original
state. Fixed the code so ieee80211_disable_dyn_ps() functions correctly
when HW_PS_NULLFUNC is not used.

net/mac80211/mlme.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4f6b267..ac1f6ce 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -760,23 +760,34 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	if (local->hw.conf.flags & IEEE80211_CONF_PS)
 		return;
 
-	/*
-	 * transmission can be stopped by others which leads to
-	 * dynamic_ps_timer expiry. Postpond the ps timer if it
-	 * is not the actual idle state.
-	 */
-	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	for (q = 0; q < local->hw.queues; q++) {
-		if (local->queue_stop_reasons[q]) {
-			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
-					       flags);
+	if (!local->disable_dynamic_ps &&
+	    local->hw.conf.dynamic_ps_timeout > 0) {
+		/* don't enter PS if TX frames are pending */
+		if (drv_tx_frames_pending(local)) {
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(
 				  local->hw.conf.dynamic_ps_timeout));
 			return;
 		}
+
+		/*
+		 * transmission can be stopped by others which leads to
+		 * dynamic_ps_timer expiry. Postpone the ps timer if it
+		 * is not the actual idle state.
+		 */
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		for (q = 0; q < local->hw.queues; q++) {
+			if (local->queue_stop_reasons[q]) {
+				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
+						       flags);
+				mod_timer(&local->dynamic_ps_timer, jiffies +
+					  msecs_to_jiffies(
+					  local->hw.conf.dynamic_ps_timeout));
+				return;
+			}
+		}
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 	}
-	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
@@ -801,7 +812,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
-	netif_tx_wake_all_queues(sdata->dev);
+	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+		netif_tx_wake_all_queues(sdata->dev);
 }
 
 void ieee80211_dynamic_ps_timer(unsigned long data)
-- 
1.7.4.1

