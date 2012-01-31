Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41118 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab2AaJyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 04:54:09 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so172570wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 01:54:09 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 05/10] wl12xx: remove PS management code
Date: Tue, 31 Jan 2012 11:57:20 +0200
Message-Id: <1328003845-3926-6-git-send-email-eliad@wizery.com> (sfid-20120131_105422_095680_0412D3B2)
In-Reply-To: <1328003845-3926-1-git-send-email-eliad@wizery.com>
References: <1328003845-3926-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Removal of PS management code from the driver as PS
is handled by the FW (dynamic PS)

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c    |    1 -
 drivers/net/wireless/wl12xx/conf.h    |    7 --
 drivers/net/wireless/wl12xx/debugfs.c |    1 -
 drivers/net/wireless/wl12xx/event.c   |  143 ---------------------------------
 drivers/net/wireless/wl12xx/event.h   |    5 +-
 drivers/net/wireless/wl12xx/main.c    |   81 +------------------
 drivers/net/wireless/wl12xx/wl12xx.h  |    6 --
 7 files changed, 5 insertions(+), 239 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 7843028..8e698c8 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -507,7 +507,6 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	/* unmask required mbox events  */
 	wl->event_mask = BSS_LOSE_EVENT_ID |
 		SCAN_COMPLETE_EVENT_ID |
-		PS_REPORT_EVENT_ID |
 		ROLE_STOP_COMPLETE_EVENT_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 1bcfb01..47cf80f 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -868,13 +868,6 @@ struct conf_conn_settings {
 	u8 ps_poll_threshold;
 
 	/*
-	 * PS Poll failure recovery ACTIVE period length
-	 *
-	 * Range: u32 (ms)
-	 */
-	u32 ps_poll_recovery_period;
-
-	/*
 	 * Configuration of signal average weights.
 	 */
 	struct conf_sig_weights sig_weights;
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 15eb3a9..5e96e05 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -471,7 +471,6 @@ static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
 		VIF_STATE_PRINT_INT(default_key);
 		VIF_STATE_PRINT_INT(aid);
 		VIF_STATE_PRINT_INT(session_counter);
-		VIF_STATE_PRINT_INT(ps_poll_failures);
 		VIF_STATE_PRINT_INT(psm_entry_retry);
 		VIF_STATE_PRINT_INT(power_level);
 		VIF_STATE_PRINT_INT(rssi_thold);
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index d3280df68..2ec5d21 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -30,133 +30,6 @@
 #include "scan.h"
 #include "wl12xx_80211.h"
 
-void wl1271_pspoll_work(struct work_struct *work)
-{
-	struct ieee80211_vif *vif;
-	struct wl12xx_vif *wlvif;
-	struct delayed_work *dwork;
-	struct wl1271 *wl;
-	int ret;
-
-	dwork = container_of(work, struct delayed_work, work);
-	wlvif = container_of(dwork, struct wl12xx_vif, pspoll_work);
-	vif = container_of((void *)wlvif, struct ieee80211_vif, drv_priv);
-	wl = wlvif->wl;
-
-	wl1271_debug(DEBUG_EVENT, "pspoll work");
-
-	mutex_lock(&wl->mutex);
-
-	if (unlikely(wl->state == WL1271_STATE_OFF))
-		goto out;
-
-	if (!test_and_clear_bit(WLVIF_FLAG_PSPOLL_FAILURE, &wlvif->flags))
-		goto out;
-
-	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-		goto out;
-
-	/*
-	 * if we end up here, then we were in powersave when the pspoll
-	 * delivery failure occurred, and no-one changed state since, so
-	 * we should go back to powersave.
-	 */
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	wl1271_ps_set_mode(wl, wlvif, STATION_POWER_SAVE_MODE,
-			   wlvif->basic_rate, true);
-
-	wl1271_ps_elp_sleep(wl);
-out:
-	mutex_unlock(&wl->mutex);
-};
-
-static void wl1271_event_pspoll_delivery_fail(struct wl1271 *wl,
-					      struct wl12xx_vif *wlvif)
-{
-	int delay = wl->conf.conn.ps_poll_recovery_period;
-	int ret;
-
-	wlvif->ps_poll_failures++;
-	if (wlvif->ps_poll_failures == 1)
-		wl1271_info("AP with dysfunctional ps-poll, "
-			    "trying to work around it.");
-
-	/* force active mode receive data from the AP */
-	if (test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
-		ret = wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE,
-					 wlvif->basic_rate, true);
-		if (ret < 0)
-			return;
-		set_bit(WLVIF_FLAG_PSPOLL_FAILURE, &wlvif->flags);
-		ieee80211_queue_delayed_work(wl->hw, &wlvif->pspoll_work,
-					     msecs_to_jiffies(delay));
-	}
-
-	/*
-	 * If already in active mode, lets we should be getting data from
-	 * the AP right away. If we enter PSM too fast after this, and data
-	 * remains on the AP, we will get another event like this, and we'll
-	 * go into active once more.
-	 */
-}
-
-static int wl1271_event_ps_report(struct wl1271 *wl,
-				  struct wl12xx_vif *wlvif,
-				  struct event_mailbox *mbox,
-				  bool *beacon_loss)
-{
-	int ret = 0;
-	u32 total_retries = wl->conf.conn.psm_entry_retries;
-
-	wl1271_debug(DEBUG_EVENT, "ps_status: 0x%x", mbox->ps_status);
-
-	switch (mbox->ps_status) {
-	case EVENT_ENTER_POWER_SAVE_FAIL:
-		wl1271_debug(DEBUG_PSM, "PSM entry failed");
-
-		if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
-			/* remain in active mode */
-			wlvif->psm_entry_retry = 0;
-			break;
-		}
-
-		if (wlvif->psm_entry_retry < total_retries) {
-			wlvif->psm_entry_retry++;
-			ret = wl1271_ps_set_mode(wl, wlvif,
-						 STATION_POWER_SAVE_MODE,
-						 wlvif->basic_rate, true);
-		} else {
-			wl1271_info("No ack to nullfunc from AP.");
-			wlvif->psm_entry_retry = 0;
-			*beacon_loss = true;
-		}
-		break;
-	case EVENT_ENTER_POWER_SAVE_SUCCESS:
-		wlvif->psm_entry_retry = 0;
-
-		/*
-		 * BET has only a minor effect in 5GHz and masks
-		 * channel switch IEs, so we only enable BET on 2.4GHz
-		*/
-		if (wlvif->band == IEEE80211_BAND_2GHZ)
-			/* enable beacon early termination */
-			ret = wl1271_acx_bet_enable(wl, wlvif, true);
-
-		if (wlvif->ps_compl) {
-			complete(wlvif->ps_compl);
-			wlvif->ps_compl = NULL;
-		}
-		break;
-	default:
-		break;
-	}
-
-	return ret;
-}
-
 static void wl1271_event_rssi_trigger(struct wl1271 *wl,
 				      struct wl12xx_vif *wlvif,
 				      struct event_mailbox *mbox)
