Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53622 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab1EMTip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/13] iwlagn: add testmode set fixed rate command
Date: Fri, 13 May 2011 12:13:25 -0700
Message-Id: <1305314010-18073-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213911_643147_AA545D6C)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support in testmode for setting fixed rate

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   58 +++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |   11 +++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h |    7 +++
 4 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index dbe6295..432f839 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -335,6 +335,32 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
 	return tid;
 }
 
+#if defined(CONFIG_MAC80211_DEBUGFS) || defined(CONFIG_IWLWIFI_DEVICE_SVTOOL)
+static void rs_program_fix_rate(struct iwl_priv *priv,
+				struct iwl_lq_sta *lq_sta)
+{
+	struct iwl_station_priv *sta_priv =
+		container_of(lq_sta, struct iwl_station_priv, lq_sta);
+	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+
+	lq_sta->active_legacy_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
+	lq_sta->active_siso_rate   = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_mimo3_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+
+	lq_sta->dbg_fixed_rate = priv->dbg_fixed_rate;
+
+	IWL_DEBUG_RATE(priv, "sta_id %d rate 0x%X\n",
+		lq_sta->lq.sta_id, priv->dbg_fixed_rate);
+
+	if (priv->dbg_fixed_rate) {
+		rs_fill_link_cmd(NULL, lq_sta, priv->dbg_fixed_rate);
+		iwl_send_lq_cmd(lq_sta->drv, ctx, &lq_sta->lq, CMD_ASYNC,
+				false);
+	}
+}
+#endif
+
 /*
 	get the traffic load value for tid
 */
@@ -1046,7 +1072,10 @@ done:
 	/* See if there's a better rate or modulation mode to try. */
 	if (sta && sta->supp_rates[sband->band])
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
-
+#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+	if (priv->dbg_fixed_rate != lq_sta->dbg_fixed_rate)
+		rs_program_fix_rate(priv, lq_sta);
+#endif
 	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist)
 		rs_bt_update_lq(priv, ctx, lq_sta);
 }
@@ -2871,6 +2900,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 	lq_sta->is_agg = 0;
 
+	priv->dbg_fixed_rate = 0;
 #ifdef CONFIG_MAC80211_DEBUGFS
 	lq_sta->dbg_fixed_rate = 0;
 #endif
@@ -3045,7 +3075,6 @@ static void rs_free_sta(void *priv_r, struct ieee80211_sta *sta,
 	IWL_DEBUG_RATE(priv, "leave\n");
 }
 
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 static int open_file_generic(struct inode *inode, struct file *file)
 {
@@ -3070,6 +3099,7 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 			IWL_DEBUG_RATE(priv, "Fixed rate ON\n");
 		} else {
 			lq_sta->dbg_fixed_rate = 0;
+			priv->dbg_fixed_rate = 0;
 			IWL_ERR(priv,
 			    "Invalid antenna selection 0x%X, Valid is 0x%X\n",
 			    ant_sel_tx, valid_tx_ant);
@@ -3088,9 +3118,7 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 	char buf[64];
 	int buf_size;
 	u32 parsed_rate;
-	struct iwl_station_priv *sta_priv =
-		container_of(lq_sta, struct iwl_station_priv, lq_sta);
-	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+
 
 	priv = lq_sta->drv;
 	memset(buf, 0, sizeof(buf));
@@ -3099,23 +3127,11 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 		return -EFAULT;
 
 	if (sscanf(buf, "%x", &parsed_rate) == 1)
-		lq_sta->dbg_fixed_rate = parsed_rate;
+		priv->dbg_fixed_rate = lq_sta->dbg_fixed_rate = parsed_rate;
 	else
-		lq_sta->dbg_fixed_rate = 0;
-
-	lq_sta->active_legacy_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
-	lq_sta->active_siso_rate   = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-	lq_sta->active_mimo3_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-
-	IWL_DEBUG_RATE(priv, "sta_id %d rate 0x%X\n",
-		lq_sta->lq.sta_id, lq_sta->dbg_fixed_rate);
+		priv->dbg_fixed_rate = lq_sta->dbg_fixed_rate = 0;
 
-	if (lq_sta->dbg_fixed_rate) {
-		rs_fill_link_cmd(NULL, lq_sta, lq_sta->dbg_fixed_rate);
-		iwl_send_lq_cmd(lq_sta->drv, ctx, &lq_sta->lq, CMD_ASYNC,
-				false);
-	}
+	rs_program_fix_rate(priv, lq_sta);
 
 	return count;
 }
@@ -3143,7 +3159,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			lq_sta->total_failed, lq_sta->total_success,
 			lq_sta->active_legacy_rate);
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
-			lq_sta->dbg_fixed_rate);
+			priv->dbg_fixed_rate);
 	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
 	    (priv->hw_params.valid_tx_ant & ANT_A) ? "ANT_A," : "",
 	    (priv->hw_params.valid_tx_ant & ANT_B) ? "ANT_B," : "",
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 12fb2f4..ab29ab5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1521,6 +1521,8 @@ struct iwl_priv {
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 	struct iwl_testmode_trace testmode_trace;
 #endif
+	u32 dbg_fixed_rate;
+
 }; /*iwl_priv */
 
 static inline void iwl_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index e77ccaa..69b7e6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -103,6 +103,7 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 	[IWL_TM_ATTR_TRACE_ADDR] = { .type = NLA_UNSPEC, },
 	[IWL_TM_ATTR_TRACE_DATA] = { .type = NLA_UNSPEC, },
 
+	[IWL_TM_ATTR_FIXRATE] = { .type = NLA_U32, },
 };
 
 /*
@@ -443,6 +444,15 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			return -EFAULT;
 		break;
 
+	case IWL_TM_CMD_APP2DEV_FIXRATE_REQ:
+		if (!tb[IWL_TM_ATTR_FIXRATE]) {
+			IWL_DEBUG_INFO(priv,
+				       "Error finding fixrate setting\n");
+			return -ENOMSG;
+		}
+		priv->dbg_fixed_rate = nla_get_u32(tb[IWL_TM_ATTR_FIXRATE]);
+		break;
+
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode driver command ID\n");
 		return -ENOSYS;
@@ -607,6 +617,7 @@ int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	case IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB:
 	case IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW:
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
+	case IWL_TM_CMD_APP2DEV_FIXRATE_REQ:
 		IWL_DEBUG_INFO(priv, "testmode cmd to driver\n");
 		result = iwl_testmode_driver(hw, tb);
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 4171d29..a88085e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -89,6 +89,7 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB,
 	IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW,
 	IWL_TM_CMD_APP2DEV_GET_EEPROM,
+	IWL_TM_CMD_APP2DEV_FIXRATE_REQ,
 	/* if there is other new command for the driver layer operation,
 	 * append them here */
 
@@ -167,6 +168,12 @@ enum iwl_tm_attr_t {
 	IWL_TM_ATTR_TRACE_ADDR,
 	IWL_TM_ATTR_TRACE_DATA,
 
+	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_FIXRATE_REQ,
+	 * The mandatory fields are:
+	 * IWL_TM_ATTR_FIXRATE for the fixed rate
+	 */
+	IWL_TM_ATTR_FIXRATE,
+
 	IWL_TM_ATTR_MAX,
 };
 
-- 
1.7.0.4

