Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:62373 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbaEOREy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:04:54 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so1390444wes.36
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:04:53 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/24] iwlwifi: add missing trailing newlines to debug messages
Date: Thu, 15 May 2014 20:04:18 +0300
Message-Id: <1400173481-9047-1-git-send-email-egrumbach@gmail.com> (sfid-20140515_190459_295039_E7F56482)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All messages should have a trailing newline, add all the
missing ones. Also make all messages constants, replacing
the single one that pointlessly used a variable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c     | 13 ++++++-------
 drivers/net/wireless/iwlwifi/dvm/power.c    |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c       |  8 ++++----
 drivers/net/wireless/iwlwifi/dvm/rxon.c     |  2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c      |  4 ++--
 drivers/net/wireless/iwlwifi/dvm/tx.c       | 20 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-phy-db.c   |  8 ++++----
 drivers/net/wireless/iwlwifi/iwl-trans.h    | 10 +++++-----
 drivers/net/wireless/iwlwifi/mvm/coex.c     |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/rs.c       |  8 ++++----
 drivers/net/wireless/iwlwifi/pcie/drv.c     | 14 +++++++-------
 12 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 6a00353..7bfd741 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -987,7 +987,7 @@ static void iwl_bg_restart(struct work_struct *data)
 			ieee80211_restart_hw(priv->hw);
 		else
 			IWL_ERR(priv,
-				"Cannot request restart before registrating with mac80211");
+				"Cannot request restart before registrating with mac80211\n");
 	} else {
 		WARN_ON(1);
 	}
