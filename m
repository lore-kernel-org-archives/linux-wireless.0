Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45334 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934317Ab1JEJ43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:29 -0400
Received: by eya28 with SMTP id 28so1406494eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:28 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 27/29] wl12xx: move ba fields into wlvif
Date: Wed,  5 Oct 2011 11:56:04 +0200
Message-Id: <1317808566-18857-28-git-send-email-eliad@wizery.com> (sfid-20111005_121655_526721_C6AB4327)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move ba_fields into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    2 --
 drivers/net/wireless/wl12xx/event.c   |    8 ++++----
 drivers/net/wireless/wl12xx/init.c    |    7 +++----
 drivers/net/wireless/wl12xx/main.c    |    4 ++--
 drivers/net/wireless/wl12xx/tx.c      |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |   10 +++++-----
 6 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index e53f9683..ee42a43 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -357,8 +357,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(noise);
 	DRIVER_STATE_PRINT_LHEX(ap_hlid_map[0]);
 	DRIVER_STATE_PRINT_INT(last_tx_hlid);
-	DRIVER_STATE_PRINT_INT(ba_support);
-	DRIVER_STATE_PRINT_HEX(ba_rx_bitmap);
 	DRIVER_STATE_PRINT_HEX(ap_fw_ps_map);
 	DRIVER_STATE_PRINT_LHEX(ap_ps_map);
 	DRIVER_STATE_PRINT_HEX(quirks);
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index d5af3e3..c941533 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -184,9 +184,9 @@ static void wl1271_event_rssi_trigger(struct wl1271 *wl,
 static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
-		if (!wl->ba_rx_bitmap)
+		if (!wlvif->sta.ba_rx_bitmap)
 			return;
-		ieee80211_stop_rx_ba_session(wl->vif, wl->ba_rx_bitmap,
+		ieee80211_stop_rx_ba_session(wl->vif, wlvif->sta.ba_rx_bitmap,
 					     wl->vif->bss_conf.bssid);
 	} else {
 		int i;
@@ -306,9 +306,9 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		wl1271_debug(DEBUG_EVENT, "BA_SESSION_RX_CONSTRAINT_EVENT_ID. "
 			     "ba_allowed = 0x%x", mbox->rx_ba_allowed);
 
-		wl->ba_allowed = !!mbox->rx_ba_allowed;
+		wlvif->ba_allowed = !!mbox->rx_ba_allowed;
 
-		if (wl->vif && !wl->ba_allowed)
+		if (wl->vif && !wlvif->ba_allowed)
 			wl1271_stop_ba_event(wl, wlvif);
 	}
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 85e3635..08745ad 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -486,18 +486,17 @@ int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 static int wl1271_set_ba_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	/* Reset the BA RX indicators */
-	wl->ba_rx_bitmap = 0;
-	wl->ba_allowed = true;
+	wlvif->ba_allowed = true;
 	wl->ba_rx_session_count = 0;
 
 	/* BA is supported in STA/AP modes */
 	if (wlvif->bss_type != BSS_TYPE_AP_BSS &&
 	    wlvif->bss_type != BSS_TYPE_STA_BSS) {
-		wl->ba_support = false;
+		wlvif->ba_support = false;
 		return 0;
 	}
 
-	wl->ba_support = true;
+	wlvif->ba_support = true;
 
 	/* 802.11n initiator BA session setting */
 	return wl12xx_acx_set_ba_initiator_policy(wl, wlvif);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dede647..a45c4bb 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4100,7 +4100,7 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS) {
 		hlid = wlvif->sta.hlid;
-		ba_bitmap = &wl->ba_rx_bitmap;
+		ba_bitmap = &wlvif->sta.ba_rx_bitmap;
 	} else if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
 		struct wl1271_station *wl_sta;
 
@@ -4121,7 +4121,7 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (!wl->ba_support || !wl->ba_allowed) {
+		if (!wlvif->ba_support || !wlvif->ba_allowed) {
 			ret = -ENOTSUPP;
 			break;
 		}
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 509ae10..6ce6163 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -941,7 +941,7 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 			}
 		}
 
-		wl->ba_rx_bitmap = 0;
+		wlvif->sta.ba_rx_bitmap = 0;
 	}
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 758bff5..fb77c58 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -545,11 +545,6 @@ struct wl1271 {
 	/* bands supported by this instance of wl12xx */
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
-	/* RX BA constraint value */
-	bool ba_support;
-	u8 ba_rx_bitmap;
-	bool ba_allowed;
-
 	int tcxo_clock;
 
 	/*
@@ -604,6 +599,7 @@ struct wl12xx_vif {
 	union {
 		struct {
 			u8 hlid;
+			u8 ba_rx_bitmap;
 		} sta;
 		struct {
 			u8 global_hlid;
@@ -651,6 +647,10 @@ struct wl12xx_vif {
 
 	int rssi_thold;
 	int last_rssi_event;
+
+	/* RX BA constraint value */
+	bool ba_support;
+	bool ba_allowed;
 };
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
-- 
1.7.6.401.g6a319

