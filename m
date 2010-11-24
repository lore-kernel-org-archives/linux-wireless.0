Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:54145 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab0KXQ36 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 11:29:58 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v3] wl12xx: BA Initiator support
Date: Wed, 24 Nov 2010 18:29:40 +0200
Message-Id: <1290616180-16473-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 80211n BA initiator session support wl1271 driver.
BA initiator session management included in FW independently.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 Limitation:
- For now only one BA per direction is supported
- BA receiver session not supported in that Series

Changes from v1:
- Remove wl1271_op_ampdu_action()
- set CONF_BA_INACTIVITY_TIMEOUT as configurable value
- Clean to Linux code style.

Changes from v2:
- Two new ACX commands ACX_BA_SESSION_POLICY_CFG & ACX_BA_SESSION_RX_SETUP
- New struct wl1271_acx_ba_session_policy
- Calling wl1271_set_ba_policies() once in init
- Use ieee80211_back_parties
- Rebase to latest


 drivers/net/wireless/wl12xx/acx.c    |   50 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   41 ++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/conf.h   |    7 +++++
 drivers/net/wireless/wl12xx/init.c   |   25 +++++++++++++++++
 drivers/net/wireless/wl12xx/main.c   |    8 ++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    4 +++
 6 files changed, 131 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 7cbaeb6..6c433b7 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1309,6 +1309,56 @@ out:
 	return ret;
 }
 
+/* Configure BA session initiator\receiver parameters setting in the FW. */
+int wl1271_acx_set_ba_session(struct wl1271 *wl,
+			      enum ieee80211_back_parties direction,
+			      u8 tid_index, u8 policy)
+{
+	struct wl1271_acx_ba_session_policy *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx ba session setting");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* ANY role */
+	acx->role_id = 0xff;
+	acx->tid = tid_index;
+	acx->enable = policy;
+	acx->win_size = BA_RECEIVER_WIN_SIZE;
+	acx->ba_direction = direction;
+
+	switch (direction) {
+	case WLAN_BACK_INITIATOR:
+		acx->inactivity_timeout = wl->conf.ht.inactivity_timeout;
+		break;
+	case WLAN_BACK_RECIPIENT:
+		acx->inactivity_timeout = 0;
+		break;
+	default:
+		wl1271_error("Incorrect acx command id=%x\n", direction);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = wl1271_cmd_configure(wl,
+				   ACX_BA_SESSION_POLICY_CFG,
+				   acx,
+				   sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx ba session setting failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime)
 {
 	struct wl1271_acx_fw_tsf_information *tsf_info;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 75a6306..c511dce 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1046,6 +1046,40 @@ struct wl1271_acx_ht_information {
 	u8 padding[3];
 } __packed;
 
+#define BA_RECEIVER_WIN_SIZE 8
+
+struct wl1271_acx_ba_session_policy {
+	struct acx_header header;
+	/*
+	 * Specifies role Id, Range 0-7, 0xFF means ANY role.
+	 * Future use. For now this field is irrelevant
+	 */
+	u8 role_id;
+	/*
+	 * Specifies Link Id, Range 0-31, 0xFF means ANY  Link Id.
+	 * Not applicable if Role Id is set to ANY.
+	 */
+	u8 link_id;
+
+	u8 tid;
+
+	u8 enable;
+
+	/* Windows size in number of packets */
+	u16 win_size;
+
+	/*
+	 * As initiator inactivity timeout in time units(TU) of 1024us.
+	 * As receiver reserved
+	 */
+	u16 inactivity_timeout;
+
+	/* Initiator = 1/Receiver = 0 */
+	u8 ba_direction;
+
+	u8 padding[3];
+} __packed;
+
 struct wl1271_acx_fw_tsf_information {
 	struct acx_header header;
 
@@ -1108,8 +1142,8 @@ enum {
 	ACX_RSSI_SNR_WEIGHTS        = 0x0052,
 	ACX_KEEP_ALIVE_MODE         = 0x0053,
 	ACX_SET_KEEP_ALIVE_CONFIG   = 0x0054,
-	ACX_BA_SESSION_RESPONDER_POLICY = 0x0055,
-	ACX_BA_SESSION_INITIATOR_POLICY = 0x0056,
+	ACX_BA_SESSION_POLICY_CFG   = 0x0055,
+	ACX_BA_SESSION_RX_SETUP     = 0x0056,
 	ACX_PEER_HT_CAP             = 0x0057,
 	ACX_HT_BSS_OPERATION        = 0x0058,
 	ACX_COEX_ACTIVITY           = 0x0059,
@@ -1180,6 +1214,9 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    bool allow_ht_operation);
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
+int wl1271_acx_set_ba_session(struct wl1271 *wl,
+			      enum ieee80211_back_parties direction,
+			      u8 tid_index, u8 policy);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index a16b361..41df771 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1090,6 +1090,12 @@ struct conf_rf_settings {
 	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
 };
 
+#define CONF_BA_INACTIVITY_TIMEOUT 10000
+
+struct conf_ht_setting {
+	u16 inactivity_timeout;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1100,6 +1106,7 @@ struct conf_drv_settings {
 	struct conf_roam_trigger_settings roam_trigger;
 	struct conf_scan_settings scan;
 	struct conf_rf_settings rf;
+	struct conf_ht_setting ht;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 7949d34..adc27c0 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -208,6 +208,26 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
 	return 0;
 }
 
+static int wl1271_set_ba_policies(struct wl1271 *wl)
+{
+	u8 tid_index;
+	u8 ret;
+
+	/* Reset the BA RX indicators */
+	wl->ba_allowed = true;
+	wl->ba_rx_bitmap = 0;
+
+	/* 802.11n initiator BA session setting */
+	for (tid_index = 0; tid_index < CONF_TX_MAX_TID_COUNT; ++tid_index) {
+		ret = wl1271_acx_set_ba_session(wl, WLAN_BACK_INITIATOR,
+						tid_index, true);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
 int wl1271_hw_init(struct wl1271 *wl)
 {
 	struct conf_tx_ac_category *conf_ac;
@@ -359,6 +379,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	/* Configure initiator BA sessions policies */
+	ret = wl1271_set_ba_policies(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	return 0;
 
  out_free_memmap:
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 31f0e2f..b8c42d7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -233,7 +233,7 @@ static struct conf_drv_settings default_conf = {
 		.avg_weight_rssi_beacon       = 20,
 		.avg_weight_rssi_data         = 10,
 		.avg_weight_snr_beacon        = 20,
-		.avg_weight_snr_data          = 10
+		.avg_weight_snr_data          = 10,
 	},
 	.scan = {
 		.min_dwell_time_active        = 7500,
@@ -252,6 +252,9 @@ static struct conf_drv_settings default_conf = {
 			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		},
 	},
+	.ht = {
+		.inactivity_timeout = CONF_BA_INACTIVITY_TIMEOUT,
+	},
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
@@ -2059,7 +2062,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl1271_warning("Set ht cap true failed %d", ret);
 			goto out_sleep;
 		}
-			ret = wl1271_acx_set_ht_information(wl,
+
+		ret = wl1271_acx_set_ht_information(wl,
 				bss_conf->ht_operation_mode);
 		if (ret < 0) {
 			wl1271_warning("Set ht information failed %d", ret);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3c836e6..807ac7a 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -497,6 +497,10 @@ struct wl1271 {
 
 	/* Most recently reported noise in dBm */
 	s8 noise;
+
+	/* RX BA constraint value */
+	u8 ba_allowed;
+	u8 ba_rx_bitmap;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
-- 
1.7.0.4

