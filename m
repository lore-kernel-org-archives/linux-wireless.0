Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54742 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751150AbcIOSLr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:11:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:12 +0300
Message-Id: <20160915181131.32213-6-luca@coelho.fi> (sfid-20160915_201154_876925_25E8464E)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: mvm: support new shared memory config API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In a000 devices we have 15 fifos, so in the shared memory
config the number of tx fifos in the array was changed
accordingly.
As it is in the middle of the struct, the parsing code needs
to be duplicated.
To minimize the duplication, do not save variables we never
actually use.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 22 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 96 ++++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    |  9 +--
 4 files changed, 77 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 57b574b..2f92994 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -1977,8 +1977,9 @@ struct iwl_tdls_config_res {
 	struct iwl_tdls_config_sta_info_res sta_info[IWL_MVM_TDLS_STA_COUNT];
 } __packed; /* TDLS_CONFIG_RSP_API_S_VER_1 */
 
-#define TX_FIFO_MAX_NUM		8
-#define RX_FIFO_MAX_NUM		2
+#define TX_FIFO_MAX_NUM_9000		8
+#define TX_FIFO_MAX_NUM			15
+#define RX_FIFO_MAX_NUM			2
 #define TX_FIFO_INTERNAL_MAX_NUM	6
 
 /**
@@ -2004,6 +2005,21 @@ struct iwl_tdls_config_res {
  * NOTE: on firmware that don't have IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG
  *	 set, the last 3 members don't exist.
  */
