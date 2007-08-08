Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250AbXHHHhc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:32 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 12/28] iwlwifi: shorten some structure and function names
Date: Wed,  8 Aug 2007 15:33:29 +0800
Message-Id: <11865584543903-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584521358-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c   |    1 -
 drivers/net/wireless/iwl-4965.c   |   79 +++++++++++++------------------------
 drivers/net/wireless/iwl-base.c   |   10 +----
 drivers/net/wireless/iwl-eeprom.h |   15 +++----
 drivers/net/wireless/iwl-io.h     |   10 ++---
 5 files changed, 41 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index 50c21aa..c4441db 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -307,7 +307,6 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 		.rate = rx_hdr->rate,
 		.flag = 0,
 	};
-
 	u8 network_packet;
 	int snr;
 
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index d334951..0cbe798 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -660,10 +660,6 @@ int iwl_hw_nic_reset(struct iwl_priv *priv)
 		iwl_release_restricted_access(priv);
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
 	priv->status &= ~STATUS_HCMD_ACTIVE;
 	wake_up_interruptible(&priv->wait_command_queue);
 
@@ -1894,7 +1890,7 @@ iwl4965_get_channel_txpower_info(struct iwl_priv *priv, u8 phymode, u8 channel)
 	return ch_info;
 }
 
-static s32 iwl4965_get_txatten_group_from_channel(u32 channel)
+static s32 iwl4965_get_tx_atten_grp(u32 channel)
 {
 	if (channel >= CALIB_IWL_TX_ATTEN_GR5_FCH &&
 	    channel <= CALIB_IWL_TX_ATTEN_GR5_LCH)
@@ -1922,22 +1918,18 @@ static s32 iwl4965_get_txatten_group_from_channel(u32 channel)
 
 static u32 iwl4965_get_sub_band(const struct iwl_priv *priv, u32 channel)
 {
-	s32 sub_band = -1;
+	s32 b = -1;
 
-	for (sub_band = 0; sub_band < EEPROM_TX_POWER_BANDS; sub_band++) {
-
-		if (priv->eeprom.calib_info.band_info_tbl[sub_band].ch_from ==
-		    0)
+	for (b = 0; b < EEPROM_TX_POWER_BANDS; b++) {
+		if (priv->eeprom.calib_info.band_info[b].ch_from == 0)
 			continue;
 
-		if ((channel >=
-		     priv->eeprom.calib_info.band_info_tbl[sub_band].ch_from)
-		    && (channel <=
-			priv->eeprom.calib_info.band_info_tbl[sub_band].ch_to))
+		if ((channel >= priv->eeprom.calib_info.band_info[b].ch_from)
+		    && (channel <= priv->eeprom.calib_info.band_info[b].ch_to))
 			break;
 	}
 
-	return sub_band;
+	return b;
 }
 
 static s32 iwl4965_interpolate_value(s32 x, s32 x1, s32 y1, s32 x2, s32 y2)
@@ -1952,16 +1944,15 @@ static s32 iwl4965_interpolate_value(s32 x, s32 x1, s32 y1, s32 x2, s32 y2)
 	}
 }
 
