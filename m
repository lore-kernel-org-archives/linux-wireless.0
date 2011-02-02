Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46343 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1BBJM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 04:12:26 -0500
Received: by wyb28 with SMTP id 28so7633693wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 01:12:24 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] wl12xx: add automatic rx streaming support
Date: Wed,  2 Feb 2011 11:12:18 +0200
Message-Id: <1296637939-26729-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1296637939-26729-1-git-send-email-eliad@wizery.com>
References: <1296637939-26729-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when rx_streaming.interval is non-zero, use automatic rx streaming.
we enable rx streaming on the each rx/tx packet, and disable it
rx_streaming.duration msecs later.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |  126 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/rx.c     |   13 ++++
 drivers/net/wireless/wl12xx/tx.c     |   11 +++
 drivers/net/wireless/wl12xx/wl12xx.h |    9 ++-
 4 files changed, 158 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ff991c9..ad8bbc2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -419,6 +419,121 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
 	return 0;
 }
 
+static int wl1271_set_rx_streaming(struct wl1271 *wl, bool enable)
+{
+	int ret = 0;
+
+	/* we should hold wl->mutex */
+	if (enable) {
+		wl->conf.rx_streaming.queues = 0xff;
+		ret = wl1271_acx_ps_rx_streaming(wl);
+		if (!ret)
+			set_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags);
+	} else {
+		wl->conf.rx_streaming.queues = 0;
+		ret = wl1271_acx_ps_rx_streaming(wl);
+		if (!ret)
+			clear_bit(WL1271_FLAG_RX_STREAMING_STARTED,
+				  &wl->flags);
+	}
+
+	return ret;
+}
+
+/*
+ * this function is being called when the rx_streaming interval
+ * has beed changed
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
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	/* reconfigure/disable according to new streaming_period */
+	if (period)
+		ret = wl1271_set_rx_streaming(wl, true);
+	else {
+		ret = wl1271_set_rx_streaming(wl, false);
+		/* don't cancel_work_sync since we might deadlock */
+		del_timer_sync(&wl->rx_streaming_timer);
+	}
+
+	wl1271_ps_elp_sleep(wl);
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
+	if (test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+		goto out;
+
+	if (!wl->conf.rx_streaming.interval)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
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
+	ret = wl1271_ps_elp_wakeup(wl, false);
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
 
@@ -3302,6 +3417,11 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
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
@@ -3321,6 +3441,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->bss_type = MAX_BSS_TYPE;
 	wl->set_bss_type = MAX_BSS_TYPE;
 	wl->fw_bss_type = MAX_BSS_TYPE;
+	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
+		    (unsigned long) wl);
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
@@ -3389,6 +3511,10 @@ EXPORT_SYMBOL_GPL(wl1271_alloc_hw);
 
 int wl1271_free_hw(struct wl1271 *wl)
 {
+	del_timer_sync(&wl->rx_streaming_timer);
+	cancel_work_sync(&wl->rx_streaming_enable_work);
+	cancel_work_sync(&wl->rx_streaming_disable_work);
+
 	platform_device_unregister(wl->plat_dev);
 	free_pages((unsigned long)wl->aggr_buf,
 			get_order(WL1271_AGGR_BUFFER_SIZE));
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 029597b..0846242 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -144,6 +144,7 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 	u32 mem_block;
 	u32 pkt_length;
 	u32 pkt_offset;
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 
 	while (drv_rx_counter != fw_rx_counter) {
 		buf_size = 0;
@@ -199,6 +200,18 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 		}
 	}
 	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
+
+	if (!is_ap && wl->conf.rx_streaming.interval) {
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
index 67a0094..797a449 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -336,6 +336,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 	bool woken_up = false;
 	u32 buf_offset = 0;
 	bool sent_packets = false;
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 	int ret;
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
@@ -389,7 +390,17 @@ out_ack:
 		wl1271_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
 		handle_tx_low_watermark(wl);
 	}
+	if (!is_ap && wl->conf.rx_streaming.interval) {
+		u32 timeout = wl->conf.rx_streaming.duration;
+
+		/* enable rx streaming */
+		if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+			ieee80211_queue_work(wl->hw,
+					     &wl->rx_streaming_enable_work);
 
+		mod_timer(&wl->rx_streaming_timer,
+			  jiffies + msecs_to_jiffies(timeout));
+	}
 out:
 	if (woken_up)
 		wl1271_ps_elp_sleep(wl);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 15d9e9e..f2ec0f9 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -316,7 +316,8 @@ enum wl12xx_flags {
 	WL1271_FLAG_PSPOLL_FAILURE,
 	WL1271_FLAG_STA_STATE_SENT,
 	WL1271_FLAG_FW_TX_BUSY,
-	WL1271_FLAG_AP_STARTED
+	WL1271_FLAG_AP_STARTED,
+	WL1271_FLAG_RX_STREAMING_STARTED
 };
 
 struct wl1271 {
@@ -443,6 +444,11 @@ struct wl1271 {
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
@@ -506,6 +512,7 @@ struct wl1271_station {
 
 int wl1271_plt_start(struct wl1271 *wl);
 int wl1271_plt_stop(struct wl1271 *wl);
+int wl1271_recalc_rx_streaming(struct wl1271 *wl);
 
 #define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
 
-- 
1.7.0.4

