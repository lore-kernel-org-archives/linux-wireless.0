Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbYEOF43 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 15/26] iwlwifi: move TX code into iwl-tx.c
Date: Thu, 15 May 2008 13:54:07 +0800
Message-Id: <1210830858-3410-16-git-send-email-yi.zhu@intel.com> (sfid-20080515_081614_745823_00CC8332)
In-Reply-To: <1210830858-3410-15-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves the sending part of the TX code into iwl-tx.c
including sending host commands.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  105 -----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   21 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |  662 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  581 +-----------------------
 6 files changed, 691 insertions(+), 691 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 02bbe04..8f0852d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1933,76 +1933,6 @@ int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	return rc;
 }
 
-#define RTS_HCCA_RETRY_LIMIT		3
-#define RTS_DFAULT_RETRY_LIMIT		60
-
-void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-			      struct iwl_cmd *cmd,
-			      struct ieee80211_tx_control *ctrl,
-			      struct ieee80211_hdr *hdr, int sta_id,
-			      int is_hcca)
-{
-	struct iwl_tx_cmd *tx = &cmd->cmd.tx;
-	u8 rts_retry_limit = 0;
-	u8 data_retry_limit = 0;
-	u16 fc = le16_to_cpu(hdr->frame_control);
-	u8 rate_plcp;
-	u16 rate_flags = 0;
-	int rate_idx = min(ctrl->tx_rate->hw_value & 0xffff, IWL_RATE_COUNT - 1);
-
-	rate_plcp = iwl_rates[rate_idx].plcp;
-
-	rts_retry_limit = (is_hcca) ?
-	    RTS_HCCA_RETRY_LIMIT : RTS_DFAULT_RETRY_LIMIT;
-
-	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
-		rate_flags |= RATE_MCS_CCK_MSK;
-
-
-	if (ieee80211_is_probe_response(fc)) {
-		data_retry_limit = 3;
-		if (data_retry_limit < rts_retry_limit)
-			rts_retry_limit = data_retry_limit;
-	} else
-		data_retry_limit = IWL_DEFAULT_TX_RETRY;
-
-	if (priv->data_retry_limit != -1)
-		data_retry_limit = priv->data_retry_limit;
-
-
-	if (ieee80211_is_data(fc)) {
-		tx->initial_rate_index = 0;
-		tx->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
-	} else {
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_AUTH:
-		case IEEE80211_STYPE_DEAUTH:
-		case IEEE80211_STYPE_ASSOC_REQ:
-		case IEEE80211_STYPE_REASSOC_REQ:
-			if (tx->tx_flags & TX_CMD_FLG_RTS_MSK) {
-				tx->tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-				tx->tx_flags |= TX_CMD_FLG_CTS_MSK;
-			}
-			break;
-		default:
-			break;
-		}
-
-		/* Alternate between antenna A and B for successive frames */
-		if (priv->use_ant_b_for_management_frame) {
-			priv->use_ant_b_for_management_frame = 0;
-			rate_flags |= RATE_MCS_ANT_B_MSK;
-		} else {
-			priv->use_ant_b_for_management_frame = 1;
-			rate_flags |= RATE_MCS_ANT_A_MSK;
-		}
-	}
-
-	tx->rts_retry_limit = rts_retry_limit;
-	tx->data_retry_limit = data_retry_limit;
-	tx->rate_n_flags = iwl4965_hw_set_rate_n_flags(rate_plcp, rate_flags);
-}
-
 static int iwl4965_shared_mem_rx_idx(struct iwl_priv *priv)
 {
 	struct iwl4965_shared *s = priv->shared_virt;
@@ -2046,40 +1976,6 @@ unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 	return (sizeof(*tx_beacon_cmd) + frame_size);
 }
 
-int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
-				 dma_addr_t addr, u16 len)
-{
-	int index, is_odd;
-	struct iwl_tfd_frame *tfd = ptr;
-	u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
-
-	/* Each TFD can point to a maximum 20 Tx buffers */
-	if ((num_tbs >= MAX_NUM_OF_TBS) || (num_tbs < 0)) {
-		IWL_ERROR("Error can not send more than %d chunks\n",
-			  MAX_NUM_OF_TBS);
-		return -EINVAL;
-	}
-
-	index = num_tbs / 2;
-	is_odd = num_tbs & 0x1;
-
-	if (!is_odd) {
-		tfd->pa[index].tb1_addr = cpu_to_le32(addr);
-		IWL_SET_BITS(tfd->pa[index], tb1_addr_hi,
-			     iwl_get_dma_hi_address(addr));
-		IWL_SET_BITS(tfd->pa[index], tb1_len, len);
-	} else {
-		IWL_SET_BITS(tfd->pa[index], tb2_addr_lo16,
-			     (u32) (addr & 0xffff));
-		IWL_SET_BITS(tfd->pa[index], tb2_addr_hi20, addr >> 16);
-		IWL_SET_BITS(tfd->pa[index], tb2_len, len);
-	}
-
-	IWL_SET_BITS(*tfd, num_tbs, num_tbs + 1);
-
-	return 0;
-}
-
 static int iwl4965_alloc_shared_mem(struct iwl_priv *priv)
 {
 	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
@@ -3711,7 +3607,6 @@ static struct iwl_hcmd_ops iwl4965_hcmd = {
 
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.get_hcmd_size = iwl4965_get_hcmd_size,
-	.enqueue_hcmd = iwl4965_enqueue_hcmd,
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
 #ifdef CONFIG_IWL4965_RUN_TIME_CALIB
 	.chain_noise_reset = iwl4965_chain_noise_reset,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index dcf1e56..b159fd3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -87,7 +87,6 @@ struct iwl_hcmd_ops {
 };
 struct iwl_hcmd_utils_ops {
 	u16 (*get_hcmd_size)(u8 cmd_id, u16 len);
-	int (*enqueue_hcmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 	u16 (*build_addsta_hcmd)(const struct iwl_addsta_cmd *cmd, u8 *data);
 #ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	void (*gain_computation)(struct iwl_priv *priv,
@@ -208,10 +207,14 @@ void iwl_rx_allocate(struct iwl_priv *priv);
 * TX
 ******************************************************/
 int iwl_txq_ctx_reset(struct iwl_priv *priv);
+int iwl_tx_skb(struct iwl_priv *priv,
+		struct sk_buff *skb, struct ieee80211_tx_control *ctl);
 /* FIXME: remove when free Tx is fully merged into iwlcore */
 int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
-
+int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
+					dma_addr_t addr, u16 len);
+int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
@@ -227,6 +230,8 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 			   int (*callback)(struct iwl_priv *priv,
 					   struct iwl_cmd *cmd,
 					   struct sk_buff *skb));
+
+int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
 #define STATUS_HCMD_ACTIVE	0	/* host command in progress */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7bd99f9..4106efd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -689,8 +689,6 @@ extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
 extern int iwl4965_hw_nic_stop_master(struct iwl_priv *priv);
 extern void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_nic_reset(struct iwl_priv *priv);
-extern int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
-					dma_addr_t addr, u16 len);
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl_frame *frame, u8 rate);
@@ -719,6 +717,25 @@ extern u8 iwl_find_station(struct iwl_priv *priv, const u8 *bssid);
 extern int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel);
 extern int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 extern int iwl_queue_space(const struct iwl_queue *q);
