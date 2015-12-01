Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5956 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbbLAJ7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:11 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/41] iwlwifi: add support for 12K Receive Buffers
Date: Tue,  1 Dec 2015 11:58:28 +0200
Message-Id: <1448963947-24302-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110358_566849_EF7A321F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11ac allows A-MSDU that can be up to 12KB long. Since
an entire A-MSDU needs to fit into one single Receive
Buffer (RB), add support for big RBs.
Since this adds lots of pressure to the memory manager and
significantly increase the true_size of the RX buffers,
don't enable this by default.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c        | 16 +++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c         |  4 ++--
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h   | 10 ++++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c   | 13 ++++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       | 20 ++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         | 16 +++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |  4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c         | 16 +++++++++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |  8 +++-----
 10 files changed, 89 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index e7616f0..41f3aa1 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1227,7 +1227,21 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	trans_cfg.op_mode = op_mode;
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
-	trans_cfg.rx_buf_size_8k = iwlwifi_mod_params.amsdu_size_8K;
+
+	switch (iwlwifi_mod_params.amsdu_size) {
+	case IWL_AMSDU_4K:
+		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
+		break;
+	case IWL_AMSDU_8K:
+		trans_cfg.rx_buf_size = IWL_AMSDU_8K;
+		break;
+	case IWL_AMSDU_12K:
+	default:
+		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
+		pr_err("Unsupported amsdu_size: %d\n",
+		       iwlwifi_mod_params.amsdu_size);
+	}
+
 	trans_cfg.cmd_q_wdg_timeout = IWL_WATCHDOG_DISABLED;
 
 	trans_cfg.command_names = iwl_dvm_cmd_strings;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 463cadf..48f090a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1637,9 +1637,9 @@ MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(11n_disable, iwlwifi_mod_params.disable_11n, uint, S_IRUGO);
 MODULE_PARM_DESC(11n_disable,
 	"disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX");
