Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbbAYIxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:24 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 01/10] wil6210: sync WMI with firmware
Date: Sun, 25 Jan 2015 10:52:42 +0200
Message-Id: <1422175971-8075-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095333_764146_3705B209)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Incorporate changes from firmware.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 15 +++++----
 drivers/net/wireless/ath/wil6210/wmi.h | 58 ++++++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index b2b0fe1..097d78b 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1133,12 +1133,13 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 	return rc;
 }
 
-int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r)
+int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_bb, u32 *t_rf)
 {
 	int rc;
 	struct wmi_temp_sense_cmd cmd = {
-		.measure_marlon_m_en = cpu_to_le32(!!t_m),
-		.measure_marlon_r_en = cpu_to_le32(!!t_r),
+		.measure_baseband_en = cpu_to_le32(!!t_bb),
+		.measure_rf_en = cpu_to_le32(!!t_rf),
+		.measure_mode = cpu_to_le32(TEMPERATURE_MEASURE_NOW),
 	};
 	struct {
 		struct wil6210_mbox_hdr_wmi wmi;
@@ -1150,10 +1151,10 @@ int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r)
 	if (rc)
 		return rc;
 
-	if (t_m)
-		*t_m = le32_to_cpu(reply.evt.marlon_m_t1000);
-	if (t_r)
-		*t_r = le32_to_cpu(reply.evt.marlon_r_t1000);
+	if (t_bb)
+		*t_bb = le32_to_cpu(reply.evt.baseband_t1000);
+	if (t_rf)
+		*t_rf = le32_to_cpu(reply.evt.rf_t1000);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index b5102f0..8a4af61 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -29,8 +29,10 @@
 
 /* General */
 #define WILOCITY_MAX_ASSOC_STA (8)
+#define WILOCITY_DEFAULT_ASSOC_STA (1)
 #define WMI_MAC_LEN		(6)
 #define WMI_PROX_RANGE_NUM	(3)
+#define WMI_MAX_LOSS_DMG_BEACONS	(32)
 
 /* List of Commands */
 enum wmi_command_id {
@@ -48,7 +50,7 @@ enum wmi_command_id {
 	WMI_SET_WSC_STATUS_CMDID	= 0x0041,
 	WMI_PXMT_RANGE_CFG_CMDID	= 0x0042,
 	WMI_PXMT_SNR2_RANGE_CFG_CMDID	= 0x0043,
-	WMI_FAST_MEM_ACC_MODE_CMDID	= 0x0300,
+/*	WMI_FAST_MEM_ACC_MODE_CMDID	= 0x0300, */
 	WMI_MEM_READ_CMDID		= 0x0800,
 	WMI_MEM_WR_CMDID		= 0x0801,
 	WMI_ECHO_CMDID			= 0x0803,
@@ -102,6 +104,8 @@ enum wmi_command_id {
 	WMI_MAINTAIN_RESUME_CMDID	= 0x0851,
 	WMI_RS_MGMT_CMDID		= 0x0852,
 	WMI_RF_MGMT_CMDID		= 0x0853,
+	WMI_THERMAL_THROTTLING_CTRL_CMDID	= 0x0854,
+	WMI_THERMAL_THROTTLING_GET_STATUS_CMDID	= 0x0855,
 	/* Performance monitoring commands */
 	WMI_BF_CTRL_CMDID		= 0x0862,
 	WMI_NOTIFY_REQ_CMDID		= 0x0863,
@@ -136,6 +140,7 @@ enum wmi_command_id {
 	WMI_EAPOL_TX_CMDID		= 0xf04c,
 	WMI_MAC_ADDR_REQ_CMDID		= 0xf04d,
 	WMI_FW_VER_CMDID		= 0xf04e,
+	WMI_PMC_CMDID			= 0xf04f,
 };
 
 /*
@@ -283,8 +288,8 @@ enum wmi_scan_type {
 	WMI_LONG_SCAN		= 0,
 	WMI_SHORT_SCAN		= 1,
 	WMI_PBC_SCAN		= 2,
-	WMI_ACTIVE_SCAN		= 3,
-	WMI_DIRECT_SCAN		= 4,
+	WMI_DIRECT_SCAN		= 3,
+	WMI_ACTIVE_SCAN		= 4,
 };
 
 struct wmi_start_scan_cmd {
@@ -375,6 +380,17 @@ struct wmi_rf_mgmt_cmd {
 } __packed;
 
 /*
+ * WMI_THERMAL_THROTTLING_CTRL_CMDID
+ */
+#define THERMAL_THROTTLING_USE_DEFAULT_MAX_TXOP_LENGTH	(0xFFFFFFFF)
+
+struct wmi_thermal_throttling_ctrl_cmd {
+	__le32 time_on_usec;
+	__le32 time_off_usec;
+	__le32 max_txop_length_usec;
+} __packed;
+
+/*
  * WMI_RF_RX_TEST_CMDID
  */
 struct wmi_rf_rx_test_cmd {
@@ -648,6 +664,7 @@ enum wmi_cfg_rx_chain_cmd_action {
 enum wmi_cfg_rx_chain_cmd_decap_trans_type {
 	WMI_DECAP_TYPE_802_3			= 0,
 	WMI_DECAP_TYPE_NATIVE_WIFI		= 1,
+	WMI_DECAP_TYPE_NONE			= 2,
 };
 
 enum wmi_cfg_rx_chain_cmd_nwifi_ds_trans_type {
@@ -785,9 +802,17 @@ struct wmi_echo_cmd {
  *
  * Measure MAC and radio temperatures
  */
+
+/* Possible modes for temperature measurement */
+enum wmi_temperature_measure_mode {
+	TEMPERATURE_USE_OLD_VALUE	= 0x1,
+	TEMPERATURE_MEASURE_NOW		= 0x2,
+};
+
 struct wmi_temp_sense_cmd {
-	__le32 measure_marlon_m_en;
-	__le32 measure_marlon_r_en;
+	__le32 measure_baseband_en;
+	__le32 measure_rf_en;
+	__le32 measure_mode;
 } __packed;
 
 /*
@@ -843,6 +868,7 @@ enum wmi_event_id {
 	WMI_BF_RXSS_MGMT_DONE_EVENTID		= 0x1839,
 	WMI_RS_MGMT_DONE_EVENTID		= 0x1852,
 	WMI_RF_MGMT_STATUS_EVENTID		= 0x1853,
+	WMI_THERMAL_THROTTLING_STATUS_EVENTID	= 0x1855,
 	WMI_BF_SM_MGMT_DONE_EVENTID		= 0x1838,
 	WMI_RX_MGMT_PACKET_EVENTID		= 0x1840,
 	WMI_TX_MGMT_PACKET_EVENTID		= 0x1841,
@@ -859,6 +885,7 @@ enum wmi_event_id {
 	WMI_FLASH_READ_DONE_EVENTID		= 0x1902,
 	WMI_FLASH_WRITE_DONE_EVENTID		= 0x1903,
 	/*P2P*/
+	WMI_P2P_CFG_DONE_EVENTID		= 0x1910,
 	WMI_PORT_ALLOCATED_EVENTID		= 0x1911,
 	WMI_PORT_DELETED_EVENTID		= 0x1912,
 	WMI_LISTEN_STARTED_EVENTID		= 0x1914,
@@ -899,6 +926,15 @@ struct wmi_rf_mgmt_status_event {
 } __packed;
 
 /*
+ * WMI_THERMAL_THROTTLING_STATUS_EVENTID
+ */
+struct wmi_thermal_throttling_status_event {
+	__le32 time_on_usec;
+	__le32 time_off_usec;
+	__le32 max_txop_length_usec;
+} __packed;
+
+/*
  * WMI_GET_STATUS_DONE_EVENTID
  */
 struct wmi_get_status_done_event {
@@ -1155,6 +1191,14 @@ struct wmi_get_pcp_channel_event {
 } __packed;
 
 /*
+ * WMI_P2P_CFG_DONE_EVENTID
+ */
+struct wmi_p2p_cfg_done_event {
+	u8 status;	/* wmi_fw_status */
+	u8 reserved[3];
+} __packed;
+
+/*
 * WMI_PORT_ALLOCATED_EVENTID
 */
 struct wmi_port_allocated_event {
@@ -1282,8 +1326,8 @@ struct wmi_echo_event {
  * Measure MAC and radio temperatures
  */
 struct wmi_temp_sense_done_event {
-	__le32 marlon_m_t1000;
-	__le32 marlon_r_t1000;
+	__le32 baseband_t1000;
+	__le32 rf_t1000;
 } __packed;
 
 #endif /* __WILOCITY_WMI_H__ */
-- 
2.1.0

