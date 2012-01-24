Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:46129 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283Ab2AXJGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 04:06:48 -0500
Received: by lags15 with SMTP id s15so2156300lag.6
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 01:06:45 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Yariv <ido@wizery.com>
Subject: [PATCH 3/8] wl12xx: Fix potential interrupt storm
Date: Tue, 24 Jan 2012 11:06:24 +0200
Message-Id: <1327395989-29663-4-git-send-email-coelho@ti.com> (sfid-20120124_100659_893560_2B751569)
In-Reply-To: <1327395989-29663-1-git-send-email-coelho@ti.com>
References: <1327395989-29663-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

The interrupt threaded handler exits immediately if the driver's state
is WL1271_STATE_OFF. As a result, the interrupt status is not read. If
the interrupt is level triggered, it will be fired again.

Fix this by disabling interrupts before setting the state to OFF.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bf356a8..27ca324 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1397,9 +1397,23 @@ int wl1271_plt_stop(struct wl1271 *wl)
 
 	wl1271_notice("power down");
 
+	/*
+	 * Interrupts must be disabled before setting the state to OFF.
+	 * Otherwise, the interrupt handler might be called and exit without
+	 * reading the interrupt status.
+	 */
+	wl1271_disable_interrupts(wl);
 	mutex_lock(&wl->mutex);
 	if (wl->state != WL1271_STATE_PLT) {
 		mutex_unlock(&wl->mutex);
+
+		/*
+		 * This will not necessarily enable interrupts as interrupts
+		 * may have been disabled when op_stop was called. It will,
+		 * however, balance the above call to disable_interrupts().
+		 */
+		wl1271_enable_interrupts(wl);
+
 		wl1271_error("cannot power down because not in PLT "
 			     "state: %d", wl->state);
 		ret = -EBUSY;
@@ -1411,7 +1425,6 @@ int wl1271_plt_stop(struct wl1271 *wl)
 
 	mutex_unlock(&wl->mutex);
 
-	wl1271_disable_interrupts(wl);
 	wl1271_flush_deferred_work(wl);
 	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->recovery_work);
@@ -1773,11 +1786,25 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
 
+	/*
+	 * Interrupts must be disabled before setting the state to OFF.
+	 * Otherwise, the interrupt handler might be called and exit without
+	 * reading the interrupt status.
+	 */
+	wl1271_disable_interrupts(wl);
 	mutex_lock(&wl->mutex);
 	if (wl->state == WL1271_STATE_OFF) {
 		mutex_unlock(&wl->mutex);
+
+		/*
+		 * This will not necessarily enable interrupts as interrupts
+		 * may have been disabled when op_stop was called. It will,
+		 * however, balance the above call to disable_interrupts().
+		 */
+		wl1271_enable_interrupts(wl);
 		return;
 	}
+
 	/*
 	 * this must be before the cancel_work calls below, so that the work
 	 * functions don't perform further work.
@@ -1789,7 +1816,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	list_del(&wl->list);
 	mutex_unlock(&wl_list_mutex);
 
-	wl1271_disable_interrupts(wl);
 	wl1271_flush_deferred_work(wl);
 	cancel_delayed_work_sync(&wl->scan_complete_work);
 	cancel_work_sync(&wl->netstack_work);
-- 
1.7.4.1