@@ -1127,7 +1127,6 @@ static void iwl_option_config(struct iwl_priv *priv)
 static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 {
 	struct iwl_nvm_data *data = priv->nvm_data;
-	char *debug_msg;
 
 	if (data->sku_cap_11n_enable &&
 	    !priv->cfg->ht_params) {
@@ -1141,8 +1140,8 @@ static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 		return -EINVAL;
 	}
 
-	debug_msg = "Device SKU: 24GHz %s %s, 52GHz %s %s, 11.n %s %s\n";
-	IWL_DEBUG_INFO(priv, debug_msg,
+	IWL_DEBUG_INFO(priv,
+		       "Device SKU: 24GHz %s %s, 52GHz %s %s, 11.n %s %s\n",
 		       data->sku_cap_band_24GHz_enable ? "" : "NOT", "enabled",
 		       data->sku_cap_band_52GHz_enable ? "" : "NOT", "enabled",
 		       data->sku_cap_11n_enable ? "" : "NOT", "enabled");
@@ -1350,7 +1349,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	iwl_set_hw_params(priv);
 
 	if (!(priv->nvm_data->sku_cap_ipan_enable)) {
-		IWL_DEBUG_INFO(priv, "Your EEPROM disabled PAN");
+		IWL_DEBUG_INFO(priv, "Your EEPROM disabled PAN\n");
 		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 		/*
 		 * if not PAN, then don't support P2P -- might be a uCode
@@ -2019,10 +2018,10 @@ void iwlagn_lift_passive_no_rx(struct iwl_priv *priv)
 
 	for (mq = 0; mq < IWLAGN_FIRST_AMPDU_QUEUE; mq++) {
 		if (!test_bit(mq, &priv->transport_queue_stop)) {
-			IWL_DEBUG_TX_QUEUES(priv, "Wake queue %d", mq);
+			IWL_DEBUG_TX_QUEUES(priv, "Wake queue %d\n", mq);
 			ieee80211_wake_queue(priv->hw, mq);
 		} else {
-			IWL_DEBUG_TX_QUEUES(priv, "Don't wake queue %d", mq);
+			IWL_DEBUG_TX_QUEUES(priv, "Don't wake queue %d\n", mq);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c b/drivers/net/wireless/iwlwifi/dvm/power.c
index b4e6141..6ad7cb6 100644
--- a/drivers/net/wireless/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/iwlwifi/dvm/power.c
@@ -361,7 +361,7 @@ int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
 
 		memcpy(&priv->power_data.sleep_cmd, cmd, sizeof(*cmd));
 	} else
-		IWL_ERR(priv, "set power fail, ret = %d", ret);
+		IWL_ERR(priv, "set power fail, ret = %d\n", ret);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index aa773a2..6fba037 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -1453,7 +1453,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
 		break;
 	default:
-		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
+		IWL_ERR(priv, "Invalid BT load %d\n", priv->bt_traffic_load);
 		break;
 	}
 
@@ -1628,7 +1628,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 		break;
 	default:
-		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
+		IWL_ERR(priv, "Invalid BT load %d\n", priv->bt_traffic_load);
 		break;
 	}
 
@@ -1799,7 +1799,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 			tbl->action = IWL_MIMO2_SWITCH_SISO_A;
 		break;
 	default:
-		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
+		IWL_ERR(priv, "Invalid BT load %d\n", priv->bt_traffic_load);
 		break;
 	}
 
@@ -1969,7 +1969,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 			tbl->action = IWL_MIMO3_SWITCH_SISO_A;
 		break;
 	default:
-		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
+		IWL_ERR(priv, "Invalid BT load %d\n", priv->bt_traffic_load);
 		break;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 503a81e..623814d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -823,7 +823,7 @@ static int iwl_check_rxon_cmd(struct iwl_priv *priv,
 
 	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
 			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK)) {
-		IWL_WARN(priv, "CCK and auto detect");
+		IWL_WARN(priv, "CCK and auto detect\n");
 		errors |= BIT(8);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index 9cdd91c..2763b9c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -39,7 +39,7 @@ static int iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 	lockdep_assert_held(&priv->sta_lock);
 
 	if (sta_id >= IWLAGN_STATION_COUNT) {
-		IWL_ERR(priv, "invalid sta_id %u", sta_id);
+		IWL_ERR(priv, "invalid sta_id %u\n", sta_id);
 		return -EINVAL;
 	}
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE))
@@ -165,7 +165,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	iwl_free_resp(&cmd);
 
 	if (cmd.handler_status)
-		IWL_ERR(priv, "%s - error in the CMD response %d", __func__,
+		IWL_ERR(priv, "%s - error in the CMD response %d\n", __func__,
 			cmd.handler_status);
 
 	return cmd.handler_status;
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 398dd096..5b88ca7 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -402,10 +402,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		/* aggregation is on for this <sta,tid> */
 		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
 		    tid_data->agg.state != IWL_AGG_ON) {
-			IWL_ERR(priv, "TX_CTL_AMPDU while not in AGG:"
-				" Tx flags = 0x%08x, agg.state = %d",
+			IWL_ERR(priv,
+				"TX_CTL_AMPDU while not in AGG: Tx flags = 0x%08x, agg.state = %d\n",
 				info->flags, tid_data->agg.state);
-			IWL_ERR(priv, "sta_id = %d, tid = %d seq_num = %d",
+			IWL_ERR(priv, "sta_id = %d, tid = %d seq_num = %d\n",
 				sta_id, tid,
 				IEEE80211_SEQ_TO_SN(tid_data->seq_number));
 			goto drop_unlock_sta;
@@ -416,7 +416,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		 */
 		if (WARN_ONCE(tid_data->agg.state != IWL_AGG_ON &&
 			      tid_data->agg.state != IWL_AGG_OFF,
-		    "Tx while agg.state = %d", tid_data->agg.state))
+			      "Tx while agg.state = %d\n", tid_data->agg.state))
 			goto drop_unlock_sta;
 
 		seq_number = tid_data->seq_number;
@@ -778,8 +778,8 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 		/* There are no packets for this RA / TID in the HW any more */
 		if (tid_data->agg.ssn == tid_data->next_reclaimed) {
 			IWL_DEBUG_TX_QUEUES(priv,
-				"Can continue DELBA flow ssn = next_recl ="
-				" %d", tid_data->next_reclaimed);
+				"Can continue DELBA flow ssn = next_recl = %d\n",
+				tid_data->next_reclaimed);
 			iwl_trans_txq_disable(priv->trans,
 					      tid_data->agg.txq_id);
 			iwlagn_dealloc_agg_txq(priv, tid_data->agg.txq_id);
@@ -791,8 +791,8 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 		/* There are no packets for this RA / TID in the HW any more */
 		if (tid_data->agg.ssn == tid_data->next_reclaimed) {
 			IWL_DEBUG_TX_QUEUES(priv,
-				"Can continue ADDBA flow ssn = next_recl ="
-				" %d", tid_data->next_reclaimed);
+				"Can continue ADDBA flow ssn = next_recl = %d\n",
+				tid_data->next_reclaimed);
 			tid_data->agg.state = IWL_AGG_STARTING;
 			ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
 		}
@@ -1216,8 +1216,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			    ctx->vif->type == NL80211_IFTYPE_STATION) {
 				/* block and stop all queues */
 				priv->passive_no_rx = true;
-				IWL_DEBUG_TX_QUEUES(priv, "stop all queues: "
-						    "passive channel");
+				IWL_DEBUG_TX_QUEUES(priv,
+					"stop all queues: passive channel\n");
 				ieee80211_stop_queues(priv->hw);
 
 				IWL_DEBUG_TX_REPLY(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
index b761ac4..7f7a559 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
@@ -393,13 +393,13 @@ static int iwl_phy_db_send_all_channel_groups(
 					  entry->data);
 		if (err) {
 			IWL_ERR(phy_db->trans,
-				"Can't SEND phy_db section %d (%d), err %d",
+				"Can't SEND phy_db section %d (%d), err %d\n",
 				type, i, err);
 			return err;
 		}
 
 		IWL_DEBUG_INFO(phy_db->trans,
-			       "Sent PHY_DB HCMD, type = %d num = %d",
+			       "Sent PHY_DB HCMD, type = %d num = %d\n",
 			       type, i);
 	}
 
@@ -451,7 +451,7 @@ int iwl_send_phy_db_data(struct iwl_phy_db *phy_db)
 						 IWL_NUM_PAPD_CH_GROUPS);
 	if (err) {
 		IWL_ERR(phy_db->trans,
-			"Cannot send channel specific PAPD groups");
+			"Cannot send channel specific PAPD groups\n");
 		return err;
 	}
 
