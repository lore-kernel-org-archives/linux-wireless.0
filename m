Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18025 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1BRIqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 03:46:22 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:46:01 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: [PATCH 1/2] mac80211: Fix a race on enabling power save.
Date: Fri, 18 Feb 2011 14:16:15 +0530
Message-ID: <1298018776-6936-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a race on sending a data frame before the tx completion
of nullfunc frame for enabling power save. As the data quickly
follows the nullfunc frame, the AP thinks that the station is out
of power save and continues to send the frames. Whereas in the
station, the nullfunc ack will be processed after the tx completion
of data frame and mac80211 goes to powersave. Thus the power
save state mismatch between the station and the AP causes some
data loss and some applications fail because of that. This patch
fixes this issue.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/mlme.c   |   11 ++++++++++-
 net/mac80211/status.c |    2 --
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d89e878..91006a2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -738,8 +738,16 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		return;
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)))
+	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
+		netif_tx_stop_all_queues(sdata->dev);
+		/* flush all the frames queued in the driver before
+		 * going to power save
+		 */
+		drv_flush(local, false);
 		ieee80211_send_nullfunc(local, sdata, 1);
+		/* flush once again to get the tx status of nullfunc frame */
+		drv_flush(local, false);
+	}
 
 	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
 	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
@@ -748,6 +756,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
+	netif_tx_start_all_queues(sdata->dev);
 }
 
 void ieee80211_dynamic_ps_timer(unsigned long data)
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 010a559..8651851 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -318,8 +318,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (info->flags & IEEE80211_TX_STAT_ACK) {
 			local->ps_sdata->u.mgd.flags |=
 					IEEE80211_STA_NULLFUNC_ACKED;
-			ieee80211_queue_work(&local->hw,
-					&local->dynamic_ps_enable_work);
 		} else
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 					msecs_to_jiffies(10));
-- 
1.6.3.3

