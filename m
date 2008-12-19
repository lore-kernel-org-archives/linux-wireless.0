Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65030 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbYLSCp1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:27 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 27/43] iwl3945: rename iwl3945_priv variables
Date: Fri, 19 Dec 2008 10:37:27 +0800
Message-Id: <1229654263-21454-28-git-send-email-yi.zhu@intel.com> (sfid-20081219_034613_458142_C54ED18B)
In-Reply-To: <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch renames iwl3945 specific variables in iwl3945_priv
structure. iwl3945_priv structure differs with iwl_priv structure
with these variables. Goal of this patch is to make transition from
iwl3945_priv to iwl_priv smoothly.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |   56 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   66 +++---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   24 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  378 +++++++++++++-------------
 5 files changed, 264 insertions(+), 264 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 32d09ba..1ef21b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -313,66 +313,66 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 	priv->allow_blinking = 0;
 
 	trigger = ieee80211_get_radio_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_RADIO].name,
-		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s:radio",
+	snprintf(priv->led39[IWL_LED_TRG_RADIO].name,
+		 sizeof(priv->led39[IWL_LED_TRG_RADIO].name), "iwl-%s:radio",
 		 wiphy_name(priv->hw->wiphy));
 
-	priv->led[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on;
-	priv->led[IWL_LED_TRG_RADIO].led_off = iwl3945_led_off;
-	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
+	priv->led39[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on;
+	priv->led39[IWL_LED_TRG_RADIO].led_off = iwl3945_led_off;
+	priv->led39[IWL_LED_TRG_RADIO].led_pattern = NULL;
 
 	ret = iwl3945_led_register_led(priv,
-				   &priv->led[IWL_LED_TRG_RADIO],
+				   &priv->led39[IWL_LED_TRG_RADIO],
 				   IWL_LED_TRG_RADIO, 1, trigger);
 
 	if (ret)
 		goto exit_fail;
 
 	trigger = ieee80211_get_assoc_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_ASSOC].name,
-		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s:assoc",
+	snprintf(priv->led39[IWL_LED_TRG_ASSOC].name,
+		 sizeof(priv->led39[IWL_LED_TRG_ASSOC].name), "iwl-%s:assoc",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
-				   &priv->led[IWL_LED_TRG_ASSOC],
+				   &priv->led39[IWL_LED_TRG_ASSOC],
 				   IWL_LED_TRG_ASSOC, 0, trigger);
 
 	/* for assoc always turn led on */
-	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on;
-	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on;
-	priv->led[IWL_LED_TRG_ASSOC].led_pattern = NULL;
+	priv->led39[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on;
+	priv->led39[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on;
+	priv->led39[IWL_LED_TRG_ASSOC].led_pattern = NULL;
 
 	if (ret)
 		goto exit_fail;
 
 	trigger = ieee80211_get_rx_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_RX].name,
-		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s:RX",
+	snprintf(priv->led39[IWL_LED_TRG_RX].name,
+		 sizeof(priv->led39[IWL_LED_TRG_RX].name), "iwl-%s:RX",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
-				   &priv->led[IWL_LED_TRG_RX],
+				   &priv->led39[IWL_LED_TRG_RX],
 				   IWL_LED_TRG_RX, 0, trigger);
 
-	priv->led[IWL_LED_TRG_RX].led_on = iwl3945_led_associated;
-	priv->led[IWL_LED_TRG_RX].led_off = iwl3945_led_associated;
-	priv->led[IWL_LED_TRG_RX].led_pattern = iwl3945_led_pattern;
+	priv->led39[IWL_LED_TRG_RX].led_on = iwl3945_led_associated;
+	priv->led39[IWL_LED_TRG_RX].led_off = iwl3945_led_associated;
+	priv->led39[IWL_LED_TRG_RX].led_pattern = iwl3945_led_pattern;
 
 	if (ret)
 		goto exit_fail;
 
 	trigger = ieee80211_get_tx_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_TX].name,
-		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s:TX",
+	snprintf(priv->led39[IWL_LED_TRG_TX].name,
+		 sizeof(priv->led39[IWL_LED_TRG_TX].name), "iwl-%s:TX",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
-				   &priv->led[IWL_LED_TRG_TX],
+				   &priv->led39[IWL_LED_TRG_TX],
 				   IWL_LED_TRG_TX, 0, trigger);
 
-	priv->led[IWL_LED_TRG_TX].led_on = iwl3945_led_associated;
-	priv->led[IWL_LED_TRG_TX].led_off = iwl3945_led_associated;
-	priv->led[IWL_LED_TRG_TX].led_pattern = iwl3945_led_pattern;
+	priv->led39[IWL_LED_TRG_TX].led_on = iwl3945_led_associated;
+	priv->led39[IWL_LED_TRG_TX].led_off = iwl3945_led_associated;
+	priv->led39[IWL_LED_TRG_TX].led_pattern = iwl3945_led_pattern;
 
 	if (ret)
 		goto exit_fail;
@@ -401,9 +401,9 @@ static void iwl3945_led_unregister_led(struct iwl3945_led *led, u8 set_led)
 /* Unregister all led handlers */
 void iwl3945_led_unregister(struct iwl3945_priv *priv)
 {
-	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_ASSOC], 0);
-	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_RX], 0);
-	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_TX], 0);
-	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_RADIO], 1);
+	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_ASSOC], 0);
+	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_RX], 0);
+	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_TX], 0);
+	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_RADIO], 1);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 295bd26..7d3fb4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -894,7 +894,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 
 	rcu_read_lock();
 
-	sta = ieee80211_find_sta(hw, priv->stations[sta_id].sta.sta.addr);
+	sta = ieee80211_find_sta(hw, priv->stations_39[sta_id].sta.sta.addr);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
@@ -909,7 +909,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	switch (priv->band) {
 	case IEEE80211_BAND_2GHZ:
 		/* TODO: this always does G, not a regression */
-		if (priv->active_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
+		if (priv->active39_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
 			rs_sta->tgg = 1;
 			rs_sta->expected_tpt = iwl3945_expected_tpt_g_prot;
 		} else
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8333ee4..be682cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -199,7 +199,7 @@ static int iwl3945_hwrate_to_plcp_idx(u8 plcp)
  * iwl3945_get_antenna_flags - Get antenna flags for RXON command
  * @priv: eeprom and antenna fields are used to determine antenna flags
  *
- * priv->eeprom  is used to determine if antenna AUX/MAIN are reversed
+ * priv->eeprom39  is used to determine if antenna AUX/MAIN are reversed
  * priv->antenna specifies the antenna diversity mode:
  *
  * IWL_ANTENNA_DIVERSITY - NIC selects best antenna by itself
@@ -213,12 +213,12 @@ __le32 iwl3945_get_antenna_flags(const struct iwl3945_priv *priv)
 		return 0;
 
 	case IWL_ANTENNA_MAIN:
-		if (priv->eeprom.antenna_switch_type)
+		if (priv->eeprom39.antenna_switch_type)
 			return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_B_MSK;
 		return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_A_MSK;
 
 	case IWL_ANTENNA_AUX:
-		if (priv->eeprom.antenna_switch_type)
+		if (priv->eeprom39.antenna_switch_type)
 			return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_A_MSK;
 		return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_B_MSK;
 	}
@@ -305,7 +305,7 @@ int iwl3945_rs_next_rate(struct iwl3945_priv *priv, int rate)
 static void iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv,
 				     int txq_id, int index)
 {
-	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
 	struct iwl_queue *q = &txq->q;
 	struct iwl3945_tx_info *tx_info;
 
@@ -336,7 +336,7 @@ static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
-	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
 	struct ieee80211_tx_info *info;
 	struct iwl3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
@@ -396,7 +396,7 @@ void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl_rx_mem_buffe
 		     (int)sizeof(struct iwl3945_notif_statistics),
 		     le32_to_cpu(pkt->len));
 
