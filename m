Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:48836 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab1ACNlM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 08:41:12 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v5 1/2] wl12xx: BA initiator support
Date: Mon,  3 Jan 2011 15:42:43 +0200
Message-Id: <1294062164-3459-2-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
References: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 80211n BA initiator session support wl1271 driver.
Include BA supported FW version auto detection mechanism.
BA initiator session management included in FW independently.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Limitation:
- For now only one BA per direction is supported

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

Changes from v3:
- New FW file name due to new FW API

Changes from v4:
- Reverse change of "New FW file name due to new FW API"
- Add supported FW version auto detection mechanism (Parsing fw version once and
  use it to validate BA support)

 drivers/net/wireless/wl12xx/acx.c    |   50 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   41 ++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/boot.c   |   41 +++++++++++++++++++++++++--
 drivers/net/wireless/wl12xx/conf.h   |    7 +++++
 drivers/net/wireless/wl12xx/init.c   |   50 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/main.c   |   14 ++++++---
 drivers/net/wireless/wl12xx/wl12xx.h |   15 +++++++++-
 7 files changed, 207 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index cc4068d..54fd68d 100644
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
+	acx->win_size = BA_WIN_SIZE;
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
index 9cbc3f4..df48468 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1051,6 +1051,40 @@ struct wl1271_acx_ht_information {
 	u8 padding[3];
 } __packed;
 
+#define BA_WIN_SIZE 8
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
 
@@ -1113,8 +1147,8 @@ enum {
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
@@ -1185,6 +1219,9 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    bool allow_ht_operation);
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
+int wl1271_acx_set_ba_session(struct wl1271 *wl,
+			      enum ieee80211_back_parties direction,
+			      u8 tid_index, u8 policy);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 4a9f929..cd42e12 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -101,6 +101,39 @@ static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 	wl1271_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
 }
 
+static void wl1271_save_fw_ver(struct wl1271 *wl)
+{
+	char fw_ver_str[ETHTOOL_BUSINFO_LEN];
+	char *fw_ver_point;
+	int ret, i;
+
+	/* copy the fw version to temp str */
+	strncpy(fw_ver_str, wl->chip.fw_ver_str, sizeof(fw_ver_str));
+
+	for (i = (WL12XX_NUM_FW_VER - 1); i > 0; --i) {
+		/* find the last '.' */
+		fw_ver_point = strrchr(fw_ver_str, '.');
+
+		/* read version number */
+		ret = strict_strtoul(fw_ver_point+1, 10, &(wl->chip.fw_ver[i]));
+		if (ret < 0) {
+			wl1271_warning("fw version incorrect value");
+			memset(wl->chip.fw_ver, 0, sizeof(wl->chip.fw_ver));
+			return;
+		}
+
+		/* clean '.' */
+		*fw_ver_point = '\0';
+	}
+
+	ret = strict_strtoul(fw_ver_point-1, 10, &(wl->chip.fw_ver[0]));
+	if (ret < 0) {
+		wl1271_warning("fw version incorrect value");
+		memset(wl->chip.fw_ver, 0, sizeof(wl->chip.fw_ver));
+		return;
+	}
+}
+
 static void wl1271_boot_fw_version(struct wl1271 *wl)
 {
 	struct wl1271_static_data static_data;
@@ -108,11 +141,13 @@ static void wl1271_boot_fw_version(struct wl1271 *wl)
 	wl1271_read(wl, wl->cmd_box_addr, &static_data, sizeof(static_data),
 		    false);
 
-	strncpy(wl->chip.fw_ver, static_data.fw_version,
-		sizeof(wl->chip.fw_ver));
+	strncpy(wl->chip.fw_ver_str, static_data.fw_version,
+		sizeof(wl->chip.fw_ver_str));
 
 	/* make sure the string is NULL-terminated */
-	wl->chip.fw_ver[sizeof(wl->chip.fw_ver) - 1] = '\0';
+	wl->chip.fw_ver_str[sizeof(wl->chip.fw_ver_str) - 1] = '\0';
+
+	wl1271_save_fw_ver(wl);
 }
 
 static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
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
index 785a530..5482b85 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -213,6 +213,51 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
 	return 0;
 }
 
