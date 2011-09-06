Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26707 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab1IFRPJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/10] iwlagn: iwl-trans.c can't dereference iwl_priv any more
Date: Tue,  6 Sep 2011 09:31:21 -0700
Message-Id: <1315326685-22213-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191522_793500_E5B195D5)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This reaches encapsulation for this file. In order to reach this:
 * move priv->valid_context to iwl_shared
 * move the last_rejected initialization to the upper layer
 * define a wrapper iwl_nic_config in the upper layer that calls to
   cfg->lib->ops->nic_config

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |    3 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c           |    6 +++
 drivers/net/wireless/iwlwifi/iwl-csr.h            |   18 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   38 +--------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    6 +++
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   15 ++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   12 ++-----
 10 files changed, 58 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 7c036b9..1301887 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -659,7 +659,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 				 IWL_SCD_BE_MSK | IWL_SCD_BK_MSK |
 				 IWL_SCD_MGMT_MSK;
 	if ((flush_control & BIT(IWL_RXON_CTX_PAN)) &&
-	    (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS)))
+	    (priv->shrd->valid_contexts != BIT(IWL_RXON_CTX_BSS)))
 		flush_cmd.fifo_control |= IWL_PAN_SCD_VO_MSK |
 				IWL_PAN_SCD_VI_MSK | IWL_PAN_SCD_BE_MSK |
 				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index ea4895a..00e6fc5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -311,7 +311,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	int slot0 = 300, slot1 = 0;
 	int ret;
 
-	if (priv->valid_contexts == BIT(IWL_RXON_CTX_BSS))
+	if (priv->shrd->valid_contexts == BIT(IWL_RXON_CTX_BSS))
 		return 0;
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 8b14d24..ea31d76 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -349,6 +349,7 @@ int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 static int iwlagn_alive_notify(struct iwl_priv *priv)
 {
+	struct iwl_rxon_context *ctx;
 	int ret;
 
 	if (!priv->tx_cmd_pool)
@@ -361,6 +362,8 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
 		return -ENOMEM;
 
 	iwl_trans_tx_start(trans(priv));
+	for_each_context(priv, ctx)
+		ctx->last_tx_rejected = false;
 
 	ret = iwlagn_send_wimax_coex(priv);
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 484f889..7f6c58e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -623,9 +623,9 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	 * The default context is always valid,
 	 * the PAN context depends on uCode.
 	 */
-	priv->valid_contexts = BIT(IWL_RXON_CTX_BSS);
+	priv->shrd->valid_contexts = BIT(IWL_RXON_CTX_BSS);
 	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN)
-		priv->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
+		priv->shrd->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
 
 	for (i = 0; i < NUM_IWL_RXON_CTX; i++)
 		priv->contexts[i].ctxid = i;
@@ -2880,7 +2880,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
 	int err = 0;
 
