Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34238 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932258AbcKNMcD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 07:32:03 -0500
Received: by mail-pf0-f195.google.com with SMTP id y68so6173700pfb.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 04:32:02 -0800 (PST)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/5] rsi: Added rx filter frame
Date: Mon, 14 Nov 2016 17:46:52 +0530
Message-Id: <1479125812-2666-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161114_133208_121549_768F2F91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Filtering the rx frames in firmware after connection in station mode
avoids the overhead of processing un-necessary frames. Hence rx filter
frame is added which can be configured to device at suitable times.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 22 ++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 32 +++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_mgmt.h         | 11 ++++++++++
 3 files changed, 65 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dbb2389..fa9498d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -259,11 +259,14 @@ static int rsi_mac80211_start(struct ieee80211_hw *hw)
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	u16 rx_filter_word = 0;
 
 	mutex_lock(&common->mutex);
 	common->iface_down = false;
 	mutex_unlock(&common->mutex);
 
+	rsi_send_rx_filter_frame(common, rx_filter_word);
+
 	return 0;
 }
 
@@ -456,11 +459,28 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	struct ieee80211_bss_conf *bss = &adapter->vifs[0]->bss_conf;
+	u16 rx_filter_word = 0;
 
 	mutex_lock(&common->mutex);
 	if (changed & BSS_CHANGED_ASSOC) {
 		rsi_dbg(INFO_ZONE, "%s: Changed Association status: %d\n",
 			__func__, bss_conf->assoc);
+		bss->assoc = bss_conf->assoc;
+		if (bss_conf->assoc) {
+			/* Send the RX filter frame */
+			rx_filter_word = (ALLOW_DATA_ASSOC_PEER |
+					  ALLOW_CTRL_ASSOC_PEER |
+					  ALLOW_MGMT_ASSOC_PEER);
+			rsi_send_rx_filter_frame(common, rx_filter_word);
+		}
+		rsi_dbg(INFO_ZONE,
+			"assoc_status=%d, qos=%d, aid=%d\n",
+			bss->assoc, bss->qos, bss->aid);
+		rsi_dbg(INFO_ZONE,
+			"bssid=%02x:%02x:%02x:%02x:%02x:%02x",
+			bss->bssid[0], bss->bssid[1], bss->bssid[2],
+			bss->bssid[3], bss->bssid[4], bss->bssid[5]);
 		rsi_inform_bss_status(common,
 				      bss_conf->assoc,
 				      bss_conf->bssid,
@@ -1009,6 +1029,8 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 	common->secinfo.gtk_cipher = 0;
 	mutex_unlock(&common->mutex);
 
+	if (!common->iface_down)
+		rsi_send_rx_filter_frame(common, 0);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 8db377b..ae4a814 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1254,6 +1254,38 @@ int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
 
 }
 
+/**
+ * This function sends a frame to filter the RX packets
+ *
+ * @param common Pointer to the driver private structure.
+ * @param rx_filter_word - Flags of filter packets
+ * @return 0 on success, -1 on failure.
+ */
+int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word)
+{
+	struct rsi_mac_frame *mgmt_frame;
+	struct sk_buff *skb;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending RX filter frame\n", __func__);
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
+	mgmt_frame->desc_word[1] = cpu_to_le16(SET_RX_FILTER);
+	mgmt_frame->desc_word[4] = cpu_to_le16(rx_filter_word);
+
+	skb_put(skb, FRAME_DESC_SZ);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
 
 /**
  * rsi_handle_ta_confirm_type() - This function handles the confirm frames.
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 3741173..40e8f8e 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -140,6 +140,16 @@
 
 #define RSI_SUPP_FILTERS	(FIF_ALLMULTI | FIF_PROBE_REQ |\
 				 FIF_BCN_PRBRESP_PROMISC)
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
 enum opmode {
 	STA_OPMODE = 1,
 	AP_OPMODE = 2
@@ -306,4 +316,5 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_mgmt_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_band_check(struct rsi_common *common);
+int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word);
 #endif
-- 
2.4.11
