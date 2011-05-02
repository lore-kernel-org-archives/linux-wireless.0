Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33922 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122Ab1EBJxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 05:53:01 -0400
Received: by eye27 with SMTP id 27so1934380eye.20
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 02:52:59 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com
Subject: [PATCH] Revert "wl12xx: support FW TX inactivity triggers"
Date: Mon,  2 May 2011 12:52:50 +0300
Message-Id: <1304329970-7244-1-git-send-email-coelho@ti.com> (sfid-20110502_115307_383428_82CEB66D)
In-Reply-To: <1304329855.12586.234.camel@cumari>
References: <1304329855.12586.234.camel@cumari>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 47684808fd89d6809c0886e06f8ac324252499d8.

Conflicts:

	drivers/net/wireless/wl12xx/conf.h
	drivers/net/wireless/wl12xx/main.c
---
 drivers/net/wireless/wl12xx/acx.c    |   34 +++---------------------
 drivers/net/wireless/wl12xx/acx.h    |   12 +-------
 drivers/net/wireless/wl12xx/boot.c   |    6 +---
 drivers/net/wireless/wl12xx/cmd.c    |    2 +-
 drivers/net/wireless/wl12xx/conf.h   |   12 +-------
 drivers/net/wireless/wl12xx/event.c  |   47 ----------------------------------
 drivers/net/wireless/wl12xx/event.h  |   12 +--------
 drivers/net/wireless/wl12xx/init.c   |    6 +---
 drivers/net/wireless/wl12xx/main.c   |   10 +------
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 10 files changed, 17 insertions(+), 125 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index ec0156b..c6ee530 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1577,46 +1577,22 @@ out:
 	return ret;
 }
 
-int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl)
+int wl1271_acx_max_tx_retry(struct wl1271 *wl)
 {
-	struct wl1271_acx_ap_max_tx_retry *acx = NULL;
+	struct wl1271_acx_max_tx_retry *acx = NULL;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx ap max tx retry");
+	wl1271_debug(DEBUG_ACX, "acx max tx retry");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx)
 		return -ENOMEM;
 
