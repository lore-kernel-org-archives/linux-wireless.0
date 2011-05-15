Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52608 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab1EOIKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 04:10:37 -0400
Received: by wwa36 with SMTP id 36so4137152wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 01:10:35 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/3] wl12xx: add automatic rx streaming triggers
Date: Sun, 15 May 2011 11:10:29 +0300
Message-Id: <1305447030-10704-2-git-send-email-eliad@wizery.com> (sfid-20110515_101044_766587_F5D2E7FC)
In-Reply-To: <1305447030-10704-1-git-send-email-eliad@wizery.com>
References: <1305447030-10704-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rx_streaming.interval is non-zero, use automatic rx streaming.
Enable rx streaming on the each rx/tx packet, and disable it
rx_streaming.duration msecs later.

When rx_streaming.always=0 (default), rx streaming is enabled only
when there is a coex operation.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1->v2:
	add .always param
	consider only data packets
	fix some minor bugs

 drivers/net/wireless/wl12xx/conf.h   |    5 ++
 drivers/net/wireless/wl12xx/event.c  |   25 +++++--
 drivers/net/wireless/wl12xx/main.c   |  122 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/rx.c     |   29 +++++++-
 drivers/net/wireless/wl12xx/tx.c     |   25 +++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    8 ++
 6 files changed, 203 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 2b60a43..510c2f7 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1267,6 +1267,11 @@ struct conf_rx_streaming_settings {
 	 * Range: 0 (disabled), 10 - 100
 	 */
 	u8 interval;
+
+	/*
+	 * enable rx streaming also when there is no coex activity
+	 */
+	u8 always;
 };
 
 struct conf_drv_settings {
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index c3c554c..c469853 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -168,6 +168,21 @@ static void wl1271_event_rssi_trigger(struct wl1271 *wl,
 	wl->last_rssi_event = event;
 }
 
+static void wl12xx_event_soft_gemini_sense(struct wl1271 *wl,
+					       u8 enable)
+{
+	if (enable) {
+		/* disable dynamic PS when the firmware senses BT*/
+		ieee80211_disable_dyn_ps(wl->vif);
+		set_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags);
+	} else {
+		ieee80211_enable_dyn_ps(wl->vif);
+		clear_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags);
+		wl1271_recalc_rx_streaming(wl);
+	}
+
+}
+
 static void wl1271_event_mbox_dump(struct event_mailbox *mbox)
 {
 	wl1271_debug(DEBUG_EVENT, "MBOX DUMP:");
@@ -211,14 +226,10 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		}
 	}
 
