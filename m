Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54424 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1DRLWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:22:40 -0400
Received: by wwa36 with SMTP id 36so5514188wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:22:39 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] wl12xx: support FW TX inactivity triggers
Date: Mon, 18 Apr 2011 14:22:29 +0300
Message-Id: <1303125749-31967-2-git-send-email-arik@wizery.com>
In-Reply-To: <1303125749-31967-1-git-send-email-arik@wizery.com>
References: <1303125749-31967-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode register for the MAX_TX_RETRY and INACTIVE_STA events.
Both are reported to the upper layers as a TX failure in the offending
stations.

In STA mode we register only for the MAX_TX_RETRY event. A TX failure is
interpreted as a loss of connection.

Support for IEEE80211_HW_REPORTS_TX_ACK_STATUS has been removed to avoid
the inherent race condition of a mac80211 TX failure counter in addition
to the FW counter.

This patch depends on "mac80211: allow low level drivers to report packet
loss"

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c   |    6 +++-
 drivers/net/wireless/wl12xx/cmd.c    |    2 +-
 drivers/net/wireless/wl12xx/conf.h   |    6 ++++
 drivers/net/wireless/wl12xx/event.c  |   47 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/event.h  |   12 ++++++++-
 drivers/net/wireless/wl12xx/main.c   |    8 +++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 -
 7 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index b5ec2c2..072f783 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -478,10 +478,12 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		DISCONNECT_EVENT_COMPLETE_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
-		SOFT_GEMINI_SENSE_EVENT_ID;
+		SOFT_GEMINI_SENSE_EVENT_ID |
+		MAX_TX_RETRY_EVENT_ID;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID;
+		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID |
+				  INACTIVE_STA_EVENT_ID;
 	else
 		wl->event_mask |= DUMMY_PACKET_EVENT_ID;
 
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 2468044..d483316 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1070,7 +1070,7 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 
 	memcpy(cmd->bssid, bss_conf->bssid, ETH_ALEN);
 
-	cmd->aging_period = cpu_to_le16(WL1271_AP_DEF_INACTIV_SEC);
+	cmd->aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
 	cmd->bss_index = WL1271_AP_BSS_INDEX;
 	cmd->global_hlid = WL1271_AP_GLOBAL_HLID;
 	cmd->broadcast_hlid = WL1271_AP_BROADCAST_HLID;
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 743bd0b..e6398e0 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -689,6 +689,12 @@ struct conf_tx_settings {
 	u16 ap_max_tx_retries;
 
 	/*
+	 * AP-mode - after this number of seconds a connected station is
+	 * considered inactive.
+	 */
+	u16 ap_aging_period;
+
+	/*
 	 * Configuration for TID parameters.
 	 */
 	u8 tid_conf_count;
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index ae69330..2d484db 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -174,6 +174,8 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	u32 vector;
 	bool beacon_loss = false;
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool disconnect_sta = false;
+	unsigned long sta_bitmap = 0;
 
 	wl1271_event_mbox_dump(mbox);
 
@@ -235,9 +237,54 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			wl1271_tx_dummy_packet(wl);
 	}
 
+	/*
+	 * "TX retries exceeded" has a different meaning according to mode.
+	 * In AP mode the offending station is disconnected. In STA mode we
+	 * report connection loss.
+	 */
+	if (vector & MAX_TX_RETRY_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT, "MAX_TX_RETRY_EVENT_ID");
+		if (is_ap) {
+			sta_bitmap |= le16_to_cpu(mbox->sta_tx_retry_exceeded);
+			disconnect_sta = true;
+		} else {
+			beacon_loss = true;
+		}
+	}
+
+	if ((vector & INACTIVE_STA_EVENT_ID) && is_ap) {
+		wl1271_debug(DEBUG_EVENT, "INACTIVE_STA_EVENT_ID");
+		sta_bitmap |= le16_to_cpu(mbox->sta_aging_status);
+		disconnect_sta = true;
+	}
+
 	if (wl->vif && beacon_loss)
 		ieee80211_connection_loss(wl->vif);
 
