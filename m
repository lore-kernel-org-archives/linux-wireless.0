Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab1JJIMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:55 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:54 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/29] wl12xx: rearm rx streaming per vif
Date: Mon, 10 Oct 2011 10:12:59 +0200
Message-Id: <1318234397-21081-12-git-send-email-eliad@wizery.com> (sfid-20111010_101257_737067_D12D034A)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the rx streaming doesn't support multi-vif
(the actual wlvif is taken from wl->vif, and the management
is global).

Make the rx streaming timers/works per-vif, and pass the
the actual vif as param.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c     |    5 +-
 drivers/net/wireless/wl12xx/acx.h     |    3 +-
 drivers/net/wireless/wl12xx/debugfs.c |   10 ++++-
 drivers/net/wireless/wl12xx/event.c   |    4 +-
 drivers/net/wireless/wl12xx/main.c    |   53 ++++++++++++++------------
 drivers/net/wireless/wl12xx/rx.c      |   35 ++++++-----------
 drivers/net/wireless/wl12xx/tx.c      |   67 ++++++++++++++++++++++----------
 drivers/net/wireless/wl12xx/tx.h      |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h  |   12 +++---
 9 files changed, 109 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 5b70cc1..21e74ca 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1510,10 +1510,9 @@ out:
 	return ret;
 }
 
-int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable)
+int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			       bool enable)
 {
-	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_acx_ps_rx_streaming *rx_streaming;
 	u32 conf_queues, enable_queues;
 	int i, ret = 0;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 7fccfcc..c06119b 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1310,7 +1310,8 @@ int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl,
 int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
 				       u16 ssn, bool enable, u8 peer_hlid);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
-int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable);
+int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			       bool enable);
 int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_acx_config_ps(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 669b081..4abff82 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -505,6 +505,7 @@ static ssize_t rx_streaming_interval_write(struct file *file,
 			   size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
+	struct wl12xx_vif *wlvif;
 	unsigned long value;
 	int ret;
 
@@ -528,7 +529,9 @@ static ssize_t rx_streaming_interval_write(struct file *file,
 	if (ret < 0)
 		goto out;
 
-	wl1271_recalc_rx_streaming(wl);
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		wl1271_recalc_rx_streaming(wl, wlvif);
+	}
 
 	wl1271_ps_elp_sleep(wl);
 out:
@@ -557,6 +560,7 @@ static ssize_t rx_streaming_always_write(struct file *file,
 			   size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
+	struct wl12xx_vif *wlvif;
 	unsigned long value;
 	int ret;
 
@@ -580,7 +584,9 @@ static ssize_t rx_streaming_always_write(struct file *file,
 	if (ret < 0)
 		goto out;
 
-	wl1271_recalc_rx_streaming(wl);
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		wl1271_recalc_rx_streaming(wl, wlvif);
+	}
 
 	wl1271_ps_elp_sleep(wl);
 out:
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index dbc40bb..be9e112 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -220,12 +220,12 @@ static void wl12xx_event_soft_gemini_sense(struct wl1271 *wl,
 		}
 		set_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags);
 	} else {
+		clear_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags);
 		wl12xx_for_each_wlvif_sta(wl, wlvif) {
 			vif = wl12xx_wlvif_to_vif(wlvif);
 			ieee80211_enable_dyn_ps(vif);
+			wl1271_recalc_rx_streaming(wl, wlvif);
 		}
-		clear_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags);
-		wl1271_recalc_rx_streaming(wl);
 	}
 
 }
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 055e70a..e242c50 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -502,12 +502,13 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
 	return 0;
 }
 
-static int wl1271_set_rx_streaming(struct wl1271 *wl, bool enable)
+static int wl1271_set_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				   bool enable)
 {
 	int ret = 0;
 
 	/* we should hold wl->mutex */
-	ret = wl1271_acx_ps_rx_streaming(wl, enable);
+	ret = wl1271_acx_ps_rx_streaming(wl, wlvif, enable);
 	if (ret < 0)
 		goto out;
 
@@ -523,7 +524,7 @@ out:
  * this function is being called when the rx_streaming interval
  * has beed changed or rx_streaming should be disabled
  */
-int wl1271_recalc_rx_streaming(struct wl1271 *wl)
+int wl1271_recalc_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret = 0;
 	int period = wl->conf.rx_streaming.interval;
@@ -537,11 +538,11 @@ int wl1271_recalc_rx_streaming(struct wl1271 *wl)
 	    test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) &&
 	    (wl->conf.rx_streaming.always ||
 	     test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags)))
