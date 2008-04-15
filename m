Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54268 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYDOEQU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/12] iwlwifi: move shared pointers to iwl_priv
Date: Mon, 14 Apr 2008 21:16:14 -0700
Message-Id: <1208232974-3828-13-git-send-email-reinette.chatre@intel.com> (sfid-20080415_052248_619630_2F051DEA)
In-Reply-To: <1208232974-3828-12-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-7-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-8-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-9-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-10-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-11-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-12-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves shared memory structure to iwl_priv

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   55 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   11 +++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +-
 4 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index de7bac1..3d098da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -1554,29 +1554,29 @@ struct iwl4965_sched_queue_byte_cnt_tbl {
 struct iwl4965_shared {
 	struct iwl4965_sched_queue_byte_cnt_tbl
 	 queues_byte_cnt_tbls[IWL_MAX_NUM_QUEUES];
-	__le32 val0;
+	__le32 rb_closed;
 
 	/* __le32 rb_closed_stts_rb_num:12; */
 #define IWL_rb_closed_stts_rb_num_POS 0
 #define IWL_rb_closed_stts_rb_num_LEN 12
-#define IWL_rb_closed_stts_rb_num_SYM val0
+#define IWL_rb_closed_stts_rb_num_SYM rb_closed
 	/* __le32 rsrv1:4; */
 	/* __le32 rb_closed_stts_rx_frame_num:12; */
 #define IWL_rb_closed_stts_rx_frame_num_POS 16
 #define IWL_rb_closed_stts_rx_frame_num_LEN 12
-#define IWL_rb_closed_stts_rx_frame_num_SYM val0
+#define IWL_rb_closed_stts_rx_frame_num_SYM rb_closed
 	/* __le32 rsrv2:4; */
 
-	__le32 val1;
+	__le32 frm_finished;
 	/* __le32 frame_finished_stts_rb_num:12; */
 #define IWL_frame_finished_stts_rb_num_POS 0
 #define IWL_frame_finished_stts_rb_num_LEN 12
-#define IWL_frame_finished_stts_rb_num_SYM val1
+#define IWL_frame_finished_stts_rb_num_SYM frm_finished
 	/* __le32 rsrv3:4; */
 	/* __le32 frame_finished_stts_rx_frame_num:12; */
 #define IWL_frame_finished_stts_rx_frame_num_POS 16
 #define IWL_frame_finished_stts_rx_frame_num_LEN 12
-#define IWL_frame_finished_stts_rx_frame_num_SYM val1
+#define IWL_frame_finished_stts_rx_frame_num_SYM frm_finished
 	/* __le32 rsrv4:4; */
 
 	__le32 padding1;  /* so that allocation will be aligned to 16B */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 04fed5e..a10a6e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -274,6 +274,18 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 	spin_lock_init(&priv->hcmd_lock);
 	spin_lock_init(&priv->lq_mngr.lock);
 
+	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
+					sizeof(struct iwl4965_shared),
+					&priv->shared_phys);
+
+	if (!priv->shared_virt) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	memset(priv->shared_virt, 0, sizeof(struct iwl4965_shared));
+
+
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++)
 		INIT_LIST_HEAD(&priv->ibss_mac_hash[i]);
 
@@ -546,15 +558,15 @@ static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 
 static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 {
-	int rc;
+	int ret;
 	unsigned long flags;
 	unsigned int rb_size;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
+		return ret;
 	}
 
 	if (priv->cfg->mod_params->amsdu_size_8K)
@@ -574,15 +586,15 @@ static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl4965_rx_queue *rxq)
 
 	/* Tell device where in DRAM to update its Rx status */
 	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
-			   (priv->hw_setting.shared_phys +
-				offsetof(struct iwl4965_shared, val0)) >> 4);
+			   (priv->shared_phys +
+			    offsetof(struct iwl4965_shared, rb_closed)) >> 4);
 
 	/* Enable Rx DMA, enable host interrupt, Rx buffer size 4k, 256 RBDs */
 	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
 			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
 			   rb_size |
-			     /*0x10 << 4 | */
+			     /* 0x10 << 4 | */
 			   (RX_QUEUE_SIZE_LOG <<
 			      FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT));
 