+	if (is_ap && disconnect_sta) {
+		u32 num_packets = wl->conf.tx.ap_max_tx_retries;
+		struct ieee80211_sta *sta;
+		const u8 *addr;
+		int h;
+
+		for (h = find_first_bit(&sta_bitmap, AP_MAX_LINKS);
+		     h < AP_MAX_LINKS;
+		     h = find_next_bit(&sta_bitmap, AP_MAX_LINKS, h+1)) {
+			if (!wl1271_is_active_sta(wl, h))
+				continue;
+
+			addr = wl->links[h].addr;
+
+			rcu_read_lock();
+			sta = ieee80211_find_sta(wl->vif, addr);
+			if (sta) {
+				wl1271_debug(DEBUG_EVENT, "remove sta %d", h);
+				ieee80211_report_low_ack(sta, num_packets);
+			}
+			rcu_read_unlock();
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index b6cf06e..7ae5a08 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -58,13 +58,16 @@ enum {
 	CHANNEL_SWITCH_COMPLETE_EVENT_ID	 = BIT(17),
 	BSS_LOSE_EVENT_ID			 = BIT(18),
 	REGAINED_BSS_EVENT_ID			 = BIT(19),
-	ROAMING_TRIGGER_MAX_TX_RETRY_EVENT_ID	 = BIT(20),
+	MAX_TX_RETRY_EVENT_ID			 = BIT(20),
 	/* STA: dummy paket for dynamic mem blocks */
 	DUMMY_PACKET_EVENT_ID                    = BIT(21),
 	/* AP: STA remove complete */
 	STA_REMOVE_COMPLETE_EVENT_ID             = BIT(21),
 	SOFT_GEMINI_SENSE_EVENT_ID		 = BIT(22),
+	/* STA: SG prediction */
 	SOFT_GEMINI_PREDICTION_EVENT_ID		 = BIT(23),
+	/* AP: Inactive STA */
+	INACTIVE_STA_EVENT_ID			 = BIT(23),
 	SOFT_GEMINI_AVALANCHE_EVENT_ID		 = BIT(24),
 	PLT_RX_CALIBRATION_COMPLETE_EVENT_ID	 = BIT(25),
 	DBG_EVENT_ID				 = BIT(26),
@@ -119,7 +122,11 @@ struct event_mailbox {
 
 	/* AP FW only */
 	u8 hlid_removed;
+
+	/* a bitmap of hlids for stations that have been inactive too long */
 	__le16 sta_aging_status;
+
+	/* a bitmap of hlids for stations which didn't respond to TX */
 	__le16 sta_tx_retry_exceeded;
 
 	u8 reserved_5[24];
@@ -130,4 +137,7 @@ void wl1271_event_mbox_config(struct wl1271 *wl);
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
 void wl1271_pspoll_work(struct work_struct *work);
 
+/* Functions from main.c */
+bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid);
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7126506..e840176 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -193,6 +193,7 @@ static struct conf_drv_settings default_conf = {
 			.aflags              = 0,
 		},
 		.ap_max_tx_retries = 100,
+		.ap_aging_period = 300,
 		.tid_conf_count = 4,
 		.tid_conf = {
 			[CONF_TX_AC_BE] = {
@@ -2952,6 +2953,12 @@ static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 }
 
+bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid)
+{
+	int id = hlid - WL1271_AP_STA_HLID_START;
+	return test_bit(id, wl->ap_hlid_map);
+}
+
 static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta)
@@ -3535,7 +3542,6 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_CONNECTION_MONITOR |
 		IEEE80211_HW_SUPPORTS_CQM_RSSI |
-		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_AP_LINK_PS;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index fb2b79f..7c521af 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -172,7 +172,6 @@ extern u32 wl12xx_debug_level;
 #define WL1271_PS_STA_MAX_BLOCKS  (2 * 9)
 
 #define WL1271_AP_BSS_INDEX        0
-#define WL1271_AP_DEF_INACTIV_SEC  300
 #define WL1271_AP_DEF_BEACON_EXP   20
 
 #define ACX_TX_DESCRIPTORS         32
-- 
1.7.1

