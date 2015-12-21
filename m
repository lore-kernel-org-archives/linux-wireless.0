Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbbLUUwL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:11 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 24/45] iwlwifi: pcie: allow to pretend to have Tx CSUM for debug
Date: Mon, 21 Dec 2015 22:50:25 +0200
Message-Id: <1450731046-2796-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215216_892844_4662C35D)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to configure the driver to pretend to have TX CSUM
offload support. This will be useful to test the TSO flows
that will come in further patches.
This configuration is disabled by default.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 13 +++++++++++++
 7 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 777fd6c..6534537 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -478,6 +478,7 @@ struct iwl_hcmd_arr {
  *	in DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
  * @wide_cmd_header: firmware supports wide host command header
+ * @sw_csum_tx: transport should compute the TCP checksum
  * @command_groups: array of command groups, each member is an array of the
  *	commands in the group; for debugging only
  * @command_groups_size: number of command groups, to avoid illegal access
@@ -497,6 +498,7 @@ struct iwl_trans_config {
 	bool bc_table_dword;
 	bool scd_set_active;
 	bool wide_cmd_header;
+	bool sw_csum_tx;
 	const struct iwl_hcmd_arr *command_groups;
 	int command_groups_size;
  
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index 1f8f616..b00c03f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -106,6 +106,7 @@
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
 #define IWL_MVM_RS_80_20_FAR_RANGE_TWEAK	1
 #define IWL_MVM_TOF_IS_RESPONDER		0
+#define IWL_MVM_SW_TX_CSUM_OFFLOAD		0
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE_TW   1
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 0fb10fd..0227b29 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -667,6 +667,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (!iwl_mvm_is_csum_supported(mvm))
 		hw->netdev_features &= ~NETIF_F_RXCSUM;
 
+	if (IWL_MVM_SW_TX_CSUM_OFFLOAD)
+		hw->netdev_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+
 	ret = ieee80211_register_hw(mvm->hw);
 	if (ret)
 		iwl_mvm_leds_exit(mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ffcebea..50b8c01 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -541,6 +541,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans_cfg.scd_set_active = true;
 
 	trans_cfg.sdio_adma_addr = fw->sdio_adma_addr;
+	trans_cfg.sw_csum_tx = IWL_MVM_SW_TX_CSUM_OFFLOAD;
 
 	/* Set a short watchdog for the command queue */
 	trans_cfg.cmd_q_wdg_timeout =
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 92a35d9..3d47dd7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -307,6 +307,8 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
  * @wide_cmd_header: true when ucode supports wide command header format
+ * @sw_csum_tx: if true, then the transport will compute the csum of the TXed
+ *	frame.
  * @rx_page_order: page order for receive buffer size
  * @reg_lock: protect hw register access
  * @mutex: to protect stop_device / start_fw / start_hw
@@ -361,6 +363,7 @@ struct iwl_trans_pcie {
 	bool bc_table_dword;
 	bool scd_set_active;
 	bool wide_cmd_header;
+	bool sw_csum_tx;
 	u32 rx_page_order;
 
 	/*protect hw register */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index a5bf24e..97e22fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1442,6 +1442,7 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	trans_pcie->wide_cmd_header = trans_cfg->wide_cmd_header;
 	trans_pcie->bc_table_dword = trans_cfg->bc_table_dword;
 	trans_pcie->scd_set_active = trans_cfg->scd_set_active;
+	trans_pcie->sw_csum_tx = trans_cfg->sw_csum_tx;
 
 	trans->command_groups = trans_cfg->command_groups;
 	trans->command_groups_size = trans_cfg->command_groups_size;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 2952915..6c460a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1823,6 +1823,19 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      "TX on unused queue %d\n", txq_id))
 		return -EINVAL;
 
+	if (unlikely(trans_pcie->sw_csum_tx &&
+		     skb->ip_summed == CHECKSUM_PARTIAL)) {
+		int offs = skb_checksum_start_offset(skb);
+		int csum_offs = offs + skb->csum_offset;
+		__wsum csum;
+
+		if (skb_ensure_writable(skb, csum_offs + sizeof(__sum16)))
+			return -1;
+
+		csum = skb_checksum(skb, offs, skb->len - offs, 0);
+		*(__sum16 *)(skb->data + csum_offs) = csum_fold(csum);
+	}
+
 	if (skb_is_nonlinear(skb) &&
 	    skb_shinfo(skb)->nr_frags > IWL_PCIE_MAX_FRAGS &&
 	    __skb_linearize(skb))
-- 
2.5.0

