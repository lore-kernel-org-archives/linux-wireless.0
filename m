Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1HZGxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 52/60] iwlagn: move the mapping ac to queue / fifo to transport
Date: Thu, 25 Aug 2011 23:11:24 -0700
Message-Id: <1314339092-20797-53-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085400_606970_208732B3)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This mapping is transport related.
This allows us to remove the notion of tx queue from the tx path in
the upper layer.
iwl_wake_any_queue moved to transport layer since it needs to access
these mappings.
The TX API is nicer now:

int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
		struct iwl_device_cmd *dev_cmd, u8 ctx, u8 sta_id);

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   53 +-----
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   23 --
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   11 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h        |   13 --
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   14 ++
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  223 +++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   19 ++-
 10 files changed, 201 insertions(+), 168 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 7ce56ff..b4d7460 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -835,7 +835,8 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			 */
 			if (ctx->last_tx_rejected) {
 				ctx->last_tx_rejected = false;
-				iwl_wake_any_queue(priv, ctx);
+				iwl_trans_wake_any_queue(trans(priv),
+							 ctx->ctxid);
 			}
 			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index bf66575..7da65a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -278,14 +278,11 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_device_cmd *dev_cmd = NULL;
 	struct iwl_tx_cmd *tx_cmd;
-	int txq_id;
 
-	u16 seq_number = 0;
 	__le16 fc;
 	u8 hdr_len;
 	u16 len;
 	u8 sta_id;
-	u8 tid = 0;
 	unsigned long flags;
 	bool is_agg = false;
 
@@ -343,50 +340,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		iwl_sta_modify_sleep_tx_count(priv, sta_id, 1);
 	}
 
-	/*
-	 * Send this frame after DTIM -- there's a special queue
-	 * reserved for this for contexts that support AP mode.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
-		txq_id = ctx->mcast_queue;
-		/*
-		 * The microcode will clear the more data
-		 * bit in the last frame it transmits.
-		 */
-		hdr->frame_control |=
-			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-	} else if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
-		txq_id = IWL_AUX_QUEUE;
-	else
-		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
-
 	/* irqs already disabled/saved above when locking priv->shrd->lock */
 	spin_lock(&priv->shrd->sta_lock);
 
-	if (ieee80211_is_data_qos(fc)) {
-		u8 *qc = NULL;
-		struct iwl_tid_data *tid_data;
-		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-		tid_data = &priv->shrd->tid_data[sta_id][tid];
-
-		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
-			goto drop_unlock_sta;
-
-		seq_number = tid_data->seq_number;
-		seq_number &= IEEE80211_SCTL_SEQ;
-		hdr->seq_ctrl = hdr->seq_ctrl &
-				cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(seq_number);
-		seq_number += 0x10;
-		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
-		    tid_data->agg.state == IWL_AGG_ON) {
-			txq_id = tid_data->agg.txq_id;
-			is_agg = true;
-		}
-	}
-
 	dev_cmd = kmem_cache_alloc(priv->tx_cmd_pool, GFP_ATOMIC);
 
 	if (unlikely(!dev_cmd))
@@ -416,16 +372,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	info->driver_data[0] = ctx;
 	info->driver_data[1] = dev_cmd;
 
-	if (iwl_trans_tx(trans(priv), skb, dev_cmd, txq_id, fc, is_agg))
+	if (iwl_trans_tx(trans(priv), skb, dev_cmd, ctx->ctxid, sta_id))
 		goto drop_unlock_sta;
 