@@ -461,7 +461,7 @@ int iwl_send_phy_db_data(struct iwl_phy_db *phy_db)
 						 IWL_NUM_TXP_CH_GROUPS);
 	if (err) {
 		IWL_ERR(phy_db->trans,
-			"Cannot send channel specific TX power groups");
+			"Cannot send channel specific TX power groups\n");
 		return err;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 84ad48d..01b18fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -696,7 +696,7 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 		return -EIO;
 
 	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE)) {
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 		return -EIO;
 	}
 
@@ -738,7 +738,7 @@ static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		return -EIO;
 
 	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 
 	return trans->ops->tx(trans, skb, dev_cmd, queue);
 }
@@ -747,7 +747,7 @@ static inline void iwl_trans_reclaim(struct iwl_trans *trans, int queue,
 				     int ssn, struct sk_buff_head *skbs)
 {
 	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 
 	trans->ops->reclaim(trans, queue, ssn, skbs);
 }
@@ -764,7 +764,7 @@ static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 	might_sleep();
 
 	if (unlikely((trans->state != IWL_TRANS_FW_ALIVE)))
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 
 	trans->ops->txq_enable(trans, queue, fifo, sta_id, tid,
 				 frame_limit, ssn);
@@ -781,7 +781,7 @@ static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
 						u32 txq_bm)
 {
 	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 
 	return trans->ops->wait_tx_queue_empty(trans, txq_bm);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 4284672..31926fd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1024,7 +1024,7 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 	if (memcmp(&cmd, &mvm->last_bt_ci_cmd, sizeof(cmd))) {
 		if (iwl_mvm_send_cmd_pdu(mvm, BT_COEX_CI, CMD_SYNC,
 					 sizeof(cmd), &cmd))
-			IWL_ERR(mvm, "Failed to send BT_CI cmd");
+			IWL_ERR(mvm, "Failed to send BT_CI cmd\n");
 		memcpy(&mvm->last_bt_ci_cmd, &cmd, sizeof(cmd));
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 6713b87..18d77e4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1364,7 +1364,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 	}
 
 	if (changes & BSS_CHANGED_CQM) {
-		IWL_DEBUG_MAC80211(mvm, "cqm info_changed");
+		IWL_DEBUG_MAC80211(mvm, "cqm info_changed\n");
 		/* reset cqm events tracking */
 		mvmvif->bf_data.last_cqm_event = 0;
 		ret = iwl_mvm_update_beacon_filter(mvm, vif, false, CMD_SYNC);
@@ -1373,7 +1373,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 	}
 
 	if (changes & BSS_CHANGED_ARP_FILTER) {
-		IWL_DEBUG_MAC80211(mvm, "arp filter changed");
+		IWL_DEBUG_MAC80211(mvm, "arp filter changed\n");
 		iwl_mvm_configure_bcast_filter(mvm, vif);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 10ad1dc..306a6ca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1866,7 +1866,7 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	if (lq_sta->dbg_fixed_txp_reduction <= TPC_MAX_REDUCTION) {
-		IWL_DEBUG_RATE(mvm, "fixed tpc: %d",
+		IWL_DEBUG_RATE(mvm, "fixed tpc: %d\n",
 			       lq_sta->dbg_fixed_txp_reduction);
 		lq_sta->lq.reduced_tpc = lq_sta->dbg_fixed_txp_reduction;
 		return cur != lq_sta->dbg_fixed_txp_reduction;
@@ -1883,7 +1883,7 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 
 	if (!rs_tpc_allowed(mvm, vif, rate, band)) {
 		IWL_DEBUG_RATE(mvm,
-			       "tpc is not allowed. remove txp restrictions");
+			       "tpc is not allowed. remove txp restrictions\n");
 		lq_sta->lq.reduced_tpc = TPC_NO_REDUCTION;
 		return cur != TPC_NO_REDUCTION;
 	}
@@ -1909,12 +1909,12 @@ static bool rs_tpc_perform(struct iwl_mvm *mvm,
 
 	/* override actions if we are on the edge */
 	if (weak == TPC_INVALID && action == TPC_ACTION_DECREASE) {
-		IWL_DEBUG_RATE(mvm, "already in lowest txp, stay");
+		IWL_DEBUG_RATE(mvm, "already in lowest txp, stay\n");
 		action = TPC_ACTION_STAY;
 	} else if (strong == TPC_INVALID &&
 		   (action == TPC_ACTION_INCREASE ||
 		    action == TPC_ACTION_NO_RESTIRCTION)) {
-		IWL_DEBUG_RATE(mvm, "already in highest txp, stay");
+		IWL_DEBUG_RATE(mvm, "already in highest txp, stay\n");
 		action = TPC_ACTION_STAY;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 3d1d57f..7091a18 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -417,7 +417,7 @@ static u64 splx_get_pwr_limit(struct iwl_trans *trans, union acpi_object *splx)
 	    splx->package.count != 2 ||
 	    splx->package.elements[0].type != ACPI_TYPE_INTEGER ||
 	    splx->package.elements[0].integer.value != 0) {
-		IWL_ERR(trans, "Unsupported splx structure");
+		IWL_ERR(trans, "Unsupported splx structure\n");
 		return 0;
 	}
 
@@ -426,14 +426,14 @@ static u64 splx_get_pwr_limit(struct iwl_trans *trans, union acpi_object *splx)
 	    limits->package.count < 2 ||
 	    limits->package.elements[0].type != ACPI_TYPE_INTEGER ||
 	    limits->package.elements[1].type != ACPI_TYPE_INTEGER) {
-		IWL_ERR(trans, "Invalid limits element");
+		IWL_ERR(trans, "Invalid limits element\n");
 		return 0;
 	}
 
 	domain_type = &limits->package.elements[0];
 	power_limit = &limits->package.elements[1];
 	if (!(domain_type->integer.value & SPL_DOMAINTYPE_WIFI)) {
-		IWL_DEBUG_INFO(trans, "WiFi power is not limited");
+		IWL_DEBUG_INFO(trans, "WiFi power is not limited\n");
 		return 0;
 	}
 
@@ -450,26 +450,26 @@ static void set_dflt_pwr_limit(struct iwl_trans *trans, struct pci_dev *pdev)
 	pxsx_handle = ACPI_HANDLE(&pdev->dev);
 	if (!pxsx_handle) {
 		IWL_DEBUG_INFO(trans,
-			       "Could not retrieve root port ACPI handle");
+			       "Could not retrieve root port ACPI handle\n");
 		return;
 	}
 
 	/* Get the method's handle */
 	status = acpi_get_handle(pxsx_handle, (acpi_string)SPL_METHOD, &handle);
 	if (ACPI_FAILURE(status)) {
-		IWL_DEBUG_INFO(trans, "SPL method not found");
+		IWL_DEBUG_INFO(trans, "SPL method not found\n");
 		return;
 	}
 
 	/* Call SPLC with no arguments */
 	status = acpi_evaluate_object(handle, NULL, NULL, &splx);
 	if (ACPI_FAILURE(status)) {
-		IWL_ERR(trans, "SPLC invocation failed (0x%x)", status);
+		IWL_ERR(trans, "SPLC invocation failed (0x%x)\n", status);
 		return;
 	}
 
 	trans->dflt_pwr_limit = splx_get_pwr_limit(trans, splx.pointer);
-	IWL_DEBUG_INFO(trans, "Default power limit set to %lld",
+	IWL_DEBUG_INFO(trans, "Default power limit set to %lld\n",
 		       trans->dflt_pwr_limit);
 	kfree(splx.pointer);
 }
-- 
1.8.3.2