-	memcpy(&priv->statistics, pkt->u.raw, sizeof(priv->statistics));
+	memcpy(&priv->statistics_39, pkt->u.raw, sizeof(priv->statistics_39));
 
 	iwl3945_led_background(priv);
 
@@ -809,9 +809,9 @@ u8 iwl3945_hw_find_station(struct iwl3945_priv *priv, const u8 *addr)
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	for (i = start; i < priv->hw_params.max_stations; i++)
-		if ((priv->stations[i].used) &&
+		if ((priv->stations_39[i].used) &&
 		    (!compare_ether_addr
-		     (priv->stations[i].sta.sta.addr, addr))) {
+		     (priv->stations_39[i].sta.sta.addr, addr))) {
 			ret = i;
 			goto out;
 		}
@@ -906,7 +906,7 @@ u8 iwl3945_sync_sta(struct iwl3945_priv *priv, int sta_id, u16 tx_rate, u8 flags
 		return IWL_INVALID_STATION;
 
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
-	station = &priv->stations[sta_id];
+	station = &priv->stations_39[sta_id];
 
 	station->sta.sta.modify_mask = STA_MODIFY_TX_RATE_MSK;
 	station->sta.rate_n_flags = cpu_to_le16(tx_rate);
@@ -1063,7 +1063,7 @@ static int iwl3945_txq_ctx_reset(struct iwl3945_priv *priv)
 	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 				TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		rc = iwl3945_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
+		rc = iwl3945_tx_queue_init(priv, &priv->txq39[txq_id], slots_num,
 				txq_id);
 		if (rc) {
 			IWL_ERROR("Tx %d queue init failed\n", txq_id);
@@ -1136,42 +1136,42 @@ int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
 			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MM);
 	}
 
-	if (EEPROM_SKU_CAP_OP_MODE_MRC == priv->eeprom.sku_cap) {
+	if (EEPROM_SKU_CAP_OP_MODE_MRC == priv->eeprom39.sku_cap) {
 		IWL_DEBUG_INFO("SKU OP mode is mrc\n");
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_SKU_MRC);
 	} else
 		IWL_DEBUG_INFO("SKU OP mode is basic\n");
 
-	if ((priv->eeprom.board_revision & 0xF0) == 0xD0) {
+	if ((priv->eeprom39.board_revision & 0xF0) == 0xD0) {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
-			       priv->eeprom.board_revision);
+			       priv->eeprom39.board_revision);
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	} else {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
-			       priv->eeprom.board_revision);
+			       priv->eeprom39.board_revision);
 		iwl3945_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
 			      CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	}
 
-	if (priv->eeprom.almgor_m_version <= 1) {
+	if (priv->eeprom39.almgor_m_version <= 1) {
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A);
 		IWL_DEBUG_INFO("Card M type A version is 0x%X\n",
-			       priv->eeprom.almgor_m_version);
+			       priv->eeprom39.almgor_m_version);
 	} else {
 		IWL_DEBUG_INFO("Card M type B version is 0x%X\n",
-			       priv->eeprom.almgor_m_version);
+			       priv->eeprom39.almgor_m_version);
 		iwl3945_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (priv->eeprom.sku_cap & EEPROM_SKU_CAP_SW_RF_KILL_ENABLE)
+	if (priv->eeprom39.sku_cap & EEPROM_SKU_CAP_SW_RF_KILL_ENABLE)
 		IWL_DEBUG_RF_KILL("SW RF KILL supported in EEPROM.\n");
 
-	if (priv->eeprom.sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
+	if (priv->eeprom39.sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
 		IWL_DEBUG_RF_KILL("HW RF KILL supported in EEPROM.\n");
 
 	/* Allocate the RX queue, or reset if it is already allocated */
@@ -1225,7 +1225,7 @@ void iwl3945_hw_txq_ctx_free(struct iwl3945_priv *priv)
 
 	/* Tx queues */
 	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++)
-		iwl3945_tx_queue_free(priv, &priv->txq[txq_id]);
+		iwl3945_tx_queue_free(priv, &priv->txq39[txq_id]);
 }
 
 void iwl3945_hw_txq_ctx_stop(struct iwl3945_priv *priv)
@@ -1383,7 +1383,7 @@ static int iwl3945_hw_reg_txpower_get_temperature(struct iwl3945_priv *priv)
 		/* if really really hot(?),
 		 *   substitute the 3rd band/group's temp measured at factory */
 		if (priv->last_temperature > 100)
-			temperature = priv->eeprom.groups[2].temperature;
+			temperature = priv->eeprom39.groups[2].temperature;
 		else /* else use most recent "sane" value from driver */
 			temperature = priv->last_temperature;
 	}
@@ -1678,17 +1678,17 @@ int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv)
 	int rate_idx, i;
 	const struct iwl_channel_info *ch_info = NULL;
 	struct iwl3945_txpowertable_cmd txpower = {
-		.channel = priv->active_rxon.channel,
+		.channel = priv->active39_rxon.channel,
 	};
 
 	txpower.band = (priv->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
 	ch_info = iwl3945_get_channel_info(priv,
 				       priv->band,
-				       le16_to_cpu(priv->active_rxon.channel));
+				       le16_to_cpu(priv->active39_rxon.channel));
 	if (!ch_info) {
 		IWL_ERROR
 		    ("Failed to get channel info for channel %d [%d]\n",
-		     le16_to_cpu(priv->active_rxon.channel), priv->band);
+		     le16_to_cpu(priv->active39_rxon.channel), priv->band);
 		return -EINVAL;
 	}
 
@@ -1758,7 +1758,7 @@ static int iwl3945_hw_reg_set_new_power(struct iwl3945_priv *priv,
 	int power;
 
 	/* Get this chnlgrp's rate-to-max/clip-powers table */
-	clip_pwrs = priv->clip_groups[ch_info->group_index].clip_powers;
+	clip_pwrs = priv->clip39_groups[ch_info->group_index].clip_powers;
 
 	/* Get this channel's rate-to-current-power settings table */
 	power_info = ch_info->power_info;
@@ -1857,7 +1857,7 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl3945_priv *priv)
 		a_band = is_channel_a_band(ch_info);
 
 		/* Get this chnlgrp's factory calibration temperature */
-		ref_temp = (s16)priv->eeprom.groups[ch_info->group_index].
+		ref_temp = (s16)priv->eeprom39.groups[ch_info->group_index].
 		    temperature;
 
 		/* get power index adjustment based on current and factory
@@ -1883,7 +1883,7 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl3945_priv *priv)
 		}
 
 		/* Get this chnlgrp's rate-to-max/clip-powers table */
