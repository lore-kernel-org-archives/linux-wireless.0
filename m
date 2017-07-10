Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36529 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753565AbdGJMpT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:45:19 -0400
Received: by mail-pg0-f67.google.com with SMTP id u36so12592864pgn.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:45:19 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 09/17] rsi: update vap capabilities command frame
Date: Mon, 10 Jul 2017 18:10:40 +0530
Message-Id: <1499690448-9956-10-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144535_315625_A1125982)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

VAP capablities frame configured to device is modified to use
common descriptor structure.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 56 ++++++++++++++++++---------------
 drivers/net/wireless/rsi/rsi_main.h     |  3 ++
 drivers/net/wireless/rsi/rsi_mgmt.h     | 19 +++++++++--
 3 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 4bcb840..3ce1f71 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -230,6 +230,8 @@ static void rsi_set_default_parameters(struct rsi_common *common)
 	common->rf_power_val = 0; /* Default 1.9V */
 	common->wlan_rf_power_mode = 0;
 	common->obm_ant_sel_val = 2;
+	common->beacon_interval = RSI_BEACON_INTERVAL;
+	common->dtim_cnt = RSI_DTIM_COUNT;
 }
 
 /**
@@ -627,59 +629,61 @@ int rsi_set_vap_capabilities(struct rsi_common *common,
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_hw *hw = adapter->hw;
 	struct ieee80211_conf *conf = &hw->conf;
+	u16 frame_len = sizeof(struct rsi_vap_caps);
 	u16 vap_id = 0;
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending VAP capabilities frame\n", __func__);
 
-	skb = dev_alloc_skb(sizeof(struct rsi_vap_caps));
+	skb = dev_alloc_skb(frame_len);
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
 			__func__);
 		return -ENOMEM;
 	}
 
-	memset(skb->data, 0, sizeof(struct rsi_vap_caps));
+	memset(skb->data, 0, frame_len);
 	vap_caps = (struct rsi_vap_caps *)skb->data;
 
-	vap_caps->desc_word[0] = cpu_to_le16((sizeof(struct rsi_vap_caps) -
-					     FRAME_DESC_SZ) |
-					     (RSI_WIFI_MGMT_Q << 12));
-	vap_caps->desc_word[1] = cpu_to_le16(VAP_CAPABILITIES);
-	vap_caps->desc_word[2] = cpu_to_le16(vap_status << 8);
-	vap_caps->desc_word[4] = cpu_to_le16(mode |
-					     (common->channel_width << 8));
-	vap_caps->desc_word[7] = cpu_to_le16((vap_id << 8) |
-					     (common->mac_id << 4) |
-					     common->radio_id);
+	rsi_set_len_qno(&vap_caps->desc_dword0.len_qno,
+			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
+	vap_caps->desc_dword0.frame_type = VAP_CAPABILITIES;
+	vap_caps->status = vap_status;
+	vap_caps->vif_type = mode;
+	vap_caps->channel_bw = common->channel_width;
+	vap_caps->vap_id = vap_id;
+	vap_caps->radioid_macid = ((common->mac_id & 0xf) << 4) |
+				   (common->radio_id & 0xf);
 
 	memcpy(vap_caps->mac_addr, common->mac_addr, IEEE80211_ADDR_LEN);
 	vap_caps->keep_alive_period = cpu_to_le16(90);
 	vap_caps->frag_threshold = cpu_to_le16(IEEE80211_MAX_FRAG_THRESHOLD);
 
 	vap_caps->rts_threshold = cpu_to_le16(common->rts_threshold);
-	vap_caps->default_mgmt_rate = cpu_to_le32(RSI_RATE_6);
 
 	if (common->band == NL80211_BAND_5GHZ) {
-		vap_caps->default_ctrl_rate = cpu_to_le32(RSI_RATE_6);
-		if (conf_is_ht40(&common->priv->hw->conf)) {
-			vap_caps->default_ctrl_rate |=
-				cpu_to_le32(FULL40M_ENABLE << 16);
-		}
+		vap_caps->default_ctrl_rate = cpu_to_le16(RSI_RATE_6);
+		vap_caps->default_mgmt_rate = cpu_to_le32(RSI_RATE_6);
 	} else {
-		vap_caps->default_ctrl_rate = cpu_to_le32(RSI_RATE_1);
+		vap_caps->default_ctrl_rate = cpu_to_le16(RSI_RATE_1);
+		vap_caps->default_mgmt_rate = cpu_to_le32(RSI_RATE_1);
+	}
+	if (conf_is_ht40(conf)) {
 		if (conf_is_ht40_minus(conf))
-			vap_caps->default_ctrl_rate |=
-				cpu_to_le32(UPPER_20_ENABLE << 16);
+			vap_caps->ctrl_rate_flags =
+				cpu_to_le16(UPPER_20_ENABLE);
 		else if (conf_is_ht40_plus(conf))
-			vap_caps->default_ctrl_rate |=
-				cpu_to_le32(LOWER_20_ENABLE << 16);
+			vap_caps->ctrl_rate_flags =
+				cpu_to_le16(LOWER_20_ENABLE);
+		else
+			vap_caps->ctrl_rate_flags =
+				cpu_to_le16(FULL40M_ENABLE);
 	}
 
 	vap_caps->default_data_rate = 0;
-	vap_caps->beacon_interval = cpu_to_le16(200);
-	vap_caps->dtim_period = cpu_to_le16(4);
+	vap_caps->beacon_interval = cpu_to_le16(common->beacon_interval);
+	vap_caps->dtim_period = cpu_to_le16(common->dtim_cnt);
 
-	skb_put(skb, sizeof(*vap_caps));
+	skb_put(skb, frame_len);
 
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index a567986..485b97a 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -239,6 +239,9 @@ struct rsi_common {
 	u8 obm_ant_sel_val;
 	int tx_power;
 	u8 ant_in_use;
+
+	u16 beacon_interval;
+	u8 dtim_cnt;
 };
 
 enum host_intf {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 2f49e55..fcde44e 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -167,6 +167,8 @@
 
 #define RSI_MPDU_DENSITY		0x8
 #define RSI_CHAN_RADAR			BIT(7)
+#define RSI_BEACON_INTERVAL		200
+#define RSI_DTIM_COUNT			2
 
 enum opmode {
 	STA_OPMODE = 1,
@@ -320,19 +322,30 @@ struct rsi_chan_config {
 } __packed;
 
 struct rsi_vap_caps {
-	__le16 desc_word[8];
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	u8 reserved1;
+	u8 status;
+	__le16 reserved2;
+	u8 vif_type;
+	u8 channel_bw;
+	__le16 antenna_info;
+	u8 radioid_macid;
+	u8 vap_id;
+	__le16 reserved3;
 	u8 mac_addr[6];
 	__le16 keep_alive_period;
 	u8 bssid[6];
-	__le16 reserved;
+	__le16 reserved4;
 	__le32 flags;
 	__le16 frag_threshold;
 	__le16 rts_threshold;
 	__le32 default_mgmt_rate;
-	__le32 default_ctrl_rate;
+	__le16 default_ctrl_rate;
+	__le16 ctrl_rate_flags;
 	__le32 default_data_rate;
 	__le16 beacon_interval;
 	__le16 dtim_period;
+	__le16 beacon_miss_threshold;
 } __packed;
 
 struct rsi_set_key {
-- 
2.7.4
