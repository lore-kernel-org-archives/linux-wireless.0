Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62764 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1ECLeI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 07:34:08 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 04:33:40 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] mac80211: Postpond ps timer if tx is stopped by others
Date: Tue, 3 May 2011 17:03:59 +0530
Message-ID: <1304422439-3278-1-git-send-email-rmanoharan@atheros.com> (sfid-20110503_133412_531344_35170C9F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever the driver's queue depth reaches the max, the queues are
stopped by the driver till the driver can accept the frames.
At the mean time dynamic_ps_timer can be expired due to not
receiving packet from upper layer which could restart the transmission
at the end of ps work. Due to the mismatch with driver state,
mac80211 is unneccesarity buffering all the frames till the driver
wakes up the queue.

Check whether there is no transmit or the tx queues were stopped by some
reasons. If any of the queue was stopped, the postpond ps timer and
do not restart netif_tx.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/mlme.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8d752b4..4f6b267 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -750,6 +750,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 			     dynamic_ps_enable_work);
 	struct ieee80211_sub_if_data *sdata = local->ps_sdata;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	unsigned long flags;
+	int q;
 
 	/* can only happen when PS was just disabled anyway */
 	if (!sdata)
@@ -758,6 +760,24 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	if (local->hw.conf.flags & IEEE80211_CONF_PS)
 		return;
 
+	/*
+	 * transmission can be stopped by others which leads to
+	 * dynamic_ps_timer expiry. Postpond the ps timer if it
+	 * is not the actual idle state.
+	 */
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+	for (q = 0; q < local->hw.queues; q++) {
+		if (local->queue_stop_reasons[q]) {
+			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
+					       flags);
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+				  msecs_to_jiffies(
+				  local->hw.conf.dynamic_ps_timeout));
+			return;
+		}
+	}
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
 		netif_tx_stop_all_queues(sdata->dev);
-- 
1.7.5

