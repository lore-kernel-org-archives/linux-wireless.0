Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33913 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1FRTcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 15:32:19 -0400
Received: by wyb38 with SMTP id 38so925494wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2011 12:32:18 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [RFC] mac80211: dynamic PS - don't enter PS when TX frames are pending
Date: Sat, 18 Jun 2011 22:32:13 +0300
Message-Id: <1308425533-20854-1-git-send-email-arik@wizery.com> (sfid-20110618_213228_300208_5ED88178)
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
 net/mac80211/mlme.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a41f234..3a1699b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -758,19 +758,23 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	if (local->hw.conf.flags & IEEE80211_CONF_PS)
 		return;
 
+	/* don't enter PS if dynamic PS is enabled and TX frames are pending */
+	if (local->hw.conf.dynamic_ps_timeout > 0 &&
+	    !local->disable_dynamic_ps && drv_tx_frames_pending(local)) {
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+			  msecs_to_jiffies(
+			  local->hw.conf.dynamic_ps_timeout));
+		return;
+	}
+
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
 		netif_tx_stop_all_queues(sdata->dev);
 
-		if (drv_tx_frames_pending(local))
-			mod_timer(&local->dynamic_ps_timer, jiffies +
-				  msecs_to_jiffies(
-				  local->hw.conf.dynamic_ps_timeout));
-		else {
-			ieee80211_send_nullfunc(local, sdata, 1);
-			/* Flush to get the tx status of nullfunc frame */
-			drv_flush(local, false);
-		}
+		ieee80211_send_nullfunc(local, sdata, 1);
+
+		/* Flush to get the tx status of nullfunc frame */
+		drv_flush(local, false);
 	}
 
 	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
-- 
1.7.4.1