+static inline int iwl_queue_used(const struct iwl_queue *q, int i)
+{
+	return q->write_ptr > q->read_ptr ?
+		(i >= q->read_ptr && i < q->write_ptr) :
+		!(i < q->read_ptr && i >= q->write_ptr);
+}
+
+
+static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
+{
+	/* This is for scan command, the big buffer at end of command array */
+	if (is_huge)
+		return q->n_window;	/* must be power of 2 */
+
+	/* Otherwise, use normal size buffers */
+	return index & (q->n_window - 1);
+}
+
+
 struct iwl_priv;
 
 extern void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio);
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 0412adf..dab4a0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -139,7 +139,7 @@ static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EBUSY;
 
-	ret = priv->cfg->ops->utils->enqueue_hcmd(priv, cmd);
+	ret = iwl_enqueue_hcmd(priv, cmd);
 	if (ret < 0) {
 		IWL_ERROR("Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
@@ -170,7 +170,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (cmd->meta.flags & CMD_WANT_SKB)
 		cmd->meta.source = &cmd->meta;
 
-	cmd_idx = priv->cfg->ops->utils->enqueue_hcmd(priv, cmd);
+	cmd_idx = iwl_enqueue_hcmd(priv, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
 		IWL_ERROR("Error sending %s: enqueue_hcmd failed: %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 870d257..a37ced5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -27,6 +27,7 @@
  *
  *****************************************************************************/
 
+#include <linux/etherdevice.h>
 #include <net/mac80211.h>
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -95,6 +96,89 @@ int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 }
 EXPORT_SYMBOL(iwl_hw_txq_free_tfd);
 
+
+int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
+				 dma_addr_t addr, u16 len)
+{
+	int index, is_odd;
+	struct iwl_tfd_frame *tfd = ptr;
+	u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
+
+	/* Each TFD can point to a maximum 20 Tx buffers */
+	if ((num_tbs >= MAX_NUM_OF_TBS) || (num_tbs < 0)) {
+		IWL_ERROR("Error can not send more than %d chunks\n",
+			  MAX_NUM_OF_TBS);
+		return -EINVAL;
+	}
+
+	index = num_tbs / 2;
+	is_odd = num_tbs & 0x1;
+
+	if (!is_odd) {
+		tfd->pa[index].tb1_addr = cpu_to_le32(addr);
+		IWL_SET_BITS(tfd->pa[index], tb1_addr_hi,
+			     iwl_get_dma_hi_address(addr));
+		IWL_SET_BITS(tfd->pa[index], tb1_len, len);
+	} else {
+		IWL_SET_BITS(tfd->pa[index], tb2_addr_lo16,
+			     (u32) (addr & 0xffff));
+		IWL_SET_BITS(tfd->pa[index], tb2_addr_hi20, addr >> 16);
+		IWL_SET_BITS(tfd->pa[index], tb2_len, len);
+	}
+
+	IWL_SET_BITS(*tfd, num_tbs, num_tbs + 1);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_hw_txq_attach_buf_to_tfd);
+
+/**
+ * iwl_txq_update_write_ptr - Send new write index to hardware
+ */
+int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+{
+	u32 reg = 0;
+	int ret = 0;
+	int txq_id = txq->q.id;
+
+	if (txq->need_update == 0)
+		return ret;
+
+	/* if we're trying to save power */
+	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
+		/* wake up nic if it's powered down ...
+		 * uCode will wake up, and interrupt us again, so next
+		 * time we'll skip this part. */
+		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
+
+		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
+			IWL_DEBUG_INFO("Requesting wakeup, GP1 = 0x%x\n", reg);
+			iwl_set_bit(priv, CSR_GP_CNTRL,
+				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+			return ret;
+		}
+
+		/* restore this queue's parameters in nic hardware. */
+		ret = iwl_grab_nic_access(priv);
+		if (ret)
+			return ret;
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
+				     txq->q.write_ptr | (txq_id << 8));
+		iwl_release_nic_access(priv);
+
+	/* else not in power-save mode, uCode will never sleep when we're
+	 * trying to tx (during RFKILL, we're not trying to tx). */
+	} else
+		iwl_write32(priv, HBUS_TARG_WRPTR,
+			    txq->q.write_ptr | (txq_id << 8));
+
+	txq->need_update = 0;
+
+	return ret;
+}
+EXPORT_SYMBOL(iwl_txq_update_write_ptr);
+
+
 /**
  * iwl_tx_queue_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
@@ -137,6 +221,47 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	memset(txq, 0, sizeof(*txq));
 }
 
+/*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
+ * DMA services
+ *
+ * Theory of operation
+ *
+ * A Tx or Rx queue resides in host DRAM, and is comprised of a circular buffer
+ * of buffer descriptors, each of which points to one or more data buffers for
+ * the device to read from or fill.  Driver and device exchange status of each
+ * queue via "read" and "write" pointers.  Driver keeps minimum of 2 empty
+ * entries in each circular buffer, to protect against confusing empty and full
+ * queue states.
+ *
+ * The device reads or writes the data in the queues via the device's several
+ * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
+ *
+ * For Tx queue, there are low mark and high mark limits. If, after queuing
+ * the packet for Tx, free space become < low mark, Tx queue stopped. When
+ * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
+ * Tx queue resumed.
+ *
+ * See more detailed info in iwl-4965-hw.h.
+ ***************************************************/
+
+int iwl_queue_space(const struct iwl_queue *q)
+{
+	int s = q->read_ptr - q->write_ptr;
+
+	if (q->read_ptr > q->write_ptr)
+		s -= q->n_bd;
+
+	if (s <= 0)
+		s += q->n_window;
+	/* keep some reserve to not confuse empty and full situations */
+	s -= 2;
+	if (s < 0)
+		s = 0;
+	return s;
+}
+EXPORT_SYMBOL(iwl_queue_space);
+
+
 /**
  * iwl_hw_txq_ctx_free - Free TXQ Context
  *
@@ -371,3 +496,540 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
  error_kw:
 	return ret;
 }
+
+/*
+ * handle build REPLY_TX command notification.
+ */
+static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
+				  struct iwl_tx_cmd *tx_cmd,
+				  struct ieee80211_tx_control *ctrl,
+				  struct ieee80211_hdr *hdr,
+				  int is_unicast, u8 std_id)
+{
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le32 tx_flags = tx_cmd->tx_flags;
+
+	tx_cmd->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+	if (!(ctrl->flags & IEEE80211_TXCTL_NO_ACK)) {
+		tx_flags |= TX_CMD_FLG_ACK_MSK;
+		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
+			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+		if (ieee80211_is_probe_response(fc) &&
+		    !(le16_to_cpu(hdr->seq_ctrl) & 0xf))
+			tx_flags |= TX_CMD_FLG_TSF_MSK;
+	} else {
+		tx_flags &= (~TX_CMD_FLG_ACK_MSK);
+		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+	}
+
+	if (ieee80211_is_back_request(fc))
+		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
+
+
+	tx_cmd->sta_id = std_id;
+	if (ieee80211_get_morefrag(hdr))
+		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
+
+	if (ieee80211_is_qos_data(fc)) {
+		u8 *qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+		tx_cmd->tid_tspec = qc[0] & 0xf;
+		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
+	} else {
+		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+	}
+
+	if (ctrl->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+		tx_flags |= TX_CMD_FLG_RTS_MSK;
+		tx_flags &= ~TX_CMD_FLG_CTS_MSK;
+	} else if (ctrl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+		tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+		tx_flags |= TX_CMD_FLG_CTS_MSK;
+	}
+
+	if ((tx_flags & TX_CMD_FLG_RTS_MSK) || (tx_flags & TX_CMD_FLG_CTS_MSK))
+		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
+
+	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
+	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
+		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ ||
+		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ)
+			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(3);
+		else
+			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(2);
+	} else {
+		tx_cmd->timeout.pm_frame_timeout = 0;
+	}
+
+	tx_cmd->driver_txop = 0;
+	tx_cmd->tx_flags = tx_flags;
+	tx_cmd->next_frame_len = 0;
+}
+
+#define RTS_HCCA_RETRY_LIMIT		3
+#define RTS_DFAULT_RETRY_LIMIT		60
+
+static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
+			      struct iwl_tx_cmd *tx_cmd,
+			      struct ieee80211_tx_control *ctrl,
+			      u16 fc, int sta_id,
+			      int is_hcca)
+{
+	u8 rts_retry_limit = 0;
+	u8 data_retry_limit = 0;
+	u8 rate_plcp;
+	u16 rate_flags = 0;
+	int rate_idx = min(ctrl->tx_rate->hw_value & 0xffff, IWL_RATE_COUNT - 1);
+
+	rate_plcp = iwl_rates[rate_idx].plcp;
+
+	rts_retry_limit = (is_hcca) ?
+	    RTS_HCCA_RETRY_LIMIT : RTS_DFAULT_RETRY_LIMIT;
+
+	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
+		rate_flags |= RATE_MCS_CCK_MSK;
+
+
+	if (ieee80211_is_probe_response(fc)) {
+		data_retry_limit = 3;
+		if (data_retry_limit < rts_retry_limit)
+			rts_retry_limit = data_retry_limit;
+	} else
+		data_retry_limit = IWL_DEFAULT_TX_RETRY;
+
+	if (priv->data_retry_limit != -1)
+		data_retry_limit = priv->data_retry_limit;
+
+
+	if (ieee80211_is_data(fc)) {
+		tx_cmd->initial_rate_index = 0;
+		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
+	} else {
+		switch (fc & IEEE80211_FCTL_STYPE) {
+		case IEEE80211_STYPE_AUTH:
+		case IEEE80211_STYPE_DEAUTH:
+		case IEEE80211_STYPE_ASSOC_REQ:
+		case IEEE80211_STYPE_REASSOC_REQ:
+			if (tx_cmd->tx_flags & TX_CMD_FLG_RTS_MSK) {
+				tx_cmd->tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+				tx_cmd->tx_flags |= TX_CMD_FLG_CTS_MSK;
+			}
+			break;
+		default:
+			break;
+		}
+
+		/* Alternate between antenna A and B for successive frames */
+		if (priv->use_ant_b_for_management_frame) {
+			priv->use_ant_b_for_management_frame = 0;
+			rate_flags |= RATE_MCS_ANT_B_MSK;
+		} else {
+			priv->use_ant_b_for_management_frame = 1;
+			rate_flags |= RATE_MCS_ANT_A_MSK;
+		}
+	}
+
+	tx_cmd->rts_retry_limit = rts_retry_limit;
+	tx_cmd->data_retry_limit = data_retry_limit;
+	tx_cmd->rate_n_flags = iwl4965_hw_set_rate_n_flags(rate_plcp, rate_flags);
+}
+
+static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
+				      struct ieee80211_tx_control *ctl,
+				      struct iwl_tx_cmd *tx_cmd,
+				      struct sk_buff *skb_frag,
+				      int sta_id)
+{
+	struct iwl_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
+	struct iwl_wep_key *wepkey;
+	int keyidx = 0;
+
+	BUG_ON(ctl->hw_key->hw_key_idx > 3);
+
+	switch (keyinfo->alg) {
+	case ALG_CCMP:
+		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
+		memcpy(tx_cmd->key, keyinfo->key, keyinfo->keylen);
+		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
+			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
+		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
+		break;
+
+	case ALG_TKIP:
+		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
+		ieee80211_get_tkip_key(keyinfo->conf, skb_frag,
+			IEEE80211_TKIP_P2_KEY, tx_cmd->key);
+		IWL_DEBUG_TX("tx_cmd with tkip hwcrypto\n");
+		break;
+
+	case ALG_WEP:
+		wepkey = &priv->wep_keys[ctl->hw_key->hw_key_idx];
+		tx_cmd->sec_ctl = 0;
+		if (priv->default_wep_key) {
+			/* the WEP key was sent as static */
+			keyidx = ctl->hw_key->hw_key_idx;
+			memcpy(&tx_cmd->key[3], wepkey->key,
+							wepkey->key_size);
+			if (wepkey->key_size == WEP_KEY_LEN_128)
+				tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
+		} else {
+			/* the WEP key was sent as dynamic */
+			keyidx = keyinfo->keyidx;
+			memcpy(&tx_cmd->key[3], keyinfo->key,
+							keyinfo->keylen);
+			if (keyinfo->keylen == WEP_KEY_LEN_128)
+				tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
+		}
+
+		tx_cmd->sec_ctl |= (TX_CMD_SEC_WEP |
+			(keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
+
+		IWL_DEBUG_TX("Configuring packet for WEP encryption "
+			     "with key %d\n", keyidx);
+		break;
+
+	default:
+		printk(KERN_ERR "Unknown encode alg %d\n", keyinfo->alg);
+		break;
+	}
+}
+
+static void iwl_update_tx_stats(struct iwl_priv *priv, u16 fc, u16 len)
+{
+	/* 0 - mgmt, 1 - cnt, 2 - data */
+	int idx = (fc & IEEE80211_FCTL_FTYPE) >> 2;
+	priv->tx_stats[idx].cnt++;
+	priv->tx_stats[idx].bytes += len;
+}
+
+/*
+ * start REPLY_TX command process
+ */
+int iwl_tx_skb(struct iwl_priv *priv,
+		struct sk_buff *skb, struct ieee80211_tx_control *ctl)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct iwl_tfd_frame *tfd;
+	u32 *control_flags;
+	int txq_id = ctl->queue;
+	struct iwl_tx_queue *txq = NULL;
+	struct iwl_queue *q = NULL;
+	dma_addr_t phys_addr;
+	dma_addr_t txcmd_phys;
+	dma_addr_t scratch_phys;
+	struct iwl_cmd *out_cmd = NULL;
+	struct iwl_tx_cmd *tx_cmd;
+	u16 len, idx, len_org;
+	u16 seq_number = 0;
+	u8 id, hdr_len, unicast;
+	u8 sta_id;
+	u16 fc;
+	u8 wait_write_ptr = 0;
+	u8 tid = 0;
+	u8 *qc = NULL;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_DROP("Dropping - RF KILL\n");
+		goto drop_unlock;
+	}
+
+	if (!priv->vif) {
+		IWL_DEBUG_DROP("Dropping - !priv->vif\n");
+		goto drop_unlock;
+	}
+
+	if ((ctl->tx_rate->hw_value & 0xFF) == IWL_INVALID_RATE) {
+		IWL_ERROR("ERROR: No TX rate available.\n");
+		goto drop_unlock;
+	}
+
+	unicast = !is_multicast_ether_addr(hdr->addr1);
+	id = 0;
+
+	fc = le16_to_cpu(hdr->frame_control);
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (ieee80211_is_auth(fc))
+		IWL_DEBUG_TX("Sending AUTH frame\n");
+	else if (ieee80211_is_assoc_request(fc))
+		IWL_DEBUG_TX("Sending ASSOC frame\n");
+	else if (ieee80211_is_reassoc_request(fc))
+		IWL_DEBUG_TX("Sending REASSOC frame\n");
+#endif
+
+	/* drop all data frame if we are not associated */
+	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+	   (!iwl_is_associated(priv) ||
+	    ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id) ||
+	    !priv->assoc_station_added)) {
+		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
+		goto drop_unlock;
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	hdr_len = ieee80211_get_hdrlen(fc);
+
+	/* Find (or create) index into station table for destination station */
+	sta_id = iwl_get_sta_id(priv, hdr);
+	if (sta_id == IWL_INVALID_STATION) {
+		DECLARE_MAC_BUF(mac);
+
+		IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
+			       print_mac(mac, hdr->addr1));
+		goto drop;
+	}
+
+	IWL_DEBUG_TX("station Id %d\n", sta_id);
+
+	if (ieee80211_is_qos_data(fc)) {
+		qc = ieee80211_get_qos_ctrl(hdr, hdr_len);
+		tid = qc[0] & 0xf;
+		seq_number = priv->stations[sta_id].tid[tid].seq_number &
+				IEEE80211_SCTL_SEQ;
+		hdr->seq_ctrl = cpu_to_le16(seq_number) |
+			(hdr->seq_ctrl &
+				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
+		seq_number += 0x10;
+#ifdef CONFIG_IWL4965_HT
+		/* aggregation is on for this <sta,tid> */
+		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
+			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
+		priv->stations[sta_id].tid[tid].tfds_in_queue++;
+#endif /* CONFIG_IWL4965_HT */
+	}
+
+	/* Descriptor for chosen Tx queue */
+	txq = &priv->txq[txq_id];
+	q = &txq->q;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* Set up first empty TFD within this queue's circular TFD buffer */
+	tfd = &txq->bd[q->write_ptr];
+	memset(tfd, 0, sizeof(*tfd));
+	control_flags = (u32 *) tfd;
+	idx = get_cmd_index(q, q->write_ptr, 0);
+
+	/* Set up driver data for this TFD */
+	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
+	txq->txb[q->write_ptr].skb[0] = skb;
+	memcpy(&(txq->txb[q->write_ptr].status.control),
+	       ctl, sizeof(struct ieee80211_tx_control));
+
+	/* Set up first empty entry in queue's array of Tx/cmd buffers */
+	out_cmd = &txq->cmd[idx];
+	tx_cmd = &out_cmd->cmd.tx;
+	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
+	memset(tx_cmd, 0, sizeof(struct iwl_tx_cmd));
+
+	/*
+	 * Set up the Tx-command (not MAC!) header.
+	 * Store the chosen Tx queue and TFD index within the sequence field;
+	 * after Tx, uCode's Tx response will return this value so driver can
+	 * locate the frame within the tx queue and do post-tx processing.
+	 */
+	out_cmd->hdr.cmd = REPLY_TX;
+	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
+				INDEX_TO_SEQ(q->write_ptr)));
+
+	/* Copy MAC header from skb into command buffer */
+	memcpy(tx_cmd->hdr, hdr, hdr_len);
+
+	/*
+	 * Use the first empty entry in this queue's command buffer array
+	 * to contain the Tx command and MAC header concatenated together
+	 * (payload data will be in another buffer).
+	 * Size of this varies, due to varying MAC header length.
+	 * If end is not dword aligned, we'll have 2 extra bytes at the end
+	 * of the MAC header (device reads on dword boundaries).
+	 * We'll tell device about this padding later.
+	 */
+	len = sizeof(struct iwl_tx_cmd) +
+		sizeof(struct iwl_cmd_header) + hdr_len;
+
+	len_org = len;
+	len = (len + 3) & ~3;
+
+	if (len_org != len)
+		len_org = 1;
+	else
+		len_org = 0;
+
+	/* Physical address of this Tx command's header (not MAC header!),
+	 * within command buffer array. */
+	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
+		     offsetof(struct iwl_cmd, hdr);
+
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
+	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
+
+	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
+		iwl_tx_cmd_build_hwcrypto(priv, ctl, tx_cmd, skb, sta_id);
+
+	/* Set up TFD's 2nd entry to point directly to remainder of skb,
+	 * if any (802.11 null frames have no payload). */
+	len = skb->len - hdr_len;
+	if (len) {
+		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
+					   len, PCI_DMA_TODEVICE);
+		iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
+	}
+
+	/* Tell NIC about any 2-byte padding after MAC header */
+	if (len_org)
+		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
+
+	/* Total # bytes to be transmitted */
+	len = (u16)skb->len;
+	tx_cmd->len = cpu_to_le16(len);
+	/* TODO need this for burst mode later on */
+	iwl_tx_cmd_build_basic(priv, tx_cmd, ctl, hdr, unicast, sta_id);
+
+	/* set is_hcca to 0; it probably will never be implemented */
+	iwl_tx_cmd_build_rate(priv, tx_cmd, ctl, fc, sta_id, 0);
+
+	iwl_update_tx_stats(priv, fc, len);
+
+	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
+		offsetof(struct iwl_tx_cmd, scratch);
+	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
+	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
+
+	if (!ieee80211_get_morefrag(hdr)) {
+		txq->need_update = 1;
+		if (qc)
+			priv->stations[sta_id].tid[tid].seq_number = seq_number;
+	} else {
+		wait_write_ptr = 1;
+		txq->need_update = 0;
+	}
+
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
+
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
+
+	/* Set up entry for this TFD in Tx byte-count array */
+	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, len);
+
+	/* Tell device the write index *just past* this latest filled TFD */
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
+	ret = iwl_txq_update_write_ptr(priv, txq);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (ret)
+		return ret;
+
+	if ((iwl_queue_space(q) < q->high_mark)
+	    && priv->mac80211_registered) {
+		if (wait_write_ptr) {
+			spin_lock_irqsave(&priv->lock, flags);
+			txq->need_update = 1;
+			iwl_txq_update_write_ptr(priv, txq);
+			spin_unlock_irqrestore(&priv->lock, flags);
+		}
+
+		ieee80211_stop_queue(priv->hw, ctl->queue);
+	}
+
+	return 0;
+
+drop_unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+drop:
+	return -1;
+}
+EXPORT_SYMBOL(iwl_tx_skb);
+
+/*************** HOST COMMAND QUEUE FUNCTIONS   *****/
+
+/**
+ * iwl_enqueue_hcmd - enqueue a uCode command
+ * @priv: device private data point
+ * @cmd: a point to the ucode command structure
+ *
+ * The function returns < 0 values to indicate the operation is
+ * failed. On success, it turns the index (> 0) of command in the
+ * command queue.
+ */
+int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+{
+	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
+	struct iwl_queue *q = &txq->q;
+	struct iwl_tfd_frame *tfd;
+	u32 *control_flags;
+	struct iwl_cmd *out_cmd;
+	u32 idx;
+	u16 fix_size;
+	dma_addr_t phys_addr;
+	int ret;
+	unsigned long flags;
+
+	cmd->len = priv->cfg->ops->utils->get_hcmd_size(cmd->id, cmd->len);
+	fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
+
+	/* If any of the command structures end up being larger than
+	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
+	 * we will need to increase the size of the TFD entries */
+	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
+	       !(cmd->meta.flags & CMD_SIZE_HUGE));
+
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_INFO("Not sending command - RF KILL");
+		return -EIO;
+	}
+
+	if (iwl_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
+		IWL_ERROR("No space for Tx\n");
+		return -ENOSPC;
+	}
+
+	spin_lock_irqsave(&priv->hcmd_lock, flags);
+
+	tfd = &txq->bd[q->write_ptr];
+	memset(tfd, 0, sizeof(*tfd));
+
+	control_flags = (u32 *) tfd;
+
+	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
+	out_cmd = &txq->cmd[idx];
+
+	out_cmd->hdr.cmd = cmd->id;
+	memcpy(&out_cmd->meta, &cmd->meta, sizeof(cmd->meta));
+	memcpy(&out_cmd->cmd.payload, cmd->data, cmd->len);
+
+	/* At this point, the out_cmd now has all of the incoming cmd
+	 * information */
+
+	out_cmd->hdr.flags = 0;
+	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
+			INDEX_TO_SEQ(q->write_ptr));
+	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
+		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
+
+	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
+			offsetof(struct iwl_cmd, hdr);
+	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
+
+	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
+		     "%d bytes at %d[%d]:%d\n",
+		     get_cmd_string(out_cmd->hdr.cmd),
+		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
+		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
+
+	txq->need_update = 1;
+
+	/* Set up entry in queue's byte count circular buffer */
+	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, 0);
+
+	/* Increment and update queue's write index */
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
+	ret = iwl_txq_update_write_ptr(priv, txq);
+
+	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
+	return ret ? ret : idx;
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e3f872e..dd2fd40 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -53,8 +53,6 @@
 #include "iwl-sta.h"
 #include "iwl-calib.h"
 
