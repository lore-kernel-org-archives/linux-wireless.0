Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35534 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbcKRKkl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 05:40:41 -0500
Received: by mail-pg0-f66.google.com with SMTP id p66so20368737pga.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 02:40:41 -0800 (PST)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/4] rsi: Add support for configuring tx power
Date: Fri, 18 Nov 2016 16:08:04 +0530
Message-Id: <1479465484-2468-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161118_114044_612664_D00AF7E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX power can be configured from iwconfig, iw or from mac80211 when
regulatory changes are done. Hence support for configuring tx power
to device is added using the RADIO_PARAMS_UPDATE command frame.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 34 ++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 37 +++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |  2 ++
 drivers/net/wireless/rsi/rsi_mgmt.h         |  4 +++-
 4 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index fdd31df..ba0f5ca 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -396,6 +396,34 @@ static int rsi_channel_change(struct ieee80211_hw *hw)
 }
 
 /**
+ * rsi_config_power() - This function configures tx power to device
+ * @hw: Pointer to the ieee80211_hw structure.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int rsi_config_power(struct ieee80211_hw *hw)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	struct ieee80211_conf *conf = &hw->conf;
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
+	return rsi_send_radio_params_update(common);
+}
+
+/**
  * rsi_mac80211_config() - This function is a handler for configuration
  *			   requests. The stack calls this function to
  *			   change hardware configuration, e.g., channel.
@@ -416,6 +444,12 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
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
index ef4b05a..f20db82 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -950,6 +950,43 @@ int rsi_set_channel(struct rsi_common *common, u16 channel)
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
+	struct rsi_mac_frame *cmd_frame;
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
+	cmd_frame = (struct rsi_mac_frame *)skb->data;
+
+	cmd_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+	cmd_frame->desc_word[1] = cpu_to_le16(RADIO_PARAMS_UPDATE);
+	cmd_frame->desc_word[3] = cpu_to_le16(BIT(0));
+
+	cmd_frame->desc_word[3] |= cpu_to_le16(common->tx_power << 8);
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
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
index 40e8f8e..80d3331 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -194,7 +194,8 @@ enum cmd_frame_type {
 	BG_SCAN_PARAMS,
 	BG_SCAN_PROBE_REQ,
 	CW_MODE_REQ,
-	PER_CMD_PKT
+	PER_CMD_PKT,
+	RADIO_PARAMS_UPDATE = 0x29
 };
 
 struct rsi_mac_frame {
@@ -317,4 +318,5 @@ int rsi_send_mgmt_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_band_check(struct rsi_common *common);
 int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word);
+int rsi_send_radio_params_update(struct rsi_common *common);
 #endif
-- 
2.4.11
