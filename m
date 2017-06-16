Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33145 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdFPO5f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:57:35 -0400
Received: by mail-pf0-f194.google.com with SMTP id w12so6923353pfk.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:57:35 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 01/20] rsi: changes in eeprom read frame
Date: Fri, 16 Jun 2017 20:24:22 +0530
Message-Id: <1497624881-2315-2-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_165739_176902_8B637855)
In-Reply-To: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

EEPROM read frame is sent during device initialization to read mac address.
The format of the frame is modified in firmware to include eeprom length
and offset. This frame does not return firmware version now. Also same
frame is sent again to read rf type and band information.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 90 ++++++++++++++++++++++-----------
 drivers/net/wireless/rsi/rsi_main.h     | 16 ++++++
 drivers/net/wireless/rsi/rsi_mgmt.h     | 19 ++++++-
 3 files changed, 95 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 83ce81a..816c2e0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1282,7 +1282,8 @@ void rsi_inform_bss_status(struct rsi_common *common,
  */
 static int rsi_eeprom_read(struct rsi_common *common)
 {
-	struct rsi_mac_frame *mgmt_frame;
+	struct rsi_eeprom_read_frame *mgmt_frame;
+	struct rsi_hw *adapter = common->priv;
 	struct sk_buff *skb;
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending EEPROM read req frame\n", __func__);
@@ -1295,18 +1296,21 @@ static int rsi_eeprom_read(struct rsi_common *common)
 	}
 
 	memset(skb->data, 0, FRAME_DESC_SZ);
-	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+	mgmt_frame = (struct rsi_eeprom_read_frame *)skb->data;
 
 	/* FrameType */
-	mgmt_frame->desc_word[1] = cpu_to_le16(EEPROM_READ_TYPE);
-	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	rsi_set_len_qno(&mgmt_frame->len_qno, 0, RSI_WIFI_MGMT_Q);
+	mgmt_frame->pkt_type = EEPROM_READ;
+
 	/* Number of bytes to read */
-	mgmt_frame->desc_word[3] = cpu_to_le16(ETH_ALEN +
-					       WLAN_MAC_MAGIC_WORD_LEN +
-					       WLAN_HOST_MODE_LEN +
-					       WLAN_FW_VERSION_LEN);
+	mgmt_frame->pkt_info =
+		cpu_to_le32((adapter->eeprom.length << RSI_EEPROM_LEN_OFFSET) &
+			    RSI_EEPROM_LEN_MASK);
+	mgmt_frame->pkt_info |= cpu_to_le32((3 << RSI_EEPROM_HDR_SIZE_OFFSET) &
+					    RSI_EEPROM_HDR_SIZE_MASK);
+
 	/* Address to read */
-	mgmt_frame->desc_word[4] = cpu_to_le16(WLAN_MAC_EEPROM_ADDR);
+	mgmt_frame->eeprom_offset = cpu_to_le32(adapter->eeprom.offset);
 
 	skb_put(skb, FRAME_DESC_SZ);
 
@@ -1432,19 +1436,25 @@ int rsi_set_antenna(struct rsi_common *common, u8 antenna)
 static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 				      u8 *msg)
 {
+	struct rsi_hw *adapter = common->priv;
 	u8 sub_type = (msg[15] & 0xff);
+	u16 msg_len = ((u16 *)msg)[0] & 0xfff;
+	u8 offset;
 
 	switch (sub_type) {
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
-			} else {
-				common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
 			}
+			common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
 		} else {
 			rsi_dbg(INFO_ZONE,
 				"%s: Received bootup params cfm in %d state\n",
@@ -1453,30 +1463,52 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 		}
 		break;
 
-	case EEPROM_READ_TYPE:
+	case EEPROM_READ:
+		rsi_dbg(FSM_ZONE, "EEPROM READ confirm received\n");
+		if (msg_len <= 0) {
+			rsi_dbg(FSM_ZONE,
+				"%s: [EEPROM_READ] Invalid len %d\n",
+				__func__, msg_len);
+			goto out;
+		}
+		if (msg[16] != MAGIC_WORD) {
+			rsi_dbg(FSM_ZONE,
+				"%s: [EEPROM_READ] Invalid token\n", __func__);
+			common->fsm_state = FSM_CARD_NOT_READY;
+			goto out;
+		}
 		if (common->fsm_state == FSM_EEPROM_READ_MAC_ADDR) {
-			if (msg[16] == MAGIC_WORD) {
-				u8 offset = (FRAME_DESC_SZ + WLAN_HOST_MODE_LEN
-					     + WLAN_MAC_MAGIC_WORD_LEN);
-				memcpy(common->mac_addr,
-				       &msg[offset],
-				       ETH_ALEN);
-				memcpy(&common->fw_ver,
-				       &msg[offset + ETH_ALEN],
-				       sizeof(struct version_info));
-
-			} else {
+			offset = (FRAME_DESC_SZ + WLAN_HOST_MODE_LEN +
+				  WLAN_MAC_MAGIC_WORD_LEN);
+			memcpy(common->mac_addr, &msg[offset], ETH_ALEN);
+			adapter->eeprom.length =
+				((WLAN_MAC_MAGIC_WORD_LEN + 3) & (~3));
+			adapter->eeprom.offset = WLAN_EEPROM_RFTYPE_ADDR;
+			if (rsi_eeprom_read(common)) {
+				rsi_dbg(ERR_ZONE,
+					"%s: Failed reading RF band\n",
+					__func__);
 				common->fsm_state = FSM_CARD_NOT_READY;
-				break;
+				goto out;
+			}
+			common->fsm_state = FSM_EEPROM_READ_RF_TYPE;
+		} else if (common->fsm_state == FSM_EEPROM_READ_RF_TYPE) {
+			if ((msg[17] & 0x3) == 0x3) {
+				rsi_dbg(INIT_ZONE, "Dual band supported\n");
+				common->band = NL80211_BAND_5GHZ;
+				common->num_supp_bands = 2;
+			} else if ((msg[17] & 0x3) == 0x1) {
+				rsi_dbg(INIT_ZONE,
+					"Only 2.4Ghz band supported\n");
+				common->band = NL80211_BAND_2GHZ;
+				common->num_supp_bands = 1;
 			}
 			if (rsi_send_reset_mac(common))
 				goto out;
-			else
-				common->fsm_state = FSM_RESET_MAC_SENT;
+			common->fsm_state = FSM_RESET_MAC_SENT;
 		} else {
-			rsi_dbg(ERR_ZONE,
-				"%s: Received eeprom mac addr in %d state\n",
-				__func__, common->fsm_state);
+			rsi_dbg(ERR_ZONE, "%s: Invalid EEPROM read type\n",
+				__func__);
 			return 0;
 		}
 		break;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index f398525..fc99c17 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -37,6 +37,7 @@ enum RSI_FSM_STATES {
 	FSM_COMMON_DEV_PARAMS_SENT,
 	FSM_BOOT_PARAMS_SENT,
 	FSM_EEPROM_READ_MAC_ADDR,
+	FSM_EEPROM_READ_RF_TYPE,
 	FSM_RESET_MAC_SENT,
 	FSM_RADIO_CAPS_SENT,
 	FSM_BB_RF_PROG_SENT,
@@ -175,6 +176,7 @@ struct rsi_common {
 
 	/* Channel/band related */
 	u8 band;
+	u8 num_supp_bands;
 	u8 channel_width;
 
 	u16 rts_threshold;
@@ -228,6 +230,19 @@ enum host_intf {
 	RSI_HOST_INTF_USB
 };
 
+struct eepromrw_info {
+	u32 offset;
+	u32 length;
+	u8  write;
+	u16 eeprom_erase;
+	u8 data[480];
+};
+
+struct eeprom_read {
+	u16 length;
+	u16 off_set;
+};
+
 struct rsi_hw {
 	struct rsi_common *priv;
 	u8 device_model;
@@ -250,6 +265,7 @@ struct rsi_hw {
 	struct timer_list bl_cmd_timer;
 	bool blcmd_timer_expired;
 	u32 flash_capacity;
+	struct eepromrw_info eeprom;
 	u8 dfs_region;
 	void *rsi_dev;
 	struct rsi_host_intf_ops *host_intf_ops;
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index dcb6db7..47926c9 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -43,6 +43,7 @@
 #define WLAN_HOST_MODE_LEN              0x04
 #define WLAN_FW_VERSION_LEN             0x08
 #define MAGIC_WORD                      0x5A
+#define WLAN_EEPROM_RFTYPE_ADDR		424
 
 /* Receive Frame Types */
 #define TA_CONFIRM_TYPE                 0x01
@@ -192,7 +193,7 @@ enum cmd_frame_type {
 	AUTO_RATE_IND,
 	BOOTUP_PARAMS_REQUEST,
 	VAP_CAPABILITIES,
-	EEPROM_READ_TYPE ,
+	EEPROM_READ,
 	EEPROM_WRITE,
 	GPIO_PIN_CONFIG ,
 	SET_RX_FILTER,
@@ -353,6 +354,22 @@ struct rsi_config_vals {
 	u8 reserved2[16];
 } __packed;
 
+/* Packet info flags */
+#define RSI_EEPROM_HDR_SIZE_OFFSET		8
+#define RSI_EEPROM_HDR_SIZE_MASK		0x300
+#define RSI_EEPROM_LEN_OFFSET			20
+#define RSI_EEPROM_LEN_MASK			0xFFF00000
+
+struct rsi_eeprom_read_frame {
+	__le16 len_qno;
+	u8 pkt_type;
+	u8 misc_flags;
+	__le32 pkt_info;
+	__le32 eeprom_offset;
+	__le16 delay_ms;
+	__le16 reserved3;
+} __packed;
+
 static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
 {
 	return (le16_to_cpu(*(__le16 *)&addr[offset]) & 0x7000) >> 12;
-- 
2.7.4
