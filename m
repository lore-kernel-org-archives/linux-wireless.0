Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40628 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaEORFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:13 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so3708342wgh.8
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:11 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/24] iwlwifi: remove CMD_SYNC
Date: Thu, 15 May 2014 20:04:29 +0300
Message-Id: <1400173481-9047-12-git-send-email-egrumbach@gmail.com> (sfid-20140515_190615_977525_DF8F911F)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

CMD_SYNC is really 0 which is confusing:

if (cmd.flags & CMD_SYNC) is always false.
Fix this by simply removing its definition.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/calib.c       |  1 -
 drivers/net/wireless/iwlwifi/dvm/debugfs.c     |  7 +++----
 drivers/net/wireless/iwlwifi/dvm/devices.c     |  2 --
 drivers/net/wireless/iwlwifi/dvm/lib.c         | 17 +++++++---------
 drivers/net/wireless/iwlwifi/dvm/main.c        | 14 +++++--------
 drivers/net/wireless/iwlwifi/dvm/power.c       |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c        | 16 +++++++--------
 drivers/net/wireless/iwlwifi/dvm/scan.c        |  3 +--
 drivers/net/wireless/iwlwifi/dvm/sta.c         | 25 +++++++++++-------------
 drivers/net/wireless/iwlwifi/dvm/tt.c          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c       |  6 +++---
 drivers/net/wireless/iwlwifi/iwl-phy-db.c      |  1 -
 drivers/net/wireless/iwlwifi/iwl-trans.h       |  8 +++-----
 drivers/net/wireless/iwlwifi/mvm/coex.c        |  7 ++-----
 drivers/net/wireless/iwlwifi/mvm/d3.c          | 27 +++++++++++---------------
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     |  6 +++---
 drivers/net/wireless/iwlwifi/mvm/fw.c          |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c    |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    | 20 +++++++++----------
 drivers/net/wireless/iwlwifi/mvm/nvm.c         |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/ops.c         |  2 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c    |  2 +-
 drivers/net/wireless/iwlwifi/mvm/power.c       |  6 +++---
 drivers/net/wireless/iwlwifi/mvm/quota.c       |  2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c        |  8 ++------
 drivers/net/wireless/iwlwifi/mvm/sta.c         | 18 ++++++++---------
 drivers/net/wireless/iwlwifi/mvm/time-event.c  |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/tt.c          |  1 -
 drivers/net/wireless/iwlwifi/mvm/tx.c          |  2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c       |  4 ++--
 32 files changed, 99 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/calib.c b/drivers/net/wireless/iwlwifi/dvm/calib.c
index be1086c..20e6aa9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/calib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/calib.c
@@ -94,7 +94,6 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 {
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_PHY_CALIBRATION_CMD,
-		.flags = CMD_SYNC,
 	};
 	struct iwl_calib_result *res;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index d2fe259..0ffb6ff 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -1481,7 +1481,7 @@ static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
 
 	/* make request to uCode to retrieve statistics information */
 	mutex_lock(&priv->mutex);
-	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
+	ret = iwl_send_statistics_request(priv, 0, false);
 	mutex_unlock(&priv->mutex);
 
 	if (ret)
@@ -1868,7 +1868,7 @@ static ssize_t iwl_dbgfs_clear_ucode_statistics_write(struct file *file,
 
 	/* make request to uCode to retrieve statistics information */
 	mutex_lock(&priv->mutex);
-	iwl_send_statistics_request(priv, CMD_SYNC, true);
+	iwl_send_statistics_request(priv, 0, true);
 	mutex_unlock(&priv->mutex);
 
 	return count;
@@ -2188,7 +2188,6 @@ static int iwl_cmd_echo_test(struct iwl_priv *priv)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_ECHO,
 		.len = { 0 },
-		.flags = CMD_SYNC,
 	};
 
 	ret = iwl_dvm_send_cmd(priv, &cmd);
@@ -2320,7 +2319,7 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct file *file,
 	mutex_lock(&priv->mutex);
 
 	/* take the return value to make compiler happy - it will fail anyway */
-	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_ERROR, CMD_SYNC, 0, NULL);
+	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_ERROR, 0, 0, NULL);
 
 	mutex_unlock(&priv->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index 758c54e..34b41e5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -417,7 +417,6 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
 		.len = { sizeof(cmd), },
-		.flags = CMD_SYNC,
 		.data = { &cmd, },
 	};
 
@@ -579,7 +578,6 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
 		.len = { sizeof(*cmd), },
-		.flags = CMD_SYNC,
 		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 	};
 	int err;
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index d169228..2191621 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -81,7 +81,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	else
 		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
 
-	return iwl_dvm_send_cmd_pdu(priv, tx_ant_cfg_cmd, CMD_SYNC,
+	return iwl_dvm_send_cmd_pdu(priv, tx_ant_cfg_cmd, 0,
 			sizeof(tx_power_cmd), &tx_power_cmd);
 }
 
@@ -141,7 +141,6 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u32 scd_q_msk)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TXFIFO_FLUSH,
 		.len = { sizeof(struct iwl_txfifo_flush_cmd), },
-		.flags = CMD_SYNC,
 		.data = { &flush_cmd, },
 	};
 
@@ -333,12 +332,12 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 		memcpy(&bt_cmd_v2.basic, &basic,
 			sizeof(basic));
 		ret = iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-			CMD_SYNC, sizeof(bt_cmd_v2), &bt_cmd_v2);
+			0, sizeof(bt_cmd_v2), &bt_cmd_v2);
 	} else {
 		memcpy(&bt_cmd_v1.basic, &basic,
 			sizeof(basic));
 		ret = iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-			CMD_SYNC, sizeof(bt_cmd_v1), &bt_cmd_v1);
