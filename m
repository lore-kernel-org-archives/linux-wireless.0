Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51481 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab1EMI5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 04:57:19 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so1752034wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 01:57:18 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 4/6] wl12xx: prevent scheduling while suspending (WoW enabled)
Date: Fri, 13 May 2011 11:57:11 +0300
Message-Id: <1305277033-6662-5-git-send-email-eliad@wizery.com> (sfid-20110513_105724_122724_A35F961F)
In-Reply-To: <1305277033-6662-1-git-send-email-eliad@wizery.com>
References: <1305277033-6662-1-git-send-email-eliad@wizery.com>
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
v1->v2:
	change wl1271_hardirq flow when returning IRQ_HANDLED

 drivers/net/wireless/wl12xx/main.c   |   46 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/sdio.c   |   24 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +
 3 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9ca71ce..308855a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1338,6 +1338,28 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
 	wl->wow_enabled = !!wow;
+	if (wl->wow_enabled) {
+		/* flush any remaining work */
+		wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
+		flush_delayed_work(&wl->scan_complete_work);
+
+		/*
+		 * disable and re-enable interrupts in order to flush
+		 * the threaded_irq
+		 */
+		wl1271_disable_interrupts(wl);
+
+		/*
+		 * set suspended flag to avoid triggering a new threaded_irq
+		 * work. no need for spinlock as interrupts are disabled.
+		 */
+		set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
+
+		wl1271_enable_interrupts(wl);
+		flush_work(&wl->tx_work);
+		flush_delayed_work(&wl->pspoll_work);
+		flush_delayed_work(&wl->elp_work);
+	}
 	return 0;
 }
 
@@ -1346,6 +1368,30 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 	struct wl1271 *wl = hw->priv;
 	wl1271_debug(DEBUG_MAC80211, "mac80211 resume wow=%d",
 		     wl->wow_enabled);
+
+	/*
+	 * re-enable irq_work enqueuing, and call irq_work directly if
+	 * there is a pending work.
+	 */
+	if (wl->wow_enabled) {
+		struct wl1271 *wl = hw->priv;
+		unsigned long flags;
+		bool run_irq_work = false;
+
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		clear_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
+		if (test_and_clear_bit(WL1271_FLAG_PENDING_WORK, &wl->flags))
+			run_irq_work = true;
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+		if (run_irq_work) {
+			wl1271_debug(DEBUG_MAC80211,
+				     "run postponed irq_work directly");
+			wl1271_irq(0, wl);
+			wl1271_enable_interrupts(wl);
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 5b03fd5..41183db 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -82,6 +82,16 @@ static irqreturn_t wl1271_hardirq(int irq, void *cookie)
 		complete(wl->elp_compl);
 		wl->elp_compl = NULL;
 	}
+
+	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
+		/* don't enqueue a work right now. mark it as pending */
+		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
+		wl1271_debug(DEBUG_IRQ, "should not enqueue work");
+		disable_irq_nosync(wl->irq);
+		pm_wakeup_event(wl1271_sdio_wl_to_dev(wl), 0);
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+		return IRQ_HANDLED;
+	}
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	return IRQ_WAKE_THREAD;
@@ -268,6 +278,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	}
 
 	enable_irq_wake(wl->irq);
+	device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 1);
 
 	disable_irq(wl->irq);
 
@@ -305,6 +316,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	pm_runtime_get_noresume(&func->dev);
 
 	wl1271_unregister_hw(wl);
+	device_init_wakeup(wl1271_sdio_wl_to_dev(wl), 0);
 	disable_irq_wake(wl->irq);
 	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
@@ -339,6 +351,9 @@ static int wl1271_suspend(struct device *dev)
 			wl1271_error("error while trying to keep power");
 			goto out;
 		}
+
+		/* release host */
+		sdio_release_host(func);
 	}
 out:
 	return ret;
@@ -346,6 +361,15 @@ out:
 
 static int wl1271_resume(struct device *dev)
 {
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct wl1271 *wl = sdio_get_drvdata(func);
+
+	wl1271_debug(DEBUG_MAC80211, "wl1271 resume");
+	if (wl->wow_enabled) {
+		/* claim back host */
+		sdio_claim_host(func);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index f9d0a14..daf941d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -358,6 +358,8 @@ enum wl12xx_flags {
 	WL1271_FLAG_AP_STARTED,
 	WL1271_FLAG_IF_INITIALIZED,
 	WL1271_FLAG_DUMMY_PACKET_PENDING,
+	WL1271_FLAG_SUSPENDED,
+	WL1271_FLAG_PENDING_WORK,
 };
 
 struct wl1271_link {
-- 
1.7.0.4