-static int iwl_txq_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl_tx_queue *txq);
 
 /******************************************************************************
  *
@@ -135,69 +133,6 @@ static const char *iwl4965_escape_essid(const char *essid, u8 essid_len)
 	return escaped;
 }
 
-
-/*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
- * DMA services
- *
- * Theory of operation
- *
- * A Tx or Rx queue resides in host DRAM, and is comprised of a circular buffer
- * of buffer descriptors, each of which points to one or more data buffers for
- * the device to read from or fill.  Driver and device exchange status of each
- * queue via "read" and "write" pointers.  Driver keeps minimum of 2 empty
- * entries in each circular buffer, to protect against confusing empty and full
- * queue states.
- *
- * The device reads or writes the data in the queues via the device's several
- * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
- *
- * For Tx queue, there are low mark and high mark limits. If, after queuing
- * the packet for Tx, free space become < low mark, Tx queue stopped. When
- * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
- * Tx queue resumed.
- *
- * The 4965 operates with up to 17 queues:  One receive queue, one transmit
- * queue (#4) for sending commands to the device firmware, and 15 other
- * Tx queues that may be mapped to prioritized Tx DMA/FIFO channels.
- *
- * See more detailed info in iwl-4965-hw.h.
- ***************************************************/
-
-int iwl_queue_space(const struct iwl_queue *q)
-{
-	int s = q->read_ptr - q->write_ptr;
-
-	if (q->read_ptr > q->write_ptr)
-		s -= q->n_bd;
-
-	if (s <= 0)
-		s += q->n_window;
-	/* keep some reserve to not confuse empty and full situations */
-	s -= 2;
-	if (s < 0)
-		s = 0;
-	return s;
-}
-
-
-static inline int iwl_queue_used(const struct iwl_queue *q, int i)
-{
-	return q->write_ptr > q->read_ptr ?
-		(i >= q->read_ptr && i < q->write_ptr) :
-		!(i < q->read_ptr && i >= q->write_ptr);
-}
-
-static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
-{
-	/* This is for scan command, the big buffer at end of command array */
-	if (is_huge)
-		return q->n_window;	/* must be power of 2 */
-
-	/* Otherwise, use normal size buffers */
-	return index & (q->n_window - 1);
-}
-
-
 /*************** STATION TABLE MANAGEMENT ****
  * mac80211 should be examined to determine if sta_info is duplicating
  * the functionality provided here
@@ -250,95 +185,6 @@ out:
 
 
 
-/*************** HOST COMMAND QUEUE FUNCTIONS   *****/
-
-/**
- * iwl4965_enqueue_hcmd - enqueue a uCode command
- * @priv: device private data point
- * @cmd: a point to the ucode command structure
- *
- * The function returns < 0 values to indicate the operation is
- * failed. On success, it turns the index (> 0) of command in the
- * command queue.
- */
-int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
-{
-	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
-	struct iwl_queue *q = &txq->q;
-	struct iwl_tfd_frame *tfd;
-	u32 *control_flags;
-	struct iwl_cmd *out_cmd;
-	u32 idx;
-	u16 fix_size;
-	dma_addr_t phys_addr;
-	int ret;
-	unsigned long flags;
-
-	cmd->len = priv->cfg->ops->utils->get_hcmd_size(cmd->id, cmd->len);
-	fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
-
-	/* If any of the command structures end up being larger than
-	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
-	 * we will need to increase the size of the TFD entries */
-	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
-	       !(cmd->meta.flags & CMD_SIZE_HUGE));
-
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_INFO("Not sending command - RF KILL");
-		return -EIO;
-	}
-
-	if (iwl_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
-		IWL_ERROR("No space for Tx\n");
-		return -ENOSPC;
-	}
-
-	spin_lock_irqsave(&priv->hcmd_lock, flags);
-
-	tfd = &txq->bd[q->write_ptr];
-	memset(tfd, 0, sizeof(*tfd));
-
-	control_flags = (u32 *) tfd;
-
-	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
-	out_cmd = &txq->cmd[idx];
-
-	out_cmd->hdr.cmd = cmd->id;
-	memcpy(&out_cmd->meta, &cmd->meta, sizeof(cmd->meta));
-	memcpy(&out_cmd->cmd.payload, cmd->data, cmd->len);
-
-	/* At this point, the out_cmd now has all of the incoming cmd
-	 * information */
-
-	out_cmd->hdr.flags = 0;
-	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
-			INDEX_TO_SEQ(q->write_ptr));
-	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
-		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
-
-	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
-			offsetof(struct iwl_cmd, hdr);
-	iwl4965_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
-
-	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
-		     "%d bytes at %d[%d]:%d\n",
-		     get_cmd_string(out_cmd->hdr.cmd),
-		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
-		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
-
-	txq->need_update = 1;
-
-	/* Set up entry in queue's byte count circular buffer */
-	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, 0);
-
-	/* Increment and update queue's write index */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	ret = iwl_txq_update_write_ptr(priv, txq);
-
-	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
-	return ret ? ret : idx;
-}
-
 static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 {
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
@@ -1453,385 +1299,6 @@ static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 	return 0;
 }
 