+struct iwl_shared_mem_cfg_v1 {
+	__le32 shared_mem_addr;
+	__le32 shared_mem_size;
+	__le32 sample_buff_addr;
+	__le32 sample_buff_size;
+	__le32 txfifo_addr;
+	__le32 txfifo_size[TX_FIFO_MAX_NUM_9000];
+	__le32 rxfifo_size[RX_FIFO_MAX_NUM];
+	__le32 page_buff_addr;
+	__le32 page_buff_size;
+	__le32 rxfifo_addr;
+	__le32 internal_txfifo_addr;
+	__le32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
+} __packed; /* SHARED_MEM_ALLOC_API_S_VER_2 */
+
 struct iwl_shared_mem_cfg {
 	__le32 shared_mem_addr;
 	__le32 shared_mem_size;
@@ -2017,7 +2033,7 @@ struct iwl_shared_mem_cfg {
 	__le32 rxfifo_addr;
 	__le32 internal_txfifo_addr;
 	__le32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
-} __packed; /* SHARED_MEM_ALLOC_API_S_VER_2 */
+} __packed; /* SHARED_MEM_ALLOC_API_S_VER_3 */
 
 /**
  * VHT MU-MIMO group configuration
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index bebb148..42dcefe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -557,7 +557,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 					 sizeof(struct iwl_fw_error_dump_fifo);
 		}
 
-		for (i = 0; i < ARRAY_SIZE(mem_cfg->txfifo_size); i++) {
+		for (i = 0; i < mem_cfg->num_txfifo_entries; i++) {
 			if (!mem_cfg->txfifo_size[i])
 				continue;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 47e8e70..b951a7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -838,59 +838,48 @@ out:
 	return ret;
 }
 
-static void iwl_mvm_get_shared_mem_conf(struct iwl_mvm *mvm)
+static void iwl_mvm_parse_shared_mem_a000(struct iwl_mvm *mvm,
+					  struct iwl_rx_packet *pkt)
 {
-	struct iwl_host_cmd cmd = {
-		.flags = CMD_WANT_SKB,
-		.data = { NULL, },
-		.len = { 0, },
-	};
-	struct iwl_shared_mem_cfg *mem_cfg;
-	struct iwl_rx_packet *pkt;
-	u32 i;
+	struct iwl_shared_mem_cfg *mem_cfg = (void *)pkt->data;
+	int i;
 
-	lockdep_assert_held(&mvm->mutex);
+	mvm->shared_mem_cfg.num_txfifo_entries =
+		ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size);
+	for (i = 0; i < ARRAY_SIZE(mem_cfg->txfifo_size); i++)
+		mvm->shared_mem_cfg.txfifo_size[i] =
+			le32_to_cpu(mem_cfg->txfifo_size[i]);
+	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.rxfifo_size); i++)
+		mvm->shared_mem_cfg.rxfifo_size[i] =
+			le32_to_cpu(mem_cfg->rxfifo_size[i]);
 
-	if (fw_has_capa(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG))
-		cmd.id = iwl_cmd_id(SHARED_MEM_CFG_CMD, SYSTEM_GROUP, 0);
-	else
-		cmd.id = SHARED_MEM_CFG;
+	BUILD_BUG_ON(sizeof(mvm->shared_mem_cfg.internal_txfifo_size) !=
+		     sizeof(mem_cfg->internal_txfifo_size));
 
-	if (WARN_ON(iwl_mvm_send_cmd(mvm, &cmd)))
-		return;
+	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.internal_txfifo_size);
+	     i++)
+		mvm->shared_mem_cfg.internal_txfifo_size[i] =
+			le32_to_cpu(mem_cfg->internal_txfifo_size[i]);
+}
 
-	pkt = cmd.resp_pkt;
-	mem_cfg = (void *)pkt->data;
-
-	mvm->shared_mem_cfg.shared_mem_addr =
-		le32_to_cpu(mem_cfg->shared_mem_addr);
-	mvm->shared_mem_cfg.shared_mem_size =
-		le32_to_cpu(mem_cfg->shared_mem_size);
-	mvm->shared_mem_cfg.sample_buff_addr =
-		le32_to_cpu(mem_cfg->sample_buff_addr);
-	mvm->shared_mem_cfg.sample_buff_size =
-		le32_to_cpu(mem_cfg->sample_buff_size);
-	mvm->shared_mem_cfg.txfifo_addr = le32_to_cpu(mem_cfg->txfifo_addr);
-	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size); i++)
+static void iwl_mvm_parse_shared_mem(struct iwl_mvm *mvm,
+				     struct iwl_rx_packet *pkt)
+{
+	struct iwl_shared_mem_cfg_v1 *mem_cfg = (void *)pkt->data;
+	int i;
+
+	mvm->shared_mem_cfg.num_txfifo_entries =
+		ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size);
+	for (i = 0; i < ARRAY_SIZE(mem_cfg->txfifo_size); i++)
 		mvm->shared_mem_cfg.txfifo_size[i] =
 			le32_to_cpu(mem_cfg->txfifo_size[i]);
 	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.rxfifo_size); i++)
 		mvm->shared_mem_cfg.rxfifo_size[i] =
 			le32_to_cpu(mem_cfg->rxfifo_size[i]);
-	mvm->shared_mem_cfg.page_buff_addr =
-		le32_to_cpu(mem_cfg->page_buff_addr);
-	mvm->shared_mem_cfg.page_buff_size =
-		le32_to_cpu(mem_cfg->page_buff_size);
 
-	/* new API has more data */
+	/* new API has more data, from rxfifo_addr field and on */
 	if (fw_has_capa(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
-		mvm->shared_mem_cfg.rxfifo_addr =
-			le32_to_cpu(mem_cfg->rxfifo_addr);
-		mvm->shared_mem_cfg.internal_txfifo_addr =
-			le32_to_cpu(mem_cfg->internal_txfifo_addr);
-
 		BUILD_BUG_ON(sizeof(mvm->shared_mem_cfg.internal_txfifo_size) !=
 			     sizeof(mem_cfg->internal_txfifo_size));
 
@@ -900,6 +889,33 @@ static void iwl_mvm_get_shared_mem_conf(struct iwl_mvm *mvm)
 			mvm->shared_mem_cfg.internal_txfifo_size[i] =
 				le32_to_cpu(mem_cfg->internal_txfifo_size[i]);
 	}
+}
+
+static void iwl_mvm_get_shared_mem_conf(struct iwl_mvm *mvm)
+{
+	struct iwl_host_cmd cmd = {
+		.flags = CMD_WANT_SKB,
+		.data = { NULL, },
+		.len = { 0, },
+	};
+	struct iwl_rx_packet *pkt;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG))
+		cmd.id = iwl_cmd_id(SHARED_MEM_CFG_CMD, SYSTEM_GROUP, 0);
+	else
+		cmd.id = SHARED_MEM_CFG;
+
+	if (WARN_ON(iwl_mvm_send_cmd(mvm, &cmd)))
+		return;
+
+	pkt = cmd.resp_pkt;
+	if (iwl_mvm_has_new_tx_api(mvm))
+		iwl_mvm_parse_shared_mem_a000(mvm, pkt);
+	else
+		iwl_mvm_parse_shared_mem(mvm, pkt);
 
 	IWL_DEBUG_INFO(mvm, "SHARED MEM CFG: got memory offsets/sizes\n");
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 1806495..f5df706 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -602,16 +602,9 @@ enum iwl_mvm_tdls_cs_state {
 };
 
 struct iwl_mvm_shared_mem_cfg {
-	u32 shared_mem_addr;
-	u32 shared_mem_size;
-	u32 sample_buff_addr;
-	u32 sample_buff_size;
-	u32 txfifo_addr;
+	int num_txfifo_entries;
 	u32 txfifo_size[TX_FIFO_MAX_NUM];
 	u32 rxfifo_size[RX_FIFO_MAX_NUM];
-	u32 page_buff_addr;
-	u32 page_buff_size;
-	u32 rxfifo_addr;
 	u32 internal_txfifo_addr;
 	u32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
 };
-- 
2.9.3
