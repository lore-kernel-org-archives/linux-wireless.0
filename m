Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33875 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754404AbdFPOoz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:44:55 -0400
Received: by mail-pg0-f65.google.com with SMTP id j186so6583651pge.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:44:55 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 6/6] rsi: add tx frame for common device configuration
Date: Fri, 16 Jun 2017 20:12:05 +0530
Message-Id: <1497624125-2047-1-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_164510_986723_039C7678)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

After successful loading of firmware, a CARD READY indication is
received by host. Common device configuration parameters are sent
to the device after this. It includes information like device
operating mode (Wi-Fi alone or BT coex), power save related
parameters, GPIO information etc. As device supports BT coex,
this frame is send in COEX queue initially. Based on the operating
mode, CARD READY indication is received from each protocol module
in firmware i.e. WLAN, BT.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c  |   3 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 100 ++++++++++++++++++++++++++++----
 drivers/net/wireless/rsi/rsi_hal.h      |   3 +
 drivers/net/wireless/rsi/rsi_main.h     |  10 +++-
 drivers/net/wireless/rsi/rsi_mgmt.h     |  76 ++++++++++++++++++++++++
 5 files changed, 178 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 94e074d..c230359 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -718,7 +718,8 @@ int rsi_hal_device_init(struct rsi_hw *adapter)
 {
 	struct rsi_common *common = adapter->priv;
 
-	common->coex_mode = 1;
+	common->coex_mode = RSI_DEV_COEX_MODE_WIFI_ALONE;
+	common->oper_mode = RSI_DEV_OPMODE_WIFI_ALONE;
 	adapter->device_model = RSI_DEV_9113;
 
 	switch (adapter->device_model) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index b2950aa..83ce81a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -224,6 +224,12 @@ static void rsi_set_default_parameters(struct rsi_common *common)
 	common->fsm_state = FSM_CARD_NOT_READY;
 	common->iface_down = true;
 	common->endpoint = EP_2GHZ_20MHZ;
+	common->driver_mode = 1; /* End to end mode */
+	common->lp_ps_handshake_mode = 0; /* Default no handShake mode*/
+	common->ulp_ps_handshake_mode = 2; /* Default PKT handShake mode*/
+	common->rf_power_val = 0; /* Default 1.9V */
+	common->wlan_rf_power_mode = 0;
+	common->obm_ant_sel_val = 2;
 }
 
 /**
@@ -762,6 +768,53 @@ int rsi_hal_load_key(struct rsi_common *common,
 }
 
 /*
+ * This function sends the common device configuration parameters to device.
+ * This frame includes the useful information to make device works on
+ * specific operating mode.
+ */
+static int rsi_send_common_dev_params(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	u16 frame_len;
+	struct rsi_config_vals *dev_cfgs;
+
+	frame_len = sizeof(struct rsi_config_vals);
+
+	rsi_dbg(MGMT_TX_ZONE, "Sending common device config params\n");
+	skb = dev_alloc_skb(frame_len);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to allocate skb\n", __func__);
+		return -ENOMEM;
+	}
+
+	memset(skb->data, 0, frame_len);
+
+	dev_cfgs = (struct rsi_config_vals *)skb->data;
+	memset(dev_cfgs, 0, (sizeof(struct rsi_config_vals)));
+
+	rsi_set_len_qno(&dev_cfgs->len_qno, (frame_len - FRAME_DESC_SZ),
+			RSI_COEX_Q);
+	dev_cfgs->pkt_type = COMMON_DEV_CONFIG;
+
+	dev_cfgs->lp_ps_handshake = common->lp_ps_handshake_mode;
+	dev_cfgs->ulp_ps_handshake = common->ulp_ps_handshake_mode;
+
+	dev_cfgs->unused_ulp_gpio = RSI_UNUSED_ULP_GPIO_BITMAP;
+	dev_cfgs->unused_soc_gpio_bitmap =
+				cpu_to_le32(RSI_UNUSED_SOC_GPIO_BITMAP);
+
+	dev_cfgs->opermode = common->oper_mode;
+	dev_cfgs->wlan_rf_pwr_mode = common->wlan_rf_power_mode;
+	dev_cfgs->driver_mode = common->driver_mode;
+	dev_cfgs->region_code = NL80211_DFS_FCC;
+	dev_cfgs->antenna_sel_val = common->obm_ant_sel_val;
+
+	skb_put(skb, frame_len);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/*
  * rsi_load_bootup_params() - This function send bootup params to the firmware.
  * @common: Pointer to the driver private structure.
  *
@@ -1493,6 +1546,40 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 	return -EINVAL;
 }
 
+static int rsi_handle_card_ready(struct rsi_common *common, u8 *msg)
+{
+	switch (common->fsm_state) {
+	case FSM_CARD_NOT_READY:
+		rsi_dbg(INIT_ZONE, "Card ready indication from Common HAL\n");
+		rsi_set_default_parameters(common);
+		if (rsi_send_common_dev_params(common) < 0)
+			return -EINVAL;
+		common->fsm_state = FSM_COMMON_DEV_PARAMS_SENT;
+		break;
+	case FSM_COMMON_DEV_PARAMS_SENT:
+		rsi_dbg(INIT_ZONE, "Card ready indication from WLAN HAL\n");
+
+		/* Get usb buffer status register address */
+		common->priv->usb_buffer_status_reg = *(u32 *)&msg[8];
+		rsi_dbg(INFO_ZONE, "USB buffer status register = %x\n",
+			common->priv->usb_buffer_status_reg);
+
+		if (rsi_load_bootup_params(common)) {
+			common->fsm_state = FSM_CARD_NOT_READY;
+			return -EINVAL;
+		}
+		common->fsm_state = FSM_BOOT_PARAMS_SENT;
+		break;
+	default:
+		rsi_dbg(ERR_ZONE,
+			"%s: card ready indication in invalid state %d.\n",
+			__func__, common->fsm_state);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * rsi_mgmt_pkt_recv() - This function processes the management packets
  *			 recieved from the hardware.
