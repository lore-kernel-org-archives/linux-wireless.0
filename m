Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40346 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0GHOub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:31 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 05/13] wl1271: Work around AP's with broken ps-poll functionality
Date: Thu,  8 Jul 2010 17:50:00 +0300
Message-Id: <1278600608-22411-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Some AP's (such as Zyxel Prestige 600) have totally broken ps-poll
functionality. When powersave is enabled, these AP's will set the TIM bit for
a STA in beacons, but when the STA responds with a ps-poll, the AP does not
respond with data.

The wl1271 firmware is able to send an indication to the host, when this
problem occurs. This patch adds implementation, which temporarily disables
power-save in response to this indication, allowing the AP to transmit whatever
data it has buffered for the STA / whatever data is inbound at that time.

This patch does not make these AP's work reliably in PSM, but improves the
chances of inbound data getting through.

The side effect of this patch is increased power consumption when using a
faulty AP.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h       |    5 ++
 drivers/net/wireless/wl12xx/wl1271_boot.c  |    3 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h  |    7 +++
 drivers/net/wireless/wl12xx/wl1271_event.c |   60 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_event.h |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c  |   14 ++++++-
 6 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 1b52ce6..cfdccdb 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -351,6 +351,7 @@ struct wl1271 {
 #define WL1271_FLAG_IRQ_RUNNING       (10)
 #define WL1271_FLAG_IDLE              (11)
 #define WL1271_FLAG_IDLE_REQUESTED    (12)
+#define WL1271_FLAG_PSPOLL_FAILURE    (13)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
@@ -445,6 +446,10 @@ struct wl1271 {
 
 	struct completion *elp_compl;
 	struct delayed_work elp_work;
+	struct delayed_work pspoll_work;
+
+	/* counter for ps-poll delivery failures */
+	int ps_poll_failures;
 
 	/* retry counter for PSM entries */
 	u8 psm_entry_retry;
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 1a36d8a..f44ccaf 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -414,7 +414,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		PS_REPORT_EVENT_ID |
 		JOIN_EVENT_COMPLETE_ID |
 		DISCONNECT_EVENT_COMPLETE_ID |
-		RSSI_SNR_TRIGGER_0_EVENT_ID;
+		RSSI_SNR_TRIGGER_0_EVENT_ID |
+		PSPOLL_DELIVERY_FAILURE_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index d046d04..84b0de7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -874,6 +874,13 @@ struct conf_conn_settings {
 	u8 ps_poll_threshold;
 
 	/*
+	 * PS Poll failure recovery ACTIVE period length
+	 *
+	 * Range: u32 (ms)
+	 */
+	u32 ps_poll_recovery_period;
+
+	/*
 	 * Configuration of signal average weights.
 	 */
 	struct conf_sig_weights sig_weights;
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index ca52cde..15f6b86 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -28,6 +28,63 @@
 #include "wl1271_ps.h"
 #include "wl12xx_80211.h"
 
+void wl1271_pspoll_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct wl1271 *wl;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wl = container_of(dwork, struct wl1271, pspoll_work);
+
+	wl1271_debug(DEBUG_EVENT, "pspoll work");
+
+	mutex_lock(&wl->mutex);
+
+	if (!test_and_clear_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags))
+		goto out;
+
+	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+		goto out;
+
+	/*
+	 * if we end up here, then we were in powersave when the pspoll
+	 * delivery failure occurred, and no-one changed state since, so
+	 * we should go back to powersave.
+	 */
+	wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE, true);
+
+out:
+	mutex_unlock(&wl->mutex);
+};
+
+static void wl1271_event_pspoll_delivery_fail(struct wl1271 *wl)
+{
+	int delay = wl->conf.conn.ps_poll_recovery_period;
+	int ret;
+
+	wl->ps_poll_failures++;
+	if (wl->ps_poll_failures == 1)
+		wl1271_info("AP with dysfunctional ps-poll, "
+			    "trying to work around it.");
+
+	/* force active mode receive data from the AP */
+	if (test_bit(WL1271_FLAG_PSM, &wl->flags)) {
+		ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE, true);
+		if (ret < 0)
+			return;
+		set_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags);
+		ieee80211_queue_delayed_work(wl->hw, &wl->pspoll_work,
+					     msecs_to_jiffies(delay));
+	}
+
+	/*
+	 * If already in active mode, lets we should be getting data from
+	 * the AP right away. If we enter PSM too fast after this, and data
+	 * remains on the AP, we will get another event like this, and we'll
+	 * go into active once more.
+	 */
+}
+
 static int wl1271_event_scan_complete(struct wl1271 *wl,
 				      struct event_mailbox *mbox)
 {
@@ -191,6 +248,9 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			return ret;
 	}
 
+	if (vector & PSPOLL_DELIVERY_FAILURE_EVENT_ID)
+		wl1271_event_pspoll_delivery_fail(wl);
+
 	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "RSSI_SNR_TRIGGER_0_EVENT");
 		if (wl->vif)
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.h b/drivers/net/wireless/wl12xx/wl1271_event.h
index 5837100..9fb5a94 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.h
+++ b/drivers/net/wireless/wl12xx/wl1271_event.h
@@ -121,5 +121,6 @@ struct event_mailbox {
 int wl1271_event_unmask(struct wl1271 *wl);
 void wl1271_event_mbox_config(struct wl1271 *wl);
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
+void wl1271_pspoll_work(struct work_struct *work);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index a37244c..8a4b17f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -233,7 +233,8 @@ static struct conf_drv_settings default_conf = {
 		.beacon_rx_timeout           = 10000,
 		.broadcast_timeout           = 20000,
 		.rx_broadcast_in_ps          = 1,
-		.ps_poll_threshold           = 20,
+		.ps_poll_threshold           = 10,
+		.ps_poll_recovery_period     = 700,
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
 		.bet_max_consecutive         = 10,
 		.psm_entry_retries           = 3,
@@ -955,6 +956,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
+	cancel_delayed_work_sync(&wl->pspoll_work);
 
 	mutex_lock(&wl->mutex);
 
@@ -1260,6 +1262,13 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl1271_warning("idle mode change failed %d", ret);
 	}
 
+	/*
+	 * if mac80211 changes the PSM mode, make sure the mode is not
+	 * incorrectly changed after the pspoll failure active window.
+	 */
+	if (changed & IEEE80211_CONF_CHANGE_PS)
+		clear_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags);
+
 	if (conf->flags & IEEE80211_CONF_PS &&
 	    !test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
 		set_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags);
@@ -1766,6 +1775,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl->aid = bss_conf->aid;
 			set_assoc = true;
 
+			wl->ps_poll_failures = 0;
+
 			/*
 			 * use basic rates from AP, and determine lowest rate
 			 * to use with control frames.
@@ -2390,6 +2401,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	skb_queue_head_init(&wl->tx_queue);
 
 	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
+	INIT_DELAYED_WORK(&wl->pspoll_work, wl1271_pspoll_work);
 	wl->channel = WL1271_DEFAULT_CHANNEL;
 	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
 	wl->default_key = 0;
-- 
1.6.3.3

