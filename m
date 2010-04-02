Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63735 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0DBUjA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:39:00 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Frans Pop <elendil@planet.nl>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: [PATCH 6/7] iwlwifi: remove trailing space in messages
Date: Fri,  2 Apr 2010 13:38:53 -0700
Message-Id: <1270240734-12825-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
References: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Frans Pop <elendil@planet.nl>

Includes minor improvements in debugging messages in iwl-4965.c,
function iwl4965_is_temp_calib_needed().

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-io.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 ++++----
 16 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 605aca4..9e411dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -341,7 +341,7 @@ void iwl3945_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 s
 	struct ieee80211_supported_band *sband;
 	int i;
 
-	IWL_DEBUG_INFO(priv, "enter \n");
+	IWL_DEBUG_INFO(priv, "enter\n");
 	if (sta_id == priv->hw_params.bcast_sta_id)
 		goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 2c16c5c..e81577b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -486,7 +486,7 @@ static void _iwl3945_dbg_report_frame(struct iwl_priv *priv,
 		 *    but you can hack it to show more, if you'd like to. */
 		if (dataframe)
 			IWL_DEBUG_RX(priv, "%s: mhd=0x%04x, dst=0x%02x, "
-				     "len=%u, rssi=%d, chnl=%d, rate=%d, \n",
+				     "len=%u, rssi=%d, chnl=%d, rate=%d,\n",
 				     title, le16_to_cpu(fc), header->addr1[5],
 				     length, rssi, channel, rate);
 		else {
@@ -998,7 +998,7 @@ static void iwl3945_nic_config(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", rev_id);
 
 	if (rev_id & PCI_CFG_REV_ID_BIT_RTP)
-		IWL_DEBUG_INFO(priv, "RTP type \n");
+		IWL_DEBUG_INFO(priv, "RTP type\n");
 	else if (rev_id & PCI_CFG_REV_ID_BIT_BASIC_SKU) {
 		IWL_DEBUG_INFO(priv, "3945 RADIO-MB type\n");
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a5122a6..9a220d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -410,7 +410,7 @@ static void iwl4965_gain_computation(struct iwl_priv *priv,
 				      sizeof(cmd), &cmd);
 		if (ret)
 			IWL_DEBUG_CALIB(priv, "fail sending cmd "
-				     "REPLY_PHY_CALIBRATION_CMD \n");
+				     "REPLY_PHY_CALIBRATION_CMD\n");
 
 		/* TODO we might want recalculate
 		 * rx_chain in rxon cmd */
@@ -1612,19 +1612,19 @@ static int iwl4965_is_temp_calib_needed(struct iwl_priv *priv)
 
 	/* get absolute value */
 	if (temp_diff < 0) {
-		IWL_DEBUG_POWER(priv, "Getting cooler, delta %d, \n", temp_diff);
+		IWL_DEBUG_POWER(priv, "Getting cooler, delta %d\n", temp_diff);
 		temp_diff = -temp_diff;
 	} else if (temp_diff == 0)
-		IWL_DEBUG_POWER(priv, "Same temp, \n");
+		IWL_DEBUG_POWER(priv, "Temperature unchanged\n");
 	else
-		IWL_DEBUG_POWER(priv, "Getting warmer, delta %d, \n", temp_diff);
+		IWL_DEBUG_POWER(priv, "Getting warmer, delta %d\n", temp_diff);
 
 	if (temp_diff < IWL_TEMPERATURE_THRESHOLD) {
-		IWL_DEBUG_POWER(priv, "Thermal txpower calib not needed\n");
+		IWL_DEBUG_POWER(priv, " => thermal txpower calib not needed\n");
 		return 0;
 	}
 
-	IWL_DEBUG_POWER(priv, "Thermal txpower calib needed\n");
+	IWL_DEBUG_POWER(priv, " => thermal txpower calib needed\n");
 
 	return 1;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 6fe1d93..49e20f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -851,7 +851,7 @@ static void iwlagn_dbg_report_frame(struct iwl_priv *priv,
 		 *    but you can hack it to show more, if you'd like to. */
 		if (dataframe)
 			IWL_DEBUG_RX(priv, "%s: mhd=0x%04x, dst=0x%02x, "
-				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
+				     "len=%u, rssi=%d, chnl=%d, rate=%u,\n",
 				     title, le16_to_cpu(fc), header->addr1[5],
 				     length, rssi, channel, bitrate);
 		else {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index bcae6a0..0f88194 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2009,7 +2009,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	/* rates available for this association, and for modulation mode */
 	rate_mask = rs_get_supported_rates(lq_sta, hdr, tbl->lq_type);
 
-	IWL_DEBUG_RATE(priv, "mask 0x%04X \n", rate_mask);
+	IWL_DEBUG_RATE(priv, "mask 0x%04X\n", rate_mask);
 
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index ad6cb1b..a76e143 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -723,9 +723,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
 
-	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
+	IWL_DEBUG_TX(priv, "sequence nr = 0X%x\n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
-	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx_cmd->tx_flags));
+	IWL_DEBUG_TX(priv, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
@@ -1289,7 +1289,7 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
 			   ba_resp->scd_flow,
 			   ba_resp->scd_ssn);
-	IWL_DEBUG_TX_REPLY(priv, "DAT start_idx = %d, bitmap = 0x%llx \n",
+	IWL_DEBUG_TX_REPLY(priv, "DAT start_idx = %d, bitmap = 0x%llx\n",
 			   agg->start_idx,
 			   (unsigned long long)agg->bitmap);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ef5690a..629cbf3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -181,7 +181,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
 			return ret;
 		}
-		IWL_DEBUG_INFO(priv, "Return from !new_assoc RXON. \n");
+		IWL_DEBUG_INFO(priv, "Return from !new_assoc RXON.\n");
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 		iwl_clear_ucode_stations(priv, false);
 		iwl_restore_stations(priv);
@@ -2303,7 +2303,7 @@ static int iwl_prepare_card_hw(struct iwl_priv *priv)
 {
 	int ret = 0;
 
-	IWL_DEBUG_INFO(priv, "iwl_prepare_card_hw enter \n");
+	IWL_DEBUG_INFO(priv, "iwl_prepare_card_hw enter\n");
 
 	ret = iwl_set_hw_ready(priv);
 	if (priv->hw_ready)
@@ -3067,7 +3067,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	iwl_restore_wepkeys(priv);
 
 	/* Initialize rate scaling */
-	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM \n",
+	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	iwl_rs_rate_init(priv, sta, sta_id);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 845831a..dbb50a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -592,7 +592,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 	IWL_DEBUG_CALIB(priv, "rx_enable_time = %u usecs\n", rx_enable_time);
 
 	if (!rx_enable_time) {
-		IWL_DEBUG_CALIB(priv, "<< RX Enable Time == 0! \n");
+		IWL_DEBUG_CALIB(priv, "<< RX Enable Time == 0!\n");
 		return;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ff7f5c7..f09bff8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1801,7 +1801,7 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
 	struct ieee80211_sta *sta;
 
-	IWL_DEBUG_MAC80211(priv, "enter: \n");
+	IWL_DEBUG_MAC80211(priv, "enter:\n");
 
 	if (!ht_conf->is_ht)
 		return;
@@ -2366,7 +2366,7 @@ int iwl_alloc_txq_mem(struct iwl_priv *priv)
 			sizeof(struct iwl_tx_queue) * priv->cfg->num_of_queues,
 			GFP_KERNEL);
 	if (!priv->txq) {
-		IWL_ERR(priv, "Not enough memory for txq \n");
+		IWL_ERR(priv, "Not enough memory for txq\n");
 		return -ENOMEM;
 	}
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 73681c4..51f89e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -169,7 +169,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	mutex_lock(&priv->sync_cmd_mutex);
 
 	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
-	IWL_DEBUG_INFO(priv, "Setting HCMD_ACTIVE for command %s \n",
+	IWL_DEBUG_INFO(priv, "Setting HCMD_ACTIVE for command %s\n",
 			get_cmd_string(cmd->id));
 
 	cmd_idx = iwl_enqueue_hcmd(priv, cmd);
@@ -191,7 +191,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
 			clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-			IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s \n",
+			IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s\n",
 				       get_cmd_string(cmd->id));
 			ret = -ETIMEDOUT;
 			goto cancel;
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index c719baf..4f54a5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -297,7 +297,7 @@ static inline u32 __iwl_read_direct32(const char *f, u32 l,
 					struct iwl_priv *priv, u32 reg)
 {
 	u32 value = _iwl_read_direct32(priv, reg);
-	IWL_DEBUG_IO(priv, "read_direct32(0x%4X) = 0x%08x - %s %d \n", reg, value,
+	IWL_DEBUG_IO(priv, "read_direct32(0x%4X) = 0x%08x - %s %d\n", reg, value,
 		     f, l);
 	return value;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index e0581a7..2655dbd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -874,7 +874,7 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	int size = sizeof(struct iwl_tt_trans) * (IWL_TI_STATE_MAX - 1);
 	struct iwl_tt_trans *transaction;
 
-	IWL_DEBUG_POWER(priv, "Initialize Thermal Throttling \n");
+	IWL_DEBUG_POWER(priv, "Initialize Thermal Throttling\n");
 
 	memset(tt, 0, sizeof(struct iwl_tt_mgmt));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 5ecfc7f..0daa1c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -453,7 +453,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		added++;
 	}
 
-	IWL_DEBUG_SCAN(priv, "total channels to scan %d \n", added);
+	IWL_DEBUG_SCAN(priv, "total channels to scan %d\n", added);
 	return added;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 9c28ad7..e34ac03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -71,7 +71,7 @@ u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 	    (!(priv->stations[ret].used & IWL_STA_UCODE_ACTIVE) ||
 	     ((priv->stations[ret].used & IWL_STA_UCODE_ACTIVE) &&
 	      (priv->stations[ret].used & IWL_STA_UCODE_INPROGRESS)))) {
-		IWL_ERR(priv, "Requested station info for sta %d before ready. \n",
+		IWL_ERR(priv, "Requested station info for sta %d before ready.\n",
 			ret);
 		ret = IWL_INVALID_STATION;
 	}
@@ -143,7 +143,7 @@ static void iwl_process_add_sta_resp(struct iwl_priv *priv,
 			sta_id);
 		break;
 	case ADD_STA_MODIFY_NON_EXIST_STA:
-		IWL_ERR(priv, "Attempting to modify non-existing station %d \n",
+		IWL_ERR(priv, "Attempting to modify non-existing station %d\n",
 			sta_id);
 		break;
 	default:
@@ -571,7 +571,7 @@ static int iwl_remove_station(struct iwl_priv *priv, struct ieee80211_sta *sta)
 
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_INFO(priv,
-			"Unable to remove station %pM, device not ready. \n",
+			"Unable to remove station %pM, device not ready.\n",
 			sta->addr);
 		/*
 		 * It is typical for stations to be removed when we are
@@ -668,7 +668,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv, bool force)
 	} else {
 		for (i = 0; i < priv->hw_params.max_stations; i++) {
 			if (priv->stations[i].used & IWL_STA_UCODE_ACTIVE) {
-				IWL_DEBUG_INFO(priv, "Clearing ucode active for station %d \n", i);
+				IWL_DEBUG_INFO(priv, "Clearing ucode active for station %d\n", i);
 				priv->stations[i].used &= ~IWL_STA_UCODE_ACTIVE;
 				cleared = true;
 			}
@@ -1105,7 +1105,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
 	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_WEP(priv, "Not sending REPLY_ADD_STA command because RFKILL enabled. \n");
+		IWL_DEBUG_WEP(priv, "Not sending REPLY_ADD_STA command because RFKILL enabled.\n");
 		spin_unlock_irqrestore(&priv->sta_lock, flags);
 		return 0;
 	}
@@ -1207,7 +1207,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 		return ret;
 
 	if (init) {
-		IWL_DEBUG_INFO(priv, "init LQ command complete, clearing sta addition status for sta %d \n",
+		IWL_DEBUG_INFO(priv, "init LQ command complete, clearing sta addition status for sta %d\n",
 			       lq->sta_id);
 		spin_lock_irqsave(&priv->sta_lock, flags_spin);
 		priv->stations[lq->sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 91f9c89..65090d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -579,7 +579,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 	if (!(meta->flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-		IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s \n",
+		IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 24c240d..4d0394b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -597,9 +597,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		txq->need_update = 0;
 	}
 
-	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
+	IWL_DEBUG_TX(priv, "sequence nr = 0X%x\n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
-	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx_cmd->tx_flags));
+	IWL_DEBUG_TX(priv, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
 	iwl_print_hex_dump(priv, IWL_DL_TX, tx_cmd, sizeof(*tx_cmd));
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr,
 			   ieee80211_hdrlen(fc));
@@ -1937,7 +1937,7 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 		added++;
 	}
 
-	IWL_DEBUG_SCAN(priv, "total channels to scan %d \n", added);
+	IWL_DEBUG_SCAN(priv, "total channels to scan %d\n", added);
 	return added;
 }
 
@@ -3401,7 +3401,7 @@ static int iwl3945_mac_sta_add(struct ieee80211_hw *hw,
 	}
 
 	/* Initialize rate scaling */
-	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM \n",
+	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	iwl3945_rs_rate_init(priv, sta, sta_id);
 
-- 
1.6.3.3