-		ret = wl1271_set_rx_streaming(wl, true);
+		ret = wl1271_set_rx_streaming(wl, wlvif, true);
 	else {
-		ret = wl1271_set_rx_streaming(wl, false);
+		ret = wl1271_set_rx_streaming(wl, wlvif, false);
 		/* don't cancel_work_sync since we might deadlock */
-		del_timer_sync(&wl->rx_streaming_timer);
+		del_timer_sync(&wlvif->rx_streaming_timer);
 	}
 out:
 	return ret;
@@ -550,8 +551,9 @@ out:
 static void wl1271_rx_streaming_enable_work(struct work_struct *work)
 {
 	int ret;
-	struct wl1271 *wl =
-		container_of(work, struct wl1271, rx_streaming_enable_work);
+	struct wl12xx_vif *wlvif = container_of(work, struct wl12xx_vif,
+						rx_streaming_enable_work);
+	struct wl1271 *wl = wlvif->wl;
 
 	mutex_lock(&wl->mutex);
 
@@ -568,12 +570,12 @@ static void wl1271_rx_streaming_enable_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_set_rx_streaming(wl, true);
+	ret = wl1271_set_rx_streaming(wl, wlvif, true);
 	if (ret < 0)
 		goto out_sleep;
 
 	/* stop it after some time of inactivity */
-	mod_timer(&wl->rx_streaming_timer,
+	mod_timer(&wlvif->rx_streaming_timer,
 		  jiffies + msecs_to_jiffies(wl->conf.rx_streaming.duration));
 
 out_sleep:
@@ -585,8 +587,9 @@ out:
 static void wl1271_rx_streaming_disable_work(struct work_struct *work)
 {
 	int ret;
-	struct wl1271 *wl =
-		container_of(work, struct wl1271, rx_streaming_disable_work);
+	struct wl12xx_vif *wlvif = container_of(work, struct wl12xx_vif,
+						rx_streaming_disable_work);
+	struct wl1271 *wl = wlvif->wl;
 
 	mutex_lock(&wl->mutex);
 
@@ -597,7 +600,7 @@ static void wl1271_rx_streaming_disable_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_set_rx_streaming(wl, false);
+	ret = wl1271_set_rx_streaming(wl, wlvif, false);
 	if (ret)
 		goto out_sleep;
 
@@ -609,8 +612,9 @@ out:
 
 static void wl1271_rx_streaming_timer(unsigned long data)
 {
-	struct wl1271 *wl = (struct wl1271 *)data;
-	ieee80211_queue_work(wl->hw, &wl->rx_streaming_disable_work);
+	struct wl12xx_vif *wlvif = (struct wl12xx_vif *)data;
+	struct wl1271 *wl = wlvif->wl;
+	ieee80211_queue_work(wl->hw, &wlvif->rx_streaming_disable_work);
 }
 
 static void wl1271_conf_init(struct wl1271 *wl)
@@ -1827,9 +1831,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	cancel_delayed_work_sync(&wl->scan_complete_work);
 	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->tx_work);
-	del_timer_sync(&wl->rx_streaming_timer);
-	cancel_work_sync(&wl->rx_streaming_enable_work);
-	cancel_work_sync(&wl->rx_streaming_disable_work);
 	cancel_delayed_work_sync(&wl->elp_work);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
@@ -1960,9 +1961,16 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->beacon_int = WL1271_DEFAULT_BEACON_INT;
 
+	INIT_WORK(&wlvif->rx_streaming_enable_work,
+		  wl1271_rx_streaming_enable_work);
+	INIT_WORK(&wlvif->rx_streaming_disable_work,
+		  wl1271_rx_streaming_disable_work);
 	INIT_DELAYED_WORK(&wlvif->pspoll_work, wl1271_pspoll_work);
 	INIT_LIST_HEAD(&wlvif->list);
 
+	setup_timer(&wlvif->rx_streaming_timer, wl1271_rx_streaming_timer,
+		    (unsigned long) wlvif);
+
 	return 0;
 }
 
@@ -2193,6 +2201,9 @@ deinit:
 	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
 
 	mutex_unlock(&wl->mutex);
+	del_timer_sync(&wlvif->rx_streaming_timer);
+	cancel_work_sync(&wlvif->rx_streaming_enable_work);
+	cancel_work_sync(&wlvif->rx_streaming_disable_work);
 	cancel_delayed_work_sync(&wlvif->pspoll_work);
 
 	mutex_lock(&wl->mutex);
@@ -4893,10 +4904,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	INIT_WORK(&wl->tx_work, wl1271_tx_work);
 	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
 	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
-	INIT_WORK(&wl->rx_streaming_enable_work,
-		  wl1271_rx_streaming_enable_work);
-	INIT_WORK(&wl->rx_streaming_disable_work,
-		  wl1271_rx_streaming_disable_work);
 
 	wl->freezable_wq = create_freezable_workqueue("wl12xx_wq");
 	if (!wl->freezable_wq) {
@@ -4920,8 +4927,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->active_sta_count = 0;
-	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
-		    (unsigned long) wl);
 	wl->fwlog_size = 0;
 	init_waitqueue_head(&wl->fwlog_waitq);
 
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 9cfa0b2..dd2f8b7 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -28,6 +28,7 @@
 #include "acx.h"
 #include "reg.h"
 #include "rx.h"
+#include "tx.h"
 #include "io.h"
 
 static u8 wl12xx_rx_get_mem_block(struct wl12xx_fw_status *status,
@@ -96,7 +97,7 @@ static void wl1271_rx_status(struct wl1271 *wl,
 }
 
 static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
-				 bool unaligned)
+				 bool unaligned, u8 *hlid)
 {
 	struct wl1271_rx_descriptor *desc;
 	struct sk_buff *skb;
@@ -159,6 +160,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	 * payload aligned to 4 bytes.
 	 */
 	memcpy(buf, data + sizeof(*desc), length - sizeof(*desc));
+	*hlid = desc->hlid;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (ieee80211_is_beacon(hdr->frame_control))
@@ -169,10 +171,10 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	wl1271_rx_status(wl, desc, IEEE80211_SKB_RXCB(skb), beacon);
 
 	seq_num = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
-	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s seq %d", skb,
+	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s seq %d hlid %d", skb,
 		     skb->len - desc->pad_len,
 		     beacon ? "beacon" : "",
-		     seq_num);
+		     seq_num, *hlid);
 
 	skb_trim(skb, skb->len - desc->pad_len);
 