@@ -237,7 +110,6 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 {
 	struct ieee80211_vif *vif;
 	struct wl12xx_vif *wlvif;
-	int ret;
 	u32 vector;
 	bool beacon_loss = false;
 	bool disconnect_sta = false;
@@ -293,21 +165,6 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		beacon_loss = true;
 	}
 
-	if (vector & PS_REPORT_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT, "PS_REPORT_EVENT");
-		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			ret = wl1271_event_ps_report(wl, wlvif,
-						     mbox, &beacon_loss);
-			if (ret < 0)
-				return ret;
-		}
-	}
-
-	if (vector & PSPOLL_DELIVERY_FAILURE_EVENT_ID)
-		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			wl1271_event_pspoll_delivery_fail(wl, wlvif);
-		}
-
 	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID) {
 		/* TODO: check actual multi-role support */
 		wl1271_debug(DEBUG_EVENT, "RSSI_SNR_TRIGGER_0_EVENT");
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index b41f730..057d193 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -51,7 +51,7 @@ enum {
 	SCAN_COMPLETE_EVENT_ID			 = BIT(10),
 	WFD_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(11),
 	AP_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(12),
-	PS_REPORT_EVENT_ID			 = BIT(13),
+	RESERVED1			         = BIT(13),
 	PSPOLL_DELIVERY_FAILURE_EVENT_ID	 = BIT(14),
 	ROLE_STOP_COMPLETE_EVENT_ID		 = BIT(15),
 	RADAR_DETECTED_EVENT_ID                  = BIT(16),
@@ -96,7 +96,7 @@ struct event_mailbox {
 	s8 rssi_snr_trigger_metric[NUM_OF_RSSI_SNR_TRIGGERS];
 	u8 change_auto_mode_timeout;
 	u8 scheduled_scan_status;
-	u8 ps_status;
+	u8 reserved4;
 	/* tuned channel (roc) */
 	u8 roc_channel;
 
@@ -135,6 +135,5 @@ struct event_mailbox {
 int wl1271_event_unmask(struct wl1271 *wl);
 void wl1271_event_mbox_config(struct wl1271 *wl);
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
-void wl1271_pspoll_work(struct work_struct *work);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85604b4..cb0d7b7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -235,7 +235,6 @@ static struct conf_drv_settings default_conf = {
 		.broadcast_timeout           = 20000,
 		.rx_broadcast_in_ps          = 1,
 		.ps_poll_threshold           = 10,
-		.ps_poll_recovery_period     = 700,
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
 		.bet_max_consecutive         = 50,
 		.psm_entry_retries           = 8,
@@ -1560,57 +1559,6 @@ static struct notifier_block wl1271_dev_notifier = {
 };
 
 #ifdef CONFIG_PM
-static int wl1271_configure_suspend_sta(struct wl1271 *wl,
-					struct wl12xx_vif *wlvif)
-{
-	int ret = 0;
-
-	mutex_lock(&wl->mutex);
-
-	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-		goto out_unlock;
-
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out_unlock;
-
-	/* enter psm if needed*/
-	if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
-		DECLARE_COMPLETION_ONSTACK(compl);
-
-		wlvif->ps_compl = &compl;
-		ret = wl1271_ps_set_mode(wl, wlvif, STATION_POWER_SAVE_MODE,
-				   wlvif->basic_rate, true);
-		if (ret < 0)
-			goto out_sleep;
-
-		/* we must unlock here so we will be able to get events */
-		wl1271_ps_elp_sleep(wl);
-		mutex_unlock(&wl->mutex);
-
-		ret = wait_for_completion_timeout(
-			&compl, msecs_to_jiffies(WL1271_PS_COMPLETE_TIMEOUT));
-
-		mutex_lock(&wl->mutex);
-		if (ret <= 0) {
-			wl1271_warning("couldn't enter ps mode!");
-			ret = -EBUSY;
-			goto out_cleanup;
-		}
-
-		ret = wl1271_ps_elp_wakeup(wl);
-		if (ret < 0)
-			goto out_cleanup;
-	}
-out_sleep:
-	wl1271_ps_elp_sleep(wl);
-out_cleanup:
-	wlvif->ps_compl = NULL;
-out_unlock:
-	mutex_unlock(&wl->mutex);
-	return ret;
-
-}
 
 static int wl1271_configure_suspend_ap(struct wl1271 *wl,
 				       struct wl12xx_vif *wlvif)
@@ -1638,8 +1586,6 @@ out_unlock:
 static int wl1271_configure_suspend(struct wl1271 *wl,
 				    struct wl12xx_vif *wlvif)
 {
-	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
-		return wl1271_configure_suspend_sta(wl, wlvif);
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl1271_configure_suspend_ap(wl, wlvif);
 	return 0;
@@ -1649,10 +1595,9 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 				    struct wl12xx_vif *wlvif)
 {
 	int ret;
-	bool is_sta = wlvif->bss_type == BSS_TYPE_STA_BSS;
 	bool is_ap = wlvif->bss_type == BSS_TYPE_AP_BSS;
 
-	if (!is_sta && !is_ap)
+	if (!is_ap)
 		return;
 
 	mutex_lock(&wl->mutex);
@@ -1660,14 +1605,7 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
-	if (is_sta) {
-		/* exit psm if it wasn't configured */
-		if (!test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags))
-			wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE,
-					   wlvif->basic_rate, true);
-	} else if (is_ap) {
-		wl1271_acx_beacon_filter_opt(wl, wlvif, false);
-	}
+	wl1271_acx_beacon_filter_opt(wl, wlvif, false);
 
 	wl1271_ps_elp_sleep(wl);
 out:
@@ -1709,9 +1647,6 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 
 	wl1271_enable_interrupts(wl);
 	flush_work(&wl->tx_work);
-	wl12xx_for_each_wlvif(wl, wlvif) {
-		flush_delayed_work(&wlvif->pspoll_work);
-	}
 	flush_delayed_work(&wl->elp_work);
 
 	return 0;
@@ -1971,7 +1906,6 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 		  wl1271_rx_streaming_enable_work);
 	INIT_WORK(&wlvif->rx_streaming_disable_work,
 		  wl1271_rx_streaming_disable_work);
-	INIT_DELAYED_WORK(&wlvif->pspoll_work, wl1271_pspoll_work);
 	INIT_LIST_HEAD(&wlvif->list);
 
 	setup_timer(&wlvif->rx_streaming_timer, wl1271_rx_streaming_timer,
@@ -2252,10 +2186,10 @@ deinit:
 		wl->sta_count--;
 
 	mutex_unlock(&wl->mutex);
+
 	del_timer_sync(&wlvif->rx_streaming_timer);
 	cancel_work_sync(&wlvif->rx_streaming_enable_work);
 	cancel_work_sync(&wlvif->rx_streaming_disable_work);
-	cancel_delayed_work_sync(&wlvif->pspoll_work);
 
 	mutex_lock(&wl->mutex);
 }
@@ -2502,13 +2436,6 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		}
 	}
 
-	/*
-	 * if mac80211 changes the PSM mode, make sure the mode is not
-	 * incorrectly changed after the pspoll failure active window.
-	 */
-	if (changed & IEEE80211_CONF_CHANGE_PS)
-		clear_bit(WLVIF_FLAG_PSPOLL_FAILURE, &wlvif->flags);
-
 	if (conf->flags & IEEE80211_CONF_PS &&
 	    !test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags)) {
 		set_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags);
@@ -3682,8 +3609,6 @@ sta_not_found:
 			wlvif->aid = bss_conf->aid;
 			set_assoc = true;
 
-			wlvif->ps_poll_failures = 0;
-
 			/*
 			 * use basic rates from AP, and determine lowest rate
 			 * to use with control frames.
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 6e025ca..af1cedc 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -560,12 +560,6 @@ struct wl12xx_vif {
 	/* Session counter for the chipset */
 	int session_counter;
 
-	struct completion *ps_compl;
-	struct delayed_work pspoll_work;
-
-	/* counter for ps-poll delivery failures */
-	int ps_poll_failures;
-
 	/* retry counter for PSM entries */
 	u8 psm_entry_retry;
 
-- 
1.7.6.401.g6a319