-	if (ieee80211_is_data_qos(fc)) {
-		priv->shrd->tid_data[sta_id][tid].tfds_in_queue++;
-		if (!ieee80211_has_morefrags(fc))
-			priv->shrd->tid_data[sta_id][tid].seq_number =
-				seq_number;
-	}
-
 	spin_unlock(&priv->shrd->sta_lock);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cfb4a4a..60b964b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -617,24 +617,6 @@ static int iwl_alloc_fw_desc(struct iwl_priv *priv, struct fw_desc *desc,
 
 static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 {
-	static const u8 iwlagn_bss_ac_to_fifo[] = {
-		IWL_TX_FIFO_VO,
-		IWL_TX_FIFO_VI,
-		IWL_TX_FIFO_BE,
-		IWL_TX_FIFO_BK,
-	};
-	static const u8 iwlagn_bss_ac_to_queue[] = {
-		0, 1, 2, 3,
-	};
-	static const u8 iwlagn_pan_ac_to_fifo[] = {
-		IWL_TX_FIFO_VO_IPAN,
-		IWL_TX_FIFO_VI_IPAN,
-		IWL_TX_FIFO_BE_IPAN,
-		IWL_TX_FIFO_BK_IPAN,
-	};
-	static const u8 iwlagn_pan_ac_to_queue[] = {
-		7, 6, 5, 4,
-	};
 	int i;
 
 	/*
@@ -656,8 +638,6 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
 	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
 	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
-	priv->contexts[IWL_RXON_CTX_BSS].ac_to_fifo = iwlagn_bss_ac_to_fifo;
-	priv->contexts[IWL_RXON_CTX_BSS].ac_to_queue = iwlagn_bss_ac_to_queue;
 	priv->contexts[IWL_RXON_CTX_BSS].exclusive_interface_modes =
 		BIT(NL80211_IFTYPE_ADHOC);
 	priv->contexts[IWL_RXON_CTX_BSS].interface_modes =
@@ -677,9 +657,6 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	priv->contexts[IWL_RXON_CTX_PAN].wep_key_cmd = REPLY_WIPAN_WEPKEY;
 	priv->contexts[IWL_RXON_CTX_PAN].bcast_sta_id = IWLAGN_PAN_BCAST_ID;
 	priv->contexts[IWL_RXON_CTX_PAN].station_flags = STA_FLG_PAN_STATION;
-	priv->contexts[IWL_RXON_CTX_PAN].ac_to_fifo = iwlagn_pan_ac_to_fifo;
-	priv->contexts[IWL_RXON_CTX_PAN].ac_to_queue = iwlagn_pan_ac_to_queue;
-	priv->contexts[IWL_RXON_CTX_PAN].mcast_queue = IWL_IPAN_MCAST_QUEUE;
 	priv->contexts[IWL_RXON_CTX_PAN].interface_modes =
 		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 977015b..2e75429 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -244,13 +244,6 @@ struct iwl_channel_info {
 #define IWL_DEFAULT_CMD_QUEUE_NUM	4
 #define IWL_IPAN_CMD_QUEUE_NUM		9
 
-/*
- * This queue number is required for proper operation
- * because the ucode will stop/start the scheduler as
- * required.
- */
-#define IWL_IPAN_MCAST_QUEUE		8
-
 #define IEEE80211_DATA_LEN              2304
 #define IEEE80211_4ADDR_LEN             30
 #define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
@@ -965,10 +958,6 @@ struct iwl_notification_wait {
 struct iwl_rxon_context {
 	struct ieee80211_vif *vif;
 
-	const u8 *ac_to_fifo;
-	const u8 *ac_to_queue;
-	u8 mcast_queue;
-
 	/*
 	 * We could use the vif to indicate active, but we
 	 * also need it to be active during disabling when
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 8ca624d..7f92d14 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -113,19 +113,6 @@ static inline void iwl_stop_queue(struct iwl_priv *priv,
 			ieee80211_stop_queue(priv->hw, ac);
 }
 
-static inline void iwl_wake_any_queue(struct iwl_priv *priv,
-				      struct iwl_rxon_context *ctx)
-{
-	u8 ac;
-
-	for (ac = 0; ac < AC_NUM; ac++) {
-		IWL_DEBUG_INFO(priv, "Queue Status: Q[%d] %s\n",
-			ac, (atomic_read(&priv->queue_stop_count[ac]) > 0)
-			      ? "stopped" : "awake");
-		iwl_wake_queue(priv, &priv->txq[ctx->ac_to_queue[ac]]);
-	}
-}
-
 #ifdef ieee80211_stop_queue
 #undef ieee80211_stop_queue
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 2c6659c..8572548 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -699,7 +699,7 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 					       ctx->active.bssid_addr))
 				continue;
 			ctx->last_tx_rejected = false;
-			iwl_wake_any_queue(priv, ctx);
+			iwl_trans_wake_any_queue(trans(priv), ctx->ctxid);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index f443c10..d73ebef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -107,6 +107,13 @@ struct iwl_dma_ptr {
 	size_t size;
 };
 
+/*
+ * This queue number is required for proper operation
+ * because the ucode will stop/start the scheduler as
+ * required.
+ */
+#define IWL_IPAN_MCAST_QUEUE		8
+
 /**
  * struct iwl_trans_pcie - PCIe transport specific data
  * @rxq: all the RX queue data
@@ -115,6 +122,9 @@ struct iwl_dma_ptr {
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
  * @kw: keep warm address
+ * @ac_to_fifo: to what fifo is a specifc AC mapped ?
+ * @ac_to_queue: to what tx queue  is a specifc AC mapped ?
+ * @mcast_queue:
  */
 struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
@@ -136,6 +146,10 @@ struct iwl_trans_pcie {
 	u32 scd_base_addr;
 	struct iwl_dma_ptr scd_bc_tbls;
 	struct iwl_dma_ptr kw;
+
+	const u8 *ac_to_fifo[NUM_IWL_RXON_CTX];
+	const u8 *ac_to_queue[NUM_IWL_RXON_CTX];
+	u8 mcast_queue[NUM_IWL_RXON_CTX];
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 31adf99..aa67f9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -424,10 +424,12 @@ void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
 }
 
-static inline int get_fifo_from_tid(struct iwl_rxon_context *ctx, u16 tid)
+static inline int get_fifo_from_tid(struct iwl_trans_pcie *trans_pcie,
+				    u8 ctx, u16 tid)
 {
+	const u8 *ac_to_fifo = trans_pcie->ac_to_fifo[ctx];
 	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return ctx->ac_to_fifo[tid_to_ac[tid]];
+		return ac_to_fifo[tid_to_ac[tid]];
 
 	/* no support for TIDs 8-15 yet */
 	return -EINVAL;
@@ -451,7 +453,7 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
 	if (WARN_ON(tid >= IWL_MAX_TID_COUNT))
 		return;
 
-	tx_fifo = get_fifo_from_tid(&priv->contexts[ctx], tid);
+	tx_fifo = get_fifo_from_tid(trans_pcie, ctx, tid);
 	if (WARN_ON(tx_fifo < 0)) {
 		IWL_ERR(trans, "txq_agg_setup, bad fifo: %d\n", tx_fifo);
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 7de042c..133b227 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -714,12 +714,75 @@ static int iwl_trans_pcie_prepare_card_hw(struct iwl_trans *trans)
 	return ret;
 }
 
+#define IWL_AC_UNSET -1
+
+struct queue_to_fifo_ac {
+	s8 fifo, ac;
+};
+
+static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
+	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
+	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+};
+
+static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
+	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
+	{ IWL_TX_FIFO_BK_IPAN, IEEE80211_AC_BK, },
+	{ IWL_TX_FIFO_BE_IPAN, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_VI_IPAN, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_VO_IPAN, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_BE_IPAN, 2, },
+	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_AUX, IWL_AC_UNSET, },
+};
+
+static const u8 iwlagn_bss_ac_to_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+};
+static const u8 iwlagn_bss_ac_to_queue[] = {
+	0, 1, 2, 3,
+};
+static const u8 iwlagn_pan_ac_to_fifo[] = {
+	IWL_TX_FIFO_VO_IPAN,
+	IWL_TX_FIFO_VI_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
+	IWL_TX_FIFO_BK_IPAN,
+};
+static const u8 iwlagn_pan_ac_to_queue[] = {
+	7, 6, 5, 4,
+};
+
 static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 {
 	int ret;
 	struct iwl_priv *priv = priv(trans);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	priv->shrd->ucode_owner = IWL_OWNERSHIP_DRIVER;
+	trans_pcie->ac_to_queue[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_queue;
+	trans_pcie->ac_to_queue[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_queue;
+
+	trans_pcie->ac_to_fifo[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_fifo;
+	trans_pcie->ac_to_fifo[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_fifo;
+
+	trans_pcie->mcast_queue[IWL_RXON_CTX_BSS] = 0;
+	trans_pcie->mcast_queue[IWL_RXON_CTX_PAN] = IWL_IPAN_MCAST_QUEUE;
 
 	if ((hw_params(priv).sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
 	     iwl_trans_pcie_prepare_card_hw(trans)) {
@@ -773,39 +836,6 @@ static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 	iwl_write_prph(bus(trans), SCD_TXFACT, mask);
 }
 
-#define IWL_AC_UNSET -1
-
-struct queue_to_fifo_ac {
-	s8 fifo, ac;
-};
-
-static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
-	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-};
-
-static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
-	{ IWL_TX_FIFO_BK_IPAN, IEEE80211_AC_BK, },
-	{ IWL_TX_FIFO_BE_IPAN, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_VI_IPAN, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_VO_IPAN, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_BE_IPAN, 2, },
-	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_AUX, IWL_AC_UNSET, },
-};
 static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 {
 	const struct queue_to_fifo_ac *queue_to_fifo;
@@ -1012,22 +1042,75 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	iwl_apm_stop(priv(trans));
 }
 
-static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd, int txq_id,
-		__le16 fc, bool ampdu)
+static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
+		struct iwl_device_cmd *dev_cmd, u8 ctx, u8 sta_id)
 {
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_tx_cmd *tx_cmd = &dev_cmd->cmd.tx;
 	struct iwl_cmd_meta *out_meta;
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
 
 	dma_addr_t phys_addr = 0;
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
 	u16 len, firstlen, secondlen;
+	u16 seq_number = 0;
 	u8 wait_write_ptr = 0;
+	u8 txq_id;
+	u8 tid = 0;
+	bool is_agg = false;
+	__le16 fc = hdr->frame_control;
 	u8 hdr_len = ieee80211_hdrlen(fc);
 
+	/*
+	 * Send this frame after DTIM -- there's a special queue
+	 * reserved for this for contexts that support AP mode.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
+		txq_id = trans_pcie->mcast_queue[ctx];
+
+		/*
+		 * The microcode will clear the more data
+		 * bit in the last frame it transmits.
+		 */
+		hdr->frame_control |=
+			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	} else if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+		txq_id = IWL_AUX_QUEUE;
+	else
+		txq_id =
+		    trans_pcie->ac_to_queue[ctx][skb_get_queue_mapping(skb)];
+
+	if (ieee80211_is_data_qos(fc)) {
+		u8 *qc = NULL;
+		struct iwl_tid_data *tid_data;
+		qc = ieee80211_get_qos_ctl(hdr);
+		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+		tid_data = &trans->shrd->tid_data[sta_id][tid];
+
+		if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
+			return -1;
+
+		seq_number = tid_data->seq_number;
+		seq_number &= IEEE80211_SCTL_SEQ;
+		hdr->seq_ctrl = hdr->seq_ctrl &
+				cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(seq_number);
+		seq_number += 0x10;
+		/* aggregation is on for this <sta,tid> */
+		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
+		    tid_data->agg.state == IWL_AGG_ON) {
+			txq_id = tid_data->agg.txq_id;
+			is_agg = true;
+		}
+	}
+
+	txq = &priv(trans)->txq[txq_id];
+	q = &txq->q;
+
 	/* Set up driver data for this TFD */
 	txq->skbs[q->write_ptr] = skb;
 	txq->cmd[q->write_ptr] = dev_cmd;
@@ -1058,10 +1141,10 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = dma_map_single(priv->bus->dev,
+	txcmd_phys = dma_map_single(bus(trans)->dev,
 				    &dev_cmd->hdr, firstlen,
 				    DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(priv->bus->dev, txcmd_phys)))
+	if (unlikely(dma_mapping_error(bus(trans)->dev, txcmd_phys)))
 		return -1;
 	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
 	dma_unmap_len_set(out_meta, len, firstlen);
@@ -1077,10 +1160,10 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	 * if any (802.11 null frames have no payload). */
 	secondlen = skb->len - hdr_len;
 	if (secondlen > 0) {
-		phys_addr = dma_map_single(priv->bus->dev, skb->data + hdr_len,
+		phys_addr = dma_map_single(bus(trans)->dev, skb->data + hdr_len,
 					   secondlen, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(priv->bus->dev, phys_addr))) {
-			dma_unmap_single(priv->bus->dev,
+		if (unlikely(dma_mapping_error(bus(trans)->dev, phys_addr))) {
+			dma_unmap_single(bus(trans)->dev,
 					 dma_unmap_addr(out_meta, mapping),
 					 dma_unmap_len(out_meta, len),
 					 DMA_BIDIRECTIONAL);
@@ -1089,36 +1172,35 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	}
 
 	/* Attach buffers to TFD */
-	iwlagn_txq_attach_buf_to_tfd(trans(priv), txq, txcmd_phys,
-					firstlen, 1);
+	iwlagn_txq_attach_buf_to_tfd(trans, txq, txcmd_phys, firstlen, 1);
 	if (secondlen > 0)
-		iwlagn_txq_attach_buf_to_tfd(trans(priv), txq, phys_addr,
+		iwlagn_txq_attach_buf_to_tfd(trans, txq, phys_addr,
 					     secondlen, 0);
 
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 				offsetof(struct iwl_tx_cmd, scratch);
 
 	/* take back ownership of DMA buffer to enable update */
-	dma_sync_single_for_cpu(priv->bus->dev, txcmd_phys, firstlen,
+	dma_sync_single_for_cpu(bus(trans)->dev, txcmd_phys, firstlen,
 			DMA_BIDIRECTIONAL);
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
 
-	IWL_DEBUG_TX(priv, "sequence nr = 0X%x\n",
+	IWL_DEBUG_TX(trans, "sequence nr = 0X%x\n",
 		     le16_to_cpu(dev_cmd->hdr.sequence));
-	IWL_DEBUG_TX(priv, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
+	IWL_DEBUG_TX(trans, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
+	iwl_print_hex_dump(trans, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
+	iwl_print_hex_dump(trans, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
-	if (ampdu)
-		iwl_trans_txq_update_byte_cnt_tbl(trans(priv), txq,
+	if (is_agg)
+		iwl_trans_txq_update_byte_cnt_tbl(trans, txq,
 					       le16_to_cpu(tx_cmd->len));
 
-	dma_sync_single_for_device(priv->bus->dev, txcmd_phys, firstlen,
+	dma_sync_single_for_device(bus(trans)->dev, txcmd_phys, firstlen,
 			DMA_BIDIRECTIONAL);
 
-	trace_iwlwifi_dev_tx(priv,
+	trace_iwlwifi_dev_tx(priv(trans),
 			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
 			     sizeof(struct iwl_tfd),
 			     &dev_cmd->hdr, firstlen,
@@ -1126,7 +1208,14 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	iwl_txq_update_write_ptr(trans(priv), txq);
+	iwl_txq_update_write_ptr(trans, txq);
+
+	if (ieee80211_is_data_qos(fc)) {
+		trans->shrd->tid_data[sta_id][tid].tfds_in_queue++;
+		if (!ieee80211_has_morefrags(fc))
+			trans->shrd->tid_data[sta_id][tid].seq_number =
+				seq_number;
+	}
 
 	/*
 	 * At this point the frame is "transmitted" successfully
@@ -1137,9 +1226,9 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	if (iwl_queue_space(q) < q->high_mark) {
 		if (wait_write_ptr) {
 			txq->need_update = 1;
-			iwl_txq_update_write_ptr(trans(priv), txq);
+			iwl_txq_update_write_ptr(trans, txq);
 		} else {
-			iwl_stop_queue(priv, txq);
+			iwl_stop_queue(priv(trans), txq);
 		}
 	}
 	return 0;
@@ -1262,6 +1351,23 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 
 #endif /* CONFIG_PM */
 
+static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
+					  u8 ctx)
+{
+	u8 ac, txq_id;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	for (ac = 0; ac < AC_NUM; ac++) {
+		txq_id = trans_pcie->ac_to_queue[ctx][ac];
+		IWL_DEBUG_INFO(trans, "Queue Status: Q[%d] %s\n",
+			ac,
+			(atomic_read(&priv(trans)->queue_stop_count[ac]) > 0)
+			      ? "stopped" : "awake");
+		iwl_wake_queue(priv(trans), &priv(trans)->txq[txq_id]);
+	}
+}
+
 const struct iwl_trans_ops trans_ops_pcie;
 
 static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
@@ -1842,6 +1948,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.stop_device = iwl_trans_pcie_stop_device,
 
 	.tx_start = iwl_trans_pcie_tx_start,
+	.wake_any_queue = iwl_trans_pcie_wake_any_queue,
 
 	.send_cmd = iwl_trans_pcie_send_cmd,
 	.send_cmd_pdu = iwl_trans_pcie_send_cmd_pdu,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0691d39..0fee884 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -88,6 +88,7 @@ struct iwl_device_cmd;
  *                   probe.
  * @tx_start: starts and configures all the Tx fifo - usually done once the fw
  *           is alive.
+ * @wake_any_queue: wake all the queues of a specfic context IWL_RXON_CTX_*
  * @stop_device:stops the whole device (embedded CPU put to reset)
  * @send_cmd:send a host command
  * @send_cmd_pdu:send a host command: flags can be CMD_*
@@ -113,13 +114,14 @@ struct iwl_trans_ops {
 	void (*stop_device)(struct iwl_trans *trans);
 	void (*tx_start)(struct iwl_trans *trans);
 
+	void (*wake_any_queue)(struct iwl_trans *trans, u8 ctx);
+
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
 	int (*send_cmd_pdu)(struct iwl_trans *trans, u8 id, u32 flags, u16 len,
 		     const void *data);
-	int (*tx)(struct iwl_priv *priv, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd,
-		int txq_id, __le16 fc, bool ampdu);
+	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
+		struct iwl_device_cmd *dev_cmd, u8 ctx, u8 sta_id);
 	void (*reclaim)(struct iwl_trans *trans, int txq_id, int ssn,
 			u32 status, struct sk_buff_head *skbs);
 
@@ -178,6 +180,12 @@ static inline void iwl_trans_tx_start(struct iwl_trans *trans)
 	trans->ops->tx_start(trans);
 }
 
+static inline void iwl_trans_wake_any_queue(struct iwl_trans *trans, u8 ctx)
+{
+	trans->ops->wake_any_queue(trans, ctx);
+}
+
+
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				struct iwl_host_cmd *cmd)
 {
@@ -191,10 +199,9 @@ static inline int iwl_trans_send_cmd_pdu(struct iwl_trans *trans, u8 id,
 }
 
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd,
-		int txq_id, __le16 fc, bool ampdu)
+		struct iwl_device_cmd *dev_cmd, u8 ctx, u8 sta_id)
 {
-	return trans->ops->tx(priv(trans), skb, dev_cmd, txq_id, fc, ampdu);
+	return trans->ops->tx(trans, skb, dev_cmd, ctx, sta_id);
 }
 
 static inline void iwl_trans_reclaim(struct iwl_trans *trans, int txq_id,
-- 
1.7.0.4

