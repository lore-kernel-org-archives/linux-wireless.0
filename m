Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42102 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752102AbeEOQNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 12:13:25 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 1/2] wlcore: Make sure PM calls are paired
Date: Tue, 15 May 2018 09:13:14 -0700
Message-Id: <20180515161315.1997-2-tony@atomide.com> (sfid-20180515_181330_685382_ADD150D2)
In-Reply-To: <20180515161315.1997-1-tony@atomide.com>
References: <20180515161315.1997-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The call to wl1271_ps_elp_wakeup() in wl12xx_queue_recovery_work() is
unpaired. Let's remove it and add paired calls to wl1271_recovery_work()
instead in preparation for changing things to use runtime PM.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -796,7 +796,6 @@ void wl12xx_queue_recovery_work(struct wl1271 *wl)
 
 		wl->state = WLCORE_STATE_RESTARTING;
 		set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
-		wl1271_ps_elp_wakeup(wl);
 		wlcore_disable_interrupts_nosync(wl);
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
 	}
@@ -919,12 +918,17 @@ static void wl1271_recovery_work(struct work_struct *work)
 		container_of(work, struct wl1271, recovery_work);
 	struct wl12xx_vif *wlvif;
 	struct ieee80211_vif *vif;
+	int error;
 
 	mutex_lock(&wl->mutex);
 
 	if (wl->state == WLCORE_STATE_OFF || wl->plt)
 		goto out_unlock;
 
+	error = wl1271_ps_elp_wakeup(wl);
+	if (error < 0)
+		wl1271_warning("Enable for recovery failed");
+
 	if (!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags)) {
 		if (wl->conf.fwlog.output == WL12XX_FWLOG_OUTPUT_HOST)
 			wl12xx_read_fwlog_panic(wl);
@@ -967,6 +971,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	 */
 	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_FW_RESTART);
 
+	wl1271_ps_elp_sleep(wl);
+
 out_unlock:
 	wl->watchdog_recovery = false;
 	clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
-- 
2.17.0
