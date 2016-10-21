Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33907 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754141AbcJUKNm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 06:13:42 -0400
Received: by mail-pf0-f194.google.com with SMTP id 128so8272317pfz.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 03:13:42 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/2] rsi: Device initialization sequence is changed
Date: Fri, 21 Oct 2016 15:40:56 +0530
Message-Id: <1477044656-10402-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161021_121351_978975_077F5A7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BT Co-ex support has been added in the firmware and hence BT, COEX queues are
introducted. To support the latest firmware queues, packet processing,
and initialization sequence is modified in the Host.

Common device configuration parameters (tx command frame) need to be send after
common card ready indication from the firmware. This frame contains information
about the driver mode, coex mode, protocols to support etc. Once it is sent,
then second level card ready indication comes for each protocol (WLAN, BT etc).

Currently host supports only WLAN mode. New command frames are added as part
of these changes.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c     |  14 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 281 ++++++++++++++++++++++++----
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  39 +++-
 drivers/net/wireless/rsi/rsi_91x_usb.c      |  97 ++++++----
 drivers/net/wireless/rsi/rsi_main.h         |  49 ++++-
 drivers/net/wireless/rsi/rsi_mgmt.h         | 195 ++++++++++++++++---
 drivers/net/wireless/rsi/rsi_usb.h          |   1 +
 7 files changed, 559 insertions(+), 117 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 8810862..ad725a4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -121,11 +121,23 @@ int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len)
 		actual_length = *(u16 *)&frame_desc[0];
 		offset = *(u16 *)&frame_desc[2];
 
+		if ((actual_length < (4 + FRAME_DESC_SZ)) || (offset < 4)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: actual_length (%d) is less than 20 or"
+				" offset(%d) is less than 4\n",
+				__func__, actual_length, offset);
+			break;
+		}
 		queueno = rsi_get_queueno(frame_desc, offset);
 		length = rsi_get_length(frame_desc, offset);