-	/* disable dynamic PS when requested by the firmware */
 	if (vector & SOFT_GEMINI_SENSE_EVENT_ID &&
-	    wl->bss_type == BSS_TYPE_STA_BSS) {
-		if (mbox->soft_gemini_sense_info)
-			ieee80211_disable_dyn_ps(wl->vif);
-		else
-			ieee80211_enable_dyn_ps(wl->vif);
-	}
+	    wl->bss_type == BSS_TYPE_STA_BSS)
+		wl12xx_event_soft_gemini_sense(wl,
+					       mbox->soft_gemini_sense_info);
 
 	/*
 	 * The BSS_LOSE_EVENT_ID is only needed while psm (and hence beacon
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6aa294e..fb0f764 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -365,6 +365,7 @@ static struct conf_drv_settings default_conf = {
 		.duration                      = 150,
 		.queues                        = 0x1,
 		.interval                      = 20,
+		.always                        = 0,
 	},
 	.hci_io_ds = HCI_IO_DS_6MA,
 };
@@ -477,6 +478,117 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
 	return 0;
 }
 
+static int wl1271_set_rx_streaming(struct wl1271 *wl, bool enable)
+{
+	int ret = 0;
+
+	/* we should hold wl->mutex */
+	ret = wl1271_acx_ps_rx_streaming(wl, enable);
+	if (ret < 0)
+		goto out;
+
+	if (enable)
+		set_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags);
+	else
+		clear_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags);
+out:
+	return ret;
+}
+
+/*
+ * this function is being called when the rx_streaming interval
+ * has beed changed or rx_streaming should be disabled
+ */
+int wl1271_recalc_rx_streaming(struct wl1271 *wl)
+{
+	int ret = 0;
+	int period = wl->conf.rx_streaming.interval;
+
+	/* don't reconfigure if rx_streaming is disabled */
+	if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+		goto out;
+
+	/* reconfigure/disable according to new streaming_period */
+	if (period &&
+	    test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) &&
+	    (wl->conf.rx_streaming.always ||
+	     test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags)))
+		ret = wl1271_set_rx_streaming(wl, true);
+	else {
+		ret = wl1271_set_rx_streaming(wl, false);
+		/* don't cancel_work_sync since we might deadlock */
+		del_timer_sync(&wl->rx_streaming_timer);
+	}
+out:
+	return ret;
+}
+
+static void wl1271_rx_streaming_enable_work(struct work_struct *work)
+{
+	int ret;
+	struct wl1271 *wl =
+		container_of(work, struct wl1271, rx_streaming_enable_work);
+
+	mutex_lock(&wl->mutex);
+
+	if (test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags) ||
+	    !test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
+	    (!wl->conf.rx_streaming.always &&
+	     !test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags)))
+		goto out;
+
+	if (!wl->conf.rx_streaming.interval)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_set_rx_streaming(wl, true);
+	if (ret < 0)
+		goto out_sleep;
+
+	/* stop it after some time of inactivity */
+	mod_timer(&wl->rx_streaming_timer,
+		  jiffies + msecs_to_jiffies(wl->conf.rx_streaming.duration));
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+static void wl1271_rx_streaming_disable_work(struct work_struct *work)
+{
+	int ret;
+	struct wl1271 *wl =
+		container_of(work, struct wl1271, rx_streaming_disable_work);
+
+	mutex_lock(&wl->mutex);
+
+	if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_set_rx_streaming(wl, false);
+	if (ret)
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+static void wl1271_rx_streaming_timer(unsigned long data)
+{
+	struct wl1271 *wl = (struct wl1271 *)data;
+	ieee80211_queue_work(wl->hw, &wl->rx_streaming_disable_work);
+}
+
 static void wl1271_conf_init(struct wl1271 *wl)
 {
 
@@ -1696,6 +1808,9 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	cancel_delayed_work_sync(&wl->scan_complete_work);
 	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->tx_work);
+	del_timer_sync(&wl->rx_streaming_timer);
+	cancel_work_sync(&wl->rx_streaming_enable_work);
+	cancel_work_sync(&wl->rx_streaming_disable_work);
 	cancel_delayed_work_sync(&wl->pspoll_work);
 	cancel_delayed_work_sync(&wl->elp_work);
 
@@ -3961,6 +4076,11 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	INIT_WORK(&wl->tx_work, wl1271_tx_work);
 	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
 	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
+	INIT_WORK(&wl->rx_streaming_enable_work,
+		  wl1271_rx_streaming_enable_work);
+	INIT_WORK(&wl->rx_streaming_disable_work,
+		  wl1271_rx_streaming_disable_work);
+
 	wl->channel = WL1271_DEFAULT_CHANNEL;
 	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
 	wl->default_key = 0;
@@ -3986,6 +4106,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->quirks = 0;
 	wl->platform_quirks = 0;
 	wl->sched_scanning = false;
+	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
+		    (unsigned long) wl);
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 7009103..db230a5 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -95,6 +95,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	struct ieee80211_hdr *hdr;
 	u8 *buf;
 	u8 beacon = 0;
+	u8 is_data = 0;
 
 	/*
 	 * In PLT mode we seem to get frames and mac80211 warns about them,
@@ -137,6 +138,8 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (ieee80211_is_beacon(hdr->frame_control))
 		beacon = 1;
+	if (ieee80211_is_data_present(hdr->frame_control))
+		is_data = 1;
 
 	wl1271_rx_status(wl, desc, IEEE80211_SKB_RXCB(skb), beacon);
 
@@ -149,7 +152,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	skb_queue_tail(&wl->deferred_rx_queue, skb);
 	ieee80211_queue_work(wl->hw, &wl->netstack_work);
 
-	return 0;
+	return is_data;
 }
 
 void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
@@ -162,6 +165,8 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 	u32 mem_block;
 	u32 pkt_length;
 	u32 pkt_offset;
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool had_data = false;
 
 	while (drv_rx_counter != fw_rx_counter) {
 		buf_size = 0;
@@ -214,9 +219,11 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 			 * conditions, in that case the received frame will just
 			 * be dropped.
 			 */
