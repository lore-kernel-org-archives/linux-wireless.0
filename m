Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37140 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1FFJVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:21:36 -0400
Received: by wwa36 with SMTP id 36so3582178wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 02:21:35 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/4] wl12xx: don't check wow param on suspend/resume
Date: Mon,  6 Jun 2011 12:21:52 +0300
Message-Id: <1307352115-28969-1-git-send-email-eliad@wizery.com> (sfid-20110606_112140_011146_8D33AD07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since mac80211 calls suspend/resume only when wowlan triggers
exist, there is no need to check for triggers existance in the
callbacks as well.
Add a WARN_ON() to verify it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   87 ++++++++++++++++++------------------
 1 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..8eb52b7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1544,69 +1544,68 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 			    struct cfg80211_wowlan *wow)
 {
 	struct wl1271 *wl = hw->priv;
+	int ret;
+
 	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
-	wl->wow_enabled = !!wow;
-	if (wl->wow_enabled) {
-		int ret;
-		ret = wl1271_configure_suspend(wl);
-		if (ret < 0) {
-			wl1271_warning("couldn't prepare device to suspend");
-			return ret;
-		}
-		/* flush any remaining work */
-		wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
-		flush_delayed_work(&wl->scan_complete_work);
+	WARN_ON(!wow || !wow->any);
 
-		/*
-		 * disable and re-enable interrupts in order to flush
-		 * the threaded_irq
-		 */
-		wl1271_disable_interrupts(wl);
+	wl->wow_enabled = true;
+	ret = wl1271_configure_suspend(wl);
+	if (ret < 0) {
+		wl1271_warning("couldn't prepare device to suspend");
+		return ret;
+	}
+	/* flush any remaining work */
+	wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
+	flush_delayed_work(&wl->scan_complete_work);
 
-		/*
-		 * set suspended flag to avoid triggering a new threaded_irq
-		 * work. no need for spinlock as interrupts are disabled.
-		 */
-		set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
+	/*
+	 * disable and re-enable interrupts in order to flush
+	 * the threaded_irq
+	 */
+	wl1271_disable_interrupts(wl);
+
+	/*
+	 * set suspended flag to avoid triggering a new threaded_irq
+	 * work. no need for spinlock as interrupts are disabled.
+	 */
+	set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
+
+	wl1271_enable_interrupts(wl);
+	flush_work(&wl->tx_work);
+	flush_delayed_work(&wl->pspoll_work);
+	flush_delayed_work(&wl->elp_work);
 
-		wl1271_enable_interrupts(wl);
-		flush_work(&wl->tx_work);
-		flush_delayed_work(&wl->pspoll_work);
-		flush_delayed_work(&wl->elp_work);
-	}
 	return 0;
 }
 
 static int wl1271_op_resume(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
+	unsigned long flags;
+	bool run_irq_work = false;
+
 	wl1271_debug(DEBUG_MAC80211, "mac80211 resume wow=%d",
 		     wl->wow_enabled);
+	WARN_ON(!wl->wow_enabled);
 
 	/*
 	 * re-enable irq_work enqueuing, and call irq_work directly if
 	 * there is a pending work.
 	 */
-	if (wl->wow_enabled) {
-		struct wl1271 *wl = hw->priv;
-		unsigned long flags;
-		bool run_irq_work = false;
-
-		spin_lock_irqsave(&wl->wl_lock, flags);
-		clear_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
-		if (test_and_clear_bit(WL1271_FLAG_PENDING_WORK, &wl->flags))
-			run_irq_work = true;
-		spin_unlock_irqrestore(&wl->wl_lock, flags);
-
-		if (run_irq_work) {
-			wl1271_debug(DEBUG_MAC80211,
-				     "run postponed irq_work directly");
-			wl1271_irq(0, wl);
-			wl1271_enable_interrupts(wl);
-		}
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	clear_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
+	if (test_and_clear_bit(WL1271_FLAG_PENDING_WORK, &wl->flags))
+		run_irq_work = true;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-		wl1271_configure_resume(wl);
+	if (run_irq_work) {
+		wl1271_debug(DEBUG_MAC80211,
+			     "run postponed irq_work directly");
+		wl1271_irq(0, wl);
+		wl1271_enable_interrupts(wl);
 	}
+	wl1271_configure_resume(wl);
 
 	return 0;
 }
-- 
1.7.0.4

