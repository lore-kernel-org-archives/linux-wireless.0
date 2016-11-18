Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34244 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbcKRKkQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 05:40:16 -0500
Received: by mail-pg0-f67.google.com with SMTP id e9so19988500pgc.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 02:40:16 -0800 (PST)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 1/4] rsi: Add support to filter rx frames
Date: Fri, 18 Nov 2016 16:07:09 +0530
Message-Id: <1479465429-2412-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161118_114020_697732_BDFD70EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Filtering rx frames after connection in station mode avoids the
overhead of processing un-necessary frames. Hence rx filter frame
is added which can be configured to device at suitable times.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 16 +++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 33 +++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_mgmt.h         | 11 ++++++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dbb2389..fdd31df 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -264,6 +264,8 @@ static int rsi_mac80211_start(struct ieee80211_hw *hw)
 	common->iface_down = false;
 	mutex_unlock(&common->mutex);
 
+	rsi_send_rx_filter_frame(common, 0);
+
 	return 0;
 }
 
@@ -456,11 +458,19 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	u16 rx_filter_word = 0;
 
 	mutex_lock(&common->mutex);
 	if (changed & BSS_CHANGED_ASSOC) {
 		rsi_dbg(INFO_ZONE, "%s: Changed Association status: %d\n",
 			__func__, bss_conf->assoc);
+		if (bss_conf->assoc) {
+			/* Send the RX filter frame */
+			rx_filter_word = (ALLOW_DATA_ASSOC_PEER |
+					  ALLOW_CTRL_ASSOC_PEER |
+					  ALLOW_MGMT_ASSOC_PEER);
+			rsi_send_rx_filter_frame(common, rx_filter_word);
+		}
 		rsi_inform_bss_status(common,
 				      bss_conf->assoc,
 				      bss_conf->bssid,
@@ -998,6 +1008,7 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 	struct rsi_common *common = adapter->priv;
 
 	mutex_lock(&common->mutex);
+
 	/* Resetting all the fields to default values */
 	common->bitrate_mask[NL80211_BAND_2GHZ] = 0;
 	common->bitrate_mask[NL80211_BAND_5GHZ] = 0;
@@ -1007,8 +1018,11 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 	common->vif_info[0].seq_start = 0;
 	common->secinfo.ptk_cipher = 0;
 	common->secinfo.gtk_cipher = 0;
-	mutex_unlock(&common->mutex);
 
+	rsi_send_rx_filter_frame(common, 0);
+	
+	mutex_unlock(&common->mutex);
+	
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 35c14cc..ef4b05a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1240,6 +1240,39 @@ int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
 
 }
 
+/**
+ * rsi_send_rx_filter_frame() - Sends a frame to filter the RX packets
+ *
+ * @common: Pointer to the driver private structure.
+ * @rx_filter_word: Flags of filter packets
+ *
+ * @Return: 0 on success, -1 on failure.
+ */
+int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word)
+{
+	struct rsi_mac_frame *cmd_frame;
+	struct sk_buff *skb;
+
+	rsi_dbg(MGMT_TX_ZONE, "Sending RX filter frame\n");
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
+	cmd_frame->desc_word[1] = cpu_to_le16(SET_RX_FILTER);
+	cmd_frame->desc_word[4] = cpu_to_le16(rx_filter_word);
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