-	acx->max_tx_retry = cpu_to_le16(wl->conf.tx.max_tx_retries);
+	acx->max_tx_retry = cpu_to_le16(wl->conf.tx.ap_max_tx_retries);
 
 	ret = wl1271_cmd_configure(wl, ACX_MAX_TX_FAILURE, acx, sizeof(*acx));
 	if (ret < 0) {
-		wl1271_warning("acx ap max tx retry failed: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(acx);
-	return ret;
-}
-
-int wl1271_acx_sta_max_tx_retry(struct wl1271 *wl)
-{
-	struct wl1271_acx_sta_max_tx_retry *acx = NULL;
-	int ret;
-
-	wl1271_debug(DEBUG_ACX, "acx sta max tx retry");
-
-	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
-	if (!acx)
-		return -ENOMEM;
-
-	acx->max_tx_retry = wl->conf.tx.max_tx_retries;
-
-	ret = wl1271_cmd_configure(wl, ACX_CONS_TX_FAILURE, acx, sizeof(*acx));
-	if (ret < 0) {
-		wl1271_warning("acx sta max tx retry failed: %d", ret);
+		wl1271_warning("acx max tx retry failed: %d", ret);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 75338f9..9a895e3 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1153,7 +1153,7 @@ struct wl1271_acx_fw_tsf_information {
 	u8 padding[3];
 } __packed;
 
-struct wl1271_acx_ap_max_tx_retry {
+struct wl1271_acx_max_tx_retry {
 	struct acx_header header;
 
 	/*
@@ -1164,13 +1164,6 @@ struct wl1271_acx_ap_max_tx_retry {
 	u8 padding_1[2];
 } __packed;
 
-struct wl1271_acx_sta_max_tx_retry {
-	struct acx_header header;
-
-	u8 max_tx_retry;
-	u8 padding_1[3];
-} __packed;
-
 struct wl1271_acx_config_ps {
 	struct acx_header header;
 
@@ -1391,8 +1384,7 @@ int wl1271_acx_set_ba_session(struct wl1271 *wl,
 int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 				       bool enable);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
-int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl);
-int wl1271_acx_sta_max_tx_retry(struct wl1271 *wl);
+int wl1271_acx_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_set_ap_beacon_filter(struct wl1271 *wl, bool enable);
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index d263ebb..2b0cf85 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -478,12 +478,10 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		DISCONNECT_EVENT_COMPLETE_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
-		SOFT_GEMINI_SENSE_EVENT_ID |
-		MAX_TX_RETRY_EVENT_ID;
+		SOFT_GEMINI_SENSE_EVENT_ID;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID |
-				  INACTIVE_STA_EVENT_ID;
+		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID;
 	else
 		wl->event_mask |= DUMMY_PACKET_EVENT_ID;
 
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index d8596ae..2116a37 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1080,7 +1080,7 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 
 	memcpy(cmd->bssid, bss_conf->bssid, ETH_ALEN);
 
-	cmd->aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
+	cmd->aging_period = cpu_to_le16(WL1271_AP_DEF_INACTIV_SEC);
 	cmd->bss_index = WL1271_AP_BSS_INDEX;
 	cmd->global_hlid = WL1271_AP_GLOBAL_HLID;
 	cmd->broadcast_hlid = WL1271_AP_BROADCAST_HLID;
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index c0045f0..1f94736 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -711,18 +711,10 @@ struct conf_tx_settings {
 	struct conf_tx_ac_category ac_conf[CONF_TX_MAX_AC_COUNT];
 
 	/*
-	 * Allow this number of TX retries to a connected station/AP before an
+	 * AP-mode - allow this number of TX retries to a station before an
 	 * event is triggered from FW.
-	 * In AP-mode the hlids of unreachable stations are given in the
-	 * "sta_tx_retry_exceeded" member in the event mailbox.
 	 */
-	u8 max_tx_retries;
-
-	/*
-	 * AP-mode - after this number of seconds a connected station is
-	 * considered inactive.
-	 */
-	u16 ap_aging_period;
+	u16 ap_max_tx_retries;
 
 	/*
 	 * Configuration for TID parameters.
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index d7be3ae..ae69330 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -174,8 +174,6 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	u32 vector;
 	bool beacon_loss = false;
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
-	bool disconnect_sta = false;
-	unsigned long sta_bitmap = 0;
 
 	wl1271_event_mbox_dump(mbox);
 
@@ -237,54 +235,9 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			wl1271_tx_dummy_packet(wl);
 	}
 
-	/*
-	 * "TX retries exceeded" has a different meaning according to mode.
-	 * In AP mode the offending station is disconnected. In STA mode we
-	 * report connection loss.
-	 */
-	if (vector & MAX_TX_RETRY_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT, "MAX_TX_RETRY_EVENT_ID");
-		if (is_ap) {
-			sta_bitmap |= le16_to_cpu(mbox->sta_tx_retry_exceeded);
-			disconnect_sta = true;
-		} else {
-			beacon_loss = true;
-		}
-	}
-
-	if ((vector & INACTIVE_STA_EVENT_ID) && is_ap) {
-		wl1271_debug(DEBUG_EVENT, "INACTIVE_STA_EVENT_ID");
-		sta_bitmap |= le16_to_cpu(mbox->sta_aging_status);
-		disconnect_sta = true;
-	}
-
 	if (wl->vif && beacon_loss)
 		ieee80211_connection_loss(wl->vif);
 
-	if (is_ap && disconnect_sta) {
-		u32 num_packets = wl->conf.tx.max_tx_retries;
-		struct ieee80211_sta *sta;
-		const u8 *addr;
-		int h;
-
-		for (h = find_first_bit(&sta_bitmap, AP_MAX_LINKS);
-		     h < AP_MAX_LINKS;
-		     h = find_next_bit(&sta_bitmap, AP_MAX_LINKS, h+1)) {
-			if (!wl1271_is_active_sta(wl, h))
-				continue;
-
-			addr = wl->links[h].addr;
-
-			rcu_read_lock();
-			sta = ieee80211_find_sta(wl->vif, addr);
-			if (sta) {
-				wl1271_debug(DEBUG_EVENT, "remove sta %d", h);
-				ieee80211_report_low_ack(sta, num_packets);
-			}
-			rcu_read_unlock();
-		}
-	}
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index 7ae5a08..b6cf06e 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -58,16 +58,13 @@ enum {
 	CHANNEL_SWITCH_COMPLETE_EVENT_ID	 = BIT(17),
 	BSS_LOSE_EVENT_ID			 = BIT(18),
 	REGAINED_BSS_EVENT_ID			 = BIT(19),
-	MAX_TX_RETRY_EVENT_ID			 = BIT(20),
+	ROAMING_TRIGGER_MAX_TX_RETRY_EVENT_ID	 = BIT(20),
 	/* STA: dummy paket for dynamic mem blocks */
 	DUMMY_PACKET_EVENT_ID                    = BIT(21),
 	/* AP: STA remove complete */
 	STA_REMOVE_COMPLETE_EVENT_ID             = BIT(21),
 	SOFT_GEMINI_SENSE_EVENT_ID		 = BIT(22),
-	/* STA: SG prediction */
 	SOFT_GEMINI_PREDICTION_EVENT_ID		 = BIT(23),
-	/* AP: Inactive STA */
-	INACTIVE_STA_EVENT_ID			 = BIT(23),
 	SOFT_GEMINI_AVALANCHE_EVENT_ID		 = BIT(24),
 	PLT_RX_CALIBRATION_COMPLETE_EVENT_ID	 = BIT(25),
 	DBG_EVENT_ID				 = BIT(26),
@@ -122,11 +119,7 @@ struct event_mailbox {
 
 	/* AP FW only */
 	u8 hlid_removed;
-
-	/* a bitmap of hlids for stations that have been inactive too long */
 	__le16 sta_aging_status;
-
-	/* a bitmap of hlids for stations which didn't respond to TX */
 	__le16 sta_tx_retry_exceeded;
 
 	u8 reserved_5[24];
@@ -137,7 +130,4 @@ void wl1271_event_mbox_config(struct wl1271 *wl);
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
 void wl1271_pspoll_work(struct work_struct *work);
 
-/* Functions from main.c */
-bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid);
-
 #endif
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index b1242a6..a8f4f15 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -378,10 +378,6 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_sta_max_tx_retry(wl);
-	if (ret < 0)
-		return ret;
-
 	ret = wl1271_acx_sta_mem_cfg(wl);
 	if (ret < 0)
 		return ret;
@@ -432,7 +428,7 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_ap_max_tx_retry(wl);
+	ret = wl1271_acx_max_tx_retry(wl);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6dd42c9..6dab6f0 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -209,8 +209,7 @@ static struct conf_drv_settings default_conf = {
 				.tx_op_limit = 1504,
 			},
 		},
-		.max_tx_retries = 100,
-		.ap_aging_period = 300,
+		.ap_max_tx_retries = 100,
 		.tid_conf_count = 4,
 		.tid_conf = {
 			[CONF_TX_AC_BE] = {
@@ -3021,12 +3020,6 @@ static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 }
 
-bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid)
-{
-	int id = hlid - WL1271_AP_STA_HLID_START;
-	return test_bit(id, wl->ap_hlid_map);
-}
-
 static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta)
@@ -3632,6 +3625,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_CONNECTION_MONITOR |
 		IEEE80211_HW_SUPPORTS_CQM_RSSI |
+		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_AP_LINK_PS;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index f3de962..b760143 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -172,6 +172,7 @@ extern u32 wl12xx_debug_level;
 #define WL1271_PS_STA_MAX_BLOCKS  (2 * 9)
 
 #define WL1271_AP_BSS_INDEX        0
+#define WL1271_AP_DEF_INACTIV_SEC  300
 #define WL1271_AP_DEF_BEACON_EXP   20
 
 #define ACX_TX_DESCRIPTORS         32
-- 
1.7.1

