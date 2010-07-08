Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40389 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab0GHOuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:46 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 08/13] wl1271: Disable dynamic PS based on BT co-ext sense events
Date: Thu,  8 Jul 2010 17:50:03 +0300
Message-Id: <1278600608-22411-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch requests mac80211 to disable dynamic PSM based on sense events
coming from the firmware. Effectively, whenever there is bluetooth traffic,
the mac80211 is forced into full PSM mode.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c  |    3 ++-
 drivers/net/wireless/wl12xx/wl1271_event.c |    9 +++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c  |    8 +++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index f44ccaf..f36430b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -415,7 +415,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		JOIN_EVENT_COMPLETE_ID |
 		DISCONNECT_EVENT_COMPLETE_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
-		PSPOLL_DELIVERY_FAILURE_EVENT_ID;
+		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
+		SOFT_GEMINI_SENSE_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 15f6b86..525ba1a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -225,6 +225,15 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			return ret;
 	}
 
+	/* disable dynamic PS when requested by the firmware */
+	if (vector & SOFT_GEMINI_SENSE_EVENT_ID &&
+	    wl->bss_type == BSS_TYPE_STA_BSS) {
+		if (mbox->soft_gemini_sense_info)
+			ieee80211_disable_dyn_ps(wl->vif, true);
+		else
+			ieee80211_disable_dyn_ps(wl->vif, false);
+	}
+
 	/*
 	 * The BSS_LOSE_EVENT_ID is only needed while psm (and hence beacon
 	 * filtering) is enabled. Without PSM, the stack will receive all
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 15c99dd..366e415 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -54,7 +54,7 @@ static struct conf_drv_settings default_conf = {
 			[CONF_SG_HV3_MAX_OVERRIDE]                  = 0,
 			[CONF_SG_BT_NFS_SAMPLE_INTERVAL]            = 400,
 			[CONF_SG_BT_LOAD_RATIO]                     = 50,
-			[CONF_SG_AUTO_PS_MODE]                      = 0,
+			[CONF_SG_AUTO_PS_MODE]                      = 1,
 			[CONF_SG_AUTO_SCAN_PROBE_REQ]               = 170,
 			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3]   = 50,
 			[CONF_SG_ANTENNA_CONFIGURATION]             = 0,
@@ -937,6 +937,9 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 
 	WARN_ON(wl->state != WL1271_STATE_ON);
 
+	/* enable dyn ps just in case (if left on due to fw crash etc) */
+	ieee80211_disable_dyn_ps(wl->vif, false);
+
 	if (test_and_clear_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
 		mutex_unlock(&wl->mutex);
 		ieee80211_scan_completed(wl->hw, true);
@@ -1774,6 +1777,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			clear_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 			wl->aid = 0;
 
+			/* re-enable dynamic ps - just in case */
+			ieee80211_disable_dyn_ps(wl->vif, false);
+
 			/* revert back to minimum rates for the current band */
 			wl1271_set_band_rate(wl);
 			wl->basic_rate = wl1271_min_rate_get(wl);
-- 
1.6.3.3