+			0, sizeof(bt_cmd_v1), &bt_cmd_v1);
 	}
 	if (ret)
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
@@ -1044,7 +1043,6 @@ int iwlagn_send_patterns(struct iwl_priv *priv,
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_WOWLAN_PATTERNS,
 		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
-		.flags = CMD_SYNC,
 	};
 	int i, err;
 
@@ -1201,7 +1199,6 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 		if (key_data.use_rsc_tsc) {
 			struct iwl_host_cmd rsc_tsc_cmd = {
 				.id = REPLY_WOWLAN_TSC_RSC_PARAMS,
-				.flags = CMD_SYNC,
 				.data[0] = key_data.rsc_tsc,
 				.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 				.len[0] = sizeof(*key_data.rsc_tsc),
@@ -1215,7 +1212,7 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 		if (key_data.use_tkip) {
 			ret = iwl_dvm_send_cmd_pdu(priv,
 						 REPLY_WOWLAN_TKIP_PARAMS,
-						 CMD_SYNC, sizeof(tkip_cmd),
+						 0, sizeof(tkip_cmd),
 						 &tkip_cmd);
 			if (ret)
 				goto out;
@@ -1231,20 +1228,20 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 
 			ret = iwl_dvm_send_cmd_pdu(priv,
 						 REPLY_WOWLAN_KEK_KCK_MATERIAL,
-						 CMD_SYNC, sizeof(kek_kck_cmd),
+						 0, sizeof(kek_kck_cmd),
 						 &kek_kck_cmd);
 			if (ret)
 				goto out;
 		}
 	}
 
-	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_D3_CONFIG, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_D3_CONFIG, 0,
 				     sizeof(d3_cfg_cmd), &d3_cfg_cmd);
 	if (ret)
 		goto out;
 
 	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_WOWLAN_WAKEUP_FILTER,
-				 CMD_SYNC, sizeof(wakeup_filter_cmd),
+				 0, sizeof(wakeup_filter_cmd),
 				 &wakeup_filter_cmd);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 7bfd741..0b7f46f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -128,7 +128,6 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_BEACON,
-		.flags = CMD_SYNC,
 	};
 	struct ieee80211_tx_info *info;
 	u32 frame_size;
@@ -311,8 +310,7 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 					sizeof(struct iwl_statistics_cmd),
 					&statistics_cmd);
 	else
-		return iwl_dvm_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
-					CMD_SYNC,
+		return iwl_dvm_send_cmd_pdu(priv, REPLY_STATISTICS_CMD, 0,
 					sizeof(struct iwl_statistics_cmd),
 					&statistics_cmd);
 }
@@ -622,7 +620,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 
 		ret = iwl_dvm_send_cmd_pdu(priv,
 				       REPLY_CT_KILL_CONFIG_CMD,
-				       CMD_SYNC, sizeof(adv_cmd), &adv_cmd);
+				       0, sizeof(adv_cmd), &adv_cmd);
 		if (ret)
 			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
 		else
@@ -637,7 +635,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 
 		ret = iwl_dvm_send_cmd_pdu(priv,
 				       REPLY_CT_KILL_CONFIG_CMD,
-				       CMD_SYNC, sizeof(cmd), &cmd);
+				       0, sizeof(cmd), &cmd);
 		if (ret)
 			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
 		else
@@ -673,9 +671,7 @@ static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 
 	if (IWL_UCODE_API(priv->fw->ucode_ver) > 1) {
 		IWL_DEBUG_HC(priv, "select valid tx ant: %u\n", valid_tx_ant);
-		return iwl_dvm_send_cmd_pdu(priv,
-					TX_ANT_CONFIGURATION_CMD,
-					CMD_SYNC,
+		return iwl_dvm_send_cmd_pdu(priv, TX_ANT_CONFIGURATION_CMD, 0,
 					sizeof(struct iwl_tx_ant_config_cmd),
 					&tx_ant_cmd);
 	} else {
@@ -703,7 +699,7 @@ static void iwl_send_bt_config(struct iwl_priv *priv)
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
 	if (iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-			     CMD_SYNC, sizeof(struct iwl_bt_cmd), &bt_cmd))
+			     0, sizeof(struct iwl_bt_cmd), &bt_cmd))
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
 }
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c b/drivers/net/wireless/iwlwifi/dvm/power.c
index 6ad7cb6..f2c1439 100644
--- a/drivers/net/wireless/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/iwlwifi/dvm/power.c
@@ -278,7 +278,7 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 			le32_to_cpu(cmd->sleep_interval[3]),
 			le32_to_cpu(cmd->sleep_interval[4]));
 
-	return iwl_dvm_send_cmd_pdu(priv, POWER_TABLE_CMD, CMD_SYNC,
+	return iwl_dvm_send_cmd_pdu(priv, POWER_TABLE_CMD, 0,
 				sizeof(struct iwl_powertable_cmd), cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 6fba037..32b78a6 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -2709,7 +2709,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_link_cmd(NULL, lq_sta, rate);
 	priv->stations[lq_sta->lq.sta_id].lq = &lq_sta->lq;
-	iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, CMD_SYNC, true);
+	iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, 0, true);
 }
 
 static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 623814d..ed50de6 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -104,7 +104,7 @@ static int iwlagn_disable_bss(struct iwl_priv *priv,
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd,
-				CMD_SYNC, sizeof(*send), send);
+				0, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
 
@@ -134,7 +134,7 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	send->dev_type = RXON_DEV_TYPE_P2P;
 	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd,
-				CMD_SYNC, sizeof(*send), send);
+				0, sizeof(*send), send);
 
 	send->filter_flags = old_filter;
 	send->dev_type = old_dev_type;
@@ -160,7 +160,7 @@ static int iwlagn_disconn_pan(struct iwl_priv *priv,
 	int ret;
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd, 0,
 				sizeof(*send), send);
 
 	send->filter_flags = old_filter;
@@ -189,7 +189,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 		      ctx->qos_data.qos_active,
 		      ctx->qos_data.def_qos_parm.qos_flags);
 