@@ -185,8 +187,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 {
 	struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
-	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
 	u32 buf_size;
 	u32 fw_rx_counter  = status->fw_rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
 	u32 drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
@@ -194,8 +195,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 	u32 mem_block;
 	u32 pkt_length;
 	u32 pkt_offset;
-	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
-	bool had_data = false;
+	u8 hlid;
 	bool unaligned = false;
 
 	while (drv_rx_counter != fw_rx_counter) {
@@ -255,8 +255,11 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 			 */
 			if (wl1271_rx_handle_data(wl,
 						  wl->aggr_buf + pkt_offset,
-						  pkt_length, unaligned) == 1)
-				had_data = true;
+						  pkt_length, unaligned,
+						  &hlid) == 1) {
+				WARN_ON(hlid >= WL12XX_MAX_LINKS);
+				__set_bit(hlid, active_hlids);
+			}
 
 			wl->rx_counter++;
 			drv_rx_counter++;
@@ -272,17 +275,5 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 	if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
 		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 
-	if (!is_ap && wl->conf.rx_streaming.interval && had_data &&
-	    (wl->conf.rx_streaming.always ||
-	     test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags))) {
-		u32 timeout = wl->conf.rx_streaming.duration;
-
-		/* restart rx streaming */
-		if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
-			ieee80211_queue_work(wl->hw,
-					     &wl->rx_streaming_enable_work);
-
-		mod_timer(&wl->rx_streaming_timer,
-			  jiffies + msecs_to_jiffies(timeout));
-	}
+	wl12xx_rearm_rx_streaming(wl, active_hlids);
 }
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 0a5fef5..91689d0 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -643,21 +643,58 @@ static bool wl1271_tx_is_data_present(struct sk_buff *skb)
 	return ieee80211_is_data_present(hdr->frame_control);
 }
 
