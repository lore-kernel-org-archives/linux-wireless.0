Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51460 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbZKBSWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 13:22:25 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 4/6] wl1271: Add retry implementation for PSM entries
Date: Mon,  2 Nov 2009 20:22:11 +0200
Message-Id: <1257186133-18367-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
References: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

PSM entries can fail (transmitting the corresponding null-func may not
be heard by the AP.) Previously, this scenario was not detected, and
out-of-sync between STA and AP could occur.

Add retry implementation for the entries to recover from the situation.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h       |    3 ++
 drivers/net/wireless/wl12xx/wl1271_boot.c  |    3 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h  |    8 ++++
 drivers/net/wireless/wl12xx/wl1271_event.c |   53 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_event.h |    7 ++++
 drivers/net/wireless/wl12xx/wl1271_main.c  |    5 ++-
 6 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 566f152..94359b1 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -417,6 +417,9 @@ struct wl1271 {
 	/* PSM mode requested */
 	bool psm_requested;
 
+	/* retry counter for PSM entries */
+	u8 psm_entry_retry;
+
 	/* in dBm */
 	int power_level;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 8678bea..b7c9645 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -407,7 +407,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 
 	/* unmask required mbox events  */
 	wl->event_mask = BSS_LOSE_EVENT_ID |
-		SCAN_COMPLETE_EVENT_ID;
+		SCAN_COMPLETE_EVENT_ID |
+		PS_REPORT_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 061d475..565373e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -712,6 +712,14 @@ struct conf_conn_settings {
 	 * Range 0 - 255
 	 */
 	u8 bet_max_consecutive;
+
+	/*
+	 * Specifies the maximum number of times to try PSM entry if it fails
+	 * (if sending the appropriate null-func message fails.)
+	 *
+	 * Range 0 - 255
+	 */
+	u8 psm_entry_retries;
 };
 
 #define CONF_SR_ERR_TBL_MAX_VALUES   14
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 31d396b..e135d89 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -68,6 +68,40 @@ static int wl1271_event_scan_complete(struct wl1271 *wl,
 	return 0;
 }
 
+static int wl1271_event_ps_report(struct wl1271 *wl,
+				  struct event_mailbox *mbox,
+				  bool *beacon_loss)
+{
+	int ret = 0;
+
+	wl1271_debug(DEBUG_EVENT, "ps_status: 0x%x", mbox->ps_status);
+
+	switch (mbox->ps_status) {
+	case EVENT_ENTER_POWER_SAVE_FAIL:
+		if (wl->psm_entry_retry < wl->conf.conn.psm_entry_retries) {
+			wl->psm_entry_retry++;
+			wl1271_error("PSM entry failed, retrying %d\n",
+				     wl->psm_entry_retry);
+			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+		} else {
+			wl->psm_entry_retry = 0;
+			*beacon_loss = true;
+		}
+		break;
+	case EVENT_ENTER_POWER_SAVE_SUCCESS:
+		wl->psm_entry_retry = 0;
+		break;
+	case EVENT_EXIT_POWER_SAVE_FAIL:
+		wl1271_info("PSM exit failed");
+		break;
+	case EVENT_EXIT_POWER_SAVE_SUCCESS:
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 static void wl1271_event_mbox_dump(struct event_mailbox *mbox)
 {
 	wl1271_debug(DEBUG_EVENT, "MBOX DUMP:");
@@ -79,6 +113,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 {
 	int ret;
 	u32 vector;
+	bool beacon_loss = false;
 
 	wl1271_event_mbox_dump(mbox);
 
@@ -101,7 +136,25 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		wl1271_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
 
 		/* indicate to the stack, that beacons have been lost */
+		beacon_loss = true;
+	}
+
+	if (vector & PS_REPORT_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT, "PS_REPORT_EVENT");
+		ret = wl1271_event_ps_report(wl, mbox, &beacon_loss);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (beacon_loss) {
+		/* Obviously, it's dangerous to release the mutex while
+		   we are holding many of the variables in the wl struct.
+		   That's why it's done last in the function, and care must
+		   be taken that nothing more is done after this function
+		   returns. */
+		mutex_unlock(&wl->mutex);
 		ieee80211_beacon_loss(wl->vif);
+		mutex_lock(&wl->mutex);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.h b/drivers/net/wireless/wl12xx/wl1271_event.h
index 3ab53d3..4e3f55e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.h
+++ b/drivers/net/wireless/wl12xx/wl1271_event.h
@@ -63,6 +63,13 @@ enum {
 	EVENT_MBOX_ALL_EVENT_ID			 = 0x7fffffff,
 };
 
+enum {
+	EVENT_ENTER_POWER_SAVE_FAIL = 0,
+	EVENT_ENTER_POWER_SAVE_SUCCESS,
+	EVENT_EXIT_POWER_SAVE_FAIL,
+	EVENT_EXIT_POWER_SAVE_SUCCESS,
+};
+
 struct event_debug_report {
 	u8 debug_event_id;
 	u8 num_params;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 0ae506a..d2149fc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -222,7 +222,8 @@ static struct conf_drv_settings default_conf = {
 			.snr_pkt_avg_weight  = 10
 		},
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
-		.bet_max_consecutive         = 100
+		.bet_max_consecutive         = 100,
+		.psm_entry_retries           = 3
 	},
 	.init = {
 		.sr_err_tbl = {
@@ -973,6 +974,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->rx_counter = 0;
 	wl->elp = false;
 	wl->psm = 0;
+	wl->psm_entry_retry = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->tx_blocks_available = 0;
@@ -1822,6 +1824,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->elp = false;
 	wl->psm = 0;
 	wl->psm_requested = false;
+	wl->psm_entry_retry = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
-- 
1.5.6.5

