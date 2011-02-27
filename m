Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1B0WbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:31:03 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so2383975wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:31:02 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 4/7] wl12xx: Switch to a threaded interrupt handler
Date: Mon, 28 Feb 2011 00:30:42 +0200
Message-Id: <1298845845-12191-5-git-send-email-ido@wizery.com>
In-Reply-To: <1298845845-12191-1-git-send-email-ido@wizery.com>
References: <1298845845-12191-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To achieve maximal throughput, it is very important to react to
interrupts as soon as possible. Currently the interrupt handler wakes up
a worker for handling interrupts in process context. A cleaner and more
efficient design would be to request a threaded interrupt handler.  This
handler's priority is very high, and can do blocking operations such as
SDIO/SPI transactions.

Some work can be deferred, mostly calls to mac80211 APIs
(ieee80211_rx_ni and ieee80211_tx_status). By deferring such work to a
different worker, we can keep the irq handler thread more I/O
responsive. In addition, on multi-core systems the two threads can be
scheduled on different cores, which will improve overall performance.

The use of WL1271_FLAG_IRQ_PENDING & WL1271_FLAG_IRQ_RUNNING was
changed. For simplicity, always query the FW for more pending
interrupts. Since there are relatively long bursts of interrupts, the
extra FW status read overhead is negligible. In addition, this enables
registering the IRQ handler with the ONESHOT option.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/io.h      |    1 +
 drivers/net/wireless/wl12xx/main.c    |  114 +++++++++++++++++++--------------
 drivers/net/wireless/wl12xx/ps.c      |    6 +-
 drivers/net/wireless/wl12xx/ps.h      |    2 +-
 drivers/net/wireless/wl12xx/rx.c      |    3 +-
 drivers/net/wireless/wl12xx/sdio.c    |   16 ++---
 drivers/net/wireless/wl12xx/spi.c     |   19 ++----
 drivers/net/wireless/wl12xx/tx.c      |    5 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |   11 ++-
 10 files changed, 97 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index bebfa28..8e75b09 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -99,7 +99,7 @@ static void wl1271_debugfs_update_stats(struct wl1271 *wl)
 
 	mutex_lock(&wl->mutex);
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index 844b32b..c1aac82 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -168,5 +168,6 @@ void wl1271_unregister_hw(struct wl1271 *wl);
 int wl1271_init_ieee80211(struct wl1271 *wl);
 struct ieee80211_hw *wl1271_alloc_hw(void);
 int wl1271_free_hw(struct wl1271 *wl);
+irqreturn_t wl1271_irq(int irq, void *data);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 443f829..9ceba52 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -374,7 +374,7 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -635,16 +635,12 @@ static void wl1271_fw_status(struct wl1271 *wl,
 		(s64)le32_to_cpu(status->fw_localtime);
 }
 
-#define WL1271_IRQ_MAX_LOOPS 10
-
-static void wl1271_irq_work(struct work_struct *work)
+irqreturn_t wl1271_irq(int irq, void *cookie)
 {
 	int ret;
 	u32 intr;
-	int loopcount = WL1271_IRQ_MAX_LOOPS;
-	unsigned long flags;
-	struct wl1271 *wl =
-		container_of(work, struct wl1271, irq_work);
+	struct wl1271 *wl = (struct wl1271 *)cookie;
+	bool done = false;
 
 	mutex_lock(&wl->mutex);
 
@@ -653,26 +649,27 @@ static void wl1271_irq_work(struct work_struct *work)
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl, true);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	spin_lock_irqsave(&wl->wl_lock, flags);
-	while (test_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags) && loopcount) {
-		clear_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags);
-		spin_unlock_irqrestore(&wl->wl_lock, flags);
-		loopcount--;
+	while (!done) {
+		/*
+		 * In order to avoid a race with the hardirq, clear the flag
+		 * before acknowledging the chip. Since the mutex is held,
+		 * wl1271_ps_elp_wakeup cannot be called concurrently.
+		 */
+		clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
+		smp_mb__after_clear_bit();
 
 		wl1271_fw_status(wl, wl->fw_status);
 		intr = le32_to_cpu(wl->fw_status->common.intr);
+		intr &= WL1271_INTR_MASK;
 		if (!intr) {
-			wl1271_debug(DEBUG_IRQ, "Zero interrupt received.");
-			spin_lock_irqsave(&wl->wl_lock, flags);
+			done = true;
 			continue;
 		}
 
-		intr &= WL1271_INTR_MASK;
-
 		if (unlikely(intr & WL1271_ACX_INTR_WATCHDOG)) {
 			wl1271_error("watchdog interrupt received! "
 				     "starting recovery.");
@@ -719,20 +716,37 @@ static void wl1271_irq_work(struct work_struct *work)
 
 		if (intr & WL1271_ACX_INTR_HW_AVAILABLE)
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
-
-		spin_lock_irqsave(&wl->wl_lock, flags);
 	}
 
-	if (test_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags))
-		ieee80211_queue_work(wl->hw, &wl->irq_work);
-	else
-		clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
-
 	wl1271_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
