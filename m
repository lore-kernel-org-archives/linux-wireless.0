Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34249 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbcKRKlS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 05:41:18 -0500
Received: by mail-pf0-f195.google.com with SMTP id y68so13403757pfb.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 02:41:18 -0800 (PST)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 4/4] rsi: Add support for 802.11d
Date: Fri, 18 Nov 2016 16:08:43 +0530
Message-Id: <1479465523-2578-1-git-send-email-prameela.j04cs@gmail.com> (sfid-20161118_114134_946547_0455393B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Transmit power level in a channel is determined based on the dfs region.
To support regulatory rules dfs region should be configured to device during
set channel request. Also antenna gain values are taken from the mac80211
channel parameters instead of fixed values.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 30 ++++++++++++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 26 ++++++++++++++++++++-----
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 drivers/net/wireless/rsi/rsi_mgmt.h         |  3 ++-
 4 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 6789c0b..65a5c5a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -375,7 +375,7 @@ static int rsi_channel_change(struct ieee80211_hw *hw)
 
 	status = rsi_band_check(common);
 	if (!status)
-		status = rsi_set_channel(adapter->priv, channel);
+		status = rsi_set_channel(adapter->priv, curchan);
 
 	if (bss->assoc) {
 		if (common->hw_data_qs_blocked &&
@@ -1136,6 +1136,32 @@ static int rsi_mac80211_get_antenna(struct ieee80211_hw *hw,
 	return 0;	
 }
 
+static void rsi_reg_notify(struct wiphy *wiphy,
+			   struct regulatory_request *request)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct rsi_hw * adapter = hw->priv; 
+	int i;
+
+	sband = wiphy->bands[NL80211_BAND_5GHZ];
+	
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+		if (ch->flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
+		if (ch->flags & IEEE80211_CHAN_RADAR)
+			ch->flags |= IEEE80211_CHAN_NO_IR;
+	}
+	
+	rsi_dbg(INFO_ZONE,
+		"country = %s dfs_region = %d\n",
+		request->alpha2, request->dfs_region);
+	adapter->dfs_region = request->dfs_region;
+}
+
 static struct ieee80211_ops mac80211_ops = {
 	.tx = rsi_mac80211_tx,
 	.start = rsi_mac80211_start,
@@ -1218,6 +1244,8 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->bands[NL80211_BAND_5GHZ] =
 		&adapter->sbands[NL80211_BAND_5GHZ];
 
+	wiphy->reg_notifier = rsi_reg_notify;
+
 	status = ieee80211_register_hw(hw);
 	if (status)
 		return status;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index a16eeed..229aec4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -910,7 +910,8 @@ int rsi_band_check(struct rsi_common *common)
  *
  * Return: 0 on success, corresponding error code on failure.
  */
-int rsi_set_channel(struct rsi_common *common, u16 channel)
+int rsi_set_channel(struct rsi_common *common,
+		    struct ieee80211_channel *channel)
 {
 	struct sk_buff *skb = NULL;
 	struct rsi_mac_frame *mgmt_frame;
@@ -925,24 +926,39 @@ int rsi_set_channel(struct rsi_common *common, u16 channel)
 		return -ENOMEM;
 	}
 
+	if (!channel) {
+		dev_kfree_skb(skb);
+		return 0;
+	}
 	memset(skb->data, 0, FRAME_DESC_SZ);
 	mgmt_frame = (struct rsi_mac_frame *)skb->data;
 
 	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
 	mgmt_frame->desc_word[1] = cpu_to_le16(SCAN_REQUEST);
-	mgmt_frame->desc_word[4] = cpu_to_le16(channel);
+	mgmt_frame->desc_word[4] = cpu_to_le16(channel->hw_value);
+
+	mgmt_frame->desc_word[4] |=
+		cpu_to_le16(((char)(channel->max_antenna_gain)) << 8);
+	mgmt_frame->desc_word[5] =
+		cpu_to_le16((char)(channel->max_antenna_gain));
 
 	mgmt_frame->desc_word[7] = cpu_to_le16(PUT_BBP_RESET |
 					       BBP_REG_WRITE |
 					       (RSI_RF_TYPE << 4));
 
-	mgmt_frame->desc_word[5] = cpu_to_le16(0x01);
-	mgmt_frame->desc_word[6] = cpu_to_le16(0x12);
+	if (!(channel->flags & IEEE80211_CHAN_NO_IR) &&
+	       !(channel->flags & IEEE80211_CHAN_RADAR)) {
+		if (common->tx_power < channel->max_power)
+			mgmt_frame->desc_word[6] = cpu_to_le16(common->tx_power);
+		else
+			mgmt_frame->desc_word[6] = cpu_to_le16(channel->max_power);
+	}
+	mgmt_frame->desc_word[7] = cpu_to_le16(common->priv->dfs_region);
 
 	if (common->channel_width == BW_40MHZ)
 		mgmt_frame->desc_word[5] |= cpu_to_le16(0x1 << 8);
 
-	common->channel = channel;
+	common->channel = channel->hw_value;
 
 	skb_put(skb, FRAME_DESC_SZ);
 
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 2405b30..1d5904b 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -223,6 +223,7 @@ struct rsi_hw {
 	struct rsi_debugfs *dfsentry;
 	u8 num_debugfs_entries;
 #endif
+	u8 dfs_region;
 	void *rsi_dev;
 	int (*host_intf_read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
 	int (*host_intf_write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 02b203f..bfc327c 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -307,7 +307,8 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common, u16 tid,
 				      u16 ssn, u8 buf_size, u8 event);
 int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
 		     u8 key_type, u8 key_id, u32 cipher);
-int rsi_set_channel(struct rsi_common *common, u16 chno);
+int rsi_set_channel(struct rsi_common *common,
+		    struct ieee80211_channel *channel);
 int rsi_send_block_unblock_frame(struct rsi_common *common, bool event);
 void rsi_inform_bss_status(struct rsi_common *common, u8 status,
 			   const u8 *bssid, u8 qos_enable, u16 aid);
-- 
2.4.11