-module_param_named(amsdu_size_8K, iwlwifi_mod_params.amsdu_size_8K,
+module_param_named(amsdu_size, iwlwifi_mod_params.amsdu_size,
 		   int, S_IRUGO);
-MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size (default 0)");
+MODULE_PARM_DESC(amsdu_size, "amsdu size 0:4K 1:8K 2:12K (default 0)");
 module_param_named(fw_restart, iwlwifi_mod_params.restart_fw, bool, S_IRUGO);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error (default true)");
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index acc3d18..a19c458 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -766,7 +766,7 @@ void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 	if (cfg->ht_params->ldpc)
 		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
 
-	if (iwlwifi_mod_params.amsdu_size_8K)
+	if (iwlwifi_mod_params.amsdu_size >= IWL_AMSDU_8K)
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
 	ht_info->ampdu_factor = cfg->max_ht_ampdu_exponent;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index ac2b90d..3436c00 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -86,6 +86,12 @@ enum iwl_disable_11n {
 	IWL_ENABLE_HT_TXAGG	 = BIT(3),
 };
 
+enum iwl_amsdu_size {
+	IWL_AMSDU_4K = 0,
+	IWL_AMSDU_8K = 1,
+	IWL_AMSDU_12K = 2,
+};
+
 /**
  * struct iwl_mod_params
  *
@@ -94,7 +100,7 @@ enum iwl_disable_11n {
  * @sw_crypto: using hardware encryption, default = 0
  * @disable_11n: disable 11n capabilities, default = 0,
  *	use IWL_[DIS,EN]ABLE_HT_* constants
- * @amsdu_size_8K: enable 8K amsdu size, default = 0
+ * @amsdu_size: enable 8K amsdu size, default = 4K. enum iwl_amsdu_size.
  * @restart_fw: restart firmware, default = 1
  * @bt_coex_active: enable bt coex, default = true
  * @led_mode: system default, default = 0
@@ -109,7 +115,7 @@ enum iwl_disable_11n {
 struct iwl_mod_params {
 	int sw_crypto;
 	unsigned int disable_11n;
-	int amsdu_size_8K;
+	int amsdu_size;
 	bool restart_fw;
 	bool bt_coex_active;
 	int led_mode;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 3b8e85e..60b7fce 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -379,8 +379,19 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 	else
 		vht_cap->cap |= IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
 
-	if (iwlwifi_mod_params.amsdu_size_8K)
+	switch (iwlwifi_mod_params.amsdu_size) {
+	case IWL_AMSDU_4K:
+		vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895;
+		break;
+	case IWL_AMSDU_8K:
 		vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991;
+		break;
+	case IWL_AMSDU_12K:
+		vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454;
+		break;
+	default:
+		break;
+	}
 
 	vht_cap->vht_mcs.rx_mcs_map =
 		cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_9 << 0 |
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 6f76525..607f4f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -423,6 +423,22 @@ enum iwl_trans_status {
 	STATUS_TRANS_DEAD,
 };
 
+static inline int
+iwl_trans_get_rb_size_order(enum iwl_amsdu_size rb_size)
+{
+	switch (rb_size) {
+	case IWL_AMSDU_4K:
+		return get_order(4 * 1024);
+	case IWL_AMSDU_8K:
+		return get_order(8 * 1024);
+	case IWL_AMSDU_12K:
+		return get_order(12 * 1024);
+	default:
+		WARN_ON(1);
+		return -1;
+	}
+}
+
 /**
  * struct iwl_trans_config - transport configuration
  *
@@ -436,7 +452,7 @@ enum iwl_trans_status {
  *	list of such notifications to filter. Max length is
  *	%MAX_NO_RECLAIM_CMDS.
  * @n_no_reclaim_cmds: # of commands in list
- * @rx_buf_size_8k: 8 kB RX buffer size needed for A-MSDUs,
+ * @rx_buf_size: RX buffer size needed for A-MSDUs
  *	if unset 4k will be the RX buffer size
  * @bc_table_dword: set to true if the BC table expects the byte count to be
  *	in DWORD (as opposed to bytes)
@@ -456,7 +472,7 @@ struct iwl_trans_config {
 	const u8 *no_reclaim_cmds;
 	unsigned int n_no_reclaim_cmds;
 
-	bool rx_buf_size_8k;
+	enum iwl_amsdu_size rx_buf_size;
 	bool bc_table_dword;
 	bool scd_set_active;
 	bool wide_cmd_header;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 13c97f6..1646cdd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -485,7 +485,21 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans_cfg.op_mode = op_mode;
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
-	trans_cfg.rx_buf_size_8k = iwlwifi_mod_params.amsdu_size_8K;
+	switch (iwlwifi_mod_params.amsdu_size) {
+	case IWL_AMSDU_4K:
+		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
+		break;
+	case IWL_AMSDU_8K:
+		trans_cfg.rx_buf_size = IWL_AMSDU_8K;
+		break;
+	case IWL_AMSDU_12K:
+		trans_cfg.rx_buf_size = IWL_AMSDU_12K;
+		break;
+	default:
+		pr_err("%s: Unsupported amsdu_size: %d\n", KBUILD_MODNAME,
+		       iwlwifi_mod_params.amsdu_size);
+		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
+	}
 	trans_cfg.wide_cmd_header = fw_has_api(&mvm->fw->ucode_capa,
 					       IWL_UCODE_TLV_API_WIDE_CMD_HDR);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index feb2f7e..bf8cb59 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -302,7 +302,7 @@ iwl_pcie_get_scratchbuf_dma(struct iwl_txq *txq, int idx)
  * @ucode_write_complete: indicates that the ucode has been copied.
  * @ucode_write_waitq: wait queue for uCode load
  * @cmd_queue - command queue number
- * @rx_buf_size_8k: 8 kB RX buffer size
+ * @rx_buf_size: Rx buffer size
  * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
  * @wide_cmd_header: true when ucode supports wide command header format
@@ -356,7 +356,7 @@ struct iwl_trans_pcie {
 	u8 n_no_reclaim_cmds;
 	u8 no_reclaim_cmds[MAX_NO_RECLAIM_CMDS];
 
-	bool rx_buf_size_8k;
+	enum iwl_amsdu_size rx_buf_size;
 	bool bc_table_dword;
 	bool scd_set_active;
 	bool wide_cmd_header;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index e06591f..b837b34 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -602,10 +602,20 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 	u32 rb_size;
 	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
 
-	if (trans_pcie->rx_buf_size_8k)
+	switch (trans_pcie->rx_buf_size) {
+	case IWL_AMSDU_4K:
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
+		break;
+	case IWL_AMSDU_8K:
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
-	else
+		break;
+	case IWL_AMSDU_12K:
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_12K;
+		break;
+	default:
+		WARN_ON(1);
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
+	}
 
 	/* Stop Rx DMA */
 	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
@@ -629,7 +639,7 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
 	 *      the credit mechanism in 5000 HW RX FIFO
 	 * Direct rx interrupts to hosts
-	 * Rx buffer size 4 or 8k
+	 * Rx buffer size 4 or 8k or 12k
 	 * RB timeout 0x10
 	 * 256 RBDs
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 9028345..889227c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1435,11 +1435,9 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 		memcpy(trans_pcie->no_reclaim_cmds, trans_cfg->no_reclaim_cmds,
 		       trans_pcie->n_no_reclaim_cmds * sizeof(u8));
 
-	trans_pcie->rx_buf_size_8k = trans_cfg->rx_buf_size_8k;
-	if (trans_pcie->rx_buf_size_8k)
-		trans_pcie->rx_page_order = get_order(8 * 1024);
-	else
-		trans_pcie->rx_page_order = get_order(4 * 1024);
+	trans_pcie->rx_buf_size = trans_cfg->rx_buf_size;
+	trans_pcie->rx_page_order =
+		iwl_trans_get_rb_size_order(trans_pcie->rx_buf_size);
 
 	trans_pcie->wide_cmd_header = trans_cfg->wide_cmd_header;
 	trans_pcie->command_names = trans_cfg->command_names;
-- 
2.5.0