+
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL_GPL(wl1271_irq);
+
+static void wl1271_netstack_work(struct work_struct *work)
+{
+	struct wl1271 *wl =
+		container_of(work, struct wl1271, netstack_work);
+	struct sk_buff *skb;
+	bool done = false;
+
+	while (!done) {
+		done = true;
+		/* Pass all received frames to the network stack */
+		while ((skb = skb_dequeue(&wl->deferred_rx_queue)))
+			ieee80211_rx_ni(wl->hw, skb);
+
+		/* Return sent skbs to the network stack */
+		while ((skb = skb_dequeue(&wl->deferred_tx_queue))) {
+			ieee80211_tx_status(wl->hw, skb);
+			/* We did some work, so check the rx queue again */
+			done = false;
+		}
+	}
 }
 
 static int wl1271_fetch_firmware(struct wl1271 *wl)
@@ -974,7 +988,6 @@ int wl1271_plt_start(struct wl1271 *wl)
 		goto out;
 
 irq_disable:
-		wl1271_disable_interrupts(wl);
 		mutex_unlock(&wl->mutex);
 		/* Unlocking the mutex in the middle of handling is
 		   inherently unsafe. In this case we deem it safe to do,
@@ -983,7 +996,8 @@ irq_disable:
 		   work function will not do anything.) Also, any other
 		   possible concurrent operations will fail due to the
 		   current state, hence the wl1271 struct should be safe. */
-		cancel_work_sync(&wl->irq_work);
+		wl1271_disable_interrupts(wl);
+		cancel_work_sync(&wl->netstack_work);
 		mutex_lock(&wl->mutex);
 power_off:
 		wl1271_power_off(wl);
@@ -1010,14 +1024,14 @@ int __wl1271_plt_stop(struct wl1271 *wl)
 		goto out;
 	}
 
-	wl1271_disable_interrupts(wl);
 	wl1271_power_off(wl);
 
 	wl->state = WL1271_STATE_OFF;
 	wl->rx_counter = 0;
 
 	mutex_unlock(&wl->mutex);
-	cancel_work_sync(&wl->irq_work);
+	wl1271_disable_interrupts(wl);
+	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->recovery_work);
 	mutex_lock(&wl->mutex);
 out:
@@ -1171,7 +1185,6 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		break;
 
 irq_disable:
-		wl1271_disable_interrupts(wl);
 		mutex_unlock(&wl->mutex);
 		/* Unlocking the mutex in the middle of handling is
 		   inherently unsafe. In this case we deem it safe to do,
@@ -1180,7 +1193,8 @@ irq_disable:
 		   work function will not do anything.) Also, any other
 		   possible concurrent operations will fail due to the
 		   current state, hence the wl1271 struct should be safe. */
-		cancel_work_sync(&wl->irq_work);
+		wl1271_disable_interrupts(wl);
+		cancel_work_sync(&wl->netstack_work);
 		mutex_lock(&wl->mutex);
 power_off:
 		wl1271_power_off(wl);
@@ -1246,12 +1260,11 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 
 	wl->state = WL1271_STATE_OFF;
 
-	wl1271_disable_interrupts(wl);
-
 	mutex_unlock(&wl->mutex);
 
+	wl1271_disable_interrupts(wl);
 	cancel_delayed_work_sync(&wl->scan_complete_work);
-	cancel_work_sync(&wl->irq_work);
+	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->tx_work);
 	cancel_delayed_work_sync(&wl->pspoll_work);
 	cancel_delayed_work_sync(&wl->elp_work);
