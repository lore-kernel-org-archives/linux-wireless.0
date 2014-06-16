Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40414 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaFPORP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:17:15 -0400
Received: by mail-pb0-f43.google.com with SMTP id um1so1911769pbc.2
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 07:17:14 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id ln2sm69538950pab.35.2014.06.16.07.17.12
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 16 Jun 2014 07:17:14 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 16/16] rsi: Changes for 40MHz
Date: Mon, 16 Jun 2014 19:47:03 +0530
Message-Id: <1402928223-4263-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140616_161717_684347_AC7548D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added code required for 40MHz.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |    2 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   40 +++++++++++++--------------
 drivers/net/wireless/rsi/rsi_91x_pkt.c      |   11 +++++++
 3 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 1cb3164..aeaf87b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -177,7 +177,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 	sbands->ht_cap.cap = (IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 			      IEEE80211_HT_CAP_SGI_20 |
 			      IEEE80211_HT_CAP_SGI_40);
-	sbands->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K;
+	sbands->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K;
 	sbands->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
 	sbands->ht_cap.mcs.rx_mask[0] = 0xff;
 	sbands->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 3ef3434..83abe58 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -277,7 +277,6 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 {
 	struct rsi_radio_caps *radio_caps;
 	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_hw *hw = adapter->hw;
 	u16 inx = 0;
 	u8 ii;
 	u8 radio_id = 0;
@@ -286,7 +285,6 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 		      0xf0, 0xf0, 0xf0, 0xf0,
 		      0xf0, 0xf0, 0xf0, 0xf0,
 		      0xf0, 0xf0, 0xf0, 0xf0};
-	struct ieee80211_conf *conf = &hw->conf;
 	struct sk_buff *skb;
 
 	rsi_dbg(INFO_ZONE, "%s: Sending rate symbol req frame\n", __func__);
@@ -308,26 +306,26 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 	if (common->channel_width == BW_40MHZ) {
 		radio_caps->desc_word[7] |= cpu_to_le16(RSI_LMAC_CLOCK_80MHZ);
 		radio_caps->desc_word[7] |= cpu_to_le16(RSI_ENABLE_40MHZ);
-		if (common->channel_width) {
-			radio_caps->desc_word[5] =
-				cpu_to_le16(common->channel_width << 12);
-			radio_caps->desc_word[5] |= cpu_to_le16(FULL40M_ENABLE);
-		}
 
-		if (conf_is_ht40_minus(conf)) {
-			radio_caps->desc_word[5] = 0;
-			radio_caps->desc_word[5] |=
-				cpu_to_le16(LOWER_20_ENABLE);
-			radio_caps->desc_word[5] |=
-				cpu_to_le16(LOWER_20_ENABLE >> 12);
-		}
-
-		if (conf_is_ht40_plus(conf)) {
-			radio_caps->desc_word[5] = 0;
-			radio_caps->desc_word[5] |=
-				cpu_to_le16(UPPER_20_ENABLE);
-			radio_caps->desc_word[5] |=
-				cpu_to_le16(UPPER_20_ENABLE >> 12);
+		if (common->fsm_state == FSM_MAC_INIT_DONE) {
+			struct ieee80211_hw *hw = adapter->hw;
+			struct ieee80211_conf *conf = &hw->conf;
+			if (conf_is_ht40_plus(conf)) {
+				radio_caps->desc_word[5] =
+					cpu_to_le16(LOWER_20_ENABLE);
+				radio_caps->desc_word[5] |=
+					cpu_to_le16(LOWER_20_ENABLE >> 12);
+			} else if (conf_is_ht40_minus(conf)) {
+				radio_caps->desc_word[5] =
+					cpu_to_le16(UPPER_20_ENABLE);
+				radio_caps->desc_word[5] |=
+					cpu_to_le16(UPPER_20_ENABLE >> 12);
+			} else {
+				radio_caps->desc_word[5] =
+					cpu_to_le16(BW_40MHZ << 12);
+				radio_caps->desc_word[5] |=
+					cpu_to_le16(FULL40M_ENABLE);
+			}
 		}
 	}
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index 229ef3a..702593f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -81,6 +81,10 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 		/* Send fixed rate */
 		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
 		frame_desc[4] = cpu_to_le16(common->min_rate);
+
+		if (conf_is_ht40(&common->priv->hw->conf))
+			frame_desc[5] = cpu_to_le16(FULL40M_ENABLE);
+
 		if (common->vif_info[0].sgi) {
 			if (common->min_rate & 0x100) /* Only MCS rates */
 				frame_desc[4] |=
@@ -122,6 +126,8 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	struct ieee80211_hdr *wh = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_bss_conf *bss = NULL;
+	struct ieee80211_hw *hw = adapter->hw;
+	struct ieee80211_conf *conf = &hw->conf;
 	struct skb_info *tx_params;
 	int status = -E2BIG;
 	__le16 *msg = NULL;
@@ -181,6 +187,11 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	else
 		msg[4] = cpu_to_le16((RSI_RATE_6 & 0x0f) | RSI_11G_MODE);
 
+	if (conf_is_ht40(conf)) {
+		msg[4] = cpu_to_le16(0xB | RSI_11G_MODE);
+		msg[5] = cpu_to_le16(0x6);
+	}
+
 	/* Indicate to firmware to give cfm */
 	if ((skb->data[16] == IEEE80211_STYPE_PROBE_REQ) && (!bss->assoc)) {
 		msg[1] |= cpu_to_le16(BIT(10));
-- 
1.7.1