@@ -1505,7 +1592,6 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 {
 	s32 msg_len = (le16_to_cpu(*(__le16 *)&msg[0]) & 0x0fff);
 	u16 msg_type = (msg[2]);
-	int ret;
 
 	rsi_dbg(FSM_ZONE, "%s: Msg Len: %d, Msg Type: %4x\n",
 		__func__, msg_len, msg_type);
@@ -1515,17 +1601,7 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 	} else if (msg_type == CARD_READY_IND) {
 		rsi_dbg(FSM_ZONE, "%s: Card ready indication received\n",
 			__func__);
-		if (common->fsm_state == FSM_CARD_NOT_READY) {
-			rsi_set_default_parameters(common);
-
-			ret = rsi_load_bootup_params(common);
-			if (ret)
-				return ret;
-			else
-				common->fsm_state = FSM_BOOT_PARAMS_SENT;
-		} else {
-			return -EINVAL;
-		}
+		return rsi_handle_card_ready(common, msg);
 	} else if (msg_type == TX_STATUS_IND) {
 		if (msg[15] == PROBEREQ_CONFIRM) {
 			common->mgmt_q_block = false;
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index b95200d..902dc54 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -63,6 +63,9 @@
 
 #define COMMAN_HAL_WAIT_FOR_CARD_READY	1
 
+#define RSI_DEV_OPMODE_WIFI_ALONE	1
+#define RSI_DEV_COEX_MODE_WIFI_ALONE	1
+
 struct bl_header {
 	__le32 flags;
 	__le32 image_no;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index f12e5d9..f398525 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -34,6 +34,7 @@
 enum RSI_FSM_STATES {
 	FSM_FW_NOT_LOADED,
 	FSM_CARD_NOT_READY,
+	FSM_COMMON_DEV_PARAMS_SENT,
 	FSM_BOOT_PARAMS_SENT,
 	FSM_EEPROM_READ_MAC_ADDR,
 	FSM_RESET_MAC_SENT,
@@ -210,8 +211,14 @@ struct rsi_common {
 	struct cqm_info cqm_info;
 
 	bool hw_data_qs_blocked;
+	u8 driver_mode;
 	u8 coex_mode;
-	
+	u16 oper_mode;
+	u8 lp_ps_handshake_mode;
+	u8 ulp_ps_handshake_mode;
+	u8 rf_power_val;
+	u8 wlan_rf_power_mode;
+	u8 obm_ant_sel_val;
 	int tx_power;
 	u8 ant_in_use;
 };
@@ -234,6 +241,7 @@ struct rsi_hw {
 
 	enum host_intf rsi_host_intf;
 	u16 block_size;
+	u32 usb_buffer_status_reg;
 #ifdef CONFIG_RSI_DEBUGFS
 	struct rsi_debugfs *dfsentry;
 	u8 num_debugfs_entries;
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index dfbf7a5..dcb6db7 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -205,6 +205,7 @@ enum cmd_frame_type {
 	CW_MODE_REQ,
 	PER_CMD_PKT,
 	ANT_SEL_FRAME = 0x20,
+	COMMON_DEV_CONFIG = 0x28,
 	RADIO_PARAMS_UPDATE = 0x29
 };
 
@@ -282,6 +283,76 @@ struct rsi_radio_caps {
 	__le16 preamble_type;
 } __packed;
 
+/* ULP GPIO flags */
+#define RSI_GPIO_MOTION_SENSOR_ULP_WAKEUP	BIT(0)
+#define RSI_GPIO_SLEEP_IND_FROM_DEVICE		BIT(1)
+#define RSI_GPIO_2_ULP				BIT(2)
+#define RSI_GPIO_PUSH_BUTTON_ULP_WAKEUP		BIT(3)
+
+/* SOC GPIO flags */
+#define RSI_GPIO_0_PSPI_CSN_0			BIT(0)
+#define RSI_GPIO_1_PSPI_CSN_1			BIT(1)
+#define RSI_GPIO_2_HOST_WAKEUP_INTR		BIT(2)
+#define RSI_GPIO_3_PSPI_DATA_0			BIT(3)
+#define RSI_GPIO_4_PSPI_DATA_1			BIT(4)
+#define RSI_GPIO_5_PSPI_DATA_2			BIT(5)
+#define RSI_GPIO_6_PSPI_DATA_3			BIT(6)
+#define RSI_GPIO_7_I2C_SCL			BIT(7)
+#define RSI_GPIO_8_I2C_SDA			BIT(8)
+#define RSI_GPIO_9_UART1_RX			BIT(9)
+#define RSI_GPIO_10_UART1_TX			BIT(10)
+#define RSI_GPIO_11_UART1_RTS_I2S_CLK		BIT(11)
+#define RSI_GPIO_12_UART1_CTS_I2S_WS		BIT(12)
+#define RSI_GPIO_13_DBG_UART_RX_I2S_DIN		BIT(13)
+#define RSI_GPIO_14_DBG_UART_RX_I2S_DOUT	BIT(14)
+#define RSI_GPIO_15_LP_WAKEUP_BOOT_BYPASS	BIT(15)
+#define RSI_GPIO_16_LED_0			BIT(16)
+#define RSI_GPIO_17_BTCOEX_WLAN_ACT_EXT_ANT_SEL	BIT(17)
+#define RSI_GPIO_18_BTCOEX_BT_PRIO_EXT_ANT_SEL	BIT(18)
+#define RSI_GPIO_19_BTCOEX_BT_ACT_EXT_ON_OFF	BIT(19)
+#define RSI_GPIO_20_RF_RESET			BIT(20)
+#define RSI_GPIO_21_SLEEP_IND_FROM_DEVICE	BIT(21)
+
+#define RSI_UNUSED_SOC_GPIO_BITMAP (RSI_GPIO_9_UART1_RX | \
+				    RSI_GPIO_10_UART1_TX | \
+				    RSI_GPIO_11_UART1_RTS_I2S_CLK | \
+				    RSI_GPIO_12_UART1_CTS_I2S_WS | \
+				    RSI_GPIO_13_DBG_UART_RX_I2S_DIN | \
+				    RSI_GPIO_14_DBG_UART_RX_I2S_DOUT | \
+				    RSI_GPIO_15_LP_WAKEUP_BOOT_BYPASS | \
+				    RSI_GPIO_17_BTCOEX_WLAN_ACT_EXT_ANT_SEL | \
+				    RSI_GPIO_18_BTCOEX_BT_PRIO_EXT_ANT_SEL | \
+				    RSI_GPIO_19_BTCOEX_BT_ACT_EXT_ON_OFF | \
+				    RSI_GPIO_21_SLEEP_IND_FROM_DEVICE)
+
+#define RSI_UNUSED_ULP_GPIO_BITMAP (RSI_GPIO_MOTION_SENSOR_ULP_WAKEUP | \
+				    RSI_GPIO_SLEEP_IND_FROM_DEVICE | \
+				    RSI_GPIO_2_ULP | \
+				    RSI_GPIO_PUSH_BUTTON_ULP_WAKEUP);
+struct rsi_config_vals {
+	__le16 len_qno;
+	u8 pkt_type;
+	u8 misc_flags;
+	__le16 reserved1[6];
+	u8 lp_ps_handshake;
+	u8 ulp_ps_handshake;
+	u8 sleep_config_params; /* 0 for no handshake,
+				 * 1 for GPIO based handshake,
+				 * 2 packet handshake
+				 */
+	u8 unused_ulp_gpio;
+	__le32 unused_soc_gpio_bitmap;
+	u8 ext_pa_or_bt_coex_en;
+	u8 opermode;
+	u8 wlan_rf_pwr_mode;
+	u8 bt_rf_pwr_mode;
+	u8 zigbee_rf_pwr_mode;
+	u8 driver_mode;
+	u8 region_code;
+	u8 antenna_sel_val;
+	u8 reserved2[16];
+} __packed;
+
 static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
 {
 	return (le16_to_cpu(*(__le16 *)&addr[offset]) & 0x7000) >> 12;
@@ -307,6 +378,11 @@ static inline u8 rsi_get_channel(u8 *addr)
 	return *(char *)(addr + 15);
 }
 
+static inline void rsi_set_len_qno(__le16 *addr, u16 len, u8 qno)
+{
+	*addr = cpu_to_le16(len | ((qno & 7) << 12));
+}
+
 int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg);
 int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode,
 			     u8 vap_status);
-- 
2.7.4
