Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47376 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab1CAUhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:37:00 -0500
Received: by mail-ww0-f42.google.com with SMTP id 15so4909349wwe.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:37:00 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 8/9] wl12xx: prevent scheduling while suspending (WoW enabled)
Date: Tue,  1 Mar 2011 22:36:43 +0200
Message-Id: <1299011804-13899-9-git-send-email-eliad@wizery.com>
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When WoW is enabled, the interface will stay up and the chip will
be powered on, so we have to flush/cancel any remaining work, and
prevent the irq handler from scheduling a new work until the system
is resumed.

Add 2 new flags:
* WL1271_FLAG_SUSPENDED - the system is (about to be) suspended.
* WL1271_FLAG_PENDING_WORK - there is a pending irq work which
   should be scheduled when the system is being resumed.

In order to wake-up the system while getting an irq, we initialize
the device as wakeup device, and calling pm_wakeup_event() upon
getting the interrupt (while the system is about to be suspended)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   33 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/sdio.c   |   31 ++++++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/wl12xx.h |    4 +++-
 3 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a46022f..6de0567 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1086,6 +1086,24 @@ static int wl1271_op_start(struct ieee80211_hw *hw,
 {
 	wl1271_debug(DEBUG_MAC80211, "mac80211 start resume=%d", !!wow);
 
+	/* on resume we have to enable irq_work enqueuing */
+	if (wow) {
+		struct wl1271 *wl = hw->priv;
+		unsigned long flags;
+
+		wl1271_debug(DEBUG_MAC80211, "enabled wow triggers: 0x%x",
+			     wow->enabled_triggers);
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		clear_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
+		if (test_and_clear_bit(WL1271_FLAG_PENDING_WORK, &wl->flags)) {
+			ieee80211_queue_work(wl->hw, &wl->irq_work);
+			set_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags);
+			wl1271_debug(DEBUG_MAC80211,
+				     "enqueuing 'missing' irq_work");
+		}
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+	}
+
 	/*
 	 * We have to delay the booting of the hardware because
 	 * we need to know the local MAC address before downloading and
@@ -1109,6 +1127,21 @@ static void wl1271_op_stop(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop suspend=%d", !!wow);
 	wl->wow_enabled = !!(wow && wow->enabled_triggers);
+	if (wl->wow_enabled) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+		/* we don't want any remaining work */
+		wl1271_info("flushing remaining works\n");
+		flush_delayed_work(&wl->scan_complete_work);
+		flush_work(&wl->irq_work);
+		flush_work(&wl->tx_work);
+		flush_delayed_work(&wl->pspoll_work);
+		flush_delayed_work(&wl->elp_work);
+	}
 }
 
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 6083c3d..f5d4b21 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -75,9 +75,16 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		wl->elp_compl = NULL;
 	}
 
-	if (!test_and_set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
-		ieee80211_queue_work(wl->hw, &wl->irq_work);
-	set_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags);
+	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
+		/* we shouldn't enqueue a work right now. mark it as pending */
+		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
+		wl1271_debug(DEBUG_IRQ, "not enqueuing work");
+		pm_wakeup_event(wl1271_sdio_wl_to_dev(wl), 0);
+	} else {
+		if (!test_and_set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
+			ieee80211_queue_work(wl->hw, &wl->irq_work);
+		set_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags);
+	}
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	return IRQ_HANDLED;
@@ -266,6 +273,8 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
 	set_irq_wake(wl->irq, 1);
+	device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 1);
+
 
 	disable_irq(wl->irq);
 
@@ -304,6 +313,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	pm_runtime_get_noresume(&func->dev);
 
 	wl1271_unregister_hw(wl);
+	device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 0);
 	set_irq_wake(wl->irq, 0);
 	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
@@ -316,9 +326,24 @@ static int wl1271_suspend(struct device *dev)
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	struct wl1271 *wl = sdio_get_drvdata(func);
 	mmc_pm_flag_t sdio_flags;
+	unsigned long flags;
+	bool abort;
 	int ret = 0;
 
 	/*
+	 * if there is a pending irq work, we should abort the suspension.
+	 * (irq might come between mac80211 suspension and our suspension)
+	 * TODO: maybe remove it, since system will wake up anyway?
+	 */
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	abort = !!test_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+	if (abort) {
+		wl1271_info("pending irq work - aborting suspend");
+		return -EBUSY;
+	}
+
+	/*
 	 * we need to look into wl to tell which suspend method to use.
 	 * we will have full power, ps mode, elp, and power off
 	 */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index dd21818..2dc0b31 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -327,7 +327,9 @@ enum wl12xx_flags {
 	WL1271_FLAG_PSPOLL_FAILURE,
 	WL1271_FLAG_STA_STATE_SENT,
 	WL1271_FLAG_FW_TX_BUSY,
-	WL1271_FLAG_AP_STARTED
+	WL1271_FLAG_AP_STARTED,
+	WL1271_FLAG_SUSPENDED,
+	WL1271_FLAG_PENDING_WORK,
 };
 
 struct wl1271_link {
-- 
1.7.0.4

