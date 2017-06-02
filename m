Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36507 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdFBOP7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 10:15:59 -0400
Received: by mail-pf0-f196.google.com with SMTP id n23so11878101pfb.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 07:15:59 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 6/6] rsi: add tx frame for common device configuration
Date: Fri,  2 Jun 2017 19:43:05 +0530
Message-Id: <1496412785-8720-7-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170602_161603_481320_784F3B3A)
In-Reply-To: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
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
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 132 +++++++++++++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_hal.h      |   3 +
 drivers/net/wireless/rsi/rsi_main.h     |  11 ++-
 drivers/net/wireless/rsi/rsi_mgmt.h     |  97 +++++++++++++++++++++++
 5 files changed, 232 insertions(+), 14 deletions(-)

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
index b2950aa..237e59a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -206,6 +206,39 @@ static struct bootup_params boot_params_40 = {
 	.beacon_resedue_alg_en = 0,
 };
 
+#define UNUSED_GPIO	1
+#define USED_GPIO	0
+static struct rsi_ulp_gpio_vals unused_ulp_gpio_bitmap = {
+	.motion_sensor_gpio_ulp_wakeup = UNUSED_GPIO,
+	.sleep_ind_from_device = UNUSED_GPIO,
+	.ulp_gpio_2 = UNUSED_GPIO,
+	.push_button_ulp_wakeup = UNUSED_GPIO,
+};
+
+static struct rsi_soc_gpio_vals unused_soc_gpio_bitmap = {
+	.pspi_csn_0		= USED_GPIO,	//GPIO_0
+	.pspi_csn_1		= USED_GPIO,	//GPIO_1
+	.host_wakeup_intr	= USED_GPIO,	//GPIO_2
+	.pspi_data_0		= USED_GPIO,	//GPIO_3
+	.pspi_data_1		= USED_GPIO,	//GPIO_4
+	.pspi_data_2		= USED_GPIO,	//GPIO_5
+	.pspi_data_3		= USED_GPIO,	//GPIO_6
+	.i2c_scl		= USED_GPIO,	//GPIO_7
+	.i2c_sda		= USED_GPIO,	//GPIO_8
+	.uart1_rx		= UNUSED_GPIO,	//GPIO_9
+	.uart1_tx		= UNUSED_GPIO,	//GPIO_10
+	.uart1_rts_i2s_clk	= UNUSED_GPIO,	//GPIO_11
+	.uart1_cts_i2s_ws	= UNUSED_GPIO,	//GPIO_12
+	.dbg_uart_rx_i2s_din	= UNUSED_GPIO,	//GPIO_13
+	.dbg_uart_tx_i2s_dout	= UNUSED_GPIO,	//GPIO_14
+	.lp_wakeup_boot_bypass	= UNUSED_GPIO,	//GPIO_15
+	.led_0			= USED_GPIO,	//GPIO_16
+	.btcoex_wlan_active_ext_pa_ant_sel_A = UNUSED_GPIO, //GPIO_17
+	.btcoex_bt_priority_ext_pa_ant_sel_B = UNUSED_GPIO, //GPIO_18
+	.btcoex_bt_active_ext_pa_on_off = UNUSED_GPIO, //GPIO_19
+	.rf_reset		= USED_GPIO, //GPIO_20
+	.sleep_ind_from_device	= UNUSED_GPIO,
+};
 static u16 mcs[] = {13, 26, 39, 52, 78, 104, 117, 130};
 
 /**
@@ -224,6 +257,12 @@ static void rsi_set_default_parameters(struct rsi_common *common)
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
@@ -762,6 +801,52 @@ int rsi_hal_load_key(struct rsi_common *common,
 }
 
 /*
+ * This function sends the common device configuration parameters to device.
+ * This frame includes the useful information to make device works on
+ * specific operating mode.
+ */
+static int rsi_send_common_dev_params(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	u32 frame_len;
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
+	dev_cfgs->len = frame_len - FRAME_DESC_SZ;
+	dev_cfgs->q_no = RSI_COEX_Q;
+	dev_cfgs->pkt_type = COMMON_DEV_CONFIG;
+
+	dev_cfgs->lp_ps_handshake = common->lp_ps_handshake_mode;
+	dev_cfgs->ulp_ps_handshake = common->ulp_ps_handshake_mode;
+
+	dev_cfgs->unused_ulp_gpio = *(u8 *)&unused_ulp_gpio_bitmap;
+	dev_cfgs->unused_soc_gpio_bitmap = *(u32 *)&unused_soc_gpio_bitmap;
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
@@ -1493,6 +1578,40 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
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
@@ -1505,7 +1624,6 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 {
 	s32 msg_len = (le16_to_cpu(*(__le16 *)&msg[0]) & 0x0fff);
 	u16 msg_type = (msg[2]);
-	int ret;
 
 	rsi_dbg(FSM_ZONE, "%s: Msg Len: %d, Msg Type: %4x\n",
 		__func__, msg_len, msg_type);
@@ -1515,17 +1633,7 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
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
index f12e5d9..43c74a5 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -34,8 +34,10 @@
 enum RSI_FSM_STATES {
 	FSM_FW_NOT_LOADED,
 	FSM_CARD_NOT_READY,
+	FSM_COMMON_DEV_PARAMS_SENT,
 	FSM_BOOT_PARAMS_SENT,
 	FSM_EEPROM_READ_MAC_ADDR,
+	FSM_EEPROM_READ_RF_TYPE,
 	FSM_RESET_MAC_SENT,
 	FSM_RADIO_CAPS_SENT,
 	FSM_BB_RF_PROG_SENT,
@@ -210,8 +212,14 @@ struct rsi_common {
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
@@ -234,6 +242,7 @@ struct rsi_hw {
 
 	enum host_intf rsi_host_intf;
 	u16 block_size;
+	u32 usb_buffer_status_reg;
 #ifdef CONFIG_RSI_DEBUGFS
 	struct rsi_debugfs *dfsentry;
 	u8 num_debugfs_entries;
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index dfbf7a5..4cff27d 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -205,6 +205,7 @@ enum cmd_frame_type {
 	CW_MODE_REQ,
 	PER_CMD_PKT,
 	ANT_SEL_FRAME = 0x20,
+	COMMON_DEV_CONFIG = 0x28,
 	RADIO_PARAMS_UPDATE = 0x29
 };
 
@@ -282,6 +283,102 @@ struct rsi_radio_caps {
 	__le16 preamble_type;
 } __packed;
 
+struct rsi_ulp_gpio_vals {
+#ifdef __LITTLE_ENDIAN
+	u8 motion_sensor_gpio_ulp_wakeup:1;
+	u8 sleep_ind_from_device:1;
+	u8 ulp_gpio_2:1;
+	u8 push_button_ulp_wakeup:1;
+	u8 reserved:4;
+#else
+	u8 reserved:4;
+	u8 push_button_ulp_wakeup:1;
+	u8 ulp_gpio_2:1;
+	u8 sleep_ind_from_device:1;
+	u8 motion_sensor_gpio_ulp_wakeup:1;
+#endif
+} __packed;
+
+struct rsi_soc_gpio_vals {
+#ifdef __LITTLE_ENDIAN
+	u32 pspi_csn_0:1;
+	u32 pspi_csn_1:1;
+	u32 host_wakeup_intr:1;
+	u32 pspi_data_0:1;
+	u32 pspi_data_1:1;
+	u32 pspi_data_2:1;
+	u32 pspi_data_3:1;
+	u32 i2c_scl:1;
+	u32 i2c_sda:1;
+	u32 uart1_rx:1;
+	u32 uart1_tx:1;
+	u32 uart1_rts_i2s_clk:1;
+	u32 uart1_cts_i2s_ws:1;
+	u32 dbg_uart_rx_i2s_din:1;
+	u32 dbg_uart_tx_i2s_dout:1;
+	u32 lp_wakeup_boot_bypass:1;
+	u32 led_0:1;
+	u32 btcoex_wlan_active_ext_pa_ant_sel_A:1;
+	u32 btcoex_bt_priority_ext_pa_ant_sel_B:1;
+	u32 btcoex_bt_active_ext_pa_on_off:1;
+	u32 rf_reset:1;
+	u32 sleep_ind_from_device:1;
+#else
+	u32 sleep_ind_from_device:1;
+	u32 rf_reset:1;
+	u32 btcoex_bt_active_ext_pa_on_off:1;
+	u32 btcoex_bt_priority_ext_pa_ant_sel_B:1;
+	u32 btcoex_wlan_active_ext_pa_ant_sel_A:1;
+	u32 led_0:1;
+	u32 lp_wakeup_boot_bypass:1;
+	u32 dbg_uart_tx_i2s_dout:1;
+	u32 dbg_uart_rx_i2s_din:1;
+	u32 uart1_cts_i2s_ws:1;
+	u32 uart1_rts_i2s_clk:1;
+	u32 uart1_tx:1;
+	u32 uart1_rx:1;
+	u32 i2c_sda:1;
+	u32 i2c_scl:1;
+	u32 pspi_data_3:1;
+	u32 pspi_data_2:1;
+	u32 pspi_data_1:1;
+	u32 pspi_data_0:1;
+	u32 host_wakeup_intr:1;
+	u32 pspi_csn_1:1;
+	u32 pspi_csn_0:1;
+#endif
+} __packed;
+
+struct rsi_config_vals {
+#ifdef __LITTLE_ENDIAN
+	u16 len:12;
+	u16 q_no:4;
+#else
+	u16 q_no:4;
+	u16 len:12;
+#endif
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
+	u32 unused_soc_gpio_bitmap;
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
-- 
2.7.4
