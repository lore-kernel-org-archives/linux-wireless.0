Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbYEOF4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 21/26] iwlwifi: add ucode init flow handling for iwl5000
Date: Thu, 15 May 2008 13:54:13 +0800
Message-Id: <1210830858-3410-22-git-send-email-yi.zhu@intel.com> (sfid-20080515_081614_437590_803B2FDF)
In-Reply-To: <1210830858-3410-21-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-9-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-11-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-12-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-13-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-14-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-15-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-16-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-17-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-18-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-19-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-20-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-21-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds all the handlers and functions needed for ucode
initialization flow.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |  157 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-prph.h |   28 ++++++
 2 files changed, 185 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b6bdffc..5e818ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -46,6 +46,16 @@
 
 #define IWL5000_UCODE_API  "-1"
 
+static const u16 iwl5000_default_queue_to_tx_fifo[] = {
+	IWL_TX_FIFO_AC3,
+	IWL_TX_FIFO_AC2,
+	IWL_TX_FIFO_AC1,
+	IWL_TX_FIFO_AC0,
+	IWL50_CMD_FIFO_NUM,
+	IWL_TX_FIFO_HCCA_1,
+	IWL_TX_FIFO_HCCA_2
+};
+
 static int iwl5000_apm_init(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -420,6 +430,151 @@ static int iwl5000_load_ucode(struct iwl_priv *priv)
 	return ret;
 }
 
