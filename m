Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1GHQUe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/21] iwlagn: add an API for RX stop
Date: Fri,  8 Jul 2011 08:46:11 -0700
Message-Id: <1310139989-27661-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182040_059009_19B2FA22)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Rx stop moves to transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   24 +++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-trans.c   |   10 ++++++++++
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 90d366e..25a592a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -905,17 +905,6 @@ void iwlagn_rx_replenish_now(struct iwl_priv *priv)
 	iwlagn_rx_queue_restock(priv);
 }
 
-int iwlagn_rxq_stop(struct iwl_priv *priv)
-{
-
-	/* stop Rx DMA */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
-			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
-
-	return 0;
-}
-
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 {
 	int idx = 0;
@@ -2321,13 +2310,14 @@ void iwlagn_stop_device(struct iwl_priv *priv)
 	 * already dead.
 	 */
 	if (test_bit(STATUS_DEVICE_ENABLED, &priv->status)) {
-                iwlagn_txq_ctx_stop(priv);
-                iwlagn_rxq_stop(priv);
+		iwlagn_txq_ctx_stop(priv);
+		priv->trans.ops->rx_stop(priv);
 
-                /* Power-down device's busmaster DMA clocks */
-                iwl_write_prph(priv, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
-                udelay(5);
-        }
+		/* Power-down device's busmaster DMA clocks */
+		iwl_write_prph(priv, APMG_CLK_DIS_REG,
+			       APMG_CLK_VAL_DMA_CLK_RQT);
+		udelay(5);
+	}
 
 	/* Make sure (redundant) we've released our request to stay awake */
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index fabab0f..0fa379b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -193,7 +193,6 @@ void iwlagn_rx_queue_restock(struct iwl_priv *priv);
 void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority);
 void iwlagn_rx_replenish(struct iwl_priv *priv);
 void iwlagn_rx_replenish_now(struct iwl_priv *priv);
-int iwlagn_rxq_stop(struct iwl_priv *priv);
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void iwl_setup_rx_handlers(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a29fdd4..8611cf0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1231,12 +1231,14 @@ struct iwl_trans;
  * struct iwl_trans_ops - transport specific operations
 
  * @rx_init: inits the rx memory, allocate it if needed
+ * @rx_stop: stop the rx
  * @rx_free: frees the rx memory
  * @tx_init:inits the tx memory, allocate if needed
  * @tx_free: frees the tx memory
  */
 struct iwl_trans_ops {
 	int (*rx_init)(struct iwl_priv *priv);
+	int (*rx_stop)(struct iwl_priv *priv);
 	void (*rx_free)(struct iwl_priv *priv);
 
 	int (*tx_init)(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 38b43e4..c4cd363 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -188,6 +188,15 @@ static void iwl_trans_rx_free(struct iwl_priv *priv)
 	rxq->rb_stts = NULL;
 }
 
+static int iwl_trans_rx_stop(struct iwl_priv *priv)
+{
+
+	/* stop Rx DMA */
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	return iwl_poll_direct_bit(priv, FH_MEM_RSSR_RX_STATUS_REG,
+			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
+}
+
 /* TODO:remove this code duplication */
 static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
 				    struct iwl_dma_ptr *ptr, size_t size)
@@ -490,6 +499,7 @@ error:
 
 static const struct iwl_trans_ops trans_ops = {
 	.rx_init = iwl_trans_rx_init,
+	.rx_stop = iwl_trans_rx_stop,
 	.rx_free = iwl_trans_rx_free,
 
 	.tx_init = iwl_trans_tx_init,
-- 
1.7.0.4

