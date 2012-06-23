Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:36668 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754394Ab2FWGl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:41:59 -0400
Received: by lboj14 with SMTP id j14so6133132lbo.21
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:41:56 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 02/18] wlcore: Disable interrupts while recovering
Date: Sat, 23 Jun 2012 09:41:13 +0300
Message-Id: <1340433689-24320-3-git-send-email-coelho@ti.com> (sfid-20120623_084205_804810_6A802470)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

In case a recovery is initiated, the FW can no longer be trusted, and
the driver should not handle any new FW events.

Disable the interrupt handler when a recovery is scheduled and balance
it back in the op_stop callback.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/io.c   |    6 ++++++
 drivers/net/wireless/ti/wlcore/io.h   |    1 +
 drivers/net/wireless/ti/wlcore/main.c |   21 +++++++++++++++------
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index 7cd0081..62d6573 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -48,6 +48,12 @@ void wlcore_disable_interrupts(struct wl1271 *wl)
 }
 EXPORT_SYMBOL_GPL(wlcore_disable_interrupts);
 
+void wlcore_disable_interrupts_nosync(struct wl1271 *wl)
+{
+	disable_irq_nosync(wl->irq);
+}
+EXPORT_SYMBOL_GPL(wlcore_disable_interrupts_nosync);
+
 void wlcore_enable_interrupts(struct wl1271 *wl)
 {
 	enable_irq(wl->irq);
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 404cb14..bbaf711 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -45,6 +45,7 @@
 struct wl1271;
 
 void wlcore_disable_interrupts(struct wl1271 *wl);
+void wlcore_disable_interrupts_nosync(struct wl1271 *wl);
 void wlcore_enable_interrupts(struct wl1271 *wl);
 
 void wl1271_io_reset(struct wl1271 *wl);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 78edc58..c94351a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -743,8 +743,11 @@ out:
 
 void wl12xx_queue_recovery_work(struct wl1271 *wl)
 {
-	if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
+	/* Avoid a recursive recovery */
+	if (!test_and_set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
+		wlcore_disable_interrupts_nosync(wl);
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
+	}
 }
 
 size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen)
@@ -848,9 +851,6 @@ static void wl1271_recovery_work(struct work_struct *work)
 	if (wl->state != WL1271_STATE_ON || wl->plt)
 		goto out_unlock;
 
-	/* Avoid a recursive recovery */
-	set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
-
 	wl12xx_read_fwlog_panic(wl);
 
 	/* change partitions momentarily so we can read the FW pc */
@@ -902,8 +902,6 @@ static void wl1271_recovery_work(struct work_struct *work)
 	mutex_unlock(&wl->mutex);
 	wl1271_op_stop(wl->hw);
 
-	clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
-
 	ieee80211_restart_hw(wl->hw);
 
 	/*
@@ -1706,6 +1704,10 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wlcore_disable_interrupts(wl);
 	mutex_lock(&wl->mutex);
 	if (wl->state == WL1271_STATE_OFF) {
+		if (test_and_clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
+					&wl->flags))
+			wlcore_enable_interrupts(wl);
+
 		mutex_unlock(&wl->mutex);
 
 		/*
@@ -1737,6 +1739,13 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	mutex_lock(&wl->mutex);
 
 	wl1271_power_off(wl);
+	/*
+	 * In case a recovery was scheduled, interrupts were disabled to avoid
+	 * an interrupt storm. Now that the power is down, it is safe to
+	 * re-enable interrupts to balance the disable depth
+	 */
+	if (test_and_clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
+		wlcore_enable_interrupts(wl);
 
 	wl->band = IEEE80211_BAND_2GHZ;
 
-- 
1.7.10