-		clip_pwrs = priv->clip_groups[ch_info->group_index].clip_powers;
+		clip_pwrs = priv->clip39_groups[ch_info->group_index].clip_powers;
 
 		/* set scan tx power, 1Mbit for CCK, 6Mbit for OFDM */
 		for (scan_tbl_index = 0;
@@ -2002,7 +2002,7 @@ static void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
 static u16 iwl3945_hw_reg_get_ch_grp_index(struct iwl3945_priv *priv,
 				       const struct iwl_channel_info *ch_info)
 {
-	struct iwl3945_eeprom_txpower_group *ch_grp = &priv->eeprom.groups[0];
+	struct iwl3945_eeprom_txpower_group *ch_grp = &priv->eeprom39.groups[0];
 	u8 group;
 	u16 group_index = 0;	/* based on factory calib frequencies */
 	u8 grp_channel;
@@ -2046,7 +2046,7 @@ static int iwl3945_hw_reg_get_matched_power_index(struct iwl3945_priv *priv,
 	s32 res;
 	s32 denominator;
 
-	chnl_grp = &priv->eeprom.groups[setting_index];
+	chnl_grp = &priv->eeprom39.groups[setting_index];
 	samples = chnl_grp->samples;
 	for (i = 0; i < 5; i++) {
 		if (power == samples[i].power) {
@@ -2092,7 +2092,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl3945_priv *priv)
 	for (i = 0; i < IWL_NUM_TX_CALIB_GROUPS; i++) {
 		s8 *clip_pwrs;	/* table of power levels for each rate */
 		s8 satur_pwr;	/* saturation power for each chnl group */
-		group = &priv->eeprom.groups[i];
+		group = &priv->eeprom39.groups[i];
 
 		/* sanity check on factory saturation power value */
 		if (group->saturation_power < 40) {
@@ -2111,7 +2111,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl3945_priv *priv)
 		 *   power peaks, without too much distortion (clipping).
 		 */
 		/* we'll fill in this array with h/w max power levels */
-		clip_pwrs = (s8 *) priv->clip_groups[i].clip_powers;
+		clip_pwrs = (s8 *) priv->clip39_groups[i].clip_powers;
 
 		/* divide factory saturation power by 2 to find -3dB level */
 		satur_pwr = (s8) (group->saturation_power >> 1);
@@ -2194,12 +2194,12 @@ int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv)
 			iwl3945_hw_reg_get_ch_grp_index(priv, ch_info);
 
 		/* Get this chnlgrp's rate->max/clip-powers table */
-		clip_pwrs = priv->clip_groups[ch_info->group_index].clip_powers;
+		clip_pwrs = priv->clip39_groups[ch_info->group_index].clip_powers;
 
 		/* calculate power index *adjustment* value according to
 		 *  diff between current temperature and factory temperature */
 		delta_index = iwl3945_hw_reg_adjust_power_by_temp(temperature,
-				priv->eeprom.groups[ch_info->group_index].
+				priv->eeprom39.groups[ch_info->group_index].
 				temperature);
 
 		IWL_DEBUG_POWER("Delta index for channel %d: %d [%d]\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index cfceee1..788cd9c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -422,7 +422,7 @@ struct iwl3945_priv {
 
 	/* each calibration channel group in the EEPROM has a derived
 	 * clip setting for each rate. */
-	const struct iwl3945_clip_group clip_groups[5];
+	const struct iwl3945_clip_group clip39_groups[5];
 
 	/* thermal calibration */
 	s32 temperature;	/* degrees Kelvin */
@@ -438,7 +438,7 @@ struct iwl3945_priv {
 	int one_direct_scan;
 	u8 direct_ssid_len;
 	u8 direct_ssid[IW_ESSID_MAX_SIZE];
-	struct iwl3945_scan_cmd *scan;
+	struct iwl3945_scan_cmd *scan39;
 
 	/* spinlock */
 	spinlock_t lock;	/* protect general shared data */
@@ -468,11 +468,11 @@ struct iwl3945_priv {
 	 * changed via explicit cast within the
 	 * routines that actually update the physical
 	 * hardware */
-	const struct iwl3945_rxon_cmd active_rxon;
-	struct iwl3945_rxon_cmd staging_rxon;
+	const struct iwl3945_rxon_cmd active39_rxon;
+	struct iwl3945_rxon_cmd staging39_rxon;
 
 	int error_recovering;
-	struct iwl3945_rxon_cmd recovery_rxon;
+	struct iwl3945_rxon_cmd recovery39_rxon;
 
 	/* 1st responses from initialize and runtime uCode images.
 	 * 4965's initialize alive response contains some calibration data. */
@@ -485,7 +485,7 @@ struct iwl3945_priv {
 #endif
 
 #ifdef CONFIG_IWL3945_LEDS
-	struct iwl3945_led led[IWL_LED_TRG_MAX];
+	struct iwl3945_led led39[IWL_LED_TRG_MAX];
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
 	u8 allow_blinking;
@@ -510,16 +510,16 @@ struct iwl3945_priv {
 
 	/* Rx and Tx DMA processing queues */
 	struct iwl_rx_queue rxq;
-	struct iwl3945_tx_queue txq[IWL39_MAX_NUM_QUEUES];
+	struct iwl3945_tx_queue txq39[IWL39_MAX_NUM_QUEUES];
 
 	unsigned long status;
 
 	int last_rx_rssi;	/* From Rx packet statisitics */
 	int last_rx_noise;	/* From beacon statistics */
 
-	struct iwl3945_power_mgr power_data;
+	struct iwl3945_power_mgr power_data_39;
 
-	struct iwl3945_notif_statistics statistics;
+	struct iwl3945_notif_statistics statistics_39;
 	unsigned long last_statistics_time;
 
 	/* context information */
@@ -534,7 +534,7 @@ struct iwl3945_priv {
 	/*station table variables */
 	spinlock_t sta_lock;
 	int num_stations;
-	struct iwl3945_station_entry stations[IWL_STATION_COUNT];
+	struct iwl3945_station_entry stations_39[IWL_STATION_COUNT];
 
 	/* Indication if ieee80211_ops->open has been called */
 	u8 is_open;
@@ -546,7 +546,7 @@ struct iwl3945_priv {
 	u64 last_tsf;
 
 	/* eeprom */
-	struct iwl3945_eeprom eeprom;
+	struct iwl3945_eeprom eeprom39;
 
 	enum nl80211_iftype iw_mode;
 
@@ -607,7 +607,7 @@ struct iwl3945_priv {
 
 static inline int iwl3945_is_associated(struct iwl3945_priv *priv)
 {
-	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+	return (priv->active39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
 
 extern const struct iwl_channel_info *iwl3945_get_channel_info(
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 751cd3d..00c22f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -329,8 +329,8 @@ static u8 iwl3945_remove_station(struct iwl3945_priv *priv, const u8 *addr, int
 		index = priv->hw_params.bcast_sta_id;
 	else
 		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++)
-			if (priv->stations[i].used &&
-			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
+			if (priv->stations_39[i].used &&
+			    !compare_ether_addr(priv->stations_39[i].sta.sta.addr,
 						addr)) {
 				index = i;
 				break;
@@ -339,8 +339,8 @@ static u8 iwl3945_remove_station(struct iwl3945_priv *priv, const u8 *addr, int
 	if (unlikely(index == IWL_INVALID_STATION))
 		goto out;
 
-	if (priv->stations[index].used) {
-		priv->stations[index].used = 0;
+	if (priv->stations_39[index].used) {
+		priv->stations_39[index].used = 0;
 		priv->num_stations--;
 	}
 
@@ -364,7 +364,7 @@ static void iwl3945_clear_stations_table(struct iwl3945_priv *priv)
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	priv->num_stations = 0;
-	memset(priv->stations, 0, sizeof(priv->stations));
+	memset(priv->stations_39, 0, sizeof(priv->stations_39));
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
@@ -388,13 +388,13 @@ u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8
 		index = priv->hw_params.bcast_sta_id;
 	else
 		for (i = IWL_STA_ID; i < priv->hw_params.max_stations; i++) {
-			if (!compare_ether_addr(priv->stations[i].sta.sta.addr,
+			if (!compare_ether_addr(priv->stations_39[i].sta.sta.addr,
 						addr)) {
 				index = i;
 				break;
 			}
 
-			if (!priv->stations[i].used &&
+			if (!priv->stations_39[i].used &&
 			    index == IWL_INVALID_STATION)
 				index = i;
 		}
@@ -406,14 +406,14 @@ u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8
 		return index;
 	}
 
-	if (priv->stations[index].used &&
-	   !compare_ether_addr(priv->stations[index].sta.sta.addr, addr)) {
+	if (priv->stations_39[index].used &&
+	   !compare_ether_addr(priv->stations_39[index].sta.sta.addr, addr)) {
 		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 		return index;
 	}
 
 	IWL_DEBUG_ASSOC("Add STA ID %d: %s\n", index, print_mac(mac, addr));
-	station = &priv->stations[index];
+	station = &priv->stations_39[index];
 	station->used = 1;
 	priv->num_stations++;
 
@@ -503,7 +503,7 @@ static inline int iwl3945_is_ready_rf(struct iwl3945_priv *priv)
  */
 static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
 {
-	struct iwl3945_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
+	struct iwl3945_tx_queue *txq = &priv->txq39[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
 	struct iwl3945_tfd_frame *tfd;
 	u32 *control_flags;
@@ -679,7 +679,7 @@ cancel:
 		 * TX cmd queue. Otherwise in case the cmd comes
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source). */
-		qcmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
+		qcmd = &priv->txq39[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
 		qcmd->meta.flags &= ~CMD_WANT_SKB;
 	}
 fail:
@@ -747,15 +747,15 @@ static int iwl3945_set_rxon_channel(struct iwl3945_priv *priv,
 		return -EINVAL;
 	}
 
-	if ((le16_to_cpu(priv->staging_rxon.channel) == channel) &&
+	if ((le16_to_cpu(priv->staging39_rxon.channel) == channel) &&
 	    (priv->band == band))
 		return 0;
 
-	priv->staging_rxon.channel = cpu_to_le16(channel);
+	priv->staging39_rxon.channel = cpu_to_le16(channel);
 	if (band == IEEE80211_BAND_5GHZ)
-		priv->staging_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
+		priv->staging39_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
 	else
-		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
+		priv->staging39_rxon.flags |= RXON_FLG_BAND_24G_MSK;
 
 	priv->band = band;
 
@@ -775,7 +775,7 @@ static int iwl3945_check_rxon_cmd(struct iwl3945_priv *priv)
 {
 	int error = 0;
 	int counter = 1;
-	struct iwl3945_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl3945_rxon_cmd *rxon = &priv->staging39_rxon;
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
 		error |= le32_to_cpu(rxon->flags &
@@ -857,17 +857,17 @@ static int iwl3945_full_rxon_required(struct iwl3945_priv *priv)
 
 	/* These items are only settable from the full RXON command */
 	if (!(iwl3945_is_associated(priv)) ||
-	    compare_ether_addr(priv->staging_rxon.bssid_addr,
-			       priv->active_rxon.bssid_addr) ||
-	    compare_ether_addr(priv->staging_rxon.node_addr,
-			       priv->active_rxon.node_addr) ||
-	    compare_ether_addr(priv->staging_rxon.wlap_bssid_addr,
-			       priv->active_rxon.wlap_bssid_addr) ||
-	    (priv->staging_rxon.dev_type != priv->active_rxon.dev_type) ||
-	    (priv->staging_rxon.channel != priv->active_rxon.channel) ||
-	    (priv->staging_rxon.air_propagation !=
-	     priv->active_rxon.air_propagation) ||
-	    (priv->staging_rxon.assoc_id != priv->active_rxon.assoc_id))
+	    compare_ether_addr(priv->staging39_rxon.bssid_addr,
+			       priv->active39_rxon.bssid_addr) ||
+	    compare_ether_addr(priv->staging39_rxon.node_addr,
+			       priv->active39_rxon.node_addr) ||
+	    compare_ether_addr(priv->staging39_rxon.wlap_bssid_addr,
+			       priv->active39_rxon.wlap_bssid_addr) ||
+	    (priv->staging39_rxon.dev_type != priv->active39_rxon.dev_type) ||
+	    (priv->staging39_rxon.channel != priv->active39_rxon.channel) ||
+	    (priv->staging39_rxon.air_propagation !=
+	     priv->active39_rxon.air_propagation) ||
+	    (priv->staging39_rxon.assoc_id != priv->active39_rxon.assoc_id))
 		return 1;
 
 	/* flags, filter_flags, ofdm_basic_rates, and cck_basic_rates can
@@ -875,13 +875,13 @@ static int iwl3945_full_rxon_required(struct iwl3945_priv *priv)
 	 * flag transitions are allowed using RXON_ASSOC */
 
 	/* Check if we are not switching bands */
-	if ((priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) !=
-	    (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK))
+	if ((priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK) !=
+	    (priv->active39_rxon.flags & RXON_FLG_BAND_24G_MSK))
 		return 1;
 
 	/* Check if we are switching association toggle */
-	if ((priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) !=
-		(priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK))
+	if ((priv->staging39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) !=
+		(priv->active39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK))
 		return 1;
 
 	return 0;
@@ -898,8 +898,8 @@ static int iwl3945_send_rxon_assoc(struct iwl3945_priv *priv)
 		.meta.flags = CMD_WANT_SKB,
 		.data = &rxon_assoc,
 	};
-	const struct iwl3945_rxon_cmd *rxon1 = &priv->staging_rxon;
-	const struct iwl3945_rxon_cmd *rxon2 = &priv->active_rxon;
+	const struct iwl3945_rxon_cmd *rxon1 = &priv->staging39_rxon;
+	const struct iwl3945_rxon_cmd *rxon2 = &priv->active39_rxon;
 
 	if ((rxon1->flags == rxon2->flags) &&
 	    (rxon1->filter_flags == rxon2->filter_flags) &&
@@ -909,10 +909,10 @@ static int iwl3945_send_rxon_assoc(struct iwl3945_priv *priv)
 		return 0;
 	}
 
-	rxon_assoc.flags = priv->staging_rxon.flags;
-	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
-	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
+	rxon_assoc.flags = priv->staging39_rxon.flags;
+	rxon_assoc.filter_flags = priv->staging39_rxon.filter_flags;
+	rxon_assoc.ofdm_basic_rates = priv->staging39_rxon.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = priv->staging39_rxon.cck_basic_rates;
 	rxon_assoc.reserved = 0;
 
 	rc = iwl3945_send_cmd_sync(priv, &cmd);
@@ -942,7 +942,7 @@ static int iwl3945_send_rxon_assoc(struct iwl3945_priv *priv)
 static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 {
 	/* cast away the const for active_rxon in this function */
-	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active_rxon;
+	struct iwl3945_rxon_cmd *active_rxon = (void *)&priv->active39_rxon;
 	int rc = 0;
 	DECLARE_MAC_BUF(mac);
 
@@ -950,12 +950,12 @@ static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 		return -1;
 
 	/* always get timestamp with Rx frame */
-	priv->staging_rxon.flags |= RXON_FLG_TSF2HOST_MSK;
+	priv->staging39_rxon.flags |= RXON_FLG_TSF2HOST_MSK;
 
 	/* select antenna */
-	priv->staging_rxon.flags &=
+	priv->staging39_rxon.flags &=
 	    ~(RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_SEL_MSK);
-	priv->staging_rxon.flags |= iwl3945_get_antenna_flags(priv);
+	priv->staging39_rxon.flags |= iwl3945_get_antenna_flags(priv);
 
 	rc = iwl3945_check_rxon_cmd(priv);
 	if (rc) {
@@ -974,7 +974,7 @@ static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 			return rc;
 		}
 
-		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
+		memcpy(active_rxon, &priv->staging39_rxon, sizeof(*active_rxon));
 
 		return 0;
 	}
@@ -984,13 +984,13 @@ static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 	 * we must clear the associated from the active configuration
 	 * before we apply the new config */
 	if (iwl3945_is_associated(priv) &&
-	    (priv->staging_rxon.filter_flags & RXON_FILTER_ASSOC_MSK)) {
+	    (priv->staging39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK)) {
 		IWL_DEBUG_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
 		rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON,
 				      sizeof(struct iwl3945_rxon_cmd),
-				      &priv->active_rxon);
+				      &priv->active39_rxon);
 
 		/* If the mask clearing failed then we set
 		 * active_rxon back to what it was previously */
@@ -1006,20 +1006,20 @@ static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 		       "* with%s RXON_FILTER_ASSOC_MSK\n"
 		       "* channel = %d\n"
 		       "* bssid = %s\n",
-		       ((priv->staging_rxon.filter_flags &
+		       ((priv->staging39_rxon.filter_flags &
 			 RXON_FILTER_ASSOC_MSK) ? "" : "out"),
-		       le16_to_cpu(priv->staging_rxon.channel),
-		       print_mac(mac, priv->staging_rxon.bssid_addr));
+		       le16_to_cpu(priv->staging39_rxon.channel),
+		       print_mac(mac, priv->staging39_rxon.bssid_addr));
 
 	/* Apply the new configuration */
 	rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON,
-			      sizeof(struct iwl3945_rxon_cmd), &priv->staging_rxon);
+			      sizeof(struct iwl3945_rxon_cmd), &priv->staging39_rxon);
 	if (rc) {
 		IWL_ERROR("Error setting new configuration (%d).\n", rc);
 		return rc;
 	}
 
-	memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
+	memcpy(active_rxon, &priv->staging39_rxon, sizeof(*active_rxon));
 
 	iwl3945_clear_stations_table(priv);
 
@@ -1042,7 +1042,7 @@ static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 	 * add the IWL_AP_ID to the station rate table */
 	if (iwl3945_is_associated(priv) &&
 	    (priv->iw_mode == NL80211_IFTYPE_STATION))
-		if (iwl3945_add_station(priv, priv->active_rxon.bssid_addr, 1, 0)
+		if (iwl3945_add_station(priv, priv->active39_rxon.bssid_addr, 1, 0)
 		    == IWL_INVALID_STATION) {
 			IWL_ERROR("Error adding AP address for transmit.\n");
 			return -EIO;
@@ -1240,21 +1240,21 @@ static int iwl3945_update_sta_key_info(struct iwl3945_priv *priv,
 		return -EINVAL;
 	}
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
-	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
-	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
+	priv->stations_39[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations_39[sta_id].keyinfo.keylen = keyconf->keylen;
+	memcpy(priv->stations_39[sta_id].keyinfo.key, keyconf->key,
 	       keyconf->keylen);
 
-	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
+	memcpy(priv->stations_39[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	priv->stations_39[sta_id].sta.key.key_flags = key_flags;
+	priv->stations_39[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations_39[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-	iwl3945_send_add_station(priv, &priv->stations[sta_id].sta, 0);
+	iwl3945_send_add_station(priv, &priv->stations_39[sta_id].sta, 0);
 	return 0;
 }
 
@@ -1263,16 +1263,16 @@ static int iwl3945_clear_sta_key_info(struct iwl3945_priv *priv, u8 sta_id)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	memset(&priv->stations[sta_id].keyinfo, 0, sizeof(struct iwl3945_hw_key));
-	memset(&priv->stations[sta_id].sta.key, 0,
+	memset(&priv->stations_39[sta_id].keyinfo, 0, sizeof(struct iwl3945_hw_key));
+	memset(&priv->stations_39[sta_id].sta.key, 0,
 		sizeof(struct iwl4965_keyinfo));
-	priv->stations[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	priv->stations_39[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
+	priv->stations_39[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations_39[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
-	iwl3945_send_add_station(priv, &priv->stations[sta_id].sta, 0);
+	iwl3945_send_add_station(priv, &priv->stations_39[sta_id].sta, 0);
 	return 0;
 }
 
@@ -1347,7 +1347,7 @@ static u8 iwl3945_rate_get_lowest_plcp(struct iwl3945_priv *priv)
 	int rate_mask;
 
 	/* Set rate mask*/
-	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
+	if (priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK)
 		rate_mask = priv->active_rate_basic & IWL_CCK_RATES_MASK;
 	else
 		rate_mask = priv->active_rate_basic & IWL_OFDM_RATES_MASK;
@@ -1359,7 +1359,7 @@ static u8 iwl3945_rate_get_lowest_plcp(struct iwl3945_priv *priv)
 	}
 
 	/* No valid rate was found. Assign the lowest one */
-	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)
+	if (priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK)
 		return IWL_RATE_1M_PLCP;
 	else
 		return IWL_RATE_6M_PLCP;
@@ -1400,7 +1400,7 @@ static int iwl3945_send_beacon_cmd(struct iwl3945_priv *priv)
 
 static void get_eeprom_mac(struct iwl3945_priv *priv, u8 *mac)
 {
-	memcpy(mac, priv->eeprom.mac_address, 6);
+	memcpy(mac, priv->eeprom39.mac_address, 6);
 }
 
 /*
@@ -1420,15 +1420,15 @@ static inline int iwl3945_eeprom_acquire_semaphore(struct iwl3945_priv *priv)
 /**
  * iwl3945_eeprom_init - read EEPROM contents
  *
- * Load the EEPROM contents from adapter into priv->eeprom
+ * Load the EEPROM contents from adapter into priv->eeprom39
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
 int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 {
-	u16 *e = (u16 *)&priv->eeprom;
+	u16 *e = (u16 *)&priv->eeprom39;
 	u32 gp = iwl3945_read32(priv, CSR_EEPROM_GP);
-	int sz = sizeof(priv->eeprom);
+	int sz = sizeof(priv->eeprom39);
 	int ret;
 	u16 addr;
 
@@ -1436,7 +1436,7 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 	 * and when adding new EEPROM maps is subject to programmer errors
 	 * which may be very difficult to identify without explicitly
 	 * checking the resulting size of the eeprom map. */
-	BUILD_BUG_ON(sizeof(priv->eeprom) != IWL_EEPROM_IMAGE_SIZE);
+	BUILD_BUG_ON(sizeof(priv->eeprom39) != IWL_EEPROM_IMAGE_SIZE);
 
 	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
 		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x\n", gp);
@@ -1627,7 +1627,7 @@ static void iwl3945_reset_qos(struct iwl3945_priv *priv)
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC &&
 	     (priv->active_rate & IWL_OFDM_RATES_MASK) == 0) ||
 	    (priv->iw_mode == NL80211_IFTYPE_STATION &&
-	     (priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK) == 0)) {
+	     (priv->staging39_rxon.flags & RXON_FLG_SHORT_SLOT_MSK) == 0)) {
 		cw_min = 31;
 		is_legacy = 1;
 	}
@@ -1771,7 +1771,7 @@ int iwl3945_power_init_handle(struct iwl3945_priv *priv)
 
 	IWL_DEBUG_POWER("Initialize power \n");
 
-	pow_data = &(priv->power_data);
+	pow_data = &(priv->power_data_39);
 
 	memset(pow_data, 0, sizeof(*pow_data));
 
@@ -1815,7 +1815,7 @@ static int iwl3945_update_power_cmd(struct iwl3945_priv *priv,
 		IWL_DEBUG_POWER("Error invalid power mode \n");
 		return -1;
 	}
-	pow_data = &(priv->power_data);
+	pow_data = &(priv->power_data_39);
 
 	if (pow_data->active_index == IWL_POWER_RANGE_0)
 		range = &pow_data->pwr_range_0[0];
@@ -2055,7 +2055,7 @@ static int iwl3945_scan_initiate(struct iwl3945_priv *priv)
 
 static int iwl3945_set_rxon_hwcrypto(struct iwl3945_priv *priv, int hw_decrypt)
 {
-	struct iwl3945_rxon_cmd *rxon = &priv->staging_rxon;
+	struct iwl3945_rxon_cmd *rxon = &priv->staging39_rxon;
 
 	if (hw_decrypt)
 		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
@@ -2069,23 +2069,23 @@ static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv,
 					  enum ieee80211_band band)
 {
 	if (band == IEEE80211_BAND_5GHZ) {
-		priv->staging_rxon.flags &=
+		priv->staging39_rxon.flags &=
 		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
 		      | RXON_FLG_CCK_MSK);
-		priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+		priv->staging39_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 	} else {
 		/* Copied from iwl3945_bg_post_associate() */
 		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+			priv->staging39_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
-		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
-		priv->staging_rxon.flags |= RXON_FLG_AUTO_DETECT_MSK;
-		priv->staging_rxon.flags &= ~RXON_FLG_CCK_MSK;
+		priv->staging39_rxon.flags |= RXON_FLG_BAND_24G_MSK;
+		priv->staging39_rxon.flags |= RXON_FLG_AUTO_DETECT_MSK;
+		priv->staging39_rxon.flags &= ~RXON_FLG_CCK_MSK;
 	}
 }
 
@@ -2097,28 +2097,28 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv,
 {
 	const struct iwl_channel_info *ch_info;
 
-	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
+	memset(&priv->staging39_rxon, 0, sizeof(priv->staging39_rxon));
 
 	switch (mode) {
 	case NL80211_IFTYPE_AP:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_AP;
+		priv->staging39_rxon.dev_type = RXON_DEV_TYPE_AP;
 		break;
 
 	case NL80211_IFTYPE_STATION:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_ESS;
-		priv->staging_rxon.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
+		priv->staging39_rxon.dev_type = RXON_DEV_TYPE_ESS;
+		priv->staging39_rxon.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
 	case NL80211_IFTYPE_ADHOC:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_IBSS;
-		priv->staging_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
-		priv->staging_rxon.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
+		priv->staging39_rxon.dev_type = RXON_DEV_TYPE_IBSS;
+		priv->staging39_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
+		priv->staging39_rxon.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
 						  RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
 	case NL80211_IFTYPE_MONITOR:
-		priv->staging_rxon.dev_type = RXON_DEV_TYPE_SNIFFER;
-		priv->staging_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
+		priv->staging39_rxon.dev_type = RXON_DEV_TYPE_SNIFFER;
+		priv->staging39_rxon.filter_flags = RXON_FILTER_PROMISC_MSK |
 		    RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 	default:
@@ -2130,13 +2130,13 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv,
 	/* TODO:  Figure out when short_preamble would be set and cache from
 	 * that */
 	if (!hw_to_local(priv->hw)->short_preamble)
-		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+		priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
-		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		priv->staging39_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
 	ch_info = iwl3945_get_channel_info(priv, priv->band,
-				       le16_to_cpu(priv->active_rxon.channel));
+				       le16_to_cpu(priv->active39_rxon.channel));
 
 	if (!ch_info)
 		ch_info = &priv->channel_info[0];
@@ -2148,7 +2148,7 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv,
 	if ((mode == NL80211_IFTYPE_ADHOC) && !(is_channel_ibss(ch_info)))
 		ch_info = &priv->channel_info[0];
 
-	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
+	priv->staging39_rxon.channel = cpu_to_le16(ch_info->channel);
 	if (is_channel_a_band(ch_info))
 		priv->band = IEEE80211_BAND_5GHZ;
 	else
@@ -2156,9 +2156,9 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv,
 
 	iwl3945_set_flags_for_phymode(priv, priv->band);
 
-	priv->staging_rxon.ofdm_basic_rates =
+	priv->staging39_rxon.ofdm_basic_rates =
 	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-	priv->staging_rxon.cck_basic_rates =
+	priv->staging39_rxon.cck_basic_rates =
 	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
 }
 
@@ -2169,17 +2169,17 @@ static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 
 		ch_info = iwl3945_get_channel_info(priv,
 			priv->band,
-			le16_to_cpu(priv->staging_rxon.channel));
+			le16_to_cpu(priv->staging39_rxon.channel));
 
 		if (!ch_info || !is_channel_ibss(ch_info)) {
 			IWL_ERROR("channel %d not IBSS channel\n",
-				  le16_to_cpu(priv->staging_rxon.channel));
+				  le16_to_cpu(priv->staging39_rxon.channel));
 			return -EINVAL;
 		}
 	}
 
 	iwl3945_connection_init_rx_config(priv, mode);
-	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
+	memcpy(priv->staging39_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
 	iwl3945_clear_stations_table(priv);
 
@@ -2206,7 +2206,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl3945_priv *priv,
 				      int last_frag)
 {
 	struct iwl3945_hw_key *keyinfo =
-	    &priv->stations[info->control.hw_key->hw_key_idx].keyinfo;
+	    &priv->stations_39[info->control.hw_key->hw_key_idx].keyinfo;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
@@ -2452,7 +2452,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-		seq_number = priv->stations[sta_id].tid[tid].seq_number &
+		seq_number = priv->stations_39[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(seq_number) |
 			(hdr->seq_ctrl &
@@ -2461,7 +2461,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	}
 
 	/* Descriptor for chosen Tx queue */
-	txq = &priv->txq[txq_id];
+	txq = &priv->txq39[txq_id];
 	q = &txq->q;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -2560,7 +2560,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
 		if (qc)
-			priv->stations[sta_id].tid[tid].seq_number = seq_number;
+			priv->stations_39[sta_id].tid[tid].seq_number = seq_number;
 	} else {
 		wait_write_ptr = 1;
 		txq->need_update = 0;
@@ -2637,20 +2637,20 @@ static void iwl3945_set_rate(struct iwl3945_priv *priv)
 	 * OFDM
 	 */
 	if (priv->active_rate_basic & IWL_CCK_BASIC_RATES_MASK)
-		priv->staging_rxon.cck_basic_rates =
+		priv->staging39_rxon.cck_basic_rates =
 		    ((priv->active_rate_basic &
 		      IWL_CCK_RATES_MASK) >> IWL_FIRST_CCK_RATE) & 0xF;
 	else
-		priv->staging_rxon.cck_basic_rates =
+		priv->staging39_rxon.cck_basic_rates =
 		    (IWL_CCK_BASIC_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
 
 	if (priv->active_rate_basic & IWL_OFDM_BASIC_RATES_MASK)
-		priv->staging_rxon.ofdm_basic_rates =
+		priv->staging39_rxon.ofdm_basic_rates =
 		    ((priv->active_rate_basic &
 		      (IWL_OFDM_BASIC_RATES_MASK | IWL_RATE_6M_MASK)) >>
 		      IWL_FIRST_OFDM_RATE) & 0xFF;
 	else
-		priv->staging_rxon.ofdm_basic_rates =
+		priv->staging39_rxon.ofdm_basic_rates =
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
@@ -2710,7 +2710,7 @@ void iwl3945_set_decrypted_flag(struct iwl3945_priv *priv, struct sk_buff *skb,
 	u16 fc =
 	    le16_to_cpu(((struct ieee80211_hdr *)skb->data)->frame_control);
 
-	if (priv->active_rxon.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
+	if (priv->active39_rxon.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
 		return;
 
 	if (!(fc & IEEE80211_FCTL_PROTECTED))
@@ -2831,7 +2831,7 @@ static int iwl3945_get_measurement(struct iwl3945_priv *priv,
 	spectrum.channels[0].duration = cpu_to_le32(duration * TIME_UNIT);
 	spectrum.channels[0].channel = params->channel;
 	spectrum.channels[0].type = type;
-	if (priv->active_rxon.flags & RXON_FLG_BAND_24G_MSK)
+	if (priv->active39_rxon.flags & RXON_FLG_BAND_24G_MSK)
 		spectrum.flags |= RXON_FLG_BAND_24G_MSK |
 		    RXON_FLG_AUTO_DETECT_MSK | RXON_FLG_TGG_PROTECT_MSK;
 
@@ -2932,12 +2932,12 @@ static void iwl3945_rx_reply_error(struct iwl3945_priv *priv,
 static void iwl3945_rx_csa(struct iwl3945_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl3945_rxon_cmd *rxon = (void *)&priv->active_rxon;
+	struct iwl3945_rxon_cmd *rxon = (void *)&priv->active39_rxon;
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
 	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
 		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
 	rxon->channel = csa->channel;
-	priv->staging_rxon.channel = csa->channel;
+	priv->staging39_rxon.channel = csa->channel;
 }
 
 static void iwl3945_rx_spectrum_measure_notif(struct iwl3945_priv *priv,
@@ -3232,7 +3232,7 @@ static void iwl3945_setup_rx_handlers(struct iwl3945_priv *priv)
 static void iwl3945_cmd_queue_reclaim(struct iwl3945_priv *priv,
 				      int txq_id, int index)
 {
-	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
 	struct iwl_queue *q = &txq->q;
 	int nfreed = 0;
 
@@ -3277,8 +3277,8 @@ static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
 
 	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
 
-	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
-	cmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
+	cmd_index = get_cmd_index(&priv->txq39[IWL_CMD_QUEUE_NUM].q, index, huge);
+	cmd = &priv->txq39[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
 
 	/* Input error checking is done when commands are added to queue. */
 	if (cmd->meta.flags & CMD_WANT_SKB) {
@@ -4123,7 +4123,7 @@ static void iwl3945_irq_handle_error(struct iwl3945_priv *priv)
 	if (priv->debug_level & IWL_DL_FW_ERRORS) {
 		iwl3945_dump_nic_error_log(priv);
 		iwl3945_dump_nic_event_log(priv);
-		iwl3945_print_rx_config_cmd(priv, &priv->staging_rxon);
+		iwl3945_print_rx_config_cmd(priv, &priv->staging39_rxon);
 	}
 #endif
 
@@ -4138,8 +4138,8 @@ static void iwl3945_irq_handle_error(struct iwl3945_priv *priv)
 			  "Restarting adapter due to uCode error.\n");
 
 		if (iwl3945_is_associated(priv)) {
-			memcpy(&priv->recovery_rxon, &priv->active_rxon,
-			       sizeof(priv->recovery_rxon));
+			memcpy(&priv->recovery39_rxon, &priv->active39_rxon,
+			       sizeof(priv->recovery39_rxon));
 			priv->error_recovering = 1;
 		}
 		queue_work(priv->workqueue, &priv->restart);
@@ -4150,15 +4150,15 @@ static void iwl3945_error_recovery(struct iwl3945_priv *priv)
 {
 	unsigned long flags;
 
-	memcpy(&priv->staging_rxon, &priv->recovery_rxon,
-	       sizeof(priv->staging_rxon));
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	memcpy(&priv->staging39_rxon, &priv->recovery39_rxon,
+	       sizeof(priv->staging39_rxon));
+	priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwl3945_commit_rxon(priv);
 
 	iwl3945_add_station(priv, priv->bssid, 1, 0);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->assoc_id = le16_to_cpu(priv->staging_rxon.assoc_id);
+	priv->assoc_id = le16_to_cpu(priv->staging39_rxon.assoc_id);
 	priv->error_recovering = 0;
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
@@ -4247,12 +4247,12 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
 		iwl3945_rx_queue_update_write_ptr(priv, &priv->rxq);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[0]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[1]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[2]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[3]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[4]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[5]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[0]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[1]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[2]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[3]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[4]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[5]);
 
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
@@ -4366,7 +4366,7 @@ unplugged:
  * EEPROM contents to the specific channel number supported for each
  * band.
  *
- * For example, iwl3945_priv->eeprom.band_3_channels[4] from the band_3
+ * For example, iwl3945_priv->eeprom39.band_3_channels[4] from the band_3
  * definition below maps to physical channel 42 in the 5.2GHz spectrum.
  * The specific geography and calibration information for that channel
  * is contained in the eeprom map itself.
@@ -4422,27 +4422,27 @@ static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int ban
 	switch (band) {
 	case 1:		/* 2.4GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_1);
-		*eeprom_ch_info = priv->eeprom.band_1_channels;
+		*eeprom_ch_info = priv->eeprom39.band_1_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_1;
 		break;
 	case 2:		/* 4.9GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_2);
-		*eeprom_ch_info = priv->eeprom.band_2_channels;
+		*eeprom_ch_info = priv->eeprom39.band_2_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_2;
 		break;
 	case 3:		/* 5.2GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_3);
-		*eeprom_ch_info = priv->eeprom.band_3_channels;
+		*eeprom_ch_info = priv->eeprom39.band_3_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_3;
 		break;
 	case 4:		/* 5.5GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_4);
-		*eeprom_ch_info = priv->eeprom.band_4_channels;
+		*eeprom_ch_info = priv->eeprom39.band_4_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_4;
 		break;
 	case 5:		/* 5.7GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_5);
-		*eeprom_ch_info = priv->eeprom.band_5_channels;
+		*eeprom_ch_info = priv->eeprom39.band_5_channels;
 		*eeprom_ch_index = iwl3945_eeprom_band_5;
 		break;
 	default:
@@ -4500,9 +4500,9 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 		return 0;
 	}
 
-	if (priv->eeprom.version < 0x2f) {
+	if (priv->eeprom39.version < 0x2f) {
 		IWL_WARNING("Unsupported EEPROM version: 0x%04X\n",
-			    priv->eeprom.version);
+			    priv->eeprom39.version);
 		return -EINVAL;
 	}
 
@@ -5636,15 +5636,15 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 
 	if (iwl3945_is_associated(priv)) {
 		struct iwl3945_rxon_cmd *active_rxon =
-				(struct iwl3945_rxon_cmd *)(&priv->active_rxon);
+				(struct iwl3945_rxon_cmd *)(&priv->active39_rxon);
 
-		memcpy(&priv->staging_rxon, &priv->active_rxon,
-		       sizeof(priv->staging_rxon));
+		memcpy(&priv->staging39_rxon, &priv->active39_rxon,
+		       sizeof(priv->staging39_rxon));
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
 		iwl3945_connection_init_rx_config(priv, priv->iw_mode);
-		memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
+		memcpy(priv->staging39_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 	}
 
 	/* Configure Bluetooth device coexistence support */
@@ -6037,15 +6037,15 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	if (!priv->scan) {
-		priv->scan = kmalloc(sizeof(struct iwl3945_scan_cmd) +
+	if (!priv->scan39) {
+		priv->scan39 = kmalloc(sizeof(struct iwl3945_scan_cmd) +
 				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
-		if (!priv->scan) {
+		if (!priv->scan39) {
 			rc = -ENOMEM;
 			goto done;
 		}
 	}
-	scan = priv->scan;
+	scan = priv->scan39;
 	memset(scan, 0, sizeof(struct iwl3945_scan_cmd) + IWL_MAX_SCAN_SIZE);
 
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
@@ -6222,7 +6222,7 @@ static void iwl3945_post_associate(struct iwl3945_priv *priv)
 
 	IWL_DEBUG_ASSOC("Associated as %d to: %s\n",
 			priv->assoc_id,
-			print_mac(mac, priv->active_rxon.bssid_addr));
+			print_mac(mac, priv->active39_rxon.bssid_addr));
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6234,7 +6234,7 @@ static void iwl3945_post_associate(struct iwl3945_priv *priv)
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
-	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwl3945_commit_rxon(priv);
 
 	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
@@ -6245,26 +6245,26 @@ static void iwl3945_post_associate(struct iwl3945_priv *priv)
 		IWL_WARNING("REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
 
-	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
+	priv->staging39_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
+	priv->staging39_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 
 	IWL_DEBUG_ASSOC("assoc id %d beacon interval %d\n",
 			priv->assoc_id, priv->beacon_int);
 
 	if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
-		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		priv->staging39_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 	else
-		priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+		priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-	if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
+	if (priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK) {
 		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_SLOT_TIME)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
+			priv->staging39_rxon.flags |= RXON_FLG_SHORT_SLOT_MSK;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
 	}
 
@@ -6371,7 +6371,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&priv->mutex);
 
-	memset(&priv->staging_rxon, 0, sizeof(struct iwl3945_rxon_cmd));
+	memset(&priv->staging39_rxon, 0, sizeof(struct iwl3945_rxon_cmd));
 	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
 	 * ucode filename and max sizes are card-specific. */
 
@@ -6589,8 +6589,8 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	iwl3945_set_rate(priv);
 
-	if (memcmp(&priv->active_rxon,
-		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
+	if (memcmp(&priv->active39_rxon,
+		   &priv->staging39_rxon, sizeof(priv->staging39_rxon)))
 		iwl3945_commit_rxon(priv);
 	else
 		IWL_DEBUG_INFO("No re-sending same RXON configuration.\n");
@@ -6614,7 +6614,7 @@ static void iwl3945_config_ap(struct iwl3945_priv *priv)
 	if (!(iwl3945_is_associated(priv))) {
 
 		/* RXON - unassoc (to set timing command) */
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 
 		/* RXON Timing */
@@ -6627,29 +6627,29 @@ static void iwl3945_config_ap(struct iwl3945_priv *priv)
 					"Attempting to continue.\n");
 
 		/* FIXME: what should be the assoc_id for AP? */
-		priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
+		priv->staging39_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
 		if (priv->assoc_capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
-			priv->staging_rxon.flags |=
+			priv->staging39_rxon.flags |=
 				RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			priv->staging_rxon.flags &=
+			priv->staging39_rxon.flags &=
 				~RXON_FLG_SHORT_PREAMBLE_MSK;
 
-		if (priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK) {
+		if (priv->staging39_rxon.flags & RXON_FLG_BAND_24G_MSK) {
 			if (priv->assoc_capability &
 				WLAN_CAPABILITY_SHORT_SLOT_TIME)
-				priv->staging_rxon.flags |=
+				priv->staging39_rxon.flags |=
 					RXON_FLG_SHORT_SLOT_MSK;
 			else
-				priv->staging_rxon.flags &=
+				priv->staging39_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 
 			if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
-				priv->staging_rxon.flags &=
+				priv->staging39_rxon.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 		}
 		/* restore RXON assoc */
-		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
+		priv->staging39_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 		iwl3945_add_station(priv, iwl_bcast_addr, 0, 0);
 	}
@@ -6732,7 +6732,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 			mutex_unlock(&priv->mutex);
 			return -EAGAIN;
 		}
-		memcpy(priv->staging_rxon.bssid_addr, conf->bssid, ETH_ALEN);
+		memcpy(priv->staging39_rxon.bssid_addr, conf->bssid, ETH_ALEN);
 
 		/* TODO: Audit driver for usage of these members and see
 		 * if mac80211 deprecates them (priv->bssid looks like it
@@ -6746,12 +6746,12 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 			rc = iwl3945_commit_rxon(priv);
 			if ((priv->iw_mode == NL80211_IFTYPE_STATION) && rc)
 				iwl3945_add_station(priv,
-					priv->active_rxon.bssid_addr, 1, 0);
+					priv->active39_rxon.bssid_addr, 1, 0);
 		}
 
 	} else {
 		iwl3945_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
 
@@ -6768,7 +6768,7 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 				 int mc_count, struct dev_addr_list *mc_list)
 {
 	struct iwl3945_priv *priv = hw->priv;
-	__le32 *filter_flags = &priv->staging_rxon.filter_flags;
+	__le32 *filter_flags = &priv->staging39_rxon.filter_flags;
 
 	IWL_DEBUG_MAC80211("Enter: changed: 0x%x, total: 0x%x\n",
 			changed_flags, *total_flags);
@@ -6819,7 +6819,7 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 
 	if (iwl3945_is_ready_rf(priv)) {
 		iwl3945_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
 	if (priv->vif == conf->vif) {
@@ -6846,17 +6846,17 @@ static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
 		IWL_DEBUG_MAC80211("ERP_PREAMBLE %d\n",
 				   bss_conf->use_short_preamble);
 		if (bss_conf->use_short_preamble)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+			priv->staging39_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+			priv->staging39_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 	}
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
 		IWL_DEBUG_MAC80211("ERP_CTS %d\n", bss_conf->use_cts_prot);
 		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
-			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
+			priv->staging39_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
-			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+			priv->staging39_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 	}
 
 	if (changes & BSS_CHANGED_ASSOC) {
@@ -7065,7 +7065,7 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&priv->lock, flags);
 
 	for (i = 0; i < AC_NUM; i++) {
-		txq = &priv->txq[i];
+		txq = &priv->txq39[i];
 		q = &txq->q;
 		avail = iwl_queue_space(q);
 
@@ -7120,7 +7120,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	*/
 	if (priv->iw_mode != NL80211_IFTYPE_AP) {
 		iwl3945_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
 
@@ -7267,7 +7267,7 @@ static ssize_t show_flags(struct device *d,
 {
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 
-	return sprintf(buf, "0x%04X\n", priv->active_rxon.flags);
+	return sprintf(buf, "0x%04X\n", priv->active39_rxon.flags);
 }
 
 static ssize_t store_flags(struct device *d,
@@ -7278,14 +7278,14 @@ static ssize_t store_flags(struct device *d,
 	u32 flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
-	if (le32_to_cpu(priv->staging_rxon.flags) != flags) {
+	if (le32_to_cpu(priv->staging39_rxon.flags) != flags) {
 		/* Cancel any currently running scans... */
 		if (iwl3945_scan_cancel_timeout(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.flags = 0x%04X\n",
 				       flags);
-			priv->staging_rxon.flags = cpu_to_le32(flags);
+			priv->staging39_rxon.flags = cpu_to_le32(flags);
 			iwl3945_commit_rxon(priv);
 		}
 	}
@@ -7302,7 +7302,7 @@ static ssize_t show_filter_flags(struct device *d,
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
 
 	return sprintf(buf, "0x%04X\n",
-		le32_to_cpu(priv->active_rxon.filter_flags));
+		le32_to_cpu(priv->active39_rxon.filter_flags));
 }
 
 static ssize_t store_filter_flags(struct device *d,
@@ -7313,14 +7313,14 @@ static ssize_t store_filter_flags(struct device *d,
 	u32 filter_flags = simple_strtoul(buf, NULL, 0);
 
 	mutex_lock(&priv->mutex);
-	if (le32_to_cpu(priv->staging_rxon.filter_flags) != filter_flags) {
+	if (le32_to_cpu(priv->staging39_rxon.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
 		if (iwl3945_scan_cancel_timeout(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
-			priv->staging_rxon.filter_flags =
+			priv->staging39_rxon.filter_flags =
 				cpu_to_le32(filter_flags);
 			iwl3945_commit_rxon(priv);
 		}
@@ -7373,7 +7373,7 @@ static ssize_t store_measurement(struct device *d,
 {
 	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	struct ieee80211_measurement_params params = {
-		.channel = le16_to_cpu(priv->active_rxon.channel),
+		.channel = le16_to_cpu(priv->active39_rxon.channel),
 		.start_time = cpu_to_le64(priv->last_tsf),
 		.duration = cpu_to_le16(1),
 	};
@@ -7535,7 +7535,7 @@ static ssize_t show_statistics(struct device *d,
 	struct iwl3945_priv *priv = dev_get_drvdata(d);
 	u32 size = sizeof(struct iwl3945_notif_statistics);
 	u32 len = 0, ofs = 0;
-	u8 *data = (u8 *)&priv->statistics;
+	u8 *data = (u8 *)&priv->statistics_39;
 	int rc = 0;
 
 	if (!iwl3945_is_alive(priv))
@@ -7878,7 +7878,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->ibss_beacon = NULL;
 
 	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->power_data.lock);
+	spin_lock_init(&priv->power_data_39.lock);
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
@@ -8058,7 +8058,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	iwl3945_free_channel_map(priv);
 	iwl3945_free_geos(priv);
-	kfree(priv->scan);
+	kfree(priv->scan39);
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
 
-- 
1.5.3.6

