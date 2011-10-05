Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58856 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298Ab1JEJ42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:28 -0400
Received: by wyg34 with SMTP id 34so1496129wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:26 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 26/29] wl12xx: move rssi_thold and last_rssi_event into wlvif
Date: Wed,  5 Oct 2011 11:56:03 +0200
Message-Id: <1317808566-18857-27-git-send-email-eliad@wizery.com> (sfid-20111005_115636_421645_71D75934)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move rssi_thold and last_rssi_event into the per-interface
data, rather than being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c     |    2 +-
 drivers/net/wireless/wl12xx/debugfs.c |    2 --
 drivers/net/wireless/wl12xx/event.c   |   12 +++++++-----
 drivers/net/wireless/wl12xx/main.c    |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |    6 +++---
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 9b4eef6..5b70cc1 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1274,7 +1274,7 @@ int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		goto out;
 	}
 
-	wl->last_rssi_event = -1;
+	wlvif->last_rssi_event = -1;
 
 	acx->role_id = wlvif->role_id;
 	acx->pacing = cpu_to_le16(wl->conf.roam_trigger.trigger_pacing);
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index cd390e0..e53f9683 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -352,8 +352,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(channel);
 	DRIVER_STATE_PRINT_INT(band);
 	DRIVER_STATE_PRINT_INT(power_level);
-	DRIVER_STATE_PRINT_INT(rssi_thold);
-	DRIVER_STATE_PRINT_INT(last_rssi_event);
 	DRIVER_STATE_PRINT_INT(sg_enabled);
 	DRIVER_STATE_PRINT_INT(enable_11a);
 	DRIVER_STATE_PRINT_INT(noise);
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 31cb43e..d5af3e3 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -162,21 +162,23 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 }
 
 static void wl1271_event_rssi_trigger(struct wl1271 *wl,
+				      struct ieee80211_vif *vif,
 				      struct event_mailbox *mbox)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	enum nl80211_cqm_rssi_threshold_event event;
 	s8 metric = mbox->rssi_snr_trigger_metric[0];
 
 	wl1271_debug(DEBUG_EVENT, "RSSI trigger metric: %d", metric);
 
-	if (metric <= wl->rssi_thold)
+	if (metric <= wlvif->rssi_thold)
 		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW;
 	else
 		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
 
-	if (event != wl->last_rssi_event)
-		ieee80211_cqm_rssi_notify(wl->vif, event, GFP_KERNEL);
-	wl->last_rssi_event = event;
+	if (event != wlvif->last_rssi_event)
+		ieee80211_cqm_rssi_notify(vif, event, GFP_KERNEL);
+	wlvif->last_rssi_event = event;
 }
 
 static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
@@ -297,7 +299,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "RSSI_SNR_TRIGGER_0_EVENT");
 		if (wl->vif)
-			wl1271_event_rssi_trigger(wl, mbox);
+			wl1271_event_rssi_trigger(wl, vif, mbox);
 	}
 
 	if ((vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID)) {
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 20ad35d..dede647 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3492,7 +3492,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 						  bss_conf->cqm_rssi_hyst);
 		if (ret < 0)
 			goto out;
-		wl->rssi_thold = bss_conf->cqm_rssi_thold;
+		wlvif->rssi_thold = bss_conf->cqm_rssi_thold;
 	}
 
 	if (changed & BSS_CHANGED_BSSID)
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 5e976ae..758bff5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -513,9 +513,6 @@ struct wl1271 {
 	/* in dBm */
 	int power_level;
 
-	int rssi_thold;
-	int last_rssi_event;
-
 	struct wl1271_stats stats;
 
 	__le32 buffer_32;
@@ -651,6 +648,9 @@ struct wl12xx_vif {
 
 	/* retry counter for PSM entries */
 	u8 psm_entry_retry;
+
+	int rssi_thold;
+	int last_rssi_event;
 };
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
-- 
1.7.6.401.g6a319

