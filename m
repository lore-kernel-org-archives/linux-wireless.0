Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbYEECYb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:31 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 22/25] iwlwifi: handle shared memory Rx index access
Date: Mon,  5 May 2008 10:22:49 +0800
Message-Id: <1209954172-3092-23-git-send-email-yi.zhu@intel.com> (sfid-20080505_044417_426935_37A7F2BC)
In-Reply-To: <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch splits ucode's and driver's shared memory Rx index access to
match 4965 and 5000 offsets.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    3 +--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 6 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 5ce7530..9be2847 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2006,7 +2006,7 @@ void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	tx->rate_n_flags = iwl4965_hw_set_rate_n_flags(rate_plcp, rate_flags);
 }
 
-int iwl4965_hw_get_rx_read(struct iwl_priv *priv)
+static int iwl4965_shared_mem_rx_idx(struct iwl_priv *priv)
 {
 	struct iwl4965_shared *s = priv->shared_virt;
 	return le32_to_cpu(s->rb_closed) & 0xFFF;
@@ -2093,6 +2093,8 @@ static int iwl4965_alloc_shared_mem(struct iwl_priv *priv)
 
 	memset(priv->shared_virt, 0, sizeof(struct iwl4965_shared));
 
+	priv->rb_closed_offset = offsetof(struct iwl4965_shared, rb_closed);
+
 	return 0;
 }
 
@@ -3821,6 +3823,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.set_hw_params = iwl4965_hw_set_hw_params,
 	.alloc_shared_mem = iwl4965_alloc_shared_mem,
 	.free_shared_mem = iwl4965_free_shared_mem,
+	.shared_mem_rx_idx = iwl4965_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
 	.disable_tx_fifo = iwl4965_disable_tx_fifo,
 	.rx_handler_setup = iwl4965_rx_handler_setup,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index feffcaf..d6b91f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -362,6 +362,8 @@ static int iwl5000_alloc_shared_mem(struct iwl_priv *priv)
 
 	memset(priv->shared_virt, 0, sizeof(struct iwl5000_shared));
 
+	priv->rb_closed_offset = offsetof(struct iwl5000_shared, rb_closed);
+
 	return 0;
 }
 
@@ -374,6 +376,12 @@ static void iwl5000_free_shared_mem(struct iwl_priv *priv)
 				    priv->shared_phys);
 }
 
+static int iwl5000_shared_mem_rx_idx(struct iwl_priv *priv)
+{
+	struct iwl5000_shared *s = priv->shared_virt;
+	return le32_to_cpu(s->rb_closed) & 0xFFF;
+}
+
 /**
  * iwl5000_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
@@ -466,6 +474,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.alloc_shared_mem = iwl5000_alloc_shared_mem,
 	.free_shared_mem = iwl5000_free_shared_mem,
+	.shared_mem_rx_idx = iwl5000_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.disable_tx_fifo = iwl5000_disable_tx_fifo,
 	.apm_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 08eccde..77428db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -103,6 +103,7 @@ struct iwl_lib_ops {
 	/* ucode shared memory */
 	int (*alloc_shared_mem)(struct iwl_priv *priv);
 	void (*free_shared_mem)(struct iwl_priv *priv);
+	int (*shared_mem_rx_idx)(struct iwl_priv *priv);
 	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
 					struct iwl4965_tx_queue *txq,
 					u16 byte_cnt);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 25dce14..1683bee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -697,7 +697,6 @@ extern int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl4965_frame *frame, u8 rate);
-extern int iwl4965_hw_get_rx_read(struct iwl_priv *priv);
 extern void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 				     struct iwl_cmd *cmd,
 				     struct ieee80211_tx_control *ctrl,
@@ -1138,6 +1137,7 @@ struct iwl_priv {
 	struct iwl_hw_params hw_params;
 	/* driver/uCode shared Tx Byte Counts and Rx status */
 	void *shared_virt;
+	int rb_closed_offset;
 	/* Physical Pointer to Tx Byte Counts and Rx status */
 	dma_addr_t shared_phys;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 171751e..a2eb90d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -399,8 +399,7 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 
 	/* Tell device where in DRAM to update its Rx status */
 	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
-			   (priv->shared_phys +
-			    offsetof(struct iwl4965_shared, rb_closed)) >> 4);
+			   (priv->shared_phys + priv->rb_closed_offset) >> 4);
 
 	/* Enable Rx DMA, enable host interrupt, Rx buffer size 4k, 256 RBDs */
 	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 77de0a5..d942e98 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3096,7 +3096,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
-	r = iwl4965_hw_get_rx_read(priv);
+	r = priv->cfg->ops->lib->shared_mem_rx_idx(priv);
 	i = rxq->read;
 
 	/* Rx interrupt, but nothing sent from uCode */
-- 
1.5.3.6

