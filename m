Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48798 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1FSGFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 02:05:04 -0400
Received: by wyb38 with SMTP id 38so1034768wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2011 23:05:02 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/3] wl12xx: AP mode - support FW TX inactivity triggers
Date: Sun, 19 Jun 2011 09:04:55 +0300
Message-Id: <1308463496-15522-2-git-send-email-arik@wizery.com> (sfid-20110619_080517_332688_CEAAD8C1)
In-Reply-To: <1308463496-15522-1-git-send-email-arik@wizery.com>
References: <1308463496-15522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode we register for the MAX_TX_RETRY and INACTIVE_STA events.
Both are reported to the upper layers as a TX failure in the offending
stations.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c    |   10 ++++----
 drivers/net/wireless/wl12xx/acx.h    |    4 +-
 drivers/net/wireless/wl12xx/boot.c   |    4 ++-
 drivers/net/wireless/wl12xx/cmd.c    |    2 +-
 drivers/net/wireless/wl12xx/conf.h   |   10 +++++++-
 drivers/net/wireless/wl12xx/event.c  |   42 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/event.h  |   12 +++++++++-
 drivers/net/wireless/wl12xx/init.c   |    2 +-
 drivers/net/wireless/wl12xx/main.c   |    9 ++++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 -
 10 files changed, 82 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index b5880eb..91fd7cc 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1623,22 +1623,22 @@ out:
 	return ret;
 }
 
-int wl1271_acx_max_tx_retry(struct wl1271 *wl)
+int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl)
 {
-	struct wl1271_acx_max_tx_retry *acx = NULL;
+	struct wl1271_acx_ap_max_tx_retry *acx = NULL;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx max tx retry");
+	wl1271_debug(DEBUG_ACX, "acx ap max tx retry");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx)
 		return -ENOMEM;
 
-	acx->max_tx_retry = cpu_to_le16(wl->conf.tx.ap_max_tx_retries);
+	acx->max_tx_retry = cpu_to_le16(wl->conf.tx.max_tx_retries);
 
 	ret = wl1271_cmd_configure(wl, ACX_MAX_TX_FAILURE, acx, sizeof(*acx));
 	if (ret < 0) {
-		wl1271_warning("acx max tx retry failed: %d", ret);
+		wl1271_warning("acx ap max tx retry failed: %d", ret);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index f1d55313..a30cc7be 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1166,7 +1166,7 @@ struct wl1271_acx_ps_rx_streaming {
 	u8 timeout;
 } __packed;
 
-struct wl1271_acx_max_tx_retry {
+struct wl1271_acx_ap_max_tx_retry {
 	struct acx_header header;
 
 	/*
@@ -1398,7 +1398,7 @@ int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 				       bool enable);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable);
-int wl1271_acx_max_tx_retry(struct wl1271 *wl);
+int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_set_ap_beacon_filter(struct wl1271 *wl, bool enable);
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index b07f8b7..651c30d 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -483,7 +483,9 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		PERIODIC_SCAN_COMPLETE_EVENT_ID;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID;
+		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID |
+				  INACTIVE_STA_EVENT_ID |
+				  MAX_TX_RETRY_EVENT_ID;
 	else
 		wl->event_mask |= DUMMY_PACKET_EVENT_ID;
 
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 0a9079e..bafb6b7 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1075,7 +1075,7 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 
 	memcpy(cmd->bssid, bss_conf->bssid, ETH_ALEN);
 
-	cmd->aging_period = cpu_to_le16(WL1271_AP_DEF_INACTIV_SEC);
+	cmd->aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
 	cmd->bss_index = WL1271_AP_BSS_INDEX;
 	cmd->global_hlid = WL1271_AP_GLOBAL_HLID;
 	cmd->broadcast_hlid = WL1271_AP_BROADCAST_HLID;
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 510c2f7..c408759 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -713,8 +713,16 @@ struct conf_tx_settings {
 	/*
 	 * AP-mode - allow this number of TX retries to a station before an
 	 * event is triggered from FW.
+	 * In AP-mode the hlids of unreachable stations are given in the
+	 * "sta_tx_retry_exceeded" member in the event mailbox.
 	 */
-	u16 ap_max_tx_retries;
+	u8 max_tx_retries;
+
+	/*
+	 * AP-mode - after this number of seconds a connected station is
+	 * considered inactive.
+	 */
+	u16 ap_aging_period;
 
 	/*
 	 * Configuration for TID parameters.
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 9102443..cf2ba99 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -199,6 +199,8 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	u32 vector;
 	bool beacon_loss = false;
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	bool disconnect_sta = false;
+	unsigned long sta_bitmap = 0;
 
 	wl1271_event_mbox_dump(mbox);
 
@@ -272,6 +274,46 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			wl1271_tx_dummy_packet(wl);
 	}
 
+	/*
+	 * "TX retries exceeded" has a different meaning according to mode.
+	 * In AP mode the offending station is disconnected.
+	 */
+	if ((vector & MAX_TX_RETRY_EVENT_ID) && is_ap) {
+		wl1271_debug(DEBUG_EVENT, "MAX_TX_RETRY_EVENT_ID");
+		sta_bitmap |= le16_to_cpu(mbox->sta_tx_retry_exceeded);
+		disconnect_sta = true;
+	}
+
+	if ((vector & INACTIVE_STA_EVENT_ID) && is_ap) {
+		wl1271_debug(DEBUG_EVENT, "INACTIVE_STA_EVENT_ID");
+		sta_bitmap |= le16_to_cpu(mbox->sta_aging_status);
+		disconnect_sta = true;
+	}
+
+	if (is_ap && disconnect_sta) {
+		u32 num_packets = wl->conf.tx.max_tx_retries;
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
 	if (wl->vif && beacon_loss)
 		ieee80211_connection_loss(wl->vif);
 
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
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index b85edcc..1698645 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -433,7 +433,7 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_max_tx_retry(wl);
+	ret = wl1271_acx_ap_max_tx_retry(wl);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 547e5d9..e84a662 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -209,7 +209,8 @@ static struct conf_drv_settings default_conf = {
 				.tx_op_limit = 1504,
 			},
 		},
-		.ap_max_tx_retries = 100,
+		.max_tx_retries = 100,
+		.ap_aging_period = 300,
 		.tid_conf_count = 4,
 		.tid_conf = {
 			[CONF_TX_AC_BE] = {
@@ -3379,6 +3380,12 @@ static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
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
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index daf6964..15e3337 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -173,7 +173,6 @@ extern u32 wl12xx_debug_level;
 #define WL1271_PS_STA_MAX_BLOCKS  (2 * 9)
 
 #define WL1271_AP_BSS_INDEX        0
-#define WL1271_AP_DEF_INACTIV_SEC  300
 #define WL1271_AP_DEF_BEACON_EXP   20
 
 #define ACX_TX_DESCRIPTORS         32
-- 
1.7.4.1

