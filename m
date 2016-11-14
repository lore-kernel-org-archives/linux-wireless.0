Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35528 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbcKNMUK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 07:20:10 -0500
Received: by mail-pf0-f194.google.com with SMTP id i88so6131069pfk.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 04:20:10 -0800 (PST)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 4/5] rsi: Added support for antenna selection
Date: Mon, 14 Nov 2016 17:47:34 +0530
Message-Id: <1479125854-2778-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161114_132013_284994_E96E70F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSI 9113 device supports single antenna for tx and rx. Support for using
external is added. This can be configured from user space using iw.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 78 +++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 33 ++++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 drivers/net/wireless/rsi/rsi_mgmt.h         |  4 ++
 4 files changed, 116 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index ba21608..07314ea 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1071,6 +1071,82 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 	return 0;
 }
 
+/**
+ * rsi_mac80211_set_antenna() - This function is used to configure
+ *				tx and rx antennas.
+ * @hw: Pointer to the ieee80211_hw structure.
+ * @tx_ant: Bitmap for tx antenna
+ * @rx_ant: Bitmap for rx antenna
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int rsi_mac80211_set_antenna(struct ieee80211_hw *hw,
+				    u32 tx_ant, u32 rx_ant)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+	u32 antenna = 0;
+
+	if (tx_ant > 1 || rx_ant > 1) {
+		rsi_dbg(ERR_ZONE,
+			"Invalid antenna selection (tx: %d, rx:%d)\n",
+			tx_ant, rx_ant);
+		rsi_dbg(ERR_ZONE,
+			"Use 0 for int_ant, 1 for ext_ant\n");
+		return -EINVAL; 
+	}
+
+	rsi_dbg(INFO_ZONE, "%s: Antenna map Tx %x Rx %d\n",
+			__func__, tx_ant, rx_ant);
+
+	mutex_lock(&common->mutex);
+
+	antenna = tx_ant ? ANTENNA_SEL_UFL : ANTENNA_SEL_INT;
+	if (common->ant_in_use != antenna)
+		if (rsi_set_antenna(common, antenna))
+			goto fail_set_antenna;
+
+	rsi_dbg(INFO_ZONE, "(%s) Antenna path configured successfully\n",
+		tx_ant ? "UFL" : "INT");
+
+	common->ant_in_use = antenna;
+	
+	mutex_unlock(&common->mutex);
+	
+	return 0;
+
+fail_set_antenna:
+	rsi_dbg(ERR_ZONE, "%s: Failed.\n", __func__);
+	mutex_unlock(&common->mutex);
+	return -EINVAL;
+}
+
+/**
+ * rsi_mac80211_get_antenna() - This function is used to configure 
+ * 				tx and rx antennas.
+ *
+ * @hw: Pointer to the ieee80211_hw structure.
+ * @tx_ant: Bitmap for tx antenna
+ * @rx_ant: Bitmap for rx antenna
+ * 
+ * Return: 0 on success, -1 on failure.
+ */
+static int rsi_mac80211_get_antenna(struct ieee80211_hw *hw,
+				    u32 *tx_ant, u32 *rx_ant)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	mutex_lock(&common->mutex);
+
+	*tx_ant = (common->ant_in_use == ANTENNA_SEL_UFL) ? 1 : 0;
+	*rx_ant = 0;
+
+	mutex_unlock(&common->mutex);
+	
+	return 0;	
+}
+
 static struct ieee80211_ops mac80211_ops = {
 	.tx = rsi_mac80211_tx,
 	.start = rsi_mac80211_start,
@@ -1087,6 +1163,8 @@ static struct ieee80211_ops mac80211_ops = {
 	.ampdu_action = rsi_mac80211_ampdu_action,
 	.sta_add = rsi_mac80211_sta_add,
 	.sta_remove = rsi_mac80211_sta_remove,
+	.set_antenna = rsi_mac80211_set_antenna,
+	.get_antenna = rsi_mac80211_get_antenna,
 };
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 2e8e5dc..16dc3ac 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1326,6 +1326,39 @@ int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word)
 }
 
 /**
+ * rsi_set_antenna() - This fuction handles antenna selection functionality.
+ *
+ * @common: Pointer to the driver private structure.
+ * @antenna: bitmap for tx antenna selection
+ *
+ * Return: 0 on Success, < 0 on failure
+ */
+int rsi_set_antenna(struct rsi_common *common,
+		    u8 antenna)
+{
+	struct rsi_mac_frame *mgmt_frame;
+	struct sk_buff *skb;
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
+	mgmt_frame->desc_word[1] = cpu_to_le16(ANT_SEL_FRAME);
+	mgmt_frame->desc_word[3] = cpu_to_le16(antenna & 0x00ff);
+	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
+/**
  * rsi_handle_ta_confirm_type() - This function handles the confirm frames.
  * @common: Pointer to the driver private structure.
  * @msg: Pointer to received packet.
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 3938f13..2405b30 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -206,6 +206,7 @@ struct rsi_common {
 	bool hw_data_qs_blocked;
 	
 	int tx_power;
+	u8 ant_in_use;
 };
 
 struct rsi_hw {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 6547ae7..1111c07 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -141,6 +141,9 @@
 #define RSI_SUPP_FILTERS	(FIF_ALLMULTI | FIF_PROBE_REQ |\
 				 FIF_BCN_PRBRESP_PROMISC)
 
+#define ANTENNA_SEL_INT			0x02 /* RF_OUT_2 / Integerated */
+#define ANTENNA_SEL_UFL			0x03 /* RF_OUT_1 / U.FL */
+
 /* Rx filter word definitions */
 #define PROMISCOUS_MODE			BIT(0)
 #define ALLOW_DATA_ASSOC_PEER		BIT(1)
@@ -337,4 +340,5 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_band_check(struct rsi_common *common);
 int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word);
 int rsi_send_radio_params_update(struct rsi_common *common);
+int rsi_set_antenna(struct rsi_common *common, u8 antenna);
 #endif
-- 
2.4.11
