Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38814 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaFNNzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:55:42 -0400
Received: by mail-pa0-f53.google.com with SMTP id kx10so3003161pab.26
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:55:41 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id sv10sm37771883pab.32.2014.06.14.06.55.40
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:55:40 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/16] rsi: Adding support for 5GHz
Date: Sat, 14 Jun 2014 19:25:31 +0530
Message-Id: <1402754131-14261-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155544_805761_331A79B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding support for 5GHz.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |   17 +++--
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   81 +++++++++++++++++++++++++--
 drivers/net/wireless/rsi/rsi_mgmt.h         |    1 +
 3 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 45bdb99..4700714 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -723,17 +723,17 @@ static int rsi_mac80211_set_rate_mask(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	enum ieee80211_band band = hw->conf.chandef.chan->band;
 
 	mutex_lock(&common->mutex);
+	common->fixedrate_mask[band] = 0;
 
-	common->fixedrate_mask[IEEE80211_BAND_2GHZ] = 0;
-
-	if (mask->control[IEEE80211_BAND_2GHZ].legacy == 0xfff) {
-		common->fixedrate_mask[IEEE80211_BAND_2GHZ] =
-			(mask->control[IEEE80211_BAND_2GHZ].ht_mcs[0] << 12);
+	if (mask->control[band].legacy == 0xfff) {
+		common->fixedrate_mask[band] =
+			(mask->control[band].ht_mcs[0] << 12);
 	} else {
-		common->fixedrate_mask[IEEE80211_BAND_2GHZ] =
-			mask->control[IEEE80211_BAND_2GHZ].legacy;
+		common->fixedrate_mask[band] =
+			mask->control[band].legacy;
 	}
 	mutex_unlock(&common->mutex);
 
@@ -980,6 +980,7 @@ int rsi_mac80211_attach(struct rsi_common *common)
 
 	hw->max_tx_aggregation_subframes = 6;
 	rsi_register_rates_channels(adapter, IEEE80211_BAND_2GHZ);
+	rsi_register_rates_channels(adapter, IEEE80211_BAND_5GHZ);
 	hw->rate_control_algorithm = "AARF";
 
 	SET_IEEE80211_PERM_ADDR(hw, common->mac_addr);
@@ -997,6 +998,8 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->available_antennas_tx = 1;
 	wiphy->bands[IEEE80211_BAND_2GHZ] =
 		&adapter->sbands[IEEE80211_BAND_2GHZ];
+	wiphy->bands[IEEE80211_BAND_5GHZ] =
+		&adapter->sbands[IEEE80211_BAND_5GHZ];
 
 	status = ieee80211_register_hw(hw);
 	if (status)
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 92f584e..cbd5a7e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -623,6 +623,9 @@ int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
 {
 	struct sk_buff *skb = NULL;
 	struct rsi_vap_caps *vap_caps;
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hw *hw = adapter->hw;
+	struct ieee80211_conf *conf = &hw->conf;
 	u16 vap_id = 0;
 
 	rsi_dbg(MGMT_TX_ZONE, "%s: Sending VAP capabilities frame\n", __func__);
@@ -652,13 +655,24 @@ int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode)
 	vap_caps->frag_threshold = cpu_to_le16(IEEE80211_MAX_FRAG_THRESHOLD);
 
 	vap_caps->rts_threshold = cpu_to_le16(common->rts_threshold);
-	vap_caps->default_mgmt_rate = 0;
-	if (conf_is_ht40(&common->priv->hw->conf)) {
-		vap_caps->default_ctrl_rate =
-				cpu_to_le32(RSI_RATE_6 | FULL40M_ENABLE << 16);
-	} else {
+	vap_caps->default_mgmt_rate = cpu_to_le32(RSI_RATE_6);
+
+	if (common->band == IEEE80211_BAND_5GHZ) {
 		vap_caps->default_ctrl_rate = cpu_to_le32(RSI_RATE_6);
+		if (conf_is_ht40(&common->priv->hw->conf)) {
+			vap_caps->default_ctrl_rate |=
+				cpu_to_le32(FULL40M_ENABLE << 16);
+		}
+	} else {
+		vap_caps->default_ctrl_rate = cpu_to_le32(RSI_RATE_1);
+		if (conf_is_ht40_minus(conf))
+			vap_caps->default_ctrl_rate |=
+				cpu_to_le32(UPPER_20_ENABLE << 16);
+		else if (conf_is_ht40_plus(conf))
+			vap_caps->default_ctrl_rate |=
+				cpu_to_le32(LOWER_20_ENABLE << 16);
 	}
+
 	vap_caps->default_data_rate = 0;
 	vap_caps->beacon_interval = cpu_to_le16(200);
 	vap_caps->dtim_period = cpu_to_le16(4);
@@ -835,6 +849,63 @@ static int rsi_send_reset_mac(struct rsi_common *common)
 }
 
 /**
+ * rsi_band_check() - This function programs the band
+ * @common: Pointer to the driver private structure.
+ *
+ * Return: 0 on success, corresponding error code on failure.
+ */
+int rsi_band_check(struct rsi_common *common)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_hw *hw = adapter->hw;
+	u8 prev_bw = common->channel_width;
+	u8 prev_ep = common->endpoint;
+	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+	int status = 0;
+
+	if (common->band != curchan->band) {
+		common->rf_reset = 1;
+		common->band = curchan->band;
+	}
+
+	if ((hw->conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT) ||
+	    (hw->conf.chandef.width == NL80211_CHAN_WIDTH_20))
+		common->channel_width = BW_20MHZ;
+	else
+		common->channel_width = BW_40MHZ;
+
+	if (common->band == IEEE80211_BAND_2GHZ) {
+		if (common->channel_width)
+			common->endpoint = EP_2GHZ_40MHZ;
+		else
+			common->endpoint = EP_2GHZ_20MHZ;
+	} else {
+		if (common->channel_width)
+			common->endpoint = EP_5GHZ_40MHZ;
+		else
+			common->endpoint = EP_5GHZ_20MHZ;
+	}
+
+	if (common->endpoint != prev_ep) {
+		status = rsi_program_bb_rf(common);
+		if (status)
+			return status;
+	}
+
+	if (common->channel_width != prev_bw) {
+		status = rsi_load_bootup_params(common);
+		if (status)
+			return status;
+
+		status = rsi_load_radio_caps(common);
+		if (status)
+			return status;
+	}
+
+	return status;
+}
+
+/**
  * rsi_set_channel() - This function programs the channel.
  * @common: Pointer to the driver private structure.
  * @channel: Channel value to be set.
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 8bff664..f10d6c6 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -304,4 +304,5 @@ void rsi_core_qos_processor(struct rsi_common *common);
 void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_mgmt_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
+int rsi_band_check(struct rsi_common *common);
 #endif
-- 
1.7.1

