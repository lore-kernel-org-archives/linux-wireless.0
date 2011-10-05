Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41414 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934315Ab1JEJ40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:26 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so1903568bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:25 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 25/29] wl12xx: move ps_poll_failures and psm_entry_retry into wlvif
Date: Wed,  5 Oct 2011 11:56:02 +0200
Message-Id: <1317808566-18857-26-git-send-email-eliad@wizery.com> (sfid-20111005_115634_347887_10F80244)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move ps_poll_failures and psm_entry_retries into the per-interface
data, rather than being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    2 --
 drivers/net/wireless/wl12xx/event.c   |   14 +++++++-------
 drivers/net/wireless/wl12xx/main.c    |    4 +---
 drivers/net/wireless/wl12xx/wl12xx.h  |   12 ++++++------
 4 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 439db1f..cd390e0 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -351,8 +351,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(state);
 	DRIVER_STATE_PRINT_INT(channel);
 	DRIVER_STATE_PRINT_INT(band);
-	DRIVER_STATE_PRINT_INT(psm_entry_retry);
-	DRIVER_STATE_PRINT_INT(ps_poll_failures);
 	DRIVER_STATE_PRINT_INT(power_level);
 	DRIVER_STATE_PRINT_INT(rssi_thold);
 	DRIVER_STATE_PRINT_INT(last_rssi_event);
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index fac4eae..31cb43e 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -78,8 +78,8 @@ static void wl1271_event_pspoll_delivery_fail(struct wl1271 *wl,
 	int delay = wl->conf.conn.ps_poll_recovery_period;
 	int ret;
 
-	wl->ps_poll_failures++;
-	if (wl->ps_poll_failures == 1)
+	wlvif->ps_poll_failures++;
+	if (wlvif->ps_poll_failures == 1)
 		wl1271_info("AP with dysfunctional ps-poll, "
 			    "trying to work around it.");
 
@@ -118,23 +118,23 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 		if (!test_bit(WL1271_FLAG_PSM, &wl->flags)) {
 			/* remain in active mode */
-			wl->psm_entry_retry = 0;
+			wlvif->psm_entry_retry = 0;
 			break;
 		}
 
-		if (wl->psm_entry_retry < total_retries) {
-			wl->psm_entry_retry++;
+		if (wlvif->psm_entry_retry < total_retries) {
+			wlvif->psm_entry_retry++;
 			ret = wl1271_ps_set_mode(wl, wlvif,
 						 STATION_POWER_SAVE_MODE,
 						 wlvif->basic_rate, true);
 		} else {
 			wl1271_info("No ack to nullfunc from AP.");
-			wl->psm_entry_retry = 0;
+			wlvif->psm_entry_retry = 0;
 			*beacon_loss = true;
 		}
 		break;
 	case EVENT_ENTER_POWER_SAVE_SUCCESS:
-		wl->psm_entry_retry = 0;
+		wlvif->psm_entry_retry = 0;
 
 		/* enable beacon filtering */
 		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1d3ed60..20ad35d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2141,7 +2141,6 @@ deinit:
 	wl->band = IEEE80211_BAND_2GHZ;
 
 	wl->rx_counter = 0;
-	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->tx_blocks_available = 0;
 	wl->tx_allocated_blocks = 0;
@@ -3535,7 +3534,7 @@ sta_not_found:
 			wlvif->aid = bss_conf->aid;
 			set_assoc = true;
 
-			wl->ps_poll_failures = 0;
+			wlvif->ps_poll_failures = 0;
 
 			/*
 			 * use basic rates from AP, and determine lowest rate
@@ -4853,7 +4852,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 
 	wl->channel = WL1271_DEFAULT_CHANNEL;
 	wl->rx_counter = 0;
-	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index d153b24..5e976ae 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -510,12 +510,6 @@ struct wl1271 {
 	struct completion *elp_compl;
 	struct delayed_work elp_work;
 
-	/* counter for ps-poll delivery failures */
-	int ps_poll_failures;
-
-	/* retry counter for PSM entries */
-	u8 psm_entry_retry;
-
 	/* in dBm */
 	int power_level;
 
@@ -651,6 +645,12 @@ struct wl12xx_vif {
 
 	struct completion *ps_compl;
 	struct delayed_work pspoll_work;
+
+	/* counter for ps-poll delivery failures */
+	int ps_poll_failures;
+
+	/* retry counter for PSM entries */
+	u8 psm_entry_retry;
 };
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
-- 
1.7.6.401.g6a319