+static void iwl5000_init_alive_start(struct iwl_priv *priv)
+{
+	int ret = 0;
+
+	/* Check alive response for "valid" sign from uCode */
+	if (priv->card_alive_init.is_valid != UCODE_VALID_OK) {
+		/* We had an error bringing up the hardware, so take it
+		 * all the way back down so we can try again */
+		IWL_DEBUG_INFO("Initialize Alive failed.\n");
+		goto restart;
+	}
+
+	/* initialize uCode was loaded... verify inst image.
+	 * This is a paranoid check, because we would not have gotten the
+	 * "initialize" alive if code weren't properly loaded.  */
+	if (iwl_verify_ucode(priv)) {
+		/* Runtime instruction load was bad;
+		 * take it all the way back down so we can try again */
+		IWL_DEBUG_INFO("Bad \"initialize\" uCode load.\n");
+		goto restart;
+	}
+
+	iwlcore_clear_stations_table(priv);
+	ret = priv->cfg->ops->lib->alive_notify(priv);
+	if (ret) {
+		IWL_WARNING("Could not complete ALIVE transition: %d\n", ret);
+		goto restart;
+	}
+
+	return;
+
+restart:
+	/* real restart (first load init_ucode) */
+	queue_work(priv->workqueue, &priv->restart);
+}
+
+static void iwl5000_set_wr_ptrs(struct iwl_priv *priv,
+				int txq_id, u32 index)
+{
+	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
+			(index & 0xff) | (txq_id << 8));
+	iwl_write_prph(priv, IWL50_SCD_QUEUE_RDPTR(txq_id), index);
+}
+
+static void iwl5000_tx_queue_set_status(struct iwl_priv *priv,
+					struct iwl_tx_queue *txq,
+					int tx_fifo_id, int scd_retry)
+{
+	int txq_id = txq->q.id;
+	int active = test_bit(txq_id, &priv->txq_ctx_active_msk)?1:0;
+
+	iwl_write_prph(priv, IWL50_SCD_QUEUE_STATUS_BITS(txq_id),
+			(active << IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+			(tx_fifo_id << IWL50_SCD_QUEUE_STTS_REG_POS_TXF) |
+			(1 << IWL50_SCD_QUEUE_STTS_REG_POS_WSL) |
+			IWL50_SCD_QUEUE_STTS_REG_MSK);
+
+	txq->sched_retry = scd_retry;
+
+	IWL_DEBUG_INFO("%s %s Queue %d on AC %d\n",
+		       active ? "Activate" : "Deactivate",
+		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
+}
+
+static int iwl5000_alive_notify(struct iwl_priv *priv)
+{
+	u32 a;
+	int i = 0;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return ret;
+	}
+
+	priv->scd_base_addr = iwl_read_prph(priv, IWL50_SCD_SRAM_BASE_ADDR);
+	a = priv->scd_base_addr + IWL50_SCD_CONTEXT_DATA_OFFSET;
+	for (; a < priv->scd_base_addr + IWL50_SCD_TX_STTS_BITMAP_OFFSET;
+		a += 4)
+		iwl_write_targ_mem(priv, a, 0);
+	for (; a < priv->scd_base_addr + IWL50_SCD_TRANSLATE_TBL_OFFSET;
+		a += 4)
+		iwl_write_targ_mem(priv, a, 0);
+	for (; a < sizeof(u16) * priv->hw_params.max_txq_num; a += 4)
+		iwl_write_targ_mem(priv, a, 0);
+
+	iwl_write_prph(priv, IWL50_SCD_DRAM_BASE_ADDR,
+		(priv->shared_phys +
+		 offsetof(struct iwl5000_shared, queues_byte_cnt_tbls)) >> 10);
+	iwl_write_prph(priv, IWL50_SCD_QUEUECHAIN_SEL,
+		IWL50_SCD_QUEUECHAIN_SEL_ALL(
+			priv->hw_params.max_txq_num));
+	iwl_write_prph(priv, IWL50_SCD_AGGR_SEL, 0);
+
+	/* initiate the queues */
+	for (i = 0; i < priv->hw_params.max_txq_num; i++) {
+		iwl_write_prph(priv, IWL50_SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
+				IWL50_SCD_CONTEXT_QUEUE_OFFSET(i), 0);
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
+				IWL50_SCD_CONTEXT_QUEUE_OFFSET(i) +
+				sizeof(u32),
+				((SCD_WIN_SIZE <<
+				IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+				IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+				((SCD_FRAME_LIMIT <<
+				IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+				IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+	}
+
+	iwl_write_prph(priv, IWL50_SCD_INTERRUPT_MASK,
+				 (1 << priv->hw_params.max_txq_num) - 1);
+
+	iwl_write_prph(priv, IWL50_SCD_TXFACT,
+				 SCD_TXFACT_REG_TXFIFO_MASK(0, 7));
+
+	iwl5000_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
+	/* map qos queues to fifos one-to-one */
+	for (i = 0; i < ARRAY_SIZE(iwl5000_default_queue_to_tx_fifo); i++) {
+		int ac = iwl5000_default_queue_to_tx_fifo[i];
+		iwl_txq_ctx_activate(priv, i);
+		iwl5000_tx_queue_set_status(priv, &priv->txq[i], ac, 0);
+	}
+	/* TODO - need to initialize those FIFOs inside the loop above,
+	 * not only mark them as active */
+	iwl_txq_ctx_activate(priv, 4);
+	iwl_txq_ctx_activate(priv, 7);
+	iwl_txq_ctx_activate(priv, 8);
+	iwl_txq_ctx_activate(priv, 9);
+
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Ask for statistics now, the uCode will send notification
+	 * periodically after association */
+	iwl_send_statistics_request(priv, CMD_ASYNC);
+
+	return 0;
+}
+
 static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if ((priv->cfg->mod_params->num_of_queues > IWL50_NUM_QUEUES) ||
@@ -622,6 +777,8 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.disable_tx_fifo = iwl5000_disable_tx_fifo,
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.load_ucode = iwl5000_load_ucode,
+	.init_alive_start = iwl5000_init_alive_start,
+	.alive_notify = iwl5000_alive_notify,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.config = iwl5000_nic_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index acac629..d6a04f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -517,6 +517,34 @@
 #define IWL49_SCD_QUEUE_RA_TID_MAP_RATID_MSK	(0x01FF)
 
 /* 5000 SCD */
+#define IWL50_SCD_QUEUE_STTS_REG_POS_TXF	(0)
+#define IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE	(3)
+#define IWL50_SCD_QUEUE_STTS_REG_POS_WSL	(4)
+#define IWL50_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN (19)
+#define IWL50_SCD_QUEUE_STTS_REG_MSK		(0x00FF0000)
+
+#define IWL50_SCD_QUEUE_CTX_REG1_CREDIT_POS		(8)
+#define IWL50_SCD_QUEUE_CTX_REG1_CREDIT_MSK		(0x00FFFF00)
+#define IWL50_SCD_QUEUE_CTX_REG1_SUPER_CREDIT_POS	(24)
+#define IWL50_SCD_QUEUE_CTX_REG1_SUPER_CREDIT_MSK	(0xFF000000)
+#define IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS		(0)
+#define IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK		(0x0000007F)
+#define IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
+#define IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
+
+#define IWL50_SCD_CONTEXT_DATA_OFFSET		(0x600)
+#define IWL50_SCD_TX_STTS_BITMAP_OFFSET		(0x7B1)
+#define IWL50_SCD_TRANSLATE_TBL_OFFSET		(0x7E0)
+
+#define IWL50_SCD_CONTEXT_QUEUE_OFFSET(x)\
+	(IWL50_SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
+
+#define IWL50_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
+	((IWL50_SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffc)
+
+#define IWL50_SCD_QUEUECHAIN_SEL_ALL(x)		(((1<<(x)) - 1) &\
+	(~(1<<IWL_CMD_QUEUE_NUM)))
+
 #define IWL50_SCD_BASE			(PRPH_BASE + 0xa02c00)
 
 #define IWL50_SCD_SRAM_BASE_ADDR         (IWL50_SCD_BASE + 0x0)
-- 
1.5.3.6