-	ret = iwl_dvm_send_cmd_pdu(priv, ctx->qos_cmd, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, ctx->qos_cmd, 0,
 			       sizeof(struct iwl_qosparam_cmd),
 			       &ctx->qos_data.def_qos_parm);
 	if (ret)
@@ -353,7 +353,7 @@ static int iwl_send_rxon_timing(struct iwl_priv *priv,
 			le16_to_cpu(ctx->timing.atim_window));
 
 	return iwl_dvm_send_cmd_pdu(priv, ctx->rxon_timing_cmd,
-				CMD_SYNC, sizeof(ctx->timing), &ctx->timing);
+				0, sizeof(ctx->timing), &ctx->timing);
 }
 
 static int iwlagn_rxon_disconn(struct iwl_priv *priv,
@@ -495,7 +495,7 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	 * Associated RXON doesn't clear the station table in uCode,
 	 * so we don't need to restore stations etc. after this.
 	 */
-	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, ctx->rxon_cmd, 0,
 		      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 	if (ret) {
 		IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
@@ -610,7 +610,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].width = cpu_to_le16(slot0);
 	cmd.slots[1].width = cpu_to_le16(slot1);
 
-	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_WIPAN_PARAMS, CMD_SYNC,
+	ret = iwl_dvm_send_cmd_pdu(priv, REPLY_WIPAN_PARAMS, 0,
 			sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(priv, "Error setting PAN parameters (%d)\n", ret);
@@ -1395,7 +1395,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 			priv->phy_calib_chain_noise_reset_cmd);
 		ret = iwl_dvm_send_cmd_pdu(priv,
 					REPLY_PHY_CALIBRATION_CMD,
-					CMD_SYNC, sizeof(cmd), &cmd);
+					0, sizeof(cmd), &cmd);
 		if (ret)
 			IWL_ERR(priv,
 				"Could not send REPLY_PHY_CALIBRATION_CMD\n");
diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index be98b91..43bef90 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -59,7 +59,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	int ret;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
-		.flags = CMD_SYNC | CMD_WANT_SKB,
+		.flags = CMD_WANT_SKB,
 	};
 	__le32 *status;
 
@@ -639,7 +639,6 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = { sizeof(struct iwl_scan_cmd), },
-		.flags = CMD_SYNC,
 	};
 	struct iwl_scan_cmd *scan;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index 2763b9c..6ec86ad 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -261,7 +261,7 @@ int iwl_sta_update_ht(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	cmd.station_flags = flags;
 	cmd.sta.sta_id = sta_id;
 
-	return iwl_send_add_sta(priv, &cmd, CMD_SYNC);
+	return iwl_send_add_sta(priv, &cmd, 0);
 }
 
 static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
@@ -413,7 +413,7 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	spin_unlock_bh(&priv->sta_lock);
 
 	/* Add station to device's station table */
-	ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+	ret = iwl_send_add_sta(priv, &sta_cmd, 0);
 	if (ret) {
 		spin_lock_bh(&priv->sta_lock);
 		IWL_ERR(priv, "Adding station %pM failed.\n",
@@ -456,7 +456,6 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_REMOVE_STA,
 		.len = { sizeof(struct iwl_rem_sta_cmd), },
-		.flags = CMD_SYNC,
 		.data = { &rm_sta_cmd, },
 	};
 
@@ -740,7 +739,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 					send_lq = true;
 			}
 			spin_unlock_bh(&priv->sta_lock);
-			ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+			ret = iwl_send_add_sta(priv, &sta_cmd, 0);
 			if (ret) {
 				spin_lock_bh(&priv->sta_lock);
 				IWL_ERR(priv, "Adding station %pM failed.\n",
@@ -756,8 +755,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			 * current LQ command
 			 */
 			if (send_lq)
-				iwl_send_lq_cmd(priv, ctx, &lq,
-						CMD_SYNC, true);
+				iwl_send_lq_cmd(priv, ctx, &lq, 0, true);
 			spin_lock_bh(&priv->sta_lock);
 			priv->stations[i].used &= ~IWL_STA_UCODE_INPROGRESS;
 		}
@@ -968,7 +966,7 @@ int iwlagn_add_bssid_station(struct iwl_priv *priv,
 		return -ENOMEM;
 	}
 
-	ret = iwl_send_lq_cmd(priv, ctx, link_cmd, CMD_SYNC, true);
+	ret = iwl_send_lq_cmd(priv, ctx, link_cmd, 0, true);
 	if (ret)
 		IWL_ERR(priv, "Link quality command failed (%d)\n", ret);
 
@@ -999,7 +997,6 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 	struct iwl_host_cmd cmd = {
 		.id = ctx->wep_key_cmd,
 		.data = { wep_cmd, },
-		.flags = CMD_SYNC,
 	};
 
 	might_sleep();
@@ -1248,7 +1245,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	sta_cmd.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	sta_cmd.mode = STA_CONTROL_MODIFY_MSK;
 
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+	return iwl_send_add_sta(priv, &sta_cmd, 0);
 }
 
 int iwl_set_dynamic_key(struct iwl_priv *priv,
@@ -1284,13 +1281,13 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
 		ieee80211_get_tkip_rx_p1k(keyconf, addr, seq.tkip.iv32, p1k);
 		ret = iwlagn_send_sta_key(priv, keyconf, sta_id,
-					  seq.tkip.iv32, p1k, CMD_SYNC);
+					  seq.tkip.iv32, p1k, 0);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		ret = iwlagn_send_sta_key(priv, keyconf, sta_id,
-					  0, NULL, CMD_SYNC);
+					  0, NULL, 0);
 		break;
 	default:
 		IWL_ERR(priv, "Unknown cipher %x\n", keyconf->cipher);
@@ -1409,7 +1406,7 @@ int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_bh(&priv->sta_lock);
 
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+	return iwl_send_add_sta(priv, &sta_cmd, 0);
 }
 
 int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