+static void wl1271_check_ba_support(struct wl1271 *wl)
+{
+
+	/* validate FW cose ver x.x.x.50-60.x */
+	if ((wl->chip.fw_ver[3] >= WL12XX_BA_SUPPORT_FW_COST_VER2_START) &&
+	    (wl->chip.fw_ver[3] < WL12XX_BA_SUPPORT_FW_COST_VER2_END)) {
+		wl->ba_support = true;
+		return;
+	}
+
+	/* validate FW sub ver x.x.x.>= 33.339 */
+	if ((wl->chip.fw_ver[4] == WL12XX_BA_SUPPORT_FW_SUB_VER) &&
+	    (wl->chip.fw_ver[4] >= WL12XX_BA_SUPPORT_FW_COST_VER1)) {
+		wl->ba_support = true;
+		return;
+	}
+
+	wl->ba_support = false;
+}
+
+static int wl1271_set_ba_policies(struct wl1271 *wl)
+{
+	u8 tid_index;
+	u8 ret = 0;
+
+	/* Reset the BA RX indicators */
+	wl->ba_allowed = true;
+	wl->ba_rx_bitmap = 0;
+
+	/* validate that FW support BA */
+	wl1271_check_ba_support(wl);
+
+	if (wl->ba_support)
+		/* 802.11n initiator BA session setting */
+		for (tid_index = 0; tid_index < CONF_TX_MAX_TID_COUNT;
+		      ++tid_index) {
+			ret = wl1271_acx_set_ba_session(wl, WLAN_BACK_INITIATOR,
+							tid_index, true);
+			if (ret < 0)
+				break;
+		}
+
+	return ret;
+}
+
 int wl1271_hw_init(struct wl1271 *wl)
 {
 	struct conf_tx_ac_category *conf_ac;
@@ -364,6 +409,11 @@ int wl1271_hw_init(struct wl1271 *wl)
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
index 062247e..c44462d 100644
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
@@ -827,7 +830,7 @@ int wl1271_plt_start(struct wl1271 *wl)
 
 		wl->state = WL1271_STATE_PLT;
 		wl1271_notice("firmware booted in PLT mode (%s)",
-			      wl->chip.fw_ver);
+			      wl->chip.fw_ver_str);
 		goto out;
 
 irq_disable:
@@ -1061,11 +1064,11 @@ power_off:
 
 	wl->vif = vif;
 	wl->state = WL1271_STATE_ON;
-	wl1271_info("firmware booted (%s)", wl->chip.fw_ver);
+	wl1271_info("firmware booted (%s)", wl->chip.fw_ver_str);
 
 	/* update hw/fw version info in wiphy struct */
 	wiphy->hw_version = wl->chip.id;
-	strncpy(wiphy->fw_version, wl->chip.fw_ver,
+	strncpy(wiphy->fw_version, wl->chip.fw_ver_str,
 		sizeof(wiphy->fw_version));
 
 	/*
@@ -2090,7 +2093,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
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
index 01711fe..7b34393 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -38,6 +38,11 @@
 #define DRIVER_NAME "wl1271"
 #define DRIVER_PREFIX DRIVER_NAME ": "
 
+#define WL12XX_BA_SUPPORT_FW_SUB_VER           339
+#define WL12XX_BA_SUPPORT_FW_COST_VER1          33
+#define WL12XX_BA_SUPPORT_FW_COST_VER2_START    50
+#define WL12XX_BA_SUPPORT_FW_COST_VER2_END      60
+
 enum {
 	DEBUG_NONE	= 0,
 	DEBUG_IRQ	= BIT(0),
@@ -161,10 +166,13 @@ struct wl1271_partition_set {
 
 struct wl1271;
 
+#define WL12XX_NUM_FW_VER 5
+
 /* FIXME: I'm not sure about this structure name */
 struct wl1271_chip {
 	u32 id;
-	char fw_ver[21];
+	char fw_ver_str[ETHTOOL_BUSINFO_LEN];
+	unsigned long fw_ver[WL12XX_NUM_FW_VER];
 };
 
 struct wl1271_stats {
@@ -399,6 +407,11 @@ struct wl1271 {
 
 	/* Most recently reported noise in dBm */
 	s8 noise;
+
+	/* RX BA constraint value */
+	bool ba_support;
+	u8 ba_allowed;
+	u8 ba_rx_bitmap;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
-- 
1.7.0.4