-static int iwl4965_interpolate_chan(
-	struct iwl_priv *priv, u32 channel,
-	struct iwl_eeprom_calib_channel_info *chan_info)
+static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
+				    struct iwl_eeprom_calib_ch_info *chan_info)
 {
 	s32 s = -1;
 	u32 c;
 	u32 m;
-	const struct iwl_eeprom_calib_measurement *m1;
-	const struct iwl_eeprom_calib_measurement *m2;
-	struct iwl_eeprom_calib_measurement *omeas;
+	const struct iwl_eeprom_calib_measure *m1;
+	const struct iwl_eeprom_calib_measure *m2;
+	struct iwl_eeprom_calib_measure *omeas;
 	u32 ch_i1;
 	u32 ch_i2;
 
@@ -1971,8 +1962,8 @@ static int iwl4965_interpolate_chan(
 		return -1;
 	}
 
-	ch_i1 = priv->eeprom.calib_info.band_info_tbl[s].ch1.ch_num;
-	ch_i2 = priv->eeprom.calib_info.band_info_tbl[s].ch2.ch_num;
+	ch_i1 = priv->eeprom.calib_info.band_info[s].ch1.ch_num;
+	ch_i2 = priv->eeprom.calib_info.band_info[s].ch2.ch_num;
 	chan_info->ch_num = (u8) channel;
 
 	IWL_DEBUG_TXPOWER("channel %d subband %d factory cal ch %d & %d\n",
@@ -1980,9 +1971,9 @@ static int iwl4965_interpolate_chan(
 
 	for (c = 0; c < EEPROM_TX_POWER_TX_CHAINS; c++) {
 		for (m = 0; m < EEPROM_TX_POWER_MEASUREMENTS; m++) {
-			m1 = &(priv->eeprom.calib_info.band_info_tbl[s].ch1.
+			m1 = &(priv->eeprom.calib_info.band_info[s].ch1.
 			       measurements[c][m]);
-			m2 = &(priv->eeprom.calib_info.band_info_tbl[s].ch2.
+			m2 = &(priv->eeprom.calib_info.band_info[s].ch2.
 			       measurements[c][m]);
 			omeas = &(chan_info->measurements[c][m]);
 
@@ -2299,12 +2290,12 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u8 channel,
 	s32 current_temp;
 	s32 reg_limit;
 	s32 current_regulatory;
-	s32 txatten_group = CALIB_CH_GROUP_MAX;
+	s32 txatten_grp = CALIB_CH_GROUP_MAX;
 	int i = 0;
 	int c;
 	const struct iwl_channel_info *ch_info = NULL;
-	struct iwl_eeprom_calib_channel_info ch_eeprom_info;
-	const struct iwl_eeprom_calib_measurement *measurement;
+	struct iwl_eeprom_calib_ch_info ch_eeprom_info;
+	const struct iwl_eeprom_calib_measure *measurement;
 	s16 voltage;
 	s32 init_voltage;
 	s32 voltage_compensation;
@@ -2344,12 +2335,12 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u8 channel,
 
 	/* get txatten group, used to select 1) thermal txpower adjustment
 	 *   and 2) mimo txpower balance between Tx chains. */
-	txatten_group = iwl4965_get_txatten_group_from_channel(channel);
-	if (txatten_group < 0)
+	txatten_grp = iwl4965_get_tx_atten_grp(channel);
+	if (txatten_grp < 0)
 		return -EINVAL;
 
 	IWL_DEBUG_TXPOWER("channel %d belongs to txatten group %d\n",
-			  channel, txatten_group);
+			  channel, txatten_grp);
 
 	if (is_fat) {
 		if (ctrl_chan_high)
@@ -2407,18 +2398,12 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u8 channel,
 	current_temp = min(priv->temperature, IWL_TX_POWER_TEMPERATURE_MAX);
 	current_temp = KELVIN_TO_CELSIUS(current_temp);
 
-	if (-40 > current_temp) {
-		IWL_WARNING("Invalid temperature %d, can't calculate "
-			    "txpower\n", current_temp);
-		return -EINVAL;
-	}
-
 	/* select thermal txpower adjustment params, based on channel group
 	 *   (same frequency group used for mimo txatten adjustment) */
 	degrees_per_05db_num =
-	    tx_power_cmp_tble[txatten_group].degrees_per_05db_a;
+	    tx_power_cmp_tble[txatten_grp].degrees_per_05db_a;
 	degrees_per_05db_denom =
-	    tx_power_cmp_tble[txatten_group].degrees_per_05db_a_denom;
+	    tx_power_cmp_tble[txatten_grp].degrees_per_05db_a_denom;
 
 	/* get per-chain txpower values from factory measurements */
 	for (c = 0; c < 2; c++) {
@@ -2486,7 +2471,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u8 channel,
 			if (is_mimo_rate)
 				atten_value =
 				    priv->card_alive_init.
-				    tx_atten[txatten_group][c];
+				    tx_atten[txatten_grp][c];
 			else
 				atten_value = 0;
 
@@ -2765,11 +2750,6 @@ int iwl_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	return 0;
 }
 
-static inline u32 iwl4965_get_dma_lo_address(dma_addr_t addr)
-{
-	return (u32) (addr & 0xffffffff);
-}
-
 static inline u8 iwl4965_get_dma_hi_address(dma_addr_t addr)
 {
 	return sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0;
@@ -2792,8 +2772,7 @@ int iwl_hw_tx_queue_attach_buffer_to_tfd(struct iwl_priv *priv,
 	is_odd = num_tbs & 0x1;
 
 	if (!is_odd) {
-		tfd->pa[index].tb1_addr = cpu_to_le32(
-			     iwl4965_get_dma_lo_address(addr));
+		tfd->pa[index].tb1_addr = cpu_to_le32(addr);
 		IWL_SET_BITS(tfd->pa[index], tb1_addr_hi,
 			     iwl4965_get_dma_hi_address(addr));
 		IWL_SET_BITS(tfd->pa[index], tb1_len, len);
@@ -3281,8 +3260,7 @@ int iwl4965_tx_cmd(struct iwl_priv *priv, struct iwl_cmd *out_cmd,
 
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 	    offsetof(struct iwl_tx_cmd, scratch);
-	tx->dram_lsb_ptr = cpu_to_le32(
-			iwl4965_get_dma_lo_address(scratch_phys));
+	tx->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx->dram_msb_ptr = iwl4965_get_dma_hi_address(scratch_phys);
 
 	/* Hard coded to start at the highest retry fallback position
@@ -3802,7 +3780,6 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-
 	/* Use phy data (Rx signal strength, etc.) contained within
 	 *   this rx packet for legacy frames,
 	 *   or phy data cached from REPLY_RX_PHY_CMD for HT frames. */
@@ -3810,7 +3787,6 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
 		(struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) :
 		(struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
-
 	__le32 *rx_end;
 	unsigned int len = 0;
 	struct ieee80211_hdr *header;
@@ -4098,6 +4074,7 @@ static void iwl4965_set_tx_status(struct iwl_priv *priv, int txq_id, int idx,
 {
 	struct ieee80211_tx_status *tx_status =
 		&(priv->txq[txq_id].txb[idx].status);
+
 	tx_status->flags = status?IEEE80211_TX_STATUS_ACK:0;
 	tx_status->retry_count += retry_count;
 	tx_status->control.tx_rate = rate;
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index e419391..dad9649 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -4296,8 +4296,8 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 		if (rc)
 			goto exit_unlock;
 
-		iwl_write_restricted(priv,
-				     FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
+		iwl_write_restricted(priv, FH_RSCSR_CHNL0_WPTR,
+				     q->write & ~0x7);
 		iwl_release_restricted_access(priv);
 	} else
 		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
@@ -6745,11 +6745,7 @@ void iwl_down(struct iwl_priv *priv)
 	udelay(5);
 
 	iwl_hw_nic_stop_master(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	iwl_hw_nic_reset(priv);
 
  exit:
@@ -9328,9 +9324,7 @@ static void iwl_resume(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	spin_unlock_irqrestore(&priv->lock, flags);
 
-	spin_lock_irqsave(&priv->lock, flags);
 	if (!iwl_grab_restricted_access(priv)) {
 		iwl_write_restricted_reg(priv, ALM_APMG_CLK_DIS,
 					 APMG_CLK_REG_VAL_DMA_CLK_RQT);
diff --git a/drivers/net/wireless/iwl-eeprom.h b/drivers/net/wireless/iwl-eeprom.h
index 19d7028..c6b0faa 100644
--- a/drivers/net/wireless/iwl-eeprom.h
+++ b/drivers/net/wireless/iwl-eeprom.h
@@ -187,32 +187,31 @@ struct iwl_eeprom_temperature_corr {
 #define EEPROM_TX_POWER_VERSION        (2)
 #define EEPROM_TX_POWER_VERSION_NEW    (5)
 
-struct iwl_eeprom_calib_measurement {
+struct iwl_eeprom_calib_measure {
 	u8 temperature;
 	u8 gain_idx;
 	u8 actual_pow;
 	s8 pa_det;
 } __attribute__ ((packed));
 
-struct iwl_eeprom_calib_channel_info {
+struct iwl_eeprom_calib_ch_info {
 	u8 ch_num;
-	struct iwl_eeprom_calib_measurement
-	 measurements[EEPROM_TX_POWER_TX_CHAINS][EEPROM_TX_POWER_MEASUREMENTS];
+	struct iwl_eeprom_calib_measure measurements[EEPROM_TX_POWER_TX_CHAINS]
+		[EEPROM_TX_POWER_MEASUREMENTS];
 } __attribute__ ((packed));
 
 struct iwl_eeprom_calib_subband_info {
 	u8 ch_from;
 	u8 ch_to;
-	struct iwl_eeprom_calib_channel_info ch1;
-	struct iwl_eeprom_calib_channel_info ch2;
+	struct iwl_eeprom_calib_ch_info ch1;
+	struct iwl_eeprom_calib_ch_info ch2;
 } __attribute__ ((packed));
 
 struct iwl_eeprom_calib_info {
 	u8 saturation_power24;
 	u8 saturation_power52;
 	__le16 voltage;		/* signed */
-	struct iwl_eeprom_calib_subband_info
-	 band_info_tbl[EEPROM_TX_POWER_BANDS];
+	struct iwl_eeprom_calib_subband_info band_info[EEPROM_TX_POWER_BANDS];
 } __attribute__ ((packed));
 
 #endif
diff --git a/drivers/net/wireless/iwl-io.h b/drivers/net/wireless/iwl-io.h
index 0ae031a..3f8cb06 100644
--- a/drivers/net/wireless/iwl-io.h
+++ b/drivers/net/wireless/iwl-io.h
@@ -415,18 +415,16 @@ static inline void iwl_write_restricted_mem(struct iwl_priv *priv, u32 addr,
 	iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, val);
 }
 
-static inline void iwl_write_restricted_mem_buffer(struct iwl_priv *priv,
-						   u32 addr, u32 len,
-						   u32 *values)
+static inline void iwl_write_restricted_mems(struct iwl_priv *priv, u32 addr,
+					     u32 len, u32 *values)
 {
 	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
 	for (; 0 < len; len -= sizeof(u32), values++)
 		iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, *values);
 }
 
-static inline void iwl_write_restricted_reg_buffer(struct iwl_priv *priv,
-						   u32 reg, u32 len,
-						   u8 *values)
+static inline void iwl_write_restricted_regs(struct iwl_priv *priv, u32 reg,
+					     u32 len, u8 *values)
 {
 	u32 reg_offset = reg;
 	u32 aligment = reg & 0x3;
-- 
1.5.2