-			wl1271_rx_handle_data(wl,
-					      wl->aggr_buf + pkt_offset,
-					      pkt_length);
+			if (wl1271_rx_handle_data(wl,
+						  wl->aggr_buf + pkt_offset,
+						  pkt_length) == 1)
+				had_data = true;
+
 			wl->rx_counter++;
 			drv_rx_counter++;
 			drv_rx_counter &= NUM_RX_PKT_DESC_MOD_MASK;
@@ -230,6 +237,20 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 	 */
 	if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
 		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
+
+	if (!is_ap && wl->conf.rx_streaming.interval && had_data &&
+	    (wl->conf.rx_streaming.always ||
+	     test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags))) {
+		u32 timeout = wl->conf.rx_streaming.duration;
+
+		/* restart rx streaming */
+		if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+			ieee80211_queue_work(wl->hw,
+					     &wl->rx_streaming_enable_work);
+
+		mod_timer(&wl->rx_streaming_timer,
+			  jiffies + msecs_to_jiffies(timeout));
+	}
 }
 
 void wl1271_set_default_filters(struct wl1271 *wl)
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ca3ab1c..6603e60 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -562,17 +562,29 @@ static void wl1271_skb_queue_head(struct wl1271 *wl, struct sk_buff *skb)
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
 
+static bool wl1271_tx_is_data_present(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
+
+	return ieee80211_is_data_present(hdr->frame_control);
+}
+
 void wl1271_tx_work_locked(struct wl1271 *wl)
 {
 	struct sk_buff *skb;
 	u32 buf_offset = 0;
 	bool sent_packets = false;
+	bool had_data = false;
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 	int ret;
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		return;
 
 	while ((skb = wl1271_skb_dequeue(wl))) {
+		if (wl1271_tx_is_data_present(skb))
+			had_data = true;
+
 		ret = wl1271_prepare_tx_frame(wl, skb, buf_offset);
 		if (ret == -EAGAIN) {
 			/*
@@ -619,6 +631,19 @@ out_ack:
 
 		wl1271_handle_tx_low_watermark(wl);
 	}
+	if (!is_ap && wl->conf.rx_streaming.interval && had_data &&
+	    (wl->conf.rx_streaming.always ||
+	     test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags))) {
+		u32 timeout = wl->conf.rx_streaming.duration;
+
+		/* enable rx streaming */
+		if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+			ieee80211_queue_work(wl->hw,
+					     &wl->rx_streaming_enable_work);
+
+		mod_timer(&wl->rx_streaming_timer,
+			  jiffies + msecs_to_jiffies(timeout));
+	}
 }
 
 void wl1271_tx_work(struct work_struct *work)
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index fbe8f46..1cafb08 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -359,6 +359,8 @@ enum wl12xx_flags {
 	WL1271_FLAG_DUMMY_PACKET_PENDING,
 	WL1271_FLAG_SUSPENDED,
 	WL1271_FLAG_PENDING_WORK,
+	WL1271_FLAG_SOFT_GEMINI,
+	WL1271_FLAG_RX_STREAMING_STARTED,
 };
 
 struct wl1271_link {
@@ -508,6 +510,11 @@ struct wl1271 {
 	/* Default key (for WEP) */
 	u32 default_key;
 
+	/* Rx Streaming */
+	struct work_struct rx_streaming_enable_work;
+	struct work_struct rx_streaming_disable_work;
+	struct timer_list rx_streaming_timer;
+
 	unsigned int filters;
 	unsigned int rx_config;
 	unsigned int rx_filter;
@@ -601,6 +608,7 @@ struct wl1271_station {
 
 int wl1271_plt_start(struct wl1271 *wl);
 int wl1271_plt_stop(struct wl1271 *wl);
+int wl1271_recalc_rx_streaming(struct wl1271 *wl);
 
 #define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
 
-- 
1.7.0.4

