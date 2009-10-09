Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761393AbZJIUW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/17] iwlwifi/iwl3945: unify rts_tx_cmd_flag
Date: Fri,  9 Oct 2009 13:20:30 -0700
Message-Id: <1255119634-3060-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 and 4965 share the functionality for setting RTS and CTS to
the tx_cmd. Unify these functions and move the common
functionality to core.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   14 +-------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   17 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 +--------
 5 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index cee03e7..1372ce4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2826,6 +2826,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.get_hcmd_size = iwl3945_get_hcmd_size,
 	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
+	.rts_tx_cmd_flag = iwlcore_rts_tx_cmd_flag,
 };
 
 static struct iwl_ops iwl3945_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c9d9016..6d77039 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -484,18 +484,6 @@ static void iwl4965_gain_computation(struct iwl_priv *priv,
 	data->beacon_count = 0;
 }
 
-static void iwl4965_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
-			__le32 *tx_flags)
-{
-	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
-		*tx_flags |= TX_CMD_FLG_RTS_MSK;
-		*tx_flags &= ~TX_CMD_FLG_CTS_MSK;
-	} else if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-		*tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-		*tx_flags |= TX_CMD_FLG_CTS_MSK;
-	}
-}
-
 static void iwl4965_bg_txpower_work(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
@@ -2212,7 +2200,7 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
 	.chain_noise_reset = iwl4965_chain_noise_reset,
 	.gain_computation = iwl4965_gain_computation,
-	.rts_tx_cmd_flag = iwl4965_rts_tx_cmd_flag,
+	.rts_tx_cmd_flag = iwlcore_rts_tx_cmd_flag,
 	.calc_rssi = iwl4965_calc_rssi,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c40c7e2..1e0021f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -604,6 +604,23 @@ void iwlcore_free_geos(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwlcore_free_geos);
 
+/*
+ *  iwlcore_rts_tx_cmd_flag: Set rts/cts. 3945 and 4965 only share this
+ *  function.
+ */
+void iwlcore_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
+				__le32 *tx_flags)
+{
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
+		*tx_flags |= TX_CMD_FLG_RTS_MSK;
+		*tx_flags &= ~TX_CMD_FLG_CTS_MSK;
+	} else if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
+		*tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+		*tx_flags |= TX_CMD_FLG_CTS_MSK;
+	}
+}
+EXPORT_SYMBOL(iwlcore_rts_tx_cmd_flag);
+
 static bool is_single_rx_stream(struct iwl_priv *priv)
 {
 	return !priv->current_ht_config.is_ht ||
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3679c2c..cec673b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -329,6 +329,8 @@ int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
 int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
+void iwlcore_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
+				__le32 *tx_flags);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 66da441..f4d4353 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -408,7 +408,6 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
 	__le32 tx_flags = tx->tx_flags;
 	__le16 fc = hdr->frame_control;
-	u8 rc_flags = info->control.rates[0].flags;
 
 	tx->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
@@ -435,13 +434,7 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
-	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
-		tx_flags |= TX_CMD_FLG_RTS_MSK;
-		tx_flags &= ~TX_CMD_FLG_CTS_MSK;
-	} else if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-		tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-		tx_flags |= TX_CMD_FLG_CTS_MSK;
-	}
+	priv->cfg->ops->utils->rts_tx_cmd_flag(info, &tx_flags);
 
 	if ((tx_flags & TX_CMD_FLG_RTS_MSK) || (tx_flags & TX_CMD_FLG_CTS_MSK))
 		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
-- 
1.5.6.3

