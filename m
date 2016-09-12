Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33821 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757479AbcILJne (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:43:34 -0400
Received: by mail-pf0-f193.google.com with SMTP id g202so7873083pfb.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:43:34 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 5/9] rsi: code cleanup in file rsi_91x_mgmt.c
Date: Mon, 12 Sep 2016 15:08:20 +0530
Message-Id: <15f578621eaa8918ccef2887e8e283727bbbfc8a.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114338_452241_2010DDE5)
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
In-Reply-To: <cover.1473669618.git.prameela.j04cs@gmail.com>
References: <cover.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 35c14cc..e505600 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -255,7 +255,7 @@ static int rsi_send_internal_mgmt_frame(struct rsi_common *common,
 {
 	struct skb_info *tx_params;
 
-	if (skb == NULL) {
+	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to allocate skb\n", __func__);
 		return -ENOMEM;
 	}
@@ -290,7 +290,6 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 	rsi_dbg(INFO_ZONE, "%s: Sending rate symbol req frame\n", __func__);
 
 	skb = dev_alloc_skb(sizeof(struct rsi_radio_caps));
-
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
 			__func__);
@@ -310,6 +309,7 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 		if (common->fsm_state == FSM_MAC_INIT_DONE) {
 			struct ieee80211_hw *hw = adapter->hw;
 			struct ieee80211_conf *conf = &hw->conf;
+
 			if (conf_is_ht40_plus(conf)) {
 				radio_caps->desc_word[5] =
 					cpu_to_le16(LOWER_20_ENABLE);
@@ -375,8 +375,8 @@ static int rsi_load_radio_caps(struct rsi_common *common)
  * rsi_mgmt_pkt_to_core() - This function is the entry point for Mgmt module.
  * @common: Pointer to the driver private structure.
  * @msg: Pointer to received packet.
- * @msg_len: Length of the recieved packet.
- * @type: Type of recieved packet.
+ * @msg_len: Length of the received packet.
+ * @type: Type of received packet.
  *
  * Return: 0 on success, -1 on failure.
  */
@@ -425,9 +425,8 @@ static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
 		rx_params->rssi = rsi_get_rssi(msg);
 		rx_params->channel = rsi_get_channel(msg);
 		rsi_indicate_pkt_to_os(common, skb);
-	} else {
+	} else
 		rsi_dbg(MGMT_TX_ZONE, "%s: Internal Packet\n", __func__);
-	}
 
 	return 0;
 }
@@ -545,7 +544,9 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common,
 		mgmt_frame->desc_word[4] = cpu_to_le16(ssn);
 		mgmt_frame->desc_word[5] = cpu_to_le16(buf_size);
 		mgmt_frame->desc_word[7] =
-		cpu_to_le16((tid | (START_AMPDU_AGGR << 4) | (peer_id << 8)));
+			cpu_to_le16((tid |
+				    (START_AMPDU_AGGR << 4) |
+				    (peer_id << 8)));
 	} else if (event == STA_RX_ADDBA_DONE) {
 		mgmt_frame->desc_word[4] = cpu_to_le16(ssn);
 		mgmt_frame->desc_word[7] = cpu_to_le16(tid |
@@ -980,6 +981,7 @@ static int rsi_compare(const void *a, const void *b)
 static bool rsi_map_rates(u16 rate, int *offset)
 {
 	int kk;
+
 	for (kk = 0; kk < ARRAY_SIZE(rsi_mcsrates); kk++) {
 		if (rate == mcs[kk]) {
 			*offset = kk;
@@ -1013,7 +1015,6 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	u8 num_supported_rates = 0;
 	u8 rate_table_offset, rate_offset = 0;
 	u32 rate_bitmap = common->bitrate_mask[band];
-
 	u16 *selected_rates, min_rate;
 
 	skb = dev_alloc_skb(sizeof(struct rsi_auto_rate));
@@ -1261,9 +1262,8 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 			if (rsi_eeprom_read(common)) {
 				common->fsm_state = FSM_CARD_NOT_READY;
 				goto out;
-			} else {
+			} else
 				common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
-			}
 		} else {
 			rsi_dbg(INFO_ZONE,
 				"%s: Received bootup params cfm in %d state\n",
@@ -1275,8 +1275,10 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 	case EEPROM_READ_TYPE:
 		if (common->fsm_state == FSM_EEPROM_READ_MAC_ADDR) {
 			if (msg[16] == MAGIC_WORD) {
-				u8 offset = (FRAME_DESC_SZ + WLAN_HOST_MODE_LEN
-					     + WLAN_MAC_MAGIC_WORD_LEN);
+				u8 offset = (FRAME_DESC_SZ +
+					     WLAN_HOST_MODE_LEN +
+					     WLAN_MAC_MAGIC_WORD_LEN);
+
 				memcpy(common->mac_addr,
 				       &msg[offset],
 				       ETH_ALEN);
@@ -1347,7 +1349,7 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 			}
 		} else {
 			rsi_dbg(INFO_ZONE,
-				"%s: Received bbb_rf cfm in %d state\n",
+				"%s: Received bb_rf cfm in %d state\n",
 				 __func__, common->fsm_state);
 			return 0;
 		}
@@ -1367,7 +1369,7 @@ out:
 
 /**
  * rsi_mgmt_pkt_recv() - This function processes the management packets
- *			 recieved from the hardware.
+ *			 received from the hardware.
  * @common: Pointer to the driver private structure.
  * @msg: Pointer to the received packet.
  *
-- 
2.4.11
