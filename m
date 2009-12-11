Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63573 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762629AbZLKLmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:42:10 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 28/31] wl1271: Change booleans in struct wl1271 into a flags bitmask
Date: Fri, 11 Dec 2009 13:41:19 +0200
Message-Id: <1260531682-4695-29-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

For cleaner implementation, change the bunch of booleans in the struct wl1271
structure into a flags bitmask.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h         |   23 ++++---------
 drivers/net/wireless/wl12xx/wl1271_cmd.c     |    6 ++--
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |   13 ++++++--
 drivers/net/wireless/wl12xx/wl1271_event.c   |   11 +++---
 drivers/net/wireless/wl12xx/wl1271_main.c    |   45 ++++++++++---------------
 drivers/net/wireless/wl12xx/wl1271_ps.c      |   15 ++++----
 drivers/net/wireless/wl12xx/wl1271_tx.c      |    6 ++--
 7 files changed, 55 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 9290c92..d0938db 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -324,6 +324,13 @@ struct wl1271 {
 
 #define WL1271_FLAG_STA_RATES_CHANGED  (0)
 #define WL1271_FLAG_STA_ASSOCIATED     (1)
+#define WL1271_FLAG_JOINED             (2)
+#define WL1271_FLAG_GPIO_POWER         (3)
+#define WL1271_FLAG_TX_QUEUE_STOPPED   (4)
+#define WL1271_FLAG_SCANNING           (5)
+#define WL1271_FLAG_IN_ELP             (6)
+#define WL1271_FLAG_PSM                (7)
+#define WL1271_FLAG_PSM_REQUESTED      (8)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
@@ -363,7 +370,6 @@ struct wl1271 {
 
 	/* Frames scheduled for transmission, not handled yet */
 	struct sk_buff_head tx_queue;
-	bool tx_queue_stopped;
 
 	struct work_struct tx_work;
 
@@ -391,7 +397,6 @@ struct wl1271 {
 	u32 mbox_ptr[2];
 
 	/* Are we currently scanning */
-	bool scanning;
 	struct wl1271_scan scan;
 
 	/* Our association ID */
@@ -411,18 +416,9 @@ struct wl1271 {
 	unsigned int rx_config;
 	unsigned int rx_filter;
 
-	/* is firmware in elp mode */
-	bool elp;
-
 	struct completion *elp_compl;
 	struct delayed_work elp_work;
 
-	/* we can be in psm, but not in elp, we have to differentiate */
-	bool psm;
-
-	/* PSM mode requested */
-	bool psm_requested;
-
 	/* retry counter for PSM entries */
 	u8 psm_entry_retry;
 
@@ -441,15 +437,10 @@ struct wl1271 {
 
 	struct ieee80211_vif *vif;
 
-	/* Used for a workaround to send disconnect before rejoining */
-	bool joined;
-
 	/* Current chipset configuration */
 	struct conf_drv_settings conf;
 
 	struct list_head list;
-
-	bool gpio_power;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 20f3e67..b5eb9ed 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -655,7 +655,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 	channels = wl->hw->wiphy->bands[ieee_band]->channels;
 	n_ch = wl->hw->wiphy->bands[ieee_band]->n_channels;
 
-	if (wl->scanning)
+	if (test_bit(WL1271_FLAG_SCANNING, &wl->flags))
 		return -EINVAL;
 
 	params = kzalloc(sizeof(*params), GFP_KERNEL);
@@ -730,7 +730,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 
 	wl1271_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
 
-	wl->scanning = true;
+	set_bit(WL1271_FLAG_SCANNING, &wl->flags);
 	if (wl1271_11a_enabled()) {
 		wl->scan.state = band;
 		if (band == WL1271_SCAN_BAND_DUAL) {
@@ -748,7 +748,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params), 0);
 	if (ret < 0) {
 		wl1271_error("SCAN failed");
-		wl->scanning = false;
+		clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.c b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
index 4eaf40c..8d7588c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
@@ -241,10 +241,12 @@ static ssize_t gpio_power_read(struct file *file, char __user *user_buf,
 			  size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
+	bool state = test_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
+
 	int res;
 	char buf[10];
 
-	res = scnprintf(buf, sizeof(buf), "%d\n", wl->gpio_power);
+	res = scnprintf(buf, sizeof(buf), "%d\n", state);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
 }
@@ -274,8 +276,13 @@ static ssize_t gpio_power_write(struct file *file,
 		goto out;
 	}
 
-	wl->set_power(!!value);
-	wl->gpio_power = !!value;
+	if (value) {
+		wl->set_power(true);
+		set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
+	} else {
+		wl->set_power(false);
+		clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
+	}
 
 out:
 	mutex_unlock(&wl->mutex);
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 8d0c18d..6ff535d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -35,7 +35,7 @@ static int wl1271_event_scan_complete(struct wl1271 *wl,
 	wl1271_debug(DEBUG_EVENT, "status: 0x%x",
 		     mbox->scheduled_scan_status);
 
-	if (wl->scanning) {
+	if (test_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
 		if (wl->scan.state == WL1271_SCAN_BAND_DUAL) {
 			wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
 						NULL, size);
@@ -43,7 +43,7 @@ static int wl1271_event_scan_complete(struct wl1271 *wl,
 			 * to the wl1271_cmd_scan function that we are not
 			 * scanning as it checks that.
 			 */
-			wl->scanning = false;
+			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
 			wl1271_cmd_scan(wl, wl->scan.ssid, wl->scan.ssid_len,
 						wl->scan.active,
 						wl->scan.high_prio,
@@ -62,7 +62,7 @@ static int wl1271_event_scan_complete(struct wl1271 *wl,
 			mutex_unlock(&wl->mutex);
 			ieee80211_scan_completed(wl->hw, false);
 			mutex_lock(&wl->mutex);
-			wl->scanning = false;
+			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
 		}
 	}
 	return 0;
@@ -78,7 +78,7 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 	switch (mbox->ps_status) {
 	case EVENT_ENTER_POWER_SAVE_FAIL:
-		if (!wl->psm) {
+		if (!test_bit(WL1271_FLAG_PSM, &wl->flags)) {
 			wl->psm_entry_retry = 0;
 			break;
 		}
@@ -135,7 +135,8 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	 * filtering) is enabled. Without PSM, the stack will receive all
 	 * beacons and can detect beacon loss by itself.
 	 */
-	if (vector & BSS_LOSE_EVENT_ID && wl->psm) {
+	if (vector & BSS_LOSE_EVENT_ID &&
+	    test_bit(WL1271_FLAG_PSM, &wl->flags)) {
 		wl1271_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
 
 		/* indicate to the stack, that beacons have been lost */
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index fe11df3..61d79ba 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -378,13 +378,13 @@ static void wl1271_disable_interrupts(struct wl1271 *wl)
 static void wl1271_power_off(struct wl1271 *wl)
 {
 	wl->set_power(false);
-	wl->gpio_power = false;
+	clear_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
 }
 
 static void wl1271_power_on(struct wl1271 *wl)
 {
 	wl->set_power(true);
-	wl->gpio_power = true;
+	set_bit(WL1271_FLAG_GPIO_POWER, &wl->flags);
 }
 
 static void wl1271_fw_status(struct wl1271 *wl,
@@ -812,7 +812,7 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		 * protected. Maybe fix this by removing the stupid
 		 * variable altogether and checking the real queue state?
 		 */
-		wl->tx_queue_stopped = true;
+		set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
 	}
 
 	return NETDEV_TX_OK;
@@ -985,11 +985,10 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 
 	WARN_ON(wl->state != WL1271_STATE_ON);
 
-	if (wl->scanning) {
+	if (test_and_clear_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
 		mutex_unlock(&wl->mutex);
 		ieee80211_scan_completed(wl->hw, true);
 		mutex_lock(&wl->mutex);
-		wl->scanning = false;
 	}
 
 	wl->state = WL1271_STATE_OFF;
@@ -1014,10 +1013,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->band = IEEE80211_BAND_2GHZ;
 
 	wl->rx_counter = 0;
-	wl->elp = false;
-	wl->psm = 0;
 	wl->psm_entry_retry = 0;
-	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->tx_blocks_available = 0;
 	wl->tx_results_count = 0;
@@ -1027,7 +1023,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->tx_security_seq_32 = 0;
 	wl->time_offset = 0;
 	wl->session_counter = 0;
-	wl->joined = false;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->sta_rate_set = 0;
 	wl->flags = 0;
@@ -1174,7 +1169,7 @@ static int wl1271_join_channel(struct wl1271 *wl, int channel)
 	if (ret < 0)
 		goto out;
 
-	wl->joined = true;
+	set_bit(WL1271_FLAG_JOINED, &wl->flags);
 
 out:
 	return ret;
@@ -1189,7 +1184,7 @@ static int wl1271_unjoin_channel(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	wl->joined = false;
+	clear_bit(WL1271_FLAG_JOINED, &wl->flags);
 	wl->channel = 0;
 	memset(wl->bssid, 0, ETH_ALEN);
 	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
@@ -1221,7 +1216,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
-		if (conf->flags & IEEE80211_CONF_IDLE && wl->joined)
+		if (conf->flags & IEEE80211_CONF_IDLE &&
+		    test_bit(WL1271_FLAG_JOINED, &wl->flags))
 			wl1271_unjoin_channel(wl);
 		else
 			wl1271_join_channel(wl, channel);
@@ -1234,11 +1230,12 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	/* if the channel changes while joined, join again */
-	if (channel != wl->channel && wl->joined)
+	if (channel != wl->channel && test_bit(WL1271_FLAG_JOINED, &wl->flags))
 		wl1271_join_channel(wl, channel);
 
-	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
-		wl->psm_requested = true;
+	if (conf->flags & IEEE80211_CONF_PS &&
+	    !test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
+		set_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags);
 
 		/*
 		 * We enter PSM only if we're already associated.
@@ -1250,12 +1247,12 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-		   wl->psm_requested) {
+		   test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags)) {
 		wl1271_info("psm disabled");
 
-		wl->psm_requested = false;
+		clear_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags);
 
-		if (wl->psm)
+		if (test_bit(WL1271_FLAG_PSM, &wl->flags))
 			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE);
 	}
 
@@ -1574,7 +1571,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				wl1271_warning("cmd join failed %d", ret);
 				goto out_sleep;
 			}
-			wl->joined = true;
+			set_bit(WL1271_FLAG_JOINED, &wl->flags);
 	}
 
 	if (wl->bss_type == BSS_TYPE_IBSS) {
@@ -1633,7 +1630,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				goto out_sleep;
 
 			/* If we want to go in PSM but we're not there yet */
-			if (wl->psm_requested && !wl->psm) {
+			if (test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags) &&
+			    !test_bit(WL1271_FLAG_PSM, &wl->flags)) {
 				mode = STATION_POWER_SAVE_MODE;
 				ret = wl1271_ps_set_mode(wl, mode);
 				if (ret < 0)
@@ -1949,24 +1947,17 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 
 	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
 	wl->channel = WL1271_DEFAULT_CHANNEL;
-	wl->scanning = false;
 	wl->default_key = 0;
 	wl->rx_counter = 0;
 	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
 	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
-	wl->elp = false;
-	wl->psm = 0;
-	wl->psm_requested = false;
 	wl->psm_entry_retry = 0;
-	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->sta_rate_set = 0;
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
-	wl->joined = false;
-	wl->gpio_power = false;
 	wl->flags = 0;
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index 507cd91..e407790 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -39,12 +39,13 @@ void wl1271_elp_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->elp || !wl->psm)
+	if (test_bit(WL1271_FLAG_IN_ELP, &wl->flags) ||
+	    !test_bit(WL1271_FLAG_PSM, &wl->flags))
 		goto out;
 
 	wl1271_debug(DEBUG_PSM, "chip to elp");
 	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
-	wl->elp = true;
+	set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -55,7 +56,7 @@ out:
 /* Routines to toggle sleep mode while in ELP */
 void wl1271_ps_elp_sleep(struct wl1271 *wl)
 {
-	if (wl->psm) {
+	if (test_bit(WL1271_FLAG_PSM, &wl->flags)) {
 		cancel_delayed_work(&wl->elp_work);
 		ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
 					msecs_to_jiffies(ELP_ENTRY_DELAY));
@@ -70,7 +71,7 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake)
 	u32 start_time = jiffies;
 	bool pending = false;
 
-	if (!wl->elp)
+	if (!test_bit(WL1271_FLAG_IN_ELP, &wl->flags))
 		return 0;
 
 	wl1271_debug(DEBUG_PSM, "waking up chip from elp");
@@ -101,7 +102,7 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake)
 		}
 	}
 
-	wl->elp = false;
+	clear_bit(WL1271_FLAG_IN_ELP, &wl->flags);
 
 	wl1271_debug(DEBUG_PSM, "wakeup time: %u ms",
 		     jiffies_to_msecs(jiffies - start_time));
@@ -143,7 +144,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
-		wl->psm = 1;
+		set_bit(WL1271_FLAG_PSM, &wl->flags);
 		break;
 	case STATION_ACTIVE_MODE:
 	default:
@@ -166,7 +167,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
-		wl->psm = 0;
+		clear_bit(WL1271_FLAG_PSM, &wl->flags);
 		break;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 75f5327..a288cc3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -277,18 +277,18 @@ void wl1271_tx_work(struct work_struct *work)
 			wl1271_debug(DEBUG_TX, "tx_work: fw buffer full, "
 				     "stop queues");
 			ieee80211_stop_queues(wl->hw);
-			wl->tx_queue_stopped = true;
+			set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
 			skb_queue_head(&wl->tx_queue, skb);
 			goto out;
 		} else if (ret < 0) {
 			dev_kfree_skb(skb);
 			goto out;
-		} else if (wl->tx_queue_stopped) {
+		} else if (test_and_clear_bit(WL1271_FLAG_TX_QUEUE_STOPPED,
+					      &wl->flags)) {
 			/* firmware buffer has space, restart queues */
 			wl1271_debug(DEBUG_TX,
 				     "complete_packet: waking queues");
 			ieee80211_wake_queues(wl->hw);
-			wl->tx_queue_stopped = false;
 		}
 	}
 
-- 
1.6.3.3

