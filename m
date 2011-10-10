Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1JJIMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:50 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so5615227wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:50 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/29] wl12xx: make event handling support multirole
Date: Mon, 10 Oct 2011 10:12:57 +0200
Message-Id: <1318234397-21081-10-git-send-email-eliad@wizery.com> (sfid-20111010_101254_832332_9751D834)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some events don't indicate the role they are intended for.
In these cases, iterate through all the relevant vifs,
and pass the event to each one of them.

This is only a workaround. future fw releases should indicate
the relevant role_id for such events.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c  |  121 +++++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/wl12xx.h |   10 +++
 2 files changed, 91 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 486c8ee..dbc40bb 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -162,10 +162,10 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 }
 
 static void wl1271_event_rssi_trigger(struct wl1271 *wl,
-				      struct ieee80211_vif *vif,
+				      struct wl12xx_vif *wlvif,
 				      struct event_mailbox *mbox)
 {
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	enum nl80211_cqm_rssi_threshold_event event;
 	s8 metric = mbox->rssi_snr_trigger_metric[0];
 
@@ -183,11 +183,13 @@ static void wl1271_event_rssi_trigger(struct wl1271 *wl,
 
 static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+
 	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
 		if (!wlvif->sta.ba_rx_bitmap)
 			return;
-		ieee80211_stop_rx_ba_session(wl->vif, wlvif->sta.ba_rx_bitmap,
-					     wl->vif->bss_conf.bssid);
+		ieee80211_stop_rx_ba_session(vif, wlvif->sta.ba_rx_bitmap,
+					     vif->bss_conf.bssid);
 	} else {
 		u8 hlid;
 		struct wl1271_link *lnk;
@@ -197,7 +199,7 @@ static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 			if (!lnk->ba_bitmap)
 				continue;
 
-			ieee80211_stop_rx_ba_session(wl->vif,
+			ieee80211_stop_rx_ba_session(vif,
 						     lnk->ba_bitmap,
 						     lnk->addr);
 		}
@@ -207,12 +209,21 @@ static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 static void wl12xx_event_soft_gemini_sense(struct wl1271 *wl,
 					       u8 enable)
 {
+	struct ieee80211_vif *vif;
+	struct wl12xx_vif *wlvif;
+
 	if (enable) {
 		/* disable dynamic PS when requested by the firmware */
-		ieee80211_disable_dyn_ps(wl->vif);
+		wl12xx_for_each_wlvif_sta(wl, wlvif) {
+			vif = wl12xx_wlvif_to_vif(wlvif);
+			ieee80211_disable_dyn_ps(vif);
+		}
 		set_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags);
 	} else {
-		ieee80211_enable_dyn_ps(wl->vif);
+		wl12xx_for_each_wlvif_sta(wl, wlvif) {
+			vif = wl12xx_wlvif_to_vif(wlvif);
+			ieee80211_enable_dyn_ps(vif);
+		}
 		clear_bit(WL1271_FLAG_SOFT_GEMINI, &wl->flags);
 		wl1271_recalc_rx_streaming(wl);
 	}
@@ -228,12 +239,11 @@ static void wl1271_event_mbox_dump(struct event_mailbox *mbox)
 
 static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 {
-	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct ieee80211_vif *vif;
+	struct wl12xx_vif *wlvif;
 	int ret;
 	u32 vector;
 	bool beacon_loss = false;
-	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	bool disconnect_sta = false;
 	unsigned long sta_bitmap = 0;
 
@@ -266,8 +276,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		}
 	}
 
-	if (vector & SOFT_GEMINI_SENSE_EVENT_ID &&
-	    wlvif->bss_type == BSS_TYPE_STA_BSS)
+	if (vector & SOFT_GEMINI_SENSE_EVENT_ID)
 		wl12xx_event_soft_gemini_sense(wl,
 					       mbox->soft_gemini_sense_info);
 
@@ -280,40 +289,54 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	 * BSS_LOSE_EVENT, beacon loss has to be reported to the stack.
 	 *
 	 */
-	if ((vector & BSS_LOSE_EVENT_ID) && !is_ap) {
+	if (vector & BSS_LOSE_EVENT_ID) {
+		/* TODO: check for multi-role */
 		wl1271_info("Beacon loss detected.");
 
 		/* indicate to the stack, that beacons have been lost */
 		beacon_loss = true;
 	}
 
-	if ((vector & PS_REPORT_EVENT_ID) && !is_ap) {
+	if (vector & PS_REPORT_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "PS_REPORT_EVENT");
-		ret = wl1271_event_ps_report(wl, wlvif, mbox, &beacon_loss);
-		if (ret < 0)
-			return ret;
+		wl12xx_for_each_wlvif_sta(wl, wlvif) {
+			ret = wl1271_event_ps_report(wl, wlvif,
+						     mbox, &beacon_loss);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
-	if ((vector & PSPOLL_DELIVERY_FAILURE_EVENT_ID) && !is_ap)
-		wl1271_event_pspoll_delivery_fail(wl, wlvif);
+	if (vector & PSPOLL_DELIVERY_FAILURE_EVENT_ID)
+		wl12xx_for_each_wlvif_sta(wl, wlvif) {
+			wl1271_event_pspoll_delivery_fail(wl, wlvif);
+		}
 
 	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID) {
+		/* TODO: check actual multi-role support */
 		wl1271_debug(DEBUG_EVENT, "RSSI_SNR_TRIGGER_0_EVENT");
-		if (wl->vif)
-			wl1271_event_rssi_trigger(wl, vif, mbox);
+		wl12xx_for_each_wlvif_sta(wl, wlvif) {
+			wl1271_event_rssi_trigger(wl, wlvif, mbox);
+		}
 	}
 
-	if ((vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID)) {
+	if (vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID) {
+		u8 role_id = mbox->role_id;
 		wl1271_debug(DEBUG_EVENT, "BA_SESSION_RX_CONSTRAINT_EVENT_ID. "
-			     "ba_allowed = 0x%x", mbox->rx_ba_allowed);
+			     "ba_allowed = 0x%x, role_id=%d",
+			     mbox->rx_ba_allowed, role_id);
 
-		wlvif->ba_allowed = !!mbox->rx_ba_allowed;
+		wl12xx_for_each_wlvif(wl, wlvif) {
+			if (role_id != 0xff && role_id != wlvif->role_id)
+				continue;
 
-		if (wl->vif && !wlvif->ba_allowed)
-			wl1271_stop_ba_event(wl, wlvif);
+			wlvif->ba_allowed = !!mbox->rx_ba_allowed;
+			if (!wlvif->ba_allowed)
+				wl1271_stop_ba_event(wl, wlvif);
+		}
 	}
 
-	if ((vector & CHANNEL_SWITCH_COMPLETE_EVENT_ID) && !is_ap) {
+	if (vector & CHANNEL_SWITCH_COMPLETE_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "CHANNEL_SWITCH_COMPLETE_EVENT_ID. "
 					  "status = 0x%x",
 					  mbox->channel_switch_status);
@@ -322,48 +345,63 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		 * 1) channel switch complete with status=0
 		 * 2) channel switch failed status=1
 		 */
-		if (test_and_clear_bit(WL1271_FLAG_CS_PROGRESS, &wl->flags) &&
-		    (wl->vif))
-			ieee80211_chswitch_done(wl->vif,
-				mbox->channel_switch_status ? false : true);
+		if (test_and_clear_bit(WL1271_FLAG_CS_PROGRESS, &wl->flags)) {
+			/* TODO: configure only the relevant vif */
+			wl12xx_for_each_wlvif_sta(wl, wlvif) {
+				struct ieee80211_vif *vif =
+					wl12xx_wlvif_to_vif(wlvif);
+				bool success = mbox->channel_switch_status ?
+					false : true;
+
+				ieee80211_chswitch_done(vif, success);
+			}
+		}
 	}
 
 	if ((vector & DUMMY_PACKET_EVENT_ID)) {
 		wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
-		if (wl->vif)
-			wl1271_tx_dummy_packet(wl);
+		wl1271_tx_dummy_packet(wl);
 	}
 
 	/*
 	 * "TX retries exceeded" has a different meaning according to mode.
 	 * In AP mode the offending station is disconnected.
 	 */
-	if ((vector & MAX_TX_RETRY_EVENT_ID) && is_ap) {
+	if (vector & MAX_TX_RETRY_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "MAX_TX_RETRY_EVENT_ID");
 		sta_bitmap |= le16_to_cpu(mbox->sta_tx_retry_exceeded);
 		disconnect_sta = true;
 	}
 
-	if ((vector & INACTIVE_STA_EVENT_ID) && is_ap) {
+	if (vector & INACTIVE_STA_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "INACTIVE_STA_EVENT_ID");
 		sta_bitmap |= le16_to_cpu(mbox->sta_aging_status);
 		disconnect_sta = true;
 	}
 
-	if (is_ap && disconnect_sta) {
+	if (disconnect_sta) {
 		u32 num_packets = wl->conf.tx.max_tx_retries;
 		struct ieee80211_sta *sta;
 		const u8 *addr;
 		int h;
 
 		for_each_set_bit(h, &sta_bitmap, WL12XX_MAX_LINKS) {
-			if (!test_bit(h, wlvif->ap.sta_hlid_map))
+			bool found = false;
+			/* find the ap vif connected to this sta */
+			wl12xx_for_each_wlvif_ap(wl, wlvif) {
+				if (!test_bit(h, wlvif->ap.sta_hlid_map))
+					continue;
+				found = true;
+				break;
+			}
+			if (!found)
 				continue;
 
+			vif = wl12xx_wlvif_to_vif(wlvif);
 			addr = wl->links[h].addr;
 
 			rcu_read_lock();
-			sta = ieee80211_find_sta(wl->vif, addr);
+			sta = ieee80211_find_sta(vif, addr);
 			if (sta) {
 				wl1271_debug(DEBUG_EVENT, "remove sta %d", h);
 				ieee80211_report_low_ack(sta, num_packets);
@@ -372,8 +410,11 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		}
 	}
 
-	if (wl->vif && beacon_loss)
-		ieee80211_connection_loss(wl->vif);
+	if (beacon_loss)
+		wl12xx_for_each_wlvif_sta(wl, wlvif) {
+			vif = wl12xx_wlvif_to_vif(wlvif);
+			ieee80211_connection_loss(vif);
+		}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 55561c5..b13f13e 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -659,6 +659,16 @@ struct ieee80211_vif *wl12xx_wlvif_to_vif(struct wl12xx_vif *wlvif)
 #define wl12xx_for_each_wlvif(wl, wlvif) \
 		list_for_each_entry(wlvif, &wl->wlvif_list, list)
 
+#define wl12xx_for_each_wlvif_bss_type(wl, wlvif, _bss_type)	\
+		wl12xx_for_each_wlvif(wl, wlvif)		\
+			if (wlvif->bss_type == _bss_type)
+
+#define wl12xx_for_each_wlvif_sta(wl, wlvif)	\
+		wl12xx_for_each_wlvif_bss_type(wl, wlvif, BSS_TYPE_STA_BSS)
+
+#define wl12xx_for_each_wlvif_ap(wl, wlvif)	\
+		wl12xx_for_each_wlvif_bss_type(wl, wlvif, BSS_TYPE_AP_BSS)
+
 int wl1271_plt_start(struct wl1271 *wl);
 int wl1271_plt_stop(struct wl1271 *wl);
 int wl1271_recalc_rx_streaming(struct wl1271 *wl);
-- 
1.7.6.401.g6a319

