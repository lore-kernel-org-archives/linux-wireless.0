Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35479 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbcKNMTx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 07:19:53 -0500
Received: by mail-pf0-f194.google.com with SMTP id i88so6130630pfk.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 04:19:53 -0800 (PST)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 3/5] rsi: Added support for configuring tx power
Date: Mon, 14 Nov 2016 17:47:16 +0530
Message-Id: <1479125836-2722-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161114_131957_095841_31111591)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX power can be configured from iwconfig, iw or from mac80211 when
regulatory changes are done. Hence support for configuring tx power
to device is added. This can be done by sending RADIO_PARAMS_UPDATE
command frame to device with upated tx power value.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 37 +++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 38 +++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |  2 +
 drivers/net/wireless/rsi/rsi_mgmt.h         | 72 ++++++++++++++++++-----------
 4 files changed, 123 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index fa9498d..ba21608 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -397,6 +397,37 @@ static int rsi_channel_change(struct ieee80211_hw *hw)
 }
 
 /**
+ * rsi_config_power() - This function configures tx power in device
+ * @hw: Pointer to the ieee80211_hw structure.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int rsi_config_power(struct ieee80211_hw *hw)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+	int status;
+
+	if (adapter->sc_nvifs <= 0) {
+		rsi_dbg(ERR_ZONE, "%s: No virtual interface found\n", __func__);
+		return -EINVAL;
+	}
+
+	rsi_dbg(INFO_ZONE,
+		"%s: Set tx power: %d dBM\n", __func__, conf->power_level);
+
+	if (conf->power_level == common->tx_power)
+		return 0;
+
+	common->tx_power = conf->power_level;
+
+	status = rsi_send_radio_params_update(common);
+
+	return status;
+}
+
+/**
  * rsi_mac80211_config() - This function is a handler for configuration
  *			   requests. The stack calls this function to
  *			   change hardware configuration, e.g., channel.
@@ -417,6 +448,12 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
 		status = rsi_channel_change(hw);
 
+	/* tx power */
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		rsi_dbg(INFO_ZONE, "%s: Configuring Power\n", __func__);
+		status = rsi_config_power(hw);
+	}
+
 	mutex_unlock(&common->mutex);
 
 	return status;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index ae4a814..2e8e5dc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -964,6 +964,44 @@ int rsi_set_channel(struct rsi_common *common, u16 channel)
 }
 
 /**
+ * rsi_send_radio_params_update() - This function sends the radio
+ *				parameters update to device
+ * @common: Pointer to the driver private structure.
+ * @channel: Channel value to be set.
+ *
+ * Return: 0 on success, corresponding error code on failure.
+ */
+int rsi_send_radio_params_update(struct rsi_common *common)
+{
+	struct rsi_mac_frame *mgmt_frame;
+	struct sk_buff *skb = NULL;
+
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending Radio Params update frame\n", __func__);
+
+	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	if (!skb) {
+		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	memset(skb->data, 0, FRAME_DESC_SZ);
+	mgmt_frame = (struct rsi_mac_frame *)skb->data;
+
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	mgmt_frame->desc_word[1] = cpu_to_le16(RADIO_PARAMS_UPDATE);
+	mgmt_frame->desc_word[3] = cpu_to_le16(BIT(0));
+
+	mgmt_frame->desc_word[3] |= cpu_to_le16(common->tx_power << 8);
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+
+/**
  * rsi_compare() - This function is used to compare two integers
  * @a: pointer to the first integer
  * @b: pointer to the second integer
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index dcd0957..3938f13 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -204,6 +204,8 @@ struct rsi_common {
 	struct cqm_info cqm_info;
 
 	bool hw_data_qs_blocked;
+	
+	int tx_power;
 };
 
 struct rsi_hw {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 40e8f8e..6547ae7 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -169,32 +169,51 @@ enum sta_notify_events {
 
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
+	EEPROM_READ_TYPE, /* 0xE */
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
@@ -317,4 +336,5 @@ int rsi_send_mgmt_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_band_check(struct rsi_common *common);
 int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word);
+int rsi_send_radio_params_update(struct rsi_common *common);
 #endif
-- 
2.4.11