@@ -1433,7 +1430,7 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_bh(&priv->sta_lock);
 
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+	return iwl_send_add_sta(priv, &sta_cmd, 0);
 }
 
 int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
@@ -1458,7 +1455,7 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
 	spin_unlock_bh(&priv->sta_lock);
 
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+	return iwl_send_add_sta(priv, &sta_cmd, 0);
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/tt.c b/drivers/net/wireless/iwlwifi/dvm/tt.c
index 058c589..acb981a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.c
@@ -236,7 +236,7 @@ static void iwl_prepare_ct_kill_task(struct iwl_priv *priv)
 {
 	IWL_DEBUG_TEMP(priv, "Prepare to enter IWL_TI_CT_KILL\n");
 	/* make request to retrieve statistics information */
-	iwl_send_statistics_request(priv, CMD_SYNC, false);
+	iwl_send_statistics_request(priv, 0, false);
 	/* Reschedule the ct_kill wait timer */
 	mod_timer(&priv->thermal_throttle.ct_kill_waiting_tm,
 		 jiffies + msecs_to_jiffies(CT_KILL_WAITING_DURATION));
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index cf03ef5..d5cee15 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -172,7 +172,7 @@ static int iwl_send_wimax_coex(struct iwl_priv *priv)
 	memset(&coex_cmd, 0, sizeof(coex_cmd));
 
 	return iwl_dvm_send_cmd_pdu(priv,
-				COEX_PRIORITY_TABLE_CMD, CMD_SYNC,
+				COEX_PRIORITY_TABLE_CMD, 0,
 				sizeof(coex_cmd), &coex_cmd);
 }
 
@@ -205,7 +205,7 @@ void iwl_send_prio_tbl(struct iwl_priv *priv)
 	memcpy(prio_tbl_cmd.prio_tbl, iwl_bt_prio_tbl,
 		sizeof(iwl_bt_prio_tbl));
 	if (iwl_dvm_send_cmd_pdu(priv,
-				REPLY_BT_COEX_PRIO_TABLE, CMD_SYNC,
+				REPLY_BT_COEX_PRIO_TABLE, 0,
 				sizeof(prio_tbl_cmd), &prio_tbl_cmd))
 		IWL_ERR(priv, "failed to send BT prio tbl command\n");
 }
@@ -218,7 +218,7 @@ int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 	env_cmd.action = action;
 	env_cmd.type = type;
 	ret = iwl_dvm_send_cmd_pdu(priv,
-			       REPLY_BT_COEX_PROT_ENV, CMD_SYNC,
+			       REPLY_BT_COEX_PROT_ENV, 0,
 			       sizeof(env_cmd), &env_cmd);
 	if (ret)
 		IWL_ERR(priv, "failed to send BT env command\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
index 7f7a559..d4fb5ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
@@ -345,7 +345,6 @@ static int iwl_send_phy_db_cmd(struct iwl_phy_db *phy_db, u16 type,
 	struct iwl_phy_db_cmd phy_db_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = PHY_DB_CMD,
-		.flags = CMD_SYNC,
 	};
 
 	IWL_DEBUG_INFO(phy_db->trans,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 01b18fe..c57d366 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -189,10 +189,9 @@ static inline u32 iwl_rx_packet_payload_len(const struct iwl_rx_packet *pkt)
 /**
  * enum CMD_MODE - how to send the host commands ?
  *
- * @CMD_SYNC: The caller will be stalled until the fw responds to the command
  * @CMD_ASYNC: Return right away and don't wait for the response
- * @CMD_WANT_SKB: valid only with CMD_SYNC. The caller needs the buffer of the
- *	response. The caller needs to call iwl_free_resp when done.
+ * @CMD_WANT_SKB: Not valid with CMD_ASYNC. The caller needs the buffer of
+ *	the response. The caller needs to call iwl_free_resp when done.
  * @CMD_HIGH_PRIO: The command is high priority - it goes to the front of the
  *	command queue, but after other high priority commands. valid only
  *	with CMD_ASYNC.
@@ -202,7 +201,6 @@ static inline u32 iwl_rx_packet_payload_len(const struct iwl_rx_packet *pkt)
  *	(i.e. mark it as non-idle).
  */
 enum CMD_MODE {
-	CMD_SYNC		= 0,
 	CMD_ASYNC		= BIT(0),
 	CMD_WANT_SKB		= BIT(1),
 	CMD_SEND_IN_RFKILL	= BIT(2),
@@ -427,7 +425,7 @@ struct iwl_trans;
  * @send_cmd:send a host command. Must return -ERFKILL if RFkill is asserted.
  *	If RFkill is asserted in the middle of a SYNC host command, it must
  *	return -ERFKILL straight away.
- *	May sleep only if CMD_SYNC is set
+ *	May sleep only if CMD_ASYNC is not set
  * @tx: send an skb
  *	Must be atomic
  * @reclaim: free packet until ssn. Returns a list of freed packets.
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 31926fd..2b87a77 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -106,7 +106,7 @@ static const u8 iwl_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 
 static int iwl_send_bt_prio_tbl(struct iwl_mvm *mvm)
 {
-	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_PRIO_TABLE, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_PRIO_TABLE, 0,
 				    sizeof(struct iwl_bt_coex_prio_tbl_cmd),
 				    &iwl_bt_prio_tbl);
 }
@@ -565,7 +565,6 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 		.id = BT_CONFIG,
 		.len = { sizeof(*bt_cmd), },
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-		.flags = CMD_SYNC,
 	};
 	int ret;
 	u32 flags;
@@ -663,7 +662,6 @@ static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
 		.data[0] = &bt_cmd,
 		.len = { sizeof(*bt_cmd), },
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-		.flags = CMD_SYNC,
 	};
 	int ret = 0;
 
