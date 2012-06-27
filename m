Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:35048 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160Ab2F0Pg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:36:28 -0400
Received: by bkty5 with SMTP id y5so1361197bkt.30
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:36:25 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 6/8] wlcore: always clear recovery flag during recovery_work
Date: Wed, 27 Jun 2012 18:36:00 +0300
Message-Id: <1340811362-30441-7-git-send-email-coelho@ti.com> (sfid-20120627_173631_442274_20DFEF81)
In-Reply-To: <1340811362-30441-1-git-send-email-coelho@ti.com>
References: <1340811362-30441-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

If recovery is called when the FW is off, we should clear the recovery
flag. Otherwise we risk booting the driver in permanent pending-recovery
state.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 49990b1..709f6dd 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -926,7 +926,6 @@ static void wl1271_recovery_work(struct work_struct *work)
 
 	if (no_recovery) {
 		wl1271_info("No recovery (chosen on module load). Fw will remain stuck.");
-		clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
 		goto out_unlock;
 	}
 
@@ -970,7 +969,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_FW_RESTART);
 	return;
 out_unlock:
-        wl->watchdog_recovery = false;
+	wl->watchdog_recovery = false;
+	clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
 	mutex_unlock(&wl->mutex);
 }
 
-- 
1.7.10