-static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
-				      struct ieee80211_tx_control *ctl,
-				      struct iwl_cmd *cmd,
-				      struct sk_buff *skb_frag,
-				      int sta_id)
-{
-	struct iwl_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
-	struct iwl_wep_key *wepkey;
-	int keyidx = 0;
-
-	BUG_ON(ctl->hw_key->hw_key_idx > 3);
-
-	switch (keyinfo->alg) {
-	case ALG_CCMP:
-		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_CCM;
-		memcpy(cmd->cmd.tx.key, keyinfo->key, keyinfo->keylen);
-		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
-			cmd->cmd.tx.tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
-		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
-		break;
-
-	case ALG_TKIP:
-		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_TKIP;
-		ieee80211_get_tkip_key(keyinfo->conf, skb_frag,
-			IEEE80211_TKIP_P2_KEY, cmd->cmd.tx.key);
-		IWL_DEBUG_TX("tx_cmd with tkip hwcrypto\n");
-		break;
-
-	case ALG_WEP:
-		wepkey = &priv->wep_keys[ctl->hw_key->hw_key_idx];
-		cmd->cmd.tx.sec_ctl = 0;
-		if (priv->default_wep_key) {
-			/* the WEP key was sent as static */
-			keyidx = ctl->hw_key->hw_key_idx;
-			memcpy(&cmd->cmd.tx.key[3], wepkey->key,
-							wepkey->key_size);
-			if (wepkey->key_size == WEP_KEY_LEN_128)
-				cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
-		} else {
-			/* the WEP key was sent as dynamic */
-			keyidx = keyinfo->keyidx;
-			memcpy(&cmd->cmd.tx.key[3], keyinfo->key,
-							keyinfo->keylen);
-			if (keyinfo->keylen == WEP_KEY_LEN_128)
-				cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
-		}
-
-		cmd->cmd.tx.sec_ctl |= (TX_CMD_SEC_WEP |
-			(keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
-
-		IWL_DEBUG_TX("Configuring packet for WEP encryption "
-			     "with key %d\n", keyidx);
-		break;
-
-	default:
-		printk(KERN_ERR "Unknown encode alg %d\n", keyinfo->alg);
-		break;
-	}
-}
-
-/*
- * handle build REPLY_TX command notification.
- */
-static void iwl4965_build_tx_cmd_basic(struct iwl_priv *priv,
-				  struct iwl_cmd *cmd,
-				  struct ieee80211_tx_control *ctrl,
-				  struct ieee80211_hdr *hdr,
-				  int is_unicast, u8 std_id)
-{
-	u16 fc = le16_to_cpu(hdr->frame_control);
-	__le32 tx_flags = cmd->cmd.tx.tx_flags;
-
-	cmd->cmd.tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-	if (!(ctrl->flags & IEEE80211_TXCTL_NO_ACK)) {
-		tx_flags |= TX_CMD_FLG_ACK_MSK;
-		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)
-			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-		if (ieee80211_is_probe_response(fc) &&
-		    !(le16_to_cpu(hdr->seq_ctrl) & 0xf))
-			tx_flags |= TX_CMD_FLG_TSF_MSK;
-	} else {
-		tx_flags &= (~TX_CMD_FLG_ACK_MSK);
-		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-	}
-
-	if (ieee80211_is_back_request(fc))
-		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
-
-
-	cmd->cmd.tx.sta_id = std_id;
-	if (ieee80211_get_morefrag(hdr))
-		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
-
-	if (ieee80211_is_qos_data(fc)) {
-		u8 *qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
-		cmd->cmd.tx.tid_tspec = qc[0] & 0xf;
-		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
-	} else {
-		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-	}
-
-	if (ctrl->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
-		tx_flags |= TX_CMD_FLG_RTS_MSK;
-		tx_flags &= ~TX_CMD_FLG_CTS_MSK;
-	} else if (ctrl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
-		tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-		tx_flags |= TX_CMD_FLG_CTS_MSK;
-	}
-
-	if ((tx_flags & TX_CMD_FLG_RTS_MSK) || (tx_flags & TX_CMD_FLG_CTS_MSK))
-		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
-
-	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) {
-		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_ASSOC_REQ ||
-		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_REQ)
-			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(3);
-		else
-			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(2);
-	} else {
-		cmd->cmd.tx.timeout.pm_frame_timeout = 0;
-	}
-
-	cmd->cmd.tx.driver_txop = 0;
-	cmd->cmd.tx.tx_flags = tx_flags;
-	cmd->cmd.tx.next_frame_len = 0;
-}
-static void iwl_update_tx_stats(struct iwl_priv *priv, u16 fc, u16 len)
-{
-	/* 0 - mgmt, 1 - cnt, 2 - data */
-	int idx = (fc & IEEE80211_FCTL_FTYPE) >> 2;
-	priv->tx_stats[idx].cnt++;
-	priv->tx_stats[idx].bytes += len;
-}
-/*
- * start REPLY_TX command process
- */
-static int iwl4965_tx_skb(struct iwl_priv *priv,
-		      struct sk_buff *skb, struct ieee80211_tx_control *ctl)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl_tfd_frame *tfd;
-	u32 *control_flags;
-	int txq_id = ctl->queue;
-	struct iwl_tx_queue *txq = NULL;
-	struct iwl_queue *q = NULL;
-	dma_addr_t phys_addr;
-	dma_addr_t txcmd_phys;
-	dma_addr_t scratch_phys;
-	struct iwl_cmd *out_cmd = NULL;
-	u16 len, idx, len_org;
-	u8 hdr_len;
-	u8 id;
-	u8 unicast;
-	u8 sta_id;
-	u8 tid = 0;
-	u8 wait_write_ptr = 0;
-	u16 seq_number = 0;
-	u16 fc;
-	u8 *qc = NULL;
-	unsigned long flags;
-	int rc;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_DROP("Dropping - RF KILL\n");
-		goto drop_unlock;
-	}
-
-	if (!priv->vif) {
-		IWL_DEBUG_DROP("Dropping - !priv->vif\n");
-		goto drop_unlock;
-	}
-
-	if ((ctl->tx_rate->hw_value & 0xFF) == IWL_INVALID_RATE) {
-		IWL_ERROR("ERROR: No TX rate available.\n");
-		goto drop_unlock;
-	}
-
-	unicast = !is_multicast_ether_addr(hdr->addr1);
-	id = 0;
-
-	fc = le16_to_cpu(hdr->frame_control);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (ieee80211_is_auth(fc))
-		IWL_DEBUG_TX("Sending AUTH frame\n");
-	else if (ieee80211_is_assoc_request(fc))
-		IWL_DEBUG_TX("Sending ASSOC frame\n");
-	else if (ieee80211_is_reassoc_request(fc))
-		IWL_DEBUG_TX("Sending REASSOC frame\n");
-#endif
-
-	/* drop all data frame if we are not associated */
-	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-	   (!iwl_is_associated(priv) ||
-	    ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id) ||
-	    !priv->assoc_station_added)) {
-		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
-		goto drop_unlock;
-	}
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	hdr_len = ieee80211_get_hdrlen(fc);
-
-	/* Find (or create) index into station table for destination station */
-	sta_id = iwl_get_sta_id(priv, hdr);
-	if (sta_id == IWL_INVALID_STATION) {
-		DECLARE_MAC_BUF(mac);
-
-		IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
-			       print_mac(mac, hdr->addr1));
-		goto drop;
-	}
-
-	IWL_DEBUG_TX("station Id %d\n", sta_id);
-
-	if (ieee80211_is_qos_data(fc)) {
-		qc = ieee80211_get_qos_ctrl(hdr, hdr_len);
-		tid = qc[0] & 0xf;
-		seq_number = priv->stations[sta_id].tid[tid].seq_number &
-				IEEE80211_SCTL_SEQ;
-		hdr->seq_ctrl = cpu_to_le16(seq_number) |
-			(hdr->seq_ctrl &
-				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
-		seq_number += 0x10;
-#ifdef CONFIG_IWL4965_HT
-		/* aggregation is on for this <sta,tid> */
-		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
-			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
-		priv->stations[sta_id].tid[tid].tfds_in_queue++;
-#endif /* CONFIG_IWL4965_HT */
-	}
-
-	/* Descriptor for chosen Tx queue */
-	txq = &priv->txq[txq_id];
-	q = &txq->q;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* Set up first empty TFD within this queue's circular TFD buffer */
-	tfd = &txq->bd[q->write_ptr];
-	memset(tfd, 0, sizeof(*tfd));
-	control_flags = (u32 *) tfd;
-	idx = get_cmd_index(q, q->write_ptr, 0);
-
-	/* Set up driver data for this TFD */
-	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
-	txq->txb[q->write_ptr].skb[0] = skb;
-	memcpy(&(txq->txb[q->write_ptr].status.control),
-	       ctl, sizeof(struct ieee80211_tx_control));
-
-	/* Set up first empty entry in queue's array of Tx/cmd buffers */
-	out_cmd = &txq->cmd[idx];
-	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
-	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
-
-	/*
-	 * Set up the Tx-command (not MAC!) header.
-	 * Store the chosen Tx queue and TFD index within the sequence field;
-	 * after Tx, uCode's Tx response will return this value so driver can
-	 * locate the frame within the tx queue and do post-tx processing.
-	 */
-	out_cmd->hdr.cmd = REPLY_TX;
-	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->write_ptr)));
-
-	/* Copy MAC header from skb into command buffer */
-	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
-
-	/*
-	 * Use the first empty entry in this queue's command buffer array
-	 * to contain the Tx command and MAC header concatenated together
-	 * (payload data will be in another buffer).
-	 * Size of this varies, due to varying MAC header length.
-	 * If end is not dword aligned, we'll have 2 extra bytes at the end
-	 * of the MAC header (device reads on dword boundaries).
-	 * We'll tell device about this padding later.
-	 */
-	len = sizeof(struct iwl_tx_cmd) +
-		sizeof(struct iwl_cmd_header) + hdr_len;
-
-	len_org = len;
-	len = (len + 3) & ~3;
-
-	if (len_org != len)
-		len_org = 1;
-	else
-		len_org = 0;
-
-	/* Physical address of this Tx command's header (not MAC header!),
-	 * within command buffer array. */
-	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
-		     offsetof(struct iwl_cmd, hdr);
-
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	iwl4965_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
-
-	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
-		iwl4965_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, sta_id);
-
-	/* Set up TFD's 2nd entry to point directly to remainder of skb,
-	 * if any (802.11 null frames have no payload). */
-	len = skb->len - hdr_len;
-	if (len) {
-		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
-					   len, PCI_DMA_TODEVICE);
-		iwl4965_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
-	}
-
-	/* Tell 4965 about any 2-byte padding after MAC header */
-	if (len_org)
-		out_cmd->cmd.tx.tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
-
-	/* Total # bytes to be transmitted */
-	len = (u16)skb->len;
-	out_cmd->cmd.tx.len = cpu_to_le16(len);
-
-	/* TODO need this for burst mode later on */
-	iwl4965_build_tx_cmd_basic(priv, out_cmd, ctl, hdr, unicast, sta_id);
-
-	/* set is_hcca to 0; it probably will never be implemented */
-	iwl4965_hw_build_tx_cmd_rate(priv, out_cmd, ctl, hdr, sta_id, 0);
-
-	iwl_update_tx_stats(priv, fc, len);
-
-	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
-		offsetof(struct iwl_tx_cmd, scratch);
-	out_cmd->cmd.tx.dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	out_cmd->cmd.tx.dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
-
-	if (!ieee80211_get_morefrag(hdr)) {
-		txq->need_update = 1;
-		if (qc)
-			priv->stations[sta_id].tid[tid].seq_number = seq_number;
-	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
-	}
-
-	iwl_print_hex_dump(priv, IWL_DL_TX, out_cmd->cmd.payload,
-			   sizeof(out_cmd->cmd.tx));
-
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
-			   ieee80211_get_hdrlen(fc));
-
-	/* Set up entry for this TFD in Tx byte-count array */
-	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, len);
-
-	/* Tell device the write index *just past* this latest filled TFD */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	rc = iwl_txq_update_write_ptr(priv, txq);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (rc)
-		return rc;
-
-	if ((iwl_queue_space(q) < q->high_mark)
-	    && priv->mac80211_registered) {
-		if (wait_write_ptr) {
-			spin_lock_irqsave(&priv->lock, flags);
-			txq->need_update = 1;
-			iwl_txq_update_write_ptr(priv, txq);
-			spin_unlock_irqrestore(&priv->lock, flags);
-		}
-
-		ieee80211_stop_queue(priv->hw, ctl->queue);
-	}
-
-	return 0;
-
-drop_unlock:
-	spin_unlock_irqrestore(&priv->lock, flags);
-drop:
-	return -1;
-}
-
 static void iwl4965_set_rate(struct iwl_priv *priv)
 {
 	const struct ieee80211_supported_band *hw = NULL;
@@ -3101,52 +2568,6 @@ int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm)
 	return sig_qual;
 }
 
