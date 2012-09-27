Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:37718 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab2I0Kik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:40 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 05/31] wlcore: cancel recovery_work on stop() instead of remove_interface()
Date: Thu, 27 Sep 2012 13:37:43 +0300
Message-Id: <1348742289-6587-6-git-send-email-luca@coelho.fi> (sfid-20120927_124025_504647_D76E7A6B)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

recovery_work should be cancelled when stopping the device,
not when removing an interface (this is probably a leftover
from the single-role days)

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 21267c5..612008f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1857,6 +1857,8 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	mutex_unlock(&wl->mutex);
 
 	wlcore_synchronize_interrupts(wl);
+	if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
+		cancel_work_sync(&wl->recovery_work);
 	wl1271_flush_deferred_work(wl);
 	cancel_delayed_work_sync(&wl->scan_complete_work);
 	cancel_work_sync(&wl->netstack_work);
@@ -2437,7 +2439,6 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl12xx_vif *iter;
 	struct vif_counter_data vif_count;
-	bool cancel_recovery = true;
 
 	wl12xx_get_vif_count(hw, vif, &vif_count);
 	mutex_lock(&wl->mutex);
@@ -2462,12 +2463,9 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 		wl12xx_force_active_psm(wl);
 		set_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags);
 		wl12xx_queue_recovery_work(wl);
-		cancel_recovery = false;
 	}
 out:
 	mutex_unlock(&wl->mutex);
-	if (cancel_recovery)
-		cancel_work_sync(&wl->recovery_work);
 }
 
 static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
-- 
1.7.10.4

