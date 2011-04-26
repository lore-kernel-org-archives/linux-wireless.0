Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61859 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1DZUWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 16:22:01 -0400
Received: by wwk4 with SMTP id 4so2656857wwk.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 13:22:00 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] wl12xx: support FW TX inactivity triggers
Date: Tue, 26 Apr 2011 23:21:51 +0300
Message-Id: <1303849311-8817-1-git-send-email-arik@wizery.com> (sfid-20110426_222206_878007_FB74B326)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode we register for the MAX_TX_RETRY and INACTIVE_STA events.
Both are reported to the upper layers as a TX failure in the offending
stations.

In STA mode we register only for the MAX_TX_RETRY event. A TX failure is
interpreted as a loss of connection.

Support for IEEE80211_HW_REPORTS_TX_ACK_STATUS has been removed to avoid
the inherent race condition of a mac80211 TX failure counter in addition
to the FW counter.

This patch depends on "mac80211: allow low level driver to report packet
loss"

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---

v1->2: STA mode configuration for max TX retries is performed using
a different FW command.

 drivers/net/wireless/wl12xx/acx.c    |   34 +++++++++++++++++++++---
 drivers/net/wireless/wl12xx/acx.h    |   12 +++++++-
 drivers/net/wireless/wl12xx/boot.c   |    6 +++-
 drivers/net/wireless/wl12xx/cmd.c    |    2 +-
 drivers/net/wireless/wl12xx/conf.h   |   12 +++++++-
 drivers/net/wireless/wl12xx/event.c  |   47 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/event.h  |   12 ++++++++-
 drivers/net/wireless/wl12xx/init.c   |    6 +++-
 drivers/net/wireless/wl12xx/main.c   |   10 ++++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 -
 10 files changed, 125 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 18a8828..8a39d1e 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1524,22 +1524,46 @@ out:
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
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_sta_max_tx_retry(struct wl1271 *wl)
+{
+	struct wl1271_acx_sta_max_tx_retry *acx = NULL;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx sta max tx retry");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx)
+		return -ENOMEM;
+
+	acx->max_tx_retry = wl->conf.tx.max_tx_retries;
+
+	ret = wl1271_cmd_configure(wl, ACX_CONS_TX_FAILURE, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx sta max tx retry failed: %d", ret);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index dd75463..2dde034 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1145,7 +1145,7 @@ struct wl1271_acx_fw_tsf_information {
 	u8 padding[3];
 } __packed;
 
-struct wl1271_acx_max_tx_retry {
+struct wl1271_acx_ap_max_tx_retry {
 	struct acx_header header;
 
 	/*
@@ -1156,6 +1156,13 @@ struct wl1271_acx_max_tx_retry {
 	u8 padding_1[2];
 } __packed;
 
+struct wl1271_acx_sta_max_tx_retry {
+	struct acx_header header;
+
+	u8 max_tx_retry;
+	u8 padding_1[3];
+} __packed;
+
 struct wl1271_acx_config_ps {
 	struct acx_header header;
 
@@ -1367,7 +1374,8 @@ int wl1271_acx_set_ba_session(struct wl1271 *wl,
 int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 				       bool enable);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
-int wl1271_acx_max_tx_retry(struct wl1271 *wl);
+int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl);
+int wl1271_acx_sta_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 2b0cf85..d263ebb 100644
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
index 9917129..bfe74d4 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1077,7 +1077,7 @@ int wl1271_cmd_start_bss(struct wl1271 *wl)
 
 	memcpy(cmd->bssid, bss_conf->bssid, ETH_ALEN);
 
-	cmd->aging_period = cpu_to_le16(WL1271_AP_DEF_INACTIV_SEC);
+	cmd->aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
 	cmd->bss_index = WL1271_AP_BSS_INDEX;
 	cmd->global_hlid = WL1271_AP_GLOBAL_HLID;
 	cmd->broadcast_hlid = WL1271_AP_BROADCAST_HLID;
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index a5841ce..9b36944 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -690,10 +690,18 @@ struct conf_tx_settings {
 	struct conf_tx_rate_class ap_bcst_conf;
 
 	/*
-	 * AP-mode - allow this number of TX retries to a station before an
+	 * Allow this number of TX retries to a connected station/AP before an
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
index ae69330..d7be3ae 100644
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
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index d2dc09e..46fd721 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -380,6 +380,10 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	ret = wl1271_acx_sta_max_tx_retry(wl);
+	if (ret < 0)
+		return ret;
+
 	ret = wl1271_acx_sta_mem_cfg(wl);
 	if (ret < 0)
 		return ret;
@@ -446,7 +450,7 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_max_tx_retry(wl);
+	ret = wl1271_acx_ap_max_tx_retry(wl);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dad81f6..8a7a8c5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -192,7 +192,8 @@ static struct conf_drv_settings default_conf = {
 			.long_retry_limit    = 10,
 			.aflags              = 0,
 		},
-		.ap_max_tx_retries = 100,
+		.max_tx_retries = 100,
+		.ap_aging_period = 300,
 		.tid_conf_count = 4,
 		.tid_conf = {
 			[CONF_TX_AC_BE] = {
@@ -2996,6 +2997,12 @@ static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
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
@@ -3578,7 +3585,6 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_CONNECTION_MONITOR |
 		IEEE80211_HW_SUPPORTS_CQM_RSSI |
-		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_AP_LINK_PS;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b760143..f3de962 100644
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

