Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:33485 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966047Ab0CPJcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 05:32:11 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2G9Vgl4004094
	for <linux-wireless@vger.kernel.org>; Tue, 16 Mar 2010 04:32:10 -0500
Received: from localhost.localdomain (trdhcp21240.nmp.nokia.com [172.22.212.40])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2G9VvfX012751
	for <linux-wireless@vger.kernel.org>; Tue, 16 Mar 2010 11:31:57 +0200
From: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Reschedule dynamic power save timer after wakeup
Date: Tue, 16 Mar 2010 11:31:02 -0400
Message-Id: <1268753462-18094-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
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