@@ -1527,7 +1540,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -1683,7 +1696,7 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -1912,7 +1925,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		goto out_unlock;
 	}
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out_unlock;
 
@@ -2015,7 +2028,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -2041,7 +2054,7 @@ static int wl1271_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 		goto out;
 	}
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -2069,7 +2082,7 @@ static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 		goto out;
 	}
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -2548,7 +2561,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -2603,7 +2616,7 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		conf_tid->apsd_conf[0] = 0;
 		conf_tid->apsd_conf[1] = 0;
 	} else {
-		ret = wl1271_ps_elp_wakeup(wl, false);
+		ret = wl1271_ps_elp_wakeup(wl);
 		if (ret < 0)
 			goto out;
 
@@ -2649,7 +2662,7 @@ static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw)
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -2738,7 +2751,7 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out_free_sta;
 
@@ -2781,7 +2794,7 @@ static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
 	if (WARN_ON(!test_bit(id, wl->ap_hlid_map)))
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -2814,7 +2827,7 @@ int wl1271_op_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		goto out;
 	}
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -3178,7 +3191,7 @@ static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
 	if (wl->state == WL1271_STATE_OFF)
 		goto out;
 
-	ret = wl1271_ps_elp_wakeup(wl, false);
+	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -3378,9 +3391,12 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 		for (j = 0; j < AP_MAX_LINKS; j++)
 			skb_queue_head_init(&wl->links[j].tx_queue[i]);
 
+	skb_queue_head_init(&wl->deferred_rx_queue);
+	skb_queue_head_init(&wl->deferred_tx_queue);
+
 	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
 	INIT_DELAYED_WORK(&wl->pspoll_work, wl1271_pspoll_work);
-	INIT_WORK(&wl->irq_work, wl1271_irq_work);
+	INIT_WORK(&wl->netstack_work, wl1271_netstack_work);
 	INIT_WORK(&wl->tx_work, wl1271_tx_work);
 	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
 	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 5c347b1..971f13e 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -69,7 +69,7 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 	}
 }
 
-int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake)
+int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 {
 	DECLARE_COMPLETION_ONSTACK(compl);
 	unsigned long flags;
@@ -87,7 +87,7 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake)
 	 * the completion variable in one entity.
 	 */
 	spin_lock_irqsave(&wl->wl_lock, flags);
-	if (work_pending(&wl->irq_work) || chip_awake)
+	if (test_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
 		pending = true;
 	else
 		wl->elp_compl = &compl;
@@ -149,7 +149,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 	case STATION_ACTIVE_MODE:
 	default:
 		wl1271_debug(DEBUG_PSM, "leaving psm");
-		ret = wl1271_ps_elp_wakeup(wl, false);
+		ret = wl1271_ps_elp_wakeup(wl);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/wl12xx/ps.h b/drivers/net/wireless/wl12xx/ps.h
index fc1f4c1..c41bd0a 100644
--- a/drivers/net/wireless/wl12xx/ps.h
+++ b/drivers/net/wireless/wl12xx/ps.h
@@ -30,7 +30,7 @@
 int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 		       u32 rates, bool send);
 void wl1271_ps_elp_sleep(struct wl1271 *wl);
-int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake);
+int wl1271_ps_elp_wakeup(struct wl1271 *wl);
 void wl1271_elp_work(struct work_struct *work);
 void wl1271_ps_link_start(struct wl1271 *wl, u8 hlid, bool clean_queues);
 void wl1271_ps_link_end(struct wl1271 *wl, u8 hlid);
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index a07e3f9..e490979 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -129,7 +129,8 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 
 	skb_trim(skb, skb->len - desc->pad_len);
 
-	ieee80211_rx_ni(wl->hw, skb);
+	skb_queue_tail(&wl->deferred_rx_queue, skb);
+	ieee80211_queue_work(wl->hw, &wl->netstack_work);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index b9c3747..7ee9d29 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -60,7 +60,7 @@ static struct device *wl1271_sdio_wl_to_dev(struct wl1271 *wl)
 	return &(wl_to_func(wl)->dev);
 }
 