@@ -1022,7 +1020,7 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 
 	/* Don't spam the fw with the same command over and over */
 	if (memcmp(&cmd, &mvm->last_bt_ci_cmd, sizeof(cmd))) {
-		if (iwl_mvm_send_cmd_pdu(mvm, BT_COEX_CI, CMD_SYNC,
+		if (iwl_mvm_send_cmd_pdu(mvm, BT_COEX_CI, 0,
 					 sizeof(cmd), &cmd))
 			IWL_ERR(mvm, "Failed to send BT_CI cmd\n");
 		memcpy(&mvm->last_bt_ci_cmd, &cmd, sizeof(cmd));
@@ -1278,7 +1276,6 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 		.id = BT_CONFIG,
 		.len = { sizeof(*bt_cmd), },
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-		.flags = CMD_SYNC,
 	};
 
 	if (!IWL_MVM_BT_COEX_CORUNNING)
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 7694472..7dc71f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -193,8 +193,7 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 			wkc.wep_key.key_offset = data->wep_key_idx;
 		}
 
-		ret = iwl_mvm_send_cmd_pdu(mvm, WEP_KEY, CMD_SYNC,
-					   sizeof(wkc), &wkc);
+		ret = iwl_mvm_send_cmd_pdu(mvm, WEP_KEY, 0, sizeof(wkc), &wkc);
 		data->error = ret != 0;
 
 		mvm->ptk_ivlen = key->iv_len;
@@ -341,7 +340,6 @@ static int iwl_mvm_send_patterns(struct iwl_mvm *mvm,
 	struct iwl_host_cmd cmd = {
 		.id = WOWLAN_PATTERNS,
 		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
-		.flags = CMD_SYNC,
 	};
 	int i, err;
 
@@ -518,7 +516,6 @@ static int iwl_mvm_send_remote_wake_cfg(struct iwl_mvm *mvm,
 		.id = REMOTE_WAKE_CONFIG_CMD,
 		.len = { sizeof(*cfg), },
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-		.flags = CMD_SYNC,
 	};
 	int ret;
 
@@ -719,7 +716,7 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	for (i = 1; i < MAX_BINDINGS; i++)
 		quota_cmd.quotas[i].id_and_color = cpu_to_le32(FW_CTXT_INVALID);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, CMD_SYNC,
+	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, 0,
 				   sizeof(quota_cmd), &quota_cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send quota: %d\n", ret);
@@ -739,7 +736,7 @@ static int iwl_mvm_get_last_nonqos_seq(struct iwl_mvm *mvm,
 	};
 	struct iwl_host_cmd cmd = {
 		.id = NON_QOS_TX_COUNTER_CMD,
-		.flags = CMD_SYNC | CMD_WANT_SKB,
+		.flags = CMD_WANT_SKB,
 	};
 	int err;
 	u32 size;
@@ -781,7 +778,7 @@ void iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	mvmvif->seqno_valid = false;
 
-	if (iwl_mvm_send_cmd_pdu(mvm, NON_QOS_TX_COUNTER_CMD, CMD_SYNC,
+	if (iwl_mvm_send_cmd_pdu(mvm, NON_QOS_TX_COUNTER_CMD, 0,
 				 sizeof(query_cmd), &query_cmd))
 		IWL_ERR(mvm, "failed to set non-QoS seqno\n");
 }
@@ -796,7 +793,7 @@ iwl_mvm_send_wowlan_config_cmd(struct iwl_mvm *mvm,
 	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID)
 		cmd_len = sizeof(*cmd);
 
-	return iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, 0,
 				    cmd_len, cmd);
 }
 
@@ -825,7 +822,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	};
 	struct iwl_host_cmd d3_cfg_cmd = {
 		.id = D3_CONFIG_CMD,
-		.flags = CMD_SYNC | CMD_WANT_SKB,
+		.flags = CMD_WANT_SKB,
 		.data[0] = &d3_cfg_cmd_data,
 		.len[0] = sizeof(d3_cfg_cmd_data),
 	};
