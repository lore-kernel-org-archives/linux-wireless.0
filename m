Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19984 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937725Ab0CPKtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 06:49:07 -0400
From: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Reschedule dynamic power save timer after wakeup
Date: Tue, 16 Mar 2010 12:46:41 -0400
Message-Id: <1268758001-18253-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After last transmission, the device goes to sleep earlier
than the configured dynamic power save timeout. If timeout
is set to 400ms, device enters into sleep mode at around
330ms since from last TX.

This patch re-schedules dynamic power save timer
after PSM is disabled, which ensures timeout
period starts only after wakeup and the timeout
variation is around 2-3ms.

Signed-off-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/mlme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 86c6ad1..f7f3f61 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -537,6 +537,8 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 
 	ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_PS);
+	mod_timer(&local->dynamic_ps_timer, jiffies +
+		  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 }
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
-- 
1.7.0