-	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
+	if (!(priv->shrd->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
 
 	if (!(ctx->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)))
@@ -2945,7 +2945,7 @@ static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
-	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
+	if (!(priv->shrd->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&priv->shrd->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0f16edc..c1441f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1870,3 +1870,9 @@ void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state)
 {
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
 }
+
+void iwl_nic_config(struct iwl_priv *priv)
+{
+	priv->cfg->lib->nic_config(priv);
+
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index d6dbb04..b9f3267 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -439,4 +439,22 @@
  */
 #define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
 
+/**********************************************************
+ * CSR values
+ **********************************************************/
+ /*
+ * host interrupt timeout value
+ * used with setting interrupt coalescing timer
+ * the CSR_INT_COALESCING is an 8 bit register in 32-usec unit
+ *
+ * default interrupt coalescing timer is 64 x 32 = 2048 usecs
+ * default interrupt coalescing calibration timer is 16 x 32 = 512 usecs
+ */
+#define IWL_HOST_INT_TIMEOUT_MAX	(0xFF)
+#define IWL_HOST_INT_TIMEOUT_DEF	(0x40)
+#define IWL_HOST_INT_TIMEOUT_MIN	(0x0)
+#define IWL_HOST_INT_CALIB_TIMEOUT_MAX	(0xFF)
+#define IWL_HOST_INT_CALIB_TIMEOUT_DEF	(0x10)
+#define IWL_HOST_INT_CALIB_TIMEOUT_MIN	(0x0)
+
 #endif /* !__iwl_csr_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bbda672..8438a33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -117,21 +117,6 @@ struct iwl_channel_info {
 	u8 ht40_extension_channel; /* HT_IE_EXT_CHANNEL_* */
 };
 
-#define IWL_TX_FIFO_BK		0	/* shared */
-#define IWL_TX_FIFO_BE		1
-#define IWL_TX_FIFO_VI		2	/* shared */
-#define IWL_TX_FIFO_VO		3
-#define IWL_TX_FIFO_BK_IPAN	IWL_TX_FIFO_BK
-#define IWL_TX_FIFO_BE_IPAN	4
-#define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
-#define IWL_TX_FIFO_VO_IPAN	5
-/* re-uses the VO FIFO, uCode will properly flush/schedule */
-#define IWL_TX_FIFO_AUX		5
-#define IWL_TX_FIFO_UNUSED	-1
-
-/* AUX (TX during scan dwell) queue */
-#define IWL_AUX_QUEUE		10
-
 /*
  * Minimum number of queues. MAX_NUM is defined in hw specific files.
  * Set the minimum to accommodate
@@ -544,9 +529,6 @@ struct iwl_chain_noise_data {
 #define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
 #define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
 
-#define IWL_TRAFFIC_ENTRIES	(256)
-#define IWL_TRAFFIC_ENTRY_SIZE  (64)
-
 enum {
 	MEASUREMENT_READY = (1 << 0),
 	MEASUREMENT_ACTIVE = (1 << 1),
@@ -688,21 +670,6 @@ struct iwl_event_log {
 };
 
 /*
- * host interrupt timeout value
- * used with setting interrupt coalescing timer
- * the CSR_INT_COALESCING is an 8 bit register in 32-usec unit
- *
- * default interrupt coalescing timer is 64 x 32 = 2048 usecs
- * default interrupt coalescing calibration timer is 16 x 32 = 512 usecs
- */
-#define IWL_HOST_INT_TIMEOUT_MAX	(0xFF)
-#define IWL_HOST_INT_TIMEOUT_DEF	(0x40)
-#define IWL_HOST_INT_TIMEOUT_MIN	(0x0)
-#define IWL_HOST_INT_CALIB_TIMEOUT_MAX	(0xFF)
-#define IWL_HOST_INT_CALIB_TIMEOUT_DEF	(0x10)
-#define IWL_HOST_INT_CALIB_TIMEOUT_MIN	(0x0)
-
-/*
  * This is the threshold value of plcp error rate per 100mSecs.  It is
  * used to set and check for the validity of plcp_delta.
  */
@@ -933,9 +900,6 @@ struct iwl_priv {
 	/*TODO: remove these pointers - use bus(priv) instead */
 	struct iwl_bus *bus;	/* bus specific data */
 
-	/* microcode/device supports multiple contexts */
-	u8 valid_contexts;
-
 	/* max number of station keys */
 	u8 sta_key_max_num;
 
@@ -1163,7 +1127,7 @@ iwl_rxon_ctx_from_vif(struct ieee80211_vif *vif)
 #define for_each_context(priv, ctx)				\
 	for (ctx = &priv->contexts[IWL_RXON_CTX_BSS];		\
 	     ctx < &priv->contexts[NUM_IWL_RXON_CTX]; ctx++)	\
-		if (priv->valid_contexts & BIT(ctx->ctxid))
+		if (priv->shrd->valid_contexts & BIT(ctx->ctxid))
 
 static inline int iwl_is_associated_ctx(struct iwl_rxon_context *ctx)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 73ea5e7..03f4c64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -213,6 +213,7 @@ struct iwl_tid_data {
  * @ucode_owner: IWL_OWNERSHIP_*
  * @cmd_queue: command queue number
  * @status: STATUS_*
+ * @valid_contexts: microcode/device supports multiple contexts
  * @bus: pointer to the bus layer data
  * @priv: pointer to the upper layer data
  * @hw_params: see struct iwl_hw_params
@@ -233,6 +234,7 @@ struct iwl_shared {
 	u8 cmd_queue;
 	unsigned long status;
 	bool wowlan;
+	u8 valid_contexts;
 
 	struct iwl_bus *bus;
 	struct iwl_priv *priv;
@@ -387,6 +389,7 @@ void iwl_stop_tx_ba_trans_ready(struct iwl_priv *priv,
 				enum iwl_rxon_context_id ctx,
 				u8 sta_id, u8 tid);
 void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
+void iwl_nic_config(struct iwl_priv *priv);
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
@@ -408,6 +411,9 @@ static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid);
 #define IWL_CMD(x) case x: return #x
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
+#define IWL_TRAFFIC_ENTRIES	(256)
+#define IWL_TRAFFIC_ENTRY_SIZE  (64)
+
 /*****************************************************
 * DRIVER STATUS FUNCTIONS
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index c5720cd..8047e95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -436,4 +436,19 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
 	return index & (q->n_window - 1);
 }
 
+#define IWL_TX_FIFO_BK		0	/* shared */
+#define IWL_TX_FIFO_BE		1
+#define IWL_TX_FIFO_VI		2	/* shared */
+#define IWL_TX_FIFO_VO		3
+#define IWL_TX_FIFO_BK_IPAN	IWL_TX_FIFO_BK
+#define IWL_TX_FIFO_BE_IPAN	4
+#define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
+#define IWL_TX_FIFO_VO_IPAN	5
+/* re-uses the VO FIFO, uCode will properly flush/schedule */
+#define IWL_TX_FIFO_AUX		5
+#define IWL_TX_FIFO_UNUSED	-1
+
+/* AUX (TX during scan dwell) queue */
+#define IWL_AUX_QUEUE		10
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 28fbaa2..5bf6250 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -71,9 +71,7 @@
 #include "iwl-prph.h"
 #include "iwl-shared.h"
 #include "iwl-eeprom.h"
-
-/* TODO: the transport layer should not include this */
-#include "iwl-core.h"
+#include "iwl-agn-hw.h"
 
 static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 {
@@ -638,7 +636,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 
 	iwl_set_pwr_vmain(trans);
 
-	priv(trans)->cfg->lib->nic_config(priv(trans));
+	iwl_nic_config(priv(trans));
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	iwl_rx_init(trans);
@@ -831,8 +829,6 @@ static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 {
 	const struct queue_to_fifo_ac *queue_to_fifo;
-	struct iwl_rxon_context *ctx;
-	struct iwl_priv *priv = priv(trans);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 a;
@@ -900,7 +896,7 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
 
 	/* map queues to FIFOs */
-	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
+	if (trans->shrd->valid_contexts != BIT(IWL_RXON_CTX_BSS))
 		queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
 	else
 		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
@@ -912,8 +908,6 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 		sizeof(trans_pcie->queue_stopped));
 	for (i = 0; i < 4; i++)
 		atomic_set(&trans_pcie->queue_stop_count[i], 0);
-	for_each_context(priv, ctx)
-		ctx->last_tx_rejected = false;
 
 	/* reset to 0 to enable all the queue first */
 	trans_pcie->txq_ctx_active_msk = 0;
-- 
1.7.0.4

