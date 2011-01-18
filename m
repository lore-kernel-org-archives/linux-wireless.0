Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59537 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab1ARJaP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 04:30:15 -0500
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0I9UEmx028017
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 03:30:15 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH v6  1/2] wl12xx: BA initiator support
Date: Tue, 18 Jan 2011 11:32:18 +0200
Message-Id: <1295343139-25375-2-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1295343139-25375-1-git-send-email-shahar_levi@ti.com>
References: <1295343139-25375-1-git-send-email-shahar_levi@ti.com>
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

Changes from v5:
- Improve implantation of FW parsing
- Stylish

 drivers/net/wireless/wl12xx/acx.c    |   51 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   41 ++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/boot.c   |   24 ++++++++++++++--
 drivers/net/wireless/wl12xx/conf.h   |    6 ++++
 drivers/net/wireless/wl12xx/init.c   |   42 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/main.c   |   12 +++++--
 drivers/net/wireless/wl12xx/wl12xx.h |   17 ++++++++++-
 7 files changed, 183 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 646d278..588056a 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1342,6 +1342,57 @@ out:
 	return ret;
 }
 
+/* Configure BA session initiator/receiver parameters setting in the FW. */
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
+	acx->ba_direction = direction;
+
+	switch (direction) {
+	case WLAN_BACK_INITIATOR:
+		acx->win_size = wl->conf.ht.tx_ba_win_size;
+		acx->inactivity_timeout = wl->conf.ht.inactivity_timeout;
+		break;
+	case WLAN_BACK_RECIPIENT:
+		acx->win_size = RX_BA_WIN_SIZE;
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
index 89d3748..c0abaf4 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1061,6 +1061,40 @@ struct wl1271_acx_ht_information {
 	u8 padding[3];
 } __packed;
 
+#define RX_BA_WIN_SIZE 8
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
 
@@ -1134,8 +1168,8 @@ enum {
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
@@ -1209,6 +1243,9 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    bool allow_ht_operation);
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
+int wl1271_acx_set_ba_session(struct wl1271 *wl,
+			      enum ieee80211_back_parties direction,
+			      u8 tid_index, u8 policy);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_max_tx_retry(struct wl1271 *wl);
 
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index d7e036f..2e66c0f 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -101,6 +101,22 @@ static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 	wl1271_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
 }
 
+static void wl1271_parse_fw_ver(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = sscanf(wl->chip.fw_ver_str + 4, "%u.%u.%u.%u.%u",
+		     &wl->chip.fw_ver[0], &wl->chip.fw_ver[1],
+		     &wl->chip.fw_ver[2], &wl->chip.fw_ver[3],
+		     &wl->chip.fw_ver[4]);
+
+	if (ret <= 0) {
+		wl1271_warning("fw version incorrect value");
+		memset(wl->chip.fw_ver, 0, sizeof(wl->chip.fw_ver));
+		return;
+	}
+}
+
 static void wl1271_boot_fw_version(struct wl1271 *wl)
 {
 	struct wl1271_static_data static_data;
@@ -108,11 +124,13 @@ static void wl1271_boot_fw_version(struct wl1271 *wl)
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
+	wl1271_parse_fw_ver(wl);
 }
 
 static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index f5c048c..135d837 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1138,6 +1138,11 @@ struct conf_rf_settings {
 	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
 };
 
+struct conf_ht_setting {
+	u16 tx_ba_win_size;
+	u16 inactivity_timeout;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1148,6 +1153,7 @@ struct conf_drv_settings {
 	struct conf_roam_trigger_settings roam_trigger;
 	struct conf_scan_settings scan;
 	struct conf_rf_settings rf;
+	struct conf_ht_setting ht;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index bdb6123..0d939a2 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -455,6 +455,43 @@ static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl)
 	return 0;
 }
 
+static void wl1271_check_ba_support(struct wl1271 *wl)
+{
+	/* validate FW cose ver x.x.x.50-60.x */
+	if ((wl->chip.fw_ver[3] >= WL12XX_BA_SUPPORT_FW_COST_VER2_START) &&
+	    (wl->chip.fw_ver[3] < WL12XX_BA_SUPPORT_FW_COST_VER2_END)) {
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
@@ -568,6 +605,11 @@ int wl1271_hw_init(struct wl1271 *wl)
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
index 9076555..542b1de 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -274,7 +274,7 @@ static struct conf_drv_settings default_conf = {
 		.avg_weight_rssi_beacon       = 20,
 		.avg_weight_rssi_data         = 10,
 		.avg_weight_snr_beacon        = 20,
-		.avg_weight_snr_data          = 10
+		.avg_weight_snr_data          = 10,
 	},
 	.scan = {
 		.min_dwell_time_active        = 7500,
@@ -293,6 +293,10 @@ static struct conf_drv_settings default_conf = {
 			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		},
 	},
+	.ht = {
+		.tx_ba_win_size = 64,
+		.inactivity_timeout = 10000,
+	},
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
@@ -890,7 +894,7 @@ int wl1271_plt_start(struct wl1271 *wl)
 
 		wl->state = WL1271_STATE_PLT;
 		wl1271_notice("firmware booted in PLT mode (%s)",
-			      wl->chip.fw_ver);
+			      wl->chip.fw_ver_str);
 		goto out;
 
 irq_disable:
@@ -1131,11 +1135,11 @@ power_off:
 
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
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index cf5c1a5..443befc 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -38,6 +38,13 @@
 #define DRIVER_NAME "wl1271"
 #define DRIVER_PREFIX DRIVER_NAME ": "
 
+/* 
+ * FW versions support BA 11n
+ * versions marks x.x.x.50-60.x
+ */
+#define WL12XX_BA_SUPPORT_FW_COST_VER2_START    50
+#define WL12XX_BA_SUPPORT_FW_COST_VER2_END      60
+
 enum {
 	DEBUG_NONE	= 0,
 	DEBUG_IRQ	= BIT(0),
@@ -182,10 +189,13 @@ struct wl1271_partition_set {
 
 struct wl1271;
 
+#define WL12XX_NUM_FW_VER 5
+
 /* FIXME: I'm not sure about this structure name */
 struct wl1271_chip {
 	u32 id;
-	char fw_ver[21];
+	char fw_ver_str[ETHTOOL_BUSINFO_LEN];
+	unsigned int fw_ver[WL12XX_NUM_FW_VER];
 };
 
 struct wl1271_stats {
@@ -460,6 +470,11 @@ struct wl1271 {
 
 	/* bands supported by this instance of wl12xx */
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+
+	/* RX BA constraint value */
+	bool ba_support;
+	u8 ba_allowed;
+	u8 ba_rx_bitmap;
 };
 
 struct wl1271_station {
-- 
1.7.0.4