-		extended_desc = rsi_get_extended_desc(frame_desc, offset);
+		if (queueno == RSI_WIFI_DATA_Q || queueno == RSI_WIFI_MGMT_Q)
+			extended_desc = rsi_get_extended_desc(frame_desc,
+							      offset);
 
 		switch (queueno) {
+		case RSI_COEX_Q:
+			rsi_mgmt_pkt_recv(common, (frame_desc + offset));
+			break;
 		case RSI_WIFI_DATA_Q:
 			skb = rsi_prepare_skb(common,
 					      (frame_desc + offset),
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 7aec45a..1bffd7d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -18,6 +18,16 @@
 #include "rsi_mgmt.h"
 #include "rsi_common.h"
 
+struct rsi_config_vals dev_config_vals[] = {
+	{
+		.lp_ps_handshake = 0,
+		.ulp_ps_handshake = 0,
+		.sleep_config_params = 0,
+		.ext_pa_or_bt_coex_en = 0,
+	},
+};
+
+/* Bootup Parameters for 20MHz */
 static struct bootup_params boot_params_20 = {
 	.magic_number = cpu_to_le16(0x5aa5),
 	.crystal_good_time = 0x0,
@@ -199,6 +209,39 @@ static struct bootup_params boot_params_40 = {
 	.dcdc_operation_mode = 0x0,
 	.soc_reset_wait_cnt = 0x0
 };
+#define UNUSED_GPIO	1
+#define USED_GPIO	0
+struct rsi_ulp_gpio_vals unused_ulp_gpio_bitmap = {
+	.motion_sensor_gpio_ulp_wakeup = UNUSED_GPIO,
+	.sleep_ind_from_device = UNUSED_GPIO,
+	.ulp_gpio_2 = UNUSED_GPIO,
+	.push_button_ulp_wakeup = UNUSED_GPIO,
+};
+
+struct rsi_soc_gpio_vals unused_soc_gpio_bitmap = {
+	.pspi_csn_0		= USED_GPIO,	//GPIO_0
+	.pspi_csn_1		= USED_GPIO,	//GPIO_1
+	.host_wakeup_intr	= UNUSED_GPIO,	//GPIO_2
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
 
@@ -218,6 +261,26 @@ static void rsi_set_default_parameters(struct rsi_common *common)
 	common->fsm_state = FSM_CARD_NOT_READY;
 	common->iface_down = true;
 	common->endpoint = EP_2GHZ_20MHZ;
+	common->driver_mode = 1; /* End-to-End Mode */
+#ifdef CONFIG_RSI_COEX
+	common->coex_mode = 4;
+#else
+	common->coex_mode = 1; /*Default coex mode is WIFI alone */
+#endif
+	common->oper_mode = 1;
+	common->ta_aggr = 0;
+	common->skip_fw_load = 0; /* Default disable skipping fw loading */
+	common->lp_ps_handshake_mode = 0; /* Default No HandShake mode*/
+	common->ulp_ps_handshake_mode = 2; /* Default PKT HandShake mode*/
+	common->rf_power_val = 0; /* Default 1.9V */
+	common->device_gpio_type = TA_GPIO; /* Default TA GPIO */
+	common->country_code = 840; /* Default US */
+	common->wlan_rf_power_mode = 0;
+	common->bt_rf_power_mode = 0;
+	common->obm_ant_sel_val = 2;
+	common->antenna_diversity = 0;
+	common->tx_power = RSI_TXPOWER_MAX;
+
 }
 
 /**
@@ -301,10 +364,11 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 	radio_caps = (struct rsi_radio_caps *)skb->data;
 
 	radio_caps->desc_word[1] = cpu_to_le16(RADIO_CAPABILITIES);
-	radio_caps->desc_word[4] = cpu_to_le16(RSI_RF_TYPE << 8);
+	radio_caps->desc_word[4] = cpu_to_le16(common->channel);
+	radio_caps->desc_word[4] |= cpu_to_le16(RSI_RF_TYPE << 8);
 
+	radio_caps->desc_word[7] |= cpu_to_le16(RSI_LMAC_CLOCK_80MHZ);
 	if (common->channel_width == BW_40MHZ) {
-		radio_caps->desc_word[7] |= cpu_to_le16(RSI_LMAC_CLOCK_80MHZ);
 		radio_caps->desc_word[7] |= cpu_to_le16(RSI_ENABLE_40MHZ);
 
 		if (common->fsm_state == FSM_MAC_INIT_DONE) {
@@ -345,7 +409,7 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 		radio_caps->qos_params[ii].txop_q = 0;
 	}
 
-	for (ii = 0; ii < MAX_HW_QUEUES - 4; ii++) {
+	for (ii = 0; ii < NUM_EDCA_QUEUES; ii++) {
 		radio_caps->qos_params[ii].cont_win_min_q =
 			cpu_to_le16(common->edca_params[ii].cw_min);
 		radio_caps->qos_params[ii].cont_win_max_q =
@@ -356,6 +420,10 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 			cpu_to_le16(common->edca_params[ii].txop);
 	}
 
+	radio_caps->qos_params[BROADCAST_HW_Q].txop_q = 0xffff;
+	radio_caps->qos_params[MGMT_HW_Q].txop_q = 0;
+	radio_caps->qos_params[BEACON_HW_Q].txop_q = 0xffff;
+
 	memcpy(&common->rate_pwr[0], &gc[0], 40);
 	for (ii = 0; ii < 20; ii++)
 		radio_caps->gcpd_per_rate[inx++] =
@@ -469,7 +537,7 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 	memset(skb->data, 0, sizeof(struct rsi_peer_notify));
 	peer_notify = (struct rsi_peer_notify *)skb->data;
 
-	peer_notify->command = cpu_to_le16(opmode << 1);
+	peer_notify->command = 0;
 
 	switch (notify_event) {
 	case STA_CONNECTED:
@@ -499,7 +567,6 @@ static int rsi_hal_send_sta_notify_frame(struct rsi_common *common,
 
 	if (!status && qos_enable) {
 		rsi_set_contention_vals(common);
-		status = rsi_load_radio_caps(common);
 	}
 	return status;
 }
@@ -595,6 +662,7 @@ static int rsi_program_bb_rf(struct rsi_common *common)
 	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
 	mgmt_frame->desc_word[1] = cpu_to_le16(BBP_PROG_IN_TA);
 	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint);
+	mgmt_frame->desc_word[3] = cpu_to_le16(common->rf_pwr_mode);
 
 	if (common->rf_reset) {
 		mgmt_frame->desc_word[7] =  cpu_to_le16(RF_RESET_ENABLE);
@@ -752,6 +820,53 @@ int rsi_hal_load_key(struct rsi_common *common,
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
 
+/**
+ * rsi_send_common_dev_params() - This function send the common device
+ *				configuration parameters to device.
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+int rsi_send_common_dev_params(struct rsi_common *common)
+{
+	struct sk_buff *skb = NULL;
+	u32 *soc_gpio, len;
+	u16 *frame, *ulp_gpio, *desc;
+
+	len = 0x20;
+
+	skb = dev_alloc_skb(len + FRAME_DESC_SZ);
+	if (!skb)
+		return -ENOMEM;
+	memset(skb->data, 0, len + FRAME_DESC_SZ);
+
+	desc = (u16 *)&skb->data[0];
+	frame = (u16 *)&skb->data[FRAME_DESC_SZ];
+
+	desc[0] = cpu_to_le16(len | (RSI_COEX_Q << 12));
+	desc[1] = cpu_to_le16(COMMON_DEV_CONFIG);
+
+	frame[0] = (u16)common->lp_ps_handshake_mode;
+	frame[0] |= (u16)common->ulp_ps_handshake_mode << 8;
+
+	ulp_gpio = (u16 *)&unused_ulp_gpio_bitmap;
+	soc_gpio = (u32 *)&unused_soc_gpio_bitmap;
+
+	frame[1] |= (*ulp_gpio) << 8;
+	*(u32 *)&frame[2] = *soc_gpio;
+	frame[4] |= ((u16)common->oper_mode << 8);
+	frame[5] |= ((u16)common->wlan_rf_power_mode);
+	frame[5] |= ((u16)common->bt_rf_power_mode << 8);
+	frame[6] |= ((u16)common->driver_mode << 8);
+	frame[7] = 3; //((u16 )d_assets->region_code);
+	frame[7] |= ((u16)common->obm_ant_sel_val << 8);
+
+	skb_put(skb, len + FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+
 /*
  * rsi_load_bootup_params() - This function send bootup params to the firmware.
  * @common: Pointer to the driver private structure.
@@ -1140,6 +1255,7 @@ void rsi_inform_bss_status(struct rsi_common *common,
 			   u16 aid)
 {
 	if (status) {
+		common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
 					      RSI_IFTYPE_STATION,
 					      STA_CONNECTED,
@@ -1148,13 +1264,17 @@ void rsi_inform_bss_status(struct rsi_common *common,
 					      aid);
 		if (common->min_rate == 0xffff)
 			rsi_send_auto_rate_request(common);
+		if (!rsi_send_block_unblock_frame(common, false))
+			common->hw_data_qs_blocked = false;
 	} else {
+		common->hw_data_qs_blocked = true;
 		rsi_hal_send_sta_notify_frame(common,
 					      RSI_IFTYPE_STATION,
 					      STA_DISCONNECTED,
 					      bssid,
 					      qos_enable,
 					      aid);
+		rsi_send_block_unblock_frame(common, true);
 	}
 }
 
@@ -1168,6 +1288,7 @@ void rsi_inform_bss_status(struct rsi_common *common,
 static int rsi_eeprom_read(struct rsi_common *common)
 {
 	struct rsi_mac_frame *mgmt_frame;
+	struct rsi_hw *adapter = common->priv;
 	struct sk_buff *skb;
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending EEPROM read req frame\n", __func__);
@@ -1183,15 +1304,16 @@ static int rsi_eeprom_read(struct rsi_common *common)
 	mgmt_frame = (struct rsi_mac_frame *)skb->data;
 
 	/* FrameType */
-	mgmt_frame->desc_word[1] = cpu_to_le16(EEPROM_READ_TYPE);
+	mgmt_frame->desc_word[1] = cpu_to_le16(EEPROM_READ);
 	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
 	/* Number of bytes to read */
-	mgmt_frame->desc_word[3] = cpu_to_le16(ETH_ALEN +
-					       WLAN_MAC_MAGIC_WORD_LEN +
-					       WLAN_HOST_MODE_LEN +
-					       WLAN_FW_VERSION_LEN);
+	mgmt_frame->desc_word[3] = cpu_to_le16(adapter->eeprom.length << 4);
+	mgmt_frame->desc_word[2] |= cpu_to_le16(3 << 8);
+
 	/* Address to read */
-	mgmt_frame->desc_word[4] = cpu_to_le16(WLAN_MAC_EEPROM_ADDR);
+	mgmt_frame->desc_word[4] = cpu_to_le16(adapter->eeprom.offset);
+	mgmt_frame->desc_word[5] = cpu_to_le16(adapter->eeprom.offset >> 16);
+	mgmt_frame->desc_word[6] = cpu_to_le16(0); //delay = 0
 
 	skb_put(skb, FRAME_DESC_SZ);
 
@@ -1225,13 +1347,16 @@ int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
 
 	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
 	mgmt_frame->desc_word[1] = cpu_to_le16(BLOCK_HW_QUEUE);
+	mgmt_frame->desc_word[3] = cpu_to_le16(0x1);
 
 	if (block_event) {
 		rsi_dbg(INFO_ZONE, "blocking the data qs\n");
 		mgmt_frame->desc_word[4] = cpu_to_le16(0xf);
+		mgmt_frame->desc_word[4] |= cpu_to_le16(0xf << 4);
 	} else {
 		rsi_dbg(INFO_ZONE, "unblocking the data qs\n");
 		mgmt_frame->desc_word[5] = cpu_to_le16(0xf);
+		mgmt_frame->desc_word[5] |= cpu_to_le16(0xf << 4);
 	}
 
 	skb_put(skb, FRAME_DESC_SZ);
@@ -1262,7 +1387,7 @@ int rsi_flash_read(struct rsi_hw *adapter)
 	cmd_frame = (struct rsi_mac_frame *)skb->data;
 
 	/* FrameType */
-	cmd_frame->desc_word[1] = cpu_to_le16(EEPROM_READ_TYPE);
+	cmd_frame->desc_word[1] = cpu_to_le16(EEPROM_READ);
 
 	/* Format of length and offset differs for
 	 * autoflashing and swbl flashing
@@ -1300,13 +1425,36 @@ int rsi_flash_read(struct rsi_hw *adapter)
 static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 				      u8 *msg)
 {
+	struct rsi_hw *adapter = common->priv;
 	u8 sub_type = (msg[15] & 0xff);
 
 	switch (sub_type) {
+	case COMMON_DEV_CONFIG:
+		rsi_dbg(FSM_ZONE,
+			"Common Dev Config params confirm received\n");
+		if (common->fsm_state == FSM_COMMON_DEV_PARAMS_SENT) {
+			if (rsi_load_bootup_params(common)) {
+				common->fsm_state = FSM_CARD_NOT_READY;
+				goto out;
+			} else {
+				common->fsm_state = FSM_BOOT_PARAMS_SENT;
+			}
+		} else {
+			rsi_dbg(INFO_ZONE,
+				"%s: Received common dev config params cfm in %d state\n",
+				 __func__, common->fsm_state);
+			return 0;
+		}
+		break;
+
 	case BOOTUP_PARAMS_REQUEST:
 		rsi_dbg(FSM_ZONE, "%s: Boot up params confirm received\n",
 			__func__);
 		if (common->fsm_state == FSM_BOOT_PARAMS_SENT) {
+			adapter->eeprom.length = (IEEE80211_ADDR_LEN +
+						  WLAN_MAC_MAGIC_WORD_LEN +
+						  WLAN_HOST_MODE_LEN);
+			adapter->eeprom.offset = WLAN_MAC_EEPROM_ADDR;
 			if (rsi_eeprom_read(common)) {
 				common->fsm_state = FSM_CARD_NOT_READY;
 				goto out;
@@ -1321,18 +1469,59 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 		}
 		break;
 
-	case EEPROM_READ_TYPE:
+	case EEPROM_READ:
+		rsi_dbg(FSM_ZONE, "EEPROM READ confirm received\n");
 		if (common->fsm_state == FSM_EEPROM_READ_MAC_ADDR) {
+			u32 msg_len = ((u16 *)msg)[0] & 0xfff;
+
+			if (msg_len <= 0) {
+				rsi_dbg(FSM_ZONE,
+					"%s: [EEPROM_READ] Invalid len %d\n",
+					__func__, msg_len);
+				goto out;
+			}
 			if (msg[16] == MAGIC_WORD) {
 				u8 offset = (FRAME_DESC_SZ + WLAN_HOST_MODE_LEN
 					     + WLAN_MAC_MAGIC_WORD_LEN);
 				memcpy(common->mac_addr,
 				       &msg[offset],
 				       ETH_ALEN);
-				memcpy(&common->fw_ver,
-				       &msg[offset + ETH_ALEN],
-				       sizeof(struct version_info));
+				adapter->eeprom.length =
+					((WLAN_MAC_MAGIC_WORD_LEN + 3) & (~3));
+				adapter->eeprom.offset =
+					WLAN_EEPROM_RFTYPE_ADDR;
+				if (rsi_eeprom_read(common)) {
+					rsi_dbg(ERR_ZONE,
+						"%s: Failed reading RF band\n",
+						__func__);
+					common->fsm_state = FSM_CARD_NOT_READY;
+				} else {
+					common->fsm_state =
+						FSM_EEPROM_READ_RF_TYPE;
+				}
+			} else {
+				common->fsm_state = FSM_CARD_NOT_READY;
+				break;
+			}
+		} else if (common->fsm_state == FSM_EEPROM_READ_RF_TYPE) {
+			u32 msg_len = ((u16 *)msg)[0] & 0xfff;
 
+			if (msg_len <= 0) {
+				rsi_dbg(FSM_ZONE,
+					"%s:[EEPROM_READ_CFM] Invalid len %d\n",
+					__func__, msg_len);
+				goto out;
+			}
+			if (msg[16] == MAGIC_WORD) {
+				if ((msg[17] & 0x3) == 0x3) {
+					rsi_dbg(INIT_ZONE,
+						"Dual band supported\n");
+					common->band = NL80211_BAND_5GHZ;
+				} else if ((msg[17] & 0x3) == 0x1) {
+					rsi_dbg(INIT_ZONE,
+						"Only 2.4Ghz band supported\n");
+					common->band = NL80211_BAND_2GHZ;
+				}
 			} else {
 				common->fsm_state = FSM_CARD_NOT_READY;
 				break;
@@ -1415,6 +1604,40 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 }
 
 /**
+ * rsi_handle_card_ready() - This function handles the card ready
+ *			 indication from firmware.
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+int rsi_handle_card_ready(struct rsi_common *common)
+{
+	switch (common->fsm_state) {
+	case FSM_CARD_NOT_READY:
+		rsi_set_default_parameters(common);
+		if (rsi_send_common_dev_params(common) < 0)
+			return -EINVAL;
+		common->fsm_state = FSM_COMMON_DEV_PARAMS_SENT;
+		break;
+	case FSM_COMMON_DEV_PARAMS_SENT:
+		rsi_dbg(FSM_ZONE, "Card ready indication from wlan.\n");
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
+/**
  * rsi_mgmt_pkt_recv() - This function processes the management packets
  *			 recieved from the hardware.
  * @common: Pointer to the driver private structure.
@@ -1426,34 +1649,26 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 {
 	s32 msg_len = (le16_to_cpu(*(__le16 *)&msg[0]) & 0x0fff);
 	u16 msg_type = (msg[2]);
-	int ret;
 
 	rsi_dbg(FSM_ZONE, "%s: Msg Len: %d, Msg Type: %4x\n",
 		__func__, msg_len, msg_type);
 
-	if (msg_type == TA_CONFIRM_TYPE) {
+	switch (msg_type) {
+	case TA_CONFIRM_TYPE:
 		return rsi_handle_ta_confirm_type(common, msg);
-	} else if (msg_type == CARD_READY_IND) {
-		rsi_dbg(FSM_ZONE, "%s: Card ready indication received\n",
-			__func__);
-		if (common->fsm_state == FSM_CARD_NOT_READY) {
-			rsi_set_default_parameters(common);
 
-			ret = rsi_load_bootup_params(common);
-			if (ret)
-				return ret;
-			else
-				common->fsm_state = FSM_BOOT_PARAMS_SENT;
-		} else {
-			return -EINVAL;
-		}
-	} else if (msg_type == TX_STATUS_IND) {
+	case CARD_READY_IND:
+		return rsi_handle_card_ready(common);
+
+	case TX_STATUS_IND:
 		if (msg[15] == PROBEREQ_CONFIRM) {
 			common->mgmt_q_block = false;
 			rsi_dbg(FSM_ZONE, "%s: Probe confirm received\n",
 				__func__);
 		}
-	} else {
+		break;
+
+	default:
 		return rsi_mgmt_pkt_to_core(common, msg, msg_len, msg_type);
 	}
 	return 0;
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index c54a534..ad399b5 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -74,17 +74,36 @@ static int rsi_process_pkt(struct rsi_common *common)
 	u8 num_blks = 0;
 	u32 rcv_pkt_len = 0;
 	int status = 0;
+	u8 value = 0;
+	u8 protocol = 0, unaggr_pkt = 0;
+
+#define COEX_PKT 0
+#define WLAN_PKT 3
+#define ZIGB_PKT 1
+#define BT_PKT   2
+	num_blks = ((adapter->interrupt_status & 1) |
+			((adapter->interrupt_status >> 4) << 1));
+
+	if (!num_blks) {
+		status = rsi_sdio_read_register(adapter,
+						SDIO_RX_NUM_BLOCKS_REG,
+						&value);
+		if (status) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to read pkt length from the card:\n",
+				__func__);
+			return status;
+		}
 
-	status = rsi_sdio_read_register(adapter,
-					SDIO_RX_NUM_BLOCKS_REG,
-					&num_blks);
-
-	if (status) {
-		rsi_dbg(ERR_ZONE,
-			"%s: Failed to read pkt length from the card:\n",
-			__func__);
-		return status;
+		protocol = value >> 5;
+		num_blks = value & 0x1f;
+	} else {
+		protocol = WLAN_PKT;
 	}
+
+	if (protocol == BT_PKT || protocol == ZIGB_PKT)  //unaggr_pkt FIXME
+		unaggr_pkt = 1;
+
 	rcv_pkt_len = (num_blks * 256);
 
 	common->rx_data_pkt = kmalloc(rcv_pkt_len, GFP_KERNEL);
@@ -233,6 +252,8 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 			mutex_unlock(&common->tx_rxlock);
 			return;
 		}
+		adapter->interrupt_status = isr_status;
+		isr_status &= 0xE;
 
 		rsi_dbg(ISR_ZONE, "%s: Intr_status = %x %d %d\n",
 			__func__, isr_status, (1 << MSDU_PKT_PENDING),
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 84ca609..63104bb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -41,19 +41,25 @@ static struct rsi_host_intf_ops usb_host_intf_ops = {
  * Return: status: 0 on success, a negative error code on failure.
  */
 static int rsi_usb_card_write(struct rsi_hw *adapter,
-			      void *buf,
+			      u8 *buf,
 			      u16 len,
-			      u8 endpoint)
+			      u32 endpoint)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	int status;
-	s32 transfer;
+	int status = 0;
+	u8 *seg = dev->tx_buffer;
+	int transfer = 0;
+	int ep = dev->bulkout_endpoint_addr[endpoint - 1];
+
+	memset(seg, 0, len + 128);
+	memcpy(seg + 128, buf, len);
+	len += 128;
+	transfer = len;
 
 	status = usb_bulk_msg(dev->usbdev,
-			      usb_sndbulkpipe(dev->usbdev,
-			      dev->bulkout_endpoint_addr[endpoint - 1]),
-			      buf,
-			      len,
+			      usb_sndbulkpipe(dev->usbdev, ep),
+			      (void *)seg,
+			      (int)len,
 			      &transfer,
 			      HZ * 5);
 
@@ -61,7 +67,11 @@ static int rsi_usb_card_write(struct rsi_hw *adapter,
 		rsi_dbg(ERR_ZONE,
 			"Card write failed with error code :%10d\n", status);
 		dev->write_fail = 1;
+		goto fail;
 	}
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sent Message successfully\n", __func__);
+
+fail:
 	return status;
 }
 
@@ -76,27 +86,23 @@ static int rsi_usb_card_write(struct rsi_hw *adapter,
  * Return: 0 on success, a negative error code on failure.
  */
 static int rsi_write_multiple(struct rsi_hw *adapter,
-			      u8 endpoint,
+			      u32 addr,
 			      u8 *data,
 			      u32 count)
 {
-	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
-	u8 *seg = dev->tx_buffer;
-
-	if (dev->write_fail)
-		return 0;
+	struct rsi_91x_usbdev *dev =
+		(struct rsi_91x_usbdev *)adapter->rsi_dev;
 
-	if (endpoint == MGMT_EP) {
-		memset(seg, 0, RSI_USB_TX_HEAD_ROOM);
-		memcpy(seg + RSI_USB_TX_HEAD_ROOM, data, count);
-	} else {
-		seg = ((u8 *)data - RSI_USB_TX_HEAD_ROOM);
+	if (!adapter || addr == 0) {
+		rsi_dbg(INFO_ZONE,
+			"%s: Unable to write to card\n", __func__);
+		return -1;
 	}
 
-	return rsi_usb_card_write(adapter,
-				  seg,
-				  count + RSI_USB_TX_HEAD_ROOM,
-				  endpoint);
+	if (dev->write_fail)
+		return -1;
+
+	return rsi_usb_card_write(adapter, data, count, addr);
 }
 
 /**
@@ -259,6 +265,11 @@ static void rsi_rx_done_handler(struct urb *urb)
 	if (urb->status)
 		return;
 
+	if (urb->actual_length <= 0) {
+		rsi_dbg(INFO_ZONE, "%s: Zero length packet\n", __func__);
+		return;
+	}
+
 	rsi_set_event(&dev->rx_thread.event);
 }
 
@@ -386,15 +397,16 @@ int rsi_usb_write_register_multiple(struct rsi_hw *adapter,
 			rsi_dbg(ERR_ZONE,
 				"Reg write failed with error code :%d\n",
 				status);
-		} else {
-			count -= transfer;
-			data += transfer;
-			addr += transfer;
+			kfree(buf);
+			return status;
 		}
+		count -= transfer;
+		data += transfer;
+		addr += transfer;
 	}
 
 	kfree(buf);
-	return 0;
+	return status;
 }
 
 /**
@@ -410,10 +422,12 @@ int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
 				u8 *pkt,
 				u32 len)
 {
-	u32 queueno = ((pkt[1] >> 4) & 0xf);
+	u32 queueno = ((pkt[1] >> 4) & 0x7);
 	u8 endpoint;
 
-	endpoint = ((queueno == RSI_WIFI_MGMT_Q) ? MGMT_EP : DATA_EP);
+	endpoint = ((queueno == RSI_WIFI_MGMT_Q || queueno == RSI_COEX_Q ||
+		     queueno == RSI_WIFI_DATA_Q) ?
+		    MGMT_EP : DATA_EP);
 
 	return rsi_write_multiple(adapter,
 				  endpoint,
@@ -500,7 +514,7 @@ static void rsi_deinit_usb_interface(struct rsi_hw *adapter)
 	rsi_kill_thread(&dev->rx_thread);
 	usb_free_urb(dev->rx_usb_urb[0]);
 	kfree(adapter->priv->rx_data_pkt);
-	kfree(dev->tx_buffer);
+	kfree(dev->saved_tx_buffer);
 }
 
 /**
@@ -516,6 +530,7 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	struct rsi_91x_usbdev *rsi_dev;
 	struct rsi_common *common = adapter->priv;
 	int status;
+	u8 dword_align_bytes = 0;
 
 	rsi_dev = kzalloc(sizeof(*rsi_dev), GFP_KERNEL);
 	if (!rsi_dev)
@@ -530,18 +545,29 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	adapter->device = &pfunction->dev;
 	usb_set_intfdata(pfunction, adapter);
 
-	common->rx_data_pkt = kmalloc(2048, GFP_KERNEL);
+	common->rx_data_pkt = kmalloc(2000 * 4, GFP_KERNEL | GFP_DMA);
 	if (!common->rx_data_pkt) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to allocate memory\n",
 			__func__);
 		return -ENOMEM;
 	}
+	common->saved_rx_data_pkt = common->rx_data_pkt;
+	dword_align_bytes = (u32)common->rx_data_pkt & 0x3f;
+	if (dword_align_bytes)
+		common->rx_data_pkt = common->rx_data_pkt +
+				      (64 - dword_align_bytes);
 
 	rsi_dev->tx_buffer = kmalloc(2048, GFP_KERNEL);
 	if (!rsi_dev->tx_buffer) {
 		status = -ENOMEM;
 		goto fail_tx;
 	}
+	rsi_dev->saved_tx_buffer = rsi_dev->tx_buffer;
+	dword_align_bytes = (u32)rsi_dev->tx_buffer & 0x3f;
+	if (dword_align_bytes)
+		rsi_dev->tx_buffer = rsi_dev->tx_buffer +
+				     (64 - dword_align_bytes);
+
 	rsi_dev->rx_usb_urb[0] = usb_alloc_urb(0, GFP_KERNEL);
 	if (!rsi_dev->rx_usb_urb[0]) {
 		status = -ENOMEM;
@@ -549,6 +575,7 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	}
 	rsi_dev->rx_usb_urb[0]->transfer_buffer = adapter->priv->rx_data_pkt;
 	rsi_dev->tx_blk_size = 252;
+	adapter->tx_blk_size = rsi_dev->tx_blk_size;
 
 	/* Initializing function callbacks */
 	adapter->rx_urb_submit = rsi_rx_urb_submit;
@@ -575,9 +602,9 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 fail_thread:
 	usb_free_urb(rsi_dev->rx_usb_urb[0]);
 fail_rx:
-	kfree(rsi_dev->tx_buffer);
+	kfree(rsi_dev->saved_tx_buffer);
 fail_tx:
-	kfree(common->rx_data_pkt);
+	kfree(common->saved_rx_data_pkt);
 	return status;
 }
 
@@ -595,7 +622,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 {
 	struct rsi_hw *adapter;
 	struct rsi_91x_usbdev *dev;
-	u32 fw_status;
+	u32 fw_status = 0;
 	int status;
 
 	rsi_dbg(INIT_ZONE, "%s: Init function called\n", __func__);
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 752c429..49e9fdf 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -32,12 +32,14 @@
 #define ISR_ZONE                        BIT(8)  /* For Interrupt Msgs         */
 
 #define FSM_CARD_NOT_READY              0
-#define FSM_BOOT_PARAMS_SENT            1
-#define FSM_EEPROM_READ_MAC_ADDR        2
-#define FSM_RESET_MAC_SENT              3
-#define FSM_RADIO_CAPS_SENT             4
-#define FSM_BB_RF_PROG_SENT             5
-#define FSM_MAC_INIT_DONE               6
+#define FSM_COMMON_DEV_PARAMS_SENT	1
+#define FSM_BOOT_PARAMS_SENT            2
+#define FSM_EEPROM_READ_MAC_ADDR        3
+#define FSM_EEPROM_READ_RF_TYPE		4
+#define FSM_RESET_MAC_SENT              5
+#define FSM_RADIO_CAPS_SENT             6
+#define FSM_BB_RF_PROG_SENT             7
+#define FSM_MAC_INIT_DONE               8
 
 extern u32 rsi_zone_enabled;
 extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
@@ -54,12 +56,23 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define MAC_80211_HDR_FRAME_CONTROL     0
 #define WME_NUM_AC                      4
 #define NUM_SOFT_QUEUES                 5
-#define MAX_HW_QUEUES                   8
+#define MAX_HW_QUEUES                   12
 #define INVALID_QUEUE                   0xff
 #define MAX_CONTINUOUS_VO_PKTS          8
 #define MAX_CONTINUOUS_VI_PKTS          4
+#define MGMT_HW_Q			10 /* Queue No 10 is used for
+					    * MGMT_QUEUE in Device FW,
+					    *  Hence this is Reserved
+					    */
+#define BROADCAST_HW_Q			9
+#define BEACON_HW_Q			11
+#define MAX_NUM_SCAN_BGCHANS		24
 
 /* Queue information */
+#define RSI_COEX_Q			0x0
+#define RSI_ZIGB_Q			0x1
+#define RSI_BT_Q			0x2
+#define RSI_WLAN_Q			0x3
 #define RSI_WIFI_MGMT_Q                 0x4
 #define RSI_WIFI_DATA_Q                 0x5
 #define IEEE80211_MGMT_FRAME            0x00
@@ -190,6 +203,7 @@ struct rsi_common {
 	/* Generic */
 	u8 channel;
 	u8 *rx_data_pkt;
+	u8 *saved_rx_data_pkt;
 	u8 mac_id;
 	u8 radio_id;
 	u16 rate_pwr[20];
@@ -204,8 +218,27 @@ struct rsi_common {
 	struct cqm_info cqm_info;
 
 	bool hw_data_qs_blocked;
-	
+	u8 driver_mode;
 	u8 coex_mode;
+	u8 oper_mode;
+	u8 ta_aggr;
+	u8 skip_fw_load;
+	u8 lp_ps_handshake_mode;
+	u8 ulp_ps_handshake_mode;
+	u8 uapsd_bitmap;
+	u8 rf_power_val;
+	u8 device_gpio_type;
+	u16 country_code;
+	u8 wlan_rf_power_mode;
+	u8 bt_rf_power_mode;
+	u8 obm_ant_sel_val;
+	u8 antenna_diversity;
+	u16 rf_pwr_mode;
+	char antenna_gain[2];
+	u8 host_wakeup_intr_enable;
+	u8 host_wakeup_intr_active_high;
+	int tx_power;
+	u8 ant_in_use;
 };
 
 enum host_intf {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index f8823126..b0bbb5a 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -43,13 +43,32 @@
 #define WLAN_HOST_MODE_LEN              0x04
 #define WLAN_FW_VERSION_LEN             0x08
 #define MAGIC_WORD                      0x5A
+#define WLAN_EEPROM_RFTYPE_ADDR		424
 
 /* Receive Frame Types */
-#define TA_CONFIRM_TYPE                 0x01
-#define RX_DOT11_MGMT                   0x02
-#define TX_STATUS_IND                   0x04
+enum rx_cmd_type {
+	CARD_READY_IND = 0x0,
+	TA_CONFIRM_TYPE = 0x01,
+	RX_DOT11_MGMT = 0x02,
+	RX_DOT11_DATA = 0x03,
+	TX_STATUS_IND = 0x04,
+	PS_NOTIFY_IND = 0x05,
+	SLEEP_NOTIFY_IND = 0x06,
+	DECRYPT_ERROR_IND = 0x07,
+	BEACON_EVENT_IND = 0x08,
+	DEBUG_IND = 0x09,
+	RX_MISC_IND = 0xa,
+	UNCONNECTED_PEER = 0xb,
+	HW_BMISS_EVENT = 0xc,
+	RATE_GC_TABLE_UPDATE = 0xd,
+	RADAR_DETECTED = 0x0e,
+	TSF_SYNC_CONFIRM = 0xc0,
+	ANTENNA_SELECT = 0xf,
+};
+
+#define EAPOL4_CONFIRM			1
 #define PROBEREQ_CONFIRM                2
-#define CARD_READY_IND                  0x00
+#define NULLDATA_CONFIRM		3
 
 #define RSI_DELETE_PEER                 0x0
 #define RSI_ADD_PEER                    0x1
@@ -62,6 +81,7 @@
 #define RF_RESET_ENABLE                 BIT(3)
 #define RATE_INFO_ENABLE                BIT(0)
 #define RSI_BROADCAST_PKT               BIT(9)
+#define RSI_DESC_11G_MODE		BIT(7)
 #define RSI_DESC_REQUIRE_CFM_TO_HOST	BIT(10)
 
 #define UPPER_20_ENABLE                 (0x2 << 12)
@@ -75,7 +95,7 @@
 #define RX_BA_INDICATION                1
 #define RSI_TBL_SZ                      40
 #define MAX_RETRIES                     8
-#define RSI_IFTYPE_STATION		 0
+#define RSI_IFTYPE_STATION		1
 
 #define STD_RATE_MCS7                   0x07
 #define STD_RATE_MCS6                   0x06
@@ -141,6 +161,44 @@
 
 #define RSI_SUPP_FILTERS	(FIF_ALLMULTI | FIF_PROBE_REQ |\
 				 FIF_BCN_PRBRESP_PROMISC)
+
+/* Power save handshake types */
+#define NO_HAND_SHAKE			0
+#define GPIO_HAND_SHAKE			1
+#define PACKET_HAND_SHAKE		2
+#define TA_GPIO				0
+#define ULP_GPIO			1
+#define RF_POWER_3_3			1
+#define RF_POWER_1_9			0
+
+/* Rx filter word definitions */
+#define PROMISCOUS_MODE			BIT(0)
+#define ALLOW_DATA_ASSOC_PEER		BIT(1)
+#define ALLOW_MGMT_ASSOC_PEER		BIT(2)
+#define ALLOW_CTRL_ASSOC_PEER		BIT(3)
+#define DISALLOW_BEACONS		BIT(4)
+#define ALLOW_CONN_PEER_MGMT_WHILE_BUF_FULL BIT(5)
+#define DISALLOW_BROADCAST_DATA		BIT(6)
+
+#define RSI_TXPOWER_MAX			30
+#define RSI_TXPOWER_MIN			-127
+
+#define DEEP_SLEEP			1
+#define CONNECTED_SLEEP			2
+
+#define SLEEP_REQUEST			1
+#define WAKEUP_REQUEST			2
+
+#define RSI_TXPOWER_MAX			30
+#define RSI_TXPOWER_MIN			-127
+
+#define IEEE80211_MARKALL_UAPSD_QUEUES \
+	(IEEE80211_WMM_IE_STA_QOSINFO_AC_VO | \
+	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI | \
+	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE | \
+	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
+#define IEEE80211_STA_SP_ALL_PKTS	0x00
+
 enum opmode {
 	STA_OPMODE = 1,
 	AP_OPMODE = 2
@@ -160,32 +218,51 @@ enum sta_notify_events {
 
 /* Send Frames Types */
 enum cmd_frame_type {
-	TX_DOT11_MGMT,
-	RESET_MAC_REQ,
-	RADIO_CAPABILITIES,
-	BB_PROG_VALUES_REQUEST,
-	RF_PROG_VALUES_REQUEST,
-	WAKEUP_SLEEP_REQUEST,
-	SCAN_REQUEST,
-	TSF_UPDATE,
-	PEER_NOTIFY,
-	BLOCK_HW_QUEUE,
-	SET_KEY_REQ,
-	AUTO_RATE_IND,
-	BOOTUP_PARAMS_REQUEST,
-	VAP_CAPABILITIES,
-	EEPROM_READ_TYPE ,
-	EEPROM_WRITE,
-	GPIO_PIN_CONFIG ,
-	SET_RX_FILTER,
-	AMPDU_IND,
-	STATS_REQUEST_FRAME,
-	BB_BUF_PROG_VALUES_REQ,
-	BBP_PROG_IN_TA,
-	BG_SCAN_PARAMS,
-	BG_SCAN_PROBE_REQ,
-	CW_MODE_REQ,
-	PER_CMD_PKT
+	TX_DOT11_MGMT = 0,
+	RESET_MAC_REQ, /* 0x1 */
+	RADIO_CAPABILITIES, /* 0x2 */
+	BB_PROG_VALUES_REQUEST, /* 0x3 */
+	RF_PROG_VALUES_REQUEST, /* 0x4 */
+	WAKEUP_SLEEP_REQUEST, /* 0x5 */
+	SCAN_REQUEST, /* 0x6 */
+	TSF_UPDATE, /* 0x7 */
+	PEER_NOTIFY, /* 0x8 */
+	BLOCK_HW_QUEUE, /* 0x9 */
+	SET_KEY_REQ, /* 0xA */
+	AUTO_RATE_IND, /* 0xB */
+	BOOTUP_PARAMS_REQUEST, /* 0xC */
+	VAP_CAPABILITIES, /* 0xD */
+	EEPROM_READ, /* 0xE */
+	EEPROM_WRITE, /* 0xF */
+	GPIO_PIN_CONFIG, /* 0x10 */
+	SET_RX_FILTER, /* 0x11 */
+	AMPDU_IND, /* 0x12 */
+	STATS_REQUEST, /* 0x13 */
+	BB_BUF_PROG_VALUES_REQ, /* 0x14 */
+	BBP_PROG_IN_TA, /* 0x15 */
+	BG_SCAN_PARAMS, /* 0x16 */
+	BG_SCAN_PROBE_REQ, /* 0x17 */
+	CW_MODE_REQ, /* 0x18 */
+	PER_CMD_PKT, /* 0x19 */
+	DEV_SLEEP_REQUEST, /* 0x1A */
+	DEV_WAKEUP_CNF,  /* 0x1B */
+	RF_LOOPBACK_REQ, /* 0x1C */
+	RF_LPBK_M3,  /* 0x1D */
+	RF_RESET_FRAME,  /* 0x1E */
+	LMAC_REG_OPS,  /* 0x1F */
+	ANT_SEL_FRAME, /* 0x20 */
+	CONFIRM, /* 0x21 */
+	WLAN_DE_REGISTER, /* 0x22 */
+	DEBUG_FRAME,  /* 0x23 */
+	HW_BMISS_HANDLE, /* 0x24 */
+	MULTICAST_ENABLE, /* 0x25 */
+	TX_MISC_IND, /* 0x26 */
+	VAP_DYNAMIC_UPDATE, /* 0x27 */
+	COMMON_DEV_CONFIG, /* 0x28 */
+	RADIO_PARAMS_UPDATE, /* 0x29 */
+	RADAR_REQUEST, /* 0x2A */
+	WOWLAN_CONFIG_PARAMS, /* 2B */
+	IAP_CONFIG, /* 0x2C */
 };
 
 struct rsi_mac_frame {
@@ -220,6 +297,7 @@ struct rsi_vap_caps {
 	__le32 default_data_rate;
 	__le16 beacon_interval;
 	__le16 dtim_period;
+	__le16 beacon_miss_threshold;
 } __packed;
 
 struct rsi_set_key {
@@ -262,6 +340,61 @@ struct rsi_radio_caps {
 	__le16 preamble_type;
 } __packed;
 
+struct rsi_ulp_gpio_vals {
+	u8 motion_sensor_gpio_ulp_wakeup : 1;
+	u8 sleep_ind_from_device : 1;
+	u8 ulp_gpio_2 :1;
+	u8 push_button_ulp_wakeup : 1;
+	u8 reserved : 4;
+} __packed;
+
+struct rsi_soc_gpio_vals {
+	u32 pspi_csn_0 : 1;
+	u32 pspi_csn_1 : 1;
+	u32 host_wakeup_intr :1;
+	u32 pspi_data_0 : 1;
+	u32 pspi_data_1 : 1;
+	u32 pspi_data_2 : 1;
+	u32 pspi_data_3 : 1;
+	u32 i2c_scl :1;
+	u32 i2c_sda   :1;
+	u32 uart1_rx :1;
+	u32 uart1_tx  :1;
+	u32 uart1_rts_i2s_clk :1;
+	u32 uart1_cts_i2s_ws :1;
+	u32 dbg_uart_rx_i2s_din :1;
+	u32 dbg_uart_tx_i2s_dout :1;
+	u32 lp_wakeup_boot_bypass :1;
+	u32 led_0 :1;
+	u32 btcoex_wlan_active_ext_pa_ant_sel_A :1;
+	u32 btcoex_bt_priority_ext_pa_ant_sel_B :1;
+	u32 btcoex_bt_active_ext_pa_on_off :1;
+	u32 rf_reset :1;
+	u32 sleep_ind_from_device :1;
+} __packed;
+
+struct rsi_config_vals {
+	u16 desc_word[8];
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
+#define EXT_PA      1
+#define EXT_BT_COEX 2
+} __packed;
+
 static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
 {
 	return (le16_to_cpu(*(__le16 *)&addr[offset]) & 0x7000) >> 12;
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index d21d40d..b20b99d 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -42,6 +42,7 @@ struct rsi_91x_usbdev {
 	struct usb_interface *pfunction;
 	struct urb *rx_usb_urb[MAX_RX_URBS];
 	u8 *tx_buffer;
+	u8 *saved_tx_buffer;
 	__le16 bulkin_size;
 	u8 bulkin_endpoint_addr;
 	__le16 bulkout_size[MAX_BULK_EP];
-- 
2.4.11
