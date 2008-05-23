Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27647 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061AbYEWCLQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:16 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: remove 4956 form iwl4965_tx_cmd
Date: Fri, 23 May 2008 10:08:51 +0800
Message-Id: <1211508569-3163-14-git-send-email-yi.zhu@intel.com> (sfid-20080523_041127_533620_76FF8994)
In-Reply-To: <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames iwl4965_tx_cmd to iwl_tx_cmd and cleans
collateral code.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    3 +--
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 5 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index aeaf5f7..02bbe04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1053,7 +1053,6 @@ int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
 	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
-	priv->hw_params.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	if (priv->cfg->mod_params->amsdu_size_8K)
@@ -1943,7 +1942,7 @@ void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 			      struct ieee80211_hdr *hdr, int sta_id,
 			      int is_hcca)
 {
-	struct iwl4965_tx_cmd *tx = &cmd->cmd.tx;
+	struct iwl_tx_cmd *tx = &cmd->cmd.tx;
 	u8 rts_retry_limit = 0;
 	u8 data_retry_limit = 0;
 	u16 fc = le16_to_cpu(hdr->frame_control);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 72d655c..d155247 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -298,7 +298,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
 	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
-	priv->hw_params.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	if (priv->cfg->mod_params->amsdu_size_8K)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 350af1b..dd84326 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1196,7 +1196,7 @@ struct iwl4965_dram_scratch {
 /*
  * REPLY_TX = 0x1c (command)
  */
-struct iwl4965_tx_cmd {
+struct iwl_tx_cmd {
 	/*
 	 * MPDU byte count:
 	 * MAC header (24/26/30/32 bytes) + 2 bytes pad if 26/30 header size,
@@ -2135,7 +2135,7 @@ struct iwl4965_scan_cmd {
 
 	/* For active scans (set to all-0s for passive scans).
 	 * Does not include payload.  Must specify Tx rate; no rate scaling. */
-	struct iwl4965_tx_cmd tx_cmd;
+	struct iwl_tx_cmd tx_cmd;
 
 	/* For directed active scans (set to all-0s otherwise) */
 	struct iwl4965_ssid_ie direct_scan[PROBE_OPTION_MAX];
@@ -2232,7 +2232,7 @@ struct iwl4965_beacon_notif {
  * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
  */
 struct iwl4965_tx_beacon_cmd {
-	struct iwl4965_tx_cmd tx;
+	struct iwl_tx_cmd tx;
 	__le16 tim_idx;
 	u8 tim_size;
 	u8 reserved1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 565d7dc..ddb950e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -329,7 +329,7 @@ struct iwl_cmd {
 		struct iwl4965_rxon_time_cmd rxon_time;
 		struct iwl4965_powertable_cmd powertable;
 		struct iwl4965_qosparam_cmd qosparam;
-		struct iwl4965_tx_cmd tx;
+		struct iwl_tx_cmd tx;
 		struct iwl4965_tx_beacon_cmd tx_beacon;
 		struct iwl4965_rxon_assoc_cmd rxon_assoc;
 		u8 *indirect;
@@ -573,7 +573,6 @@ struct iwl_sensitivity_ranges {
 /**
  * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
- * @tx_cmd_len: Size of Tx command (but not including frame itself)
  * @tx/rx_chains_num: Number of TX/RX chains
  * @valid_tx/rx_ant: usable antennas
  * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
@@ -590,7 +589,6 @@ struct iwl_sensitivity_ranges {
  */
 struct iwl_hw_params {
 	u16 max_txq_num;
-	u16 tx_cmd_len;
 	u8  tx_chains_num;
 	u8  rx_chains_num;
 	u8  valid_tx_ant;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 88032cc..6d5b58f 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1740,7 +1740,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	 * of the MAC header (device reads on dword boundaries).
 	 * We'll tell device about this padding later.
 	 */
-	len = priv->hw_params.tx_cmd_len +
+	len = sizeof(struct iwl_tx_cmd) +
 		sizeof(struct iwl_cmd_header) + hdr_len;
 
 	len_org = len;
@@ -1789,7 +1789,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	iwl_update_tx_stats(priv, fc, len);
 
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
-		offsetof(struct iwl4965_tx_cmd, scratch);
+		offsetof(struct iwl_tx_cmd, scratch);
 	out_cmd->cmd.tx.dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	out_cmd->cmd.tx.dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
 
-- 
1.5.3.6