+void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids)
+{
+	struct wl12xx_vif *wlvif;
+	u32 timeout;
+	u8 hlid;
+
+	if (!wl->conf.rx_streaming.interval)
+		return;
+
+	if (!wl->conf.rx_streaming.always &&
+	    !test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags))
+		return;
+
+	timeout = wl->conf.rx_streaming.duration;
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		bool found = false;
+		for_each_set_bit(hlid, active_hlids, WL12XX_MAX_LINKS) {
+			if (test_bit(hlid, wlvif->links_map)) {
+				found  = true;
+				break;
+			}
+		}
+
+		if (!found)
+			continue;
+
+		/* enable rx streaming */
+		if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
+			ieee80211_queue_work(wl->hw,
+					     &wlvif->rx_streaming_enable_work);
+
+		mod_timer(&wlvif->rx_streaming_timer,
+			  jiffies + msecs_to_jiffies(timeout));
+	}
+}
+
 void wl1271_tx_work_locked(struct wl1271 *wl)
 {
 	struct wl12xx_vif *wlvif;
 	struct sk_buff *skb;
+	struct wl1271_tx_hw_descr *desc;
 	u32 buf_offset = 0;
 	bool sent_packets = false;
-	bool had_data = false;
-	/* TODO: save bitmap of relevant stations */
-	bool is_sta = false;
+	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
 	int ret;
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		return;
 
 	while ((skb = wl1271_skb_dequeue(wl))) {
+		bool has_data = false;
+
 		wlvif = NULL;
 		if (!wl12xx_is_dummy_packet(wl, skb)) {
 			struct ieee80211_tx_info *info;
@@ -667,9 +704,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 			vif = info->control.vif;
 			wlvif = wl12xx_vif_to_data(vif);
 		}
-
-		if (wl1271_tx_is_data_present(skb))
-			had_data = true;
+		has_data = wlvif && wl1271_tx_is_data_present(skb);
 
 		ret = wl1271_prepare_tx_frame(wl, wlvif, skb, buf_offset);
 		if (ret == -EAGAIN) {
@@ -698,8 +733,10 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 		}
 		buf_offset += ret;
 		wl->tx_packets_count++;
-		if (wlvif && wlvif->bss_type == BSS_TYPE_STA_BSS)
-			is_sta = true;
+		if (has_data) {
+			desc = (struct wl1271_tx_hw_descr *) skb->data;
+			__set_bit(desc->hlid, active_hlids);
+		}
 	}
 
 out_ack:
@@ -719,19 +756,7 @@ out_ack:
 
 		wl1271_handle_tx_low_watermark(wl);
 	}
-	if (is_sta && wl->conf.rx_streaming.interval && had_data &&
-	    (wl->conf.rx_streaming.always ||
-	     test_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags))) {
-		u32 timeout = wl->conf.rx_streaming.duration;
-
-		/* enable rx streaming */
-		if (!test_bit(WL1271_FLAG_RX_STREAMING_STARTED, &wl->flags))
-			ieee80211_queue_work(wl->hw,
-					     &wl->rx_streaming_enable_work);
-
-		mod_timer(&wl->rx_streaming_timer,
-			  jiffies + msecs_to_jiffies(timeout));
-	}
+	wl12xx_rearm_rx_streaming(wl, active_hlids);
 }
 
 void wl1271_tx_work(struct work_struct *work)
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index fe29ff5..2dbb24e 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -220,6 +220,7 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
 bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb);
+void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids);
 
 /* from main.c */
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index f12b394..9e44430 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -478,11 +478,6 @@ struct wl1271 {
 	/* The current band */
 	enum ieee80211_band band;
 
-	/* Rx Streaming */
-	struct work_struct rx_streaming_enable_work;
-	struct work_struct rx_streaming_disable_work;
-	struct timer_list rx_streaming_timer;
-
 	struct completion *elp_compl;
 	struct delayed_work elp_work;
 
@@ -633,6 +628,11 @@ struct wl12xx_vif {
 	bool ba_support;
 	bool ba_allowed;
 
+	/* Rx Streaming */
+	struct work_struct rx_streaming_enable_work;
+	struct work_struct rx_streaming_disable_work;
+	struct timer_list rx_streaming_timer;
+
 	/*
 	 * This struct must be last!
 	 * data that has to be saved acrossed reconfigs (e.g. recovery)
@@ -679,7 +679,7 @@ struct ieee80211_vif *wl12xx_wlvif_to_vif(struct wl12xx_vif *wlvif)
 
 int wl1271_plt_start(struct wl1271 *wl);
 int wl1271_plt_stop(struct wl1271 *wl);
-int wl1271_recalc_rx_streaming(struct wl1271 *wl);
+int wl1271_recalc_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl12xx_queue_recovery_work(struct wl1271 *wl);
 size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen);
 
-- 
1.7.6.401.g6a319