@@ -1966,7 +1978,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 
 	/* Tel 4965 where to find Tx byte count tables */
 	iwl_write_prph(priv, IWL49_SCD_DRAM_BASE_ADDR,
-		(priv->hw_setting.shared_phys +
+		(priv->shared_phys +
 		 offsetof(struct iwl4965_shared, queues_byte_cnt_tbls)) >> 10);
 
 	/* Disable chain mode for all queues */
@@ -2024,29 +2036,14 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
  */
 int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 {
-	int ret = 0;
 
 	if ((priv->cfg->mod_params->num_of_queues > IWL_MAX_NUM_QUEUES) ||
 	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
 		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
 			  IWL_MIN_NUM_QUEUES, IWL_MAX_NUM_QUEUES);
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* Allocate area for Tx byte count tables and Rx queue status */
-	priv->hw_setting.shared_virt =
-	    pci_alloc_consistent(priv->pci_dev,
-				 sizeof(struct iwl4965_shared),
-				 &priv->hw_setting.shared_phys);
-
-	if (!priv->hw_setting.shared_virt) {
-		ret = -ENOMEM;
-		goto out;
+		return -EINVAL;
 	}
 
-	memset(priv->hw_setting.shared_virt, 0, sizeof(struct iwl4965_shared));
-
 	priv->hw_setting.max_txq_num = priv->cfg->mod_params->num_of_queues;
 	priv->hw_setting.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
 	priv->hw_setting.max_rxq_size = RX_QUEUE_SIZE;
@@ -2061,8 +2058,7 @@ int iwl4965_hw_set_hw_setting(struct iwl_priv *priv)
 
 	priv->hw_setting.tx_ant_num = 2;
 
-out:
-	return ret;
+	return 0;
 }
 
 /**
@@ -3014,9 +3010,8 @@ void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 
 int iwl4965_hw_get_rx_read(struct iwl_priv *priv)
 {
-	struct iwl4965_shared *shared_data = priv->hw_setting.shared_virt;
-
-	return IWL_GET_BITS(*shared_data, rb_closed_stts_rb_num);
+	struct iwl4965_shared *s = priv->shared_virt;
+	return le32_to_cpu(s->rb_closed) & 0xFFF;
 }
 
 int iwl4965_hw_get_temperature(struct iwl_priv *priv)
@@ -3149,7 +3144,7 @@ static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 {
 	int len;
 	int txq_id = txq->q.id;
-	struct iwl4965_shared *shared_data = priv->hw_setting.shared_virt;
+	struct iwl4965_shared *shared_data = priv->shared_virt;
 
 	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 17c4bcf..e5ab4c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -576,8 +576,6 @@ struct iwl4965_ibss_seq {
  * @max_rxq_log: Log-base-2 of max_rxq_size
  * @max_stations:
  * @bcast_sta_id:
- * @shared_virt: Pointer to driver/uCode shared Tx Byte Counts and Rx status
- * @shared_phys: Physical Pointer to Tx Byte Counts and Rx status
  */
 struct iwl4965_driver_hw_info {
 	u16 max_txq_num;
@@ -589,8 +587,6 @@ struct iwl4965_driver_hw_info {
 	u16 max_rxq_log;
 	u8  max_stations;
 	u8  bcast_sta_id;
-	void *shared_virt;
-	dma_addr_t shared_phys;
 };
 
 #define HT_SHORT_GI_20MHZ_ONLY          (1 << 0)
@@ -1147,9 +1143,14 @@ struct iwl_priv {
 	/* Last Rx'd beacon timestamp */
 	u64 timestamp;
 	u16 beacon_int;
-	struct iwl4965_driver_hw_info hw_setting;
 	struct ieee80211_vif *vif;
 
+	struct iwl4965_driver_hw_info hw_setting;
+	/* driver/uCode shared Tx Byte Counts and Rx status */
+	void *shared_virt;
+	/* Physical Pointer to Tx Byte Counts and Rx status */
+	dma_addr_t shared_phys;
+
 	/* Current association information needed to configure the
 	 * hardware */
 	u16 assoc_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 1f34340..5ec0af4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1219,11 +1219,11 @@ static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
 
 static void iwl4965_unset_hw_setting(struct iwl_priv *priv)
 {
-	if (priv->hw_setting.shared_virt)
+	if (priv->shared_virt)
 		pci_free_consistent(priv->pci_dev,
 				    sizeof(struct iwl4965_shared),
-				    priv->hw_setting.shared_virt,
-				    priv->hw_setting.shared_phys);
+				    priv->shared_virt,
+				    priv->shared_phys);
 }
 
 /**
-- 
1.5.3.4

