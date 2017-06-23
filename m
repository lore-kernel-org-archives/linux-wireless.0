Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35326 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdFWOKn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:10:43 -0400
Received: by mail-pg0-f68.google.com with SMTP id f127so6276403pgc.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:10:43 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 08/17] rsi: update set_channel command frame
Date: Fri, 23 Jun 2017 19:37:27 +0530
Message-Id: <1498226856-6305-9-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161047_137811_12532317)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

TX command frame set_channel is modified to use common
descriptor structure. Also DFS channel indication to firmware
is added in the descriptor for dfs channels configuration.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 47 +++++++++++++++------------------
 drivers/net/wireless/rsi/rsi_mgmt.h     | 13 +++++++++
 2 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index a1616d7..c7945ea 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -969,12 +969,13 @@ int rsi_set_channel(struct rsi_common *common,
 		    struct ieee80211_channel *channel)
 {
 	struct sk_buff *skb = NULL;
-	struct rsi_mac_frame *mgmt_frame;
+	struct rsi_chan_config *chan_cfg;
+	u16 frame_len = sizeof(struct rsi_chan_config);
 
 	rsi_dbg(MGMT_TX_ZONE,
 		"%s: Sending scan req frame\n", __func__);
 
-	skb = dev_alloc_skb(FRAME_DESC_SZ);
+	skb = dev_alloc_skb(frame_len);
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
 			__func__);
@@ -985,37 +986,33 @@ int rsi_set_channel(struct rsi_common *common,
 		dev_kfree_skb(skb);
 		return 0;
 	}
-	memset(skb->data, 0, FRAME_DESC_SZ);
-	mgmt_frame = (struct rsi_mac_frame *)skb->data;
-
-	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
-	mgmt_frame->desc_word[1] = cpu_to_le16(SCAN_REQUEST);
-	mgmt_frame->desc_word[4] = cpu_to_le16(channel->hw_value);
-
-	mgmt_frame->desc_word[4] |=
-		cpu_to_le16(((char)(channel->max_antenna_gain)) << 8);
-	mgmt_frame->desc_word[5] =
-		cpu_to_le16((char)(channel->max_antenna_gain));
-
-	mgmt_frame->desc_word[7] = cpu_to_le16(PUT_BBP_RESET |
-					       BBP_REG_WRITE |
-					       (RSI_RF_TYPE << 4));
-
-	if (!(channel->flags & IEEE80211_CHAN_NO_IR) &&
-	       !(channel->flags & IEEE80211_CHAN_RADAR)) {
+	memset(skb->data, 0, frame_len);
+	chan_cfg = (struct rsi_chan_config *)skb->data;
+
+	rsi_set_len_qno(&chan_cfg->desc_dword0.len_qno, 0, RSI_WIFI_MGMT_Q);
+	chan_cfg->desc_dword0.frame_type = SCAN_REQUEST;
+	chan_cfg->channel_number = channel->hw_value;
+	chan_cfg->antenna_gain_offset_2g = channel->max_antenna_gain;
+	chan_cfg->antenna_gain_offset_5g = channel->max_antenna_gain;
+	chan_cfg->region_rftype = (RSI_RF_TYPE & 0xf) << 4;
+
+	if ((channel->flags & IEEE80211_CHAN_NO_IR) ||
+	    (channel->flags & IEEE80211_CHAN_RADAR)) {
+		chan_cfg->antenna_gain_offset_2g |= RSI_CHAN_RADAR;
+	} else {
 		if (common->tx_power < channel->max_power)
-			mgmt_frame->desc_word[6] = cpu_to_le16(common->tx_power);
+			chan_cfg->tx_power = cpu_to_le16(common->tx_power);
 		else
-			mgmt_frame->desc_word[6] = cpu_to_le16(channel->max_power);
+			chan_cfg->tx_power = cpu_to_le16(channel->max_power);
 	}
-	mgmt_frame->desc_word[7] = cpu_to_le16(common->priv->dfs_region);
+	chan_cfg->region_rftype |= (common->priv->dfs_region & 0xf);
 
 	if (common->channel_width == BW_40MHZ)
-		mgmt_frame->desc_word[5] |= cpu_to_le16(0x1 << 8);
+		chan_cfg->channel_width = 0x1;
 
 	common->channel = channel->hw_value;
 
-	skb_put(skb, FRAME_DESC_SZ);
+	skb_put(skb, frame_len);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index d44c79f..2f49e55 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -166,6 +166,7 @@
 #define DISALLOW_BROADCAST_DATA		BIT(6)
 
 #define RSI_MPDU_DENSITY		0x8
+#define RSI_CHAN_RADAR			BIT(7)
 
 enum opmode {
 	STA_OPMODE = 1,
@@ -306,6 +307,18 @@ struct rsi_bb_rf_prog {
 	__le16 flags;
 } __packed;
 
+struct rsi_chan_config {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	struct rsi_cmd_desc_dword1 desc_dword1;
+	u8 channel_number;
+	u8 antenna_gain_offset_2g;
+	u8 antenna_gain_offset_5g;
+	u8 channel_width;
+	__le16 tx_power;
+	u8 region_rftype;
+	u8 flags;
+} __packed;
+
 struct rsi_vap_caps {
 	__le16 desc_word[8];
 	u8 mac_addr[6];
-- 
2.7.4