@@ -975,7 +972,6 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 		if (key_data.use_rsc_tsc) {
 			struct iwl_host_cmd rsc_tsc_cmd = {
 				.id = WOWLAN_TSC_RSC_PARAM,
-				.flags = CMD_SYNC,
 				.data[0] = key_data.rsc_tsc,
 				.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 				.len[0] = sizeof(*key_data.rsc_tsc),
@@ -989,7 +985,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 		if (key_data.use_tkip) {
 			ret = iwl_mvm_send_cmd_pdu(mvm,
 						   WOWLAN_TKIP_PARAM,
-						   CMD_SYNC, sizeof(tkip_cmd),
+						   0, sizeof(tkip_cmd),
 						   &tkip_cmd);
 			if (ret)
 				goto out;
@@ -1006,8 +1002,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 			kek_kck_cmd.replay_ctr = mvmvif->rekey_data.replay_ctr;
 
 			ret = iwl_mvm_send_cmd_pdu(mvm,
-						   WOWLAN_KEK_KCK_MATERIAL,
-						   CMD_SYNC,
+						   WOWLAN_KEK_KCK_MATERIAL, 0,
 						   sizeof(kek_kck_cmd),
 						   &kek_kck_cmd);
 			if (ret)
@@ -1023,7 +1018,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 
-	ret = iwl_mvm_send_proto_offload(mvm, vif, false, CMD_SYNC);
+	ret = iwl_mvm_send_proto_offload(mvm, vif, false, 0);
 	if (ret)
 		goto out;
 
@@ -1466,7 +1461,7 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	} err_info;
 	struct iwl_host_cmd cmd = {
 		.id = WOWLAN_GET_STATUSES,
-		.flags = CMD_SYNC | CMD_WANT_SKB,
+		.flags = CMD_WANT_SKB,
 	};
 	struct iwl_wowlan_status_data status;
 	struct iwl_wowlan_status *fw_status;
@@ -1492,7 +1487,7 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	}
 
 	/* only for tracing for now */
-	ret = iwl_mvm_send_cmd_pdu(mvm, OFFLOADS_QUERY_CMD, CMD_SYNC, 0, NULL);
+	ret = iwl_mvm_send_cmd_pdu(mvm, OFFLOADS_QUERY_CMD, 0, 0, NULL);
 	if (ret)
 		IWL_ERR(mvm, "failed to query offload statistics (%d)\n", ret);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 6047cfd..21793c8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -452,9 +452,9 @@ static ssize_t iwl_dbgfs_bf_params_write(struct ieee80211_vif *vif, char *buf,
 	mutex_lock(&mvm->mutex);
 	iwl_dbgfs_update_bf(vif, param, value);
 	if (param == MVM_DEBUGFS_BF_ENABLE_BEACON_FILTER && !value)
-		ret = iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC);
+		ret = iwl_mvm_disable_beacon_filter(mvm, vif, 0);
 	else
-		ret = iwl_mvm_enable_beacon_filter(mvm, vif, CMD_SYNC);
+		ret = iwl_mvm_enable_beacon_filter(mvm, vif, 0);
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index bef487b..e578129 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -681,7 +681,7 @@ static ssize_t iwl_dbgfs_fw_restart_write(struct iwl_mvm *mvm, char *buf,
 		mvm->restart_fw++;
 
 	/* take the return value to make compiler happy - it will fail anyway */
-	ret = iwl_mvm_send_cmd_pdu(mvm, REPLY_ERROR, CMD_SYNC, 0, NULL);
+	ret = iwl_mvm_send_cmd_pdu(mvm, REPLY_ERROR, 0, 0, NULL);
 
 	mutex_unlock(&mvm->mutex);
 
@@ -838,7 +838,7 @@ static ssize_t iwl_dbgfs_bcast_filters_write(struct iwl_mvm *mvm, char *buf,
 	/* send updated bcast filtering configuration */
 	if (mvm->dbgfs_bcast_filtering.override &&
 	    iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
-		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, CMD_SYNC,
+		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, 0,
 					   sizeof(cmd), &cmd);
 	mutex_unlock(&mvm->mutex);
 
@@ -910,7 +910,7 @@ static ssize_t iwl_dbgfs_bcast_filters_macs_write(struct iwl_mvm *mvm,
 	/* send updated bcast filtering configuration */
 	if (mvm->dbgfs_bcast_filtering.override &&
 	    iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
-		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, CMD_SYNC,
+		err = iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, 0,
 					   sizeof(cmd), &cmd);
 	mutex_unlock(&mvm->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 7ec2dfe..2cb7265 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -99,7 +99,7 @@ static int iwl_send_tx_ant_cfg(struct iwl_mvm *mvm, u8 valid_tx_ant)
 	};
 
 	IWL_DEBUG_FW(mvm, "select valid tx ant: %u\n", valid_tx_ant);
-	return iwl_mvm_send_cmd_pdu(mvm, TX_ANT_CONFIGURATION_CMD, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, TX_ANT_CONFIGURATION_CMD, 0,
 				    sizeof(tx_ant_cmd), &tx_ant_cmd);
 }
 
@@ -256,7 +256,7 @@ static int iwl_send_phy_cfg_cmd(struct iwl_mvm *mvm)
 	IWL_DEBUG_INFO(mvm, "Sending Phy CFG command: 0x%x\n",
 		       phy_cfg_cmd.phy_cfg);
 
-	return iwl_mvm_send_cmd_pdu(mvm, PHY_CONFIGURATION_CMD, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, PHY_CONFIGURATION_CMD, 0,
 				    sizeof(phy_cfg_cmd), &phy_cfg_cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 56cf58e..d5f50af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -685,7 +685,7 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 static int iwl_mvm_mac_ctxt_send_cmd(struct iwl_mvm *mvm,
 				     struct iwl_mac_ctx_cmd *cmd)
 {
-	int ret = iwl_mvm_send_cmd_pdu(mvm, MAC_CONTEXT_CMD, CMD_SYNC,
+	int ret = iwl_mvm_send_cmd_pdu(mvm, MAC_CONTEXT_CMD, 0,
 				       sizeof(*cmd), cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send MAC context (action:%d): %d\n",
@@ -1211,7 +1211,7 @@ int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 							   mvmvif->color));
 	cmd.action = cpu_to_le32(FW_CTXT_ACTION_REMOVE);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, MAC_CONTEXT_CMD, CMD_SYNC,
+	ret = iwl_mvm_send_cmd_pdu(mvm, MAC_CONTEXT_CMD, 0,
 				   sizeof(cmd), &cmd);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to remove MAC context: %d\n", ret);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index cc6ddc4..2f529eb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -772,7 +772,7 @@ static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		.pwr_restriction = cpu_to_le16(tx_power),
 	};
 
-	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0,
 				    sizeof(reduce_txpwr_cmd),
 				    &reduce_txpwr_cmd);
 }
@@ -836,7 +836,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_release;
 
 	/* beacon filtering */
-	ret = iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC);
+	ret = iwl_mvm_disable_beacon_filter(mvm, vif, 0);
 	if (ret)
 		goto out_remove_mac;
 
@@ -1243,7 +1243,7 @@ static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
 	if (!iwl_mvm_bcast_filter_build_cmd(mvm, &cmd))
 		return 0;
 
-	return iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, 0,
 				    sizeof(cmd), &cmd);
 }
 #else
@@ -1350,7 +1350,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
 		iwl_mvm_sf_update(mvm, vif, false);
-		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, CMD_SYNC));
+		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
 	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
 			      BSS_CHANGED_QOS)) {
 		ret = iwl_mvm_power_update_mac(mvm, vif);
@@ -1367,7 +1367,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		IWL_DEBUG_MAC80211(mvm, "cqm info_changed\n");
 		/* reset cqm events tracking */
 		mvmvif->bf_data.last_cqm_event = 0;
-		ret = iwl_mvm_update_beacon_filter(mvm, vif, false, CMD_SYNC);
+		ret = iwl_mvm_update_beacon_filter(mvm, vif, false, 0);
 		if (ret)
 			IWL_ERR(mvm, "failed to update CQM thresholds\n");
 	}