-/**
- * iwl_txq_update_write_ptr - Send new write index to hardware
- */
-static int iwl_txq_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl_tx_queue *txq)
-{
-	u32 reg = 0;
-	int ret = 0;
-	int txq_id = txq->q.id;
-
-	if (txq->need_update == 0)
-		return ret;
-
-	/* if we're trying to save power */
-	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-		/* wake up nic if it's powered down ...
-		 * uCode will wake up, and interrupt us again, so next
-		 * time we'll skip this part. */
-		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
-
-		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			IWL_DEBUG_INFO("Requesting wakeup, GP1 = 0x%x\n", reg);
-			iwl_set_bit(priv, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			return ret;
-		}
-
-		/* restore this queue's parameters in nic hardware. */
-		ret = iwl_grab_nic_access(priv);
-		if (ret)
-			return ret;
-		iwl_write_direct32(priv, HBUS_TARG_WRPTR,
-				     txq->q.write_ptr | (txq_id << 8));
-		iwl_release_nic_access(priv);
-
-	/* else not in power-save mode, uCode will never sleep when we're
-	 * trying to tx (during RFKILL, we're not trying to tx). */
-	} else
-		iwl_write32(priv, HBUS_TARG_WRPTR,
-			    txq->q.write_ptr | (txq_id << 8));
-
-	txq->need_update = 0;
-
-	return ret;
-}
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 static void iwl4965_print_rx_config_cmd(struct iwl_priv *priv)
 {
@@ -4956,7 +4377,7 @@ static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ctl->tx_rate->bitrate);
 
-	if (iwl4965_tx_skb(priv, skb, ctl))
+	if (iwl_tx_skb(priv, skb, ctl))
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MAC80211("leave\n");
-- 
1.5.3.6

