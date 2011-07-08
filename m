Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab1GHQUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:41 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Kenny Hsu <kenny.hsu@intel.com>
Subject: [PATCH 20/21] iwlagn: separate and enhance the fixed rate from
Date: Fri,  8 Jul 2011 08:46:28 -0700
Message-Id: <1310139989-27661-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182055_033495_DE69A522)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For testing purpose, we need better control of msc from user application.
Separate the fixed_rate between debugfs and testmode and enforce it.

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   28 ++++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c |    2 +-
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 85e0828..ebcd13b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -336,6 +336,12 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
+/**
+ * Program the device to use fixed rate for frame transmit
+ * This is for debugging/testing only
+ * once the device start use fixed rate, we need to reload the module
+ * to being back the normal operation.
+ */
 static void rs_program_fix_rate(struct iwl_priv *priv,
 				struct iwl_lq_sta *lq_sta)
 {
@@ -348,13 +354,15 @@ static void rs_program_fix_rate(struct iwl_priv *priv,
 	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 	lq_sta->active_mimo3_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
-	lq_sta->dbg_fixed_rate = priv->dbg_fixed_rate;
+	/* testmode has higher priority to overwirte the fixed rate */
+	if (priv->tm_fixed_rate)
+		lq_sta->dbg_fixed_rate = priv->tm_fixed_rate;
 
 	IWL_DEBUG_RATE(priv, "sta_id %d rate 0x%X\n",
-		lq_sta->lq.sta_id, priv->dbg_fixed_rate);
+		lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
 
-	if (priv->dbg_fixed_rate) {
-		rs_fill_link_cmd(NULL, lq_sta, priv->dbg_fixed_rate);
+	if (lq_sta->dbg_fixed_rate) {
+		rs_fill_link_cmd(NULL, lq_sta, lq_sta->dbg_fixed_rate);
 		iwl_send_lq_cmd(lq_sta->drv, ctx, &lq_sta->lq, CMD_ASYNC,
 				false);
 	}
@@ -1073,7 +1081,8 @@ done:
 	if (sta && sta->supp_rates[sband->band])
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
 #ifdef CONFIG_MAC80211_DEBUGFS
-	if (priv->dbg_fixed_rate != lq_sta->dbg_fixed_rate)
+	if ((priv->tm_fixed_rate) &&
+	    (priv->tm_fixed_rate != lq_sta->dbg_fixed_rate))
 		rs_program_fix_rate(priv, lq_sta);
 #endif
 	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist)
@@ -2896,7 +2905,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 	lq_sta->is_agg = 0;
 
-	priv->dbg_fixed_rate = 0;
+	priv->tm_fixed_rate = 0;
 #ifdef CONFIG_MAC80211_DEBUGFS
 	lq_sta->dbg_fixed_rate = 0;
 #endif
@@ -3095,7 +3104,6 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 			IWL_DEBUG_RATE(priv, "Fixed rate ON\n");
 		} else {
 			lq_sta->dbg_fixed_rate = 0;
-			priv->dbg_fixed_rate = 0;
 			IWL_ERR(priv,
 			    "Invalid antenna selection 0x%X, Valid is 0x%X\n",
 			    ant_sel_tx, valid_tx_ant);
@@ -3123,9 +3131,9 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 		return -EFAULT;
 
 	if (sscanf(buf, "%x", &parsed_rate) == 1)
-		priv->dbg_fixed_rate = lq_sta->dbg_fixed_rate = parsed_rate;
+		lq_sta->dbg_fixed_rate = parsed_rate;
 	else
-		priv->dbg_fixed_rate = lq_sta->dbg_fixed_rate = 0;
+		lq_sta->dbg_fixed_rate = 0;
 
 	rs_program_fix_rate(priv, lq_sta);
 
@@ -3155,7 +3163,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			lq_sta->total_failed, lq_sta->total_success,
 			lq_sta->active_legacy_rate);
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
-			priv->dbg_fixed_rate);
+			lq_sta->dbg_fixed_rate);
 	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
 	    (priv->hw_params.valid_tx_ant & ANT_A) ? "ANT_A," : "",
 	    (priv->hw_params.valid_tx_ant & ANT_B) ? "ANT_B," : "",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index f77f7e4..0394d11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -436,6 +436,16 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	if (ieee80211_is_data(fc)) {
 		tx_cmd->initial_rate_index = 0;
 		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
+		if (priv->tm_fixed_rate) {
+			/*
+			 * rate overwrite by testmode
+			 * we not only send lq command to change rate
+			 * we also re-enforce per data pkt base.
+			 */
+			tx_cmd->tx_flags &= ~TX_CMD_FLG_STA_RATE_MSK;
+			memcpy(&tx_cmd->rate_n_flags, &priv->tm_fixed_rate,
+			       sizeof(tx_cmd->rate_n_flags));
+		}
 		return;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fa0827f..a0cca02 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1605,7 +1605,7 @@ struct iwl_priv {
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 	struct iwl_testmode_trace testmode_trace;
 #endif
-	u32 dbg_fixed_rate;
+	u32 tm_fixed_rate;
 
 }; /*iwl_priv */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index ed9bd91..a322f5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -454,7 +454,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 				       "Error finding fixrate setting\n");
 			return -ENOMSG;
 		}
-		priv->dbg_fixed_rate = nla_get_u32(tb[IWL_TM_ATTR_FIXRATE]);
+		priv->tm_fixed_rate = nla_get_u32(tb[IWL_TM_ATTR_FIXRATE]);
 		break;
 
 	default:
-- 
1.7.0.4