-static irqreturn_t wl1271_irq(int irq, void *cookie)
+static irqreturn_t wl1271_hardirq(int irq, void *cookie)
 {
 	struct wl1271 *wl = cookie;
 	unsigned long flags;
@@ -69,17 +69,14 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 
 	/* complete the ELP completion */
 	spin_lock_irqsave(&wl->wl_lock, flags);
+	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
 	if (wl->elp_compl) {
 		complete(wl->elp_compl);
 		wl->elp_compl = NULL;
 	}
-
-	if (!test_and_set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
-		ieee80211_queue_work(wl->hw, &wl->irq_work);
-	set_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
 }
 
 static void wl1271_sdio_disable_interrupts(struct wl1271 *wl)
@@ -231,14 +228,14 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	wl->irq = wlan_data->irq;
 	wl->ref_clock = wlan_data->board_ref_clock;
 
-	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
+	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
+				   IRQF_TRIGGER_RISING,
+				   DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
 		goto out_free;
 	}
 
-	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-
 	disable_irq(wl->irq);
 
 	ret = wl1271_init_ieee80211(wl);
@@ -261,7 +258,6 @@ static int __devinit wl1271_probe(struct sdio_func *func,
  out_irq:
 	free_irq(wl->irq, wl);
 
-
  out_free:
 	wl1271_free_hw(wl);
 
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 0132dad..df5a00f 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -320,28 +320,23 @@ static void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 	spi_sync(wl_to_spi(wl), &m);
 }
 
-static irqreturn_t wl1271_irq(int irq, void *cookie)
+static irqreturn_t wl1271_hardirq(int irq, void *cookie)
 {
-	struct wl1271 *wl;
+	struct wl1271 *wl = cookie;
 	unsigned long flags;
 
 	wl1271_debug(DEBUG_IRQ, "IRQ");
 
-	wl = cookie;
-
 	/* complete the ELP completion */
 	spin_lock_irqsave(&wl->wl_lock, flags);
+	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
 	if (wl->elp_compl) {
 		complete(wl->elp_compl);
 		wl->elp_compl = NULL;
 	}
-
-	if (!test_and_set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
-		ieee80211_queue_work(wl->hw, &wl->irq_work);
-	set_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
 }
 
 static int wl1271_spi_set_power(struct wl1271 *wl, bool enable)
@@ -413,14 +408,14 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 		goto out_free;
 	}
 
-	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
+	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
+				   IRQF_TRIGGER_RISING,
+				   DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
 		goto out_free;
 	}
 
-	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
-
 	disable_irq(wl->irq);
 
 	ret = wl1271_init_ieee80211(wl);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 57bd3bd..af1bfef 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -464,7 +464,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 
 	while ((skb = wl1271_skb_dequeue(wl))) {
 		if (!woken_up) {
-			ret = wl1271_ps_elp_wakeup(wl, false);
+			ret = wl1271_ps_elp_wakeup(wl);
 			if (ret < 0)
 				goto out_ack;
 			woken_up = true;
@@ -589,7 +589,8 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 		     result->rate_class_index, result->status);
 
 	/* return the packet to the stack */
-	ieee80211_tx_status(wl->hw, skb);
+	skb_queue_tail(&wl->deferred_tx_queue, skb);
+	ieee80211_queue_work(wl->hw, &wl->netstack_work);
 	wl1271_free_tx_id(wl, result->id);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 338acc9..45e6577 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -320,7 +320,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_IN_ELP,
 	WL1271_FLAG_PSM,
 	WL1271_FLAG_PSM_REQUESTED,
-	WL1271_FLAG_IRQ_PENDING,
 	WL1271_FLAG_IRQ_RUNNING,
 	WL1271_FLAG_IDLE,
 	WL1271_FLAG_IDLE_REQUESTED,
@@ -404,6 +403,12 @@ struct wl1271 {
 	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
 	int tx_queue_count;
 
+	/* Frames received, not handled yet by mac80211 */
+	struct sk_buff_head deferred_rx_queue;
+
+	/* Frames sent, not returned yet to mac80211 */
+	struct sk_buff_head deferred_tx_queue;
+
 	struct work_struct tx_work;
 
 	/* Pending TX frames */
@@ -424,8 +429,8 @@ struct wl1271 {
 	/* Intermediate buffer, used for packet aggregation */
 	u8 *aggr_buf;
 
-	/* The target interrupt mask */
-	struct work_struct irq_work;
+	/* Network stack work  */
+	struct work_struct netstack_work;
 
 	/* Hardware recovery work */
 	struct work_struct recovery_work;
-- 
1.7.1