@@ -1734,13 +1734,12 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		   new_state == IEEE80211_STA_AUTHORIZED) {
 		/* enable beacon filtering */
 		if (vif->bss_conf.dtim_period)
-			WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif,
-							     CMD_SYNC));
+			WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
 		/* disable beacon filtering */
-		WARN_ON(iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC));
+		WARN_ON(iwl_mvm_disable_beacon_filter(mvm, vif, 0));
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH) {
@@ -2366,9 +2365,8 @@ static int __iwl_mvm_mac_testmode_cmd(struct iwl_mvm *mvm,
 			return -EINVAL;
 
 		if (nla_get_u32(tb[IWL_MVM_TM_ATTR_BEACON_FILTER_STATE]))
-			return iwl_mvm_enable_beacon_filter(mvm, vif,
-							    CMD_SYNC);
-		return iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC);
+			return iwl_mvm_enable_beacon_filter(mvm, vif, 0);
+		return iwl_mvm_disable_beacon_filter(mvm, vif, 0);
 	}
 
 	return -EOPNOTSUPP;
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 8dafca6..8acb9f9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -90,7 +90,7 @@ static int iwl_nvm_write_chunk(struct iwl_mvm *mvm, u16 section,
 	struct iwl_host_cmd cmd = {
 		.id = NVM_ACCESS_CMD,
 		.len = { sizeof(struct iwl_nvm_access_cmd), length },
-		.flags = CMD_SYNC | CMD_SEND_IN_RFKILL,
+		.flags = CMD_SEND_IN_RFKILL,
 		.data = { &nvm_access_cmd, data },
 		/* data may come from vmalloc, so use _DUP */
 		.dataflags = { 0, IWL_HCMD_DFL_DUP },
@@ -112,7 +112,7 @@ static int iwl_nvm_read_chunk(struct iwl_mvm *mvm, u16 section,
 	struct iwl_rx_packet *pkt;
 	struct iwl_host_cmd cmd = {
 		.id = NVM_ACCESS_CMD,
-		.flags = CMD_SYNC | CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
+		.flags = CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
 		.data = { &nvm_access_cmd, },
 	};
 	int ret, bytes_read, offset_read;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index e844f0e..cc2f7de 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1168,7 +1168,7 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm, d0i3_exit_work);
 	struct iwl_host_cmd get_status_cmd = {
 		.id = WOWLAN_GET_STATUSES,
-		.flags = CMD_SYNC | CMD_HIGH_PRIO | CMD_WANT_SKB,
+		.flags = CMD_HIGH_PRIO | CMD_WANT_SKB,
 	};
 	struct iwl_wowlan_status *status;
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index eafc517..4902f3b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -187,7 +187,7 @@ static int iwl_mvm_phy_ctxt_apply(struct iwl_mvm *mvm,
 	iwl_mvm_phy_ctxt_cmd_data(mvm, &cmd, chandef,
 				  chains_static, chains_dynamic);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, PHY_CONTEXT_CMD, CMD_SYNC,
+	ret = iwl_mvm_send_cmd_pdu(mvm, PHY_CONTEXT_CMD, 0,
 				   sizeof(struct iwl_phy_context_cmd),
 				   &cmd);
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 9985273..fc178d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -142,7 +142,7 @@ int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 	mvmvif->bf_data.ba_enabled = enable;
 	iwl_mvm_beacon_filter_set_cqm_params(mvm, vif, &cmd);
 	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
-	return iwl_mvm_beacon_filter_send_cmd(mvm, &cmd, CMD_SYNC);
+	return iwl_mvm_beacon_filter_send_cmd(mvm, &cmd, 0);
 }
 
 static void iwl_mvm_power_log(struct iwl_mvm *mvm,
@@ -456,7 +456,7 @@ static int iwl_mvm_power_send_cmd(struct iwl_mvm *mvm,
 	memcpy(&iwl_mvm_vif_from_mac80211(vif)->mac_pwr_cmd, &cmd, sizeof(cmd));
 #endif
 
-	return iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, 0,
 				    sizeof(cmd), &cmd);
 }
 
@@ -482,7 +482,7 @@ int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 			"Sending device power command with flags = 0x%X\n",
 			cmd.flags);
 
-	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_SYNC, sizeof(cmd),
+	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, 0, sizeof(cmd),
 				    &cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 35e86e0..ba68d7b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -285,7 +285,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 
 	iwl_mvm_adjust_quota_for_noa(mvm, &cmd);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, CMD_SYNC,
+	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_QUOTA_CMD, 0,
 				   sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send quota: %d\n", ret);
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index a7f6ae3..988b175 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -306,7 +306,6 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 		.id = SCAN_REQUEST_CMD,
 		.len = { 0, },
 		.data = { mvm->scan_cmd, },
-		.flags = CMD_SYNC,
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
 	};
 	struct iwl_scan_cmd *cmd = mvm->scan_cmd;
@@ -517,7 +516,7 @@ int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 				   ARRAY_SIZE(scan_abort_notif),
 				   iwl_mvm_scan_abort_notif, NULL);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_CMD, CMD_SYNC, 0, NULL);
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_CMD, 0, 0, NULL);
 	if (ret) {
 		IWL_ERR(mvm, "Couldn't send SCAN_ABORT_CMD: %d\n", ret);
 		/* mac80211's state will be cleaned in the nic_restart flow */
@@ -749,7 +748,6 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 	struct iwl_scan_offload_cfg *scan_cfg;
 	struct iwl_host_cmd cmd = {
 		.id = SCAN_OFFLOAD_CONFIG_CMD,
-		.flags = CMD_SYNC,
 	};
 	struct iwl_mvm_scan_params params = {};
 
@@ -807,7 +805,6 @@ int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 	struct iwl_scan_offload_blacklist *blacklist;
 	struct iwl_host_cmd cmd = {
 		.id = SCAN_OFFLOAD_UPDATE_PROFILES_CMD,
-		.flags = CMD_SYNC,
 		.len[1] = sizeof(*profile_cfg),
 		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 		.dataflags[1] = IWL_HCMD_DFL_NOCOPY,
@@ -898,7 +895,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		scan_req.flags |=
 			cpu_to_le16(IWL_SCAN_OFFLOAD_FLAG_EBS_ACCURATE_MODE);
 
-	return iwl_mvm_send_cmd_pdu(mvm, SCAN_OFFLOAD_REQUEST_CMD, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, SCAN_OFFLOAD_REQUEST_CMD, 0,
 				    sizeof(scan_req), &scan_req);
 }
 
@@ -907,7 +904,6 @@ static int iwl_mvm_send_sched_scan_abort(struct iwl_mvm *mvm)
 	int ret;
 	struct iwl_host_cmd cmd = {
 		.id = SCAN_OFFLOAD_ABORT_CMD,
-		.flags = CMD_SYNC,
 	};
 	u32 status;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 3e11b9d..1fb01ea 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -327,7 +327,7 @@ static int iwl_mvm_rm_sta_common(struct iwl_mvm *mvm, u8 sta_id)
 		return -EINVAL;
 	}
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, REMOVE_STA, CMD_SYNC,
+	ret = iwl_mvm_send_cmd_pdu(mvm, REMOVE_STA, 0,
 				   sizeof(rm_sta_cmd), &rm_sta_cmd);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to remove station. Id=%d\n", sta_id);
@@ -1053,12 +1053,12 @@ static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
 	cmd.sta_id = sta_id;
 
 	status = ADD_STA_SUCCESS;
-	if (cmd_flags == CMD_SYNC)
-		ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, sizeof(cmd),
-						  &cmd, &status);
-	else
+	if (cmd_flags & CMD_ASYNC)
 		ret =  iwl_mvm_send_cmd_pdu(mvm, ADD_STA_KEY, CMD_ASYNC,
 					    sizeof(cmd), &cmd);
+	else
+		ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, sizeof(cmd),
+						  &cmd, &status);
 
 	switch (status) {
 	case ADD_STA_SUCCESS:
@@ -1111,7 +1111,7 @@ static int iwl_mvm_send_sta_igtk(struct iwl_mvm *mvm,
 		       remove_key ? "removing" : "installing",
 		       igtk_cmd.sta_id);
 
-	return iwl_mvm_send_cmd_pdu(mvm, MGMT_MCAST_KEY, CMD_SYNC,
+	return iwl_mvm_send_cmd_pdu(mvm, MGMT_MCAST_KEY, 0,
 				    sizeof(igtk_cmd), &igtk_cmd);
 }
 
@@ -1198,15 +1198,15 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
 		ieee80211_get_tkip_rx_p1k(keyconf, addr, seq.tkip.iv32, p1k);
 		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, sta_id,
-					   seq.tkip.iv32, p1k, CMD_SYNC);
+					   seq.tkip.iv32, p1k, 0);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, sta_id,
-					   0, NULL, CMD_SYNC);
+					   0, NULL, 0);
 		break;
 	default:
 		ret = iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf,
-					   sta_id, 0, NULL, CMD_SYNC);
+					   sta_id, 0, NULL, 0);
 	}
 
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index a940293..80100f6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -312,7 +312,7 @@ static int iwl_mvm_time_event_send_add(struct iwl_mvm *mvm,
 				   ARRAY_SIZE(time_event_response),
 				   iwl_mvm_time_event_response, te_data);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
+	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, 0,
 					    sizeof(*te_cmd), te_cmd);
 	if (ret) {
 		IWL_ERR(mvm, "Couldn't send TIME_EVENT_CMD: %d\n", ret);
@@ -434,7 +434,7 @@ void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
 
 	IWL_DEBUG_TE(mvm, "Removing TE 0x%x\n", le32_to_cpu(time_cmd.id));
-	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
+	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, 0,
 				   sizeof(time_cmd), &time_cmd);
 	if (WARN_ON(ret))
 		return;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 39a3e03..8685615 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -409,7 +409,6 @@ void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff)
 		.id = REPLY_THERMAL_MNG_BACKOFF,
 		.len = { sizeof(u32), },
 		.data = { &backoff, },
-		.flags = CMD_SYNC,
 	};
 
 	backoff = max(backoff, mvm->thermal_throttle.min_backoff);
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index ff1b630..3846a6c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -958,7 +958,7 @@ int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, bool sync)
 		.flush_ctl = cpu_to_le16(DUMP_TX_FIFO_FLUSH),
 	};
 
-	u32 flags = sync ? CMD_SYNC : CMD_ASYNC;
+	u32 flags = sync ? 0 : CMD_ASYNC;
 
 	ret = iwl_mvm_send_cmd_pdu(mvm, TXPATH_FLUSH, flags,
 				   sizeof(flush_cmd), &flush_cmd);
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 9cd0309..b269f1e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -144,7 +144,7 @@ int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd,
 		      "cmd flags %x", cmd->flags))
 		return -EINVAL;
 
-	cmd->flags |= CMD_SYNC | CMD_WANT_SKB;
+	cmd->flags |= CMD_WANT_SKB;
 
 	ret = iwl_trans_send_cmd(mvm->trans, cmd);
 	if (ret == -ERFKILL) {
@@ -599,7 +599,7 @@ int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init)
 	struct iwl_host_cmd cmd = {
 		.id = LQ_CMD,
 		.len = { sizeof(struct iwl_lq_cmd), },
-		.flags = init ? CMD_SYNC : CMD_ASYNC,
+		.flags = init ? 0 : CMD_ASYNC,
 		.data = { lq, },
 	};
 
-- 
1.8.3.2

